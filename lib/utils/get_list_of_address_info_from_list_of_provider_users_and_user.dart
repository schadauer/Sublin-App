import 'package:Sublin/models/address_info_class.dart';
import 'package:Sublin/models/delimiter_class.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/transportation_type_enum.dart';
import 'package:Sublin/models/user_class.dart';

List<AddressInfo> getListOfAddressInfoFromListOfProviderUsersAndUser(
    {List<ProviderUser> providerUserList, User user}) {
  List<AddressInfo> addressInfoList = <AddressInfo>[];
  providerUserList.forEach((providerUser) {
    providerUser.addresses.forEach((address) {
      if (!addressInfoList.contains(address)) {
        addressInfoList.add(AddressInfo(
            formattedAddress: address,
            title: providerUser.providerName,
            transportationType: TransportationType.sublin));
      }
    });
  });
  if (user.requestedAddresses.length != 0) {
    user.requestedAddresses.forEach((address) {
      if (!addressInfoList.contains(address)) {
        addressInfoList.add(AddressInfo(
            formattedAddress: address,
            transportationType: address.toString().contains(Delimiter.station)
                ? TransportationType.public
                : TransportationType.sublin));
      }
    });
  }
  return addressInfoList;
}
