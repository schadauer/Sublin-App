import 'package:Sublin/models/address_info_class.dart';
import 'package:Sublin/models/delimiter_class.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/request_class.dart';
import 'package:Sublin/models/transportation_type_enum.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/utils/get_formatted_city_from_formatted_address.dart';

class AddressInfoProvider {
  List<AddressInfo> getListOfAddressInfoFromListOfProviderUsersAndUser({
    List<ProviderUser> providerUserList,
    User user,
    Request localRequest,
  }) {
    List<AddressInfo> _addressInfoList = <AddressInfo>[];
    List<AddressInfo> _addressInfoListFilter = <AddressInfo>[];
    //* Get all addresses from addresses in the user instance

    if (user.addresses.length != 0) {
      user.addresses.forEach((address) {
        if (!_addressInfoList.contains(address) &&
            getFormattedCityFromFormattedAddress(localRequest?.startAddress) !=
                getFormattedCityFromFormattedAddress(address)) {
          print(address);
          _addressInfoList.add(AddressInfo(
            formattedAddress: address,
            sponsor: _getSponsor(
                providerUserList: providerUserList, formattedAddress: address),
            byProvider: false,
            transportationType: _getTransportationType(
                providerUserList: providerUserList, formattedAddress: address),
          ));
        }
      });
    }
    //* Get all addresses from all applicable provider addresses
    providerUserList.forEach((providerUser) {
      providerUser.addresses.forEach((address) {
        if (!_isAddressOrCommuneOfAddressInTheList(
            addressInfoList: _addressInfoList, formattedAddress: address)) {
          _addressInfoList.add(AddressInfo(
              formattedAddress: address,
              sponsor: providerUser.providerName,
              byProvider: true,
              transportationType: TransportationType.sublin));
        }
      });
    });
    //* Now filter if the localRequest parameter has any value
    _addressInfoListFilter = _addressInfoList.where((addressInfo) {
      if (getFormattedCityFromFormattedAddress(localRequest?.startAddress) ==
          getFormattedCityFromFormattedAddress(addressInfo.formattedAddress))
        return false;
      else
        return true;
    }).toList();
    return _addressInfoListFilter;
  }

  bool _isAddressOrCommuneOfAddressInTheList(
      {List<AddressInfo> addressInfoList, String formattedAddress}) {
    bool isInList = false;
    addressInfoList.forEach((addressInfo) {
      if (getFormattedCityFromFormattedAddress(addressInfo.formattedAddress) ==
              formattedAddress ||
          addressInfo.formattedAddress == formattedAddress) isInList = true;
    });
    return isInList;
  }

  String _getSponsor(
      {List<ProviderUser> providerUserList, String formattedAddress}) {
    String sponsor = '';
    providerUserList.forEach((providerUser) {
      providerUser.addresses.forEach((address) {
        if (address == getFormattedCityFromFormattedAddress(formattedAddress) ||
            address == formattedAddress) sponsor = providerUser.providerName;
      });
    });
    return sponsor;
  }

  TransportationType _getTransportationType(
      {List<ProviderUser> providerUserList, String formattedAddress}) {
    TransportationType _transportationType = TransportationType.public;

    providerUserList.forEach((providerUser) {
      providerUser.addresses.forEach((address) {
        // print(formattedAddress);
        if (address == getFormattedCityFromFormattedAddress(formattedAddress) ||
            address == formattedAddress)
          _transportationType = TransportationType.sublin;
        if (formattedAddress.contains(Delimiter.station))
          _transportationType = TransportationType.privat;
      });
    });
    return _transportationType;
  }
}
