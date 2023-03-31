import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:routing_client_dart/src/models/road_helper.dart';
import 'utilities/computes_utilities.dart';

import 'models/lng_lat.dart';
import 'models/road.dart';
import 'utilities/localisation_instruction.dart';
import 'utilities/utils.dart';

/// [OSRMManager]
///
/// this class responsible to manage http call to get road from open-source osm server
/// or custom server that should be specified in constructor based on osrm project
/// contain only one public method [getRoad] to make the call
/// and return [Road] object.
///
/// for more detail see : https://github.com/Project-OSRM/osrm-backend
///
///
/// [server]   : (String) represent the osm server or any custom server that based of OSRM project
///
/// [roadType] : (RoadType) represent the type of road that you want to use, car or foot,bike only for osm servers
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

  /// [getRoad]
  ///
  /// this method make http call to get road from specific server
  /// this method return Road that contain road information like distance and duration
  /// and instruction or return Road with empty values.
  ///
  /// return Road object that contain information of road
  /// that will help to draw road in the map or show important information to the user
  /// you should take a specific case when road object will contain empty values like 0.0 or empty string
  /// in case of any problem
  Future<Road> getRoad({
    required List<LngLat> waypoints,
    RoadType roadType = RoadType.car,
    bool alternative = false,
    bool steps = true,
    Overview overview = Overview.full,
    Geometries geometries = Geometries.geojson,
    String languageCode = "en",
  }) async {
    String path = generatePath(
      waypoints.toWaypoints(),
      steps: steps,
      overview: overview,
      geometries: geometries,
    );
    path += "&alternatives=$alternative";

    final response = await dio.get(path);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseJson = response.data;
      return compute(
        parseRoad,
        ParserRoadComputeArg(
          jsonRoad: responseJson,
          langCode: languageCode,
          alternative: alternative,
        ),
      );
    } else {
      return Road.withError();
    }
  }

  /// [getTrip]
  /// this method used to get route from trip service api
  /// used if you have more that 10 waypoint to generate route will more accurate
  /// than [getRoad].
  ///
  /// Please note that if one sets [roundTrip] to false, then
  /// [source] and [destination] must be provided.
  Future<Road> getTrip({
    required List<LngLat> waypoints,
    RoadType roadType = RoadType.car,
    bool roundTrip = true,
    SourceGeoPointOption source = SourceGeoPointOption.any,
    DestinationGeoPointOption destination = DestinationGeoPointOption.any,
    bool steps = true,
    Overview overview = Overview.full,
    Geometries geometries = Geometries.polyline,
    String languageCode = "en",
  }) async {
    if (!roundTrip &&
        (source == SourceGeoPointOption.any ||
            destination == DestinationGeoPointOption.any)) {
      return Road.empty();
    }
    String urlReq = generateTripPath(
      waypoints.toWaypoints(),
      roadType: roadType,
      roundTrip: roundTrip,
      source: source,
      destination: destination,
      steps: steps,
      overview: overview,
      geometries: geometries,
    );
    final response = await dio.get(urlReq);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseJson = response.data;
      return compute(
        parseTrip,
        ParserTripComputeArg(
          tripJson: responseJson,
          langCode: languageCode,
        ),
      );
    } else {
      return Road.withError();
    }
  }

  static String buildInstruction(
    RoadStep step,
    Map<String, dynamic> instructionsHelper,
    Map<String, dynamic> option,
  ) {
    var type = step.maneuver.maneuverType;
    final instructionsV5 = instructionsHelper['v5'] as Map<String, dynamic>;
    if (!instructionsV5.containsKey(type)) {
      type = 'turn';
    }

    var instructionObject = (instructionsV5[type]
        as Map<String, dynamic>)['default'] as Map<String, dynamic>;
    final omitSide = type == 'off ramp' &&
        ((step.maneuver.modifier?.indexOf(step.drivingSide) ?? 0) >= 0);
    if (step.maneuver.modifier != null &&
        (instructionsV5[type] as Map<String, dynamic>)
            .containsKey(step.maneuver.modifier!) &&
        !omitSide) {
      instructionObject = (instructionsV5[type]
              as Map<String, dynamic>)[step.maneuver.modifier!]
          as Map<String, dynamic>;
    }
    String? laneInstruction;
    switch (step.maneuver.maneuverType) {
      case 'use lane':
        final lane = laneConfig(step);
        if (lane != null) {
          laneInstruction = (((instructionsV5[type]
                  as Map<String, dynamic>)['constants']
              as Map<String, dynamic>)['lanes'] as Map<String, String>)[lane];
        } else {
          instructionObject = ((instructionsV5[type]
                  as Map<String, dynamic>)[step.maneuver.maneuverType]
              as Map<String, dynamic>)['no_lanes'] as Map<String, dynamic>;
        }
        break;
      case 'rotary':
      case 'roundabout':
        if (step.rotaryName != null &&
            step.maneuver.exit != null &&
            instructionObject.containsKey('name_exit')) {
          instructionObject =
              instructionObject['name_exit'] as Map<String, dynamic>;
        } else if (step.rotaryName != null &&
            instructionObject.containsKey('name')) {
          instructionObject = instructionObject['name'] as Map<String, dynamic>;
        } else if (step.maneuver.exit != null &&
            instructionObject.containsKey('exit')) {
          instructionObject = instructionObject['exit'] as Map<String, dynamic>;
        } else {
          instructionObject =
              instructionObject['default'] as Map<String, dynamic>;
        }
        break;
      default:
        break;
    }

    final name = retrieveName(step);
    var instruction = instructionObject['default'] as String;
    if (step.destinations != null &&
        step.exits != null &&
        instructionObject.containsKey('exit_destination')) {
      instruction = instructionObject['exit_destination'] as String;
    } else if (step.destinations != null &&
        instructionObject.containsKey('destination')) {
      instruction = instructionObject['destination'] as String;
    } else if (step.exits != null && instructionObject.containsKey('exit')) {
      instruction = instructionObject['exit'] as String;
    } else if (name.isNotEmpty && instructionObject.containsKey('name')) {
      instruction = instructionObject['name'] as String;
    }
    var firstDestination = "";
    try {
      if (step.destinations != null) {
        var destinationSplits = step.destinations!.split(':');
        var destinationRef = destinationSplits.first.split(',').first;
        if (destinationSplits.length > 1) {
          var destination = destinationSplits[1].split(',').first;
          firstDestination = destination;
          if (destination.isNotEmpty && destinationRef.isNotEmpty) {
            firstDestination = "$destinationRef: $destination";
          } else {
            if (destination.isNotEmpty) {
              firstDestination = "$destinationRef: $destination";
            } else if (destinationRef.isNotEmpty) {
              firstDestination = destinationRef;
            }
          }
        } else {
          firstDestination = destinationRef;
        }
      }
    } catch (e) {
      print(e);
    }
    String modifierInstruction = "";
    if (step.maneuver.modifier != null) {
      modifierInstruction =
          (instructionsV5["constants"] as Map<String, dynamic>)["modifier"]
              [step.maneuver.modifier] as String;
    }

    String nthWaypoint = "";
    if (option["legIndex"] != null &&
        option["legIndex"] != -1 &&
        option["legIndex"] != option["legCount"]) {
      String key = (option["legIndex"] + 1).toString();
      nthWaypoint = ordinalize(instructionsV5: instructionsV5, key: key);
    }

    String exitOrdinalise = "";
    if (step.maneuver.exit != null) {
      exitOrdinalise = ordinalize(
          instructionsV5: instructionsV5, key: step.maneuver.exit.toString());
    }

    return tokenize(instruction, {
      "way_name": name,
      "destination": firstDestination,
      "exit": step.exits?.split(",").first ?? "",
      "exit_number": exitOrdinalise,
      "rotary_name": step.rotaryName ?? "",
      "lane_instruction": laneInstruction ?? "",
      "modifier": modifierInstruction,
      "direction": directionFromDegree(step.maneuver.bearingBefore),
      "nth": nthWaypoint,
    });
  }
}

