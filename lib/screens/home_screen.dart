import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sublin/models/auth.dart';
import 'package:sublin/models/provider_user.dart';
import 'package:sublin/models/user.dart';
import 'package:sublin/screens/provider/provider_home_screen.dart';
import 'package:sublin/screens/user/user_home_screen.dart';
import 'package:sublin/widgets/loading_widget.dart';
import 'package:sublin/widgets/provider_bottom_navigation_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/homeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    final user = Provider.of<User>(context);
    final providerUser = Provider.of<ProviderUser>(context);

    print(auth.uid);

    if (user.streamingOn == false && providerUser.streamingOn == false)
      return Loading();

    if (providerUser.isProvider) return ProviderHomeScreen();

    return Scaffold(
        // bottomNavigationBar: providerUser.isProvider
        //     ? ProviderBottomNavigationBarWidget()
        //     : null,
        body: Stack(
      children: <Widget>[
        UserHomeScreen(),
      ],
    ));
  }
}
