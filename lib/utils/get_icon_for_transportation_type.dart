import 'package:Sublin/models/transportation_type_enum.dart';
import 'package:flutter/material.dart';

Icon getIconForTransportationType(TransportationType transportationType) {
  if (transportationType != null) {
    switch (transportationType) {
      case TransportationType.public:
        return Icon(
          Icons.train,
          color: Colors.white,
        );
        break;
      case TransportationType.walking:
        return Icon(
          Icons.transfer_within_a_station,
          color: Colors.white,
        );
        break;
      case TransportationType.sublin:
        return Icon(
          Icons.local_taxi,
          color: Colors.white,
        );
        break;
      case TransportationType.privat:
        return Icon(
          Icons.directions_car,
          color: Colors.white,
        );
        break;
    }
  } else
    return null;
}
