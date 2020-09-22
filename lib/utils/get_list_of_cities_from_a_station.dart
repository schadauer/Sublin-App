import 'package:Sublin/models/delimiter_class.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/utils/add_string_to_list.dart';

List<String> getListOfCitiesFromAStation(
    ProviderUser providerUser, String stationFormattedAddress) {
  List<String> _cities;
  providerUser.stations.forEach((station) {
    // * We need to check if only one item is in there which keeps the reference of the station
    // * example: __STA__Bahnhof St.Peter Seitenstetten__COU__AT__CIT__Seitenstetten
    if (station.indexOf(Delimiter.station) != 0) {
      if (_cities == null) {
        _cities = [station.substring(0, station.indexOf(Delimiter.station))];
      } else if (station.contains(stationFormattedAddress)) {
        _cities = addStringToList(
            _cities, station.substring(0, station.indexOf(Delimiter.station)));
      }
    }
  });
  return _cities ?? [];
}
