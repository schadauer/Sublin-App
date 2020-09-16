import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppbarWidget({
    this.title = '',
    this.user,
    this.showProfileIcon = true,
    Key key,
  }) : super(key: key);

  final String title;
  final User user;
  final bool showProfileIcon;

  @override
  Size get preferredSize => const Size.fromHeight(55);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: AppBar(
        title: Text(
          this.title,
          style: Theme.of(context).textTheme.headline1,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
        actions: [
          if (showProfileIcon)
            Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  Icons.account_circle,
                  size: 35,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, UserProfileScreen.routeName),
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              ),
            ),
        ],
      ),
    );
  }
}
