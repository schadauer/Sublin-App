import 'package:Sublin/models/delimiter.dart';
import 'package:Sublin/utils/get_part_of_formatted_address.dart';

String convertFormattedAddressToReadableAddress(String formattedAddress) {
  if (formattedAddress != '') {
    String company =
        getPartOfFormattedAddress(formattedAddress, Delimiter.company);
    company = company != '' ? company + ', ' : '';
    String street =
        getPartOfFormattedAddress(formattedAddress, Delimiter.street);
    String number =
        getPartOfFormattedAddress(formattedAddress, Delimiter.number);
    street = number != '' ? street + ' ' : street;
    String city = getPartOfFormattedAddress(formattedAddress, Delimiter.city);
    city = street != '' ? ', ' + city : city;
    return company + street + number + city;
  } else {
    return '';
  }
}
