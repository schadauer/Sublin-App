import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/widgets/city_selector_widget.dart';
import 'package:flutter/material.dart';

class FloatingButtonAddCities extends StatefulWidget {
  final User user;
  final Function isBottomSheetClosedCallback;
  FloatingButtonAddCities({this.user, this.isBottomSheetClosedCallback});

  @override
  _FloatingButtonAddCitiesState createState() =>
      _FloatingButtonAddCitiesState();
}

class _FloatingButtonAddCitiesState extends State<FloatingButtonAddCities> {
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
                        child: CitySelectorWidget(
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
