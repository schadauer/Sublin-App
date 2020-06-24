import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sublin/models/auth.dart';
import 'package:sublin/models/provider_user.dart';
import 'package:sublin/models/user.dart';
import 'package:sublin/models/provider_user.dart';
import 'package:sublin/services/auth_service.dart';
import 'package:sublin/services/provider_service.dart';
import 'package:sublin/widgets/drawer_side_navigation_widget.dart';
import 'package:sublin/widgets/provider_bottom_navigation_bar_widget.dart';

class ProviderHomeScreen extends StatefulWidget {
  static const routeName = '/providerHomeScreen';
  @override
  _ProviderHomeScreenState createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> {
  final AuthService authService = AuthService();
  ProviderService providerService = ProviderService();
  // ProviderUser providerUserData = ProviderUser();
  TimeOfDay _timeEnd;
  TimeOfDay _timeStart;

  @override
  void initState() {
    _timeEnd = TimeOfDay.now();
    _timeStart = TimeOfDay.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    final user = Provider.of<User>(context);
    final providerUser = Provider.of<ProviderUser>(context);

    return Scaffold(
        bottomNavigationBar: providerUser.isProvider
            ? ProviderBottomNavigationBarWidget()
            : null,
        appBar: AppBar(
          title: Text('Dein Setup'),
        ),
        endDrawer: DrawerSideNavigationWidget(authService: authService),
        body: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  TextFormField(
                      decoration: InputDecoration(
                    hintText: 'Dein Betriebsname',
                    prefixIcon: Icon(Icons.account_circle,
                        color: Theme.of(context).accentColor),
                  )),
                  GestureDetector(
                      onTap: () => _pickTime(), child: Text('adsfdfs')),
                ],
              ),
            ),
          ],
        ));
  }

  _pickTime() async {
    TimeOfDay time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 10, minute: 47),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );

    if (time != null) {}
  }
}
