import 'package:Sublin/models/provider_type_enum.dart';
import 'package:Sublin/models/provider_user.dart';
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
            child: Column(
          children: [AutoSizeText('Bitte um Geduld')],
        )));
  }
}
