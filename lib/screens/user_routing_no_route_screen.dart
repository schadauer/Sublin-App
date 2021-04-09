import 'package:flutter/material.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/models/user_type_enum.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/navigation_bar_widget.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/screens/user_my_sublin_screen.dart';

class UserRoutingNoRouteScreen extends StatelessWidget {
  final User user;
  final Icon icon;
  final String title;
  final String text;
  final String buttonText;
  const UserRoutingNoRouteScreen({
    Key key,
    @required this.user,
    @required this.icon,
    @required this.title,
    @required this.text,
    @required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBarWidget(
          isProvider: user.userType == UserType.provider,
          setNavigationIndex: 1),
      appBar: AppbarWidget(title: title),
      body: Center(
        child: Padding(
          padding: ThemeConstants.largePadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              icon,
              SizedBox(
                height: 20,
              ),
              Text(
                text,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await Navigator.pushReplacementNamed(
                        context, UserMySublinScreen.routeName);
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text(buttonText),
              )
            ],
          ),
        ),
      ),
    );
  }
}
