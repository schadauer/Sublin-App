import 'package:Sublin/models/address_info_class.dart';
import 'package:Sublin/models/transportation_type_enum.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/screens/address_input_screen.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/utils/get_readable_address_from_formatted_address.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:Sublin/widgets/step_icon_widget.dart';
import 'package:Sublin/utils/get_time_format.dart';

class UserMySublinStartCardWidget extends StatelessWidget {
  final String startAddress;
  final User user;
  final Function addressInputFunction;
  final TransportationType transportationType;
  final List<AddressInfo> addressInfoList;

  UserMySublinStartCardWidget({
    this.startAddress = '',
    this.user,
    this.addressInputFunction,
    this.transportationType,
    this.addressInfoList,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        'Mein Standort',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      AutoSizeText(
                        '${getReadableAddressFromFormattedAddress(startAddress)}',
                        style: Theme.of(context).textTheme.bodyText1,
                        maxLines: 2,
                        minFontSize: 16,
                        // textAlign: TextAlign.center,
                      ),
                    ],
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
                                  builder: (context) => AddressInputScreen(
                                        userUid: user.uid,
                                        addressInputCallback:
                                            addressInputFunction,
                                        isEndAddress: false,
                                        isStartAddress: true,
                                        showGeolocationOption: true,
                                        isStation: false,
                                        title: 'Dein Standort',
                                        addressInfoList: addressInfoList,
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
                              style: Theme.of(context).textTheme.caption,
                            )
                          ],
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
        StepIconWidget(
          transportationType: TransportationType.public,
          isStartAddress: true,
          isEndAddress: false,
          icon: Icons.train,
          iconSize: 40.0,
        ),
      ]),
    );
  }
}
