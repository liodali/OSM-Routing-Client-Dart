import 'package:routing_client_dart/src/models/lng_lat.dart';

class RoadStep {
  String name;
  String? ref;
  String? rotaryName;
  String? destinations;
  String? exits;
  Maneuver maneuver;
  double duration;
  double distance;
  List<Intersections> intersections;
  String drivingSide;

  RoadStep.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? '',
        ref = json['ref'],
        rotaryName = json['rotary_name'],
        destinations = json['destinations'],
        exits = json['exits'],
        maneuver = Maneuver.fromJson(json['maneuver']!),
        duration = double.parse(json['duration'].toString()),
        distance = double.parse(json['distance'].toString()),
        drivingSide = json['driving_side']!,
        intersections = List<Intersections>.from(
          (json['intersections'] as List<dynamic>).map(
            (j) => Intersections.fromJson(j),
          ),
        );
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
        lanes = json['lanes'] != null
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