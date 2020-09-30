import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/models/user_type_enum.dart';
import 'package:Sublin/widgets/navigation_bar_widget.dart';
import 'package:Sublin/widgets/waiting_widget.dart';
import 'package:flutter/material.dart';

class WaitingScreen extends StatelessWidget {
  const WaitingScreen({
    Key key,
    this.title = 'Bitte warten...',
    this.user,
  }) : super(key: key);

  final User user;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBarWidget(
          isProvider: user?.userType == UserType.provider,
          setNavigationIndex: 1),
      body: WaitingWidget(title: title),
    );
  }
}
