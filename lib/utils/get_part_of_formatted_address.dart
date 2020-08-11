// The address pattern is [address]__[postcode]___[station]
import 'package:Sublin/utils/get_next_delimiter.dart';

String getPartOfFormattedAddress(String formattedAddress, String delimiter) {
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
        ? formattedAddress.indexOf(getNextDelimiter(
            delimiter: delimiter, formattedAddress: formattedAddress))
        : formattedAddress.length;
    return formattedAddress.substring(delimiterIndex, nextDelimiterIndex);
  } else {
    return '';
  }
}
