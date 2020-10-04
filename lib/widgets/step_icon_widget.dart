import 'package:Sublin/models/transportation_type_enum.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/utils/get_icon_for_transportation_type.dart';
import 'package:flutter/material.dart';

class StepIconWidget extends StatelessWidget {
  final bool isSublinService;
  final bool isStartAddress;
  final bool isEndAddress;
  final IconData icon;
  final bool isBooked;
  final bool isConfirmed;
  final double iconSize;
  final TransportationType transportationType;

  StepIconWidget({
    this.isSublinService = false,
    this.isEndAddress = false,
    this.isStartAddress = false,
    this.icon,
    this.iconSize = 35,
    this.isBooked = false,
    this.isConfirmed = false,
    this.transportationType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: double.infinity,
      child: Stack(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: (isStartAddress) ? EdgeInsets.only(top: 20) : null,
              height: (isEndAddress) ? 30 : double.infinity,
              width: 2,
              color: Colors.black,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 20),
                height: iconSize,
                width: iconSize,
                decoration: BoxDecoration(
                  color: isSublinService
                      ? ThemeConstants.sublinMainColor
                      : Colors.black,
                  shape: BoxShape.circle,
                ),
                child: isBooked && !isConfirmed
                    ? CircularProgressIndicator()
                    : transportationType != null
                        ? getIconForTransportationType(transportationType)
                        : isConfirmed
                            ? Icon(
                                Icons.done,
                                color: Colors.white,
                                size: iconSize / 1.7,
                              )
                            : Icon(
                                icon,
                                color: Colors.white,
                                size: iconSize / 1.7,
                              )),
          ],
        ),
      ]),
    );
  }
}
