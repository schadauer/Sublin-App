import 'package:Sublin/models/direction_enum.dart';
import 'package:Sublin/models/routing_class.dart';

bool isSublinAvailable(Direction direction, Routing routing) {
  if (direction == Direction.start)
    return routing.startAddressAvailable;
  else if (direction == Direction.end)
    return routing.endAddressAvailable;
  else
    return false;
}
