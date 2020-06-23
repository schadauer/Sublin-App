import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sublin/models/auth.dart';
import 'package:sublin/models/provider_user.dart';
import 'package:sublin/models/user.dart';
import 'package:sublin/screens/provider/provider_home_screen.dart';
import 'package:sublin/screens/user/user_home_screen.dart';
import 'package:sublin/widgets/loading_widget.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/homeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    final user = Provider.of<User>(context);
    final providerUser = Provider.of<ProviderUser>(context);

    print(auth.uid);
    print(user.requestedAddresses);

    if (user.streamingOn == false && providerUser.streamingOn == false)
      return Loading();

    if (providerUser.operationRequested) return ProviderHomeScreen();

    return Scaffold(
        body: Stack(
      children: <Widget>[
        UserHomeScreen(),
        Text('adsfasdf'),
      ],
    ));

    // Scaffold(
    //   body: UserHomeScreen(),
    //   bottomNavigationBar: SizedBox(
    //     height: 80,
    //     child: BottomNavigationBar(items: [
    //       BottomNavigationBarItem(
    //         icon: Stack(
    //           children: <Widget>[
    //             Icon(Icons.sentiment_dissatisfied),
    //             Positioned(
    //               right: 0,
    //               child: Container(
    //                 padding: EdgeInsets.all(1),
    //                 decoration: BoxDecoration(
    //                   color: Colors.red,
    //                   borderRadius: BorderRadius.circular(6),
    //                 ),
    //                 constraints: BoxConstraints(
    //                   minWidth: 15,
    //                   minHeight: 15,
    //                 ),
    //                 child: Text(
    //                   '7',
    //                   style: TextStyle(
    //                     color: Colors.white,
    //                     fontSize: 10,
    //                   ),
    //                   textAlign: TextAlign.center,
    //                 ),
    //               ),
    //             )
    //           ],
    //         ),
    //         title: Text('Suchen'),
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.search),
    //         title: Text('Usch'),
    //       ),
    //     ]),
    //   ),
    // );
  }
}
