import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sublin/models/auth.dart';
import 'package:sublin/models/provider_user.dart';
import 'package:sublin/models/time.dart';
import 'package:sublin/models/user.dart';
// import 'package:sublin/models/provider_user.dart';
import 'package:sublin/services/auth_service.dart';
import 'package:sublin/services/provider_service.dart';
import 'package:sublin/widgets/drawer_side_navigation_widget.dart';
import 'package:sublin/widgets/header_widget.dart';

import 'package:sublin/widgets/provider_bottom_navigation_bar_widget.dart';
import 'package:sublin/widgets/input/time_field_widget.dart';

class ProviderHomeScreen extends StatefulWidget {
  static const routeName = '/providerHomeScreen';
  @override
  _ProviderHomeScreenState createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> {
  final AuthService authService = AuthService();
  ProviderService providerService = ProviderService();
  // ProviderUser providerUserData = ProviderUser();
  DateTime _timeEnd;
  DateTime _timeStart;
  String _providerName;

  @override
  void initState() {
    setState(() {
      _providerName = '';
    });
    // _timeEnd = TimeOfDay.now();
    // _timeStart = TimeOfDay.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    final user = Provider.of<User>(context);
    final providerUser = Provider.of<ProviderUser>(context);

    print(providerUser.providerName);

    return Scaffold(
        bottomNavigationBar: providerUser.isProvider
            ? ProviderBottomNavigationBarWidget()
            : null,
        endDrawer: DrawerSideNavigationWidget(authService: authService),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(delegate: HeaderWidget(name: _providerName)),
            SliverList(
                delegate: SliverChildListDelegate([
              Container(
                height: 400,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: <Widget>[
                          if (providerUser.providerName == '')
                            TextFormField(
                                onChanged: (val) {
                                  print(val);
                                },
                                decoration: InputDecoration(
                                  hintText: 'Dein Betriebsname',
                                  prefixIcon: Icon(Icons.account_circle,
                                      color: Theme.of(context).accentColor),
                                )),
                          Row(
                            children: <Widget>[
                              Expanded(child: Divider()),
                              Text(
                                'Betriebszeiten',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => null, // _pickTime(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(flex: 1, child: Text('Von')),
                                Flexible(
                                    flex: 2,
                                    child: TimeFildWidget(
                                      timespan: Timespan.start,
                                      timeInputFunction: _timeInputFunction,
                                    )),
                                Flexible(flex: 1, child: Text('Bis')),
                                Flexible(
                                    flex: 2,
                                    child: TimeFildWidget(
                                      timespan: Timespan.end,
                                      timeInputFunction: _timeInputFunction,
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]))
          ],
        ));
  }

  _timeInputFunction(Timespan timespan, time) {
    setState(() {
      if (timespan == Timespan.start) {
        setState(() {
          _timeStart = time;
        });
      } else if (timespan == Timespan.end) {
        setState(() {
          _timeEnd = time;
        });
      }
    });
    print(timespan);
    print(time);
  }
}
