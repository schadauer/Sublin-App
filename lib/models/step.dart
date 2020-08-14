import 'package:Sublin/models/provider_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Step {
  String id;
  // bool booked;
  int bookedTime;
  int confirmedTime;
  int completedTime;
  bool isSublin;
  bool isStart;
  bool isEnd;
  String startAddress;
  String startName;
  String startId;
  String endAddress;
  String endName;
  String endId;
  String stationAddress;
  String stationName;
  ProviderUser provider;
  int startTime;
  int endTime;
  int duration;
  int distance;

  Step({
    this.id,
    // this.booked,
    this.bookedTime,
    this.confirmedTime,
    this.completedTime,
    this.isSublin = false,
    this.isStart = false,
    this.isEnd = false,
    this.startAddress = '',
    this.startName = '',
    this.startId = '',
    this.endAddress = '',
    this.endName = '',
    this.endId = '',
    this.stationAddress = '',
    this.stationName = '',
    this.provider,
    this.startTime = 0,
    this.endTime = 0,
    this.duration = 0,
    this.distance = 0,
  });
}
