import 'package:flutter/material.dart';

class StepIconWidget extends StatelessWidget {
  final bool isStartAddress;
  final bool isEndAddress;

  StepIconWidget({
    this.isEndAddress = false,
    this.isStartAddress = false,
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
              width: 5,
              color: Theme.of(context).accentColor,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                (isEndAddress) ? Icons.flag : Icons.home,
                color: Colors.white,
                size: 25,
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
