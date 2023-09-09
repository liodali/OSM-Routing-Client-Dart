import 'dart:math';

import 'package:fixnum/fixnum.dart';
import 'package:routing_client_dart/src/models/lng_lat.dart';
import 'package:routing_client_dart/src/models/road_helper.dart';
import 'package:routing_client_dart/src/utilities/utils.dart';

/// [Road]
class Road {
  /// this attribute is the  distance of the route in km
  final double distance;

  /// this attribute is the duration of route in second
  final double duration;

  /// this is the encoded list of lnglat that should decoded to get list of geopoint
  /// this attribute can be null if the geometry == geojson
  final String? polylineEncoded;

  /// this is list of geopoint of the route,this attribute is not null if geometry equal to geojson
  /// except that use always [polylineEncoded]
  List<LngLat>? polyline;
  List<Road>? _alternativesRoads;
  bool _isError = false;
  RoadDetailInfo details = RoadDetailInfo();
  final List<List<RoadStep>> _roadLegs = <List<RoadStep>>[];
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
          //RoadInstruction? lastNode;
          var lastName = "";
          final List<RoadStep> roadSteps = [];
          for (var step in steps) {
            final roadStep = RoadStep.fromJson(step);
            roadSteps.add(roadStep);
            // String instruction = OSRMManager.

            if (roadStep.maneuver.maneuverType != "new name" &&
                lastName != roadStep.name) {
              //   lastNode.distance += distance;
              //   lastNode.duration += duration;
              // } else {
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
      polylineEncoded: polylineEncoded ?? this.polylineEncoded,
    ).._alternativesRoads = alternativesRoads;
  }
}

extension PrivateRoad on Road {
  List<List<RoadStep>> get roadLegs => _roadLegs;
  List<LngLat> decodePoylinesGeometry(String str, {int precision = 5}) {
    final List<LngLat> coordinates = [];

    var index = 0,
        lat = 0,
        lng = 0,
        shift = 0,
        result = 0,
        factor = pow(10, precision);

    int? latitudeChange, longitudeChange, byte;

    // Coordinates have variable length when encoded, so just keep
    // track of whether we've hit the end of the string. In each
    // loop iteration, a single coordinate is decoded.
    while (index < str.length) {
      // Reset shift, result, and byte
      byte = null;
      shift = 0;
      result = 0;

      do {
        byte = str.codeUnitAt(index++) - 63;
        result |= ((Int32(byte) & Int32(0x1f)) << shift).toInt();
        shift += 5;
      } while (byte >= 0x20);

      latitudeChange =
          ((result & 1) != 0 ? ~(Int32(result) >> 1) : (Int32(result) >> 1))
              .toInt();

      shift = result = 0;

      do {
        byte = str.codeUnitAt(index++) - 63;
        result |= ((Int32(byte) & Int32(0x1f)) << shift).toInt();
        shift += 5;
      } while (byte >= 0x20);

      longitudeChange =
          ((result & 1) != 0 ? ~(Int32(result) >> 1) : (Int32(result) >> 1))
              .toInt();

      lat += latitudeChange;
      lng += longitudeChange;

      coordinates.add(LngLat(lat: lat / factor, lng: lng / factor));
    }

    return coordinates;
  }
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
