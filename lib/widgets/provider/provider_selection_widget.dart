import 'package:flutter/material.dart';
import 'package:sublin/models/provider_selection.dart';

class ProviderSelectionWidget extends StatelessWidget {
  final String title;
  final String text;
  final String caption;
  final ProviderType providerSelection;
  final Function providerSelectionFunction;
  final bool active;
  const ProviderSelectionWidget({
    this.title,
    this.text,
    this.caption,
    this.providerSelection,
    this.providerSelectionFunction,
    this.active,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          providerSelectionFunction(providerSelection);
        },
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: active
                    ? Icon(Icons.radio_button_checked)
                    : Icon(Icons.radio_button_unchecked),
              ),
              Flexible(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(title,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.bodyText1),
                        Text(text, style: Theme.of(context).textTheme.caption),
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
