import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  //reading the json file and seperate the temp and the time to diffrent lists
  List<num> listForKeppingParamatersInStage5 = [];
  num counterStage5 = 0;
  File file = File('readings.json');
  String contents = file.readAsStringSync();
  List<dynamic> jsonFileList = jsonDecode(contents);
  List<String> timesList = [];
  List<double> list2 = [];
  List<String> jokesList = [];
  List<String> cleanJokeLetters = [];
  for (var item in jsonFileList) {
    timesList.add(item['time'].toString());
    double list = (item['temperature'] as num).toDouble();
    list2.add(list);
  }
  //reading the api and make a list with all the 10 jokes
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
  var (_, extremeMaxValueOfJoke, extremeMaxValueOfTemp) = MaxTempLongestLetters(
    list2,
    jokesList,
    cleanJokeLetters,
  );
  var (_, extremeMinValueOfJoke, extremeMinValueOfTemp) =
      MinTempShortestLetters(list2, jokesList, cleanJokeLetters);
  var (average, averageJoke) = averagetempAverageLetters(
    list2,
    jokesList,
    cleanJokeLetters,
  );
  //tempAbove25(list2);
  //sortTempsHighToLow(list2);
  num biggerPercentageErrorTemp = percentageErrorCalculator(
    extremeMaxValueOfTemp,
    extremeMinValueOfTemp,
    average,
    counterStage5,
    listForKeppingParamatersInStage5,
  );
  counterStage5 = 1;
  num biggerPercentageErrorJoke = percentageErrorCalculator(
    extremeMaxValueOfJoke,
    extremeMinValueOfJoke,
    averageJoke,
    counterStage5,
    listForKeppingParamatersInStage5,
  );
  if (biggerPercentageErrorJoke > biggerPercentageErrorTemp) {
    if (biggerPercentageErrorJoke == listForKeppingParamatersInStage5[2]) {
      print(
        "the minimum Percentage Error from joke is $biggerPercentageErrorJoke",
      );
    }
    if (biggerPercentageErrorJoke == listForKeppingParamatersInStage5[3])
      print(
        "the maximum Percentage Error from joke is  $biggerPercentageErrorJoke",
      );
  } else if (biggerPercentageErrorTemp == listForKeppingParamatersInStage5[0]) {
    print(
      "the minimum Percentage Error from temp is $biggerPercentageErrorTemp",
    );
  } else {
    print(
      "the maximum Percentage Error from temp is $biggerPercentageErrorTemp",
    );
  }
}

//a func that give me the counting of the letters
(List<String>, List<String>, int) countLetters(
  List<String> jokesList,
  List<String> cleanJokeLetters,
) {
  List<String> Joke = [];
  List<String> Jokes = [];
  List<String> cleanJokes = [];
  int lettersSum = 0;
  for (int i = 0; i < jokesList.length; i++) {
    cleanJokeLetters.clear();
    Joke.clear();
    for (int j = 0; j < jokesList[i].length; j++) {
      int unitJokeLetter = jokesList[i].codeUnitAt(j);
      if (unitJokeLetter >= 48 && unitJokeLetter <= 57 ||
          unitJokeLetter >= 97 && unitJokeLetter <= 122 ||
          unitJokeLetter <= 90 && unitJokeLetter >= 65 ||
          unitJokeLetter == 58 ||
          unitJokeLetter == 45) {
        cleanJokeLetters.add(jokesList[i][j]);
        Joke.add(jokesList[i][j]);
      } else {
        Joke.add(jokesList[i][j]);
      }
    }
    //updating 2 list one a joke with spaces for the print and one without for .length
    String clearJoke = cleanJokeLetters.join();
    cleanJokes.add(clearJoke);
    String jokeWithSpaces = Joke.join();
    Jokes.add(jokeWithSpaces);
    lettersSum = lettersSum + clearJoke.length;
  }
  return (Jokes, cleanJokes, lettersSum);
}

//function that doing the part of stage 1 of max temp and the part of stage 3 that give me the longest joke
(String, int, double) MaxTempLongestLetters(
  List<double> list2,
  List<String> jokesList,
  List<String> cleanJokeLetters,
) {
  double CurrentMax = 0;
  int currentMaxLetters = 0;
  String longestJoke = "";
  for (int i = 0; i < list2.length; i++) {
    if (list2[i] > CurrentMax) {
      CurrentMax = list2[i];
    }
  }
  List<String> listOfJokesWithOutSpaces = countLetters(
    jokesList,
    cleanJokeLetters,
  ).$2;
  List<String> listOfJokes = countLetters(jokesList, cleanJokeLetters).$1;
  for (int j = 0; j < listOfJokesWithOutSpaces.length; j++) {
    if (listOfJokesWithOutSpaces[j].length > currentMaxLetters) {
      currentMaxLetters = listOfJokesWithOutSpaces[j].length;
      longestJoke = listOfJokes[j];
    }
  }
  print(
    "Joke with the most letters: ${longestJoke} with ${currentMaxLetters} letters",
  );
  print("Max temperature: ${CurrentMax}");
  return (longestJoke, currentMaxLetters, CurrentMax);
}

