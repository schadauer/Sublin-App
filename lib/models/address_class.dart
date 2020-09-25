// * This class is for the addresses collection to get information about a city like stations, addresses, etc.
class Address {
  final List<String> stations;
  Address({
    this.stations,
  });

  factory Address.fromJson(Map data) {
    data = data ?? {};
    var stationsFromJson = data['stations'];
    List<String> stationsList = List<String>.from(stationsFromJson);
    Address address = Address(
      stations: stationsList ?? <String>[],
    );
    return address;
  }
}
