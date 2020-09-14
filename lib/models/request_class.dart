class Request {
  String endAddress;
  String endId;
  String startAddress;
  String startId;
  bool checkAddress;
  DateTime departureTime;
  DateTime timestamp;

  Request({
    this.endAddress = '',
    this.endId,
    this.startAddress = '',
    this.startId,
    this.checkAddress,
    this.departureTime,
    this.timestamp,
  });
}
