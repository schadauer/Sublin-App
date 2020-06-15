import 'package:flutter/material.dart';
import 'package:sublin/screens/address_input_screen.dart';

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
                              '${widget.startAddress}',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            Text(
                              '${widget.endAddress}',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 80,
            height: double.infinity,
            child: Stack(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: (widget.isStartAddress)
                        ? EdgeInsets.only(top: 20)
                        : null,
                    height: (widget.isEndAddress) ? 30 : double.infinity,
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
                      (widget.isEndAddress) ? Icons.flag : Icons.home,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ]),
          ),
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
