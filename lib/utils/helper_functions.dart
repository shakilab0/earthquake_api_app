import 'package:intl/intl.dart';

 String getFormattedDate(DateTime dt,{String pattern = 'yyyy-MM-dd'}) =>
    DateFormat(pattern).format(dt);

String formattedDate(DateTime dateTime, String pattern) {
  return DateFormat(pattern).format(dateTime);
}

const magList = <double>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10];