// The address pattern is [address]__[postcode]___[station]
import 'package:Sublin/models/delimiter_class.dart';
import 'package:Sublin/utils/get_next_delimiter.dart';

// Returns only the part which is requested
String getReadableAddressPartOfFormattedAddress(
    String formattedAddress, String delimiter) {
  formattedAddress.contains(Delimiter.station);
  if (formattedAddress != '' &&
      formattedAddress != null &&
      formattedAddress.contains(delimiter)) {
    int delimiterIndex;
    int nextDelimiterIndex;
    RegExp regExpDelimiter = RegExp(delimiter);
    RegExp regExpNextDelimiter = RegExp(getNextDelimiter(
        delimiter: delimiter, formattedAddress: formattedAddress));
    delimiterIndex = regExpDelimiter.hasMatch(formattedAddress)
        ? formattedAddress.indexOf(delimiter) + delimiter.length
        : 0;
    nextDelimiterIndex = regExpNextDelimiter.hasMatch(formattedAddress)
        ? formattedAddress.contains(Delimiter.station)
            ? formattedAddress.lastIndexOf(getNextDelimiter(
                delimiter: delimiter, formattedAddress: formattedAddress))
            : formattedAddress.indexOf(getNextDelimiter(
                delimiter: delimiter, formattedAddress: formattedAddress))
        : formattedAddress.length;
    return formattedAddress.substring(delimiterIndex, nextDelimiterIndex);
  } else {
    return '';
  }
}
