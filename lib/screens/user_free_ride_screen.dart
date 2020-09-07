import 'package:Sublin/models/auth.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/user.dart';
import 'package:Sublin/models/user_type.dart';
import 'package:Sublin/services/provider_service.dart';
import 'package:Sublin/services/user_service.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/bottom_navigation_bar_widget.dart';
import 'package:Sublin/widgets/city_selector.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserFreeRideScreen extends StatefulWidget {
  static const routeName = './userFreeRidecreenState';
  @override
  _UserFreeRideScreenState createState() => _UserFreeRideScreenState();
}

class _UserFreeRideScreenState extends State<UserFreeRideScreen> {
  User _user;
  bool _loadAddress = false;
  bool _changedAddress = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<Auth>(context);
    final User user = Provider.of<User>(context);

    return Scaffold(
      bottomNavigationBar:
          BottomNavigationBarWidget(isProvider: user.userType != UserType.user),
      appBar: AppbarWidget(title: 'Deine Freifahrten'),
      floatingActionButton: MyFloatingActionButton(user: user),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: FutureBuilder<List<ProviderUser>>(
                    future: ProviderService().getProviders(user.communes),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        snapshot.data
                            .map((e) => print(e.providerName))
                            .toList();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            // if (user.homeAddress == '')
                            AutoSizeText(
                              'Bitte gib deine Orte an, die du gerne ohne eigenes Auto besuchen möchtest. Sobald Angebote für diese Orte verfügbar sind, wirst du hier benachrichtigt',
                              style: Theme.of(context).textTheme.bodyText1,
                              maxLines: 8,
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            // ),
                          ],
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addressInputFunction(
      {String userUid,
      String input,
      String id,
      bool isCompany,
      List<dynamic> terms,
      bool isStartAddress,
      bool isEndAddress}) async {
    setState(() {
      _loadAddress = true;
    });
    await UserService().updateHomeAddress(uid: userUid, address: input);
    // _user = await _getUser(userUid);
    setState(() {
      _loadAddress = false;
    });
  }

  Future<User> _getUser(userUid) async {
    return await UserService().getUser(userUid);
  }
}

class MyFloatingActionButton extends StatelessWidget {
  final User user;
  MyFloatingActionButton({this.user});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      label: Text(
        'Orte hinzufügen',
        style: Theme.of(context).textTheme.headline1,
      ),
      elevation: 1.0,
      icon: Icon(Icons.add),
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      onPressed: () {
        showBottomSheet(
            context: context,
            builder: (context) => Container(
                  child: CitySelector(
                    providerAddress: false,
                  ),
                ));
      },
    );
  }
}
