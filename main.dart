import 'dart:io';
import 'package:http/http.dart' as http;

void main()async{ 
  String NCtemp ="";
  String NCtime ="";
  File file = File('readings.json'); 
  String contents = file.readAsStringSync();
  List<String>list = contents.split(",");
  List<String> list2 = [];
  List<String>jokeList = [];
  List<String> jokesList = [];
    for (int i = 0; i < list.length; i+=2){
  NCtime = list[i];
  NCtemp = list[i+1];
  String cleantime = NCtime.replaceAll(RegExp(r'[^A-Z0-9-:.]'), '');
  String cleantemp = NCtemp.replaceAll(RegExp(r'[^A-Z0-9.]'), '');
      if (cleantime[0] == ":"){
        cleantime = cleantime.substring(1);
      }   
      list2.add(cleantemp);
    }
    Future<void> apiReading() async {
      for (int i = 0; i < 10; i++){
        var url = Uri.parse('https://v2.jokeapi.dev/joke/Misc,Programming?format=xml&safe-mode&type=single');
        var response = await http.get(url);  
        String urlAsString = response.body.toString(); 
  
        String cleanUrl = urlAsString.replaceAll(RegExp(r'/'), '');
        List<String>JokeList = cleanUrl.split("<joke>");
        jokesList.add(JokeList[1]);
      }
    //print(jokesList);
    //print (jokesList.length);
  
}
      
      await apiReading();
      MaxTempLongestLetters(list2, jokesList);
      MinTempShortestLetters(list2, jokesList);
      averagetempAverageLetters(list2, jokesList);
      print (tempAbove25(list2));
    
  }
  void MaxTempLongestLetters(List<String> list2,List<String>jokesList){
    double CurrentMax = 0;
    int currentMaxLetters = 0;
    int j = 0;
    
    for (int i = 0; i < list2.length; i++){
      double list = double.parse(list2[i]);
      if (list > CurrentMax){
        CurrentMax = list;
      }
    }
    
    for ( int i= 0; i < jokesList.length; i++){
      String clearJoke = jokesList[i].replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
      int jokeLength = clearJoke.length;
      if (jokeLength > currentMaxLetters){
        j = i;
        currentMaxLetters = jokeLength;
      }
    }
    
    print("Joke with the most letters: ${jokesList[j]} with ${currentMaxLetters} letters");
    print ("Max temperature: ${CurrentMax}");
  }
  void MinTempShortestLetters(List<String>list2,List<String>jokesList){
    double currentMin = 1000;
    int currentMinLetters = 1000;
    int j = 0;
    for (int i = 0; i < list2.length; i++){
      double list = double.parse(list2[i]);
      if (list < currentMin){
        currentMin = list;
      }
    }
    for (int i = 0; i<jokesList.length;i++){
      String clearJoke = jokesList[i].replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
      int jokeLength = clearJoke.length;
      if (jokeLength < currentMinLetters){
        j = i;
        currentMinLetters = jokeLength;
      }
    }
    print("Joke with the least letters: ${jokesList[j]} with ${currentMinLetters} letters");
    print ("Min temperature: ${currentMin}");
  }
  void averagetempAverageLetters(List<String> list2,List<String>jokesList){
    double sum = 0;
    int lettersSum = 0;
    bool check = false;
    for (int i =0; i<list2.length;i++){
      double list = double.parse(list2[i]);
      sum = sum + list;
    }
    double average = sum / list2.length;
    print ("Average temperature: ${average}");
    for (int i = 0; i<jokesList.length;i++){
      String clearJoke = jokesList[i].replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
      int jokeLength = clearJoke.length;
      lettersSum = lettersSum + jokeLength;
   }
   for (int i = 0; i<jokesList.length;i++){
      String clearJoke = jokesList[i].replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
      int jokeLength = clearJoke.length;
      if (jokeLength==lettersSum/jokesList.length){
        check = true;
        print ("Joke with the exact average letters: ${jokesList[i]} with ${jokeLength} letters");
      }
    }
    if (check == false){
      print ("No joke with the exact average letters");
    }

  }
int tempAbove25(List<String> list2){
  int counter = 0;
  for (int i = 0; i<list2.length;i++){
    double list = double.parse(list2[i]);
    if (list>25){
      counter++;  
    }
  }

  return counter;
}
