import 'package:Sublin/models/address_info_class.dart';
import 'package:Sublin/models/delimiter_class.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/request_class.dart';
import 'package:Sublin/models/transportation_type_enum.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/utils/get_formatted_city_from_formatted_address.dart';
import 'package:Sublin/utils/get_formatted_city_from_formatted_station_with_commune.dart';

List<AddressInfo> getListOfAddressInfoFromListOfProviderUsersAndUser({
  List<ProviderUser> providerUserList,
  User user,
  Request localRequest,
}) {
  List<AddressInfo> _addressInfoList = <AddressInfo>[];
  List<AddressInfo> _addressInfoListFilter = <AddressInfo>[];
  providerUserList.forEach((providerUser) {
    providerUser.addresses.forEach((address) {
      if (!_addressInfoList.contains(address)) {
        _addressInfoList.add(AddressInfo(
            formattedAddress: address,
            sponsor: providerUser.providerName,
            byProvider: true,
            transportationType: TransportationType.sublin));
      }
    });
  });
  if (user.addresses.length != 0) {
    user.addresses.forEach((address) {
      if (!_addressInfoList.contains(address) &&
          getFormattedCityFromFormattedAddress(localRequest?.startAddress) !=
              getFormattedCityFromFormattedAddress(address)) {
        _addressInfoList.add(AddressInfo(
            formattedAddress: address,
            byProvider: false,
            transportationType: address.toString().contains(Delimiter.station)
                ? TransportationType.public
                : TransportationType.sublin));
      }
    });
  }
  // Now filter if the localRequest parameter has any value
  _addressInfoListFilter = _addressInfoList.where((addressInfo) {
    if (getFormattedCityFromFormattedAddress(localRequest?.startAddress) ==
        getFormattedCityFromFormattedAddress(addressInfo.formattedAddress))
      return false;
    else
      return true;
  }).toList();

  return _addressInfoListFilter;
}
