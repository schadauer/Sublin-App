import 'package:Sublin/models/address_info_class.dart';
import 'package:Sublin/models/delimiter_class.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/utils/add_string_to_list.dart';

List<AddressInfo> getListOfAddressInfoFromListOfProviderUsersAndUser(
    {List<ProviderUser> providerUserList, User user}) {
  List<AddressInfo> addressInfoList = <AddressInfo>[];
  providerUserList.forEach((providerUser) {
    providerUser.addresses.forEach((address) {
      if (!addressInfoList.contains(address)) {
        addressInfoList.add(AddressInfo(formattedAddress: address));
      }
    });
  });
  if (user.requestedAddresses.length != 0) {
    user.requestedAddresses.forEach((address) {
      if (!addressInfoList.contains(address)) {
        addressInfoList.add(AddressInfo(formattedAddress: address));
      }
    });
  }
  return addressInfoList;
}
