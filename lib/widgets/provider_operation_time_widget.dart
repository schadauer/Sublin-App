import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/timespan_enum.dart';
import 'package:Sublin/services/provider_user_service.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/utils/get_date_time_from_int.dart';
import 'package:Sublin/utils/get_int_from_date_time.dart';
import 'package:Sublin/widgets/time_field_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ProviderOperationTimeWidget extends StatelessWidget {
  const ProviderOperationTimeWidget({
    Key key,
    @required ProviderUser providerUser,
  })  : _providerUser = providerUser,
        super(key: key);

  final ProviderUser _providerUser;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: ThemeConstants.largePadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                'Deine Betriebszeiten',
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                      flex: 2,
                      child: TimeFildWidget(
                        initalTime: getDateTimeFromInt(_providerUser.timeStart),
                        timespan: Timespan.start,
                        timeInputCallback: _timeInputCallback,
                      )),
                  Flexible(flex: 1, child: Text('bis')),
                  Flexible(
                      flex: 2,
                      child: TimeFildWidget(
                        initalTime: getDateTimeFromInt(_providerUser.timeEnd),
                        timespan: Timespan.end,
                        timeInputCallback: _timeInputCallback,
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _timeInputCallback(Timespan timespan, DateTime time) async {
    switch (timespan) {
      case Timespan.start:
        _providerUser.timeStart = getIntFromDateTime(time);
        break;
      case Timespan.end:
        _providerUser.timeEnd = getIntFromDateTime(time);
        break;
    }
    await ProviderUserService().setProviderUserData(
        providerUser: _providerUser, uid: _providerUser.uid);
  }
}
