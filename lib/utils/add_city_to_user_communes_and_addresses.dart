// * Both strings have to be formatted addresses
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/utils/add_string_to_list.dart';
import 'package:Sublin/utils/get_formatted_city_from_formatted_address.dart';
import 'package:Sublin/utils/is_formatted_address_a_city.dart';

User addCityToUserCommunesAndAddresses({
  String formattedAddress,
  User user,
}) {
  if (isFormattedAddressACity(formattedAddress: formattedAddress)) {
    if (!user.communes
        .contains(getFormattedCityFromFormattedAddress(formattedAddress)))
      user.communes = addStringToList(user.communes, formattedAddress);
  } else {
    if (!user.addresses.contains(formattedAddress))
      user.addresses = addStringToList(user.addresses, formattedAddress);
    user.communes = addStringToList(
        user.communes, getFormattedCityFromFormattedAddress(formattedAddress));
  }
  return user;
}
