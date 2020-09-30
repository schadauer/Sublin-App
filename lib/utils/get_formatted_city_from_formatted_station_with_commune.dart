import 'package:Sublin/models/delimiter_class.dart';

String getFormattedCityFromFormattedStationWithCommune(
    String formattedAddress) {
  int _indexOfStationDelimiter = formattedAddress.indexOf(Delimiter.station);
  if (_indexOfStationDelimiter != -1)
    return formattedAddress.substring(0, _indexOfStationDelimiter);
  else
    return '';
}
