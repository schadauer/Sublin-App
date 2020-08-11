import 'package:Sublin/utils/convert_formatted_address_to_readable_address.dart';
import 'package:flutter/material.dart';
import 'package:Sublin/screens/address_input_screen.dart';

class AddressSearchWidget extends StatefulWidget {
  //The following types are possible: start, end, train, bus, Sublin
  final bool isStartAddress;
  final bool isEndAddress;
  final String startAddress;
  final String startHintText;
  final String endAddress;
  final String endHintText;
  final String address;
  final int startTime;
  final Function addressInputFunction;
  final bool isCheckOnly;

  AddressSearchWidget({
    this.isStartAddress = false,
    this.isEndAddress = false,
    this.startAddress = '',
    this.startHintText = 'Deinen Standort finden',
    this.endAddress = '',
    this.endHintText = 'Deine Zieladresse finden',
    this.address = '',
    this.startTime,
    this.addressInputFunction,
    this.isCheckOnly = false,
  });

  @override
  _AddressSearchWidgetState createState() => _AddressSearchWidgetState();
}

class _AddressSearchWidgetState extends State<AddressSearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        height: 120,
        child: Container(
          child: Stack(children: <Widget>[
            SizedBox(
              height: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                // margin: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    if (!widget.isCheckOnly)
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
                                              child: Material(
                                        child: SizedBox(
                                          height: 50,
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              contentPadding: Theme.of(context)
                                                  .inputDecorationTheme
                                                  .contentPadding,
                                              fillColor: Theme.of(context)
                                                  .inputDecorationTheme
                                                  .fillColor,
                                              hintText: widget.isStartAddress
                                                  ? widget.startHintText
                                                  : widget.endHintText,
                                              filled: Theme.of(context)
                                                  .inputDecorationTheme
                                                  .filled,
                                              border: Theme.of(context)
                                                  .inputDecorationTheme
                                                  .border,
                                            ),
                                          ),
                                        ),
                                      ))),
                                    ),
                                  )
                                ],
                              )
                            : Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                    Text(
                                      convertFormattedAddressToReadableAddress(
                                          widget.address),
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    if (widget.isEndAddress ||
                                        widget.isStartAddress)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                                Text(
                                                  'Adresse ändern',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption,
                                                )
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
            if (!widget.isCheckOnly)
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
      ),
    );
  }

  Future _pushNavigation(BuildContext context) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddressInputScreen(
                  addressInputFunction: widget.addressInputFunction,
                  isEndAddress: widget.isEndAddress,
                  isStartAddress: widget.isStartAddress,
                  title: widget.isEndAddress
                      ? widget.endHintText
                      : widget.startHintText,
                )));
  }
}
