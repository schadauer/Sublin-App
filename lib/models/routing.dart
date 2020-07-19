import 'package:sublin/models/address.dart';
import 'package:sublin/models/provider_user.dart';
import 'package:sublin/models/step.dart';

class Routing {
  final bool streamingOn;
  String id;
  bool booked;
  bool confirmed;
  ProviderUser provider;
  String user;
  String startAddress;
  String startId;
  Address endAddress;
  bool endAddressAvailable;
  String endId;
  bool checkAddress;
  List<Step> publicSteps;
  Map<dynamic, dynamic> sublinEndStep;
  DateTime timestamp;

  Routing({
    this.streamingOn = false,
    this.id = '',
    this.booked = false,
    this.confirmed = false,
    this.provider,
    this.user = '',
    this.startAddress = '',
    this.startId = '',
    this.endAddress,
    this.endAddressAvailable = false,
    this.endId = '',
    this.checkAddress = false,
    this.publicSteps = const [],
    this.sublinEndStep = const {},
    this.timestamp,
  });

  // factory Routing.initialData() {
  //   return Routing(
  //     provider: {},
  //     streamingOn: false,
  //     checkAddress: false,
  //   );
  // }

  factory Routing.fromMap(Map data) {
    Routing defaultValue = Routing();
    Address defaultValueAddress = Address();
    ProviderUser defaultValueProviderUser = ProviderUser();
    data = data ?? {};
    return Routing(
      streamingOn: true,
      id: data['id'] ?? defaultValue.id,
      booked: data['booked'] ?? defaultValue.booked,
      confirmed: data['confirmed'] ?? defaultValue.confirmed,
      sublinEndStep: data['sublinEndStep'] ?? defaultValue.sublinEndStep,
      user: data['user'] ?? defaultValue.user,
      endId: data['endId'] ?? defaultValue.endId,
      startId: data['startId'] ?? defaultValue.startId,
      checkAddress: data['checkAddress'] ?? defaultValue.checkAddress,
      endAddressAvailable:
          data['endAddressAvailable'] ?? defaultValue.endAddressAvailable,
      provider: (data['provider'] == null)
          ? defaultValueProviderUser
          : ProviderUser(
              isProvider: data['provider']['isProvider'] ??
                  defaultValueProviderUser.isProvider,
              isTaxi:
                  data['provider']['isTaxi'] ?? defaultValueProviderUser.isTaxi,
              operationRequested: data['provider']['operationRequested'] ??
                  defaultValueProviderUser.operationRequested,
              inOperation: data['provider']['inOperation'] ??
                  defaultValueProviderUser.inOperation,
              outOfWork: data['provider']['outOfWork'] ??
                  defaultValueProviderUser.outOfWork,
              name: data['provider']['name'] ?? defaultValueProviderUser.name,
              addresses: data['provider']['addresses'] ??
                  defaultValueProviderUser.addresses,
              // postcodes: data['provider']['postcodes'] ??
              //     defaultValueProviderUser.postcodes,
              // stations: data['provider']['stations'] ??
              //     defaultValueProviderUser.stations,
              timeStart: data['provider']['timeStart'] ??
                  defaultValueProviderUser.timeStart,
              timeEnd: data['provider']['timeEnd'] ??
                  defaultValueProviderUser.timeEnd,
            ),
      endAddress: (data['endAddress'] == null)
          ? defaultValueAddress
          : Address(
              id: data['endAddress']['id'] ?? defaultValueAddress.id,
              city: data['endAddress']['city'] ?? defaultValueAddress.city,
              country:
                  data['endAddress']['country'] ?? defaultValueAddress.country,
              district: data['endAddress']['district'] ??
                  defaultValueAddress.district,
              postcode: data['endAddress']['postcode'] ??
                  defaultValueAddress.postcode,
              street:
                  data['endAddress']['street'] ?? defaultValueAddress.street,
              state: data['endAddress']['state'] ?? defaultValueAddress.state,
              formattedAddress: data['endAddress']['formattedAddress'] ??
                  defaultValueAddress.formattedAddress,
            ),
      publicSteps: (data['publicSteps'] == null)
          ? defaultValue.publicSteps
          : data['publicSteps'].map<Step>((step) {
              Step defaultValueStep = Step();
              return Step(
                endAddress: step['endAddress'] ?? defaultValueStep.endAddress,
                startAddress:
                    step['startAddress'] ?? defaultValueStep.startAddress,
                startTime: step['startTime'] ?? defaultValueStep.startTime,
                endTime: step['endTime'] ?? defaultValueStep.endTime,
                provider: step['provider'] ?? defaultValueStep.provider,
                distance: step['distance'] ?? defaultValueStep.distance,
                duration: step['duration'] ?? defaultValueStep.duration,
              );
            }).toList(),
    );
  }
}
