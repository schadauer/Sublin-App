import 'package:Sublin/models/preferences_enum.dart';
import 'package:Sublin/services/shared_preferences_service.dart';

Future<void> sublinLogging(Preferences type) async {
  try {
    int value = await getIntValuesSF(type);
    await addIntToSF(type, 1);
    print(type.toString() + ' ' + (value + 1).toString());
  } catch (e) {
    print('Logging failed' + e);
  }
}

Future<void> removeSublinLogging(Preferences type) async {
  try {
    await removeFromSF(type);
  } catch (e) {
    print('Remove logging failed' + e);
  }
}
