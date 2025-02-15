import 'package:routing_client_dart/src/models/lng_lat.dart';
import 'package:routing_client_dart/src/models/osrm/road_helper.dart';
import 'package:routing_client_dart/src/models/route.dart';
import 'package:routing_client_dart/src/utilities/utils.dart';

/// [OSRMRoad]
class OSRMRoad extends Route {
  final bool _isError;
  final List<RoadLeg> _roadLegs;

  const OSRMRoad.empty()
    : _isError = false,
      _roadLegs = const <RoadLeg>[],
      super(distance: 0.0, duration: 0.0, polylineEncoded: "");

  const OSRMRoad.minimize({
    required super.distance,
    required super.duration,
    super.polylineEncoded,
  }) : _isError = false,
       _roadLegs = const <RoadLeg>[];

  const OSRMRoad({
    required super.distance,
    required super.duration,
    required super.polylineEncoded,
    super.alternativesRoads,
    super.polyline,
  }) : _isError = false,
       _roadLegs = const <RoadLeg>[];
  const OSRMRoad._init({
    required super.distance,
    required super.duration,
    required super.polylineEncoded,
    super.alternativesRoads,
    super.polyline,
    List<RoadLeg>? legs,
    super.instructions,
  }) : _isError = false,
       _roadLegs = legs ?? const <RoadLeg>[];

  OSRMRoad.fromOSRMJson({required Map route})
    : _isError = false,
      _roadLegs =
          List.castFrom(route["legs"]).map((legMap) {
            final List<RoadStep> roadSteps = [];
            if ((legMap).containsKey("steps")) {
              final List<Map<String, dynamic>> steps = List.castFrom(
                legMap["steps"],
              );
              for (var step in steps) {
                final roadStep = RoadStep.fromJson(json: step);
                roadSteps.add(roadStep);
              }
            }
            return RoadLeg(
              parseToDouble(legMap["distance"]),
              parseToDouble(legMap["duration"]),
              steps: roadSteps,
            );
          }).toList(),
      super(
        distance: (double.parse(route["distance"].toString())) / 1000,
        duration: double.parse(route["duration"].toString()),
        polylineEncoded:
            route["geometry"].runtimeType == String
                ? route["geometry"] as String
                : null,
        polyline:
            route["geometry"] != null && route["geometry"].runtimeType != String
                ? List.castFrom(
                  route["geometry"]["coordinates"],
                ).map((e) => LngLat(lng: e.first, lat: e.last)).toList()
                : route["geometry"] is String
                ? (route["geometry"] as String).decodeGeometry()
                : <LngLat>[],
      );

  OSRMRoad.withError()
    : _roadLegs = const <RoadLeg>[],
      _isError = true,
      super(duration: 0.0, distance: 0.0, polylineEncoded: "");

  bool get canDrawRoad => !_isError;

  List<OSRMRoad>? get alternativeRoads =>
      super.alternativesRoads as List<OSRMRoad>?;
  List<String> get destinations =>
      _roadLegs
          .expand((legs) => legs.steps)
          .map((roadLeg) => roadLeg.destinations)
          .where((element) => element != null)
          .whereType<String>()
          .toList();
  void addAlternativeRoute(OSRMRoad road) {
    super.alternativesRoads!.add(road);
  }

  @override
  OSRMRoad copyWith({
    double? distance,
    double? duration,
    String? polylineEncoded,
    List<LngLat>? polyline,
    List<Route>? alternativesRoads,
    List<RouteInstruction>? instructions,
  }) => OSRMRoad._init(
    distance: distance ?? this.distance,
    duration: duration ?? this.duration,
    polylineEncoded: polylineEncoded ?? this.polylineEncoded,
    polyline: polyline ?? this.polyline,
    alternativesRoads: alternativesRoads,
    instructions: instructions ?? this.instructions,
    legs: _roadLegs,
  );
}

class RoadLeg {
  final double distance;
  final double duration;
  final List<RoadStep> steps;
  const RoadLeg(this.distance, this.duration, {this.steps = const []});
}

extension PrivateRoad on OSRMRoad {
  List<RoadLeg> get roadLegs => _roadLegs;
}
