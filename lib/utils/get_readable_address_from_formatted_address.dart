import 'package:Sublin/models/delimiter_class.dart';
import 'package:Sublin/utils/get_readable_address_part_of_formatted_address.dart';

String getReadableAddressFromFormattedAddress(String formattedAddress) {
  if (formattedAddress != '') {
    String station = getReadableAddressPartOfFormattedAddress(
        formattedAddress, Delimiter.station);
    station = station != '' ? station + ', ' : '';
    String company = getReadableAddressPartOfFormattedAddress(
        formattedAddress, Delimiter.company);
    company = company != '' ? company + ', ' : '';
    String street = getReadableAddressPartOfFormattedAddress(
        formattedAddress, Delimiter.street);
    String number = getReadableAddressPartOfFormattedAddress(
        formattedAddress, Delimiter.number);
    street = number != '' ? street + ' ' : street;
    String city = getReadableAddressPartOfFormattedAddress(
        formattedAddress, Delimiter.city);
    city = street != '' ? ', ' + city : city;
    return station + company + street + number + city;
  } else {
    return '';
  }
}
