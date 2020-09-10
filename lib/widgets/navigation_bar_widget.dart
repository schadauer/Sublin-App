import 'package:Sublin/models/preferences_enum.dart';
import 'package:Sublin/models/provider_type.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/screens/provider_booking_screen.dart';
import 'package:Sublin/screens/provider_partner_screen.dart';
import 'package:Sublin/screens/provider_target_group_screen.dart';
import 'package:Sublin/screens/user_request_screen.dart';
import 'package:Sublin/screens/user_profile_screen.dart';
import 'package:Sublin/screens/user_my_sublin_screen.dart';
import 'package:Sublin/screens/user_routing_screen.dart';
import 'package:Sublin/services/shared_preferences_service.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:flutter/material.dart';

class NavigationBarWidget extends StatefulWidget {
  final bool isProvider;
  final User user;
  final ProviderUser providerUser;

  const NavigationBarWidget({
    this.isProvider = false,
    this.user,
    this.providerUser,
    Key key,
  }) : super(key: key);

  @override
  _NavigationBarWidgetState createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  int _currentIndex;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
        future: _getCurrentIndex(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              widget.isProvider != null) {
            _currentIndex = snapshot.data;

            if (widget.isProvider == true) {
              return BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                // This is the bottom navigation for providers
                onTap: (index) async {
                  print('index');
                  print(index);
                  print(_currentIndex);
                  try {
                    if (index == 0 && _currentIndex != 0) {
                      await _setCurrentIndex(0);
                      Navigator.of(context)
                          .push(_createRoute(ProviderBookingScreen()));
                    }
                    if (index == 1 && _currentIndex != 1) {
                      await _setCurrentIndex(1);
                      Navigator.of(context)
                          .push(_createRoute(ProviderTargetGroupScreen()));
                    }
                    if (index == 2 && _currentIndex != 2) {
                      print('click');
                      await _setCurrentIndex(2);
                      Navigator.of(context)
                          .push(_createRoute(ProviderPartnerScreen()));
                    }
                    if (index != _currentIndex) {
                      setState(() {
                        _currentIndex = index;
                      });
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.assignment_late),
                    title: Text('Aufträge'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.assignment_late),
                    title: Text('Zielgruppe'),
                  ),
                  if (widget.providerUser == null ||
                      widget.providerUser?.providerType !=
                          ProviderType.sponsorShuttle)
                    BottomNavigationBarItem(
                      icon: Icon(Icons.assignment_late),
                      title: Text('Partner'),
                    ),
                ],
                currentIndex: _currentIndex,
                selectedItemColor: Colors.amber[800],
              );
            } else if (widget.isProvider == false) {
              return BottomNavigationBar(
                // This is the navigation for user -------------------------------------
                onTap: (index) async {
                  try {
                    if (index == 0 && _currentIndex != 0) {
                      await _setCurrentIndex(0);
                      await Navigator.of(context)
                          .push(_createRoute(UserMySublinScreen()));
                    }
                    if (index == 1 && _currentIndex != 1) {
                      await _setCurrentIndex(1);
                      if (await getBoolValuesSF(Preferences.boolHasRatedTrip))
                        await Navigator.of(context)
                            .push(_createRoute(UserRequestScreen()));
                      else
                        await Navigator.of(context)
                            .push(_createRoute(UserRoutingScreen()));
                    }
                    if (index == 2 && _currentIndex != 2) {
                      await _setCurrentIndex(2);
                      await Navigator.of(context)
                          .push(_createRoute(UserProfileScreen()));
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.turned_in_not),
                    title: Text('Mein Sublin'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    title: Text('Meine Fahrt'),
                  ),
                  // BottomNavigationBarItem(
                  //   icon: Icon(Icons.assignment),
                  //   title: Text('Meine Freunde'),
                  // ),
                ],
                currentIndex: _currentIndex,
                selectedItemColor: ThemeConstants.sublinMainColor,
              );
            } else {
              return LinearProgressIndicator();
            }
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Future<void> _setCurrentIndex(int currentIndex) async {
    await addIntToSF(Preferences.intCurrentScreen, currentIndex);
    int _currentIndexFromSharedServices =
        await getIntValuesSF(Preferences.intCurrentScreen);
    setState(() {
      _currentIndex = _currentIndexFromSharedServices;
    });
  }

  Future<int> _getCurrentIndex() async {
    int _currentIndexFromSharedServices =
        await getIntValuesSF(Preferences.intCurrentScreen);
    return _currentIndexFromSharedServices;
  }
}

Route _createRoute(Widget widget) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
