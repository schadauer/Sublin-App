// import 'dart:io';
import 'package:Sublin/models/address_info_class.dart';
import 'package:Sublin/models/delimiter_class.dart';
import 'package:Sublin/models/provider_type_enum.dart';
import 'package:Sublin/screens/address_input_screen.dart';
import 'package:Sublin/services/provider_user_service.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/utils/add_city_to_station_and_communes.dart';
import 'package:Sublin/utils/get_list_of_cities_from_a_station.dart';
import 'package:Sublin/utils/get_list_of_stations.dart';
import 'package:Sublin/utils/get_readable_address_part_of_formatted_address.dart';
import 'package:Sublin/utils/remove_city_from_stations_And_Communes.dart';
import 'package:Sublin/widgets/provider_operation_time_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/models/user_type_enum.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/navigation_bar_widget.dart';
import 'package:provider/provider.dart';

class ProviderSettingsScreen extends StatefulWidget {
  static const routeName = './providerScopeScreenState';
  @override
  _ProviderSettingsScreenState createState() => _ProviderSettingsScreenState();
}

class _ProviderSettingsScreenState extends State<ProviderSettingsScreen> {
  // File _image;
  ProviderUser _providerUser;
  String _selectedStation;
  bool _editProviderName = false;
  TextEditingController _providerNameFormFieldController =
      TextEditingController();

  // @override
  // void initState() {
  //   _setProviderFormFieldValue();
  //   _providerNameFormFieldController.text = _providerUser.providerName;
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    ProviderUser _providerUser = Provider.of<ProviderUser>(context);
    final User _user = Provider.of<User>(context);

    return Scaffold(
      bottomNavigationBar: NavigationBarWidget(
        isProvider: _user.userType != UserType.user,
        setNavigationIndex: 1,
        providerUser: _providerUser,
      ),
      appBar: AppbarWidget(title: 'Einstellungen'),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: Builder(builder: (BuildContext context) {
                if (_providerNameFormFieldController.text == '')
                  _providerNameFormFieldController.text =
                      _providerUser.providerName;
                return Card(
                  child: Padding(
                    padding: ThemeConstants.largePadding,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          'Dein Betriebsname',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        SizedBox(height: 10),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Row(
                                children: [
                                  if (_editProviderName == false)
                                    Expanded(
                                        flex: 5,
                                        child:
                                            Text(_providerUser.providerName)),
                                  if (_editProviderName == true)
                                    Expanded(
                                      flex: 5,
                                      child: TextFormField(
                                          validator: (val) => val.length < 3
                                              ? 'Bitte gib hier deinen Unternehmensnamen ein'
                                              : null,
                                          controller:
                                              _providerNameFormFieldController,
                                          // onChanged: (val) {
                                          //   setState(() {
                                          //     _providerUser.providerName = val;
                                          //   });
                                          // },
                                          decoration: InputDecoration(
                                            hintText: 'Dein Unternehmensname',
                                            prefixIcon: Icon(
                                              Icons.home,
                                            ),
                                          )),
                                    ),
                                  if (_editProviderName == false)
                                    SizedBox(
                                      width: 40,
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _editProviderName = true;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              if (_editProviderName == true)
                                RaisedButton(
                                    onPressed: () async {
                                      await ProviderUserService()
                                          .updateProviderNameProviderUser(
                                              uid: _providerUser.uid,
                                              providerName:
                                                  _providerNameFormFieldController
                                                      .text);
                                      setState(() {
                                        _editProviderName = false;
                                      });
                                    },
                                    child: AutoSizeText('speichern')),
                            ]),
                      ],
                    ),
                  ),
                );
              }),
            ),
            ProviderOperationTimeWidget(
              providerUser: _providerUser,
            ),
            if (_providerUser.providerType == ProviderType.taxi)
              Expanded(
                child: getListOfStations(_providerUser).length != 0
                    ? ListView.builder(
                        itemCount: getListOfStations(_providerUser).length,
                        itemBuilder: (BuildContext context, int index) {
                          List<String> _stations =
                              getListOfStations(_providerUser);
                          String _station = _stations[index];
                          return Card(
                              child: Padding(
                            padding: ThemeConstants.largePadding,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  getReadableAddressPartOfFormattedAddress(
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
                                              providerUser:
                                                  removeCityFromStationsAndCommunes(
                                                      station: _station,
                                                      city: city,
                                                      providerUser:
                                                          _providerUser),
                                              uid: _providerUser.uid);
                                        },
                                        padding: ThemeConstants.mediumPadding,
                                        label: Text(
                                            getReadableAddressPartOfFormattedAddress(
                                                city, Delimiter.city)));
                                  }).toList(),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      child: FlatButton(
                                          textColor:
                                              ThemeConstants.sublinMainColor,
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
                                                          providerUser:
                                                              _providerUser,
                                                          station:
                                                              _selectedStation,
                                                        )));
                                          },
                                          child: Text(
                                              'Weitere Ortschaften Hinzufügen')),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ));
                        })
                    : Card(child: Text('Keinen Bahnhof bestimmt')),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _citySelectionCallback({
    String userUid,
    User user,
    String input,
    String id,
    bool isCompany,
    bool isStartAddress,
    bool isEndAddress,
    ProviderUser providerUser,
    AddressInfo addressInfo,
    String station,
  }) async {
    setState(() {
      _providerUser = addCityToStationsAndCommunes(
          cityFormattedAddress: input,
          stationFormattedAddress: station,
          providerUser: providerUser);
    });
    await ProviderUserService().setProviderUserData(
        providerUser: _providerUser, uid: _providerUser.uid);
  }
}
