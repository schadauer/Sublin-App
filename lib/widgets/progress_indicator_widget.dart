import 'package:flutter/material.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int index;
  final int elements;
  final bool showProgressIndicator;

  const ProgressIndicatorWidget({
    this.index = 1,
    this.elements = 4,
    this.showProgressIndicator = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // SizedBox(
        //   height: 1,
        // ),
        if (!showProgressIndicator)
          SizedBox(
            height: 10,
            child: Row(
              children: <Widget>[
                Flexible(
                  child:
                      Container(color: Theme.of(context).secondaryHeaderColor),
                  flex: index,
                ),
                Flexible(
                  child: Container(
                    color: Colors.white,
                  ),
                  flex: elements - index,
                )
              ],
            ),
          ),
        if (showProgressIndicator)
          SizedBox(
            height: 10,
            child: LinearProgressIndicator(
              backgroundColor: Theme.of(context).secondaryHeaderColor,
            ),
          ),
      ],
    );
  }
}
