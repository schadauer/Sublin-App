/* Copyright (C) 2020 Andreas Schadauer, andreas@sublin.app - All Rights Reserved */

import 'dart:convert';
import 'package:Sublin/models/auth_class.dart';
import 'package:Sublin/models/delimiter_class.dart';
import 'package:Sublin/models/provider_type.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/models/user_type_enum.dart';
import 'package:Sublin/screens/address_input_screen.dart';
import 'package:Sublin/services/provider_service.dart';
import 'package:Sublin/services/provider_user_service.dart';
import 'package:Sublin/services/user_service.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/utils/get_city_formatted_address.dart';
import 'package:Sublin/utils/get_formatted_city_from_provider_user_addresses.dart';
import 'package:Sublin/utils/get_readable_part_of_formatted_address.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/navigation_bar_widget.dart';
import 'package:Sublin/widgets/floating_button_add_cities_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crypto/crypto.dart';

enum Filter { taxisOnly, excludeTaxis }
enum CardType { available, unavailable, add }

class UserMySublinScreen extends StatefulWidget {
  static const routeName = './userFreeRidecreenState';
  @override
  _UserMySublinScreenState createState() => _UserMySublinScreenState();
}

class _UserMySublinScreenState extends State<UserMySublinScreen> {
  User _user;
  bool _loadAddress = false;
  bool _changedAddress = false;
  int _lengthProviderUsersOfAvailables;
  int _lengthProviderUsersWithUnavailables;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    bool _cityAdded = false;

    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 2;

    // void isBottomSheetClosedCallback(bool value) {
    //   setState(() {
    //     _cityAdded = true;
    //   });
    // }

