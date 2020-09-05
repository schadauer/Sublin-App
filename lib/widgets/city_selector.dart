import 'package:Sublin/models/delimiter.dart';
import 'package:Sublin/models/user.dart';
import 'package:Sublin/screens/address_input_screen.dart';
import 'package:Sublin/utils/get_part_of_formatted_address.dart';
import 'package:flutter/material.dart';

class CitySelector extends StatefulWidget {
  final List<dynamic> addresses;
  final List<dynamic> stations;
  final Function getAddressesAndStationsFunction;

  CitySelector({
    this.addresses = const [],
    this.stations = const [],
    this.getAddressesAndStationsFunction,
  });

  @override
  _CitySelectorState createState() => _CitySelectorState();
}

class _CitySelectorState extends State<CitySelector> {
  List<dynamic> _addresses = [];
  List<dynamic> _stations = [];

  @override
  void initState() {
    _addresses = widget.addresses;
    _stations = widget.stations;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_addresses.length == 0);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _addresses.length != 0
            ? Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceBetween,
                spacing: 10.0,
                children: _addresses.map((address) {
                  String city =
                      getPartOfFormattedAddress(address, Delimiter.city);
                  return Chip(
                    padding: EdgeInsets.all(8.0),
                    label: Text(city),
                    onDeleted: () => _removeCityFromStation(city),
                  );
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
                                addressInputFunction: _citySelectionFunction,
                                isEndAddress: false,
                                isStartAddress: false,
                                cityOnly: true,
                                title: 'Ortschaft hinzufügen',
                              )));
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  void _removeCityFromStation(String city) {
    setState(() {
      int removeIndex;
      for (var i = 0; i < _addresses.length; i++) {
        String cityFromAddress =
            getPartOfFormattedAddress(_addresses[i], Delimiter.city);
        if (city == cityFromAddress) {
          removeIndex = i;
        }
      }
      setState(() {
        _addresses.removeAt(removeIndex);
      });
    });
  }

  void _citySelectionFunction({
    String userUid,
    String input,
    String id,
    bool isCompany,
    bool isStartAddress,
    bool isEndAddress,
  }) {
    print(input);
    setState(() {
      if (!_addresses.contains(input)) _addresses.add(input);
    });
    // _addCityToStations(input);
  }
}
