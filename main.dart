import 'dart:io';
import 'package:http/http.dart' as http;

void main() {
  String NCtemp ="";
  String NCtime ="";
  File file = File('readings.json'); 
  String contents = file.readAsStringSync();
  List<String>list = contents.split(",");
    List<String> list2 = [];
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
    print(MaxTemp(list2));
    print(MinTemp(list2));
    print(averagetemp(list2));
    print (tempAbove25(list2));
    apiReading();
  }
  double MaxTemp(List<String> list2){
    double CurrentMax = 0;
    for (int i = 0; i < list2.length; i++){
      double list = double.parse(list2[i]);
      if (list > CurrentMax){
        CurrentMax = list;
      }
    }
    return CurrentMax;
  }
  double MinTemp(List<String>list2){
    double currentMin = 1000;
    for (int i = 0; i < list2.length; i++){
      double list = double.parse(list2[i]);
      if (list < currentMin){
        currentMin = list;
      }
    }
    return currentMin;
  }
  double averagetemp(List<String> list2){
    double sam = 0;
    for (int i =0; i<list2.length;i++){
      double list = double.parse(list2[i]);
      sam = sam + list;
    }
    sam = sam/list2.length;
    return sam;
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
void apiReading()async{
  var url = Uri.parse('https://v2.jokeapi.dev/joke/Misc,Programming?format=xml&safe-mode&type=single');
  var response = await http.get(url);  
  String urlAsString = response.body.toString(); 
  print (response.body);
  List<String>list = urlAsString.split("joke");
  print (list[1]);
  String cleanJoke = list[1].replaceAll(RegExp(r'[^A-Z0-9%.]'), '');
  print(cleanJoke);
}