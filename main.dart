
import 'dart:io';
void main() {
 
  File file = File('readings.json');
  
  String contents = file.readAsStringSync();
  List<String>list = contents.split(",");
  String something = list[0];
  List<String>list2 = something.split(":");
  print("0");
}