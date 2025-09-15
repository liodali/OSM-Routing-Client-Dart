import 'package:routing_client_dart/src/models/lng_lat.dart';

class Route {
  /// this attribute is the  distance of the route in km
  final double distance;

  /// this attribute is the duration of route in second
  final double duration;

  /// this is the encoded list of lnglat that should decoded to get list of geopoint
  /// this attribute can be null if the geometry == geojson
  final String? polylineEncoded;

  /// this is list of geopoint of the route,this attribute is not null if geometry equal to geojson
  /// except that use always [polylineEncoded]
  final List<LngLat>? polyline;
  List<Route>? _alternativesRoads = [];
  final List<RouteInstruction> instructions;
  Route({
    required this.distance,
    required this.duration,
    required this.polylineEncoded,
    this.instructions = const <RouteInstruction>[],
    List<Route> alternativesRoads = const [],
    this.polyline = const <LngLat>[],
  }) : _alternativesRoads = alternativesRoads;
  Route.empty()
    : distance = 0.0,
      duration = 0.0,
      polylineEncoded = '',
      instructions = const <RouteInstruction>[],
      _alternativesRoads = null,
      polyline = const <LngLat>[];

  List<Route>? get alternativesRoads => _alternativesRoads;

  Route copyWith({
    double? distance,
    double? duration,
    String? polylineEncoded,
    List<LngLat>? polyline,
    List<Route>? alternativesRoads,
    List<RouteInstruction>? instructions,
  }) => Route(
    distance: distance ?? this.distance,
    duration: duration ?? this.duration,
    polylineEncoded: polylineEncoded ?? this.polylineEncoded,
    polyline: polyline ?? this.polyline,
    alternativesRoads: alternativesRoads ?? _alternativesRoads ?? [],
    instructions: instructions ?? this.instructions,
  );

  void addAlternativeRoute(Route road) {
    _alternativesRoads?.add(road);
  }
}

class RouteInstruction {
  final double distance;
  final double duration;
  final String instruction;
  final LngLat location;

  const RouteInstruction({
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

class ValhallaRouteInstruction extends RouteInstruction {
  final String? verbalPreinstruction;
  final String? verbalPostinstruction;
  final LngLat endInstructionLocation;
  const ValhallaRouteInstruction({
    required super.distance,
    required super.duration,
    required super.instruction,
    required super.location,
    required this.endInstructionLocation,
    this.verbalPreinstruction,
    this.verbalPostinstruction,
  });

  @override
  String toString() {
    return "$instruction at $location";
  }
}
