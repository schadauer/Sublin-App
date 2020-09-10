import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/models/user_type_enum.dart';
import 'package:Sublin/services/auth_service.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/navigation_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderPartnerScreen extends StatefulWidget {
  static const routeName = './providerPartnerScreenState';
  @override
  _ProviderPartnerScreenState createState() => _ProviderPartnerScreenState();
}

class _ProviderPartnerScreenState extends State<ProviderPartnerScreen> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);

    return Scaffold(
      bottomNavigationBar:
          NavigationBarWidget(isProvider: user.userType != UserType.user),
      appBar: AppbarWidget(title: 'Partner'),
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
