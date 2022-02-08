import '../../routing_client_dart.dart';
import '../utilities/utils.dart';

class Road {
  final double distance;
  final double duration;
  List<RoadInstruction> instructions = [];
  final String polylineEncoded;
  List<Road>? _alternativesRoads;
  bool _isError = false;
  RoadDetailInfo details = RoadDetailInfo();

  Road.empty()
      : distance = 0.0,
        duration = 0.0,
        polylineEncoded = "";

  Road.minimize({
    required this.distance,
    required this.duration,
    required this.polylineEncoded,
  });

  Road({
    required this.distance,
    required this.duration,
    required this.instructions,
    required this.polylineEncoded,
    List<Road>? alternativesRoads,
  }) {
    _alternativesRoads = alternativesRoads;
  }

  Road.fromOSRMJson(Map route, String languageCode)
      : distance = (double.parse(route["distance"].toString())) / 1000,
        duration = double.parse(route["duration"].toString()),
        polylineEncoded = route["geometry"] as String {
    if ((route).containsKey("legs")) {
      final List<Map<String, dynamic>> mapLegs = List.castFrom(route["legs"]);
      for (var leg in mapLegs) {
        final RoadLeg legRoad = RoadLeg(
          leg["distance"],
          (leg["duration"] as double),
        );
        details.roadLegs.add(legRoad);
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
              instructions.add(roadInstruction);
              lastNode = roadInstruction;
              lastName = name;
            }
          }
        }
      }
    }
  }

  Road.withError()
      : duration = 0.0,
        distance = 0.0,
        polylineEncoded = "",
        _isError = true;

  bool get canDrawRoad => !_isError;

  List<Road>? get alternativeRoads => _alternativesRoads;

  void addAlternativeRoute(Road road) {
    _alternativesRoads ??= [];
    _alternativesRoads!.add(road);
  }

  Road copyWith({
    double? distance,
    double? duration,
    List<RoadInstruction>? instructions,
    String? polylineEncoded,
    List<Road>? alternativesRoads,
  }) {
    return Road(
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      instructions: instructions ?? this.instructions,
      polylineEncoded: polylineEncoded ?? this.polylineEncoded,
    ).._alternativesRoads = alternativesRoads;
  }
}

class RoadInstruction {
  double distance;
  double duration;
  final String instruction;
  final LngLat location;

  RoadInstruction({
    required this.distance,
    required this.duration,
    required this.instruction,
    required this.location,
  });

  @override
  String toString() {
    return "$instruction at $location";
  }
}

class RoadDetailInfo {
  List<RoadLeg> roadLegs = [];

  RoadDetailInfo();
}

class RoadLeg {
  final double distance;
  final double duration;

  RoadLeg(
    this.distance,
    this.duration,
  );
}
