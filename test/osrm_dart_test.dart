import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:routing_client_dart/src/models/lng_lat.dart';
import 'package:routing_client_dart/src/models/osrm/osrm_mixin.dart';
import 'package:routing_client_dart/src/models/osrm/road.dart';
import 'package:routing_client_dart/src/models/osrm/road_helper.dart';
import 'package:routing_client_dart/src/models/request_helper.dart';
import 'package:routing_client_dart/src/routes_services/osrm_service.dart';
import 'package:routing_client_dart/src/routing_manager.dart';
import 'package:routing_client_dart/src/utilities/computes_utilities.dart';
import 'package:routing_client_dart/src/utilities/utils.dart';
import 'package:test/test.dart';

import 'response_data_osrm.dart';

class FakeOSRMMixin with OSRMHelper {}

class FakeOSRMMService extends OSRMRoutingService {
  @override
  Map<String, dynamic> loadInstructionHelperJson({
    Languages language = Languages.en,
  }) => en;
}

void main() {
  group('test translation', () {
    test('test translation en', () async {
      final osrmHelper = FakeOSRMMixin();
      final instructionHelper = osrmHelper.loadInstructionHelperJson();
      expect(instructionHelper.isNotEmpty, true);
    });
    test('test translation ar', () async {
      final osrmHelper = FakeOSRMMixin();
      final instructionHelper = osrmHelper.loadInstructionHelperJson(
        language: Languages.ar,
      );
      expect(instructionHelper.isNotEmpty, true);
    });
    test('test translation es', () async {
      final osrmHelper = FakeOSRMMixin();
      final instructionHelper = osrmHelper.loadInstructionHelperJson(
        language: Languages.es,
      );
      expect(instructionHelper.isNotEmpty, true);
    });
    test('test translation de', () async {
      final osrmHelper = FakeOSRMMixin();
      final instructionHelper = osrmHelper.loadInstructionHelperJson(
        language: Languages.de,
      );
      expect(instructionHelper.isNotEmpty, true);
    });
  });

  group('test orsm manager', () {
    late RoutingManager manager;
    late DioAdapter dioAdapter;
    setUpAll(() async {
      manager = RoutingManager();
      dioAdapter = DioAdapter(dio: manager.osrmClient.dio);
    });
    test("transform waypoint to string", () {
      List<LngLat> waypoints = [
        LngLat(lng: 13.388860, lat: 52.517037),
        LngLat(lng: 13.397634, lat: 52.529407),
        LngLat(lng: 13.428555, lat: 52.523219),
      ];
      expect(
        waypoints.toWaypoints(),
        "13.38886,52.517037;13.397634,52.529407;13.428555,52.523219",
      );
    });
    test("test generate URL", () {
      List<LngLat> waypoints = [
        LngLat(lng: 13.388860, lat: 52.517037),
        LngLat(lng: 13.397634, lat: 52.529407),
        LngLat(lng: 13.428555, lat: 52.523219),
      ];
      String strWaypoint =
          "13.38886,52.517037;13.397634,52.529407;13.428555,52.523219";
      final urlGenerated =
          '$oSRMServer${OSRMRequest.route(
            //oSRMServer,
            waypoints: waypoints,
            geometries: Geometries.polyline,
            steps: true,
            alternatives: null,
          ).encodeHeader()}';
      String shouldBrUrl =
          "$oSRMServer/routed-car/route/v1/driving/$strWaypoint?steps=true&overview=full&geometries=polyline";
      expect(urlGenerated, shouldBrUrl);
    });
    test("test generate URL Route-bike", () {
      List<LngLat> waypoints = [
        LngLat(lng: 13.388860, lat: 52.517037),
        LngLat(lng: 13.397634, lat: 52.529407),
        LngLat(lng: 13.428555, lat: 52.523219),
      ];
      String strWaypoint =
          "13.38886,52.517037;13.397634,52.529407;13.428555,52.523219";

      final urlGenerated =
          '$oSRMServer${OSRMRequest.route(waypoints: waypoints, routingType: RoutingType.bike, geometries: Geometries.polyline, steps: true, alternatives: null).encodeHeader()}';
      String shouldBrUrl =
          "$oSRMServer/routed-bike/route/v1/driving/$strWaypoint?steps=true&overview=full&geometries=polyline";
      expect(urlGenerated, shouldBrUrl);
    });
    test("test get road ", () async {
      List<LngLat> waypoints = [
        LngLat(lng: 13.388860, lat: 52.517037),
        LngLat(lng: 13.397634, lat: 52.529407),
        LngLat(lng: 13.428555, lat: 52.523219),
      ];
      dioAdapter.onGet(
        "https://routing.openstreetmap.de/routed-car/route/v1/driving/13.38886,52.517037;13.397634,52.529407;13.428555,52.523219?steps=true&overview=full&geometries=polyline&alternatives=false",
        (server) => server.reply(200, response),
      );
      final road = await manager.getRoute(
        request: OSRMRequest.route(
          waypoints: waypoints,
          geometries: Geometries.polyline,
          steps: true,
          languages: Languages.en,
        ),
      );

      expect(road.distance.toStringAsFixed(2), 4.7338.toStringAsFixed(2));
      expect(road.duration >= 615.0, true);
      expect(road.polylineEncoded != null, true);
      expect(road.polyline?.isNotEmpty, true);
    });
    test("test get road without steps", () async {
      List<LngLat> waypoints = [
        LngLat(lng: 13.388860, lat: 52.517037),
        LngLat(lng: 13.397634, lat: 52.529407),
        LngLat(lng: 13.428555, lat: 52.523219),
      ];
      dioAdapter.onGet(
        "https://routing.openstreetmap.de/routed-car/route/v1/driving/13.38886,52.517037;13.397634,52.529407;13.428555,52.523219?steps=false&overview=full&geometries=polyline&alternatives=false",
        (server) => server.reply(200, responseWithoutSteps),
      );
      final road = await manager.getRoute(
        request: OSRMRequest.route(
          waypoints: waypoints,
          geometries: Geometries.polyline,
          steps: false,
          languages: Languages.en,
        ),
      );
      expect(
        (road as OSRMRoad).roadLegs
            .where((element) => element.steps.isNotEmpty)
            .isEmpty,
        true,
      );
    });

    test("test get road without overview geometry", () async {
      List<LngLat> waypoints = [
        LngLat(lng: 13.388860, lat: 52.517037),
        LngLat(lng: 13.397634, lat: 52.529407),
        LngLat(lng: 13.428555, lat: 52.523219),
      ];
      dioAdapter.onGet(
        "https://routing.openstreetmap.de/routed-car/route/v1/driving/13.38886,52.517037;13.397634,52.529407;13.428555,52.523219?steps=true&overview=false&geometries=polyline&alternatives=false",
        (server) => server.reply(200, responseWithoutGeometry),
      );
      final road = await manager.getRoute(
        request: OSRMRequest.route(
          waypoints: waypoints,
          geometries: Geometries.polyline,
          steps: true,
          languages: Languages.en,
          overview: Overview.none,
        ),
      );

      expect(road.distance.toStringAsFixed(2), 4.7338.toStringAsFixed(2));
      expect(road.duration >= 615.0, true);
      expect(road.polyline, []);
      expect(road.polylineEncoded, null);
    });
    test("test if polyline not null when geometry is geojson", () async {
      List<LngLat> waypoints = [
        LngLat(lng: 13.388860, lat: 52.517037),
        LngLat(lng: 13.397634, lat: 52.529407),
        LngLat(lng: 13.428555, lat: 52.523219),
      ];
      dioAdapter.onGet(
        "https://routing.openstreetmap.de/routed-car/route/v1/driving/13.38886,52.517037;13.397634,52.529407;13.428555,52.523219?steps=false&overview=full&geometries=geojson&alternatives=false",
        (server) => server.reply(200, responseGeoJson),
      );
      final road = await manager.getRoute(
        request: OSRMRequest.route(
          waypoints: waypoints,
          geometries: Geometries.geojson,
          steps: false,
          languages: Languages.en,
        ),
      );
      expect(road.polyline != null, true);
      expect(road.polyline!.isNotEmpty, true);
    });

    /// distance 7982.2 , duration 945.6
    test("test get trip", () async {
      List<LngLat> waypoints = [
        LngLat(lng: 13.388860, lat: 52.517037),
        LngLat(lng: 13.397634, lat: 52.529407),
        LngLat(lng: 13.428555, lat: 52.523219),
      ];
      dioAdapter.onGet(
        "https://routing.openstreetmap.de/routed-car/trip/v1/driving/13.38886,52.517037;13.397634,52.529407;13.428555,52.523219?steps=false&overview=full&geometries=polyline&source=first&destination=last&roundtrip=true",
        (server) => server.reply(200, responseTrip),
      );
      final road = await manager.getRoute(
        request: OSRMRequest.trip(
          waypoints: waypoints,
          destination: DestinationGeoPointOption.last,
          source: SourceGeoPointOption.first,
          geometries: Geometries.polyline,
          steps: false,
          languages: Languages.en,
        ),
      );
      expect(road.distance >= 7.9822, true);
      expect(road.duration >= 945.6, true);
      expect(road.polylineEncoded != null, true);
    });
    test("test get trip without overview geometry", () async {
      List<LngLat> waypoints = [
        LngLat(lng: 13.388860, lat: 52.517037),
        LngLat(lng: 13.397634, lat: 52.529407),
        LngLat(lng: 13.428555, lat: 52.523219),
      ];
      dioAdapter.onGet(
        "https://routing.openstreetmap.de/routed-car/trip/v1/driving/13.38886,52.517037;13.397634,52.529407;13.428555,52.523219?steps=false&overview=false&geometries=polyline&source=first&destination=last&roundtrip=true",
        (server) => server.reply(200, responseTripWithoutGeometry),
      );
      final road = await manager.getRoute(
        request: OSRMRequest.trip(
          waypoints: waypoints,
          destination: DestinationGeoPointOption.last,
          source: SourceGeoPointOption.first,
          geometries: Geometries.polyline,
          steps: false,
          languages: Languages.en,
          overview: Overview.none,
        ),
      );
      expect(road.distance >= 7.9822, true);
      expect(road.duration >= 945.6, true);
      expect(road.polyline, []);
      expect(road.polylineEncoded, null);
    });
  });
  test("test parser", () async {
    final responseApi = {
      "code": "Ok",
      "waypoints": [
        {
          "hint":
              "GTPviIxQ4IAYAAAABQAAAAAAAAAgAAAASjFaQdLNK0AAAAAAsPePQQwAAAADAAAAAAAAABAAAAAi5QAA_kvMAKlYIQM8TMwArVghAwAA7wo6xQgq",
          "distance": 4.231666,
          "location": [13.388798, 52.517033],
          "name": "Friedrichstraße",
        },
        {
          "hint":
              "T88igL3b-IgGAAAACgAAAAAAAAB2AAAAW7-PQOKcyEAAAAAApq6DQgYAAAAKAAAAAAAAAHYAAAAi5QAAf27MABiJIQOCbswA_4ghAwAAXwU6xQgq",
          "distance": 2.789393,
          "location": [13.397631, 52.529432],
          "name": "Torstraße",
        },
        {
          "hint":
              "bswigP___38fAAAAUQAAACYAAAAeAAAAsowKQkpQX0Lx6yZCvsQGQh8AAABRAAAAJgAAAB4AAAAi5QAASufMAOdwIQNL58wA03AhAwMAvxA6xQgq",
          "distance": 2.226595,
          "location": [13.428554, 52.523239],
          "name": "Platz der Vereinten Nationen",
        },
      ],
      "routes": [
        {
          "legs": [
            {
              "steps": [
                {
                  "intersections": [
                    {
                      "out": 0,
                      "entry": [true],
                      "location": [13.388798, 52.517033],
                      "bearings": [355],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, false, false, true],
                      "location": [13.388779, 52.517155],
                      "bearings": [0, 90, 180, 270],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false, true],
                      "location": [13.388643, 52.518027],
                      "bearings": [0, 90, 180, 270],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false, true, false],
                      "location": [13.388544, 52.518716],
                      "bearings": [30, 90, 180, 270, 315],
                    },
                    {
                      "out": 0,
                      "in": 1,
                      "entry": [true, false, true],
                      "location": [13.388308, 52.520336],
                      "bearings": [0, 180, 270],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false, true],
                      "location": [13.388024, 52.52175],
                      "bearings": [0, 60, 180, 225],
                    },
                    {
                      "out": 0,
                      "in": 1,
                      "entry": [true, false, true],
                      "location": [13.387885, 52.522524],
                      "bearings": [0, 180, 225],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false],
                      "location": [13.387799, 52.523401],
                      "bearings": [0, 90, 180],
                    },
                    {
                      "out": 0,
                      "in": 1,
                      "lanes": [
                        {
                          "valid": false,
                          "indications": ["none"],
                        },
                        {
                          "valid": false,
                          "indications": ["left"],
                        },
                        {
                          "valid": true,
                          "indications": ["straight"],
                        },
                      ],
                      "entry": [true, false, true],
                      "location": [13.387748, 52.523877],
                      "bearings": [0, 180, 270],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false],
                      "location": [13.3877, 52.524433],
                      "bearings": [0, 90, 180],
                    },
                    {
                      "out": 3,
                      "in": 1,
                      "entry": [true, false, false, true],
                      "location": [13.387337, 52.526239],
                      "bearings": [105, 165, 300, 345],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, false, false, false],
                      "location": [13.387283, 52.526386],
                      "bearings": [0, 105, 165, 255],
                    },
                  ],
                  "driving_side": "right",
                  "geometry":
                      "mfp_I__vpAYBO@K@[BuBRgBLK@UBMMC?AAKAe@FyBTC@E?IDKDA@K@]BUBSBA?E@E@A@KFUBK@mAL{CZQ@qBRUBmAFc@@}@Fu@DG?a@B[@qAF_AJ[D_E`@SBO@ODA@UDA?]JC?uBNE?OAKA",
                  "duration": 129.2,
                  "distance": 1135.7,
                  "name": "Friedrichstraße",
                  "weight": 130.4,
                  "mode": "driving",
                  "maneuver": {
                    "bearing_after": 355,
                    "bearing_before": 0,
                    "type": "depart",
                    "location": [13.388798, 52.517033],
                  },
                },
                {
                  "intersections": [
                    {
                      "out": 0,
                      "in": 1,
                      "entry": [true, false, true, true],
                      "location": [13.387215, 52.527166],
                      "bearings": [75, 180, 255, 330],
                    },
                    {
                      "out": 0,
                      "in": 1,
                      "entry": [true, false, true],
                      "location": [13.389147, 52.527549],
                      "bearings": [75, 255, 345],
                    },
                    {
                      "out": 0,
                      "in": 1,
                      "entry": [true, false, true],
                      "location": [13.391396, 52.528032],
                      "bearings": [75, 255, 330],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false],
                      "location": [13.392425, 52.528233],
                      "bearings": [75, 165, 255],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false, true],
                      "location": [13.393814, 52.528526],
                      "bearings": [75, 135, 255, 315],
                    },
                    {
                      "out": 0,
                      "in": 1,
                      "entry": [true, false, true],
                      "location": [13.395724, 52.528996],
                      "bearings": [75, 255, 345],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false, true],
                      "location": [13.397565, 52.529429],
                      "bearings": [90, 180, 255, 345],
                    },
                  ],
                  "driving_side": "right",
                  "geometry":
                      "yer_IcuupACa@AI]mCCUE[AK[iCWqB[{Bk@sE_@_DAICSAOIm@AIQuACOQyAG[Gc@]wBw@aFKu@y@oFCMAOIm@?K",
                  "duration": 122.3,
                  "distance": 749,
                  "name": "Torstraße",
                  "weight": 122.3,
                  "mode": "driving",
                  "maneuver": {
                    "bearing_after": 71,
                    "location": [13.387215, 52.527166],
                    "type": "turn",
                    "bearing_before": 4,
                    "modifier": "right",
                  },
                },
                {
                  "intersections": [
                    {
                      "in": 0,
                      "entry": [true],
                      "location": [13.397631, 52.529432],
                      "bearings": [266],
                    },
                  ],
                  "driving_side": "right",
                  "geometry": "}sr_IevwpA",
                  "duration": 0,
                  "distance": 0,
                  "name": "Torstraße",
                  "weight": 0,
                  "mode": "driving",
                  "maneuver": {
                    "bearing_after": 0,
                    "bearing_before": 86,
                    "type": "arrive",
                    "location": [13.397631, 52.529432],
                  },
                },
              ],
              "weight": 252.7,
              "distance": 1884.7,
              "summary": "Friedrichstraße, Torstraße",
              "duration": 251.5,
            },
            {
              "steps": [
                {
                  "intersections": [
                    {
                      "out": 0,
                      "entry": [true],
                      "location": [13.397631, 52.529432],
                      "bearings": [85],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "lanes": [
                        {
                          "valid": true,
                          "indications": ["left"],
                        },
                        {
                          "valid": true,
                          "indications": ["straight"],
                        },
                        {
                          "valid": true,
                          "indications": ["straight", "right"],
                        },
                      ],
                      "entry": [true, true, false, false],
                      "location": [13.401337, 52.529605],
                      "bearings": [90, 165, 270, 345],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, false, true],
                      "location": [13.401541, 52.529618],
                      "bearings": [90, 165, 285],
                    },
                    {
                      "out": 1,
                      "in": 3,
                      "lanes": [
                        {
                          "valid": false,
                          "indications": ["left"],
                        },
                        {
                          "valid": true,
                          "indications": ["straight"],
                        },
                        {
                          "valid": true,
                          "indications": ["straight", "right"],
                        },
                      ],
                      "entry": [true, true, true, false],
                      "location": [13.409405, 52.528711],
                      "bearings": [30, 105, 210, 285],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "lanes": [
                        {
                          "valid": true,
                          "indications": ["straight"],
                        },
                        {
                          "valid": true,
                          "indications": ["straight", "right"],
                        },
                      ],
                      "entry": [true, true, false],
                      "location": [13.409967, 52.528591],
                      "bearings": [105, 165, 285],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "lanes": [
                        {
                          "valid": true,
                          "indications": ["straight"],
                        },
                        {
                          "valid": true,
                          "indications": ["straight", "right"],
                        },
                      ],
                      "entry": [true, false, false, false],
                      "location": [13.410145, 52.528553],
                      "bearings": [105, 150, 285, 330],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false],
                      "location": [13.411852, 52.528201],
                      "bearings": [120, 210, 285],
                    },
                  ],
                  "driving_side": "right",
                  "geometry":
                      "}sr_IevwpAAQ?KIuDQmHE}BBQ?Q?OCq@?I?IASAg@OuF?OAi@?c@@c@Du@r@cH@U@I@G@K?E~@kJRyBf@uE@KFi@RaBBMFc@Da@@ETaC@QJ{@Ny@Ha@RiAfBuJF]DOh@yAHSf@aADIR_@",
                  "duration": 202.6,
                  "distance": 1272.3,
                  "name": "Torstraße",
                  "weight": 202.6,
                  "mode": "driving",
                  "maneuver": {
                    "bearing_after": 85,
                    "bearing_before": 0,
                    "type": "depart",
                    "location": [13.397631, 52.529432],
                  },
                },
                {
                  "intersections": [
                    {
                      "out": 1,
                      "in": 3,
                      "lanes": [
                        {
                          "valid": false,
                          "indications": ["left"],
                        },
                        {
                          "valid": false,
                          "indications": ["left"],
                        },
                        {
                          "valid": false,
                          "indications": ["straight"],
                        },
                        {
                          "valid": true,
                          "indications": ["straight"],
                        },
                        {
                          "valid": true,
                          "indications": ["straight", "right"],
                        },
                      ],
                      "entry": [false, true, true, false],
                      "location": [13.415405, 52.526922],
                      "bearings": [30, 135, 210, 315],
                    },
                    {
                      "out": 0,
                      "in": 3,
                      "lanes": [
                        {
                          "valid": true,
                          "indications": ["left"],
                        },
                        {
                          "valid": true,
                          "indications": ["left"],
                        },
                        {
                          "valid": false,
                          "indications": ["straight"],
                        },
                        {
                          "valid": false,
                          "indications": ["straight"],
                        },
                        {
                          "valid": false,
                          "indications": ["straight"],
                        },
                      ],
                      "entry": [true, true, false, false],
                      "location": [13.415657, 52.52677],
                      "bearings": [30, 135, 210, 315],
                    },
                  ],
                  "driving_side": "right",
                  "geometry": "gdr_Iie{pA\\q@w@y@",
                  "duration": 12,
                  "distance": 60.5,
                  "name": "",
                  "weight": 12,
                  "mode": "driving",
                  "maneuver": {
                    "bearing_after": 133,
                    "location": [13.415405, 52.526922],
                    "type": "turn",
                    "bearing_before": 133,
                    "modifier": "left",
                  },
                },
                {
                  "intersections": [
                    {
                      "out": 0,
                      "in": 2,
                      "lanes": [
                        {
                          "valid": false,
                          "indications": ["left"],
                        },
                        {
                          "valid": true,
                          "indications": ["straight"],
                        },
                        {
                          "valid": true,
                          "indications": ["straight"],
                        },
                      ],
                      "entry": [true, false, false, true],
                      "location": [13.415945, 52.527047],
                      "bearings": [30, 120, 210, 315],
                    },
                  ],
                  "driving_side": "right",
                  "geometry": "aer_Iuh{pAe@a@CCUQaCkB{@y@GESO",
                  "duration": 18.2,
                  "distance": 177.4,
                  "name": "Prenzlauer Allee",
                  "weight": 18.2,
                  "mode": "driving",
                  "maneuver": {
                    "bearing_after": 26,
                    "location": [13.415945, 52.527047],
                    "type": "new name",
                    "bearing_before": 30,
                    "modifier": "straight",
                  },
                },
                {
                  "intersections": [
                    {
                      "out": 1,
                      "in": 2,
                      "entry": [true, true, false, false],
                      "location": [13.417166, 52.528458],
                      "bearings": [30, 90, 210, 315],
                    },
                    {
                      "out": 1,
                      "in": 3,
                      "entry": [false, true, true, false],
                      "location": [13.423592, 52.528206],
                      "bearings": [45, 120, 225, 285],
                    },
                    {
                      "out": 1,
                      "in": 3,
                      "entry": [true, true, false, false],
                      "location": [13.423868, 52.528136],
                      "bearings": [45, 120, 210, 300],
                    },
                  ],
                  "driving_side": "right",
                  "geometry":
                      "{mr_Iip{pA?_@?C?[IoCIgDMsEAYOkEAQ@Yj@kENg@ZyBBIHm@FY@GBUJk@JmA?c@?QAQG]",
                  "duration": 55,
                  "distance": 547.1,
                  "name": "Prenzlauer Berg",
                  "weight": 55,
                  "mode": "driving",
                  "maneuver": {
                    "bearing_after": 85,
                    "location": [13.417166, 52.528458],
                    "type": "turn",
                    "bearing_before": 28,
                    "modifier": "right",
                  },
                },
                {
                  "intersections": [
                    {
                      "out": 1,
                      "in": 2,
                      "entry": [true, true, false, true],
                      "location": [13.424993, 52.528068],
                      "bearings": [60, 150, 255, 345],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false],
                      "location": [13.425842, 52.527621],
                      "bearings": [120, 225, 300],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false],
                      "location": [13.428041, 52.526565],
                      "bearings": [135, 225, 315],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false],
                      "location": [13.429315, 52.525737],
                      "bearings": [135, 225, 315],
                    },
                  ],
                  "driving_side": "right",
                  "geometry":
                      "mkr_Iea}pALKDEDCHOL]FO^uA@GTu@La@`A_DJ[pAgCJSlAwBJSf@{@b@w@dAqBHQZq@LMLKRI",
                  "duration": 47.9,
                  "distance": 509.2,
                  "name": "Friedenstraße",
                  "weight": 47.9,
                  "mode": "driving",
                  "maneuver": {
                    "bearing_after": 153,
                    "location": [13.424993, 52.528068],
                    "type": "turn",
                    "bearing_before": 67,
                    "modifier": "right",
                  },
                },
                {
                  "intersections": [
                    {
                      "out": 1,
                      "in": 2,
                      "entry": [true, true, false],
                      "location": [13.430405, 52.524964],
                      "bearings": [135, 180, 345],
                    },
                  ],
                  "driving_side": "right",
                  "geometry":
                      "_xq_Iac~pAFAL?J@HBFBp@XPHh@TTJNFTRNFd@N\\HF@J@J@",
                  "duration": 20.9,
                  "distance": 196.4,
                  "name": "Platz der Vereinten Nationen",
                  "weight": 20.9,
                  "mode": "driving",
                  "maneuver": {
                    "bearing_after": 174,
                    "location": [13.430405, 52.524964],
                    "type": "new name",
                    "bearing_before": 163,
                    "modifier": "straight",
                  },
                },
                {
                  "intersections": [
                    {
                      "out": 3,
                      "in": 0,
                      "lanes": [
                        {
                          "valid": false,
                          "indications": ["left"],
                        },
                        {
                          "valid": false,
                          "indications": ["straight", "left"],
                        },
                        {
                          "valid": false,
                          "indications": ["straight"],
                        },
                        {
                          "valid": true,
                          "indications": ["straight", "right"],
                        },
                      ],
                      "entry": [false, false, true, true],
                      "location": [13.429678, 52.523269],
                      "bearings": [0, 90, 180, 270],
                    },
                  ],
                  "driving_side": "right",
                  "geometry": "mmq_Io~}pA@V?N@rA@dB",
                  "duration": 6.9,
                  "distance": 76.1,
                  "name": "Platz der Vereinten Nationen",
                  "weight": 6.9,
                  "mode": "driving",
                  "maneuver": {
                    "bearing_after": 267,
                    "location": [13.429678, 52.523269],
                    "type": "continue",
                    "bearing_before": 184,
                    "modifier": "right",
                  },
                },
                {
                  "intersections": [
                    {
                      "in": 0,
                      "entry": [true],
                      "location": [13.428554, 52.523239],
                      "bearings": [88],
                    },
                  ],
                  "driving_side": "right",
                  "geometry": "gmq_Imw}pA",
                  "duration": 0,
                  "distance": 0,
                  "name": "Platz der Vereinten Nationen",
                  "weight": 0,
                  "mode": "driving",
                  "maneuver": {
                    "bearing_after": 0,
                    "bearing_before": 268,
                    "type": "arrive",
                    "location": [13.428554, 52.523239],
                  },
                },
              ],
              "weight": 363.5,
              "distance": 2839.1,
              "summary": "Torstraße, Friedenstraße",
              "duration": 363.5,
            },
          ],
          "weight_name": "routability",
          "geometry":
              "mfp_I__vpAYBO@K@[BuBRgBLK@UBMMC?AAKAe@FyBTC@E?IDKDA@K@]BUBSBA?E@E@A@KFUBK@mAL{CZQ@qBRUBmAFc@@}@Fu@DG?a@B[@qAF_AJ[D_E`@SBO@ODA@UDA?]JC?uBNE?OAKACa@AI]mCCUE[AK[iCWqB[{Bk@sE_@_DAICSAOIm@AIQuACOQyAG[Gc@]wBw@aFKu@y@oFCMAOIm@?KAQ?KIuDQmHE}BBQ?Q?OCq@?I?IASAg@OuF?OAi@?c@@c@Du@r@cH@U@I@G@K?E~@kJRyBf@uE@KFi@RaBBMFc@Da@@ETaC@QJ{@Ny@Ha@RiAfBuJF]DOh@yAHSf@aADIR_@\\q@w@y@e@a@CCUQaCkB{@y@GESO?_@?C?[IoCIgDMsEAYOkEAQ@Yj@kENg@ZyBBIHm@FY@GBUJk@JmA?c@?QAQG]LKDEDCHOL]FO^uA@GTu@La@`A_DJ[pAgCJSlAwBJSf@{@b@w@dAqBHQZq@LMLKRIFAL?J@HBFBp@XPHh@TTJNFTRNFd@N\\HF@J@J@@V?N@rA@dB",
          "weight": 616.2,
          "distance": 4723.8,
          "duration": 615.0,
        },
      ],
    };
    OSRMRoad road = await parseRoad(
      ParserRoadComputeArg(json: responseApi, langCode: "en"),
    );
    expect(road.distance, 4.7238);
    expect(road.duration, 615.0);
  });
  test("test parser without overview geometry", () async {
    final responseApi = {
      "code": "Ok",
      "waypoints": [
        {
          "hint":
              "GTPviIxQ4IAYAAAABQAAAAAAAAAgAAAASjFaQdLNK0AAAAAAsPePQQwAAAADAAAAAAAAABAAAAAi5QAA_kvMAKlYIQM8TMwArVghAwAA7wo6xQgq",
          "distance": 4.231666,
          "location": [13.388798, 52.517033],
          "name": "Friedrichstraße",
        },
        {
          "hint":
              "T88igL3b-IgGAAAACgAAAAAAAAB2AAAAW7-PQOKcyEAAAAAApq6DQgYAAAAKAAAAAAAAAHYAAAAi5QAAf27MABiJIQOCbswA_4ghAwAAXwU6xQgq",
          "distance": 2.789393,
          "location": [13.397631, 52.529432],
          "name": "Torstraße",
        },
        {
          "hint":
              "bswigP___38fAAAAUQAAACYAAAAeAAAAsowKQkpQX0Lx6yZCvsQGQh8AAABRAAAAJgAAAB4AAAAi5QAASufMAOdwIQNL58wA03AhAwMAvxA6xQgq",
          "distance": 2.226595,
          "location": [13.428554, 52.523239],
          "name": "Platz der Vereinten Nationen",
        },
      ],
      "routes": [
        {
          "legs": [
            {
              "steps": [
                {
                  "intersections": [
                    {
                      "out": 0,
                      "entry": [true],
                      "location": [13.388798, 52.517033],
                      "bearings": [355],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, false, false, true],
                      "location": [13.388779, 52.517155],
                      "bearings": [0, 90, 180, 270],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false, true],
                      "location": [13.388643, 52.518027],
                      "bearings": [0, 90, 180, 270],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false, true, false],
                      "location": [13.388544, 52.518716],
                      "bearings": [30, 90, 180, 270, 315],
                    },
                    {
                      "out": 0,
                      "in": 1,
                      "entry": [true, false, true],
                      "location": [13.388308, 52.520336],
                      "bearings": [0, 180, 270],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false, true],
                      "location": [13.388024, 52.52175],
                      "bearings": [0, 60, 180, 225],
                    },
                    {
                      "out": 0,
                      "in": 1,
                      "entry": [true, false, true],
                      "location": [13.387885, 52.522524],
                      "bearings": [0, 180, 225],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false],
                      "location": [13.387799, 52.523401],
                      "bearings": [0, 90, 180],
                    },
                    {
                      "out": 0,
                      "in": 1,
                      "lanes": [
                        {
                          "valid": false,
                          "indications": ["none"],
                        },
                        {
                          "valid": false,
                          "indications": ["left"],
                        },
                        {
                          "valid": true,
                          "indications": ["straight"],
                        },
                      ],
                      "entry": [true, false, true],
                      "location": [13.387748, 52.523877],
                      "bearings": [0, 180, 270],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false],
                      "location": [13.3877, 52.524433],
                      "bearings": [0, 90, 180],
                    },
                    {
                      "out": 3,
                      "in": 1,
                      "entry": [true, false, false, true],
                      "location": [13.387337, 52.526239],
                      "bearings": [105, 165, 300, 345],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, false, false, false],
                      "location": [13.387283, 52.526386],
                      "bearings": [0, 105, 165, 255],
                    },
                  ],
                  "driving_side": "right",
                  "geometry":
                      "mfp_I__vpAYBO@K@[BuBRgBLK@UBMMC?AAKAe@FyBTC@E?IDKDA@K@]BUBSBA?E@E@A@KFUBK@mAL{CZQ@qBRUBmAFc@@}@Fu@DG?a@B[@qAF_AJ[D_E`@SBO@ODA@UDA?]JC?uBNE?OAKA",
                  "duration": 129.2,
                  "distance": 1135.7,
                  "name": "Friedrichstraße",
                  "weight": 130.4,
                  "mode": "driving",
                  "maneuver": {
                    "bearing_after": 355,
                    "bearing_before": 0,
                    "type": "depart",
                    "location": [13.388798, 52.517033],
                  },
                },
                {
                  "intersections": [
                    {
                      "out": 0,
                      "in": 1,
                      "entry": [true, false, true, true],
                      "location": [13.387215, 52.527166],
                      "bearings": [75, 180, 255, 330],
                    },
                    {
                      "out": 0,
                      "in": 1,
                      "entry": [true, false, true],
                      "location": [13.389147, 52.527549],
                      "bearings": [75, 255, 345],
                    },
                    {
                      "out": 0,
                      "in": 1,
                      "entry": [true, false, true],
                      "location": [13.391396, 52.528032],
                      "bearings": [75, 255, 330],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false],
                      "location": [13.392425, 52.528233],
                      "bearings": [75, 165, 255],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false, true],
                      "location": [13.393814, 52.528526],
                      "bearings": [75, 135, 255, 315],
                    },
                    {
                      "out": 0,
                      "in": 1,
                      "entry": [true, false, true],
                      "location": [13.395724, 52.528996],
                      "bearings": [75, 255, 345],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false, true],
                      "location": [13.397565, 52.529429],
                      "bearings": [90, 180, 255, 345],
                    },
                  ],
                  "driving_side": "right",
                  "geometry":
                      "yer_IcuupACa@AI]mCCUE[AK[iCWqB[{Bk@sE_@_DAICSAOIm@AIQuACOQyAG[Gc@]wBw@aFKu@y@oFCMAOIm@?K",
                  "duration": 122.3,
                  "distance": 749,
                  "name": "Torstraße",
                  "weight": 122.3,
                  "mode": "driving",
                  "maneuver": {
                    "bearing_after": 71,
                    "location": [13.387215, 52.527166],
                    "type": "turn",
                    "bearing_before": 4,
                    "modifier": "right",
                  },
                },
                {
                  "intersections": [
                    {
                      "in": 0,
                      "entry": [true],
                      "location": [13.397631, 52.529432],
                      "bearings": [266],
                    },
                  ],
                  "driving_side": "right",
                  "geometry": "}sr_IevwpA",
                  "duration": 0,
                  "distance": 0,
                  "name": "Torstraße",
                  "weight": 0,
                  "mode": "driving",
                  "maneuver": {
                    "bearing_after": 0,
                    "bearing_before": 86,
                    "type": "arrive",
                    "location": [13.397631, 52.529432],
                  },
                },
              ],
              "weight": 252.7,
              "distance": 1884.7,
              "summary": "Friedrichstraße, Torstraße",
              "duration": 251.5,
            },
            {
              "steps": [
                {
                  "intersections": [
                    {
                      "out": 0,
                      "entry": [true],
                      "location": [13.397631, 52.529432],
                      "bearings": [85],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "lanes": [
                        {
                          "valid": true,
                          "indications": ["left"],
                        },
                        {
                          "valid": true,
                          "indications": ["straight"],
                        },
                        {
                          "valid": true,
                          "indications": ["straight", "right"],
                        },
                      ],
                      "entry": [true, true, false, false],
                      "location": [13.401337, 52.529605],
                      "bearings": [90, 165, 270, 345],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, false, true],
                      "location": [13.401541, 52.529618],
                      "bearings": [90, 165, 285],
                    },
                    {
                      "out": 1,
                      "in": 3,
                      "lanes": [
                        {
                          "valid": false,
                          "indications": ["left"],
                        },
                        {
                          "valid": true,
                          "indications": ["straight"],
                        },
                        {
                          "valid": true,
                          "indications": ["straight", "right"],
                        },
                      ],
                      "entry": [true, true, true, false],
                      "location": [13.409405, 52.528711],
                      "bearings": [30, 105, 210, 285],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "lanes": [
                        {
                          "valid": true,
                          "indications": ["straight"],
                        },
                        {
                          "valid": true,
                          "indications": ["straight", "right"],
                        },
                      ],
                      "entry": [true, true, false],
                      "location": [13.409967, 52.528591],
                      "bearings": [105, 165, 285],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "lanes": [
                        {
                          "valid": true,
                          "indications": ["straight"],
                        },
                        {
                          "valid": true,
                          "indications": ["straight", "right"],
                        },
                      ],
                      "entry": [true, false, false, false],
                      "location": [13.410145, 52.528553],
                      "bearings": [105, 150, 285, 330],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false],
                      "location": [13.411852, 52.528201],
                      "bearings": [120, 210, 285],
                    },
                  ],
                  "driving_side": "right",
                  "geometry":
                      "}sr_IevwpAAQ?KIuDQmHE}BBQ?Q?OCq@?I?IASAg@OuF?OAi@?c@@c@Du@r@cH@U@I@G@K?E~@kJRyBf@uE@KFi@RaBBMFc@Da@@ETaC@QJ{@Ny@Ha@RiAfBuJF]DOh@yAHSf@aADIR_@",
                  "duration": 202.6,
                  "distance": 1272.3,
                  "name": "Torstraße",
                  "weight": 202.6,
                  "mode": "driving",
                  "maneuver": {
                    "bearing_after": 85,
                    "bearing_before": 0,
                    "type": "depart",
                    "location": [13.397631, 52.529432],
                  },
                },
                {
                  "intersections": [
                    {
                      "out": 1,
                      "in": 3,
                      "lanes": [
                        {
                          "valid": false,
                          "indications": ["left"],
                        },
                        {
                          "valid": false,
                          "indications": ["left"],
                        },
                        {
                          "valid": false,
                          "indications": ["straight"],
                        },
                        {
                          "valid": true,
                          "indications": ["straight"],
                        },
                        {
                          "valid": true,
                          "indications": ["straight", "right"],
                        },
                      ],
                      "entry": [false, true, true, false],
                      "location": [13.415405, 52.526922],
                      "bearings": [30, 135, 210, 315],
                    },
                    {
                      "out": 0,
                      "in": 3,
                      "lanes": [
                        {
                          "valid": true,
                          "indications": ["left"],
                        },
                        {
                          "valid": true,
                          "indications": ["left"],
                        },
                        {
                          "valid": false,
                          "indications": ["straight"],
                        },
                        {
                          "valid": false,
                          "indications": ["straight"],
                        },
                        {
                          "valid": false,
                          "indications": ["straight"],
                        },
                      ],
                      "entry": [true, true, false, false],
                      "location": [13.415657, 52.52677],
                      "bearings": [30, 135, 210, 315],
                    },
                  ],
                  "driving_side": "right",
                  "geometry": "gdr_Iie{pA\\q@w@y@",
                  "duration": 12,
                  "distance": 60.5,
                  "name": "",
                  "weight": 12,
                  "mode": "driving",
                  "maneuver": {
                    "bearing_after": 133,
                    "location": [13.415405, 52.526922],
                    "type": "turn",
                    "bearing_before": 133,
                    "modifier": "left",
                  },
                },
                {
                  "intersections": [
                    {
                      "out": 0,
                      "in": 2,
                      "lanes": [
                        {
                          "valid": false,
                          "indications": ["left"],
                        },
                        {
                          "valid": true,
                          "indications": ["straight"],
                        },
                        {
                          "valid": true,
                          "indications": ["straight"],
                        },
                      ],
                      "entry": [true, false, false, true],
                      "location": [13.415945, 52.527047],
                      "bearings": [30, 120, 210, 315],
                    },
                  ],
                  "driving_side": "right",
                  "geometry": "aer_Iuh{pAe@a@CCUQaCkB{@y@GESO",
                  "duration": 18.2,
                  "distance": 177.4,
                  "name": "Prenzlauer Allee",
                  "weight": 18.2,
                  "mode": "driving",
                  "maneuver": {
                    "bearing_after": 26,
                    "location": [13.415945, 52.527047],
                    "type": "new name",
                    "bearing_before": 30,
                    "modifier": "straight",
                  },
                },
                {
                  "intersections": [
                    {
                      "out": 1,
                      "in": 2,
                      "entry": [true, true, false, false],
                      "location": [13.417166, 52.528458],
                      "bearings": [30, 90, 210, 315],
                    },
                    {
                      "out": 1,
                      "in": 3,
                      "entry": [false, true, true, false],
                      "location": [13.423592, 52.528206],
                      "bearings": [45, 120, 225, 285],
                    },
                    {
                      "out": 1,
                      "in": 3,
                      "entry": [true, true, false, false],
                      "location": [13.423868, 52.528136],
                      "bearings": [45, 120, 210, 300],
                    },
                  ],
                  "driving_side": "right",
                  "geometry":
                      "{mr_Iip{pA?_@?C?[IoCIgDMsEAYOkEAQ@Yj@kENg@ZyBBIHm@FY@GBUJk@JmA?c@?QAQG]",
                  "duration": 55,
                  "distance": 547.1,
                  "name": "Prenzlauer Berg",
                  "weight": 55,
                  "mode": "driving",
                  "maneuver": {
                    "bearing_after": 85,
                    "location": [13.417166, 52.528458],
                    "type": "turn",
                    "bearing_before": 28,
                    "modifier": "right",
                  },
                },
                {
                  "intersections": [
                    {
                      "out": 1,
                      "in": 2,
                      "entry": [true, true, false, true],
                      "location": [13.424993, 52.528068],
                      "bearings": [60, 150, 255, 345],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false],
                      "location": [13.425842, 52.527621],
                      "bearings": [120, 225, 300],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false],
                      "location": [13.428041, 52.526565],
                      "bearings": [135, 225, 315],
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false],
                      "location": [13.429315, 52.525737],
                      "bearings": [135, 225, 315],
                    },
                  ],
                  "driving_side": "right",
                  "geometry":
                      "mkr_Iea}pALKDEDCHOL]FO^uA@GTu@La@`A_DJ[pAgCJSlAwBJSf@{@b@w@dAqBHQZq@LMLKRI",
                  "duration": 47.9,
                  "distance": 509.2,
                  "name": "Friedenstraße",
                  "weight": 47.9,
                  "mode": "driving",
                  "maneuver": {
                    "bearing_after": 153,
                    "location": [13.424993, 52.528068],
                    "type": "turn",
                    "bearing_before": 67,
                    "modifier": "right",
                  },
                },
                {
                  "intersections": [
                    {
                      "out": 1,
                      "in": 2,
                      "entry": [true, true, false],
                      "location": [13.430405, 52.524964],
                      "bearings": [135, 180, 345],
                    },
                  ],
                  "driving_side": "right",
                  "geometry":
                      "_xq_Iac~pAFAL?J@HBFBp@XPHh@TTJNFTRNFd@N\\HF@J@J@",
                  "duration": 20.9,
                  "distance": 196.4,
                  "name": "Platz der Vereinten Nationen",
                  "weight": 20.9,
                  "mode": "driving",
                  "maneuver": {
                    "bearing_after": 174,
                    "location": [13.430405, 52.524964],
                    "type": "new name",
                    "bearing_before": 163,
                    "modifier": "straight",
                  },
                },
                {
                  "intersections": [
                    {
                      "out": 3,
                      "in": 0,
                      "lanes": [
                        {
                          "valid": false,
                          "indications": ["left"],
                        },
                        {
                          "valid": false,
                          "indications": ["straight", "left"],
                        },
                        {
                          "valid": false,
                          "indications": ["straight"],
                        },
                        {
                          "valid": true,
                          "indications": ["straight", "right"],
                        },
                      ],
                      "entry": [false, false, true, true],
                      "location": [13.429678, 52.523269],
                      "bearings": [0, 90, 180, 270],
                    },
                  ],
                  "driving_side": "right",
                  "geometry": "mmq_Io~}pA@V?N@rA@dB",
                  "duration": 6.9,
                  "distance": 76.1,
                  "name": "Platz der Vereinten Nationen",
                  "weight": 6.9,
                  "mode": "driving",
                  "maneuver": {
                    "bearing_after": 267,
                    "location": [13.429678, 52.523269],
                    "type": "continue",
                    "bearing_before": 184,
                    "modifier": "right",
                  },
                },
                {
                  "intersections": [
                    {
                      "in": 0,
                      "entry": [true],
                      "location": [13.428554, 52.523239],
                      "bearings": [88],
                    },
                  ],
                  "driving_side": "right",
                  "geometry": "gmq_Imw}pA",
                  "duration": 0,
                  "distance": 0,
                  "name": "Platz der Vereinten Nationen",
                  "weight": 0,
                  "mode": "driving",
                  "maneuver": {
                    "bearing_after": 0,
                    "bearing_before": 268,
                    "type": "arrive",
                    "location": [13.428554, 52.523239],
                  },
                },
              ],
              "weight": 363.5,
              "distance": 2839.1,
              "summary": "Torstraße, Friedenstraße",
              "duration": 363.5,
            },
          ],
          "weight_name": "routability",
          "weight": 616.2,
          "distance": 4723.8,
          "duration": 615.0,
        },
      ],
    };
    OSRMRoad road = await parseRoad(
      ParserRoadComputeArg(json: responseApi, langCode: "en"),
    );
    expect(road.distance, 4.7238);
    expect(road.duration, 615.0);
    expect(road.polyline, []);
    expect(road.polylineEncoded, null);
  });
  test('test RoadStep', () {
    final json = {
      "geometry": "}b~`Hmzur@DPb@_@",
      "maneuver": {
        "bearing_after": 240,
        "bearing_before": 0,
        "location": [8.47287, 47.509114],
        "modifier": "right",
        "type": "depart",
      },
      "mode": "driving",
      "driving_side": "right",
      "name": "",
      "intersections": [
        {
          "out": 0,
          "entry": [true],
          "bearings": [240],
          "location": [8.47287, 47.509114],
        },
      ],
      "weight": 16.9,
      "duration": 9.4,
      "distance": 31.2,
    };
    final roadStep = RoadStep.fromJson(json: json);
    expect(roadStep.maneuver.maneuverType, "depart");
    expect(roadStep.maneuver.modifier, "right");
    expect(roadStep.name, "");
    expect(roadStep.destinations, null);
    expect(roadStep.intersections.first.lanes, null);
  });

  test('test buildInstruction 1', () async {
    final osrmHelper = FakeOSRMMixin();
    final instructionHelper = osrmHelper.loadInstructionHelperJson();
    final json = {
      "geometry": "}b~`Hmzur@DPb@_@",
      "maneuver": {
        "bearing_after": 240,
        "bearing_before": 0,
        "location": [8.47287, 47.509114],
        "modifier": "right",
        "type": "depart",
      },
      "mode": "driving",
      "driving_side": "right",
      "name": "",
      "intersections": [
        {
          "out": 0,
          "entry": [true],
          "bearings": [240],
          "location": [8.47287, 47.509114],
        },
      ],
      "weight": 16.9,
      "duration": 9.4,
      "distance": 31.2,
    };
    final roadStep = RoadStep.fromJson(json: json);

    final instruction = OSRMHelper.buildInstruction(
      roadStep,
      instructionHelper,
      {"legIndex": 0, "legCount": 1},
    );
    expect(instruction, "Head north");
  });
  test('test buildInstruction 2', () async {
    final osrmHelper = FakeOSRMMixin();
    final instructionHelper = osrmHelper.loadInstructionHelperJson();
    final json = {
      "geometry": "mh~`Hgqur@KJUHg@POBM@SCGAIEQOKSEEM]EGMYGOG[",
      "maneuver": {
        "bearing_after": 329,
        "bearing_before": 322,
        "location": [8.471398, 47.509993],
        "modifier": "straight",
        "type": "new name",
      },
      "mode": "driving",
      "driving_side": "right",
      "name": "Binzmühlestrasse",
      "intersections": [
        {
          "out": 2,
          "in": 0,
          "entry": [false, true, true],
          "bearings": [135, 240, 330],
          "location": [8.471398, 47.509993],
        },
        {
          "out": 0,
          "in": 1,
          "entry": [true, false, true],
          "bearings": [30, 195, 300],
          "location": [8.471227, 47.510695],
        },
      ],
      "weight": 14.1,
      "duration": 14.1,
      "distance": 157.6,
    };
    final roadStep = RoadStep.fromJson(json: json);
    final instruction = OSRMHelper.buildInstruction(
      roadStep,
      instructionHelper,
      {"legIndex": 0, "legCount": 1},
    );
    expect(instruction, "Continue onto Binzmühlestrasse");
  });

  test('test isOnPath', () async {
    final roadManager = RoutingManager();
    final road = OSRMRoad.fromOSRMJson(
      route: (responseRandomRoute["routes"]! as List).first,
    );

    final currentLocation = LngLat.fromList(lnglat: [13.389147, 52.527549]);
    final isOnPath = roadManager.isOnPath(
      road,
      currentLocation,
      tolerance: 0.6,
      precision: 5,
    );
    expect(isOnPath, true);
  });

  test('test instruction', () async {
    final roadManager = RoutingManager();
    final road = OSRMRoad.fromOSRMJson(
      route: (responseRandomRoute["routes"]! as List).first,
    );

    final instructions = OSRMHelper.buildInstructions(
      road: road,
      instructionsHelper: en,
    );

    final currentLocation = LngLat.fromList(
      lnglat: [13.389147, 52.527549],
    ).alignWithPrecision(precision: 5);
    final turnByTurnInformation = roadManager.nextInstruction(
      instructions,
      road,
      currentLocation,
      tolerance: 10,
      precision: 5,
    );
    //You have arrived at your {nth} destination, on the right
    print(turnByTurnInformation.toString());
    expect(turnByTurnInformation != null, true);
    expect(
      turnByTurnInformation?.currentInstruction.instruction,
      "Turn right onto Torstraße",
    );
    expect(
      turnByTurnInformation?.nextInstruction?.instruction,
      "You have arrived at your 1st destination",
      //"Head north on Torstraße",
    );
    final distance = currentLocation.distance(
      location: LngLat.fromList(lnglat: [13.39763, 52.529432]),
    );
    expect(turnByTurnInformation?.distance, distance);
  });
  test('set precision to lnglat', () {
    final location = LngLat.fromList(lnglat: [8.26195, 50.009781]);

    final nlocation = location.alignWithPrecision(precision: 5);
    expect(nlocation.lng, 8.26195);
    expect(nlocation.lat, 50.00978);
  });
  test('distance', () {
    final currentLocation = LngLat.fromList(lnglat: [8.26195, 50.009781]);
    final startLoc = LngLat.fromList(lnglat: [8.257762, 50.012695]);
    final stepLoc = LngLat.fromList(lnglat: [8.26193, 50.009907]);
    final dis1 = currentLocation.distance(location: startLoc);
    final dis2 = currentLocation.distance(location: stepLoc);
    print('dis1:$dis1,dis2:$dis2');
    expect(dis2 < dis1, true);
  });
  test('test isOnPath 2', () async {
    final roadManager = RoutingManager();
    final road = OSRMRoad.fromOSRMJson(
      route: (response2ndRoute["routes"]! as List).first,
    );

    final currentLocation = LngLat.fromList(lnglat: [13.389147, 52.527549]);
    final isOnPath = roadManager.isOnPath(road, currentLocation, tolerance: 5);
    expect(isOnPath, false);
  });
  test('test instruction 2', () async {
    final roadManager = RoutingManager();
    final road = OSRMRoad.fromOSRMJson(
      route: (response2ndRoute["routes"]! as List).first,
    );

    final instructions = OSRMHelper.buildInstructions(
      road: road,
      instructionsHelper: en,
    );

    final currentLocation = LngLat.fromList(lnglat: [8.26195, 50.009781]);
    final turnByTurnInformation = roadManager.nextInstruction(
      instructions,
      road,
      currentLocation,
      tolerance: 10,
    );
    //You have arrived at your {nth} destination, on the right
    for (var e in instructions) {
      print('$e\n');
    }

    print(
      '${instructions.first.location},$currentLocation = distance : ${currentLocation.distance(location: instructions.first.location)}',
    );
    print(turnByTurnInformation.toString());
    expect(turnByTurnInformation != null, true);
    expect(
      turnByTurnInformation?.currentInstruction.instruction,
      "Turn right onto Wallaustraße",
    );
    expect(
      turnByTurnInformation?.nextInstruction?.instruction,
      "Make a slight right",
    );
    final distance = currentLocation
    //.alignWithPrecision()
    .distance(location: LngLat.fromList(lnglat: [8.262933, 50.008737]));
    expect(turnByTurnInformation?.distance, distance);
  });
}
