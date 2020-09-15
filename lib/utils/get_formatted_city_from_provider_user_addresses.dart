import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/user_class.dart';

String getFormattedCityFromListProviderUserAddresses(
    ProviderUser providerUser, User user) {
  String _formattedCityFromCommun = '';
  user.communes.forEach((address) {
    print(address);
    if (providerUser.addresses.contains(address))
      _formattedCityFromCommun = address;
  });
  return _formattedCityFromCommun;
}
