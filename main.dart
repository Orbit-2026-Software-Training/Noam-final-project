  import 'dart:io';
  import 'package:http/http.dart' as http;
  import 'dart:convert';
  void main() async {
    //reading the json file and seperate the temp and the time to diffrent lists
    File file = File('readings.json');
    String contents = file.readAsStringSync();
    List<dynamic> jsonFileList = jsonDecode(contents);
    List<String> timesList = [];
    List<String> list2 = [];
    List<String> jokesList = [];
    List<String> cleanJokeLetters = [];
    for (var item in jsonFileList) {
    timesList.add(item['time'].toString());
    list2.add(item['temperature'].toString());
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
    MaxTempLongestLetters(list2, jokesList,  cleanJokeLetters);
    MinTempShortestLetters(list2, jokesList, cleanJokeLetters);
    averagetempAverageLetters(list2, jokesList, cleanJokeLetters);
    tempAbove25(list2);
    sortingJson(list2);
    
  }
  //a func that give me the counting of the letters
  (List<String>,List<String>,int) countLetters(List<String> jokesList, List<String> cleanJokeLetters) {
    List<String> Joke = [];
    List<String> Jokes = [];
    List<String> cleanJokes = [];
    int lettersSum= 0;
    for (int i = 0; i < jokesList.length; i++) {
      cleanJokeLetters.clear();
      Joke.clear();
      for (int j = 0; j < jokesList[i].length; j++) {
        int unitJokeLetter = jokesList[i].codeUnitAt(j);
        if (unitJokeLetter == 32) {
          Joke.add(jokesList[i][j]);
        }
        if (unitJokeLetter >= 48 && unitJokeLetter <= 57 ||
            unitJokeLetter >= 97 && unitJokeLetter <= 122 ||
            unitJokeLetter <= 90 && unitJokeLetter >= 65 ||
            unitJokeLetter == 58 ||
            unitJokeLetter == 45) {
          cleanJokeLetters.add(jokesList[i][j]);
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
  return (Jokes, cleanJokes,lettersSum);
  }
  //function that doing the part of stage 1 of max temp and the part of stage 3 that give me the longest joke
  void MaxTempLongestLetters(
    List<String> list2,
    List<String> jokesList,
    List<String> cleanJokeLetters,
  ) {
    double CurrentMax = 0;
    int currentMaxLetters = 0;
    String longestJoke = "";
    for (int i = 0; i < list2.length; i++) {
      double list = double.parse(list2[i]);
      if (list > CurrentMax) {
        CurrentMax = list;
      }
    }
    List<String>listOfJokesWithOutSpaces=countLetters(jokesList, cleanJokeLetters).$2;
    List<String>listOfJokes=countLetters(jokesList, cleanJokeLetters).$1;
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

  }
  //function that doing the part of stage 1 of min temp and the part of stage 3 that give me the shortest joke
  void MinTempShortestLetters(
    List<String> list2,
    List<String> jokesList,
    List<String> cleanJokeLetters,
  ) {
    double currentMin = 1000;
    int currentMinLetters = 1000;
    String ShortestJoke = "";
    for (int i = 0; i < list2.length; i++) {
      double list = double.parse(list2[i]);
      if (list < currentMin) {
        currentMin = list;
      }
    }
    
    List<String>listOfJokesWithOutSpaces=countLetters(jokesList, cleanJokeLetters).$2;
    List<String>listOfJokes=countLetters(jokesList, cleanJokeLetters).$1;
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
  }
  //function that doing the part of stage 1 of avrage temp and the part of stage 3 that give me the avrage num of letters
  void averagetempAverageLetters(
    List<String> list2,
    List<String> jokesList,
    List<String> cleanJokeLetters,
  ) {
    double sum = 0;
    num lettersSum = 0;
    String clearJoke = "";
    List<String> Jokes = [];
    bool check = false;
    for (int i = 0; i < list2.length; i++) {
      double list = double.parse(list2[i]);
      sum = sum + list;
    }
    sum = sum / list2.length;
    print("Average temperature: ${sum}");
    List<String>listOfJokesWithOutSpaces=countLetters(jokesList, cleanJokeLetters).$2;
    List<String>listOfJokes=countLetters(jokesList, cleanJokeLetters).$1;
    lettersSum=countLetters(jokesList, cleanJokeLetters).$3;
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
  }
//function that doing the stage 2 that counting how many times temp was over 25
  void tempAbove25(List<String> list2) {
    int counter = 0;
    for (int i = 0; i < list2.length; i++) {
      double list = double.parse(list2[i]);
      if (list > 25) {
        counter++;
      }
    }

    print(counter);
  }

void sortingJson(List<String> list2){
  double currentMaxTemp = 0;
  int index = 0;
  List<double>SortList = [];
  List<double>list1=[];
  for (int g = 0; g < list2.length; g++) { 
    double list = double.parse(list2[g]);
    list1.add(list);
  }
  for (int g = 0; g < list2.length; g++) {    
      for (int i = 0; i < list1.length; i++) {
        if (list1[i] > currentMaxTemp) {
          currentMaxTemp = list1[i];
          index = list1.indexOf(list1[i]);
      }
    }
    SortList.add(currentMaxTemp);
    list1.removeAt(index);
    
  }
  print (SortList);
  //print (currentMaxTemp);
}
