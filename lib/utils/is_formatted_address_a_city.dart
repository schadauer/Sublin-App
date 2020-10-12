// * Both strings have to be formatted addresses
import 'package:Sublin/models/delimiter_class.dart';

bool isFormattedAddressACity({
  String formattedAddress,
}) {
  if (formattedAddress.contains(Delimiter.street) ||
      formattedAddress.contains(Delimiter.company) ||
      formattedAddress.contains(Delimiter.station))
    return false;
  else
    return true;
}
