import 'package:Sublin/models/preferences_enum.dart';
import 'package:Sublin/models/provider_type_enum.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/screens/provider_booking_screen.dart';
import 'package:Sublin/screens/provider_partner_screen.dart';
import 'package:Sublin/screens/provider_settings_screen.dart';
import 'package:Sublin/screens/provider_target_group_screen.dart';
import 'package:Sublin/screens/user_my_sublin_screen.dart';
import 'package:Sublin/screens/user_routing_screen.dart';
import 'package:Sublin/services/shared_preferences_service.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:flutter/material.dart';

class NavigationBarWidget extends StatefulWidget {
  final int setNavigationIndex;
  final bool isProvider;
  final User user;
  final ProviderUser providerUser;

  const NavigationBarWidget({
    this.setNavigationIndex,
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
  ProviderUser _providerUser;

  @override
  void initState() {
    _currentIndex = widget.setNavigationIndex;
    _providerUser = widget.providerUser ?? ProviderUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.isProvider == true)
        ? BottomNavigationBar(
            selectedIconTheme: IconThemeData(
              color: ThemeConstants.sublinMainColor,
            ),
            selectedLabelStyle: TextStyle(
              color: ThemeConstants.sublinMainColor,
            ),
            type: BottomNavigationBarType.fixed,
            // ----------------- This is the bottom navigation for providers ------------------
            onTap: (index) async {
              try {
                if (index == 0 && _currentIndex != 0) {
                  Navigator.of(context)
                      .push(_createRoute(ProviderBookingScreen()));
                }
                if (index == 1 && _currentIndex != 1) {
                  Navigator.of(context)
                      .push(_createRoute(ProviderSettingsScreen()));
                }
                if (index == 2 && _currentIndex != 2) {
                  if (widget.providerUser?.providerType != ProviderType.taxi)
                    Navigator.of(context)
                        .push(_createRoute(ProviderTargetGroupScreen()));
                  else
                    Navigator.of(context)
                        .push(_createRoute(ProviderPartnerScreen()));
                }
                if (index == 3 && _currentIndex != 3) {
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
                icon: Icon(Icons.departure_board),
                label: 'Aufträge',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check_circle),
                label: 'Einstellungen',
              ),
              if (widget.providerUser?.providerType != ProviderType.taxi)
                BottomNavigationBarItem(
                  icon: Icon(Icons.group),
                  label: 'Zielgruppe',
                ),
              if (widget.providerUser == null ||
                  _providerUser?.providerType != ProviderType.shuttle)
                BottomNavigationBarItem(
                  icon: Icon(Icons.verified_user),
                  label: 'Partner',
                ),
            ],
            currentIndex: _currentIndex,
            selectedItemColor: ThemeConstants.sublinMainColor,
          )
        : BottomNavigationBar(
            // This is the navigation for user -------------------------------------
            onTap: (index) async {
              try {
                if (index == 0 && _currentIndex != 0) {
                  await Navigator.of(context)
                      .push(_createRoute(UserMySublinScreen()));
                }
                if (index == 1 && _currentIndex != 1) {
                  if (await getBoolValuesSF(Preferences.boolHasRatedTrip))
                    await Navigator.of(context)
                        .push(_createRoute(UserRoutingScreen()));
                  else
                    await Navigator.of(context)
                        .push(_createRoute(UserRoutingScreen()));
                }
              } catch (e) {
                print(e);
              }
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.turned_in_not),
                label: 'Meine Shuttles',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_taxi),
                label: 'Meine Fahrt',
              ),
              // BottomNavigationBarItem(
            ],
            currentIndex: _currentIndex,
            selectedItemColor: ThemeConstants.sublinMainColor,
          );
  }
}

Route _createRoute(Widget widget) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // var begin = Offset(0.0, 0.5);
      // var end = Offset.zero;
      // var curve = Curves.ease;
      // var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
