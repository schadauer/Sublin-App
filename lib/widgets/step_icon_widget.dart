import 'package:Sublin/theme/theme.dart';
import 'package:flutter/material.dart';

class StepIconWidget extends StatelessWidget {
  final bool isSublinService;
  final bool isStartAddress;
  final bool isEndAddress;
  final IconData icon;
  final bool isWaitingForConfirmation;
  double iconSize;

  StepIconWidget({
    this.isSublinService = false,
    this.isEndAddress = false,
    this.isStartAddress = false,
    this.icon,
    this.iconSize = 40,
    this.isWaitingForConfirmation = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isSublinService) iconSize = 50.0;
    return Container(
      width: 80,
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
              child: isWaitingForConfirmation
                  ? CircularProgressIndicator()
                  : Icon(
                      icon,
                      color: Colors.white,
                      size: iconSize / 1.5,
                    ),
            ),
          ],
        ),
      ]),
    );
  }
}
