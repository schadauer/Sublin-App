import 'dart:core';
import 'package:Sublin/models/user_type_enum.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestPeriodScreen extends StatefulWidget {
  static const routeName = './testPeriodScreen';
  @override
  _TestPeriodScreenState createState() => _TestPeriodScreenState();
}

class _TestPeriodScreenState extends State<TestPeriodScreen> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    return Scaffold(
        appBar: AppbarWidget(title: 'Bitte um Geduld'),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 90.0,
                    child: Image.asset(
                      'assets/images/logo_white_background.png',
                      alignment: Alignment.center,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  if (user.userType == UserType.user)
                    Column(
                      children: [
                        AutoSizeText(
                          'Vielen Dank für deine Registrierung ${user.firstName}!',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        AutoSizeText(
                          'Wir bitten dich um etwas Geduld. Wir befinden uns derzeit in der Textphase mit einer eingeschränkten Benutzergruppe.',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        AutoSizeText(
                          'Wir werden dich über die weiteren Entwicklungen informieren. Sobald wir die Benutzergruppe erweitern werden wir dich informieren.',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        AutoSizeText(
                          'Vielen Dank noch einmal für dein Interesse an Sublin.',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  if (user.userType == UserType.sponsor)
                    Column(
                      children: [
                        AutoSizeText(
                          'Vielen Dank für deine Registrierung ${user.firstName}!',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        AutoSizeText(
                          'Wir bitten dich um etwas Geduld. Wir befinden uns derzeit in der Textphase mit einer eingeschränkten Benutzergruppe.',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        AutoSizeText(
                          'Parallel sind wir auf der Suche nach Fahrdienstleistern, die in Zukunft gesponserte Fahrten durchführen.',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        AutoSizeText(
                          'Falls du Interesse an einer Zusammenarbeit hast, freuen wir uns, von dir zu hören!',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  AutoSizeText(
                    'Andreas Schadauer',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  GestureDetector(
                    onTap: () => launch(_emailLaunchUri.toString()),
                    child: AutoSizeText(
                      'andreas@sublin.app',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (user.userType == UserType.sponsor)
                    GestureDetector(
                      onTap: () => launch(_phoneLaunchUri.toString()),
                      child: AutoSizeText(
                        '+43 699 10651457',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                ]),
          ),
        )));
  }

  final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'andreas@sublin.app',
      queryParameters: {'subject': 'Sublin'});

  final Uri _phoneLaunchUri = Uri(
    scheme: 'tel',
    path: '004369910651457',
  );
}
