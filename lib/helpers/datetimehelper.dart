import 'package:intl/intl.dart';

class DateTimeHelper {
  
  String timestampToDateTIme(int timestamp){
    final DateTime datetime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final date24format = DateFormat('dd/MM/yyyy, HH:mm').format(datetime);
    return date24format;
  }

}
