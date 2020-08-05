import 'package:flutter/material.dart';
import 'package:Sublin/models/provider_plan.dart';
import 'package:Sublin/models/provider_type.dart';

class ProviderSelectionWidget extends StatelessWidget {
  final String title;
  final String text;
  final String caption;
  final Function buttonFunction;
  final String buttonText;
  final ProviderType providerSelection;
  final ProviderPlan providerPlanSelection;
  final bool isProvider;
  final Function selectionFunction;
  final bool active;
  const ProviderSelectionWidget({
    this.title,
    this.text = '',
    this.caption,
    this.buttonFunction,
    this.buttonText: '',
    this.providerSelection,
    this.isProvider,
    this.selectionFunction,
    this.providerPlanSelection,
    this.active,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(providerSelection ?? providerPlanSelection ?? isProvider);
    return Card(
      child: InkWell(
        onTap: () {
          selectionFunction(
              providerSelection ?? providerPlanSelection ?? isProvider);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: active
                    ? Icon(Icons.radio_button_checked)
                    : Icon(Icons.radio_button_unchecked),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(title,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.bodyText1),
                        if (text != '')
                          Text(text,
                              style: Theme.of(context).textTheme.caption),
                        if (buttonFunction != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  RaisedButton(
                                      onPressed: () {
                                        buttonFunction(context);
                                      },
                                      child: Text(buttonText)),
                                ],
                              ),
                            ],
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
