class Request {
  String endAddress;
  String startAddress;
  bool checkAddress;
  DateTime departureTime;
  DateTime timestamp;

  Request({
    this.endAddress = '',
    this.startAddress = '',
    this.checkAddress,
    this.departureTime,
    this.timestamp,
  });
}
