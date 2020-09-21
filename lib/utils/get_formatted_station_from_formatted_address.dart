import 'package:Sublin/models/delimiter_class.dart';

String getFormattedStationFromFormattedAddress(String formattedAddress) {
  int _indexOfStationDelimiter = formattedAddress.indexOf(Delimiter.station);
  return formattedAddress.substring(
      _indexOfStationDelimiter, formattedAddress.length);
}
