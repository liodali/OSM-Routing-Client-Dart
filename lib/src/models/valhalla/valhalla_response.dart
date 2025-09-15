import 'package:routing_client_dart/src/models/route.dart';
import 'package:routing_client_dart/src/models/valhalla/extensions.dart';
import 'package:routing_client_dart/src/utilities/valhalla_utilities.dart';

class ValhallaResponse {
  final Trip trip;
  final List<Trip>? alternates;
  final String? id;

  const ValhallaResponse._({
    required this.trip,
    required this.alternates,
    required this.id,
  });

  factory ValhallaResponse.fromJson(Map<String, dynamic> json) {
    return ValhallaResponse._(
      trip: Trip.fromJson(json['trip']),
      alternates:
          json.containsKey('alternates')
              ? (json['alternates'] as List)
                  .map((alternate) => Trip.fromJson(alternate['trip']))
                  .toList()
              : null,
      id: json['id'],
    );
  }
  Route toRoute({
    ValhallaUnit unit = ValhallaUnit.km,
    int accuracyExponent = 5,
  }) {
    final alters = alternates?.map((e) => e.toRoute()).toList();
    final road = trip.toRoute(unit: unit, accuracyExponent: accuracyExponent);
    return road.copyWith(alternativesRoads: alters);
  }
}

class Trip {
  final List<Location> locations;
  final List<Leg> legs;
  final Summary summary;
  final String statusMessage;
  final int status;
  final String units;
  final String language;

  const Trip._({
    required this.locations,
    required this.legs,
    required this.summary,
    required this.statusMessage,
    required this.status,
    required this.units,
    required this.language,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip._(
      locations:
          (json['locations'] as List)
              .map((location) => Location.fromJson(location))
              .toList(),
      legs: (json['legs'] as List).map((leg) => Leg.fromJson(leg)).toList(),
      summary: Summary.fromJson(json['summary']),
      statusMessage: json['status_message'],
      status: json['status'],
      units: json['units'],
      language: json['language'],
    );
  }
}

class Location {
  final String type;
  final double lat;
  final double lon;
  final int originalIndex;

  const Location._({
    required this.type,
    required this.lat,
    required this.lon,
    required this.originalIndex,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location._(
      type: json['type'],
      lat: json['lat'],
      lon: json['lon'],
      originalIndex: json['original_index'],
    );
  }
}

class Leg {
  final List<Maneuver>? maneuvers;
  final Summary summary;
  final String shape;

  const Leg._({
    required this.maneuvers,
    required this.summary,
    required this.shape,
  });

  factory Leg.fromJson(Map<String, dynamic> json) {
    return Leg._(
      maneuvers:
          List.castFrom(
            json['maneuvers'],
          ).map((maneuver) => Maneuver.fromJson(maneuver)).toList(),
      summary: Summary.fromJson(json['summary']),
      shape: json['shape'],
    );
  }
}

class Maneuver {
  final int type;
  final String instruction;
  final String? verbalSuccinctTransitionInstruction;
  final String? verbalPreTransitionInstruction;
  final String? verbalPostTransitionInstruction;
  final double time;
  final double length;
  final double cost;
  final int beginShapeIndex;
  final int endShapeIndex;
  final bool? rough;
  final String travelMode;
  final String travelType;

  const Maneuver._({
    required this.type,
    required this.instruction,
    required this.verbalSuccinctTransitionInstruction,
    required this.verbalPreTransitionInstruction,
    required this.verbalPostTransitionInstruction,
    required this.time,
    required this.length,
    required this.cost,
    required this.beginShapeIndex,
    required this.endShapeIndex,
    this.rough,
    required this.travelMode,
    required this.travelType,
  });

  factory Maneuver.fromJson(Map<String, dynamic> json) {
    return Maneuver._(
      type: json['type'],
      instruction: json['instruction'] ?? '',
      verbalSuccinctTransitionInstruction:
          json['verbal_succinct_transition_instruction'],
      verbalPreTransitionInstruction: json['verbal_pre_transition_instruction'],
      verbalPostTransitionInstruction:
          json['verbal_post_transition_instruction'],
      time: double.tryParse(json['time'].toString()) ?? 0.0,
      length: double.tryParse(json['length'].toString()) ?? 0.0,
      cost: json['cost'],
      beginShapeIndex: json['begin_shape_index'],
      endShapeIndex: json['end_shape_index'],
      rough: json['rough'],
      travelMode: json['travel_mode'],
      travelType: json['travel_type'],
    );
  }
}

class Summary {
  final bool hasTimeRestrictions;
  final bool hasToll;
  final bool hasHighway;
  final bool hasFerry;
  final double minLat;
  final double minLon;
  final double maxLat;
  final double maxLon;
  final double time;
  final double length;
  final double cost;

  const Summary._({
    required this.hasTimeRestrictions,
    required this.hasToll,
    required this.hasHighway,
    required this.hasFerry,
    required this.minLat,
    required this.minLon,
    required this.maxLat,
    required this.maxLon,
    required this.time,
    required this.length,
    required this.cost,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary._(
      hasTimeRestrictions: json['has_time_restrictions'],
      hasToll: json['has_toll'],
      hasHighway: json['has_highway'],
      hasFerry: json['has_ferry'],
      minLat: json['min_lat'],
      minLon: json['min_lon'],
      maxLat: json['max_lat'],
      maxLon: json['max_lon'],
      time: json['time'],
      length: json['length'],
      cost: json['cost'],
    );
  }
}
