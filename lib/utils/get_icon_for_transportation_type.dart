import 'package:Sublin/models/transportation_type_enum.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:flutter/material.dart';

Container getIconForTransportationType(TransportationType transportationType) {
  return Container(
      height: 30,
      width: 30,
      // decoration: BoxDecoration(
      //   shape: BoxShape.circle,
      // ),
      child: FittedBox(
          fit: BoxFit.fill,
          child: (() {
            switch (transportationType) {
              case TransportationType.public:
                return Icon(
                  Icons.train,
                  color: Colors.black,
                );
                break;
              case TransportationType.walking:
                return Icon(
                  Icons.transfer_within_a_station,
                  color: Colors.black,
                );
                break;
              case TransportationType.sublin:
                return Icon(
                  Icons.local_taxi,
                  color: ThemeConstants.sublinMainColor,
                );
                break;
              case TransportationType.privat:
                return Icon(
                  Icons.directions_car,
                  color: Colors.black,
                );
                break;
              default:
                return Icon(
                  Icons.directions_car,
                  color: Colors.black,
                );
            }
          }())));
}
