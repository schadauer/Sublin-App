// Format of address is [house number]_[street]__[city]___[country iso code]<->[station]
// at the moment only addresses from AT are allowed!

String formatAddress(String address) {
  RegExp regExp = RegExp("[0-9]{1,4}");
  String houseNo = regExp.stringMatch(address);
  bool isCityOnly = address.indexOf(',') == -1 ? true : false;
  String street = isCityOnly
      ? ''
      : address.substring(
          0,
          houseNo == null
              ? address.indexOf(',')
              : address.indexOf(houseNo) - 1);
  String city = address.substring(
      isCityOnly ? 0 : address.indexOf(',') + 1, address.length);
  String formattedHouseNo = houseNo == null ? '' : houseNo.trim() + '_';
  String formattedStreet = street == '' ? '' : street.trim() + '__';
  String formattedCity = city.trim() + '___';
  String formattedCountry = 'AT';
  print(formattedHouseNo + formattedStreet + formattedCity + formattedCountry);
  return formattedHouseNo + formattedStreet + formattedCity + formattedCountry;
}
