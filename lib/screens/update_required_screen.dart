import 'dart:core';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:launch_review/launch_review.dart';

import 'package:Sublin/widgets/appbar_widget.dart';

class UpdateRequiredScreen extends StatefulWidget {
  static const routeName = './testPeriodScreen';
  @override
  _UpdateRequiredScreenState createState() => _UpdateRequiredScreenState();
}

class _UpdateRequiredScreenState extends State<UpdateRequiredScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppbarWidget(title: 'Update erforderlich'),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 100.0,
                  child: Image.asset(
                    'assets/images/logo_white_background.png',
                    alignment: Alignment.center,
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      'Ein App-Update ist erforderlich.',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    AutoSizeText(
                      'Wir lernen täglichen von unseren Benutzern, was wir richtig machen - aber vor allem, was wir nicht richtig machen oder was sich in der Praxis nicht bewährt. ',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    AutoSizeText(
                      'Speziell in der Anfangsphase sind oft größere Änderungen notwendig, die ein Update der App erfordern. Wir bitte um dein Verständnis.',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              LaunchReview.launch();
                            },
                            child: Text('Jetzt App updaten')),
                      ],
                    )
                  ],
                ),
              ]),
        )));
  }
}
