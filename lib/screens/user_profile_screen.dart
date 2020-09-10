import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/models/user_type_enum.dart';
import 'package:Sublin/services/auth_service.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/navigation_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  static const routeName = './userProfileScreenState';
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);

    return Scaffold(
      bottomNavigationBar:
          NavigationBarWidget(isProvider: user.userType != UserType.user),
      appBar: AppbarWidget(title: 'Dein Profil'),
      body: SafeArea(
        child: Column(
          children: [
            Container(
                height: 200,
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.face,
                          color: Theme.of(context).primaryColor,
                          size: 80,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        user.firstName,
                        style: Theme.of(context).textTheme.headline1,
                      )
                    ],
                  ),
                )),
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
