DateTime getDateTimeFromInt(int time) {
  int timeInt = time ?? 0;
  String timeString = timeInt.toString();
  for (var i = timeString.length; i < 4; i++) {
    timeString = '0' + timeString;
  }
  timeString = timeString.substring(0, 2) + ':' + timeString.substring(2, 4);
  DateTime timeDate = DateTime.parse('2020-01-01 ' + timeString + ':00');
  return timeDate;
}