    return Scaffold(
      bottomNavigationBar:
          NavigationBarWidget(isProvider: user.userType != UserType.user),
      appBar: AppbarWidget(title: 'Mein Sublin'),
      // floatingActionButton: FloatingButtonAddCities(
      //     user: user, isBottomSheetClosedCallback: isBottomSheetClosedCallback),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Padding(
          padding: ThemeConstants.mediumPadding,
          child: FutureBuilder<List<List<ProviderUser>>>(
              // future: ProviderService().getProviders(communes: user.communes),
              future: Future.wait([
                ProviderService().getProviders(communes: user.communes),
                ProviderService().getProvidersEmailOnly(email: user.email),
              ]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data.length != 0) {
                  // Get all available addresses excluding taxis and add one element for user to add new cities
                  List<ProviderUser> _providerUsersExcludeTaxis =
                      _addUserProviderForUserToAddCity(
                          _applyFilterFromListOfAll(
                              [...snapshot.data[0], ...snapshot.data[1]],
                              Filter.excludeTaxis));
                  _lengthProviderUsersOfAvailables =
                      _providerUsersExcludeTaxis.length - 1;
                  // Now let's add all unavailable cities which are inactive for the user to view
                  List<ProviderUser> _providerUsersWithUnavailables =
                      _addUnavailableCitiesToList(
                          user, _providerUsersExcludeTaxis);
                  _lengthProviderUsersWithUnavailables =
                      _providerUsersWithUnavailables.length;
                  return Column(
                    children: [
                      Expanded(
                        child: Card(
                          color: ThemeConstants.backgroundColor,
                          child: Padding(
                            padding: ThemeConstants.mediumPadding,
                            child: AutoSizeText(
                              'Bei diesen Adressen ist für dich ein kostenloses Abholservice möglich',
                              style: Theme.of(context).textTheme.bodyText1,
                              // textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        flex: 10,
                        child: GridView.builder(
                          itemCount: _lengthProviderUsersWithUnavailables,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: (itemWidth / itemHeight),
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            ProviderUser _providerUser =
                                _providerUsersWithUnavailables[index];
                            CardType _cardType;
                            if (index < _lengthProviderUsersOfAvailables)
                              _cardType = CardType.available;
                            else if (index == _lengthProviderUsersOfAvailables)
                              _cardType = CardType.add;
                            else
                              _cardType = CardType.unavailable;
                            return _showCart(
                              providerUser: _providerUser,
                              itemWidth: itemWidth,
                              itemHeight: itemHeight,
                              user: user,
                              context: context,
                              cardType: _cardType,
                            );
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

  Container _showCart({
    ProviderUser providerUser,
    double itemWidth,
    double itemHeight,
    User user,
    BuildContext context,
    CardType cardType,
  }) {
    switch (cardType) {
      case CardType.available:
        return Container(
          child: Card(
              color: ThemeConstants.sublinMainBackgroundColor,
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Padding(
                padding: ThemeConstants.mediumPadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 100,
                      child: Container(
                          width: itemWidth / 2,
                          height: itemHeight / 2,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
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
                                  getFormattedCityFromListProviderUserAddresses(
                                      providerUser, user),
                                  Delimiter.city),
                              style: Theme.of(context).textTheme.headline1,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            AutoSizeText(
                              'Gesponsert von',
                              style: Theme.of(context).textTheme.caption,
                            ),
                            AutoSizeText(
                              providerUser.providerName,
                              style: Theme.of(context).textTheme.caption,
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
              )),
        );
        break;
      case CardType.add:
        return Container(
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddressInputScreen(
                            addressInputFunction:
                                _addCityToCommunesSelectionFunction,
                            userUid: user.uid,
                            isEndAddress: false,
                            isStartAddress: false,
                            cityOnly: true,
                            title: 'Ortschaft hinzufügen',
                          )));
            },
            child: Card(
                color: ThemeConstants.backgroundColor,
                child: Padding(
                  padding: ThemeConstants.mediumPadding,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        size: 70,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      AutoSizeText(
                        'Orte hinzufügen, die du gerne besuchen möchtest',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )),
          ),
        );
      case CardType.unavailable:
        return Container(
          child: Card(
              color: ThemeConstants.backgroundColor,
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Padding(
                padding: ThemeConstants.mediumPadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AutoSizeText(
                              'Für',
                              style: Theme.of(context).textTheme.caption,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            AutoSizeText(
                              providerUser.providerName,
                              style: Theme.of(context).textTheme.headline1,
                              maxLines: 2,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            AutoSizeText(
                              'gibt es leider noch keinen Sponsor',
                              style: Theme.of(context).textTheme.caption,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ))
                  ],
                ),
              )),
        );
        break;
    }
  }

  void _addCityToCommunesSelectionFunction({
    String userUid,
    String input,
    String id,
    bool isCompany,
    bool isStartAddress,
    bool isEndAddress,
  }) async {
    User _data;
    _data = await UserService().getUser(userUid);
    if (!_data.communes.contains(input)) {
      _data.communes.add(input);
    }
    await UserService().writeUserData(uid: userUid, data: _data);
    // }
    // setState(() {
    //   _isLoading = false;
    // });
  }

  Future<void> _addressInputFunction(
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

List<ProviderUser> _addUserProviderForUserToAddCity(
    List<ProviderUser> providerUserList) {
  int whereToInsert = providerUserList.length;
  ProviderUser _listWithAdditionalElement = ProviderUser();
  providerUserList.insert(whereToInsert, _listWithAdditionalElement);
  return providerUserList;
}

List<ProviderUser> _addUnavailableCitiesToList(
    User user, List<ProviderUser> providerUsersExcludeTaxis) {
  // First we need to filter out the addresses that are available
  List<ProviderUser> _providerUsersExcludeTaxisWithUnavailableCities = [
    ...providerUsersExcludeTaxis
  ];
  List<String> _addedAddresses = [];
  user.communes.forEach((commune) {
    providerUsersExcludeTaxis.forEach((providerUser) {
      bool _containsAddress = false;
      if (_addedAddresses.contains(commune)) _containsAddress = true;
      if (_containsAddress == false) {
        _addedAddresses.add(commune);
        _providerUsersExcludeTaxisWithUnavailableCities.add(ProviderUser(
            providerName:
                getReadablePartOfFormattedAddress(commune, Delimiter.city)));
      }
    });
  });
  return _providerUsersExcludeTaxisWithUnavailableCities;
}

List<ProviderUser> _applyFilterFromListOfAll(
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

String _getReadableTaxiFromListOfAllProviders(
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
