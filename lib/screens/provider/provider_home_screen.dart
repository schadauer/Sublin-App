import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sublin/models/address.dart';
import 'package:sublin/models/auth.dart';
import 'package:sublin/models/provider_user.dart';
import 'package:sublin/models/request.dart';
import 'package:sublin/models/routing.dart';
import 'package:sublin/models/user.dart';
import 'package:sublin/services/routing_service.dart';
import 'package:sublin/widgets/address_search_widget.dart';
import 'package:sublin/widgets/progress_indicator_widget.dart';

enum SingingCharacter { provider, service }

class ProviderHomeScreen extends StatefulWidget {
  static const routeName = '/providerHomeScreen';
  @override
  _ProviderHomeScreenState createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> {
  PageController _pageViewController = PageController(initialPage: 0);
  ProviderUser _providerUser = ProviderUser();
  Routing _defaultValueRouting = Routing();
  Routing _checkRoutingData;
  Request _request = Request();
  bool _showProgressIndicator = false;
  String _checkId = 'Initial';
  bool _providerAvailable;
  int _pageSteps = 1;

  String _textValueCity = '';

  @override
  void initState() {
    super.initState();
    // Dummy address to calculate route
    _request.startAddress =
        'Wien Hauptbahnhof, Wien Südbahnhof, Am Hauptbahnhof, Vienna, Austria';
    _request.startId = 'ChIJUU071tupbUcRyFdx20Nwgqg';
    _request.endAddress = '';
    _request.endId = '';
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<Auth>(context);
    final User user = Provider.of<User>(context);

    // print(_providerAvailable);

    return Scaffold(
      appBar: AppBar(
        title: Text('Registrierung als Anbieter'),
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageViewController,
          children: <Widget>[
            // First Page ------------------------------- 1 ----------------------------------
            Container(
              // padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  ProgressIndicatorWidget(
                    index: _pageSteps,
                    elements: 3,
                    showProgressIndicator: _showProgressIndicator,
                  ),
                  Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                user.firstName + ',',
                                style: Theme.of(context).textTheme.headline1,
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          AutoSizeText(
                            'bitte gib deine Geschäftsadresse, um herauszufinden, ob sich für dein Gebiet bereits ein Anbieter registriert hat.',
                            style: Theme.of(context).textTheme.bodyText1,
                            maxLines: 8,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          AddressSearchWidget(
                            addressInputFunction: addressInputFunction,
                            isEndAddress: true,
                            isStartAddress: false,
                            isCheckOnly: true,
                            address: _request.endAddress,
                            endHintText: 'Deine Geschäftsadresse',
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              RaisedButton(
                                onPressed: () async {
                                  try {
                                    setState(() {
                                      _showProgressIndicator = true;
                                    });
                                    await RoutingService().requestRoute(
                                      uid: auth.uid,
                                      startAddress: _request.startAddress,
                                      startId: _request.startId,
                                      endAddress: _request.endAddress,
                                      endId: _request.endId,
                                      checkAddress: true,
                                      timestamp:
                                          DateTime.now().millisecondsSinceEpoch,
                                    );
                                    _checkAddressStatus(auth.uid);
                                  } catch (e) {}
                                },
                                child: Text('Weiter'),
                              )
                            ],
                          )
                        ],
                      )),
                ],
              ),
            ),
            // Second Page ------------------------------- 2 ----------------------------------
            if (_pageSteps >= 2)
              Container(
                // padding: EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    ProgressIndicatorWidget(
                      // index: _pageViewController.page,
                      showProgressIndicator: _showProgressIndicator,
                    ),
                    Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Grüße nach ${_checkRoutingData.endAddress.city}',
                                  style: Theme.of(context).textTheme.headline3,
                                  textAlign: TextAlign.left,
                                ),
                                AutoSizeText(
                                    'Ein Anbieter hat sich für die PLZ ${_checkRoutingData.endAddress.postcode} registriert.'),
                                Card(
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: <Widget>[
                                          Flexible(
                                            flex: 1,
                                            child: Icon(Icons.access_alarm),
                                          ),
                                          Flexible(
                                            flex: 4,
                                            child: Row(
                                              children: <Widget>[Text('')],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (_checkRoutingData.endAddressAvailable)
                              AutoSizeText(
                                'Für deine Postleitzahl hat sich bereits ein Anbieter registriert',
                                style: Theme.of(context).textTheme.bodyText1,
                                maxLines: 8,
                              ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                RaisedButton(
                                  onPressed: () {
                                    _pageViewController.nextPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeOut);
                                  },
                                  child: Text('Weiter'),
                                )
                              ],
                            )
                          ],
                        )),
                  ],
                ),
              ),
          ],
        ),
      ),
    );

    // Scaffold(
    //     // appBar: AppBar(
    //     //   title: Text('Sublin'),
    //     //   backgroundColor: Colors.black12,
    //     // ),
    //     // drawer: DrawerSideNavigationWidget(
    //     //   authService: AuthService(),
    //     // ),
    //     body: GestureDetector(
    //         behavior: HitTestBehavior.opaque,
    //         onTap: () {
    //           FocusScope.of(context).unfocus();
    //           setState(() {
    //             _textFocus = false;
    //           });
    //         },
    //         child: Stack(children: <Widget>[
    //           SizedBox(
    //             height: 40,
    //           ),
    //           Container(
    //             padding: EdgeInsets.only(top: 20, left: 15, right: 15),
    //             width: MediaQuery.of(context).size.width,
    //             height: 220,
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.stretch,
    //               children: <Widget>[
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.start,
    //                   crossAxisAlignment: CrossAxisAlignment.center,
    //                   children: <Widget>[
    //                     Text(
    //                       user.firstName + ',',
    //                       style: Theme.of(context).textTheme.headline1,
    //                       textAlign: TextAlign.left,
    //                     ),
    //                   ],
    //                 ),
    //                 SizedBox(
    //                   height: 10,
    //                 ),
    //                 AutoSizeText(
    //                   'bitte gib deine Geschäftsadresse, um herauszufinden, ob sich für dein Gebiet bereits ein Anbieter registriert hat.',
    //                   style: Theme.of(context).textTheme.bodyText1,
    //                   maxLines: 8,
    //                 ),
    //               ],
    //             ),
    //           ),
    //           AnimatedContainer(
    //               height: 600,
    //               decoration: BoxDecoration(
    //                 color: Colors.white,
    //               ),
    //               margin: EdgeInsets.only(top: (_textFocus) ? 70 : 190),
    //               duration: Duration(milliseconds: 100),
    //               child: GestureDetector(
    //                 behavior: HitTestBehavior.translucent,
    //                 // onTap: () {
    //                 //   FocusScope.of(context).unfocus();
    //                 //   setState(() {
    //                 //     _textFocus = true;
    //                 //   });
    //                 // },
    //                 child: SingleChildScrollView(
    //                   child: Column(
    //                     children: <Widget>[
    //                       Container(
    //                         child: Stepper(
    //                           currentStep: _currentStep,
    //                           controlsBuilder: (BuildContext context,
    //                               {VoidCallback onStepContinue,
    //                               VoidCallback onStepCancel}) {
    //                             return Row(
    //                               mainAxisAlignment: MainAxisAlignment.end,
    //                               children: <Widget>[
    //                                 FlatButton(
    //                                   onPressed: onStepCancel,
    //                                   child: Text('zurück'),
    //                                 ),
    //                                 RaisedButton.icon(
    //                                   icon: Icon(Icons.navigate_next),
    //                                   onPressed: onStepContinue,
    //                                   label: Text('Weiter'),
    //                                 )
    //                               ],
    //                             );
    //                           },
    //                           onStepTapped: (index) {
    //                             setState(() {
    //                               print('adsfasdf');
    //                               _textFocus = true;
    //                             });
    //                           },
    //                           onStepCancel: () {
    //                             setState(() {
    //                               _currentStep -= 1;
    //                             });
    //                           },
    //                           onStepContinue: () {
    //                             setState(() {
    //                               _currentStep += 1;
    //                               _textFocus = true;
    //                             });
    //                           },
    //                           steps: [
    //                             Step(
    //                               title: Text("Dein Betriebsstandort"),
    //                               subtitle: _localRouting.endAddress == ''
    //                                   ? null
    //                                   : Text(
    //                                       _localRouting.endAddress.length > 40
    //                                           ? _localRouting.endAddress
    //                                                   .substring(0, 0) +
    //                                               '...'
    //                                           : _localRouting.endAddress,
    //                                       overflow: TextOverflow.ellipsis,
    //                                     ),
    //                               content: AddressSearchWidget(
    //                                 addressInputFunction: addressInputFunction,
    //                                 isEndAddress: true,
    //                                 isStartAddress: true,
    //                                 address: _localRouting.endAddress,
    //                                 startHintText: 'Dein Standort',
    //                               ),
    //                             ),
    //                             Step(
    //                                 title:
    //                                     Text("Deine Transportdienstleistung"),
    //                                 isActive: true,
    //                                 subtitle: Text(
    //                                     'Verfügbare Transportdienstleistungen'),
    //                                 state: StepState.editing,
    //                                 content: Column(
    //                                   children: <Widget>[
    //                                     ListTile(
    //                                       // onTap: () {
    //                                       //   setState(() {
    //                                       //     _textFocus = true;
    //                                       //   });
    //                                       // },
    //                                       title: Text(
    //                                         'Du bietest selbst Personentransport an',
    //                                         style: Theme.of(context)
    //                                             .textTheme
    //                                             .bodyText1,
    //                                       ),
    //                                       leading: Radio(
    //                                         value: SingingCharacter.provider,
    //                                         groupValue: _character,
    //                                         onChanged:
    //                                             (SingingCharacter value) {
    //                                           setState(() {
    //                                             _character = value;
    //                                           });
    //                                         },
    //                                       ),
    //                                     ),
    //                                     ListTile(
    //                                       title: Text(
    //                                         'Du bietest Personentransport durch einen externen Anbieter an (Betrieb, Hotel, Gemeinde, etc.)',
    //                                         style: Theme.of(context)
    //                                             .textTheme
    //                                             .bodyText1,
    //                                       ),
    //                                       leading: Radio(
    //                                         value: SingingCharacter.service,
    //                                         groupValue: _character,
    //                                         onChanged:
    //                                             (SingingCharacter value) {
    //                                           setState(() {
    //                                             _character = value;
    //                                             _textFocus = true;
    //                                           });
    //                                         },
    //                                       ),
    //                                     ),
    //                                   ],
    //                                 )),
    //                             Step(
    //                               title: Text("Einstellungen"),
    //                               content:
    //                                   Text("Let's look at its construtor."),
    //                             ),
    //                           ],
    //                         ),
    //                       ),

    //                       // Container(
    //                       //   width: MediaQuery.of(context).size.width,
    //                       //   child: Card(
    //                       //       child: Column(
    //                       //     children: <Widget>[
    //                       //       ListTile(
    //                       //         title: const Text(
    //                       //             'Du bietest selbst Personentransport an'),
    //                       //         leading: Radio(
    //                       //           value: SingingCharacter.provider,
    //                       //           groupValue: _character,
    //                       //           onChanged: (SingingCharacter value) {
    //                       //             setState(() {
    //                       //               _character = value;
    //                       //               _textFocus = true;
    //                       //             });
    //                       //           },
    //                       //         ),
    //                       //       ),
    //                       //       ListTile(
    //                       //         title: const Text(
    //                       //             'Du bietest Personentransport durch einen externen Anbieter an'),
    //                       //         leading: Radio(
    //                       //           value: SingingCharacter.service,
    //                       //           groupValue: _character,
    //                       //           onChanged: (SingingCharacter value) {
    //                       //             setState(() {
    //                       //               _character = value;
    //                       //               _textFocus = true;
    //                       //             });
    //                       //           },
    //                       //         ),
    //                       //       ),
    //                       //     ],
    //                       //   )),
    //                       // ),
    //                       // StartEnd(
    //                       //   startAddress: 'asdfasfdsdf',
    //                       //   showStartAddress: false,
    //                       //   endHintText: 'Deinen Standort suchen',
    //                       //   buttonText: 'Anbieter suchen',
    //                       //   providerRequest: true,
    //                       // ),
    //                     ],
    //                   ),
    //                 ),
    //               ))
    //         ]))
    // );
  }

  void addressInputFunction(
      String input, String id, bool startAddress, bool endAddress) {
    setState(() {
      _request.endAddress = input;
      _request.endId = id;
      _providerUser.addresses = [
        input,
        id,
      ];
    });
  }

  void _checkAddressStatus(uid) {
    final myStream = RoutingService().streamCheck(uid);
    StreamSubscription<Routing> subscription;
    subscription = myStream.listen((data) {
      print('---');
      print(data.id);
      print('------------');
      print(_checkId);
      if (data.id != _defaultValueRouting.id && _checkId != data.id) {
        print('is');
        setState(() {
          _checkRoutingData = data;
          // print(data.id);
          // print(data.provider.name);
          // _checkRoutingData = Routing(
          //     endAddressAvailable: data.endAddressAvailable,
          //     endAddress: data.endAddress,
          //     provider: ProviderUser(
          //       isTaxi: data.provider.isTaxi,
          //       stations: data.provider.stations,
          //       name: data.provider.name,
          //       timeStart: data.provider.timeStart,
          //       timeEnd: data.provider.timeEnd,
          //     ));
          _checkId = data.id;
          _showProgressIndicator = false;
          _pageSteps = 2;
          _pageViewController.nextPage(
              duration: Duration(milliseconds: 300), curve: Curves.easeOut);
        });
        subscription.onData((data) {
          print(data.id);
        });
        subscription.cancel();
      }
    });
  }
}
