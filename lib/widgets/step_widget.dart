import 'package:flutter/material.dart';
import 'package:sublin/screens/address_input_screen.dart';
import 'package:sublin/widgets/step_icon_widget.dart';
import 'package:sublin/utils/getTimeFormat.dart';

class StepWidget extends StatefulWidget {
  //The following types are possible: start, end, train, bus, sublin
  final bool isStartAddress;
  final bool isEndAddress;
  final String startAddress;
  final String endAddress;
  final int startTime;
  final int endTime;
  final String provider;
  final int distance;
  final int duration;
  final Function textInputFunction;

  StepWidget(
      {this.isStartAddress = false,
      this.isEndAddress = false,
      this.startAddress = '',
      this.endAddress = '',
      this.startTime = 0,
      this.endTime = 0,
      this.provider = '',
      this.distance = 0,
      this.duration = 0,
      this.textInputFunction});

  @override
  _StepWidgetState createState() => _StepWidgetState();
}

class _StepWidgetState extends State<StepWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Container(
        child: Stack(children: <Widget>[
          SizedBox(
            height: double.infinity,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              margin: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(0),
                    width: 60,
                    height: 100,
                    color: Colors.white54,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${getTimeFormat(widget.startTime)} ${widget.startAddress}',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Icon(
                              Icons.more_vert,
                              size: 20,
                            ),
                            Text(
                              '${getTimeFormat(widget.endTime)} ${widget.endAddress}',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          StepIconWidget(
              isStartAddress: widget.isStartAddress,
              isEndAddress: widget.isEndAddress),
        ]),
      ),
    );
  }

  Future _pushNavigation(BuildContext context) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddressInputScreen(
                  textInputFunction: widget.textInputFunction,
                  isEndAddress: widget.isEndAddress,
                  isStartAddress: widget.isStartAddress,
                )));
  }
}
