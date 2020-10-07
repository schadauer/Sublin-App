// * Both strings have to be formatted addresses
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/utils/add_string_to_list.dart';
import 'package:Sublin/utils/get_formatted_city_from_formatted_station_with_commune.dart';

ProviderUser addCityToStationsAndCommunes({
  String cityFormattedAddress,
  String stationFormattedAddress,
  ProviderUser providerUser,
}) {
  bool cityExists = false;
  providerUser.stations.forEach((station) {
    String cityFromStation =
        getFormattedCityFromFormattedStationWithCommune(station);
    if (cityFormattedAddress == cityFromStation) {
      cityExists = true;
    }
  });
  if (cityExists == false) {
    providerUser.stations.add(cityFormattedAddress + stationFormattedAddress);
    providerUser.communes =
        addStringToList(providerUser.communes, cityFormattedAddress);
    providerUser.addresses =
        addStringToList(providerUser.communes, cityFormattedAddress);
  }
  // TODO  We also need to do some clean up if a station reference is still there
  return providerUser;
}
