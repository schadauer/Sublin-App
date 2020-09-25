import 'package:Sublin/models/address_class.dart';
import 'package:Sublin/models/transportation_type_enum.dart';

class AddressInfo {
  String title;
  String formattedAddress;
  String provider;
  TransportationType transportationType;
  AddressInfo({
    this.title,
    this.provider,
    this.formattedAddress,
    this.transportationType,
  });
}
