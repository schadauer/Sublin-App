import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/utils/get_formatted_city_from_formatted_station.dart';
import 'package:Sublin/utils/get_formatted_station_from_formatted_address.dart';

ProviderUser removeCityFromStationsAndCommunes({
  String station,
  String city,
  ProviderUser providerUser,
}) {
  int _removeIndexStations;
  int _stationCount = 0;
  int _removeIndexCommunes;
  int _removeIndexAddresses;
  // * We need to remove the city from the stations list

  // * We need to be sure that we do not loose the station reference. So if only
  // * one item with the station address is left we need to keep it but only remove
  // * the city part of it
  providerUser.stations.forEach((formattedStation) {
    if (station == getFormattedStationFromFormattedAddress(formattedStation))
      _stationCount += 1;
  });

  print(_stationCount);
  print(city);

  for (var i = 0; i < providerUser.stations.length; i++) {
    String _cityFromStation =
        getFormattedCityFromFormattedStation(providerUser.stations[i]);
    print('cityFromStation');
    print(_cityFromStation);
    if (city == _cityFromStation && _stationCount > 1) {
      _removeIndexStations = i;
    } else if (_stationCount == 1)
      providerUser.stations[i] = providerUser.stations[i]
          .substring(city.length, providerUser.stations[i].length);
  }
  if (providerUser.stations.length != 0 && _removeIndexStations != null)
    providerUser.stations.removeAt(_removeIndexStations);
  // * We also need to remove the city from the communes list
  for (var i = 0; i < providerUser.communes.length; i++) {
    if (city == providerUser.communes[i]) _removeIndexCommunes = i;
  }
  if (providerUser.communes.length != 0)
    providerUser.communes.removeAt(_removeIndexCommunes);

  for (var i = 0; i < providerUser.addresses.length; i++) {
    if (city == providerUser.addresses[i]) _removeIndexAddresses = i;
  }
  if (providerUser.addresses.length != 0)
    providerUser.addresses.removeAt(_removeIndexAddresses);
  return providerUser;
}
