import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/models/user_type_enum.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/navigation_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderScopeScreen extends StatefulWidget {
  static const routeName = './providerScopeScreenState';
  @override
  _ProviderScopeScreenState createState() => _ProviderScopeScreenState();
}

class _ProviderScopeScreenState extends State<ProviderScopeScreen> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);

    return Scaffold(
      bottomNavigationBar:
          NavigationBarWidget(isProvider: user.userType != UserType.user),
      appBar: AppbarWidget(title: 'Mein Service', showProfileIcon: false),
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
          ],
        ),
      ),
    );
  }
}
