import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/utils/get_formatted_city_from_formatted_station.dart';

ProviderUser removeCityFromStationsAndCommunes({
  String city,
  ProviderUser providerUser,
}) {
  int _removeIndexStations;
  int _removeIndexCommunes;
  // * We need to remove the city from the stations list
  for (var i = 0; i < providerUser.stations.length; i++) {
    String _cityFromStation =
        getFormattedCityFromFormattedStation(providerUser.stations[i]);
    if (city == _cityFromStation) {
      _removeIndexStations = i;
    }
  }
  providerUser.stations.removeAt(_removeIndexStations);
  // * We also need to remove the city from the communes list
  for (var i = 0; i < providerUser.communes.length; i++) {
    if (city == providerUser.communes[i]) _removeIndexCommunes = i;
  }
  providerUser.communes.removeAt(_removeIndexCommunes);
  return providerUser;
}
