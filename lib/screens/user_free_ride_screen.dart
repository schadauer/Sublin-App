import 'package:Sublin/models/user.dart';
import 'package:Sublin/models/user_type.dart';
import 'package:Sublin/services/auth_service.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/bottom_navigation_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserFreeRideScreen extends StatefulWidget {
  static const routeName = './userFreeRidecreenState';
  @override
  _UserFreeRideScreenState createState() => _UserFreeRideScreenState();
}

class _UserFreeRideScreenState extends State<UserFreeRideScreen> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);

    return Scaffold(
      bottomNavigationBar:
          BottomNavigationBarWidget(isProvider: user.userType != UserType.user),
      appBar: AppbarWidget(title: 'Deine Freifahrten'),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                FlatButton(
                  onPressed: () => AuthService().signOut(),
                  child: Text('Ausloggen'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
