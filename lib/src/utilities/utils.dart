import 'dart:math' as math;
import 'dart:convert' show ascii;
import 'package:routing_client_dart/src/models/lng_lat.dart';
import 'package:routing_client_dart/src/models/osrm/road.dart';
import 'package:routing_client_dart/src/models/route.dart';
import 'package:routing_client_dart/src/utilities/computes_utilities.dart';
import 'package:fixnum/fixnum.dart';

const String oSRMServer = "https://routing.openstreetmap.de";
const String osmValhallaServer = "https://valhalla1.openstreetmap.de/route";
const double earthRadius = 6371009;
typedef TurnByTurnInformation =
    ({
      RouteInstruction currentInstruction,
      RouteInstruction? nextInstruction,
      double distance,
    });

enum Languages {
  en("en-US", 'en'),
  es("es-ES", 'es'),
  de("de-DE", 'de'),
  ar("ar-AR", 'ar');

  const Languages(this.name, this.code);
  final String name;
  final String code;
}

enum RoutingType { car, foot, bike, publicTransportation, taxi, truck }

enum Profile { route, trip }

enum Overview { simplified, full, none }

enum Geometries { polyline, polyline6, geojson }

enum SourceGeoPointOption { any, first }

enum DestinationGeoPointOption { any, last }

extension RoutingTypeExtension on RoutingType {
  String get value {
    return ["car", "foot", "bike"][index];
  }
}

extension OverviewExtension on Overview {
  String get value {
    return ["simplified", "full", "false"][index];
  }
}

extension GeometriesExtension on Geometries {
  String get value {
    return ["polyline", "polyline6", "geojson"][index];
  }
}

extension TransformToWaysOSRM on List<LngLat> {
  /// Converts the list of [LngLat] objects to a semicolon-separated string
  /// of waypoints.
  ///
  /// Returns a [String] where each [LngLat] is represented by its string
  /// representation, separated by semicolons.

  String toWaypoints() {
    return map(
      (lngLat) => lngLat.toString(),
    ).reduce((value, element) => "$value;$element");
  }

  List<List<double>> toMapList() =>
      map((lngLat) => [lngLat.lng, lngLat.lat]).toList();
}

extension ExtList on List? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

extension ExtMap on Map<String, dynamic> {
  /// Adds [value] to map using [key] if and only if [value] is not null.
  ///
  /// If [value] is not null but is not an Object, it is added to the map as a
  /// dynamic value. This is useful for adding primitive types like int, double,
  /// String, etc. to the map.
  ///
  /// This is a convenience method that is equivalent to:
  ///
  ///     if (value != null) {
  ///       map[key] = value;
  ///     }
  ///
  /// but is more concise and easier to read.
  Map<String, dynamic> addIfNotNull(String key, dynamic value) {
    if (value != null && value is Object) {
      putIfAbsent(key, () => value);
    } else if (value != null) {
      putIfAbsent(key, () => value as dynamic);
    }
    return this;
  }
}

double parseToDouble(dynamic value) {
  return double.parse(value.toString());
}

extension EncodeExt on List<LngLat> {
  /// Encodes `List<List<num>>` of [coordinates] into a `String` via
  /// [Encoded Polyline Algorithm Format](https://developers.google.com/maps/documentation/utilities/polylinealgorithm?hl=en)
  ///
  /// For mode detailed info about encoding refer to [encodePoint].
  String encodeGeometry({int precision = 5}) {
    if (isEmpty) {
      return "";
    }

    final factor = math.pow(10, precision);
    var output =
        _encode(this[0].lat, 0, factor) + _encode(this[0].lng, 0, factor);

    for (var i = 1; i < length; i++) {
      var current = this[i], previous = this[i - 1];
      output += _encode(current.lat, previous.lat, factor);
      output += _encode(current.lng, previous.lng, factor);
    }

    return output;
  }
}

extension EncodeGeoPointExt on num {
  /// [encodePoint]
  ///
  /// Encodes a single geographic point into a `String` via
  /// [Encoded Polyline Algorithm Format](https://developers.google.com/maps/documentation/utilities/polylinealgorithm?hl=en).
  ///
  /// The [previous] parameter is the previous geographic point, used
  /// to calculate the delta between the two points. The [accuracyExponent]
  /// parameter determines the precision of the encoded coordinates,
  /// with a default value of 5.
  ///
  /// Returns a `String` representing the encoded geographic point.
  String encodePoint({num previous = 0, int accuracyExponent = 5}) {
    return _encode(this, previous, math.pow(10, accuracyExponent));
  }
}

