class Location {
  final double longitude, latitude;
  final String? name, displayName, type;
  const Location(this.latitude, this.longitude, {this.displayName, this.name, this.type});
}
