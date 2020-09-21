import 'dart:io';
import 'package:Sublin/models/delimiter_class.dart';
import 'package:Sublin/models/provider_type.dart';
import 'package:Sublin/screens/address_input_screen.dart';
import 'package:Sublin/services/provider_user_service.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/utils/add_city_to_station_and_communes.dart';
import 'package:Sublin/utils/add_string_to_list.dart';
import 'package:Sublin/utils/get_formatted_city_from_formatted_station.dart';
import 'package:Sublin/utils/get_formatted_station_from_formatted_address.dart';
import 'package:Sublin/utils/get_list_of_cities_from_a_station.dart';
import 'package:Sublin/utils/get_list_of_stations.dart';
import 'package:Sublin/utils/get_readable_city_formatted_address.dart';
import 'package:Sublin/utils/get_readable_part_of_formatted_address.dart';
import 'package:Sublin/utils/remove_city_from_stations_And_Communes.dart';
import 'package:Sublin/widgets/provider_operation_time_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;

import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/models/user_type_enum.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/navigation_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderSettingsScreen extends StatefulWidget {
  static const routeName = './providerScopeScreenState';
  @override
  _ProviderSettingsScreenState createState() => _ProviderSettingsScreenState();
}

class _ProviderSettingsScreenState extends State<ProviderSettingsScreen> {
  // File _image;
  final picker = ImagePicker();
  ProviderUser _providerUser;
  String _selectedStation;
  TextEditingController _providerNameFormFieldController =
      TextEditingController();

  @override
  void initState() {
    _providerNameFormFieldController.text = _providerUser.providerName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _providerUser = Provider.of<ProviderUser>(context);

    final User user = Provider.of<User>(context);

    return Scaffold(
      bottomNavigationBar: NavigationBarWidget(
        isProvider: user.userType != UserType.user,
        setNavigationIndex: 1,
        providerUser: _providerUser,
      ),
      appBar: AppbarWidget(title: 'Mein Service', showProfileIcon: false),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(children: <Widget>[
                    TextFormField(
                        validator: (val) => val.length < 3
                            ? 'Bitte gib hier deinen Unternehmensnamen ein'
                            : null,
                        controller: _providerNameFormFieldController,
                        onChanged: (val) {
                          setState(() {
                            _providerUser.providerName = val;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Dein Unternehmensname',
                          prefixIcon: Icon(Icons.account_circle,
                              color: Theme.of(context).accentColor),
                        )),
                  ]),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: getListOfStations(_providerUser).length,
                  itemBuilder: (BuildContext context, int index) {
                    List<String> _stations = getListOfStations(_providerUser);
                    String _station = _stations[index];
                    return Card(
                        child: Padding(
                      padding: ThemeConstants.largePadding,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getReadablePartOfFormattedAddress(
                                _station, Delimiter.station),
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          SizedBox(height: 10),
                          AutoSizeText(
                            'Folgende Ortschaften werden über diesen Bahnhof bedient:',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          SizedBox(height: 10),
                          Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.spaceBetween,
                            spacing: 6.0,
                            children: getListOfCitiesFromAStation(
                                    _providerUser, _station)
                                .map((city) {
                              return Chip(
                                  onDeleted: () async {
                                    ProviderUserService().setProviderUserData(
                                        data: removeCityFromStationsAndCommunes(
                                            city: city,
                                            providerUser: _providerUser));
                                    // ProviderUser _providerUserTemp =
                                    //     _removeCityFromStationsAndCommunes(
                                    //         city: city,
                                    //         providerUser: _providerUser);
                                  },
                                  padding: ThemeConstants.mediumPadding,
                                  label: Text(getReadablePartOfFormattedAddress(
                                      city, Delimiter.city)));
                            }).toList(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                child: FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        _selectedStation = _station;
                                      });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddressInputScreen(
                                                    addressInputCallback:
                                                        _citySelectionCallback,
                                                    isEndAddress: false,
                                                    isStartAddress: false,
                                                    cityOnly: true,
                                                    title:
                                                        'Ortschaft hinzufügen',
                                                  )));
                                    },
                                    child:
                                        Text('Weitere Ortschaften Hinzufügen')),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ));
                  }),
            ),
            ProviderOperationTimeWidget(
              providerUser: _providerUser,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _citySelectionCallback({
    String userUid,
    String input,
    String id,
    bool isCompany,
    bool isStartAddress,
    bool isEndAddress,
  }) async {
    setState(() {
      _providerUser = addCityToStationsAndCommunes(
          cityFormattedAddress: input,
          stationFormattedAddress: _selectedStation,
          providerUser: _providerUser);
    });
    print(_providerUser.stations);
    await ProviderUserService().setProviderUserData(data: _providerUser);
  }
}
