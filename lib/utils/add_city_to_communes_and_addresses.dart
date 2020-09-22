// * Both strings have to be formatted addresses
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/utils/add_string_to_list.dart';

ProviderUser addCityToCommunesAndAddresses({
  String cityFormattedAddress,
  ProviderUser providerUser,
}) {
  if (!providerUser.communes.contains(cityFormattedAddress))
    providerUser.communes =
        addStringToList(providerUser.communes, cityFormattedAddress);
  if (!providerUser.addresses.contains(cityFormattedAddress))
    providerUser.addresses =
        addStringToList(providerUser.addresses, cityFormattedAddress);
  return providerUser;
}
