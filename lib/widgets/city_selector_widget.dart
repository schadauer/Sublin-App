import 'package:Sublin/models/auth_class.dart';
import 'package:Sublin/models/delimiter_class.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/screens/address_input_screen.dart';
import 'package:Sublin/services/provider_user_service.dart';
import 'package:Sublin/services/user_service.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/utils/get_readable_part_of_formatted_address.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CitySelectorWidget extends StatefulWidget {
  bool providerAddress = false;
  String station = '';
  CitySelectorWidget({
    this.providerAddress,
    this.station,
  });
  @override
  _CitySelectorWidgetState createState() => _CitySelectorWidgetState();
}

class _CitySelectorWidgetState extends State<CitySelectorWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<Auth>(context);
    return FutureBuilder(
        future: widget.providerAddress == true
            ? ProviderUserService().getProviderUser(auth.uid)
            : UserService().getUser(auth.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && !_isLoading) {
            return Padding(
              padding: ThemeConstants.mediumPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  snapshot.data.communes.length != 0
                      ? Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.spaceBetween,
                          spacing: 10.0,
                          children:
                              snapshot.data.communes.map<Widget>((address) {
                            String city = getReadablePartOfFormattedAddress(
                                address, Delimiter.city);
                            return Chip(
                                padding: ThemeConstants.mediumPadding,
                                label: Text(city),
                                onDeleted: () {
                                  _removeCityFromCommunes(auth.uid, address);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                });
                          }).toList())
                      : Center(
                          child: Text('Noch keine Orte hinzugefügt'),
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RaisedButton(
                          child: Text('Ort hinzufügen'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddressInputScreen(
                                          addressInputCallback:
                                              _addCityToCommunesSelectionFunction,
                                          userUid: snapshot.data.uid,
                                          isEndAddress: false,
                                          isStartAddress: false,
                                          cityOnly: true,
                                          title: 'Ortschaft hinzufügen',
                                        )));
                            setState(() {
                              _isLoading = true;
                            });
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  void _addCityToCommunesSelectionFunction({
    String userUid,
    String input,
    String id,
    bool isCompany,
    bool isStartAddress,
    bool isEndAddress,
  }) async {
    dynamic _data;
    User _userData;
    ProviderUser _providerUser;
    if (widget.providerAddress == true) {
      _providerUser = await ProviderUserService().getProviderUser(userUid);
      _data = _providerUser;
    } else if (widget.providerAddress == false) {
      _userData = await UserService().getUser(userUid);

      _data = _userData;
      if (!_data.communes.contains(input)) {
        _data.communes.add(input);
      }
    }
    if (widget.providerAddress == true) {
      await ProviderUserService().setProviderUserData(
          providerUser: _providerUser, uid: _providerUser.uid);
      // For providers we nee also to add the addresses as station address

    } else if (widget.providerAddress == false) {
      await UserService().writeUserData(uid: userUid, data: _data);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _removeCityFromCommunes(String userUid, String address) async {
    dynamic _data;
    User _userData;
    ProviderUser _providerUser;
    if (widget.providerAddress == true) {
      _providerUser = await ProviderUserService().getProviderUser(userUid);
      _data = _providerUser;
    } else if (widget.providerAddress == false) {
      _userData = await UserService().getUser(userUid);
      _data = _userData;
    }
    if (_data.communes.contains(address)) {
      _data.communes.remove(address);
      (widget.providerAddress == true)
          ? await ProviderUserService().setProviderUserData(
              providerUser: _providerUser, uid: _providerUser.uid)
          : await UserService().writeUserData(uid: userUid, data: _userData);
    }
    setState(() {
      _isLoading = false;
    });
  }

  // void _addCityToStations(ProviderUser providerUser, String formattedAddress) {
  //   bool cityExists = false;
  //   providerUser.stations.map((station) {
  //     String cityFromFormattedAddress =
  //         getReadablePartOfFormattedAddress(formattedAddress, Delimiter.city);
  //     String cityFromStation =
  //         getReadablePartOfFormattedAddress(station, Delimiter.city);

  //     if (cityFromFormattedAddress == cityFromStation) {
  //       cityExists = true;
  //     }
  //   }).toList();
  //   if (cityExists == false) {
  //     setState(() {
  //       providerUser.stations.add(formattedAddress + widget.station);
  //       providerUser.communes.add(formattedAddress);
  //     });
  //   }
  // }
}
