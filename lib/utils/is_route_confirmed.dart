import 'package:Sublin/models/direction_enum.dart';
import 'package:Sublin/models/routing.dart';
import 'package:Sublin/utils/is_sublin_available.dart';

bool isRouteConfirmed(Routing routing) {
  bool sublinStartIsConfirmed = false;
  bool sublinEndIsConfirmed = false;
  if (isSublinAvailable(Direction.start, routing) &&
          routing.sublinStartStep.confirmed ||
      !isSublinAvailable(Direction.start, routing))
    sublinStartIsConfirmed = true;
  if (isSublinAvailable(Direction.end, routing) &&
          routing.sublinEndStep.confirmed ||
      !isSublinAvailable(Direction.end, routing)) sublinEndIsConfirmed = true;
  return sublinStartIsConfirmed == true && sublinEndIsConfirmed == true;
}
