import 'package:Sublin/models/address_class.dart';
import 'package:Sublin/models/transportation_type_enum.dart';

class AddressInfo {
  String title;
  String sponsor;
  String formattedAddress;
  bool byProvider;
  TransportationType transportationType;
  AddressInfo({
    this.title,
    this.sponsor,
    this.byProvider,
    this.formattedAddress,
    this.transportationType,
  });
}
