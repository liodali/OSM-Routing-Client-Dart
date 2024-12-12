import 'package:routing_client_dart/routing_client_dart.dart';
import 'package:routing_client_dart/src/models/valhalla/costing.dart';
import 'package:routing_client_dart/src/models/valhalla/costing_option.dart';
import 'package:routing_client_dart/src/utilities/utils.dart';
import 'package:routing_client_dart/src/utilities/valhalla_utilities.dart';

enum HeaderServiceType { osrm, openroute, valhalla }

abstract class BaseRequest<T> {
  final List<LngLat> waypoints;
  final Languages languages;
  final int alternatives;

  const BaseRequest({
    required this.waypoints,
    this.languages = Languages.en,
    this.alternatives = 2,
  });

  T encodeHeader();
}

class OSRMRequest extends BaseRequest<String> {
  final Profile profile;
  final RoadType roadType;
  final bool steps;
  final Overview overview;
  final Geometries geometries;
  final bool roundTrip;
  final SourceGeoPointOption source;
  final DestinationGeoPointOption destination;
  const OSRMRequest.route({
    required super.waypoints,
    super.languages,
    this.roadType = RoadType.car,
    this.steps = true,
    this.overview = Overview.full,
    this.geometries = Geometries.polyline,
  })  : profile = Profile.route,
        roundTrip = false,
        source = SourceGeoPointOption.any,
        destination = DestinationGeoPointOption.any;
  const OSRMRequest.trip({
    required super.waypoints,
    super.languages,
    this.roadType = RoadType.car,
    this.steps = true,
    this.overview = Overview.full,
    this.geometries = Geometries.polyline,
    this.roundTrip = true,
    this.source = SourceGeoPointOption.any,
    this.destination = DestinationGeoPointOption.any,
  }) : profile = Profile.trip;
  @override
  String encodeHeader() {
    String baseURLOptions =
        "/routed-${roadType.name}/${profile.name}/v1/driving/$waypoints";
    var option = "";
    option += "steps=$steps&";
    option += "overview=${overview.value}&";
    option += "geometries=${geometries.value}";
    if (profile == Profile.trip) {
      option +=
          "&source=${source.name}&destination=${destination.name}&roundtrip=$roundTrip";
    }
    return "$baseURLOptions?$option";
  }
}

class OpenRouteHeader extends BaseRequest<Map<String, dynamic>> {
  final String apiKey;
  OpenRouteHeader({
    required super.waypoints,
    super.languages,
    required this.apiKey,
  }) : assert(apiKey.isEmpty,
            "please you cannot use openrouteservice without API Key");

  @override
  Map<String, dynamic> encodeHeader() {
    // TODO: implement encodeHeader
    throw UnimplementedError();
  }
}

class ValhallaRequest extends BaseRequest<Map<String, dynamic>> {
  final ValhallaFormat valhallaFormat;
  final Geometries? valhallaShapeFormat;
  final ValhallaDirectionsType directionsType;
  final Costing costing;
  final BaseCostingOption? costingOption;
  final ValhallaUnit units;
  final DateTime? time;
  ValhallaRequest({
    required super.waypoints,
    this.directionsType = ValhallaDirectionsType.instructions,
    this.costingOption,
    this.costing = Costing.auto,
    this.units = ValhallaUnit.km,
    super.languages,
    this.time,
    this.valhallaFormat = ValhallaFormat.json,
    this.valhallaShapeFormat,
    super.alternatives,
  })  : assert(
          waypoints.length == 2,
          "we dont support more that 2 points for routing service for now",
        ),
        assert(
          languages != Languages.ar,
          "arabic language not supported for now",
        ),
        assert(
          (valhallaFormat == ValhallaFormat.orsm &&
                  Geometries.values.contains(valhallaShapeFormat)) ||
              valhallaFormat != ValhallaFormat.orsm,
        );

  @override
  Map<String, dynamic> encodeHeader() => {
        'locations': waypoints.map((e) => e.toMap()).toList(),
        'costing': costing.name,
        'units': units.name,
        'language': languages.name,
        'directions_type': directionsType.name,
        'format': valhallaFormat.name,
        'alternates': alternatives,
      }..addIfNotNull(
          'shape_format',
          valhallaFormat == ValhallaFormat.orsm && valhallaShapeFormat != null
              ? (valhallaShapeFormat ?? Geometries.polyline6).name
              : null,
        );
}
