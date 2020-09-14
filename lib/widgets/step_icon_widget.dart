import 'package:flutter/material.dart';

class StepIconWidget extends StatelessWidget {
  final bool isStartAddress;
  final bool isEndAddress;
  final IconData icon;
  final double iconSize;

  StepIconWidget({
    this.isEndAddress = false,
    this.isStartAddress = false,
    this.icon,
    this.iconSize = 40,
  });

  @override
  Widget build(BuildContext context) {
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
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: Icon(
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
