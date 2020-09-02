import 'package:Sublin/models/user.dart';
import 'package:Sublin/models/user_type.dart';
import 'package:Sublin/services/auth_service.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/bottom_navigation_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderTargetGroupScreen extends StatefulWidget {
  static const routeName = './providerTargetGroupScreenState';
  @override
  _ProviderTargetGroupScreenState createState() =>
      _ProviderTargetGroupScreenState();
}

class _ProviderTargetGroupScreenState extends State<ProviderTargetGroupScreen> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);

    return Scaffold(
      bottomNavigationBar:
          BottomNavigationBarWidget(isProvider: user.userType != UserType.user),
      appBar: AppbarWidget(title: 'Zielgruppe'),
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
