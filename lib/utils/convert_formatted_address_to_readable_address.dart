import 'package:Sublin/models/delimiter.dart';
import 'package:Sublin/utils/get_readable_part_of_formatted_address.dart';

String convertFormattedAddressToReadableAddress(String formattedAddress) {
  if (formattedAddress != '') {
    String station =
        getReadablePartOfFormattedAddress(formattedAddress, Delimiter.station);
    station = station != '' ? station + ', ' : '';
    String company =
        getReadablePartOfFormattedAddress(formattedAddress, Delimiter.company);
    company = company != '' ? company + ', ' : '';
    String street =
        getReadablePartOfFormattedAddress(formattedAddress, Delimiter.street);
    String number =
        getReadablePartOfFormattedAddress(formattedAddress, Delimiter.number);
    street = number != '' ? street + ' ' : street;
    String city =
        getReadablePartOfFormattedAddress(formattedAddress, Delimiter.city);
    city = street != '' ? ', ' + city : city;
    return station + company + street + number + city;
  } else {
    return '';
  }
}
