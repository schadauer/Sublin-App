class ProviderUser {
  final bool streamingOn;
  final bool isProvider;
  final bool operationRequested;
  final bool inOperation;
  bool outOfWork;
  String providerName;
  List<String> postcodes;
  List<String> stations;
  int timeStart;
  int timeEnd;

  ProviderUser({
    this.streamingOn,
    this.isProvider,
    this.operationRequested,
    this.inOperation,
    this.outOfWork,
    this.providerName,
    this.postcodes,
    this.stations,
    this.timeStart,
    this.timeEnd,
  });

  factory ProviderUser.initialData() {
    return ProviderUser(
      streamingOn: false,
      isProvider: true,
      operationRequested: true,
      inOperation: false,
      outOfWork: true,
      providerName: '',
      postcodes: [],
      stations: [],
      timeStart: 0,
      timeEnd: 2300,
    );
  }

  factory ProviderUser.fromMap(Map data) {
    ProviderUser defaultValues = ProviderUser.initialData();
    data = data ?? {};
    return ProviderUser(
      streamingOn: true,
      isProvider: data['isProvider'] ?? defaultValues.isProvider,
      operationRequested:
          data['operationRequested'] ?? defaultValues.operationRequested,
      inOperation: data['inOperation'] ?? defaultValues.inOperation,
      outOfWork: data['outOfWork'] ?? defaultValues.inOperation,
      providerName: data['providerName'] ?? defaultValues.providerName,
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
    print(data.providerName);
    return {
      data.outOfWork ?? 'outOfWork': data.outOfWork,
      data.providerName ?? 'providerName': data.providerName,
      data.postcodes ?? 'postcodes': data.postcodes,
      data.stations ?? 'stations': data.stations,
      data.timeStart ?? 'timeStart': data.timeStart,
      data.timeEnd ?? 'timeEnd': data.timeEnd,
    };
  }

  // set provider_name(String name) {
  //   this.providerName = name;
  // }
}
