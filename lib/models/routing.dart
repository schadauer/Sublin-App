import 'package:sublin/models/step.dart';

class Routing {
  String id;
  bool booked;
  bool confirmed;
  Map<dynamic, dynamic> provider;
  String user;
  String startAddress;
  String startId;
  String endAddress;
  String endId;
  List<Step> publicSteps;
  Map<dynamic, dynamic> unavailableAddress;
  Map<dynamic, dynamic> sublinEndStep;

  Routing({
    this.id = '',
    this.booked = false,
    this.confirmed = false,
    this.provider,
    this.user = '',
    this.startAddress = '',
    this.startId = '',
    this.endAddress = '',
    this.endId = '',
    this.publicSteps,
    this.unavailableAddress,
    this.sublinEndStep,
  });

  factory Routing.fromMap(Map data) {
    data = data ?? {};
    return Routing(
      id: data['id'] ?? '',
      booked: data['booked'] ?? false,
      confirmed: data['confirmed'] ?? false,
      provider: data['provider'] ?? null,
      sublinEndStep: data['sublinEndStep'] ?? null,
      user: data['user'] ?? '',
      endId: data['endId'] ?? '',
      startId: data['startId'] ?? '',
      unavailableAddress: data['unavailableAddress'] ?? null,
      publicSteps: (data['publicSteps'] == null)
          ? null
          : data['publicSteps'].map<Step>((step) {
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
      provider: {},
    );
  }
}
