import 'package:intl/intl.dart';

extension DateFormatter on DateTime {
  String makeFormat(){
    return DateFormat('yyyy-MM-dd – hh:mm:ss:aa').format(this);
  }
}