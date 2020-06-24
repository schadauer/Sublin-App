class ProviderUser {
  final bool streamingOn;
  final bool isProvider;
  final bool operationRequested;
  final bool inOperation;
  final bool outOfWork;
  final String providerName;
  final List<dynamic> postcodes;
  final List<dynamic> stations;
  final int timeStart;
  final int timeEnd;

  ProviderUser(
      {this.streamingOn,
      this.isProvider = true,
      this.operationRequested = true,
      this.inOperation = false,
      this.outOfWork = true,
      this.providerName = '',
      this.postcodes = const [],
      this.stations = const [],
      this.timeStart = 0,
      this.timeEnd = 2400});

  factory ProviderUser.initialData() {
    return ProviderUser(
      streamingOn: false,
    );
  }

  factory ProviderUser.fromMap(Map data) {
    ProviderUser defaultValues = ProviderUser();
    data = data ?? {};
    print('check');

    return ProviderUser(
      streamingOn: true,
      isProvider: data['isProvider'] ?? defaultValues.isProvider,
      operationRequested:
          data['operationRequested'] ?? defaultValues.operationRequested,
      inOperation: data['inOperation'] ?? defaultValues.inOperation,
      outOfWork: data['outOfWork'] ?? defaultValues.inOperation,
      providerName: data['name'] ?? defaultValues.providerName,
      postcodes: (data['postcode'] == [])
          ? defaultValues.postcodes
          : data['postcode'].map((postcode) {
              return postcode;
            }).toList(),
      stations: (data['stations'] == [])
          ? defaultValues.stations
          : data['stations'].map<dynamic>((station) {
              return station;
            }).toList(),
      timeStart: data['timeStart'] ?? defaultValues.timeStart,
      timeEnd: data['timeEnd'] ?? defaultValues.timeEnd,
    );
  }

  Map<String, dynamic> toMap(ProviderUser data) {
    ProviderUser defaultValues = ProviderUser();
    return {
      'isProvider': data.isProvider ?? defaultValues.isProvider,
      'operationRequested':
          data.operationRequested ?? defaultValues.operationRequested,
      'inOperation': data.inOperation ?? defaultValues.inOperation,
      'outOfWork': data.outOfWork ?? defaultValues.outOfWork,
      'providerName': data.providerName ?? defaultValues.providerName,
      'postcode': data.postcodes ?? defaultValues.postcodes,
      'stations': data.stations ?? defaultValues.stations,
      'timeStart': data.timeStart ?? defaultValues.timeStart,
      'timeEnd': data.timeEnd ?? defaultValues.timeEnd,
    };
  }
}