//function that doing the part of stage 1 of min temp and the part of stage 3 that give me the shortest joke
(String, int, double) MinTempShortestLetters(
  List<double> list2,
  List<String> jokesList,
  List<String> cleanJokeLetters,
) {
  double currentMin = 1000;
  int currentMinLetters = 1000;
  String ShortestJoke = "";
  for (int i = 0; i < list2.length; i++) {
    if (list2[i] < currentMin) {
      currentMin = list2[i];
    }
  }
  List<String> listOfJokesWithOutSpaces = countLetters(
    jokesList,
    cleanJokeLetters,
  ).$2;
  List<String> listOfJokes = countLetters(jokesList, cleanJokeLetters).$1;
  for (int j = 0; j < listOfJokesWithOutSpaces.length; j++) {
    if (listOfJokesWithOutSpaces[j].length < currentMinLetters) {
      currentMinLetters = listOfJokesWithOutSpaces[j].length;
      ShortestJoke = listOfJokes[j];
    }
  }
  print(
    "Joke with the least letters: ${ShortestJoke} with ${currentMinLetters} letters",
  );
  print("Min temperature: ${currentMin}");
  return (ShortestJoke, currentMinLetters, currentMin);
}

//function that doing the part of stage 1 of avrage temp and the part of stage 3 that give me the avrage num of letters
(double, double) averagetempAverageLetters(
  List<double> list2,
  List<String> jokesList,
  List<String> cleanJokeLetters,
) {
  double sum = 0;
  num lettersSum = 0;
  bool check = false;
  for (int i = 0; i < list2.length; i++) {
    sum = sum + list2[i];
  }
  sum = sum / list2.length;
  print("Average temperature: ${sum}");
  List<String> listOfJokesWithOutSpaces = countLetters(
    jokesList,
    cleanJokeLetters,
  ).$2;
  List<String> listOfJokes = countLetters(jokesList, cleanJokeLetters).$1;
  lettersSum = countLetters(jokesList, cleanJokeLetters).$3;
  double lettersAverage = lettersSum / jokesList.length;
  for (int g = 0; g < listOfJokes.length; g++) {
    if (listOfJokesWithOutSpaces[g].length == lettersAverage) {
      print(
        "Joke with the exact average letters: ${listOfJokes[g]} with ${listOfJokesWithOutSpaces[g].length} letters",
      );
      check = true;
    }
  }
  if (check == false) {
    print("No joke with the exact average letters");
  }
  return (sum, lettersAverage);
}

//function that doing the stage 2 that counting how many times temp was over 25
void tempAbove25(List<double> list2) {
  int counter = 0;
  for (int i = 0; i < list2.length; i++) {
    if (list2[i] > 25) {
      counter++;
    }
  }
  print(counter);
}

//function that sorting all the temps from highest to lowest
void sortTempsHighToLow(List<double> list2) {
  List<double> listOfSortingTemps = [];
  List<double> listOfRawNumbers = list2.toList();
  while (listOfRawNumbers.isNotEmpty) {
    int index = 0;
    double currentMaxTemp = 0;
    for (int i = 0; i < listOfRawNumbers.length; i++) {
      if (listOfRawNumbers[i] >= currentMaxTemp) {
        currentMaxTemp = listOfRawNumbers[i];
        index = i;
      }
    }
    listOfSortingTemps.add(currentMaxTemp);
    listOfRawNumbers.removeAt(index);
  }
  print(listOfSortingTemps);
}

num percentageErrorCalculator(
  extremeMaxValue,
  extremeMinValue,
  average,
  counter,
  list,
) {
  num maxPercentageError = ((extremeMaxValue - average) / average) * 100;
  num minPercentageError = (((extremeMinValue - average) / average) * 100);
  list.add(minPercentageError);
  list.add(maxPercentageError);

  if (counter == 0) {
    print("the minimum Percentage Error from temp is $minPercentageError");
    print("the maximum Percentage Error from temp is $maxPercentageError");
  }
  if (counter == 1) {
    print("the minimum Percentage Error from joke is $minPercentageError");
    print("the maximum Percentage Error from joke is $maxPercentageError");
  }
  if (maxPercentageError > minPercentageError) {
    return maxPercentageError;
  } else if (maxPercentageError < minPercentageError) {
    return minPercentageError;
  } else {
    return 0;
  }
}
