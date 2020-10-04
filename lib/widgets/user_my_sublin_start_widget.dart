import 'package:Sublin/models/address_info_class.dart';
import 'package:Sublin/models/transportation_type_enum.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/screens/address_input_screen.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/utils/get_readable_address_from_formatted_address.dart';
import 'package:Sublin/widgets/address_search_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:Sublin/widgets/step_icon_widget.dart';

class UserMySublinStartWidget extends StatelessWidget {
  final String startAddress;
  final User user;
  final Function addressInputCallback;
  final TransportationType transportationType;
  final List<AddressInfo> addressInfoList;

  UserMySublinStartWidget({
    this.startAddress = '',
    this.user,
    this.addressInputCallback,
    this.transportationType,
    this.addressInfoList,
  });

  @override
  Widget build(BuildContext context) {
    AddressInfo _addressInfo =
        _getAddressInfoFromFormattedAddress(addressInfoList, startAddress);
    return (startAddress != '')
        ? SizedBox(
            height: 130,
            child: Stack(children: <Widget>[
              SizedBox(
                height: double.infinity,
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    margin: EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(0),
                          width: 70,
                          height: 80,
                          color: Colors.white54,
                        ),
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  'Mein Standort',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                AutoSizeText(
                                  '${getReadableAddressFromFormattedAddress(startAddress)}',
                                  style: Theme.of(context).textTheme.headline2,
                                  maxLines: 2,
                                  minFontSize: 16,
                                  // textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                if (_addressInfo.transportationType ==
                                    TransportationType.public)
                                  AutoSizeText(
                                    'Öffentlicher Verkehr',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                if (_addressInfo.transportationType ==
                                    TransportationType.privat)
                                  AutoSizeText(
                                    'Derzeit kein Sublin Service zum Bahnhof',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                if (_addressInfo.transportationType ==
                                    TransportationType.sublin)
                                  AutoSizeText(
                                    'Shuttle Service zum Bahnhof',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                if (_addressInfo.transportationType ==
                                    TransportationType.notAvailable)
                                  AutoSizeText(
                                    'Diese Addresse ist leider nicht verfügbar. Bitte wähle eine andere Addresse aus.',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: Padding(
                              padding: ThemeConstants.mediumPadding,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddressInputScreen(
                                                userUid: user.uid,
                                                user: user,
                                                addressInputCallback:
                                                    addressInputCallback,
                                                isEndAddress: false,
                                                isStartAddress: true,
                                                showGeolocationOption: true,
                                                isStation: false,
                                                title: 'Dein Standort',
                                                addressInfoList:
                                                    addressInfoList,
                                              )));
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      size: 25,
                                    ),
                                    Text(
                                      'ändern',
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    )
                                  ],
                                ),
                              ),
                            ))
                      ],
                    )),
              ),
              StepIconWidget(
                transportationType: _addressInfo.transportationType,
                isStartAddress: true,
                isEndAddress: true,
                icon: Icons.train,
                iconSize: 35.0,
              ),
            ]),
          )
        : SizedBox(
            height: 80,
            width: MediaQuery.of(context).size.width,
            child: AddressSearchWidget(
              userUid: user.uid,
              user: user,
              startHintText: 'Deinen Standort eingeben',
              isStartAddress: true,
              isEndAddress: false,
              startAddress: '',
              isCheckOnly: true,
              addressInputFunction: addressInputCallback,
              addressInfoList: addressInfoList,
            ),
          );
  }
}

AddressInfo _getAddressInfoFromFormattedAddress(
    List<AddressInfo> addressInfoList, String formattedAddress) {
  AddressInfo _addressInfo = AddressInfo();
  addressInfoList.forEach((addressInfo) {
    if (addressInfo.formattedAddress.contains(formattedAddress))
      _addressInfo = addressInfo;
  });
  if (_addressInfo.formattedAddress == null) {
    _addressInfo.formattedAddress = formattedAddress;
    _addressInfo.transportationType = TransportationType.notAvailable;
  }
  return _addressInfo;
}
