import 'package:flutter/material.dart';
import 'package:sublin/screens/provider/provider_home_screen.dart';

class ProviderBottomNavigationBarWidget extends StatefulWidget {
  // const ProviderBottomNavigationBarWidget({
  //   Key key,
  // }) : super(key: key);
  Function onItemTappedProvider;
  int providerSelectedItem;
  Function showProviderMenu;

  ProviderBottomNavigationBarWidget(
    this.onItemTappedProvider,
    this.providerSelectedItem,
    this.showProviderMenu,
  );

  @override
  _ProviderBottomNavigationBarWidgetState createState() =>
      _ProviderBottomNavigationBarWidgetState();
}

class _ProviderBottomNavigationBarWidgetState
    extends State<ProviderBottomNavigationBarWidget> {
  @override
  Widget build(BuildContext context) {
    print(widget.providerSelectedItem);
    return SafeArea(
      child: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          elevation: 0,
          currentIndex: widget.providerSelectedItem,
          selectedItemColor: Theme.of(context).accentColor,
          onTap: widget.onItemTappedProvider,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Fahrten'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Fahrt suchen'),
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: <Widget>[
                  Icon(Icons.directions_car),
                  // Positioned(
                  //   right: 0,
                  //   child: Container(
                  //     padding: EdgeInsets.all(1),
                  //     decoration: BoxDecoration(
                  //       color: Colors.red,
                  //       borderRadius: BorderRadius.circular(6),
                  //     ),
                  //     constraints: BoxConstraints(
                  //       minWidth: 15,
                  //       minHeight: 15,
                  //     ),
                  //     child: Text(
                  //       '7',
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 10,
                  //       ),
                  //       textAlign: TextAlign.center,
                  //     ),
                  //   ),
                  // )
                ],
              ),
              title: Text('Profil'),
            ),
          ],
        ),
      ),
    );
  }
}
