import 'package:flutter/material.dart';
import 'package:sublin/screens/address_input_screen.dart';

class AddressSearchWidget extends StatefulWidget {
  //The following types are possible: start, end, train, bus, sublin
  final bool startAddress;
  final bool endAddress;

  final String address;
  final DateTime date;
  final Function textInputFunction;

  AddressSearchWidget(
      {this.startAddress = false,
      this.endAddress = false,
      this.address = '',
      this.date,
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
                                                fillColor: Colors.black12,
                                                hintText: widget.startAddress
                                                    ? 'Dein Standort'
                                                    : 'Deine Zieladresse',
                                                filled: true,
                                                border: InputBorder.none,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    10.0)),
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
                                              color:
                                                  Theme.of(context).accentColor,
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
                    margin:
                        (widget.startAddress) ? EdgeInsets.only(top: 20) : null,
                    height: (widget.endAddress) ? 30 : double.infinity,
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
                      (widget.endAddress) ? Icons.flag : Icons.home,
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
                  endAddress: widget.endAddress,
                  startAddress: widget.startAddress,
                )));
  }
}
