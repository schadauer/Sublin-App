import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sublin/models/routing.dart';
import 'package:sublin/widgets/step_widget.dart';

class RoutingScreen extends StatefulWidget {
  static const routeName = '/routingScreen';
  @override
  _RoutingScreenState createState() => _RoutingScreenState();
}

class _RoutingScreenState extends State<RoutingScreen> {
  @override
  Widget build(BuildContext context) {
    final Routing routingService = Provider.of<Routing>(context);

    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
                itemCount: routingService.steps.length,
                itemBuilder: (context, index) {
                  if (routingService.steps[index].distance == 0) {
                    return StepWidget(
                      startAddress: routingService.steps[index].startAddress,
                      endAddress: routingService.steps[index].endAddress,
                      startTime: routingService.steps[index].startTime,
                      provider: routingService.steps[index].provider,
                      distance: routingService.steps[index].distance,
                      duration: routingService.steps[index].duration,
                    );
                  } else
                    return null;
                })),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.black26,
              height: 150,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                          onPressed: () async {
                            // await RoutingService().removeProviderFromRoute(user.uid);
                            Navigator.pop(context);
                          },
                          child: Text('Ädresse ändern')),
                      RaisedButton(onPressed: null, child: Text('Jetzt buchen'))
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
