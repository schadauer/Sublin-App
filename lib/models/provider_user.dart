import 'package:Sublin/models/provider_plan_enum.dart';
import 'package:Sublin/models/provider_type_enum.dart';

class ProviderUser {
  String uid;
  final bool streamingOn;
  final bool inOperation;
  bool operationRequested;
  ProviderType providerType;
  ProviderPlan providerPlan;
  bool outOfWork;
  String providerName;
  String phone;
  String id;
  List<String>
      targetGroup; // This value is sha256 hashed - find the readable email in user type
  List<String> communes;
  List<String> addresses;
  List<String> stations;
  List<String> partners;
  bool partnershipConfirmed;
  int timeStart;
  int timeEnd;

  ProviderUser({
    this.uid,
    this.streamingOn: false,
    this.providerType,
    this.providerPlan,
    this.operationRequested: false,
    this.inOperation: false,
    this.outOfWork: false,
    this.providerName: '',
    this.phone,
    this.id: '',
    this.targetGroup: const [],
    this.communes: const [],
    this.addresses: const [],
    this.stations: const [],
    this.partners: const [],
    this.partnershipConfirmed: false,
    this.timeStart: 0,
    this.timeEnd: 2400,
  });

  factory ProviderUser.fromJson(Map data) {
    ProviderUser defaultValues = ProviderUser();
    data = data ?? {};
    return ProviderUser(
      streamingOn: true,
      uid: data['uid'] ?? defaultValues.uid,
      providerType: ProviderType.values.firstWhere(
          (e) => e.toString() == 'ProviderType.' + (data['providerType'] ?? ''),
          orElse: () => defaultValues.providerType),
      providerPlan: ProviderPlan.values.firstWhere(
          (e) => e.toString() == 'ProviderPlan.' + (data['providerPlan'] ?? ''),
          orElse: () => defaultValues.providerPlan),
      operationRequested:
          data['operationRequested'] ?? defaultValues.operationRequested,
      inOperation: data['inOperation'] ?? defaultValues.inOperation,
      outOfWork: data['outOfWork'] ?? defaultValues.inOperation,
      providerName: data['providerName'] ?? defaultValues.providerName,
      phone: data['phone'] ?? defaultValues.phone,
      id: data['id'] ?? defaultValues.id,
      targetGroup: (data['targetGroup'] == null)
          ? defaultValues.addresses
          : data['targetGroup'].map<String>((targetG) {
              return targetG.toString();
            }).toList(),
      communes: (data['communes'] == null)
          ? defaultValues.addresses
          : data['communes'].map<String>((commune) {
              return commune.toString();
            }).toList(),
      addresses: (data['addresses'] == null)
          ? defaultValues.addresses
          : data['addresses'].map<String>((address) {
              return address.toString();
            }).toList(),
      stations: (data['stations'] == null)
          ? defaultValues.stations
          : data['stations'].map<String>((station) {
              return station.toString();
            }).toList(),
      partners: (data['partners'] == null)
          ? defaultValues.partners
          : data['partners'].map<String>((partner) {
              return partner.toString();
            }).toList(),
      partnershipConfirmed:
          data['partnershipConfirmed'] ?? defaultValues.partnershipConfirmed,
      timeStart: data['timeStart'] ?? defaultValues.timeStart,
      timeEnd: data['timeEnd'] ?? defaultValues.timeEnd,
    );
  }

  Map<String, dynamic> toJson(ProviderUser data) {
    String providerType =
        data.providerType != null ? data.providerType.toString() : '';
    String providerPlan =
        data.providerType != null ? data.providerPlan.toString() : '';
    return {
      'providerType': providerType.substring(providerType.indexOf('.') + 1),
      'providerPlan': providerPlan.substring(providerPlan.indexOf('.') + 1),
      'uid': data.uid,
      if (data.operationRequested != null)
        'operationRequested': data.operationRequested,
      if (data.inOperation != null) 'inOperation': data.inOperation,
      if (data.outOfWork != null) 'outOfWork': data.outOfWork,
      if (data.providerName != null) 'providerName': data.providerName,
      if (data.phone != null) 'phone': data.phone,
      if (data.targetGroup != null) 'targetGroup': data.targetGroup,
      if (data.communes != null) 'communes': data.communes,
      if (data.addresses != null) 'addresses': data.addresses,
      if (data.stations != null) 'stations': data.stations,
      if (data.partners != null) 'partners': data.partners,
      if (data.partnershipConfirmed != null)
        'partnershipConfirmed': data.partnershipConfirmed,
      if (data.timeStart != null) 'timeStart': data.timeStart,
      if (data.timeEnd != null) 'timeEnd': data.timeEnd,
    };
  }
}
