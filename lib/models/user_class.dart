import 'package:Sublin/models/user_type_enum.dart';

class User {
  final String uid;
  final bool streamingOn;
  final String email;
  final String firstName;
  final String secondName;
  final String homeAddress;
  final UserType userType;
  List<String> targetGroup;
  List<String> communes;
  List<String> addresses;
  bool isRegistrationCompleted;
  bool isTestPeriodRegistrationCompleted;

  User({
    this.uid = '',
    this.streamingOn,
    this.email = '',
    this.firstName = '',
    this.secondName = '',
    this.homeAddress = '',
    this.userType = UserType.user,
    this.communes = const <String>[],
    this.targetGroup = const <String>[],
    this.addresses = const <String>[],
    this.isRegistrationCompleted = false,
    this.isTestPeriodRegistrationCompleted = false,
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
      isTestPeriodRegistrationCompleted:
          data['isTestPeriodRegistrationCompleted'] ??
              defaultValues.isTestPeriodRegistrationCompleted,
      communes: (data['communes'] == null)
          ? defaultValues.communes
          : data['communes'].map<String>((commune) {
              return commune.toString();
            }).toList(),
      addresses: (data['addresses'] == null)
          ? defaultValues.addresses
          : data['addresses'].map<String>((address) {
              return address.toString();
            }).toList(),
      targetGroup: (data['targetGroup'] == null)
          ? defaultValues.targetGroup
          : data['targetGroup'].map<String>((target) {
              return target.toString();
            }).toList(),
    );
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
      if (data.isTestPeriodRegistrationCompleted != null)
        'isTestPeriodRegistrationCompleted':
            data.isTestPeriodRegistrationCompleted ??
                defaultValues.isTestPeriodRegistrationCompleted,
      if (data.communes != null)
        'communes': data.communes ?? defaultValues.communes,
      if (data.targetGroup != null)
        'targetGroup': data.targetGroup ?? defaultValues.targetGroup,
      if (data.addresses != null)
        'addresses': data.addresses ?? defaultValues.addresses
    };
  }
}
