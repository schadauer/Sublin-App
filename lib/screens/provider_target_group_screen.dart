import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:Sublin/models/provider_plan_enum.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/services/provider_user_service.dart';
import 'package:Sublin/services/user_service.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/utils/add_string_to_list.dart';
import 'package:Sublin/utils/is_email_format.dart';
import 'package:Sublin/utils/remove_from_list.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/navigation_bar_widget.dart';

class ProviderTargetGroupScreen extends StatefulWidget {
  static const routeName = './providerTargetGroupScreenState';
  @override
  _ProviderTargetGroupScreenState createState() =>
      _ProviderTargetGroupScreenState();
}

class _ProviderTargetGroupScreenState extends State<ProviderTargetGroupScreen> {
  TextEditingController _emailTextController = TextEditingController();
  // FocusNode _emailFocus;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // _emailFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _emailTextController.dispose();

    // _emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ProviderUser _providerUser = Provider.of<ProviderUser>(context);
    List<dynamic> _targetGroupUser;
    List<dynamic> _targetGroupProviderUser;
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;
    final double _seachBarHeight = 100.0;
    final double _navigationHeight = 182.0;
    final _bodyHeight = _screenHeight - _seachBarHeight - _navigationHeight;

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        bottomNavigationBar: NavigationBarWidget(
          isProvider: true,
          setNavigationIndex: 2,
          providerUser: _providerUser,
        ),
        appBar: AppbarWidget(title: 'Zielgruppe'),
        body: SafeArea(
            child: Container(
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<User>(
              stream: UserService().streamUser(_providerUser.uid),
              builder: (context, snapshot) {
                User _user = snapshot.data;
                if (snapshot.hasData) {
                  // if (snapshot.data.targetGroup.length != 0) {
                  // Show this if "providerPlan" is set to "emailOnly" and emails are in the target group
                  return Column(
                    children: [
                      if (_providerUser.providerPlan == ProviderPlan.emailOnly)
                        Container(
                          color: Theme.of(context).primaryColor,
                          height: _seachBarHeight,
                          child: Padding(
                            padding: ThemeConstants.largePadding,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Form(
                                    key: _formKey,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          hintText: 'E-Mailadresse hinzufügen'),
                                      // focusNode: _emailFocus,
                                      controller: _emailTextController,
                                      validator: (e) {
                                        String _message;
                                        if (!isEmailFormat(e))
                                          _message =
                                              'Bitte gib eine gültige E-Mailadresse an';
                                        return _message;
                                      },
                                      onChanged: (value) =>
                                          print(_emailTextController.text),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    try {
                                      if (_formKey.currentState.validate()) {
                                        _targetGroupUser = addStringToList(
                                            _user.targetGroup,
                                            _emailTextController.text);
                                        print(_emailTextController.text);
                                        await UserService()
                                            .updateTargetGroupUserData(
                                                uid: _user.uid,
                                                targetGroupList:
                                                    _targetGroupUser);
                                        ProviderUser _providerUser =
                                            await ProviderUserService()
                                                .getProviderUser(_user.uid);
                                        _targetGroupProviderUser =
                                            addStringToList(
                                                _providerUser.targetGroup,
                                                sha256
                                                    .convert(utf8.encode(
                                                        _emailTextController
                                                            .text))
                                                    .toString());
                                        print(_targetGroupProviderUser);
                                        await ProviderUserService()
                                            .updateTargetGroupProviderUser(
                                                uid: _user.uid,
                                                targetGroupList:
                                                    _targetGroupProviderUser);
                                        _emailTextController.clear();
                                        // _emailFocus.requestFocus();
                                      }
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                  child: SizedBox(
                                    width: 60,
                                    child: Icon(
                                      Icons.add,
                                      size: 40.0,
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (_user.targetGroup.length != 0)
                        SizedBox(
                          height: _bodyHeight,
                          child: ListView.builder(
                              itemCount: _user.targetGroup.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                    child: Padding(
                                  padding: ThemeConstants.largePadding,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Text(_user.targetGroup[index]),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          String emailToRemove =
                                              _user.targetGroup[index];
                                          _targetGroupUser = removeFromList(
                                              _user.targetGroup,
                                              _user.targetGroup[index]);
                                          await UserService()
                                              .updateTargetGroupUserData(
                                                  uid: _user.uid,
                                                  targetGroupList:
                                                      _targetGroupUser);
                                          ProviderUser _providerUser =
                                              await ProviderUserService()
                                                  .getProviderUser(_user.uid);
                                          _targetGroupProviderUser =
                                              removeFromList(
                                                  _providerUser.targetGroup,
                                                  sha256
                                                      .convert(utf8.encode(
                                                          emailToRemove))
                                                      .toString());
                                          await ProviderUserService()
                                              .updateTargetGroupProviderUser(
                                                  uid: _user.uid,
                                                  targetGroupList:
                                                      _targetGroupProviderUser);
                                        },
                                        child: SizedBox(
                                          width: 50.0,
                                          child: Icon(
                                            Icons.remove,
                                            size: 40.0,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ));
                              }),
                        )
                      else if (_providerUser.providerPlan ==
                              ProviderPlan.emailOnly &&
                          _user.targetGroup.length == 0)
                        SizedBox(
                          height: _bodyHeight,
                          width: _screenWidth / 1.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error,
                                size: 60.0,
                                color: Theme.of(context).errorColor,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Keine Zielgruppe definiert',
                                style: Theme.of(context).textTheme.headline1,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Derzeit kann keiner deinen Service in Anspruch nehmen. Bitte füge E-Mailadressen hinzu oder gib deinen Dienst für alle frei.',
                                style: Theme.of(context).textTheme.bodyText1,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              RaisedButton(
                                  onPressed: () async {
                                    await ProviderUserService()
                                        .updateProviderPlanProviderUserData(
                                            uid: _user.uid,
                                            providerPlan: ProviderPlan.all);
                                  },
                                  child: Text('Für alle freigeben')),
                            ],
                          ),
                        )
                      else
                        SizedBox(
                          height: _bodyHeight,
                          width: _screenWidth / 1.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: _screenWidth / 1.5,
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.group,
                                      size: 60.0,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Keine Einschränkung',
                                      style:
                                          Theme.of(context).textTheme.headline1,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Derzeit können alle deinen Shuttledienst vom Bahnhof zu deiner Addresse in Anspruch nehmen.',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    RaisedButton(
                                        onPressed: () async {
                                          await ProviderUserService()
                                              .updateProviderPlanProviderUserData(
                                                  uid: _user.uid,
                                                  providerPlan:
                                                      ProviderPlan.emailOnly);
                                        },
                                        child: Text('Zielgruppe einschränken')),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
        )));
  }
}
