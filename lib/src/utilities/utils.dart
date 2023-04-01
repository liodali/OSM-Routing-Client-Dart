

import 'package:routing_client_dart/src/models/lng_lat.dart';

const String oSRMServer = "https://routing.openstreetmap.de";

enum Languages {
  en,
}

enum RoadType {
  car,
  foot,
  bike,
}

enum Profile {
  route,
  trip,
}

enum Overview {
  simplified,
  full,
  none,
}

enum Geometries {
  polyline,
  polyline6,
  geojson,
}

enum SourceGeoPointOption {
  any,
  first,
}

enum DestinationGeoPointOption {
  any,
  last,
}

extension RoadTypeExtension on RoadType {
  String get value {
    return ["car", "foot", "bike"][index];
  }
}

extension OverviewExtension on Overview {
  String get value {
    return ["simplified", "full", "false"][index];
  }
}

extension GeometriesExtension on Geometries {
  String get value {
    return ["polyline", "polyline6", "geojson"][index];
  }
}

extension TransformToWaysOSRM on List<LngLat> {
  String toWaypoints() {
    return map((e) => e.toString())
        .reduce((value, element) => "$value;$element");
  }
}
double parseToDouble(dynamic value) {
  return double.parse(value.toString());
}

