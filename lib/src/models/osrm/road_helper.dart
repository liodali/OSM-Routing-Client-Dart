import 'package:routing_client_dart/src/models/lng_lat.dart';

class RoadStep {
  final String name;
  final String? ref;
  final String? rotaryName;
  final String? destinations;
  final String? exits;
  final Maneuver maneuver;
  final double duration;
  final double distance;
  final String mode;
  final List<Intersections> intersections;
  final String drivingSide;

  factory RoadStep.fromJson({required Map<String, dynamic> json}) {
    return RoadStep._(
      name: json['name'] ?? '',
      ref: json['ref'],
      rotaryName: json['rotary_name'],
      destinations: json['destinations'],
      exits: json['exits'],
      maneuver: Maneuver.fromJson(json['maneuver']!),
      duration: double.parse(json['duration'].toString()),
      distance: double.parse(json['distance'].toString()),
      drivingSide: json['driving_side']!,
      mode: json['mode'],
      intersections: List<Intersections>.from(
        (json['intersections'] as List<dynamic>).map(
          (j) => Intersections.fromJson(j),
        ),
      ),
    );
  }
  const RoadStep._({
    required this.name,
    required this.ref,
    required this.rotaryName,
    required this.destinations,
    required this.exits,
    required this.maneuver,
    required this.duration,
    required this.distance,
    required this.drivingSide,
    required this.mode,
    required this.intersections,
  });
}

class Intersections {
  List<Lane>? lanes;
  List<int> bearings;
  LngLat location;

  Intersections.fromJson(Map<String, dynamic> json)
    : location = LngLat.fromList(
        lnglat: (json['location'] as List).cast<double>(),
      ),
      bearings = List<int>.from(json['bearings']),
      lanes =
          json['lanes'] != null
              ? List<Lane>.from(
                (json['lanes'] as List<dynamic>).map(
                  (value) => Lane.fromJson(value),
                ),
              )
              : null;
}

class Maneuver {
  String? modifier;
  double bearingBefore;
  double bearingAfter;
  int? exit;
  String maneuverType;
  LngLat location;

  Maneuver.fromJson(Map<String, dynamic> json)
    : location = LngLat.fromList(
        lnglat: (json['location'] as List).cast<double>(),
      ),
      maneuverType = json['type']!,
      modifier = json['modifier'],
      bearingBefore = double.parse(json['bearing_before']!.toString()),
      bearingAfter = double.parse(json['bearing_after']!.toString()),
      exit = json['exit'];
}

class Lane {
  List<String> indications;
  bool valid;

  Lane.fromJson(Map<String, dynamic> json)
    : indications = List<String>.from(json['indications']),
      valid = json['valid']!;
}
