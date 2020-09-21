// * Both strings have to be formatted addresses
import 'package:Sublin/models/delimiter_class.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/utils/add_string_to_list.dart';
import 'package:Sublin/utils/get_readable_part_of_formatted_address.dart';

ProviderUser addCityToStationsAndCommunes({
  String cityFormattedAddress,
  String stationFormattedAddress,
  ProviderUser providerUser,
}) {
  bool cityExists = false;
  providerUser.stations.map((station) {
    String cityFromFormattedAddress =
        getReadablePartOfFormattedAddress(cityFormattedAddress, Delimiter.city);
    String cityFromStation =
        getReadablePartOfFormattedAddress(station, Delimiter.city);
    if (cityFromFormattedAddress == cityFromStation) {
      cityExists = true;
    }
  }).toList();
  if (cityExists == false) {
    providerUser.stations.add(cityFormattedAddress + stationFormattedAddress);
    providerUser.communes =
        addStringToList(providerUser.communes, cityFormattedAddress);
  }
  return providerUser;
}
