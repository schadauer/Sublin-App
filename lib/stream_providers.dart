import 'package:Sublin/screens/update_required_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info/package_info.dart';

import 'package:Sublin/models/booking_completed_class.dart';
import 'package:Sublin/models/booking_confirmed_class.dart';
import 'package:Sublin/models/booking_open_class.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/init_routes.dart';
import 'package:Sublin/models/versioning_class.dart';
import 'package:Sublin/screens/user_register_screen.dart';
import 'package:Sublin/services/booking_service.dart';
import 'package:Sublin/services/provider_user_service.dart';
import 'package:Sublin/services/user_service.dart';
import 'package:Sublin/models/routing_class.dart';
import 'package:Sublin/models/auth_class.dart';
import 'package:Sublin/services/routing_service.dart';
import 'package:Sublin/theme/theme.dart';

class StreamProviders extends StatelessWidget {
  final PackageInfo packageInfo;
  StreamProviders({this.packageInfo});
  static const routeName = '/wrapper';

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    final versioning = Provider.of<Versioning>(context);

    bool _appNeedsToBeUpdated() {
      String _minVersion = versioning.minVersion;
      String _thisVersion = packageInfo.version;
      for (var i = 0; i < 3; i++) {
        int _thisNumber;
        int _minNumber;
        if (i < 2) {
          _thisNumber = _thisVersion.indexOf('.');
          _minNumber = _minVersion.indexOf('.');
        } else {
          _thisNumber = _thisVersion.length;
          _minNumber = _minVersion.length;
        }
        if (int.parse(_thisVersion.substring(0, _thisNumber)) <
            int.parse(_minVersion.substring(0, _minNumber))) {
          return true;
        }
        if (i < 2) {
          _thisVersion =
              _thisVersion.substring(_thisNumber + 1, _thisVersion.length);
          _minVersion =
              _minVersion.substring(_minNumber + 1, _minVersion.length);
        }
      }
      return false;
    }

    if (auth == null || versioning == null) {
      // If auth is not logged in show Authentication screen
      return MaterialApp(
        theme: themeData(context),
        home: UserRegisterScreen(),
      );
    } else if (_appNeedsToBeUpdated()) {
      return MaterialApp(
        theme: themeData(context),
        home: UpdateRequiredScreen(),
      );
    } else {
      return MultiProvider(providers: [
        StreamProvider<Routing>.value(
          initialData: Routing(),
          value: RoutingService().streamRouting(auth.uid),
          catchError: (_, err) {
            print(err);
            return Routing();
          },
          lazy: true,
        ),
        StreamProvider<User>.value(
          initialData: User.initialData(),
          value: UserService().streamUser(auth.uid),
          catchError: (_, err) => User.initialData(),
          lazy: true,
        ),
        StreamProvider<List<BookingOpen>>.value(
          initialData: [],
          value: BookingService().streamOpenBookings(auth.uid),
          lazy: true,
        ),
        StreamProvider<List<BookingConfirmed>>.value(
          initialData: [],
          value: BookingService().streamConfirmedBookings(auth.uid),
          lazy: true,
        ),
        StreamProvider<List<BookingCompleted>>.value(
          initialData: [],
          value: BookingService().streamCompletedBookings(auth.uid),
          lazy: true,
        ),
        StreamProvider<ProviderUser>.value(
          initialData: ProviderUser(),
          value: ProviderUserService().streamProviderUser(auth.uid),
          lazy: true,
          catchError: (_, err) {
            print('Provider user error' + err);
            return ProviderUser();
          },
        )
      ], child: InitRoutes());
    }
  }
}