extension DecodingExt on String {
  /// [decodeGeometry]
  ///
  /// Decodes an encoded polyline string into a list of [LngLat] coordinates.
  ///
  /// The [precision] parameter determines the precision of the encoded
  /// coordinates, with a default value of 6. This function decodes the
  /// encoded polyline using the algorithm described in Google's Encoded
  /// Polyline Algorithm Format.
  ///
  ///
  /// Returns a list of [LngLat] objects representing the decoded
  /// geographic points.

  List<LngLat> decodeGeometry({int precision = 5}) {
    final List<LngLat> coordinates = [];

    var index = 0,
        lat = 0,
        lng = 0,
        shift = 0,
        result = 0,
        factor = math.pow(10, precision);

    int? latitudeChange, longitudeChange, byte;

    // Coordinates have variable length when encoded, so just keep
    // track of whether we've hit the end of the string. In each
    // loop iteration, a single coordinate is decoded.
    while (index < length) {
      // Reset shift, result, and byte
      byte = null;
      shift = 0;
      result = 0;

      do {
        byte = codeUnitAt(index++) - 63;
        result |= ((Int32(byte) & Int32(0x1f)) << shift).toInt();
        shift += 5;
      } while (byte >= 0x20);

      latitudeChange =
          ((result & 1) != 0 ? ~(Int32(result) >> 1) : (Int32(result) >> 1))
              .toInt();

      shift = result = 0;

      do {
        byte = codeUnitAt(index++) - 63;
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

/// [parseRoad]
///
/// this method used to parse json get it  from route service to [Road] object
/// we use this method in another thread like compute
/// the [data] is [ParserRoadComputeArg] that will to be parsed to [Road]
/// fix parsing problem [#1]
/// return [Road] object that contain list of waypoint
/// and distance and duration of the road
Future<OSRMRoad> parseRoad(ParserRoadComputeArg data) async {
  Map<String, dynamic> jsonResponse = data.json;
  bool alternative = data.alternative;
  var road = const OSRMRoad.empty();
  final List<Map<String, dynamic>> routes = List.castFrom(
    jsonResponse["routes"],
  );

  final route = routes.first;

  road = OSRMRoad.fromOSRMJson(route: route);

  if (routes.length > 1 && alternative) {
    routes.removeAt(0);
    for (var route in routes) {
      final alternative = OSRMRoad.fromOSRMJson(route: route);
      road.addAlternativeRoute(alternative);
    }
  }

  return road;
}

/// [parseTrip
/// ]
/// this method used to parse json get from trip service,
/// the [data] is  [ParserTripComputeArg] that contain information need it to be parsed to [Road]
/// such as json map and language that will be instruction
/// return [Road] object that contain list of waypoint and other information
/// this road represent trip that will pass by all geopoint entered as args
/// and this road will not be the shortes route
Future<OSRMRoad> parseTrip(ParserTripComputeArg data) async {
  Map<String, dynamic> jsonResponse = data.json;
  var road = const OSRMRoad.empty();
  final List<Map<String, dynamic>> routes = List.castFrom(
    jsonResponse["trips"],
  );
  final route = routes.first;
  road = OSRMRoad.fromOSRMJson(route: route);

  return road;
}

num _py2Round(num value) {
  return (value.abs() + 0.5).floor() * (value >= 0 ? 1 : -1);
}

String _encode(num current, num previous, num factor) {
  current = _py2Round(current * factor);
  previous = _py2Round(previous * factor);
  Int32 coordinate = Int32(current as int) - Int32(previous as int) as Int32;
  coordinate <<= 1;
  if (current - previous < 0) {
    coordinate = ~coordinate;
  }
  var output = "";
  while (coordinate >= Int32(0x20)) {
    try {
      Int32 v = (Int32(0x20) | (coordinate & Int32(0x1f))) + 63 as Int32;
      output += String.fromCharCodes([v.toInt()]);
    } catch (err) {
      rethrow;
    }
    coordinate >>= 5;
  }
  output += ascii.decode([coordinate.toInt() + 63]);
  return output;
}
