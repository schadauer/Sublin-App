import 'package:Sublin/models/direction_enum.dart';
import 'package:Sublin/models/routing_class.dart';
import 'package:Sublin/models/step_class.dart' as sublin;
import 'package:Sublin/widgets/progress_indicator_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class UserStepNotificationWidget extends StatelessWidget {
  const UserStepNotificationWidget({
    Key key,
    @required this.routingService,
    this.direction = Direction.start,
  }) : super(key: key);

  final Routing routingService;
  final Direction direction;

  @override
  Widget build(BuildContext context) {
    sublin.Step step = direction == Direction.start
        ? routingService.sublinStartStep
        : routingService.sublinEndStep;

    return Container(
      color: Theme.of(context).secondaryHeaderColor,
      height: 60,
      child: Column(
        children: [
          if (direction == Direction.start && step.confirmed == false)
            ProgressIndicatorWidget(
              index: 1,
              elements: 4,
              showProgressIndicator: true,
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 70,
                padding: EdgeInsets.only(left: 10),
                child: Center(
                  child: Icon(
                    (step.confirmed == false)
                        ? Icons.alarm
                        : Icons.check_circle,
                    size: 50.0,
                  ),
                ),
              ),
              Container(
                height: 50,
                padding: EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width - 70,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    (step.confirmed == false)
                        ? 'Wir benachrichten dich, sobald ${step.provider?.providerName} deine Abholung bestätigt hat.'
                        : step.completed == false
                            ? '${step.provider?.providerName} hat deine Abholung bestätigt.'
                            : '${step.provider?.providerName} hat deine Abholung ab abgeschlossen.',
                    style: Theme.of(context).textTheme.caption,
                    maxLines: 2,
                  ),
                ),
              )
            ],
          ),
          if (direction == Direction.end && step.confirmed == false)
            ProgressIndicatorWidget(
              index: 1,
              elements: 4,
              showProgressIndicator: true,
            ),
        ],
      ),
    );
  }
}
