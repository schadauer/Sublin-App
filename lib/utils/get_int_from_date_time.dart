import 'package:intl/intl.dart';

DateFormat format = DateFormat('HHmm');

int getIntFromDateTime(DateTime time) {
  return int.parse(format.format(time));
}
