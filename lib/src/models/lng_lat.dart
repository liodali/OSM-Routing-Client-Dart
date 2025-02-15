import 'package:routing_client_dart/src/models/lng_lat_radian.dart';
import 'package:routing_client_dart/src/models/math_utils.dart';
import 'package:routing_client_dart/src/utilities/utils.dart';

/// [LngLat] representative class  of geographic point for longitude and latitude
///
/// [lng] : (double) longitude value
///
/// [lat] : (double) latitude value
class LngLat {
  final double lng;
  final double lat;

  LngLat({required this.lng, required this.lat});

  LngLat.fromList({required List<double> lnglat})
    : assert(lnglat.length == 2),
      lat = lnglat.last,
      lng = lnglat.first;

  @override
  String toString() => "$lng,$lat";

  Map<String, dynamic> toMap() => {'lat': lat, 'lon': lng};

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is LngLat && lat == other.lat && lng == other.lng;
  }

  @override
  int get hashCode => double.parse((lat + lng).toString()).toInt();
}

extension ExtLngLat on LngLat {
  double distance({required LngLat location}) {
    final radianLocation = LngLatRadians.fromLngLat(location: location);
    final currentRadianLocation = LngLatRadians.fromLngLat(location: this);
    return earthRadius *
        MathUtil.inverseHaversine(
          MathUtil.havDistance(
            currentRadianLocation.latitude,
            radianLocation.latitude,
            (currentRadianLocation - radianLocation).longitude,
          ),
        );
  }

  List<double> toList() => [lng, lat];
}

extension PrvExtLngLat on LngLat {
  LngLat alignWithPrecision({int precision = 5}) {
    var output = [this].encodeGeometry(precision: precision);
    final precisedLngLat = output.decodeGeometry(precision: precision);
    return precisedLngLat.first;
  }
}
