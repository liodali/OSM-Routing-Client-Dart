import 'dart:math';

import 'package:routing_client_dart/routing_client_dart.dart';

typedef LocationRadians = double;

class LngLatRadians {
  final LocationRadians latitude;
  final LocationRadians longitude;
  LngLatRadians({required this.latitude, required this.longitude});
  LngLatRadians.fromLngLat({required LngLat location})
    : latitude = location.lat.radian,
      longitude = location.lng.radian;

  LngLatRadians operator +(LngLatRadians right) {
    return LngLatRadians(
      latitude: latitude + right.latitude,
      longitude: longitude + right.longitude,
    );
  }

  LngLatRadians operator -(LngLatRadians right) {
    return LngLatRadians(
      latitude: latitude - right.latitude,
      longitude: longitude - right.longitude,
    );
  }

  LngLat toLngLat() =>
      LngLat(lng: longitude.toDegree(), lat: latitude.toDegree());
}

extension on LocationRadians {
  double toDegree() => this * (180 / pi);
}

extension ExtLngLat on LngLat {
  LngLatRadians get lngLatRadian => LngLatRadians.fromLngLat(location: this);
}

extension on double {
  double get radian => this * (pi / 180);
}
