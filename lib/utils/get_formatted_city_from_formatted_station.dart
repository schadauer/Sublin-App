import 'package:Sublin/models/delimiter_class.dart';

String getFormattedCityFromFormattedStation(String formattedAddress) {
  int _indexOfStationDelimiter = formattedAddress.indexOf(Delimiter.station);
  return formattedAddress.substring(0, _indexOfStationDelimiter);
}
