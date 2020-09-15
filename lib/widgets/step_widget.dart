import 'package:Sublin/theme/theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:Sublin/widgets/step_icon_widget.dart';
import 'package:Sublin/utils/get_time_format.dart';

class StepWidget extends StatefulWidget {
  //The following types are possible: start, end, train, bus, Sublin
  final bool isStartAddress;
  final bool isEndAddress;
  final String startAddress;
  final String endAddress;
  final int startTime;
  final int endTime;
  final String providerName;
  final String lineName;
  final int distance;
  final int duration;
  final Function addressInputFunction;

  StepWidget(
      {this.isStartAddress = false,
      this.isEndAddress = false,
      this.startAddress = '',
      this.endAddress = '',
      this.startTime = 0,
      this.endTime = 0,
      this.providerName = '',
      this.lineName = '',
      this.distance = 0,
      this.duration = 0,
      this.addressInputFunction});

  @override
  _StepWidgetState createState() => _StepWidgetState();
}

class _StepWidgetState extends State<StepWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Container(
        child: Stack(children: <Widget>[
          SizedBox(
            height: double.infinity,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              margin: EdgeInsets.all(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(0),
                    width: 60,
                    height: 80,
                    color: Colors.white54,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                          right: 20, left: 20, top: 10, bottom: 10),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: AutoSizeText(
                                    '${widget.lineName} - ${widget.startAddress}',
                                    maxLines: 2,
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    '${getTimeFormat(widget.startTime)}',
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Row(
                                    children: [
                                      Icon(Icons.keyboard_tab),
                                      SizedBox(width: 5),
                                      Expanded(
                                        child: AutoSizeText(
                                          '${widget.endAddress}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    '${getTimeFormat(widget.endTime)}',
                                    style: Theme.of(context).textTheme.caption,
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
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
            isEndAddress: widget.isEndAddress,
            icon: Icons.train,
            iconSize: 30.0,
          ),
        ]),
      ),
    );
  }

  // Future _pushNavigation(BuildContext context) {
  //   return Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => AddressInputScreen(
  //                 addressInputFunction: widget.addressInputFunction,
  //                 isEndAddress: widget.isEndAddress,
  //                 isStartAddress: widget.isStartAddress,
  //               )));
  // }
}
