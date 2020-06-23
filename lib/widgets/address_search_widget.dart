import 'package:flutter/material.dart';
import 'package:sublin/screens/address_input_screen.dart';

class AddressSearchWidget extends StatefulWidget {
  //The following types are possible: start, end, train, bus, sublin
  final bool isStartAddress;
  final bool isEndAddress;
  final String startAddress;
  final String endAddress;
  final String address;
  final int startTime;
  final Function textInputFunction;

  AddressSearchWidget(
      {this.isStartAddress = false,
      this.isEndAddress = false,
      this.startAddress = '',
      this.endAddress = '',
      this.address = '',
      this.startTime,
      this.textInputFunction});

  @override
  _AddressSearchWidgetState createState() => _AddressSearchWidgetState();
}

class _AddressSearchWidgetState extends State<AddressSearchWidget> {
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
                      child: (widget.address == '')
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      _pushNavigation(context);
                                    },
                                    child: AbsorbPointer(
                                        child: Container(
                                            height: 50,
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                                fillColor: Colors.black12,
                                                hintText: widget.isStartAddress
                                                    ? 'Dein Standort finden'
                                                    : 'Deine Zieladresse finden',
                                                filled: true,
                                                border: InputBorder.none,
                                              ),
                                            ))),
                                  ),
                                )
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                  Text(
                                    widget.address,
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  ),
                                  if (widget.isEndAddress ||
                                      widget.isStartAddress)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            _pushNavigation(context);
                                          },
                                          child: Container(
                                              child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.edit_location,
                                                color: Theme.of(context)
                                                    .accentColor,
                                              ),
                                              Text('Adresse ändern')
                                            ],
                                          )),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    )
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
