import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/bottom_navigation_bar_widget.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  static const routeName = './userProfileScreenState';
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBarWidget(),
      appBar: AppbarWidget(title: 'Dein Profil'),
      body: SafeArea(
        child: Text('sadf'),
      ),
    );
  }
}
