import 'package:Sublin/models/address_class.dart';
import 'package:Sublin/models/transportation_type_enum.dart';

class AddressInfo {
  String title;
  String formattedAddress;
  String sponsor;
  TransportationType transportationType;
  AddressInfo({
    this.title,
    this.sponsor,
    this.formattedAddress,
    this.transportationType,
  });
}
