String getEmailInitials(String email) {
  int _atPosition = email.indexOf('@') + 1;
  String _initials =
      email.substring(0, 1) + email.substring(_atPosition, _atPosition + 1);
  return _initials.toUpperCase();
}
