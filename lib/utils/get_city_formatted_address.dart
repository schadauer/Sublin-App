// The address pattern is [address]__[postcode]___[station]
import 'package:Sublin/models/delimiter_class.dart';
import 'package:Sublin/utils/get_next_delimiter.dart';

// Returns only the name of the city as string
String getCityFormattedAddress(String formattedAddress) {
  if (formattedAddress != '' &&
      formattedAddress != null &&
      formattedAddress.contains(Delimiter.city)) {
    int nextDelimiterIndex;
    RegExp regExpNextDelimiter = RegExp(getNextDelimiter(
        delimiter: Delimiter.city, formattedAddress: formattedAddress));
    nextDelimiterIndex = regExpNextDelimiter.hasMatch(formattedAddress)
        ? formattedAddress.indexOf(getNextDelimiter(
            delimiter: Delimiter.city, formattedAddress: formattedAddress))
        : formattedAddress.length;
    return formattedAddress.substring(0, nextDelimiterIndex);
  } else {
    return '';
  }
}
