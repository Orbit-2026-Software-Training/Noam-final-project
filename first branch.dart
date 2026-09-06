
  import 'dart:io';
  void main() {
    //נתונים להמשך
    String NCtemp ="";
    String NCtime ="";
    //קריאת הקובץ ופירוק בתוך רשימה
    File file = File('readings.json'); 
    String contents = file.readAsStringSync();
    List<String>list = contents.split(",");
    List<String> list2 = [];
    //שימוש נתונים מההתחלה ופירוק ספיציפי לכל פארמטר
    for (int i = 0; i < list.length; i+=2){
      NCtime = list[i];
      NCtemp = list[i+1];
      String cleantime = NCtime.replaceAll(RegExp(r'[^A-Z0-9-:.]'), '');
      String cleantemp = NCtemp.replaceAll(RegExp(r'[^A-Z0-9.]'), '');
      if (cleantime[0] == ":"){
        cleantime = cleantime.substring(1);
      }
      //print(cleantime);
      //print(cleantemp);
      
      list2.add(cleantemp);
    }
    print(MaxTemp(list2));
    print(MinTemp(list2));
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