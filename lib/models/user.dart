import 'package:Sublin/models/address.dart';
import 'package:Sublin/models/user_type.dart';

class User {
  final bool streamingOn;
  final String email;
  final String firstName;
  final String secondName;
  final String homeAddress;
  final UserType userType;
  final bool isRegistrationCompleted;
  final List<dynamic> preferredAddresses;
  final List<Address> requestedAddresses;

  User({
    this.streamingOn,
    this.email = '',
    this.firstName = '',
    this.secondName = '',
    this.homeAddress = '',
    this.userType = UserType.user,
    this.isRegistrationCompleted = false,
    this.preferredAddresses = const [],
    this.requestedAddresses = const [],
  });

  factory User.initialData() {
    return User(
      streamingOn: false,
    );
  }

  factory User.fromJson(Map data) {
    final User defaultValues = User();
    final Address defaultValuesAddress = Address();
    data = data ?? {};
    return User(
        streamingOn: true,
        email: data['email'] ?? defaultValues.email,
        firstName: data['firstName'] ?? defaultValues.firstName,
        secondName: data['secondName'] ?? defaultValues.secondName,
        homeAddress: data['homeAddress'] ?? defaultValues.homeAddress,
        userType: UserType.values.firstWhere(
            (e) => e.toString() == 'UserType.' + (data['userType'] ?? '')),
        isRegistrationCompleted: data['isRegistrationCompleted'] ??
            defaultValues.isRegistrationCompleted,
        preferredAddresses:
            data['preferredAddresses'] ?? defaultValues.preferredAddresses,
        requestedAddresses: (data['requestedAddresses'] == null)
            ? defaultValues.requestedAddresses
            : data['requestedAddresses'].map<Address>((address) {
                return Address(
                  formattedAddress: address['formattedAddress'] ??
                      defaultValuesAddress.formattedAddress,
                  id: address['id'] ?? defaultValuesAddress.id,
                );
              }).toList());
  }

  Map<String, dynamic> toJson(User data) {
    User defaultValues = User();
    String userTypeString =
        data.userType != null ? data.userType.toString() : '';

    return {
      if (data.email != null) 'email': data.email ?? defaultValues.email,
      if (data.firstName != null)
        'firstName': data.firstName ?? defaultValues.firstName,
      if (data.secondName != null)
        'secondName': data.secondName ?? defaultValues.secondName,
      if (data.homeAddress != null)
        'homeAddress': data.homeAddress ?? defaultValues.homeAddress,
      if (userTypeString != '')
        'userType': userTypeString.substring(userTypeString.indexOf('.') + 1),
      if (data.isRegistrationCompleted != null)
        'isProvider': data.isRegistrationCompleted ??
            defaultValues.isRegistrationCompleted,
      if (data.preferredAddresses != null)
        'preferredAddresses':
            data.preferredAddresses ?? defaultValues.preferredAddresses,
      if (data.requestedAddresses != null)
        'requestAddresses':
            data.requestedAddresses ?? defaultValues.requestedAddresses
    };
  }
}
