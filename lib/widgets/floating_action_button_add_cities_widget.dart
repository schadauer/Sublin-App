import 'package:Sublin/models/user.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/widgets/city_selector.dart';
import 'package:flutter/material.dart';

class FloatingActionButtonAddCities extends StatefulWidget {
  final User user;
  final Function isBottomSheetClosedCallback;
  FloatingActionButtonAddCities({this.user, this.isBottomSheetClosedCallback});

  @override
  _FloatingActionButtonAddCitiesState createState() =>
      _FloatingActionButtonAddCitiesState();
}

class _FloatingActionButtonAddCitiesState
    extends State<FloatingActionButtonAddCities> {
  bool showFAB = true;
  @override
  Widget build(BuildContext context) {
    return showFAB
        ? FloatingActionButton.extended(
            label: Container(
              color: ThemeConstants.sublinMainColor,
              child: Text(
                'Meine Orte bearbeiten',
                style: ThemeConstants.mainButton,
              ),
            ),
            elevation: 2.0,
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              showFloatingActionButton(false);
              var bottomSheetController = showBottomSheet(
                  context: context,
                  builder: (context) => Container(
                        child: CitySelector(
                          providerAddress: false,
                        ),
                      ));

              bottomSheetController.closed.then((value) {
                widget.isBottomSheetClosedCallback(true);
                showFloatingActionButton(true);
              });
            },
          )
        : Container();
  }

  void showFloatingActionButton(bool value) {
    setState(() {
      showFAB = value;
    });
  }
}
