class Routing {
  String startAddress = '';
  String startName = '';
  String startId = '';
  String endAddress = '';
  String endName = '';
  String endId = '';
  String stationAddress = '';
  String stationName = '';

  Routing({
    this.startAddress,
    this.startName,
    this.startId,
    this.endAddress,
    this.endName,
    this.endId,
    this.stationAddress,
    this.stationName,
  });

  factory Routing.fromMap(Map data) {
    data = data ?? {};
    return Routing(
      startAddress: data['startAddress'] ?? '',
      startName: data['startName'] ?? '',
      startId: data['startId'] ?? '',
      endAddress: data['endAddress'] ?? '',
      endName: data['endName'] ?? '',
      endId: data['endId'] ?? '',
      stationAddress: data['stationAddress'] ?? '',
      stationName: data['stationName'] ?? '',
    );
  }
}
