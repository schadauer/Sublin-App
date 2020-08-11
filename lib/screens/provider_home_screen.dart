import 'package:Sublin/models/delimiter.dart';
import 'package:Sublin/models/provider_type.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/user.dart';
import 'package:Sublin/services/auth_service.dart';
import 'package:Sublin/utils/get_part_of_formatted_address.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/drawer_side_navigation_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderHomeScreen extends StatefulWidget {
  static const routeName = './providerHomeScreen';
  @override
  _ProviderHomeScreenState createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final providerUser = Provider.of<ProviderUser>(context);
    final User user = Provider.of<User>(context);

    return Scaffold(
        appBar: AppbarWidget(title: 'Home'),
        endDrawer: DrawerSideNavigationWidget(
          authService: AuthService(),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // If the user is not yet approved as provider
              // if (providerUser.operationRequested && !providerUser.inOperation)
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${user.firstName}, du bist ein Star!',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (providerUser.providerType == ProviderType.taxi)
                              AutoSizeText(
                                'Du bist jetzt als das Taxi- oder Mietwagenunternehmen für ${getPartOfFormattedAddress(providerUser.addresses[0], Delimiter.city)} vorgemerkt.',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Card(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Center(
                              child: Text(
                            '0',
                            style: TextStyle(fontSize: 60),
                          )),
                          Center(
                              child: Text(
                            'Offene Aufträge',
                            style: Theme.of(context).textTheme.bodyText1,
                          )),
                        ],
                      ),
                    )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Card(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Center(
                              child: Text(
                            '0',
                            style: TextStyle(fontSize: 60),
                          )),
                          Center(
                              child: Text(
                            'Besätigte Aufträge',
                            style: Theme.of(context).textTheme.bodyText1,
                          )),
                        ],
                      ),
                    )),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
