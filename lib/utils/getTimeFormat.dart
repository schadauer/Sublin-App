import 'package:intl/intl.dart';

String getTimeFormat(int timestamp) {
  DateFormat formatter = new DateFormat('HH:mm');
  String formatted = formatter.format(
    new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000000),
  );
  return formatted;
}
