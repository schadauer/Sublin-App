class ProviderUser {
  final bool streamingOn;
  final bool isProvider;
  final bool operationRequested;
  final bool inOperation;
  final bool outOfWork;
  final String providerName;
  final List<String> postcode;
  final List<String> stations;
  final int timeStart;
  final int timeEnd;

  ProviderUser(
      {this.streamingOn,
      this.isProvider,
      this.operationRequested,
      this.inOperation,
      this.outOfWork,
      this.providerName,
      this.postcode,
      this.stations,
      this.timeStart,
      this.timeEnd});

  factory ProviderUser.fromMap(Map data) {
    data = data ?? {};
    return ProviderUser(
      streamingOn: true,
      isProvider: data == null ? false : true,
      operationRequested: data['operationRequested'] ?? false,
      inOperation: data['inOperation'] ?? false,
      outOfWork: data['outOfWork'] ?? false,
      providerName: data['name'] ?? '',
      postcode: (data['postcode'] == null)
          ? null
          : data['postcode'].map<String>((postcode) {
              return postcode;
            }).toList(),
    );
  }

  factory ProviderUser.initialData() {
    return ProviderUser(
      streamingOn: false,
    );
  }
}
