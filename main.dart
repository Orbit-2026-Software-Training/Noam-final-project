
import 'dart:io';
void main() {
  //נתונים להמשך
  String NCtemp ="";
  String NCtime ="";
  int i = 0;
  //קריאת הקובץ ופירוק בתוך רשימה
  File file = File('readings.json'); 
  String contents = file.readAsStringSync();
  List<String>list = contents.split(",");
  //שימוש נתונים מההתחלה ופירוק ספיציפי לכל פארמטר
  NCtime = list[i];
  NCtemp = list[i+1];
  String cleantime = NCtime.replaceAll(RegExp(r'[^A-Z0-9-:.]'), '');
  String cleantemp = NCtemp.replaceAll(RegExp(r'[^A-Z0-9.]'), '');
  print(cleantime);
  print(cleantemp);
}