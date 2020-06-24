import 'package:flutter/material.dart';

class ProviderBottomNavigationBarWidget extends StatelessWidget {
  const ProviderBottomNavigationBarWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: BottomNavigationBar(items: [
        BottomNavigationBarItem(
          icon: Stack(
            children: <Widget>[
              Icon(Icons.directions_car),
              Positioned(
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 15,
                    minHeight: 15,
                  ),
                  child: Text(
                    '7',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
          title: Text('Anbieter'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text('Benutzer'),
        ),
      ]),
    );
  }
}
