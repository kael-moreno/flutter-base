/// Address entity representing user address information
class Address {
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final Geo geo;

  const Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });

  @override
  String toString() => '$street, $suite, $city $zipcode';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Address &&
        other.street == street &&
        other.suite == suite &&
        other.city == city &&
        other.zipcode == zipcode &&
        other.geo == geo;
  }

  @override
  int get hashCode => street.hashCode ^ suite.hashCode ^ city.hashCode ^ zipcode.hashCode ^ geo.hashCode;
}

/// Geographical coordinates
class Geo {
  final String lat;
  final String lng;

  const Geo({
    required this.lat,
    required this.lng,
  });

  @override
  String toString() => 'Lat: $lat, Lng: $lng';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Geo && other.lat == lat && other.lng == lng;
  }

  @override
  int get hashCode => lat.hashCode ^ lng.hashCode;
}
