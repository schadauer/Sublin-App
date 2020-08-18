import 'package:flutter/material.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppbarWidget({
    this.title = '',
    Key key,
  }) : super(key: key);

  final String title;

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
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
        // leading: Image.asset(
        //   'assets/images/Sublin.png',
        //   scale: 1.2,
        // ),
      ),
    );
  }
}
