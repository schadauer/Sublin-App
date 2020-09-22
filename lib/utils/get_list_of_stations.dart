import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/utils/add_string_to_list.dart';
import 'package:Sublin/utils/get_formatted_station_from_formatted_address.dart';

List<String> getListOfStations(ProviderUser providerUser) {
  List<String> _stations;
  providerUser.stations.forEach((station) {
    // * We only need the formatted station part not the city prefix
    String _station = getFormattedStationFromFormattedAddress(station);
    if (_stations == null)
      _stations = [_station];
    else if (_stations != null && _stations.contains(_station)) {
      _stations = addStringToList(_stations, _station);
    }
  });
  return _stations ?? [];
}