extension OSRMPrivateFunct on OSRMManager {
  @visibleForTesting
  String generatePath(
    String waypoints, {
    Profile profile = Profile.route,
    RoadType roadType = RoadType.car,
    bool steps = true,
    Overview overview = Overview.full,
    Geometries geometries = Geometries.polyline,
  }) {
    String url =
        "$server/routed-${roadType.value}/${profile.name}/v1/diving/$waypoints";
    var option = "";
    option += "steps=$steps&";
    option += "overview=${overview.value}&";
    option += "geometries=${geometries.value}";
    return "$url?$option";
  }

  @visibleForTesting
  String generateTripPath(
    String waypoints, {
    RoadType roadType = RoadType.car,
    bool roundTrip = true,
    SourceGeoPointOption source = SourceGeoPointOption.any,
    DestinationGeoPointOption destination = DestinationGeoPointOption.any,
    bool steps = true,
    Overview overview = Overview.full,
    Geometries geometries = Geometries.polyline,
  }) {
    String baseGeneratedUrl = generatePath(
      waypoints,
      roadType: roadType,
      steps: steps,
      overview: overview,
      profile: Profile.trip,
      geometries: geometries,
    );

    return "$baseGeneratedUrl&source=${source.name}&destination=${destination.name}&roundtrip=$roundTrip";
  }
}
