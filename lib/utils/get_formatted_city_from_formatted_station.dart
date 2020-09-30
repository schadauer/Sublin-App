import 'package:Sublin/models/delimiter_class.dart';

String getFormattedCityFromFormattedStation(String formattedAddress) {
  int _indexOfStationDelimiter = formattedAddress.indexOf(Delimiter.country);
  if (_indexOfStationDelimiter != -1)
    return formattedAddress.substring(
        _indexOfStationDelimiter, formattedAddress.length);
  else
    return '';
}
