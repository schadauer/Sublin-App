import 'package:flutter/material.dart';

class TimeInputWidget extends StatelessWidget {
  final Icon icon;
  final String timeEnd;
  final String timeStart;

  TimeInputWidget({
    this.icon,
    this.timeEnd,
    this.timeStart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      color: Color.fromRGBO(245, 245, 245, 1),
      child: Row(
        children: <Widget>[
          Container(child: icon),
          SizedBox(
            width: 13,
          ),
          Text(
            'Dienst von $timeStart',
          ),
        ],
      ),
    );
  }
}
