import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:Sublin/models/timespan.dart';

class TimeFildWidget extends StatelessWidget {
  final format = DateFormat("HH:mm");
  final Timespan timespan;
  final Function timeInputCallback;
  final DateTime initalTime;

  TimeFildWidget({
    this.timespan,
    this.timeInputCallback,
    this.initalTime,
  });

  // TextEditingController _timeFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      DateTimeField(
        initialValue: initalTime,
        resetIcon: null,
        format: format,
        decoration: InputDecoration(contentPadding: EdgeInsets.all(10)),
        onChanged: (time) {
          timeInputCallback(timespan, time);
        },
        onShowPicker: (context, currentValue) async {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            builder: (BuildContext context, Widget child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
                child: child,
              );
            },
          );
          return DateTimeField.convert(time);
        },
      ),
    ]);
  }
}
