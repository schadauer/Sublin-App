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
      timeEnd: 2400,
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
    return {
      if (data.outOfWork != null) 'outOfWork': data.outOfWork,
      if (data.providerName != null) 'providerName': data.providerName,
      if (data.postcodes != null) 'postcodes': data.postcodes,
      if (data.stations != null) 'stations': data.stations,
      if (data.timeStart != null) 'timeStart': data.timeStart,
      if (data.timeEnd != null) 'timeEnd': data.timeEnd,
    };
  }

  get getTimeStart {}

  set setProviderName(String name) {
    providerName = name;
  }

  set setPostCodes(List<String> postcodes) {
    postcodes = postcodes;
  }

  set setStations(List<String> stations) {
    stations = stations;
  }

  set setTimeStart(DateTime time) {
    timeStart = _dateTimeToInt(time);
  }

  set setEndStart(DateTime time) {
    timeEnd = _dateTimeToInt(time);
  }

  int _dateTimeToInt(DateTime time) {
    // Todo
    return 0;
  }

  DateTime _intToDateTime(int time) {
    // Todo
    return DateTime.now();
  }
}
