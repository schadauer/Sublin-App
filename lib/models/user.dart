import 'package:sublin/models/address.dart';

class User {
  final bool streamingOn;
  final String firstName;
  final String secondName;
  final String homeAddress;
  final List<Address> requestedAddresses;

  User({
    this.streamingOn,
    this.firstName,
    this.secondName,
    this.homeAddress,
    this.requestedAddresses,
  });

  factory User.fromMap(Map data) {
    data = data ?? {};
    print(data);
    return User(
        streamingOn: true,
        firstName: data['firstName'] ?? '',
        secondName: data['secondName'] ?? '',
        homeAddress: data['homeAddress'] ?? '',
        requestedAddresses: (data['requestedAddresses'] == null)
            ? null
            : data['requestedAddresses'].map<Address>((address) {
                return Address(name: address['name'], id: address['id']);
              }).toList());
  }

  factory User.initialData() {
    return User(
      streamingOn: false,
    );
  }
}
