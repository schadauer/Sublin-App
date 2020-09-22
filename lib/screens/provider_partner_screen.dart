import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';

import 'package:Sublin/models/provider_plan_enum.dart';
import 'package:Sublin/models/provider_type.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/services/provider_user_service.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/navigation_bar_widget.dart';

enum PartnerStatus {
  active,
  needsPartnerApproval,
  needsOwnApproval,
}

class ProviderPartnerScreen extends StatefulWidget {
  static const routeName = './providerPartnerScreenState';
  @override
  _ProviderPartnerScreenState createState() => _ProviderPartnerScreenState();
}

class _ProviderPartnerScreenState extends State<ProviderPartnerScreen> {
  TextEditingController _emailTextController = TextEditingController();
  // FocusNode _emailFocus;

  @override
  void dispose() {
    _emailTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ProviderUser providerUser = Provider.of<ProviderUser>(context);
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;
    final double _navigationHeight = 182.0;
    final _bodyHeight = _screenHeight - _navigationHeight;

    return Scaffold(
        bottomNavigationBar: NavigationBarWidget(
          isProvider: true,
          setNavigationIndex:
              providerUser.providerType == ProviderType.taxi ? 2 : 3,
          providerUser: providerUser,
        ),
        appBar: AppbarWidget(title: 'Partner'),
        body: SafeArea(
            child: Container(
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder<List<ProviderUser>>(
              future: _getProvidersAsPartners(providerUser: providerUser),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<ProviderUser> _providerUserList = snapshot.data;

                  // if (snapshot.data.targetGroup.length != 0) {
                  // Show this if "providerPlan" is set to "emailOnly" and emails are in the target group
                  return Column(
                    children: [
                      if (_providerUserList.length != 0)
                        SizedBox(
                          height: _bodyHeight,
                          child: GridView.builder(
                            itemCount: _providerUserList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: (itemWidth / itemHeight),
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              PartnerStatus partnerStatus = _getPartnerStatus(
                                  providerUserPartner: _providerUserList[index],
                                  providerUserOwn: providerUser);
                              return Card(
                                  child: Padding(
                                padding: ThemeConstants.largePadding,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (partnerStatus == PartnerStatus.active)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(
                                            Icons.verified_user,
                                            size: 40.0,
                                            color:
                                                ThemeConstants.sublinMainColor,
                                          ),
                                          Text(
                                            'Bestätigt',
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption,
                                          ),
                                        ],
                                      ),
                                    if (partnerStatus ==
                                        PartnerStatus.needsPartnerApproval)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(
                                            Icons.update,
                                            size: 40.0,
                                            color: Theme.of(context).errorColor,
                                          ),
                                          Text(
                                            'Nicht bestätigt',
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption,
                                          ),
                                        ],
                                      ),
                                    if (partnerStatus ==
                                        PartnerStatus.needsOwnApproval)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(
                                            Icons.error,
                                            size: 40.0,
                                            color: Theme.of(context).errorColor,
                                          ),
                                          Text(
                                            'Nicht bestätigt',
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption,
                                          ),
                                        ],
                                      ),
                                    SizedBox(height: 20),
                                    AutoSizeText(
                                      _providerUserList[index].providerName,
                                      style:
                                          Theme.of(context).textTheme.headline1,
                                    ),
                                    if (providerUser.providerType !=
                                        ProviderType.taxi)
                                      AutoSizeText(
                                        '${_providerUserList[index].providerName} führt für dich derzeit Transferservices durch.',
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                    if (providerUser.providerType ==
                                        ProviderType.taxi)
                                      AutoSizeText(
                                        'Du führst Transferservices für ${_providerUserList[index].providerName} durch.',
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                    if (partnerStatus ==
                                        PartnerStatus.needsOwnApproval)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          RaisedButton(
                                              onPressed: () async {
                                                List<String> _partners = [
                                                  ...providerUser.partners
                                                ];
                                                _partners.add(
                                                    _providerUserList[index]
                                                        .uid);
                                                await ProviderUserService()
                                                    .updatePartnersProviderUser(
                                                        uid: providerUser.uid,
                                                        partners: _partners);
                                              },
                                              child:
                                                  AutoSizeText('Akzeptieren')),
                                        ],
                                      ),
                                    if (partnerStatus == PartnerStatus.active)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          FlatButton(
                                              onPressed: () async {
                                                List<String> _partners = [
                                                  ...providerUser.partners
                                                ];
                                                _partners.remove(
                                                    _providerUserList[index]
                                                        .uid);
                                                await ProviderUserService()
                                                    .updatePartnersProviderUser(
                                                        uid: providerUser.uid,
                                                        partners: _partners);
                                              },
                                              child: AutoSizeText('Aussetzen')),
                                        ],
                                      )
                                  ],
                                ),
                              ));
                            },
                          ),
                        )
                      else if (providerUser.providerPlan ==
                              ProviderPlan.emailOnly &&
                          _providerUserList.length == 0)
                        SizedBox(
                          height: _bodyHeight,
                          width: _screenWidth / 1.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error,
                                size: 60.0,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Keine Partner vorhanden',
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
                                  onPressed: null,
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
                                        onPressed: null,
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

  Future<List<ProviderUser>> _getProvidersAsPartners(
      {ProviderUser providerUser}) async {
    List<ProviderUser> providerUserList = await ProviderUserService()
        .getProvidersAsPartners(uid: providerUser.uid);
    print(providerUserList);
    List<String> _unapprovedProviderUserListByUid = [...providerUser.partners];
    // Sponsors may have an unapproved partner which we need to show here as well
    if (providerUser.providerType == ProviderType.sponsor ||
        providerUser.providerType == ProviderType.sponsorShuttle ||
        providerUser.providerType == ProviderType.taxi) {
      //Let's check if all partners in the current partners list are in the _providerUserList
      if (providerUserList.length != 0) {
        providerUser.partners.forEach((partnerUidFromPartnerList) {
          providerUserList.forEach((partner) {
            if (partner.uid == partnerUidFromPartnerList)
              // If we find the partner remove it from the list
              _unapprovedProviderUserListByUid
                  .remove(partnerUidFromPartnerList);
          });
        });
      }
      // If we find unapproved partners we need to loop through them and get data from them
      // List<ProviderUser> _providerUserListAdded = [];
      return await _addUnapprovedProviderUsersToApprovedList(
          approvedProviderUserList: providerUserList,
          unapprovedProviderUserList: _unapprovedProviderUserListByUid);

      // return providerUserList;
    } else {
      return providerUserList;
    }
  }

  Future<List<ProviderUser>> _addUnapprovedProviderUsersToApprovedList(
      {List<ProviderUser> approvedProviderUserList,
      List<String> unapprovedProviderUserList}) async {
    for (String unapprovedProviderUserUid in unapprovedProviderUserList) {
      ProviderUser _unapprovedProviderUser = await ProviderUserService()
          .getProviderUser(unapprovedProviderUserUid);
      approvedProviderUserList.add(_unapprovedProviderUser);
    }
    return approvedProviderUserList;
  }

  PartnerStatus _getPartnerStatus(
      {ProviderUser providerUserPartner, ProviderUser providerUserOwn}) {
    PartnerStatus partnerStatus;
    bool partnerHasOurUid =
        providerUserPartner.partners.contains(providerUserOwn.uid);
    bool weHavePartnerUid =
        providerUserOwn.partners.contains(providerUserPartner.uid);
    if (partnerHasOurUid && weHavePartnerUid)
      partnerStatus = PartnerStatus.active;
    else if (partnerHasOurUid && !weHavePartnerUid)
      partnerStatus = PartnerStatus.needsOwnApproval;
    else if (!partnerHasOurUid && weHavePartnerUid)
      partnerStatus = PartnerStatus.needsPartnerApproval;

    return partnerStatus;
  }
}
