import '../models/lng_lat.dart';
import '../models/road.dart';
import 'computes_utilities.dart';

enum RoadType { car, foot, bike }
enum Overview { simplified, full, none }
enum Geometries { polyline, polyline6, geojson }

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

/// parseRoad
/// this method used to parse json get from routing server to [Road] object
/// we use this method in another thread like compute
/// get [data] as List of map objects to be parse and to [Road]
/// fix parsing problem [#1]
/// return [Road] object that contain list of waypoint
/// and distance and duration of the road
Future<Road> parseRoad(ParserRoadComputerArg data) async {
  Map<String, dynamic> jsonResponse = data.jsonRoad;
  String languageCode = data.langCode;
  bool alternative = data.alternative;
  var road = Road.empty();
  final List<Map<String, dynamic>> routes =
      List.castFrom(jsonResponse["routes"]);

  if (routes.length == 1) {
    final route = routes.first;
    road = Road.fromOSRMJson(route, languageCode);
  }
  if (routes.length > 1 && alternative) {
    routes.removeAt(0);
    for (var route in routes) {
      final alternative = Road.fromOSRMJson(route, languageCode);
      road.addAlternativeRoute(alternative);
    }
  }

  return road;
}

const String oSRMServer = "https://routing.openstreetmap.de";

const Map<String, int> maneuvers = {
  "new name": 2,
  "turn-straight": 1,
  "turn-slight right": 6,
  "turn-right": 7,
  "turn-sharp right": 8,
  "turn-uturn": 12,
  "turn-sharp left": 5,
  "turn-left": 4,
  "turn-slight left": 3,
  "depart": 24,
  "arrive": 24,
  "roundabout-1": 27,
  "roundabout-2": 28,
  "roundabout-3": 29,
  "roundabout-4": 30,
  "roundabout-5": 31,
  "roundabout-6": 31,
  "roundabout-7": 33,
  "roundabout-8": 34,
  "merge-left": 20,
  "merge-sharp left": 20,
  "merge-slight left": 20,
  "merge-right": 21,
  "merge-sharp right": 21,
  "merge-slight right": 21,
  "merge-straight": 22,
  "ramp-left": 17,
  "ramp-sharp left": 17,
  "ramp-slight left": 17,
  "ramp-right": 18,
  "ramp-sharp right": 18,
  "ramp-slight right": 18,
  "ramp-straight": 19,
};
