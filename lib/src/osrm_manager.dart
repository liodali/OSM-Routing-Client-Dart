import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:routing_client_dart/src/models/osrm_mixin.dart';
import 'package:routing_client_dart/src/models/road_helper.dart';
import 'utilities/computes_utilities.dart';

import 'package:routing_client_dart/src/models/lng_lat.dart';
import 'package:routing_client_dart/src/models/road.dart';
import 'package:routing_client_dart/src/utilities/utils.dart';

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
class OSRMManager with OSRMHelper {
  final String server;
  final RoadType roadType;
  late final Dio dio;

  OSRMManager()
      : server = oSRMServer,
        roadType = RoadType.car;

  OSRMManager.custom({
    required this.server,
    this.roadType = RoadType.car,
    Dio? dio,
  }){
    this.dio= dio ?? Dio();
  }

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
    Languages language = Languages.en,
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
          langCode: language.name,
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
    Languages language = Languages.en,
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
          langCode: language.name,
        ),
      );
    } else {
      return Road.withError();
    }
  }
  /// [buildInstructions]
  /// 
  /// this method to generate instructions of specific [road]
  Future<List<RoadInstruction>> buildInstructions(Road road) async {
    final legs = road.roadLegs;
    final instructionsHelper = await loadInstructionHelperJson();
    final List<RoadInstruction> instructions = [];
    legs.asMap().forEach((indexLeg, listSteps) {
      for (var step in listSteps) {
        final instruction = buildInstruction(
          step,
          instructionsHelper,
          {
            "legIndex": indexLeg,
            "legCount": legs.length - 1,
          },
        );
        RoadInstruction roadInstruction = RoadInstruction(
          distance: step.distance,
          duration: step.duration,
          instruction: instruction,
          location: step.maneuver.location,
        );
        instructions.add(roadInstruction);
      }
    });
    return instructions;
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
