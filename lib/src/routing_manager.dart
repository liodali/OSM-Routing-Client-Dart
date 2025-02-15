import 'dart:math';
import 'package:dio/dio.dart';
import 'package:routing_client_dart/src/models/lng_lat_radian.dart';
import 'package:routing_client_dart/src/models/math_utils.dart';
import 'package:routing_client_dart/src/models/request_helper.dart';
import 'package:routing_client_dart/src/models/route.dart';
import 'package:routing_client_dart/src/routes_services/osrm_service.dart';
import 'package:routing_client_dart/src/routes_services/valhalla_service.dart';

import 'package:routing_client_dart/src/models/lng_lat.dart';
import 'package:routing_client_dart/src/utilities/utils.dart';

class RoutingManagerConfiguration {
  final Dio? osrmServerDioClient;
  final Dio? valhallaServerDioClient;

  const RoutingManagerConfiguration({
    this.osrmServerDioClient,
    this.valhallaServerDioClient,
  });
}

/// [RoutingManager]
///
/// this class responsible to manage http call to get road from open-source osm server
/// or custom server that should be specified in constructor based on osrm project
/// contain only one public method [getRoad] to make the call
/// and return [Route] object.
///
/// for more detail see : https://github.com/Project-OSRM/osrm-backend
///
///
/// [configuration]   : (RoutingManagerConfiguration) represent the osm server config or any custom server that based of OSRM project
class RoutingManager {
  final RoutingManagerConfiguration configuration;
  final OSRMRoutingService _osrmService;
  final ValhallaRoutingService _valhallaRoutingService;
  RoutingManager({this.configuration = const RoutingManagerConfiguration()})
    : _osrmService = OSRMRoutingService.dioClient(
        client:
            configuration.osrmServerDioClient ??
            Dio(BaseOptions(baseUrl: oSRMServer)),
      ),
      _valhallaRoutingService = ValhallaRoutingService.dioClient(
        client:
            configuration.valhallaServerDioClient ??
            Dio(BaseOptions(baseUrl: osmValhallaServer)),
      );

  /// [getRoute]
  ///
  /// this method make http call to get road from specific server
  /// this method return Road that contain road information like distance and duration
  /// and instruction or return Road with empty values.
  ///
  /// return Road object that contain information of road
  /// that will help to draw road in the map or show important information to the user
  /// you should take a specific case when road object will contain empty values like 0.0 or empty string
  /// in case of any problem
  ///
  /// if [request] is not a instance of [OSRMRequest] and [OSRMRequest.profile] is trip
  /// then this method used to get route from trip service api
  /// used if you have more that 10 waypoint to generate route will more accurate
  /// than [getRoute].
  /// Please note that if one sets [roundTrip] to false, then
  /// [source] and [destination] must be provided.
  ///
  ///
  Future<Route> getRoute({required BaseRequest request}) => switch (request) {
    OSRMRequest _ => _osrmService.getOSRMRoad(request),
    ValhallaRequest _ => _valhallaRoutingService.getValhallaRoad(request),
    _ => Future.value(const Route.empty()),
  };

