import '../models/lng_lat.dart';
import '../models/road.dart';
import '../osrm_manager.dart';

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

Future<Road> parseRoad(List<dynamic> data) async {
  Map<String, dynamic> jsonResponse = data.first;
  String languageCode = data.last;
  var road = Road.empty();
  final List<Map<String, dynamic>> routes =
      List.castFrom(jsonResponse["routes"]);

  for (var route in routes) {
    final distance = (route["distance"] as double) / 1000;
    final duration = route["duration"] as int;
    final mRouteHigh = route["geometry"] as String;
    road = road.copyWith(
      distance: distance,
      duration: duration.toDouble(),
      polylineEncoded: mRouteHigh,
    );
    if ((route).containsKey("legs")) {
      final List<Map<String, dynamic>> mapLegs = List.castFrom(route["legs"]);
      for (var leg in mapLegs) {
        final RoadLeg legRoad = RoadLeg(
          leg["distance"],
          (leg["duration"] as double),
        );
        road.details.roadLegs.add(legRoad);
        if ((leg).containsKey("steps")) {
          final List<Map<String, dynamic>> steps = List.castFrom(leg["steps"]);
          RoadInstruction? lastNode;
          var lastName = "";
          for (var step in steps) {
            Map<String, dynamic> maneuver = step["maneuver"];
            List<double> locationJsonArray =
                List.castFrom(maneuver["location"]);
            final location = LngLat(
              lat: locationJsonArray.last,
              lng: locationJsonArray.first,
            );
            String direction = maneuver["type"];
            String name = step["name"] ?? "";
            String instruction = OSRMManager.instructionFromDirection(
              direction,
              maneuver,
              name,
              languageCode,
            );
            RoadInstruction roadInstruction = RoadInstruction(
              distance: double.parse(step["distance"].toString()),
              duration: double.parse(step["duration"].toString()),
              instruction: instruction,
              location: location,
            );
            if (lastNode != null &&
                maneuvers[direction] != 2 &&
                lastName == name) {
              lastNode.distance += distance;
              lastNode.duration += duration;
            } else {
              road.instructions.add(roadInstruction);
              lastNode = roadInstruction;
              lastName = name;
            }
          }
        }
      }
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
