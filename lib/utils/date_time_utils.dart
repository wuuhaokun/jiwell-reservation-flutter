import 'package:intl/intl.dart';

class dateTimeUtils{
  static String convertingTimestamp(int timestamp){
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String formattedDate = DateFormat("yyyy-MM-dd").format(date);// Apr 8, 2020
    return formattedDate;
  }


}


