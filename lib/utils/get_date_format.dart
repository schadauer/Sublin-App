import 'package:intl/intl.dart';

String getDateFormat(int timestamp) {
  DateFormat formatter = new DateFormat('HH:mm, d.M.y');
  String formatted = formatter.format(
    new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000000),
  );
  return formatted;
}
