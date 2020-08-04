// The address pattern is [address]__[postcode]___[station]
String getPartOfAddress(String address, String delimiter) {
  int delimiterIndex;
  int nextDelimiterIndex;
  RegExp regExpDelimiter = RegExp('(?<!_)' + delimiter + '(?!_)');
  RegExp regExpNextDelimiter = RegExp('(?<!_)' + delimiter + '_(?!_)');
  delimiterIndex = regExpDelimiter.hasMatch(address)
      ? address.indexOf(delimiter) + delimiter.length
      : 0;
  nextDelimiterIndex = regExpNextDelimiter.hasMatch(address)
      ? address.indexOf(delimiter + '_')
      : address.length;
  return address.substring(delimiterIndex, nextDelimiterIndex);
}
