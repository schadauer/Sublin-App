import 'package:Sublin/models/provider_plan.dart';
import 'package:Sublin/models/provider_type.dart';

class ProviderUser {
  final bool streamingOn;
  // final bool isProvider;
  final bool inOperation;
  bool operationRequested;
  ProviderType providerType;
  ProviderPlan providerPlan;
  bool outOfWork;
  String name;
  String id;
  List<String> targetGroup;
  List<String> addresses;
  List<String> postcodes;
  List<String> stations;
  List<String> partners;
  int timeStart;
  int timeEnd;

  ProviderUser({
    this.streamingOn: false,
    // this.isProvider: true,
    this.providerType,
    this.providerPlan,
    this.operationRequested: false,
    this.inOperation: false,
    this.outOfWork: false,
    this.name: '',
    this.id: '',
    this.targetGroup: const [],
    this.addresses: const [],
    this.postcodes: const [],
    this.stations: const [],
    this.partners: const [],
    this.timeStart: 0,
    this.timeEnd: 2400,
  });

  factory ProviderUser.fromMap(Map data) {
    ProviderUser defaultValues = ProviderUser();
    data = data ?? {};
    return ProviderUser(
      streamingOn: true,
      // isProvider: data['isProvider'] ?? defaultValues.isProvider,
      providerType: ProviderType.values.firstWhere(
          (e) => e.toString() == 'ProviderType.' + data['providerType'],
          orElse: () => defaultValues.providerType),
      providerPlan: ProviderPlan.values.firstWhere(
          (e) => e.toString() == 'providerPlan.' + data['providerPlan'],
          orElse: () => defaultValues.providerPlan),
      operationRequested:
          data['operationRequested'] ?? defaultValues.operationRequested,
      inOperation: data['inOperation'] ?? defaultValues.inOperation,
      outOfWork: data['outOfWork'] ?? defaultValues.inOperation,
      name: data['name'] ?? defaultValues.name,
      id: data['id'] ?? defaultValues.id,
      targetGroup: (data['targetGroup'] == [])
          ? defaultValues.postcodes
          : data['targetGroup'].map<String>((targetG) {
              return targetG.toString();
            }).toList(),
      addresses: (data['addresses'] == [])
          ? defaultValues.postcodes
          : data['addresses'].map<String>((address) {
              return address.toString();
            }).toList(),
      postcodes: (data['postcodes'] == [])
          ? defaultValues.postcodes
          : data['postcodes'].map<String>((postcode) {
              return postcode.toString();
            }).toList(),
      stations: (data['stations'] == [])
          ? defaultValues.stations
          : data['stations'].map<String>((station) {
              return station.toString();
            }).toList(),
      partners: (data['partners'] == [])
          ? defaultValues.partners
          : data['partners'].map<String>((partner) {
              return partner.toString();
            }).toList(),
      timeStart: data['timeStart'] ?? defaultValues.timeStart,
      timeEnd: data['timeEnd'] ?? defaultValues.timeEnd,
    );
  }

  Map<String, dynamic> toMap(ProviderUser data) {
    String providerType = data.providerType.toString();
    String providerPlan = data.providerPlan.toString();
    return {
      // if (data.isProvider != null) 'isProvider': data.isProvider,
      if (data.providerType != null)
        'providerType': providerType.substring(providerType.indexOf('.') + 1),
      if (data.providerPlan != null)
        'providerPlan': providerPlan.substring(providerPlan.indexOf('.') + 1),
      if (data.operationRequested != null)
        'operationRequested': data.operationRequested,
      if (data.inOperation != null)
        'inOperation': data.inOperation,
      if (data.outOfWork != null)
        'outOfWork': data.outOfWork,
      if (data.name != null)
        'name': data.name,
      if (data.id != null)
        'id': data.id,
      if (data.targetGroup != null)
        'targetGroup': data.targetGroup,
      if (data.addresses != null)
        'addresses': data.addresses,
      if (data.postcodes != null)
        'postcodes': data.postcodes,
      if (data.stations != null)
        'stations': data.stations,
      if (data.partners != null)
        'partners': data.partners,
      if (data.timeStart != null)
        'timeStart': data.timeStart,
      if (data.timeEnd != null)
        'timeEnd': data.timeEnd,
    };
  }

  DateTime _intToDateTime(int time) {
    // Todo
    return DateTime.now();
  }
}
