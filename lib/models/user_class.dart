import 'package:Sublin/models/user_type_enum.dart';

class User {
  final String uid;
  final bool streamingOn;
  final String email;
  final String firstName;
  final String secondName;
  final String homeAddress;
  final UserType userType;
  final List<dynamic> communes;
  final List<dynamic> targetGroup;
  final List<dynamic> requestedAddresses;
  bool isRegistrationCompleted;

  User({
    this.uid = '',
    this.streamingOn,
    this.email = '',
    this.firstName = '',
    this.secondName = '',
    this.homeAddress = '',
    this.userType = UserType.user,
    this.communes = const [],
    this.targetGroup = const [],
    this.requestedAddresses = const [],
    this.isRegistrationCompleted = false,
  });

  factory User.initialData() {
    return User(
      streamingOn: false,
    );
  }

  factory User.fromJson(Map data) {
    final User defaultValues = User();
    data = data ?? {};
    return User(
        streamingOn: true,
        uid: data['uid'] ?? defaultValues.uid,
        email: data['email'] ?? defaultValues.email,
        firstName: data['firstName'] ?? defaultValues.firstName,
        secondName: data['secondName'] ?? defaultValues.secondName,
        homeAddress: data['homeAddress'] ?? defaultValues.homeAddress,
        userType: UserType.values.firstWhere(
            (e) => e.toString() == 'UserType.' + (data['userType'] ?? '')),
        isRegistrationCompleted: data['isRegistrationCompleted'] ??
            defaultValues.isRegistrationCompleted,
        communes: data['communes'] ?? defaultValues.communes,
        targetGroup: data['targetGroup'] ?? defaultValues.targetGroup,
        requestedAddresses:
            data['requestedAddresses'] ?? defaultValues.requestedAddresses);
  }

  Map<String, dynamic> toJson(User data) {
    User defaultValues = User();
    String userTypeString =
        data.userType != null ? data.userType.toString() : '';

    return {
      if (data.uid != null) 'uid': data.uid ?? defaultValues.uid,
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
        'isRegistrationCompleted': data.isRegistrationCompleted ??
            defaultValues.isRegistrationCompleted,
      if (data.communes != null)
        'communes': data.communes ?? defaultValues.communes,
      if (data.targetGroup != null)
        'targetGroup': data.targetGroup ?? defaultValues.targetGroup,
      if (data.requestedAddresses != null)
        'requestedAddresses':
            data.requestedAddresses ?? defaultValues.requestedAddresses
    };
  }
}
