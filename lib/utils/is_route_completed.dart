import 'package:Sublin/models/direction.dart';
import 'package:Sublin/models/routing.dart';
import 'package:Sublin/utils/is_sublin_available.dart';

bool isRouteCompleted(Routing routing) {
  bool sublinStartIsCompleted = false;
  bool sublinEndIsCompleted = false;
  if (isSublinAvailable(Direction.start, routing) &&
          routing.sublinStartStep.completed ||
      !isSublinAvailable(Direction.start, routing))
    sublinStartIsCompleted = true;
  if (isSublinAvailable(Direction.end, routing) &&
          routing.sublinEndStep.completed ||
      !isSublinAvailable(Direction.end, routing)) sublinEndIsCompleted = true;
  return sublinStartIsCompleted == true && sublinEndIsCompleted == true;
}
