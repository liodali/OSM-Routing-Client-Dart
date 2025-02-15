import 'package:test/test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:routing_client_dart/routing_client_dart.dart';
import 'package:routing_client_dart/src/models/valhalla/costing.dart';
import 'package:routing_client_dart/src/models/valhalla/costing_option.dart';
import 'package:routing_client_dart/src/utilities/valhalla_utilities.dart';

void main() {
  final service = ValhallaRoutingService();
  final dioAdapter = DioAdapter(dio: service.dio);
  test('test simple request', () async {
    final valhallaReq = ValhallaRequest(
      waypoints: [
        LngLat(lng: 8.239853382110597, lat: 50.00949382441468),
        LngLat(lng: 8.24029862880707, lat: 50.00832510754319),
      ],
      alternatives: 1,
      valhallaFormat: ValhallaFormat.json,
      costing: Costing.pedestrian,
      costingOption: PedestrianCostingOption(
        servicePenalty: 15,
        transitStartEndMaxDistance: 2145,
        transitTransferMaxDistance: 800,
      ),
    );
    dioAdapter.onGet(
      'https://valhalla1.openstreetmap.de/route',
      (server) => server.reply(200, _esponseSimple1),
      queryParameters: {'json': valhallaReq.encodeHeader()},
    );
    print(valhallaReq.encodeHeader());
    final response = await service.getValhallaRoad(
      ValhallaRequest(
        waypoints: [
          LngLat(lng: 8.239853382110597, lat: 50.00949382441468),
          LngLat(lng: 8.24029862880707, lat: 50.00832510754319),
        ],
        alternatives: 1,
        valhallaFormat: ValhallaFormat.json,
        costing: Costing.pedestrian,
        costingOption: PedestrianCostingOption(
          servicePenalty: 15,
          transitStartEndMaxDistance: 2145,
          transitTransferMaxDistance: 800,
        ),
      ),
    );
    const encodedPoly =
        'kyik~Akl|uN~F{@pDyB~Aw@tADpCxBvAbBnBx@|@QjAkApAs@r@@lAh@lDlB~@LnAwB^qCT{Ar@}AbDyClIuGbCsA';
    final decodedPoly = encodedPoly.decodeGeometry(precision: 6);
    expect(response.polyline != null, true);
    expect(response.polyline, decodedPoly);
    expect(response.polylineEncoded, decodedPoly.encodeGeometry());
  });
}

