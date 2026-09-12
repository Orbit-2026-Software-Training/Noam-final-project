import 'dart:io';
import 'package:http/http.dart' as http;

void main() async {
  String NCtemp = "";
  String NCtime = "";
  File file = File('readings.json');
  String contents = file.readAsStringSync();
  List<String> list = contents.split(",");
  List<String> list2 = [];
  List<String> jokesList = [];
  List<String> list3 = [];
  List<String> list4 = [];
  String cleantime = "";
  String cleantemp = "";

  for (int i = 0; i < list.length; i += 2) {
    NCtime = list[i];
    NCtemp = list[i + 1];
    list3 = [];
    list4 = [];

    // ניקוי טמפרטורה
    for (int j = 0; j < NCtemp.length; j++) {
      int unitemp = NCtemp.codeUnitAt(j);
      if ((unitemp >= 48 && unitemp <= 57) || unitemp == 45 || unitemp == 46) {
        list3.add(NCtemp[j]);
      }
    }
    cleantemp = list3.join();

    // ניקוי זמן
    for (int j = 0; j < NCtime.length; j++) {
      int unitTime = NCtime.codeUnitAt(j);
      if ((unitTime >= 48 && unitTime <= 57) ||
          (unitTime >= 97 && unitTime <= 122) ||
          (unitTime <= 90 && unitTime >= 65) ||
          unitTime == 58 ||
          unitTime == 45) {
        list4.add(NCtime[j]);
      }
    }
    cleantime = list4.join();

    if (cleantime.isNotEmpty && cleantime[0] == ":") {
      cleantime = cleantime.substring(1);
    }

    if (cleantemp.isNotEmpty) {
      list2.add(cleantemp);
    }
  }

  Future<void> apiReading() async {
    for (int i = 0; i < 10; i++) {
      var url = Uri.parse(
        'https://v2.jokeapi.dev/joke/Misc,Programming?format=xml&safe-mode&type=single',
      );
      var response = await http.get(url);
      String urlAsString = response.body.toString();
      String cleanUrl = urlAsString.replaceAll("</joke>", "<joke>");
      List<String> JokeList = cleanUrl.split("<joke>");
      if (JokeList.length > 1) {
        jokesList.add(JokeList[1]);
      }
    }
  }

  await apiReading();

  MaxTempLongestLetters(list2, jokesList);
  MinTempShortestLetters(list2, jokesList);
  averagetempAverageLetters(list2, jokesList);
  print("Temps above 25: ${tempAbove25(list2)}");
}

void MaxTempLongestLetters(List<String> list2, List<String> jokesList) {
  double currentMax = -100;
  int currentMaxLetters = 0;
  int maxJokeIndex = 0;

  for (int i = 0; i < list2.length; i++) {
    double tempVal = double.parse(list2[i]);
    if (tempVal > currentMax) {
      currentMax = tempVal;
    }
  }

  for (int i = 0; i < jokesList.length; i++) {
    String clearJoke = jokesList[i].replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    if (clearJoke.length > currentMaxLetters) {
      maxJokeIndex = i;
      currentMaxLetters = clearJoke.length;
    }
  }

  if (jokesList.isNotEmpty) {
    print(
      "Joke with the most letters: ${jokesList[maxJokeIndex]} with $currentMaxLetters letters",
    );
  }
  print("Max temperature: $currentMax");
}

void MinTempShortestLetters(List<String> list2, List<String> jokesList) {
  double currentMin = 1000;
  int currentMinLetters = 1000;
  int minJokeIndex = 0;

  for (int i = 0; i < list2.length; i++) {
    double tempVal = double.parse(list2[i]);
    if (tempVal < currentMin) {
      currentMin = tempVal;
    }
  }

  for (int i = 0; i < jokesList.length; i++) {
    String clearJoke = jokesList[i].replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    if (clearJoke.length < currentMinLetters) {
      minJokeIndex = i;
      currentMinLetters = clearJoke.length;
    }
  }

  if (jokesList.isNotEmpty) {
    print(
      "Joke with the least letters: ${jokesList[minJokeIndex]} with $currentMinLetters letters",
    );
  }
  print("Min temperature: $currentMin");
}

void averagetempAverageLetters(List<String> list2, List<String> jokesList) {
  double sum = 0;
  for (int i = 0; i < list2.length; i++) {
    sum += double.parse(list2[i]);
  }
  double average = list2.isNotEmpty ? sum / list2.length : 0;
  print("Average temperature: $average");

  num lettersSum = 0;
  for (int i = 0; i < jokesList.length; i++) {
    String clearJoke = jokesList[i].replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    lettersSum += clearJoke.length;
  }

  double lettersAverage = jokesList.isNotEmpty
      ? lettersSum / jokesList.length
      : 0;
  bool foundExact = false;

  for (int i = 0; i < jokesList.length; i++) {
    String clearJoke = jokesList[i].replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    if (clearJoke.length == lettersAverage) {
      print(
        "Joke with the exact average letters: ${jokesList[i]} with ${clearJoke.length} letters",
      );
      foundExact = true;
      break;
    }
  }

  if (!foundExact) {
    print("there are no Joke with the exact average letters");
  }
}

int tempAbove25(List<String> list2) {
  int counter = 0;
  for (int i = 0; i < list2.length; i++) {
    double tempVal = double.parse(list2[i]);
    if (tempVal > 25) {
      counter++;
    }
  }

  return counter;
}
