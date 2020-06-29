import 'package:flutter/material.dart';

class HeaderWidget extends SliverPersistentHeaderDelegate {
  int index = 0;
  final String name;

  HeaderWidget({
    this.name = 'Ihr Betriebsname',
  });

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate _) => true;

  @override
  double get maxExtent => 200.0;

  @override
  double get minExtent => 80.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return LayoutBuilder(builder: (context, constraints) {
      // final Color color = Colors.primaries[index];
      // final double percentage =
      //     (constraints.maxHeight - minExtent) / (maxExtent - minExtent);

      // if (++index > Colors.primaries.length - 1) index = 0;
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
        ),
        height: constraints.maxHeight,
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: Center(
                        child: Text(
                      _getInitials(name),
                      style: Theme.of(context).textTheme.headline1,
                    )),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          name,
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        // Row(
                        //   children: <Widget>[
                        //     Text(
                        //       'Waidhofner Straß ',
                        //       style: Theme.of(context).textTheme.bodyText1,
                        //     )
                        //   ],
                        // )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        )),
      );
    });
  }

  String _getInitials(String name) {
    if (name.contains(' ')) {
      List<String> split = name.split(' ');
      String initial = '';
      split.forEach((element) {
        if (element != '' && initial.length <= 1) {
          initial = initial + element.substring(0, 1);
        }
      });
      return initial;
    } else if (name.length >= 2) {
      return name.substring(0, 2);
    } else {
      return name.length == 1 ? name.substring(0, 1) : 'X';
    }
  }
}
