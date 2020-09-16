import 'package:Sublin/models/my_card_format_enum.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/request_class.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:flutter/material.dart';

class UserMySublinHeroCardScreen extends StatelessWidget {
  const UserMySublinHeroCardScreen(
      {Key key,
      @required Request localRequest,
      @required this.providerUser,
      @required this.itemWidth,
      @required this.itemHeight,
      @required this.user,
      @required this.context,
      @required this.myCardFormat,
      this.onHeroTap})
      : localRequest = localRequest,
        super(key: key);

  final Request localRequest;
  final ProviderUser providerUser;
  final double itemWidth;
  final double itemHeight;
  final User user;
  final BuildContext context;
  final MyCardFormat myCardFormat;
  final VoidCallback onHeroTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Hero(
          tag: providerUser,
          child: Material(
            child: InkWell(onTap: onHeroTap),
          )),
    );
  }
}
