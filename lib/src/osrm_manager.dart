import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:routing_client_dart/src/models/lng_lat.dart';
import 'package:routing_client_dart/src/models/lng_lat_radian.dart';
import 'package:routing_client_dart/src/models/math_utils.dart';
import 'package:routing_client_dart/src/models/osrm_mixin.dart';
import 'package:routing_client_dart/src/models/road.dart';
import 'package:routing_client_dart/src/utilities/computes_utilities.dart';
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
        roadType = RoadType.car,
        dio = Dio();

  OSRMManager.custom({
    required this.server,
    this.roadType = RoadType.car,
    Dio? dio,
  }) {
    this.dio = dio ?? Dio();
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
    RoadType? roadType,
    bool alternative = false,
    bool steps = true,
    Overview overview = Overview.full,
    Geometries geometries = Geometries.geojson,
    Languages language = Languages.en,
  }) async {
    roadType ??= this.roadType;
    String path = generatePath(
      server,
      waypoints.toWaypoints(),
      steps: steps,
      overview: overview,
      geometries: geometries,
      roadType: roadType,
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
  ///
  /// this method used to get route from trip service api
  /// used if you have more that 10 waypoint to generate route will more accurate
  /// than [getRoad].
  ///
  /// Please note that if one sets [roundTrip] to false, then
  /// [source] and [destination] must be provided.
  Future<Road> getTrip({
    required List<LngLat> waypoints,
    RoadType? roadType,
    bool roundTrip = true,
    SourceGeoPointOption source = SourceGeoPointOption.any,
    DestinationGeoPointOption destination = DestinationGeoPointOption.any,
    bool steps = true,
    Overview overview = Overview.full,
    Geometries geometries = Geometries.polyline,
    Languages language = Languages.en,
  }) async {
    roadType ??= this.roadType;

    if (!roundTrip &&
        (source == SourceGeoPointOption.any ||
            destination == DestinationGeoPointOption.any)) {
      return Road.empty();
    }
    String urlReq = generateTripPath(
      oSRMServer,
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
  Future<List<RoadInstruction>> buildInstructions(
    Road road, {
    Languages languages = Languages.en,
  }) async {
    final legs = road.roadLegs;
    final instructionsHelper =
        await loadInstructionHelperJson(language: languages);
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

  /// [isOnPath]
  ///
  /// this method to generate instructions of specific [road]
  Future<bool> isOnPath(
    Road road,
    LngLat currentLocation, {
    double tolerance = 0.1,
  }) async {
    var polyline = road.polyline;
    if (road.polyline == null && road.polylineEncoded == null) {
      throw Exception(
          'we cannot provide next instruction where [polylines] or/and [polylineEncoded]  in roads is null');
    } else if (road.polyline == null && road.polylineEncoded != null) {
      polyline = PrivateRoad.decodePoylinesGeometry(road.polylineEncoded!);
    }
    final location = currentLocation.alignWithPrecision(precision: 5);

    final indexOfNextLocation = indexOfLocationFromRoad(
      location,
      polyline!,
      tolerance: tolerance,
    );
    if (indexOfNextLocation == -1 ||
        indexOfNextLocation > polyline.length - 1) {
      return false;
    }
    return true;
  }

  /// [nextInstruction]
  ///
  /// this method will provide the [TurnByTurnInformation] from [currentLocation],[instructions] and [road]
  /// which contain current instruction,next instruction and distance between [currentLocation] and [nextInstruction.location]
  /// the distance will in meters
  ///
  /// Note that [tolerance] can effect the result which used to mesure location in road which close to [currentLocation]
  ///
  /// return Future of TurnByTurnInformation, can be null also if current location not in Path
  Future<TurnByTurnInformation?> nextInstruction(
    List<RoadInstruction> instructions,
    Road road,
    LngLat currentLocation, {
    double tolerance = 0.1,
  }) async {
    var polyline = road.polyline;
    if (road.polyline == null && road.polylineEncoded == null) {
      throw Exception(
          'we cannot provide next instruction where [polylines] or/and [polylineEncoded]  in roads is null');
    } else if (road.polyline == null && road.polylineEncoded != null) {
      polyline = PrivateRoad.decodePoylinesGeometry(road.polylineEncoded!);
    }
    final location = currentLocation.alignWithPrecision(precision: 5);

    final indexOfNextLocation = indexOfLocationFromRoad(
      location,
      polyline!,
      tolerance: tolerance,
    );
    if (indexOfNextLocation == -1 ||
        indexOfNextLocation > polyline.length - 1) {
      return null;
    }
    final nextLocation = polyline[indexOfNextLocation];

    var currentInstruction = instructions.cast<RoadInstruction?>().firstWhere(
        (element) => element != null && element.location == nextLocation,
        orElse: () => null);
    currentInstruction ??=
        closeInstructionToLocation(instructions, nextLocation);

    if (currentInstruction == null) {
      return null;
    }

    final nextInstruction =
        instructions[instructions.indexOf(currentInstruction) + 1];
    return (
      currentInstruction: currentInstruction,
      nextInstruction: nextInstruction,
      distance: location.distance(location: nextInstruction.location),
    );
  }
}

extension RoadManagerUtils on OSRMManager {
  /// [indexOfLocationFromRoad]
  ///
  /// this method will return int that index of Location from [polylines] and current [location]
  /// within a specified [tolerance].
  ///
  /// **note : our [location] use precision 5,it better to provide [LngLat] with the precision 5 means 5 digits after fraction
  ///
  /// credit from [https://github.com/googlemaps/android-maps-utils/blob/main/library/src/main/java/com/google/maps/android/PolyUtil.java]
  int indexOfLocationFromRoad(
    LngLat location,
    List<LngLat> polylines, {
    bool closed = false,
    bool geodesic = false,
    double tolerance = 0.1,
  }) {
    if (polylines.isEmpty) {
      return -1;
    }
    if (polylines.contains(location)) {
      return polylines.indexOf(location);
    }

    double toleranceCalc = tolerance / earthRadius;
    double havTolerance = MathUtil.hav(toleranceCalc);
    final lngLatRadian = LngLatRadians.fromLngLat(
      location: location,
    );
    final prev = polylines[closed ? polylines.length - 1 : 0];
    var prevRadian = prev.lngLatRadian;
    var idx = 0;
    if (geodesic) {
      for (final point2 in polylines) {
        var lngLat2 = point2.lngLatRadian;

        if (isOnSegmentGC(
            prevRadian.latitude,
            prevRadian.longitude,
            lngLat2.latitude,
            lngLat2.longitude,
            lngLatRadian.latitude,
            lngLatRadian.longitude,
            havTolerance)) {
          return max(0, idx - 1);
        }
        prevRadian = lngLat2;
        idx++;
      }
    } else if (!geodesic) {
      final (minAcceptable, maxAcceptable) = (
        lngLatRadian.latitude - toleranceCalc,
        lngLatRadian.latitude + toleranceCalc
      );
      var y1 = MathUtil.mercator(prevRadian.latitude);
      var y3 = MathUtil.mercator(lngLatRadian.latitude);
      final xtry = List.generate(
        3,
        (index) => 0.0,
      );
      for (final lngLat in polylines) {
        final point2 = lngLat.lngLatRadian;
        final y2 = MathUtil.mercator(point2.latitude);
        if (max(prev.lat, point2.latitude) >= minAcceptable &&
            min(prev.lat, point2.latitude) <= maxAcceptable) {
          final x2 = MathUtil.wrap(
            point2.longitude - prevRadian.longitude,
            -pi,
            pi,
          );
          final x3Base = MathUtil.wrap(
            lngLatRadian.longitude - prevRadian.longitude,
            -pi,
            pi,
          );
          xtry[0] = x3Base;
          xtry[1] = x3Base + (2 * pi);
          xtry[2] = x3Base - (2 * pi);
          for (final x3 in xtry) {
            double dy = y2 - y1;
            double len2 = x2 * x2 + dy * dy;
            double t = len2 <= 0
                ? 0
                : MathUtil.clamp((x3 * x2 + (y3 - y1) * dy) / len2, 0, 1);
            double xClosest = t * x2;
            double yClosest = y1 + t * dy;
            double latClosest = MathUtil.inverseMercator(yClosest);
            double havDist = MathUtil.havDistance(
                lngLatRadian.latitude, latClosest, x3 - xClosest);
            if (havDist < havTolerance) {
              return max(0, idx - 1);
            }
          }
          prevRadian = point2;
          y1 = y2;
          idx++;
        }
      }
    }
    return -1;
  }

  RoadInstruction? closeInstructionToLocation(
    List<RoadInstruction> instructions,
    LngLat location,
  ) {
    final instructionWithDistance = instructions
        .map((instruction) =>
            (instruction, location.distance(location: instruction.location)))
        .toList()
      ..sort((a, b) => a.$2.compareTo(b.$2));
    return instructionWithDistance.first.$1;
  }

  bool isOnSegmentGC(double lat1, double lng1, double lat2, double lng2,
      double lat3, double lng3, double havTolerance) {
    double havDist13 = MathUtil.havDistance(lat1, lat3, lng1 - lng3);
    if (havDist13 <= havTolerance) {
      return false;
    }

    double havDist23 = MathUtil.havDistance(lat2, lat3, lng2 - lng3);
    if (havDist23 <= havTolerance) {
      return false;
    }

    double sinBearing =
        MathUtil.sinDeltaBearing(lat1, lng1, lat2, lng2, lat3, lng3);
    double sinDist13 = MathUtil.sinFromHav(havDist13);
    double havCrossTrack = MathUtil.havFromSin(sinDist13 * sinBearing);
    if (havCrossTrack > havTolerance) {
      return false;
    }

    double havDist12 = MathUtil.havDistance(lat1, lat2, lng1 - lng2);
    double term = havDist12 + havCrossTrack * (1 - 2 * havDist12);
    if (havDist13 > term || havDist23 > term) {
      return false;
    }

    if (havDist12 < 0.74) {
      return false;
    }

    double cosCrossTrack = 1 - 2 * havCrossTrack;
    double havAlongTrack13 = (havDist13 - havCrossTrack) / cosCrossTrack;
    double havAlongTrack23 = (havDist23 - havCrossTrack) / cosCrossTrack;
    double sinSumAlongTrack =
        MathUtil.sinSumFromHav(havAlongTrack13, havAlongTrack23);

    // Compare with half-circle == pi using sign of sin().
    return sinSumAlongTrack > 0;
  }
}
