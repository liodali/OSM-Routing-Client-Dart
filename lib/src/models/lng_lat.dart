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

  LngLat.fromList({
    required List<double> lnglat,
  })  : assert(lnglat.length == 2),
        lat = lnglat.last,
        lng = lnglat.first;
  @override
  String toString() => "$lng,$lat";
}
