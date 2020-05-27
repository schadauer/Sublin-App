class Routing {
  final String startAddress;
  final String startName;
  final String endAddress;
  final String endName;
  final String stationAddress;
  final String stationName;

  Routing({
    this.startAddress,
    this.startName,
    this.endAddress,
    this.endName,
    this.stationAddress,
    this.stationName,
  });

  factory Routing.fromMap(Map data) {
    data = data ?? {};
    return Routing(
      startAddress: data['startAddress'] ?? '',
      startName: data['startName'] ?? '',
      endAddress: data['endAddress'] ?? '',
      endName: data['endName'] ?? '',
      stationAddress: data['stationAddress'] ?? '',
      stationName: data['stationName'] ?? '',
    );
  }
}
