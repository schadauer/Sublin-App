class Versioning {
  final String minVersion;
  Versioning({
    this.minVersion,
  });

  static const version = '1.0.0';

  factory Versioning.fromJson(Map data) {
    final Versioning defaultValues = Versioning();
    data = data ?? {};
    return Versioning(
      minVersion: data['minVersion'] ?? defaultValues.minVersion,
    );
  }
}
