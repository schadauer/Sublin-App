import 'package:sublin/models/step.dart';

class Routing {
  String provider;
  String user;
  String startAddress;
  String startId;
  String endAddress;
  String endId;
  List<Step> steps;

  Routing({
    this.provider = '',
    this.user = '',
    this.startAddress = '',
    this.startId = '',
    this.endAddress = '',
    this.endId = '',
    this.steps,
  });

  factory Routing.fromMap(Map data) {
    data = data ?? {};
    return Routing(
      provider: data['provider'] ?? '',
      user: data['user'] ?? '',
      steps: (data['route'] == null)
          ? []
          : data['route'].map<Step>((step) {
              return Step(
                  endAddress: step['endAddress'] ?? '',
                  startAddress: step['startAddress'] ?? '',
                  startTime: step['startTime'] ?? 0,
                  endTime: step['endTime'] ?? 0,
                  provider: step['provider'] ?? '',
                  distance: step['distance'] ?? 0,
                  duration: step['duration'] ?? 0);
            }).toList(),
    );
  }

  factory Routing.initialData() {
    return Routing(
      provider: '',
    );
  }
}
