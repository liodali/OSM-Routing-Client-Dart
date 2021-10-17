///  [LngLat] representative class  of geographic point for longitude and latitude
///
/// [lng] : (double) longitude value
///
/// [lat] : (double) latitude value
class LngLat {
  final double lng;
  final double lat;

  LngLat({
    required this.lng,
    required this.lat,
  });

  @override
  String toString() => "$lng,$lat";
}
