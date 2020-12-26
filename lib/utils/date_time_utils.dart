import 'package:intl/intl.dart';

class dateTimeUtils{
  static String convertingTimestamp(int timestamp){
    int timeInMillis = 1586348737122;
    var date = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
    String formattedDate = DateFormat("yyyy-MM-dd").format(date);// Apr 8, 2020
    return formattedDate;
  }


}


