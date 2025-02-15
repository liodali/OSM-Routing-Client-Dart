import 'package:test/test.dart';
import 'package:routing_client_dart/routing_client_dart.dart';
import 'package:routing_client_dart/src/models/valhalla/costing.dart';
import 'package:routing_client_dart/src/models/valhalla/costing_option.dart';
import 'package:routing_client_dart/src/utilities/valhalla_utilities.dart';

void main() {
  test('test assert empty waypoints in valhalla header', () {
    expect(
      () => ValhallaRequest(waypoints: []),
      throwsA(isA<AssertionError>()),
    );
    expect(
      () =>
          ValhallaRequest(waypoints: [LngLat(lng: -73.991379, lat: 40.730930)]),
      throwsA(isA<AssertionError>()),
    );
    expect(
      () => ValhallaRequest(
        waypoints: [
          LngLat(lng: -73.991379, lat: 40.730930),
          LngLat(lng: -73.991379, lat: 40.730930),
          LngLat(lng: -73.991379, lat: 40.730930),
        ],
      ),
      throwsA(isA<AssertionError>()),
    );
  });
  test('test valhalla header', () {
    final header = ValhallaRequest(
      waypoints: [
        LngLat(lng: -73.991379, lat: 40.730930),
        LngLat(lng: -73.991562, lat: 40.749706),
      ],
    );
    expect(header.encodeHeader(), {
      'locations': [
        {'lat': 40.730930, 'lon': -73.991379, 'type': 'break'},
        {'lat': 40.749706, 'lon': -73.991562, 'type': 'break'},
      ],
      'costing': 'auto',
      'units': 'km',
      'language': 'en-US',
      'directions_type': 'instructions',
      'format': 'json',
      'alternates': 2,
      'exclude_polygons': [],
    });
  });
  test('test valhalla header3', () {
    final header = ValhallaRequest(
      id: 'valhalla_directions',
      waypoints: [
        LngLat(lng: 8.239853382110597, lat: 50.00949382441468),
        LngLat(lng: 8.24029862880707, lat: 50.00832510754319),
      ],
      costing: Costing.pedestrian,
      costingOption: PedestrianCostingOption(
        servicePenalty: 15,
        useFerry: 1,
        useTracks: 0,
        serviceFactor: 1,
        useLivingStreets: 0.5,
        maxHikingDifficulty: 1,
        maxDistance: null,
        shortest: true,
        transitStartEndMaxDistance: 2145,
        transitTransferMaxDistance: 800,
      ),
      excludePolygones: [],
      languages: Languages.de,
      units: ValhallaUnit.km,
      alternatives: 1,
      valhallaFormat: ValhallaFormat.json,
      directionsType: ValhallaDirectionsType.instructions,
    );
    expect(header.encodeHeader(), _encodedReques1);
  });
}

final _encodedReques1 = {
  "locations": [
    {"lon": 8.239853382110597, "lat": 50.00949382441468, "type": "break"},
    {"lon": 8.24029862880707, "lat": 50.00832510754319, "type": "break"},
  ],
  "costing": "pedestrian",
  "costing_options": {
    "pedestrian": {
      "use_ferry": 1,
      "use_living_streets": 0.5,
      "use_tracks": 0,
      "service_penalty": 15,
      "service_factor": 1,
      "shortest": true,
      "use_hills": 0.5,
      "walking_speed": 5.1,
      "walkway_factor": 1,
      "sidewalk_factor": 1,
      "alley_factor": 2,
      "driveway_factor": 5,
      "step_penalty": 0,
      "max_hiking_difficulty": 1,
      "use_lit": 0,
      "transit_start_end_max_distance": 2145,
      "transit_transfer_max_distance": 800,
    },
  },
  "exclude_polygons": [],
  "units": "km",
  "alternates": 1,
  "directions_type": "instructions",
  "id": "valhalla_directions",
  "format": "json",
  "language": "de-DE",
};
