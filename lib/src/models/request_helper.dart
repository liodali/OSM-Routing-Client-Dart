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
  final RoutingType routingType;
  final bool steps;
  final Overview overview;
  final Geometries geometries;
  final bool roundTrip;
  final SourceGeoPointOption source;
  final DestinationGeoPointOption destination;
  final bool? hasAlternative;
  const OSRMRequest.route({
    required super.waypoints,
    super.languages,
    this.routingType = RoutingType.car,
    this.steps = true,
    this.overview = Overview.full,
    this.geometries = Geometries.polyline,
    bool? alternatives = false,
  }) : profile = Profile.route,
       roundTrip = false,
       source = SourceGeoPointOption.any,
       hasAlternative = alternatives,
       destination = DestinationGeoPointOption.any;
  const OSRMRequest.trip({
    required super.waypoints,
    super.languages,
    this.routingType = RoutingType.car,
    this.steps = true,
    this.overview = Overview.full,
    this.geometries = Geometries.polyline,
    this.roundTrip = true,
    this.source = SourceGeoPointOption.any,
    this.destination = DestinationGeoPointOption.any,
  }) : profile = Profile.trip,
       hasAlternative = null;
  @override
  String encodeHeader() {
    String baseURLOptions =
        "/routed-${routingType.name}/${profile.name}/v1/driving/${waypoints.toWaypoints()}";
    var option = "";
    option += "steps=$steps&";
    option += "overview=${overview.value}&";
    option += "geometries=${geometries.value}";
    if (hasAlternative != null) {
      option += "&alternatives=$hasAlternative";
    }

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
  }) : assert(
         apiKey.isEmpty,
         "please you cannot use openrouteservice without API Key",
       );

  @override
  Map<String, dynamic> encodeHeader() {
    // TODO: implement encodeHeader
    throw UnimplementedError();
  }
}

class ValhallaRequest extends BaseRequest<Map<String, dynamic>> {
  final String? id;
  final ValhallaFormat valhallaFormat;
  final Geometries? valhallaShapeFormat;
  final ValhallaDirectionsType directionsType;
  final List<LngLat>? excludeLocations;
  final List<dynamic>? excludePolygones;
  final Costing costing;
  final BaseCostingOption? costingOption;
  final ValhallaUnit units;
  final DateTime? time;
  final bool? bannerInstructions;
  final bool? voiceInstructions;
  ValhallaRequest({
    this.id,
    required super.waypoints,
    this.excludeLocations,
    this.excludePolygones,
    this.directionsType = ValhallaDirectionsType.instructions,
    this.costingOption,
    this.costing = Costing.auto,
    this.units = ValhallaUnit.km,
    super.languages,
    this.time,
    this.valhallaFormat = ValhallaFormat.json,
    this.valhallaShapeFormat,
    this.bannerInstructions,
    this.voiceInstructions,
    super.alternatives,
  }) : assert(
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
  Map<String, dynamic> encodeHeader() {
    final mapHeader =
        {
            'locations':
                waypoints.map((e) {
                  final mPoint = e.toMap();
                  mPoint['type'] = 'break';
                  return mPoint;
                }).toList(),
            'exclude_polygons': [],
            'costing': costing.name,
            'units': units.name,
            'language': languages.name,
            'directions_type': directionsType.name,
            'format': valhallaFormat.name,
            'alternates': alternatives,
          }
          ..addIfNotNull('id', id)
          ..addIfNotNull(
            'shape_format',
            valhallaFormat == ValhallaFormat.orsm && valhallaShapeFormat != null
                ? (valhallaShapeFormat ?? Geometries.polyline6).name
                : null,
          )
          ..addIfNotNull(
            'costing_options',
            costingOption != null
                ? {costing.name: costingOption!.toMap()}
                : null,
          )
          ..addIfNotNull('banner_instructions', bannerInstructions)
          ..addIfNotNull('voice_instructions', voiceInstructions)
          ..addIfNotNull(
            'exclude_polygons',
            excludePolygones != null
                ? convertNestedLngLatToList(excludePolygones!)
                : null,
          )
          ..addIfNotNull('exclude_locations', excludeLocations?.toWaypoints());

    return mapHeader;
  }
}

// Function to convert nested List<LngLat> to nested List<List<double>>
List<dynamic> convertNestedLngLatToList(List<dynamic> nestedList) {
  if (nestedList.isEmpty) {
    return [];
  }
  return nestedList.map((element) {
    if (element is List) {
      return convertNestedLngLatToList(element);
    } else if (element is LngLat) {
      return element.toMap();
    }
    return element;
  }).toList();
}
