import 'package:sublin/models/provider_selection.dart';

class ProviderUser {
  final bool streamingOn;
  final bool isProvider;
  final bool operationRequested;
  final bool inOperation;
  bool isTaxi;
  ProviderType providerType;
  bool outOfWork;
  String name;
  List<String> addresses;
  List<String> postcodes;
  List<String> stations;
  int timeStart;
  int timeEnd;

  ProviderUser({
    this.streamingOn: false,
    this.isProvider: true,
    this.isTaxi: false,
    this.providerType,
    this.operationRequested: true,
    this.inOperation: false,
    this.outOfWork: false,
    this.name: '',
    this.addresses: const [],
    this.postcodes: const [],
    this.stations: const [],
    this.timeStart: 0,
    this.timeEnd: 2400,
  });

  // factory ProviderUser.initialData() {
  //   return ProviderUser(
  //     streamingOn: false,
  //     isProvider: true,
  //     operationRequested: true,
  //     inOperation: false,
  //     outOfWork: true,
  //     providerName: '',
  //     addresses: [],
  //     postcodes: [],
  //     stations: [],
  //     timeStart: 0,
  //     timeEnd: 2400,
  //   );
  // }

  factory ProviderUser.fromMap(Map data) {
    ProviderUser defaultValues = ProviderUser();

    data = data ?? {};
    return ProviderUser(
      streamingOn: true,
      isProvider: data['isProvider'] ?? defaultValues.isProvider,
      isTaxi: data['isTaxi'] ?? defaultValues.isTaxi,
      providerType: ProviderType.values.firstWhere(
              (e) => e.toString() == 'ProviderType.' + data['providerType']) ??
          defaultValues.providerType,
      operationRequested:
          data['operationRequested'] ?? defaultValues.operationRequested,
      inOperation: data['inOperation'] ?? defaultValues.inOperation,
      outOfWork: data['outOfWork'] ?? defaultValues.inOperation,
      name: data['providerName'] ?? defaultValues.name,
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
      timeStart: data['timeStart'] ?? defaultValues.timeStart,
      timeEnd: data['timeEnd'] ?? defaultValues.timeEnd,
    );
  }

  Map<String, dynamic> toMap(ProviderUser data) {
    String providerType = data.providerType.toString();
    return {
      if (data.isProvider != null) 'isProvider': data.isProvider,
      if (data.isTaxi != null) 'isTaxi': data.isTaxi,
      if (data.providerType != null)
        'providerType': providerType.substring(providerType.indexOf('.') + 1),
      if (data.operationRequested != null)
        'operationRequested': data.operationRequested,
      if (data.inOperation != null) 'inOperation': data.inOperation,
      if (data.outOfWork != null) 'outOfWork': data.outOfWork,
      if (data.name != null) 'providerName': data.name,
      if (data.addresses != null) 'addresses': data.addresses,
      if (data.postcodes != null) 'postcodes': data.postcodes,
      if (data.stations != null) 'stations': data.stations,
      if (data.timeStart != null) 'timeStart': data.timeStart,
      if (data.timeEnd != null) 'timeEnd': data.timeEnd,
    };
  }

  DateTime _intToDateTime(int time) {
    // Todo
    return DateTime.now();
  }
}
