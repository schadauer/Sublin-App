import 'package:Sublin/models/user_type_enum.dart';

String getReadableUserType(UserType userType) {
  switch (userType) {
    case UserType.provider:
      return 'Anbieter';
      break;
    case UserType.sponsor:
      return 'Auftraggeber/Sponsor';
      break;
    case UserType.user:
      return 'Privater Benutzer';
  }
}
