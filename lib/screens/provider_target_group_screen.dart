import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/models/user_type_enum.dart';
import 'package:Sublin/services/provider_service.dart';
import 'package:Sublin/services/provider_user_service.dart';
import 'package:Sublin/services/user_service.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/navigation_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderTargetGroupScreen extends StatefulWidget {
  static const routeName = './providerTargetGroupScreenState';
  @override
  _ProviderTargetGroupScreenState createState() =>
      _ProviderTargetGroupScreenState();
}

class _ProviderTargetGroupScreenState extends State<ProviderTargetGroupScreen> {
  TextEditingController _controller;
  @override
  Widget build(BuildContext context) {
    final User _user = Provider.of<User>(context);
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;
    final double _seachBarHeight = 80.0;
    final double _navigationHeight = 182.0;

    return Scaffold(
        bottomNavigationBar:
            NavigationBarWidget(isProvider: _user.userType != UserType.user),
        appBar: AppbarWidget(title: 'Zielgruppe'),
        body: SafeArea(
            child: Column(
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              width: MediaQuery.of(context).size.width,
              height: _seachBarHeight,
              child: Padding(
                padding: ThemeConstants.largePadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 6,
                      child: TextFormField(
                        initialValue: 'test@test.com',
                        enableSuggestions: true,
                        autofillHints: ['Email'],
                        controller: _controller,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        _controller.text;
                        try {
// UserService().addEmailToTargetGroupUserData();
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
            SizedBox(
                height: _screenHeight - _seachBarHeight - _navigationHeight,
                child: StreamBuilder<User>(
                    stream: UserService().streamUser(_user.uid),
                    builder: (context, snapshot) {
                      User _user = snapshot.data;
                      if (snapshot.hasData) {
                        return ListView.builder(
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
                                    SizedBox(
                                      width: 50.0,
                                      child: Icon(
                                        Icons.remove,
                                        size: 40.0,
                                      ),
                                    )
                                  ],
                                ),
                              ));
                            });
                      } else {
                        return Column(
                          children: [
                            SizedBox(
                              width: _screenWidth / 1.5,
                              child: Column(
                                children: [
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
                                      onPressed: null,
                                      child: Text('Zielgruppe einschränken')),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    })),
          ],
        )));
  }
}
