import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sublin/models/auth.dart';
import 'package:sublin/models/provider_user.dart';
import 'package:sublin/models/user.dart';
import 'package:sublin/screens/provider/provider_registration_screen.dart';
import 'package:sublin/screens/provider/provider_registration_obsolete.dart';
import 'package:sublin/screens/user/user_home_screen.dart';
import 'package:sublin/screens/user/user_routing_screen.dart';
import 'package:sublin/theme/theme.dart';
import 'package:sublin/widgets/loading_widget.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/homeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // PageController _pageController;
  // int providerSelectedItem = 0;
  // static List<Widget> _providerWidgetOptions = <Widget>[
  //   ProviderHomeScreen(),
  //   UserHomeScreen(),
  //   ProviderHomeScreen(),
  // ];

  // static List<Widget> _userWidgetOptions = <Widget>[
  //   UserHomeScreen(),
  //   UserHomeScreen(),
  //   UserHomeScreen(),
  // ];

  // void onItemTappedProvider(int index) {
  //   setState(() {
  //     providerSelectedItem = index;
  //     // _pageController.animateToPage(index,
  //     //     duration: Duration(milliseconds: 500), curve: Curves.easeOut);
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   // _pageController = PageController();
  // }

  // @override
  // void dispose() {
  //   _pageController.dispose();
  //   super.dispose();
  // }

  // void displayBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (ctx) {
  //         return Container(
  //           height: MediaQuery.of(context).size.height * 0.4,
  //           child: ListView(
  //             children: <Widget>[
  //               ListTile(
  //                 leading: Icon(Icons.person_outline),
  //                 title: Text('Persönliche Einstellungen'),
  //                 onTap: null,
  //               ),
  //               ListTile(
  //                 leading: Icon(Icons.person_outline),
  //                 title: Text('Durchgeführte Fahrten'),
  //                 onTap: null,
  //               ),
  //               ListTile(
  //                 leading: Icon(Icons.person_outline),
  //                 title: Text('Als Anbieter starten'),
  //                 onTap: null,
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    final user = Provider.of<User>(context);
    final providerUser = Provider.of<ProviderUser>(context);

    if (user.streamingOn == false && providerUser.streamingOn == false)
      return MaterialApp(
        theme: themeData(context),
        home: Loading(),
      );

    //if (providerUser.isProvider) return ProviderHomeScreen();

    return MaterialApp(
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        UserHomeScreen.routeName: (context) => UserHomeScreen(),
        ProviderRegistrationScreen.routeName: (context) =>
            ProviderRegistrationScreen(),
        RoutingScreen.routeName: (context) => RoutingScreen(),
      },
      title: 'Sublin',
      theme: themeData(context),

      home: (user.isProvider && providerUser.operationRequested)
          ? ProviderRegistrationScreen()
          : UserHomeScreen(),

      // Scaffold(
      //     appBar: AppBar(
      //       title: Text('Sublin'),
      //       backgroundColor: Colors.black12,
      //     ),
      //     drawer: DrawerSideNavigationWidget(
      //       authService: authService,
      //     ),
      //     floatingActionButton: FloatingActionButton(
      //       onPressed: () => displayBottomSheet(context),
      //       child: Icon(Icons.add),
      //     ),
      //     body: SafeArea(
      //         top: false,
      //         child: (user.streamingOn == true && user.isProvider == false)
      //             ? UserHomeScreen()
      //             : ProviderHomeScreen()

      //         // child: IndexedStack(
      //         //   index: providerSelectedItem,
      //         //   children: providerUser.isProvider
      //         //       ? _providerWidgetOptions
      //         //       : _userWidgetOptions,
      //         // )),
      //         // bottomNavigationBar: providerUser.isProvider
      //         //     ? ProviderBottomNavigationBarWidget(
      //         //         onItemTappedProvider,
      //         //         providerSelectedItem,
      //         //         showProviderMenu,
      //         //       )
      //         //     : ProviderBottomNavigationBarWidget(
      //         //         onItemTappedProvider,
      //         //         providerSelectedItem,
      //         //         showProviderMenu,
      //         //       ),
      //         // _providerWidgetOptions.elementAt(providerSelectedItem)
      //         )),
    );
  }

  showProviderMenu() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Text('Appbar');
        });
  }
}
