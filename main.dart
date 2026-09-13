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
  List<String> cleanJokeLetters = [];
  for (int i = 0; i < list.length; i += 2) {
    NCtime = list[i];
    NCtemp = list[i + 1];
    list3 = [];
    list4 = [];
    for (int j = 0; j<NCtemp.length;j++){
      int unitemp=NCtemp.codeUnitAt(j);
      if (unitemp>=48 && unitemp<=57 || unitemp==45|| unitemp==46){
        list3.add(NCtemp[j]);
      }
    }
    cleantemp = list3.join();
    for (int j = 0; j<NCtime.length;j++){
      int unitTime=NCtime.codeUnitAt(j);
      if (unitTime>=48 && unitTime<=57 || unitTime>= 97 && unitTime<=122 || unitTime<=90&& unitTime>=65|| unitTime==58|| unitTime==45){
        list4.add(NCtime[j]);
      }
      cleantime = list4.join();
    }
    if (cleantime[0] == ":") {
      cleantime = cleantime.substring(1);
    }
    list2.add(cleantemp);
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
      jokesList.add(JokeList[1]);
    }
  }
  await apiReading();
  MaxTempLongestLetters(list2, jokesList,0,0,list,cleanJokeLetters);
  MinTempShortestLetters(list2, jokesList,0,0,list,cleanJokeLetters);
  averagetempAverageLetters(list2, jokesList,0,list);
  print(tempAbove25(list2,list));
  //print ( list2);
}

void MaxTempLongestLetters(List<String> list2, List<String> jokesList,j,jokeLength,Listt,List<String> cleanJokeLetters) {
  double CurrentMax = 0;
  int currentMaxLetters = 0;
  List<String> cleanJokes = [];
  String longestJoke = "";
  for (int i = 0; i < list2.length; i++) {
    if (Listt > CurrentMax) {
      CurrentMax = Listt;
    }
  }
  for (int i = 0; i < jokesList.length; i++) {
    cleanJokeLetters.clear();
    for (int j = 0; j < jokesList[i].length; j++) {
      int unitJokeLetter = jokesList[i].codeUnitAt(j);
      if (unitJokeLetter >= 48 &&
          unitJokeLetter <= 57 ||
          unitJokeLetter >= 97 &&
          unitJokeLetter <= 122 ||
          unitJokeLetter <= 90 && unitJokeLetter >= 65 ||
          unitJokeLetter == 58 ||
          unitJokeLetter == 45) {
        cleanJokeLetters.add(jokesList[i][j]);
      }
    }
    String clearJoke = cleanJokeLetters.join();
    cleanJokes.add(clearJoke);
    for (int j = 0; j < cleanJokes.length; j++) {
      if (cleanJokes[j].length > currentMaxLetters) {
        currentMaxLetters = cleanJokes[j].length;
        jokeLength = currentMaxLetters;
        longestJoke = cleanJokes[j];
      }
    }
  }
  print(
    "Joke with the most letters: ${longestJoke} with ${currentMaxLetters} letters",
  );
  print("Max temperature: ${CurrentMax}");
}

void MinTempShortestLetters(List<String> list2, List<String> jokesList,j,jokeLength,Listt,List<String> cleanJokeLetters) {
  double currentMin = 1000;
  int currentMinLetters = 1000;
  String shortestJoke = "";
  String clearJoke = "";
  List<String> cleanJokes = [];
  for (int i = 0; i < list2.length; i++) {
    if (Listt < currentMin) {
      currentMin = Listt;
    }
  }
  for (int i = 0; i < jokesList.length; i++) {
    cleanJokeLetters.clear();
    for (int j = 0; j < jokesList[i].length; j++) {
      int unitJokeLetter = jokesList[i].codeUnitAt(j);
      if (unitJokeLetter >= 48 &&
          unitJokeLetter <= 57 ||
          unitJokeLetter >= 97 &&
          unitJokeLetter <= 122 ||
          unitJokeLetter <= 90 && unitJokeLetter >= 65 ||
          unitJokeLetter == 58 ||
          unitJokeLetter == 45) {
        cleanJokeLetters.add(jokesList[i][j]);
      }
    }
    clearJoke = cleanJokeLetters.join();
    cleanJokes.add(clearJoke);
    }
    for (int j = 0; j < cleanJokes.length; j++) {
      if (cleanJokes[j].length < currentMinLetters) {
        shortestJoke = cleanJokes[j];
        currentMinLetters = shortestJoke.length;
      }
    }
  print(
    "Joke with the least letters: ${shortestJoke} with ${currentMinLetters} letters",
  );
  print("Min temperature: ${currentMin}");
}

void averagetempAverageLetters(List<String> list2, List<String> jokesList,jokeLength,Listt) {
  double sum = 0;
  num lettersSum = 0;
  int i = 0;
  String clearJoke = "";
  for (int i = 0; i < list2.length; i++) {
    sum = sum + Listt;
  }
  double average = sum / list2.length;
  print("Average temperature: ${average}");
  for (int i = 0; i < jokesList.length; i++) {
    List<String>cleanJokeLetters = [];
    for (int j = 0; j<jokesList[i].length;j++){
      int unitJokeLetter=jokesList[i].codeUnitAt(j);
      if (unitJokeLetter>=48 && unitJokeLetter<=57 || unitJokeLetter>= 97 && unitJokeLetter<=122 || unitJokeLetter<=90&& unitJokeLetter>=65|| unitJokeLetter==58|| unitJokeLetter==45){
        cleanJokeLetters.add(jokesList[i]);
      }
    }
    clearJoke = cleanJokeLetters.join();
    lettersSum = lettersSum + clearJoke.length;
  }
  for (i = 0; i < jokesList.length; i++) {
    jokeLength = clearJoke.length;
  }
  double lettersAverage = lettersSum / jokesList.length;
  if (jokeLength == lettersAverage) {
    print(
      "Joke with the exact average letters: ${jokesList[i]} with ${jokeLength} letters",
    );
  } else {
    print("there are no Joke with the exact average letters");
  }
}

int tempAbove25(List<String> list2,Listt) {
  int counter = 0;
  for (int i = 0; i < list2.length; i++) {
    if (Listt > 25) {
      counter++;
    }
  }
  return counter;
}