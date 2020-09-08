/* Copyright (C) 2020 Andreas Schadauer, andreas@sublin.app - All Rights Reserved */

import 'package:Sublin/models/auth.dart';
import 'package:Sublin/models/delimiter.dart';
import 'package:Sublin/models/provider_type.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/user.dart';
import 'package:Sublin/models/user_type.dart';
import 'package:Sublin/services/provider_service.dart';
import 'package:Sublin/services/user_service.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/utils/get_city_formatted_address.dart';
import 'package:Sublin/utils/get_readable_part_of_formatted_address.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/bottom_navigation_bar_widget.dart';
import 'package:Sublin/widgets/floating_action_button_add_cities_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum Filter { taxisOnly, excludeTaxis }

class UserMySublinScreen extends StatefulWidget {
  static const routeName = './userFreeRidecreenState';
  @override
  _UserMySublinScreenState createState() => _UserMySublinScreenState();
}

class _UserMySublinScreenState extends State<UserMySublinScreen> {
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
    bool _cityAdded = false;

    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.5;
    final double itemWidth = size.width / 2;

    void isBottomSheetClosedCallback(bool value) {
      setState(() {
        _cityAdded = true;
      });
    }

    return Scaffold(
      bottomNavigationBar:
          BottomNavigationBarWidget(isProvider: user.userType != UserType.user),
      appBar: AppbarWidget(title: 'Mein Sublin'),
      floatingActionButton: FloatingActionButtonAddCities(
          user: user, isBottomSheetClosedCallback: isBottomSheetClosedCallback),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<List<ProviderUser>>(
              future: ProviderService().getProviders(user.communes),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data.length != 0) {
                  List<ProviderUser> providerUsersExcludeTaxis =
                      applyFilterFromListOfAll(
                          snapshot.data, Filter.excludeTaxis);
                  List<ProviderUser> providerUsersTaxisOnly =
                      applyFilterFromListOfAll(snapshot.data, Filter.taxisOnly);

                  // print(excludeTaxisFromListOfAll(providerUsers));
                  return Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Für dich sind kostenlose Transfers vom Bahnhof zu den Addressen möglich:',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                        fit: FlexFit.loose,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Expanded(
                        child: GridView.builder(
                          itemCount: providerUsersExcludeTaxis.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: (itemWidth / itemHeight),
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            ProviderUser _providerUser =
                                providerUsersExcludeTaxis[index];
                            return Card(
                                color: ThemeConstants.sublinMainBackgroundColor,
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        height: 100,
                                        child: Container(
                                            width: itemWidth / 2,
                                            height: itemHeight / 2,
                                            decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: new DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: new NetworkImage(
                                                        "https://dev.gemeindeserver.net/media/seitenstetten/1524150647-img-0151-jpg.jpeg")))),
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              AutoSizeText(
                                                getReadablePartOfFormattedAddress(
                                                    getReadableCityFromListOfUserCommuns(
                                                        _providerUser, user),
                                                    Delimiter.city),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline1,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              AutoSizeText(
                                                'Gesponsert von',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption,
                                              ),
                                              AutoSizeText(
                                                _providerUser.providerName,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption,
                                                maxLines: 2,
                                              ),
                                              // AutoSizeText(
                                              //   'Durchgeführt von',
                                              //   style: Theme.of(context)
                                              //       .textTheme
                                              //       .caption,
                                              // ),
                                              // AutoSizeText(
                                              //   getReadableTaxiFromListOfAllProviders(
                                              //       _providerUser,
                                              //       providerUsersTaxisOnly),
                                              //   style: Theme.of(context)
                                              //       .textTheme
                                              //       .caption,
                                              // )
                                            ],
                                          ))
                                    ],
                                  ),
                                ));
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
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

List<ProviderUser> applyFilterFromListOfAll(
    List<ProviderUser> providerUsers, Filter filter) {
  List<ProviderUser> _providerUsers;
  _providerUsers = providerUsers.where((providerUser) {
    bool isTrue = false;
    switch (filter) {
      case Filter.excludeTaxis:
        if (providerUser.providerType != ProviderType.taxi) isTrue = true;
        break;
      case Filter.taxisOnly:
        if (providerUser.providerType == ProviderType.taxi) isTrue = true;
    }
    return isTrue;
  }).toList();
  return _providerUsers;
}

String getReadableCityFromListOfUserCommuns(
    ProviderUser providerUser, User user) {
  String _formattedCityFromCommun;
  user.communes.forEach((address) {
    if (providerUser.addresses.contains(address))
      _formattedCityFromCommun = address;
  });
  return _formattedCityFromCommun;
}

String getReadableTaxiFromListOfAllProviders(
    ProviderUser providerUser, List<ProviderUser> providerUsersTaxiOnly) {
  String _taxi = '';

  providerUser.partners.forEach((partnerId) {
    providerUsersTaxiOnly.forEach((providerUser) {
      if (providerUser.uid == partnerId) {
        _taxi = providerUser.providerName;
      }
    });
  });
  return _taxi;
}
