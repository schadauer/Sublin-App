import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class WaitingWidget extends StatelessWidget {
  const WaitingWidget({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ConstrainedBox(
            constraints: BoxConstraints(minHeight: 80, minWidth: 80),
            child: CircularProgressIndicator()),
        SizedBox(
          height: 30,
        ),
        SizedBox(
            height: 30,
            child: AutoSizeText(
              '$title ...' ?? '',
              style: Theme.of(context).textTheme.bodyText1,
            ))
      ],
    ));
  }
}
