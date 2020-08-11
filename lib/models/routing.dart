import 'package:Sublin/models/address.dart';
import 'package:Sublin/models/provider_plan.dart';
import 'package:Sublin/models/provider_type.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/step.dart';

class Routing {
  final bool streamingOn;
  String id;
  bool booked;
  bool confirmed;
  // ProviderUser provider;
  String user;
  String startAddress;
  String startId;
  String endAddress;
  bool endAddressAvailable;
  String endId;
  bool checkAddress;
  List<Step> publicSteps;
  Step sublinEndStep;
  Step sublinStartStep;
  DateTime timestamp;

  Routing({
    this.streamingOn = false,
    this.id = '',
    this.booked = false,
    this.confirmed = false,
    // this.provider,
    this.user = '',
    this.startAddress = '',
    this.startId = '',
    this.endAddress,
    this.endAddressAvailable = false,
    this.endId = '',
    this.checkAddress = false,
    this.publicSteps = const [],
    this.sublinEndStep,
    this.sublinStartStep,
    this.timestamp,
  });

  factory Routing.fromMap(Map data) {
    Routing defaultValue = Routing();
    Address defaultValueAddress = Address();
    Step defaultValueStep = Step();
    ProviderUser defaultValueProviderUser = ProviderUser();
    data = data ?? {};
    return Routing(
      streamingOn: true,
      id: data['id'] ?? defaultValue.id,
      booked: data['booked'] ?? defaultValue.booked,
      confirmed: data['confirmed'] ?? defaultValue.confirmed,
      sublinEndStep: (data['sublinEndStep'] == null)
          ? defaultValue.sublinEndStep
          : Step(
              endAddress: data['sublinEndStep']['endAddress'] ??
                  defaultValueStep.endAddress,
              startAddress: data['sublinEndStep']['startAddress'] ??
                  defaultValueStep.startAddress,
              startTime: data['sublinEndStep']['startTime'] ??
                  defaultValueStep.startTime,
              endTime:
                  data['sublinEndStep']['endTime'] ?? defaultValueStep.endTime,
              provider: (data['sublinEndStep']['provider'] == null)
                  ? defaultValueStep.provider
                  : ProviderUser(
                      providerType: ProviderType.values.firstWhere(
                          (e) =>
                              e.toString() ==
                              'ProviderType.' +
                                  data['sublinEndStep']['provider']
                                      ['providerType'],
                          orElse: () => defaultValueProviderUser.providerType),
                      providerPlan: ProviderPlan.values.firstWhere(
                          (e) =>
                              e.toString() ==
                              'providerPlan.' +
                                  data['sublinEndStep']['provider']
                                      ['providerPlan'],
                          orElse: () => defaultValueProviderUser.providerPlan),
                      providerName: data['sublinEndStep']['provider']
                              ['providerName'] ??
                          defaultValueProviderUser.providerName,
                      id: data['sublinEndStep']['provider']['id'] ??
                          defaultValueProviderUser.id,
                      timeStart: data['sublinEndStep']['provider']
                              ['timeStart'] ??
                          defaultValueProviderUser.timeStart,
                      timeEnd: data['sublinEndStep']['provider']['timeEnd'] ??
                          defaultValueProviderUser.timeEnd,
                    ),
              distance: data['sublinEndStep']['distance'] ??
                  defaultValueStep.distance,
              duration: data['sublinEndStep']['duration'] ??
                  defaultValueStep.duration,
            ),
      sublinStartStep: (data['sublinStartStep'] == null)
          ? defaultValue.sublinEndStep
          : Step(
              endAddress: data['sublinStartStep']['endAddress'] ??
                  defaultValueStep.endAddress,
              startAddress: data['sublinStartStep']['startAddress'] ??
                  defaultValueStep.startAddress,
              startTime: data['sublinStartStep']['startTime'] ??
                  defaultValueStep.startTime,
              endTime: data['sublinStartStep']['endTime'] ??
                  defaultValueStep.endTime,
              provider: (data['sublinStartStep']['provider'] == null)
                  ? defaultValueStep.provider
                  : ProviderUser(
                      // outOfWork: data['sublinStartStep']['endAddress']
                      //         ['provider']['outOfWork'] ??
                      // defaultValueProviderUser.outOfWork,
                      providerName: data['sublinStartStep']['provider']
                              ['providerName'] ??
                          defaultValueProviderUser.providerName,
                      id: data['sublinStartStep']['provider']['id'] ??
                          defaultValueProviderUser.id,
                      timeStart: data['sublinStartStep']['provider']
                              ['timeStart'] ??
                          defaultValueProviderUser.timeStart,
                      timeEnd: data['sublinStartStep']['provider']['timeEnd'] ??
                          defaultValueProviderUser.timeEnd,
                    ),
              distance: data['sublinStartStep']['distance'] ??
                  defaultValueStep.distance,
              duration: data['sublinStartStep']['duration'] ??
                  defaultValueStep.duration,
            ),
      user: data['user'] ?? defaultValue.user,
      endId: data['endId'] ?? defaultValue.endId,
      endAddress: data['endAddress'] ?? defaultValue.endAddress,
      startId: data['startId'] ?? defaultValue.startId,
      startAddress: data['startAddress'] ?? defaultValue.startAddress,
      checkAddress: data['checkAddress'] ?? defaultValue.checkAddress,
      endAddressAvailable:
          data['endAddressAvailable'] ?? defaultValue.endAddressAvailable,
      // endAddress: (data['endAddress'] == null)
      //     ? defaultValueAddress
      //     : Address(
      //         id: data['endAddress']['id'] ?? defaultValueAddress.id,
      //         city: data['endAddress']['city'] ?? defaultValueAddress.city,
      //         country:
      //             data['endAddress']['country'] ?? defaultValueAddress.country,
      //         district: data['endAddress']['district'] ??
      //             defaultValueAddress.district,
      //         postcode: data['endAddress']['postcode'] ??
      //             defaultValueAddress.postcode,
      //         street:
      //             data['endAddress']['street'] ?? defaultValueAddress.street,
      //         state: data['endAddress']['state'] ?? defaultValueAddress.state,
      //         formattedAddress: data['endAddress']['formattedAddress'] ??
      //             defaultValueAddress.formattedAddress,
      //       ),
      publicSteps: (data['publicSteps'] == null)
          ? defaultValue.publicSteps
          : data['publicSteps'].map<Step>((step) {
              // Step defaultValueStep = Step();
              return Step(
                endAddress: step['endAddress'] ?? defaultValueStep.endAddress,
                startAddress:
                    step['startAddress'] ?? defaultValueStep.startAddress,
                startTime: step['startTime'] ?? defaultValueStep.startTime,
                endTime: step['endTime'] ?? defaultValueStep.endTime,
                // provider: step['provider'] ?? defaultValueStep.provider,
                distance: step['distance'] ?? defaultValueStep.distance,
                duration: step['duration'] ?? defaultValueStep.duration,
              );
            }).toList(),
    );
  }
}
