import 'package:Sublin/theme/theme.dart';
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
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.account_circle,
                size: 35,
              ),
              // Container(
              //   width: 40,
              //   height: 40,
              //   decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       image: DecorationImage(
              //           fit: BoxFit.fill,
              //           image: NetworkImage(
              //               "https://dev.gemeindeserver.net/media/seitenstetten/1524150647-img-0151-jpg.jpeg"))),
              // ),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
    );
  }
}