  /// [isOnPath]
  ///
  /// this method to generate instructions of specific [road]
  bool isOnPath(
    Route road,
    LngLat currentLocation, {
    double tolerance = 0.1,
    int precision = 5,
  }) {
    var polyline = road.polyline;
    if (road.polyline.isNullOrEmpty && road.polylineEncoded == null) {
      throw Exception(
        'we cannot provide next instruction where [polylines] or/and [polylineEncoded]  in roads is null',
      );
    } else if (road.polyline.isNullOrEmpty && road.polylineEncoded != null) {
      polyline = road.polylineEncoded?.decodeGeometry(precision: precision);
    }
    final location = currentLocation.alignWithPrecision(precision: precision);

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
  TurnByTurnInformation? nextInstruction(
    List<RouteInstruction> instructions,
    Route road,
    LngLat currentLocation, {
    double tolerance = 0.1,
    int precision = 6,
  }) {
    var polyline = road.polyline;
    if (road.polyline.isNullOrEmpty && road.polylineEncoded == null) {
      throw Exception(
        'we cannot provide next instruction where [polylines] or/and [polylineEncoded]  in roads is null',
      );
    } else if (road.polyline.isNullOrEmpty && road.polylineEncoded != null) {
      polyline = road.polylineEncoded!.decodeGeometry(precision: precision);
    }
    final location = currentLocation.alignWithPrecision(precision: precision);

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

    var currentInstruction = instructions.cast<RouteInstruction?>().firstWhere(
      (element) => element != null && element.location == nextLocation,
      orElse: () => null,
    );
    currentInstruction ??= closeInstructionToLocation(
      instructions,
      nextLocation,
    );

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

extension RoadManagerUtils on RoutingManager {
  /// [indexOfLocationFromRoad]
  ///
  /// this method will return int that index of Location from [polylines] and current [location]
  /// within a specified [tolerance].
  ///
  /// tolerance (in meters)
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
    final lngLatRadian = LngLatRadians.fromLngLat(location: location);
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
          havTolerance,
        )) {
          return max(0, idx - 1);
        }
        prevRadian = lngLat2;
        idx++;
      }
    } else {
      final (minAcceptable, maxAcceptable) = (
        lngLatRadian.latitude - toleranceCalc,
        lngLatRadian.latitude + toleranceCalc,
      );
      var y1 = MathUtil.mercator(prevRadian.latitude);
      var y3 = MathUtil.mercator(lngLatRadian.latitude);
      final xtry = List.generate(3, (index) => 0.0);
      for (final lngLat in polylines) {
        final point2 = lngLat.lngLatRadian;
        final y2 = MathUtil.mercator(point2.latitude);
        if (max(prevRadian.latitude, point2.latitude) >= minAcceptable &&
            min(prevRadian.latitude, point2.latitude) <= maxAcceptable) {
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
            double t =
                len2 <= 0
                    ? 0
                    : MathUtil.clamp((x3 * x2 + (y3 - y1) * dy) / len2, 0, 1);
            double xClosest = t * x2;
            double yClosest = y1 + t * dy;
            double latClosest = MathUtil.inverseMercator(yClosest);
            double havDist = MathUtil.havDistance(
              lngLatRadian.latitude,
              latClosest,
              x3 - xClosest,
            );
            if (havDist < havTolerance) {
              return max(0, idx - 1);
            }
          }
        }
        prevRadian = point2;
        y1 = y2;
        idx++;
      }
    }
    return -1;
  }

  RouteInstruction? closeInstructionToLocation(
    List<RouteInstruction> instructions,
    LngLat location,
  ) {
    final instructionWithDistance =
        instructions
            .map(
              (instruction) => (
                instruction,
                location.distance(location: instruction.location),
              ),
            )
            .toList()
          ..sort((a, b) => a.$2.compareTo(b.$2));
    return instructionWithDistance.first.$1;
  }

  bool isOnSegmentGC(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
    double lat3,
    double lng3,
    double havTolerance,
  ) {
    double havDist13 = MathUtil.havDistance(lat1, lat3, lng1 - lng3);
    if (havDist13 <= havTolerance) {
      return false;
    }

    double havDist23 = MathUtil.havDistance(lat2, lat3, lng2 - lng3);
    if (havDist23 <= havTolerance) {
      return false;
    }

    double sinBearing = MathUtil.sinDeltaBearing(
      lat1,
      lng1,
      lat2,
      lng2,
      lat3,
      lng3,
    );
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
    double sinSumAlongTrack = MathUtil.sinSumFromHav(
      havAlongTrack13,
      havAlongTrack23,
    );

    // Compare with half-circle == pi using sign of sin().
    return sinSumAlongTrack > 0;
  }
}

extension PrvRoutingManager on RoutingManager {
  OSRMRoutingService get osrmClient => _osrmService;
  ValhallaRoutingService get valhallaClient => _valhallaRoutingService;
}