final _esponseSimple1 = {
  "trip": {
    "locations": [
      {"type": "break", "lat": 50.009493, "lon": 8.239853, "original_index": 0},
      {"type": "break", "lat": 50.008325, "lon": 8.240298, "original_index": 1},
    ],
    "legs": [
      {
        "maneuvers": [
          {
            "type": 1,
            "instruction": "Walk south.",
            "verbal_succinct_transition_instruction": "Walk south.",
            "verbal_pre_transition_instruction": "Walk south.",
            "verbal_post_transition_instruction": "Continue for 90 meters.",
            "time": 64.941,
            "length": 0.092,
            "cost": 92,
            "begin_shape_index": 0,
            "end_shape_index": 14,
            "rough": true,
            "travel_mode": "pedestrian",
            "travel_type": "foot",
          },
          {
            "type": 15,
            "instruction": "Turn left.",
            "verbal_transition_alert_instruction": "Turn left.",
            "verbal_succinct_transition_instruction": "Turn left.",
            "verbal_pre_transition_instruction": "Turn left.",
            "verbal_post_transition_instruction": "Continue for 60 meters.",
            "time": 41.957,
            "length": 0.06,
            "cost": 60,
            "begin_shape_index": 14,
            "end_shape_index": 21,
            "rough": true,
            "travel_mode": "pedestrian",
            "travel_type": "foot",
          },
          {
            "type": 4,
            "instruction": "You have arrived at your destination.",
            "verbal_transition_alert_instruction":
                "You will arrive at your destination.",
            "verbal_pre_transition_instruction":
                "You have arrived at your destination.",
            "time": 0,
            "length": 0,
            "cost": 0,
            "begin_shape_index": 21,
            "end_shape_index": 21,
            "travel_mode": "pedestrian",
            "travel_type": "foot",
          },
        ],
        "summary": {
          "has_time_restrictions": false,
          "has_toll": false,
          "has_highway": false,
          "has_ferry": false,
          "min_lat": 50.008326,
          "min_lon": 8.239794,
          "max_lat": 50.009509,
          "max_lon": 8.240278,
          "time": 106.898,
          "length": 0.152,
          "cost": 152,
        },
        "shape":
            "kyik~Akl|uN~F{@pDyB~Aw@tADpCxBvAbBnBx@|@QjAkApAs@r@@lAh@lDlB~@LnAwB^qCT{Ar@}AbDyClIuGbCsA",
      },
    ],
    "summary": {
      "has_time_restrictions": false,
      "has_toll": false,
      "has_highway": false,
      "has_ferry": false,
      "min_lat": 50.008326,
      "min_lon": 8.239794,
      "max_lat": 50.009509,
      "max_lon": 8.240278,
      "time": 106.898,
      "length": 0.152,
      "cost": 152,
    },
    "status_message": "Found route between points",
    "status": 0,
    "units": "kilometers",
    "language": "en-US",
  },
  "alternates": [
    {
      "trip": {
        "locations": [
          {
            "type": "break",
            "lat": 50.009493,
            "lon": 8.239853,
            "original_index": 0,
          },
          {
            "type": "break",
            "lat": 50.008325,
            "lon": 8.240298,
            "original_index": 1,
          },
        ],
        "legs": [
          {
            "maneuvers": [
              {
                "type": 1,
                "instruction": "Walk west.",
                "verbal_succinct_transition_instruction": "Walk west.",
                "verbal_pre_transition_instruction": "Walk west.",
                "verbal_post_transition_instruction":
                    "Continue for 100 meters.",
                "time": 98.583,
                "length": 0.148,
                "cost": 148,
                "begin_shape_index": 0,
                "end_shape_index": 10,
                "travel_mode": "pedestrian",
                "travel_type": "foot",
              },
              {
                "type": 15,
                "instruction": "Turn left onto Jakob-Steffan-Straße.",
                "verbal_transition_alert_instruction":
                    "Turn left onto Jakob-Steffan-Straße.",
                "verbal_succinct_transition_instruction": "Turn left.",
                "verbal_pre_transition_instruction":
                    "Turn left onto Jakob-Steffan-Straße.",
                "verbal_post_transition_instruction": "Continue for 40 meters.",
                "street_names": ["Jakob-Steffan-Straße"],
                "time": 31.411,
                "length": 0.039,
                "cost": 39,
                "begin_shape_index": 10,
                "end_shape_index": 17,
                "travel_mode": "pedestrian",
                "travel_type": "foot",
              },
              {
                "type": 15,
                "instruction": "Turn left onto Am Judensand.",
                "verbal_transition_alert_instruction":
                    "Turn left onto Am Judensand.",
                "verbal_succinct_transition_instruction": "Turn left.",
                "verbal_pre_transition_instruction":
                    "Turn left onto Am Judensand.",
                "verbal_post_transition_instruction": "Continue for 50 meters.",
                "street_names": ["Am Judensand"],
                "time": 37.411,
                "length": 0.053,
                "cost": 53,
                "begin_shape_index": 17,
                "end_shape_index": 26,
                "travel_mode": "pedestrian",
                "travel_type": "foot",
              },
              {
                "type": 4,
                "instruction": "You have arrived at your destination.",
                "verbal_transition_alert_instruction":
                    "You will arrive at your destination.",
                "verbal_pre_transition_instruction":
                    "You have arrived at your destination.",
                "time": 0,
                "length": 0,
                "cost": 0,
                "begin_shape_index": 26,
                "end_shape_index": 26,
                "travel_mode": "pedestrian",
                "travel_type": "foot",
              },
            ],
            "summary": {
              "has_time_restrictions": false,
              "has_toll": false,
              "has_highway": false,
              "has_ferry": false,
              "min_lat": 50.008179,
              "min_lon": 8.239272,
              "max_lat": 50.009509,
              "max_lon": 8.240278,
              "time": 167.407,
              "length": 0.24,
              "cost": 240,
            },
            "shape":
                "kyik~Akl|uNz@fCP`Ck@pECfDPzAf@rA`@h@jPpAlP~@~[jBzAcGt@yCl@wB`@IjEq@`@I^Ek@mFqA{JIm@QkAWwBMeAq@iF]qCU}A",
          },
        ],
        "summary": {
          "has_time_restrictions": false,
          "has_toll": false,
          "has_highway": false,
          "has_ferry": false,
          "min_lat": 50.008179,
          "min_lon": 8.239272,
          "max_lat": 50.009509,
          "max_lon": 8.240278,
          "time": 167.407,
          "length": 0.24,
          "cost": 240,
        },
        "status_message": "Found route between points",
        "status": 0,
        "units": "kilometers",
        "language": "en-US",
      },
    },
  ],
  "id": "valhalla_directions",
};
