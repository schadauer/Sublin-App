import 'package:Sublin/models/user_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:Sublin/models/provider_plan_enum.dart';
import 'package:Sublin/models/provider_type_enum.dart';

class ProviderSelectionWidget extends StatelessWidget {
  final String title;
  final String text;
  final String caption;
  final Function buttonFunction;
  final String buttonText;
  final ProviderType providerTypeSelection;
  final ProviderPlan providerPlanSelection;
  final UserType userType;
  final Function selectionFunction;
  final bool active;
  const ProviderSelectionWidget({
    this.title,
    this.text = '',
    this.caption,
    this.buttonFunction,
    this.buttonText: '',
    this.providerTypeSelection,
    this.userType,
    this.selectionFunction,
    this.providerPlanSelection,
    this.active,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).accentColor,
      child: InkWell(
        onTap: () {
          selectionFunction(
              userType ?? providerTypeSelection ?? providerPlanSelection);
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
                            style: Theme.of(context).textTheme.headline1),
                        SizedBox(
                          height: 4,
                        ),
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
