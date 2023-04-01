import 'package:routing_client_dart/src/models/lng_lat.dart';
import 'package:routing_client_dart/src/models/road_helper.dart';
import 'package:routing_client_dart/src/osrm_manager.dart';
import 'package:routing_client_dart/src/utilities/utils.dart';

class Road {
  /// this attribute is the  distance of the route in km
  final double distance;

  /// this attribute is the duration of route in second
  final double duration;

  /// the instruction that user should follow to reach t destination from started location
  List<RoadInstruction> instructions = [];

  /// this is the encoded list of lnglat that should decoded to get list of geopoint
  /// this attribute can be null if the geometry == geojson
  final String? polylineEncoded;

  /// this is list of geopoint of the route,this attribute is not null if geometry equal to geojson
  /// except that use always [polylineEncoded]
  List<LngLat>? polyline;
  List<Road>? _alternativesRoads;
  bool _isError = false;
  RoadDetailInfo details = RoadDetailInfo();
  List<List<RoadStep>> _roadLegs = <List<RoadStep>>[];
  Road.empty()
      : distance = 0.0,
        duration = 0.0,
        polylineEncoded = "";

  Road.minimize({
    required this.distance,
    required this.duration,
    this.polylineEncoded,
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

  Road.fromOSRMJson({
    required Map route,
  })  : distance = (double.parse(route["distance"].toString())) / 1000,
        duration = double.parse(route["duration"].toString()),
        polylineEncoded = route["geometry"].runtimeType == String
            ? route["geometry"] as String
            : null {
    if (route["geometry"].runtimeType != String) {
      final List<List<dynamic>> listOfPoints =
          List.castFrom(route["geometry"]["coordinates"]);

      polyline = listOfPoints
          .map((e) => LngLat(
                lng: e.first,
                lat: e.last,
              ))
          .toList();
    }
    if ((route).containsKey("legs")) {
      final List<Map<String, dynamic>> mapLegs = List.castFrom(route["legs"]);
      mapLegs.asMap().forEach((indexLeg, leg) {
        final RoadLeg legRoad = RoadLeg(
          parseToDouble(leg["distance"]),
          parseToDouble(leg["duration"]),
        );
        details.roadLegs.add(legRoad);
        if ((leg).containsKey("steps")) {
          final List<Map<String, dynamic>> steps = List.castFrom(leg["steps"]);
          RoadInstruction? lastNode;
          var lastName = "";
          final List<RoadStep> roadSteps = [];
          for (var step in steps) {
            final roadStep = RoadStep.fromJson(step);
            roadSteps.add(roadStep);
            // String instruction = OSRMManager.

            if (lastNode != null &&
                roadStep.maneuver.maneuverType == "new name" &&
                lastName == roadStep.name) {
              lastNode.distance += distance;
              lastNode.duration += duration;
            } else {
              //instructions.add(roadInstruction);
              //lastNode = roadInstruction;
              lastName = roadStep.name;
            }
          }
          _roadLegs.add(roadSteps);
        }
      });
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

extension PrivateRoad on Road {
  List<List<RoadStep>> get roadLegs => _roadLegs;
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
