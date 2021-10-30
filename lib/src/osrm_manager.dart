import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:osrm_dart/osrm_dart.dart';

import 'models/lng_lat.dart';
import 'models/road.dart';
import 'utilities/localisation_instruction.dart';
import 'utilities/utils.dart';

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
            if(lastNode != null &&  maneuvers[direction] != 2 && lastName == name ){
              lastNode.distance+=distance;
              lastNode.duration+=duration;
            }else{
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

class OSRMManager {
  final String server;
  final RoadType roadType;
  final dio = Dio();

  OSRMManager()
      : server = oSRMServer,
        roadType = RoadType.car;

  OSRMManager.custom({
    required this.server,
    this.roadType = RoadType.car,
  });

  Future<Road> getRoad({
    required List<LngLat> waypoints,
    RoadType roadType = RoadType.car,
    int alternative = 0,
    bool steps = true,
    Overview overview = Overview.full,
    Geometries geometrie = Geometries.geojson,
    String languageCode = "en",
  }) async {
    String path = generatePath(
      waypoints.toWaypoints(),
      alternative: alternative,
      steps: steps,
      overview: overview,
      geometrie: geometrie,
    );
    final response = await dio.get(path);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseJson = response.data;
      return compute(parseRoad, [responseJson, languageCode]);
    } else {
      return Road.withError();
    }
  }

  static String instructionFromDirection(
    String direction,
    Map<String, dynamic> jManeuver,
    String roadName,
    String languageCode,
  ) {
    if (direction == "turn" || direction == "ramp" || direction == "merge") {
      String modifier = jManeuver["modifier"];
      direction = "$direction-$modifier";
    } else if (direction == "roundabout") {
      int exit = jManeuver["exit"];
      direction = "$direction-$exit";
    } else if (direction == "rotary") {
      int exit = jManeuver["exit"];
      direction = "roundabout-$exit"; //convert rotary in roundabout...
    }
    int maneuverCode = 0;
    if (maneuvers.containsKey(direction)) {
      maneuverCode = maneuvers[direction] ?? 0;
    }
    return LocalisationInstruction(
      languageCode: languageCode,
    ).getInstruction(
      maneuverCode,
      roadName,
    );
  }
}

extension OSRMPrivateFunct on OSRMManager {
  @visibleForTesting
  String generatePath(
    String waypoints, {
    RoadType roadType = RoadType.car,
    int alternative = 0,
    bool steps = true,
    Overview overview = Overview.full,
    Geometries geometrie = Geometries.polyline,
  }) {
    String url = "$server/routed-${roadType.value}/route/v1/diving/$waypoints";
    String option = "";
    option += "alternatives=${alternative <= 0 ? false : alternative}&";
    option += "steps=$steps&";
    option += "overview=${overview.value}&";
    option += "geometries=${geometrie.value}";

    return "$url${option.isNotEmpty ? "?$option" : ""}";
  }
}
