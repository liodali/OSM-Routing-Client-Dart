import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:routing_client_dart/routing_client_dart.dart';
import 'package:routing_client_dart/src/models/osrm_mixin.dart';
import 'package:routing_client_dart/src/models/road_helper.dart';
import 'package:routing_client_dart/src/osrm_manager.dart';
import 'package:routing_client_dart/src/utilities/computes_utilities.dart';
import 'package:routing_client_dart/src/utilities/utils.dart';

class FakeOSRMMixin with OSRMHelper {}

class FakeOSRMManager extends OSRMManager {
  @override
  Future<Map<String, dynamic>> loadInstructionHelperJson(
      {Languages language = Languages.en}) async {
    return _en;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group('test orsm manager', () {
    late OSRMManager manager;
    late DioAdapter dioAdapter;
    setUpAll(() async {
      manager = FakeOSRMManager();
      dioAdapter = DioAdapter(dio: manager.dio);
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
      String waypoint =
          "13.388860,52.517037;13.397634,52.529407;13.428555,52.523219";
      final urlGenerated = manager.generatePath(
        waypoint,
        geometries: Geometries.polyline,
        steps: true,
      );
      String shouldBrUrl =
          "$oSRMServer/routed-car/route/v1/diving/$waypoint?steps=true&overview=full&geometries=polyline";
      expect(urlGenerated, shouldBrUrl);
    });

    test("test get road ", () async {
      List<LngLat> waypoints = [
        LngLat(lng: 13.388860, lat: 52.517037),
        LngLat(lng: 13.397634, lat: 52.529407),
        LngLat(lng: 13.428555, lat: 52.523219),
      ];
      dioAdapter.onGet(
        "https://routing.openstreetmap.de/routed-car/route/v1/diving/13.38886,52.517037;13.397634,52.529407;13.428555,52.523219?steps=true&overview=full&geometries=polyline&alternatives=false",
        (server) => server.reply(200, _response),
      );
      final road = await manager.getRoad(
        waypoints: waypoints,
        geometries: Geometries.polyline,
        steps: true,
        language: Languages.en,
      );

      expect(road.distance.toStringAsFixed(2), 4.7338.toStringAsFixed(2));
      expect(road.duration >= 615.0, true);
    });
    test("test get road without steps", () async {
      List<LngLat> waypoints = [
        LngLat(lng: 13.388860, lat: 52.517037),
        LngLat(lng: 13.397634, lat: 52.529407),
        LngLat(lng: 13.428555, lat: 52.523219),
      ];
      dioAdapter.onGet(
          "https://routing.openstreetmap.de/routed-car/route/v1/diving/13.38886,52.517037;13.397634,52.529407;13.428555,52.523219?steps=false&overview=full&geometries=polyline&alternatives=false",
          (server) => server.reply(200, _responseWithoutSteps));
      final road = await manager.getRoad(
        waypoints: waypoints,
        geometries: Geometries.polyline,
        steps: false,
        language: Languages.en,
      );
      expect(road.instructions.isEmpty, true);
    });
    test("test if polyline not null when geometry is geojson", () async {
      List<LngLat> waypoints = [
        LngLat(lng: 13.388860, lat: 52.517037),
        LngLat(lng: 13.397634, lat: 52.529407),
        LngLat(lng: 13.428555, lat: 52.523219),
      ];
      dioAdapter.onGet(
        "https://routing.openstreetmap.de/routed-car/route/v1/diving/13.38886,52.517037;13.397634,52.529407;13.428555,52.523219?steps=false&overview=full&geometries=geojson&alternatives=false",
        (server) => server.reply(
          200,
          _responseGeoJson,
        ),
      );
      final road = await manager.getRoad(
        waypoints: waypoints,
        geometries: Geometries.geojson,
        steps: false,
        language: Languages.en,
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
        "https://routing.openstreetmap.de/routed-car/trip/v1/diving/13.38886,52.517037;13.397634,52.529407;13.428555,52.523219?steps=false&overview=full&geometries=polyline&source=first&destination=last&roundtrip=true",
        (server) => server.reply(200, _responseTrip),
      );
      final road = await manager.getTrip(
        waypoints: waypoints,
        destination: DestinationGeoPointOption.last,
        source: SourceGeoPointOption.first,
        geometries: Geometries.polyline,
        steps: false,
        language: Languages.en,
      );
      expect(road.distance >= 7.9822, true);
      expect(road.duration >= 945.6, true);
    });
  });
  test("test parser", () async {
    final osrmHelper = FakeOSRMMixin();
    final responseApi = {
      "code": "Ok",
      "waypoints": [
        {
          "hint":
              "GTPviIxQ4IAYAAAABQAAAAAAAAAgAAAASjFaQdLNK0AAAAAAsPePQQwAAAADAAAAAAAAABAAAAAi5QAA_kvMAKlYIQM8TMwArVghAwAA7wo6xQgq",
          "distance": 4.231666,
          "location": [13.388798, 52.517033],
          "name": "Friedrichstraße"
        },
        {
          "hint":
              "T88igL3b-IgGAAAACgAAAAAAAAB2AAAAW7-PQOKcyEAAAAAApq6DQgYAAAAKAAAAAAAAAHYAAAAi5QAAf27MABiJIQOCbswA_4ghAwAAXwU6xQgq",
          "distance": 2.789393,
          "location": [13.397631, 52.529432],
          "name": "Torstraße"
        },
        {
          "hint":
              "bswigP___38fAAAAUQAAACYAAAAeAAAAsowKQkpQX0Lx6yZCvsQGQh8AAABRAAAAJgAAAB4AAAAi5QAASufMAOdwIQNL58wA03AhAwMAvxA6xQgq",
          "distance": 2.226595,
          "location": [13.428554, 52.523239],
          "name": "Platz der Vereinten Nationen"
        }
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
                      "bearings": [355]
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, false, false, true],
                      "location": [13.388779, 52.517155],
                      "bearings": [0, 90, 180, 270]
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false, true],
                      "location": [13.388643, 52.518027],
                      "bearings": [0, 90, 180, 270]
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false, true, false],
                      "location": [13.388544, 52.518716],
                      "bearings": [30, 90, 180, 270, 315]
                    },
                    {
                      "out": 0,
                      "in": 1,
                      "entry": [true, false, true],
                      "location": [13.388308, 52.520336],
                      "bearings": [0, 180, 270]
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false, true],
                      "location": [13.388024, 52.52175],
                      "bearings": [0, 60, 180, 225]
                    },
                    {
                      "out": 0,
                      "in": 1,
                      "entry": [true, false, true],
                      "location": [13.387885, 52.522524],
                      "bearings": [0, 180, 225]
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false],
                      "location": [13.387799, 52.523401],
                      "bearings": [0, 90, 180]
                    },
                    {
                      "out": 0,
                      "in": 1,
                      "lanes": [
                        {
                          "valid": false,
                          "indications": ["none"]
                        },
                        {
                          "valid": false,
                          "indications": ["left"]
                        },
                        {
                          "valid": true,
                          "indications": ["straight"]
                        }
                      ],
                      "entry": [true, false, true],
                      "location": [13.387748, 52.523877],
                      "bearings": [0, 180, 270]
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false],
                      "location": [13.3877, 52.524433],
                      "bearings": [0, 90, 180]
                    },
                    {
                      "out": 3,
                      "in": 1,
                      "entry": [true, false, false, true],
                      "location": [13.387337, 52.526239],
                      "bearings": [105, 165, 300, 345]
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, false, false, false],
                      "location": [13.387283, 52.526386],
                      "bearings": [0, 105, 165, 255]
                    }
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
                    "location": [13.388798, 52.517033]
                  }
                },
                {
                  "intersections": [
                    {
                      "out": 0,
                      "in": 1,
                      "entry": [true, false, true, true],
                      "location": [13.387215, 52.527166],
                      "bearings": [75, 180, 255, 330]
                    },
                    {
                      "out": 0,
                      "in": 1,
                      "entry": [true, false, true],
                      "location": [13.389147, 52.527549],
                      "bearings": [75, 255, 345]
                    },
                    {
                      "out": 0,
                      "in": 1,
                      "entry": [true, false, true],
                      "location": [13.391396, 52.528032],
                      "bearings": [75, 255, 330]
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false],
                      "location": [13.392425, 52.528233],
                      "bearings": [75, 165, 255]
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false, true],
                      "location": [13.393814, 52.528526],
                      "bearings": [75, 135, 255, 315]
                    },
                    {
                      "out": 0,
                      "in": 1,
                      "entry": [true, false, true],
                      "location": [13.395724, 52.528996],
                      "bearings": [75, 255, 345]
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false, true],
                      "location": [13.397565, 52.529429],
                      "bearings": [90, 180, 255, 345]
                    }
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
                    "modifier": "right"
                  }
                },
                {
                  "intersections": [
                    {
                      "in": 0,
                      "entry": [true],
                      "location": [13.397631, 52.529432],
                      "bearings": [266]
                    }
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
                    "location": [13.397631, 52.529432]
                  }
                }
              ],
              "weight": 252.7,
              "distance": 1884.7,
              "summary": "Friedrichstraße, Torstraße",
              "duration": 251.5
            },
            {
              "steps": [
                {
                  "intersections": [
                    {
                      "out": 0,
                      "entry": [true],
                      "location": [13.397631, 52.529432],
                      "bearings": [85]
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "lanes": [
                        {
                          "valid": true,
                          "indications": ["left"]
                        },
                        {
                          "valid": true,
                          "indications": ["straight"]
                        },
                        {
                          "valid": true,
                          "indications": ["straight", "right"]
                        }
                      ],
                      "entry": [true, true, false, false],
                      "location": [13.401337, 52.529605],
                      "bearings": [90, 165, 270, 345]
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, false, true],
                      "location": [13.401541, 52.529618],
                      "bearings": [90, 165, 285]
                    },
                    {
                      "out": 1,
                      "in": 3,
                      "lanes": [
                        {
                          "valid": false,
                          "indications": ["left"]
                        },
                        {
                          "valid": true,
                          "indications": ["straight"]
                        },
                        {
                          "valid": true,
                          "indications": ["straight", "right"]
                        }
                      ],
                      "entry": [true, true, true, false],
                      "location": [13.409405, 52.528711],
                      "bearings": [30, 105, 210, 285]
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "lanes": [
                        {
                          "valid": true,
                          "indications": ["straight"]
                        },
                        {
                          "valid": true,
                          "indications": ["straight", "right"]
                        }
                      ],
                      "entry": [true, true, false],
                      "location": [13.409967, 52.528591],
                      "bearings": [105, 165, 285]
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "lanes": [
                        {
                          "valid": true,
                          "indications": ["straight"]
                        },
                        {
                          "valid": true,
                          "indications": ["straight", "right"]
                        }
                      ],
                      "entry": [true, false, false, false],
                      "location": [13.410145, 52.528553],
                      "bearings": [105, 150, 285, 330]
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false],
                      "location": [13.411852, 52.528201],
                      "bearings": [120, 210, 285]
                    }
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
                    "location": [13.397631, 52.529432]
                  }
                },
                {
                  "intersections": [
                    {
                      "out": 1,
                      "in": 3,
                      "lanes": [
                        {
                          "valid": false,
                          "indications": ["left"]
                        },
                        {
                          "valid": false,
                          "indications": ["left"]
                        },
                        {
                          "valid": false,
                          "indications": ["straight"]
                        },
                        {
                          "valid": true,
                          "indications": ["straight"]
                        },
                        {
                          "valid": true,
                          "indications": ["straight", "right"]
                        }
                      ],
                      "entry": [false, true, true, false],
                      "location": [13.415405, 52.526922],
                      "bearings": [30, 135, 210, 315]
                    },
                    {
                      "out": 0,
                      "in": 3,
                      "lanes": [
                        {
                          "valid": true,
                          "indications": ["left"]
                        },
                        {
                          "valid": true,
                          "indications": ["left"]
                        },
                        {
                          "valid": false,
                          "indications": ["straight"]
                        },
                        {
                          "valid": false,
                          "indications": ["straight"]
                        },
                        {
                          "valid": false,
                          "indications": ["straight"]
                        }
                      ],
                      "entry": [true, true, false, false],
                      "location": [13.415657, 52.52677],
                      "bearings": [30, 135, 210, 315]
                    }
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
                    "modifier": "left"
                  }
                },
                {
                  "intersections": [
                    {
                      "out": 0,
                      "in": 2,
                      "lanes": [
                        {
                          "valid": false,
                          "indications": ["left"]
                        },
                        {
                          "valid": true,
                          "indications": ["straight"]
                        },
                        {
                          "valid": true,
                          "indications": ["straight"]
                        }
                      ],
                      "entry": [true, false, false, true],
                      "location": [13.415945, 52.527047],
                      "bearings": [30, 120, 210, 315]
                    }
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
                    "modifier": "straight"
                  }
                },
                {
                  "intersections": [
                    {
                      "out": 1,
                      "in": 2,
                      "entry": [true, true, false, false],
                      "location": [13.417166, 52.528458],
                      "bearings": [30, 90, 210, 315]
                    },
                    {
                      "out": 1,
                      "in": 3,
                      "entry": [false, true, true, false],
                      "location": [13.423592, 52.528206],
                      "bearings": [45, 120, 225, 285]
                    },
                    {
                      "out": 1,
                      "in": 3,
                      "entry": [true, true, false, false],
                      "location": [13.423868, 52.528136],
                      "bearings": [45, 120, 210, 300]
                    }
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
                    "modifier": "right"
                  }
                },
                {
                  "intersections": [
                    {
                      "out": 1,
                      "in": 2,
                      "entry": [true, true, false, true],
                      "location": [13.424993, 52.528068],
                      "bearings": [60, 150, 255, 345]
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false],
                      "location": [13.425842, 52.527621],
                      "bearings": [120, 225, 300]
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false],
                      "location": [13.428041, 52.526565],
                      "bearings": [135, 225, 315]
                    },
                    {
                      "out": 0,
                      "in": 2,
                      "entry": [true, true, false],
                      "location": [13.429315, 52.525737],
                      "bearings": [135, 225, 315]
                    }
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
                    "modifier": "right"
                  }
                },
                {
                  "intersections": [
                    {
                      "out": 1,
                      "in": 2,
                      "entry": [true, true, false],
                      "location": [13.430405, 52.524964],
                      "bearings": [135, 180, 345]
                    }
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
                    "modifier": "straight"
                  }
                },
                {
                  "intersections": [
                    {
                      "out": 3,
                      "in": 0,
                      "lanes": [
                        {
                          "valid": false,
                          "indications": ["left"]
                        },
                        {
                          "valid": false,
                          "indications": ["straight", "left"]
                        },
                        {
                          "valid": false,
                          "indications": ["straight"]
                        },
                        {
                          "valid": true,
                          "indications": ["straight", "right"]
                        }
                      ],
                      "entry": [false, false, true, true],
                      "location": [13.429678, 52.523269],
                      "bearings": [0, 90, 180, 270]
                    }
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
                    "modifier": "right"
                  }
                },
                {
                  "intersections": [
                    {
                      "in": 0,
                      "entry": [true],
                      "location": [13.428554, 52.523239],
                      "bearings": [88]
                    }
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
                    "location": [13.428554, 52.523239]
                  }
                }
              ],
              "weight": 363.5,
              "distance": 2839.1,
              "summary": "Torstraße, Friedenstraße",
              "duration": 363.5
            }
          ],
          "weight_name": "routability",
          "geometry":
              "mfp_I__vpAYBO@K@[BuBRgBLK@UBMMC?AAKAe@FyBTC@E?IDKDA@K@]BUBSBA?E@E@A@KFUBK@mAL{CZQ@qBRUBmAFc@@}@Fu@DG?a@B[@qAF_AJ[D_E`@SBO@ODA@UDA?]JC?uBNE?OAKACa@AI]mCCUE[AK[iCWqB[{Bk@sE_@_DAICSAOIm@AIQuACOQyAG[Gc@]wBw@aFKu@y@oFCMAOIm@?KAQ?KIuDQmHE}BBQ?Q?OCq@?I?IASAg@OuF?OAi@?c@@c@Du@r@cH@U@I@G@K?E~@kJRyBf@uE@KFi@RaBBMFc@Da@@ETaC@QJ{@Ny@Ha@RiAfBuJF]DOh@yAHSf@aADIR_@\\q@w@y@e@a@CCUQaCkB{@y@GESO?_@?C?[IoCIgDMsEAYOkEAQ@Yj@kENg@ZyBBIHm@FY@GBUJk@JmA?c@?QAQG]LKDEDCHOL]FO^uA@GTu@La@`A_DJ[pAgCJSlAwBJSf@{@b@w@dAqBHQZq@LMLKRIFAL?J@HBFBp@XPHh@TTJNFTRNFd@N\\HF@J@J@@V?N@rA@dB",
          "weight": 616.2,
          "distance": 4723.8,
          "duration": 615.0
        }
      ]
    };
    Road road = await osrmHelper.parseRoad(ParserRoadComputeArg(
      jsonRoad: responseApi,
      langCode: "en",
    ));
    expect(road.distance, 4.7238);
    expect(road.duration, 615.0);
  });
  test('test RoadStep', () {
    final json = {
      "geometry": "}b~`Hmzur@DPb@_@",
      "maneuver": {
        "bearing_after": 240,
        "bearing_before": 0,
        "location": [8.47287, 47.509114],
        "modifier": "right",
        "type": "depart"
      },
      "mode": "driving",
      "driving_side": "right",
      "name": "",
      "intersections": [
        {
          "out": 0,
          "entry": [true],
          "bearings": [240],
          "location": [8.47287, 47.509114]
        }
      ],
      "weight": 16.9,
      "duration": 9.4,
      "distance": 31.2
    };
    final roadStep = RoadStep.fromJson(json);
    expect(roadStep.maneuver.maneuverType, "depart");
    expect(roadStep.maneuver.modifier, "right");
    expect(roadStep.name, "");
    expect(roadStep.destinations, null);
    expect(roadStep.intersections.first.lanes, null);
  });
  test('test buildInstruction 1', () async {
    final osrmHelper = FakeOSRMMixin();
    final instructionHelper = await osrmHelper.loadInstructionHelperJson();
    final json = {
      "geometry": "}b~`Hmzur@DPb@_@",
      "maneuver": {
        "bearing_after": 240,
        "bearing_before": 0,
        "location": [8.47287, 47.509114],
        "modifier": "right",
        "type": "depart"
      },
      "mode": "driving",
      "driving_side": "right",
      "name": "",
      "intersections": [
        {
          "out": 0,
          "entry": [true],
          "bearings": [240],
          "location": [8.47287, 47.509114]
        }
      ],
      "weight": 16.9,
      "duration": 9.4,
      "distance": 31.2
    };
    final roadStep = RoadStep.fromJson(json);
    final instruction = osrmHelper.buildInstruction(
      roadStep,
      instructionHelper,
      {
        "legIndex": 0,
        "legCount": 1,
      },
    );
    expect(instruction, "Head north");
  });
  test('test buildInstruction 2', () async {
    final osrmHelper = FakeOSRMMixin();
    final instructionHelper = await osrmHelper.loadInstructionHelperJson();
    final json = {
      "geometry": "mh~`Hgqur@KJUHg@POBM@SCGAIEQOKSEEM]EGMYGOG[",
      "maneuver": {
        "bearing_after": 329,
        "bearing_before": 322,
        "location": [8.471398, 47.509993],
        "modifier": "straight",
        "type": "new name"
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
          "location": [8.471398, 47.509993]
        },
        {
          "out": 0,
          "in": 1,
          "entry": [true, false, true],
          "bearings": [30, 195, 300],
          "location": [8.471227, 47.510695]
        }
      ],
      "weight": 14.1,
      "duration": 14.1,
      "distance": 157.6
    };
    final roadStep = RoadStep.fromJson(json);
    final instruction = osrmHelper.buildInstruction(
      roadStep,
      instructionHelper,
      {
        "legIndex": 0,
        "legCount": 1,
      },
    );
    expect(instruction, "Continue onto Binzmühlestrasse");
  });
}

const _response = {
  "code": "Ok",
  "routes": [
    {
      "geometry":
          "mfp_I__vpAWBSBE?C?[BUBuALI@O@wAJK@UBMMC?AAKAe@FyBTC@E?IDIDA@M@]BUBSBA?E@E@A@IFWBG@C?WBm@FG@I@aBNG@i@FO@OBaBNUBmAFc@@}@Fu@DG?a@B[@qAF}@JA?[D_E`@SBO@ODA@UDA?ODE@GBC?uBNE?OAKCC_@AI]mCCUE[AK[iCUaBAMAMSsAE[k@sE_@_DAMACAKAOIk@AKQuACOQyAG[Gc@]wBw@aFKu@y@oFCMAOIm@?KAQ?KIuDQmHEuB@U@U?OCq@?I?IASAg@ASMaF?OAi@?c@@c@Du@r@cH@U@I@G@I?G~@kJRyBf@uE@KFi@@KPuABMFc@D[@MT_C@QJ{@Ny@Ha@RiAfBuJF]DOh@yAHSf@aADIR_@JS@C@A@CJSWWEECEECOQe@a@CCUQaCkB{@y@GESO?_@?C?C?WIoCGqCAK?[MaEASMgDAi@AQ@YBKf@_ENg@D]T{ABIHm@FY@GBUJk@@IHcA?c@?QAQG]JKDC@ADCHOL]FOFUT{@BKTu@La@\\gANg@L_@DOJ[~@kBP[JSXg@^q@R]Ta@HQR]b@y@^s@Xg@JQHQP_@HQLMLKRIFAL?J@HBFBr@XNH^NHDTJNFTRRJd@LXFB@B?VB@V?N?F@jA@dB",
      "legs": [
        {
          "steps": [
            {
              "geometry":
                  "mfp_I__vpAWBSBE?C?[BUBuALI@O@wAJK@UBMMC?AAKAe@FyBTC@E?IDIDA@M@]BUBSBA?E@E@A@IFWBG@C?WBm@FG@I@aBNG@i@FO@OBaBNUBmAFc@@}@Fu@DG?a@B[@qAF}@JA?[D_E`@SBO@ODA@UDA?ODE@GBC?uBNE?OAKC",
              "maneuver": {
                "bearing_after": 355,
                "bearing_before": 0,
                "location": [13.388798, 52.517033],
                "type": "depart"
              },
              "mode": "driving",
              "driving_side": "right",
              "name": "Friedrichstraße",
              "intersections": [
                {
                  "out": 0,
                  "entry": [true],
                  "bearings": [355],
                  "location": [13.388798, 52.517033]
                },
                {
                  "out": 0,
                  "in": 2,
                  "entry": [true, false, false, true],
                  "bearings": [0, 90, 180, 270],
                  "location": [13.38878, 52.517149]
                },
                {
                  "out": 0,
                  "in": 2,
                  "entry": [true, true, false, true],
                  "bearings": [0, 90, 180, 270],
                  "location": [13.388643, 52.518027]
                },
                {
                  "out": 0,
                  "in": 2,
                  "entry": [true, true, false, true, false],
                  "bearings": [30, 90, 180, 270, 315],
                  "location": [13.388544, 52.518716]
                },
                {
                  "out": 0,
                  "in": 1,
                  "entry": [true, false, true, false],
                  "bearings": [0, 165, 180, 285],
                  "location": [13.388255, 52.520395]
                },
                {
                  "out": 0,
                  "in": 2,
                  "entry": [true, true, false, true],
                  "bearings": [0, 45, 180, 225],
                  "location": [13.388022, 52.521758]
                },
                {
                  "out": 0,
                  "in": 1,
                  "entry": [true, false, true],
                  "bearings": [0, 180, 225],
                  "location": [13.387885, 52.522524]
                },
                {
                  "out": 0,
                  "in": 2,
                  "entry": [true, true, false],
                  "bearings": [0, 90, 180],
                  "location": [13.387799, 52.523401]
                },
                {
                  "lanes": [
                    {
                      "valid": false,
                      "indications": ["none"]
                    },
                    {
                      "valid": false,
                      "indications": ["left"]
                    },
                    {
                      "valid": true,
                      "indications": ["straight"]
                    }
                  ],
                  "out": 0,
                  "in": 1,
                  "entry": [true, false, true],
                  "bearings": [0, 180, 270],
                  "location": [13.387748, 52.523877]
                },
                {
                  "out": 0,
                  "in": 2,
                  "entry": [true, true, false],
                  "bearings": [0, 90, 180],
                  "location": [13.3877, 52.524433]
                },
                {
                  "out": 3,
                  "in": 1,
                  "entry": [true, false, false, true],
                  "bearings": [105, 165, 300, 345],
                  "location": [13.387337, 52.526239]
                },
                {
                  "out": 0,
                  "in": 2,
                  "entry": [true, false, false, false],
                  "bearings": [0, 105, 165, 255],
                  "location": [13.387283, 52.526386]
                }
              ],
              "weight": 138.3,
              "duration": 135.5,
              "distance": 1136.9
            },
            {
              "geometry":
                  "yer_IeuupAC_@AI]mCCUE[AK[iCUaBAMAMSsAE[k@sE_@_DAMACAKAOIk@AKQuACOQyAG[Gc@]wBw@aFKu@y@oFCMAOIm@?K",
              "maneuver": {
                "bearing_after": 71,
                "bearing_before": 8,
                "location": [13.387228, 52.527168],
                "modifier": "right",
                "type": "turn"
              },
              "mode": "driving",
              "driving_side": "right",
              "name": "Torstraße",
              "intersections": [
                {
                  "out": 0,
                  "in": 1,
                  "entry": [true, false, true, true],
                  "bearings": [75, 195, 255, 330],
                  "location": [13.387228, 52.527168]
                },
                {
                  "out": 0,
                  "in": 1,
                  "entry": [true, false, true],
                  "bearings": [75, 255, 345],
                  "location": [13.389147, 52.527549]
                },
                {
                  "out": 0,
                  "in": 1,
                  "entry": [true, false, true],
                  "bearings": [75, 255, 330],
                  "location": [13.391396, 52.528032]
                },
                {
                  "out": 0,
                  "in": 2,
                  "entry": [true, true, false],
                  "bearings": [75, 165, 255],
                  "location": [13.392425, 52.528233]
                },
                {
                  "out": 0,
                  "in": 2,
                  "entry": [true, true, false, true],
                  "bearings": [75, 120, 255, 330],
                  "location": [13.393814, 52.528526]
                },
                {
                  "out": 0,
                  "in": 1,
                  "entry": [true, false, true],
                  "bearings": [75, 255, 345],
                  "location": [13.395724, 52.528996]
                },
                {
                  "out": 0,
                  "in": 2,
                  "entry": [true, true, false, true],
                  "bearings": [90, 180, 255, 345],
                  "location": [13.397565, 52.529429]
                }
              ],
              "weight": 124.6,
              "duration": 124.6,
              "distance": 750.1
            },
            {
              "geometry": "}sr_IevwpA",
              "maneuver": {
                "bearing_after": 0,
                "bearing_before": 86,
                "location": [13.39763, 52.529432],
                "type": "arrive"
              },
              "mode": "driving",
              "driving_side": "right",
              "name": "Torstraße",
              "intersections": [
                {
                  "in": 0,
                  "entry": [true],
                  "bearings": [266],
                  "location": [13.39763, 52.529432]
                }
              ],
              "weight": 0,
              "duration": 0,
              "distance": 0
            }
          ],
          "summary": "Friedrichstraße, Torstraße",
          "weight": 262.9,
          "duration": 260.1,
          "distance": 1887
        },
        {
          "steps": [
            {
              "geometry":
                  "}sr_IevwpAAQ?KIuDQmHEuB@U@U?OCq@?I?IASAg@ASMaF?OAi@?c@@c@Du@r@cH@U@I@G@I?G~@kJRyBf@uE@KFi@@KPuABMFc@D[@MT_C@QJ{@Ny@Ha@RiAfBuJF]DOh@yAHSf@aADIR_@",
              "maneuver": {
                "bearing_after": 85,
                "bearing_before": 0,
                "location": [13.39763, 52.529432],
                "type": "depart"
              },
              "mode": "driving",
              "driving_side": "right",
              "name": "Torstraße",
              "intersections": [
                {
                  "out": 0,
                  "entry": [true],
                  "bearings": [85],
                  "location": [13.39763, 52.529432]
                },
                {
                  "lanes": [
                    {
                      "valid": true,
                      "indications": ["left"]
                    },
                    {
                      "valid": true,
                      "indications": ["straight"]
                    },
                    {
                      "valid": true,
                      "indications": ["straight", "right"]
                    }
                  ],
                  "out": 0,
                  "in": 2,
                  "entry": [true, true, false, false],
                  "bearings": [90, 150, 270, 330],
                  "location": [13.401337, 52.529605]
                },
                {
                  "out": 0,
                  "in": 2,
                  "entry": [true, false, true],
                  "bearings": [90, 165, 285],
                  "location": [13.401541, 52.529618]
                },
                {
                  "out": 0,
                  "in": 2,
                  "entry": [true, true, false],
                  "bearings": [105, 195, 285],
                  "location": [13.405456, 52.529405]
                },
                {
                  "lanes": [
                    {
                      "valid": false,
                      "indications": ["left"]
                    },
                    {
                      "valid": true,
                      "indications": ["straight"]
                    },
                    {
                      "valid": true,
                      "indications": ["straight", "right"]
                    }
                  ],
                  "out": 1,
                  "in": 3,
                  "entry": [true, true, true, false],
                  "bearings": [30, 105, 210, 285],
                  "location": [13.409405, 52.528711]
                },
                {
                  "lanes": [
                    {
                      "valid": true,
                      "indications": ["straight"]
                    },
                    {
                      "valid": true,
                      "indications": ["straight", "right"]
                    }
                  ],
                  "out": 0,
                  "in": 2,
                  "entry": [true, true, false],
                  "bearings": [105, 165, 285],
                  "location": [13.409967, 52.528591]
                },
                {
                  "lanes": [
                    {
                      "valid": true,
                      "indications": ["straight"]
                    },
                    {
                      "valid": true,
                      "indications": ["straight", "right"]
                    }
                  ],
                  "out": 0,
                  "in": 2,
                  "entry": [true, false, false, false],
                  "bearings": [105, 165, 285, 330],
                  "location": [13.410146, 52.52855]
                },
                {
                  "out": 0,
                  "in": 2,
                  "entry": [true, true, false],
                  "bearings": [120, 210, 285],
                  "location": [13.411852, 52.528201]
                }
              ],
              "weight": 203.400000000,
              "duration": 203.400000000,
              "distance": 1275.6
            },
            {
              "geometry": "gdr_Iie{pAJS@C@A@CJSWWEECEECOQ",
              "maneuver": {
                "bearing_after": 133,
                "bearing_before": 133,
                "location": [13.415405, 52.526922],
                "modifier": "left",
                "type": "turn"
              },
              "mode": "driving",
              "driving_side": "right",
              "name": "",
              "intersections": [
                {
                  "lanes": [
                    {
                      "valid": false,
                      "indications": ["left"]
                    },
                    {
                      "valid": false,
                      "indications": ["left"]
                    },
                    {
                      "valid": false,
                      "indications": ["straight"]
                    },
                    {
                      "valid": true,
                      "indications": ["straight"]
                    },
                    {
                      "valid": true,
                      "indications": ["straight", "right"]
                    }
                  ],
                  "out": 1,
                  "in": 3,
                  "entry": [false, true, true, false],
                  "bearings": [30, 135, 210, 315],
                  "location": [13.415405, 52.526922]
                },
                {
                  "lanes": [
                    {
                      "valid": true,
                      "indications": ["left"]
                    },
                    {
                      "valid": true,
                      "indications": ["left"]
                    },
                    {
                      "valid": false,
                      "indications": ["straight"]
                    },
                    {
                      "valid": false,
                      "indications": ["straight"]
                    },
                    {
                      "valid": false,
                      "indications": ["straight"]
                    }
                  ],
                  "out": 0,
                  "in": 3,
                  "entry": [true, true, false, false],
                  "bearings": [30, 135, 210, 315],
                  "location": [13.415657, 52.52677]
                }
              ],
              "weight": 12,
              "duration": 12,
              "distance": 60.6
            },
            {
              "geometry": "aer_Iuh{pAe@a@CCUQaCkB{@y@GESO",
              "maneuver": {
                "bearing_after": 26,
                "bearing_before": 32,
                "location": [13.415945, 52.527047],
                "modifier": "straight",
                "type": "new name"
              },
              "mode": "driving",
              "driving_side": "right",
              "name": "Prenzlauer Allee",
              "intersections": [
                {
                  "lanes": [
                    {
                      "valid": false,
                      "indications": ["left"]
                    },
                    {
                      "valid": true,
                      "indications": ["straight"]
                    },
                    {
                      "valid": true,
                      "indications": ["straight"]
                    }
                  ],
                  "out": 0,
                  "in": 2,
                  "entry": [true, false, false, true],
                  "bearings": [30, 120, 210, 315],
                  "location": [13.415945, 52.527047]
                }
              ],
              "weight": 18.2,
              "duration": 18.2,
              "distance": 177.6
            },
            {
              "geometry":
                  "{mr_Iip{pA?_@?C?C?WIoCGqCAK?[MaEASMgDAi@AQ@YBKf@_ENg@D]T{ABIHm@FY@GBUJk@@IHcA?c@?QAQG]",
              "maneuver": {
                "bearing_after": 85,
                "bearing_before": 28,
                "location": [13.417166, 52.528458],
                "modifier": "right",
                "type": "turn"
              },
              "mode": "driving",
              "driving_side": "right",
              "name": "Prenzlauer Berg",
              "intersections": [
                {
                  "out": 1,
                  "in": 2,
                  "entry": [true, true, false, false],
                  "bearings": [30, 90, 210, 315],
                  "location": [13.417166, 52.528458]
                },
                {
                  "out": 1,
                  "in": 3,
                  "entry": [false, true, true, false],
                  "bearings": [45, 120, 225, 285],
                  "location": [13.423592, 52.528206]
                },
                {
                  "out": 1,
                  "in": 3,
                  "entry": [true, true, false, false],
                  "bearings": [45, 105, 210, 300],
                  "location": [13.423868, 52.528136]
                }
              ],
              "weight": 57,
              "duration": 57,
              "distance": 548.7
            },
            {
              "geometry":
                  "mkr_Iea}pAJKDC@ADCHOL]FOFUT{@BKTu@La@\\gANg@L_@DOJ[~@kBP[JSXg@^q@R]Ta@HQR]b@y@^s@Xg@JQHQP_@HQLMLKRI",
              "maneuver": {
                "bearing_after": 151,
                "bearing_before": 67,
                "location": [13.424993, 52.528068],
                "modifier": "right",
                "type": "turn"
              },
              "mode": "driving",
              "driving_side": "right",
              "name": "Friedenstraße",
              "intersections": [
                {
                  "out": 1,
                  "in": 2,
                  "entry": [true, true, false, true],
                  "bearings": [60, 150, 255, 345],
                  "location": [13.424993, 52.528068]
                },
                {
                  "out": 0,
                  "in": 2,
                  "entry": [true, true, false],
                  "bearings": [120, 225, 300],
                  "location": [13.425818, 52.52763]
                },
                {
                  "out": 0,
                  "in": 2,
                  "entry": [true, true, false],
                  "bearings": [135, 225, 315],
                  "location": [13.428041, 52.526565]
                },
                {
                  "out": 0,
                  "in": 2,
                  "entry": [true, true, false],
                  "bearings": [135, 225, 315],
                  "location": [13.429337, 52.525737]
                }
              ],
              "weight": 52.400000000,
              "duration": 52.400000000,
              "distance": 510.1
            },
            {
              "geometry": "_xq_Iac~pAFAL?J@HBFBr@XNH^NHDTJNFTRRJd@LXFB@B?VB",
              "maneuver": {
                "bearing_after": 174,
                "bearing_before": 163,
                "location": [13.430405, 52.524964],
                "modifier": "straight",
                "type": "new name"
              },
              "mode": "driving",
              "driving_side": "right",
              "name": "Platz der Vereinten Nationen",
              "intersections": [
                {
                  "out": 1,
                  "in": 2,
                  "entry": [true, true, false],
                  "bearings": [135, 180, 345],
                  "location": [13.430405, 52.524964]
                }
              ],
              "weight": 20.6,
              "duration": 20.6,
              "distance": 196.6
            },
            {
              "geometry": "mmq_Io~}pA@V?N?F@jA@dB",
              "maneuver": {
                "bearing_after": 267,
                "bearing_before": 189,
                "location": [13.429678, 52.523269],
                "modifier": "right",
                "type": "continue"
              },
              "mode": "driving",
              "driving_side": "right",
              "name": "Platz der Vereinten Nationen",
              "intersections": [
                {
                  "lanes": [
                    {
                      "valid": false,
                      "indications": ["left"]
                    },
                    {
                      "valid": false,
                      "indications": ["straight", "left"]
                    },
                    {
                      "valid": false,
                      "indications": ["straight"]
                    },
                    {
                      "valid": true,
                      "indications": ["straight", "right"]
                    }
                  ],
                  "out": 3,
                  "in": 0,
                  "entry": [false, false, true, true],
                  "bearings": [15, 90, 180, 270],
                  "location": [13.429678, 52.523269]
                }
              ],
              "weight": 6.9,
              "duration": 6.9,
              "distance": 76.4
            },
            {
              "geometry": "gmq_Imw}pA",
              "maneuver": {
                "bearing_after": 0,
                "bearing_before": 268,
                "location": [13.428554, 52.523239],
                "type": "arrive"
              },
              "mode": "driving",
              "driving_side": "right",
              "name": "Platz der Vereinten Nationen",
              "intersections": [
                {
                  "in": 0,
                  "entry": [true],
                  "bearings": [88],
                  "location": [13.428554, 52.523239]
                }
              ],
              "weight": 0,
              "duration": 0,
              "distance": 0
            }
          ],
          "summary": "Torstraße, Friedenstraße",
          "weight": 370.5,
          "duration": 370.5,
          "distance": 2845.5
        }
      ],
      "weight_name": "routability",
      "weight": 633.4,
      "duration": 630.6,
      "distance": 4732.5
    }
  ],
  "waypoints": [
    {
      "hint":
          "XP8JgPUvmoUXAAAABQAAAAAAAAAgAAAAIXRPQYXNK0AAAAAAcPePQQsAAAADAAAAAAAAABAAAAC8-QAA_kvMAKlYIQM8TMwArVghAwAA7wqGF9Uq",
      "distance": 4.231521214,
      "name": "Friedrichstraße",
      "location": [13.388798, 52.517033]
    },
    {
      "hint":
          "7jfdgR8ZiocGAAAACgAAAAAAAAB3AAAAppONQOodwkAAAAAA8TeEQgYAAAAKAAAAAAAAAHcAAAC8-QAAfm7MABiJIQOCbswA_4ghAwAAXwWGF9Uq",
      "distance": 2.795148358,
      "name": "Torstraße",
      "location": [13.39763, 52.529432]
    },
    {
      "hint":
          "WCoYgP___38fAAAAUQAAACYAAAAeAAAAeosKQlNOX0Jq6iZCjsMGQh8AAABRAAAAJgAAAB4AAAC8-QAASufMAOdwIQNL58wA03AhAwQAvxCGF9Uq",
      "distance": 2.226580806,
      "name": "Platz der Vereinten Nationen",
      "location": [13.428554, 52.523239]
    }
  ]
};

const _responseWithoutSteps = {
  "code": "Ok",
  "routes": [
    {
      "geometry":
          "mfp_I__vpAWBSBE?C?[BUBuALI@O@wAJK@UBMMC?AAKAe@FyBTC@E?IDIDA@M@]BUBSBA?E@E@A@IFWBG@C?WBm@FG@I@aBNG@i@FO@OBaBNG@M@mAFc@@}@Fu@DG?a@B[@qAF}@JA?[D_E`@SBO@ODA@UDA?ODE@GBC?uBNE?OAKCC_@AI]mCCUE[AK[iCUaBAMAMSsAE[k@sE_@_DAMACAKCQGi@AKQuACOKy@E_@G[Gc@]wBw@aFKw@y@mFCMAKIq@?KAQ?KIuDQmHEuB@U@U?OCq@?I?IASAg@ASMaF?OAi@?c@@c@Du@r@cH@U@I@G@I?G~@kJRyBf@uE@KFi@@KPuABMFc@D[@MT_C@QJ{@Ny@Ha@RiAfBuJF]DOh@yAHSf@aADIR_@JS@C@A@CJSWWEECEECOQe@a@CCUQaCkB{@y@GESO?_@?C?C?WIoCGqCAK?[MaEASMgDAi@AQ@YBKf@_ENg@D]T{ABIHm@FY@GBUJk@@IHcA?c@?QAQG]JKDC@ADCHOL]FOFUT{@BKTu@La@\\gANg@L_@DOJ[~@kBP[JSXg@^q@R]Ta@HQR]b@y@^s@Xg@JQHQP_@HQLMLKRIFAL?J@HBFBr@XNH^NHDTJNFTRRJd@LXFB@B?VB@V?N?F@jA@dB",
      "legs": [
        {
          "steps": [],
          "summary": "",
          "weight": 263.2,
          "duration": 260.4,
          "distance": 1887
        },
        {
          "steps": [],
          "summary": "",
          "weight": 370.5,
          "duration": 370.5,
          "distance": 2845.5
        }
      ],
      "weight_name": "routability",
      "weight": 633.7,
      "duration": 630.9,
      "distance": 4732.5
    }
  ],
  "waypoints": [
    {
      "hint":
          "TP8JgEs9moUXAAAABQAAAAAAAAAgAAAAIXRPQYXNK0AAAAAAcPePQQsAAAADAAAAAAAAABAAAABo-gAA_kvMAKlYIQM8TMwArVghAwAA7wogccr9",
      "distance": 4.231521214,
      "name": "Friedrichstraße",
      "location": [13.388798, 52.517033]
    },
    {
      "hint":
          "fTvdgTsuiocGAAAACgAAAAAAAAB3AAAAppONQOodwkAAAAAA8TeEQgYAAAAKAAAAAAAAAHcAAABo-gAAfm7MABiJIQOCbswA_4ghAwAAXwUgccr9",
      "distance": 2.795148358,
      "name": "Torstraße",
      "location": [13.39763, 52.529432]
    },
    {
      "hint":
          "WyoYgP___38fAAAAUQAAACYAAAAeAAAAeosKQlNOX0Jq6iZCjsMGQh8AAABRAAAAJgAAAB4AAABo-gAASufMAOdwIQNL58wA03AhAwQAvxAgccr9",
      "distance": 2.226580806,
      "name": "Platz der Vereinten Nationen",
      "location": [13.428554, 52.523239]
    }
  ]
};

const _responseGeoJson = {
  "code": "Ok",
  "routes": [
    {
      "geometry": {
        "coordinates": [
          [13.388798, 52.517033],
          [13.38878, 52.517149],
          [13.388764, 52.51725],
          [13.38876, 52.517276],
          [13.388755, 52.517303],
          [13.388735, 52.517435],
          [13.388718, 52.517548],
          [13.38865, 52.51798],
          [13.388643, 52.518027],
          [13.388632, 52.518106],
          [13.388568, 52.518553],
          [13.388559, 52.51861],
          [13.388544, 52.518716],
          [13.388611, 52.518785],
          [13.388614, 52.51881],
          [13.388616, 52.51882],
          [13.388625, 52.518883],
          [13.388593, 52.519069],
          [13.388481, 52.519678],
          [13.388474, 52.519704],
          [13.388465, 52.519732],
          [13.38844, 52.519782],
          [13.388406, 52.519827],
          [13.388404, 52.519842],
          [13.388392, 52.519909],
          [13.388367, 52.520055],
          [13.388345, 52.520167],
          [13.388329, 52.520274],
          [13.388327, 52.520284],
          [13.388321, 52.520313],
          [13.388308, 52.520336],
          [13.388296, 52.520353],
          [13.388255, 52.520395],
          [13.388238, 52.52052],
          [13.388232, 52.520557],
          [13.388228, 52.520576],
          [13.388207, 52.520699],
          [13.388167, 52.520929],
          [13.388161, 52.520966],
          [13.388151, 52.521018],
          [13.388065, 52.521514],
          [13.388059, 52.521547],
          [13.388022, 52.521758],
          [13.388005, 52.521842],
          [13.387991, 52.521919],
          [13.387905, 52.522412],
          [13.387898, 52.52245],
          [13.387885, 52.522524],
          [13.387845, 52.52291],
          [13.387843, 52.523088],
          [13.387799, 52.523401],
          [13.38777, 52.52367],
          [13.387766, 52.523711],
          [13.387748, 52.523877],
          [13.387742, 52.524024],
          [13.3877, 52.524433],
          [13.387642, 52.524738],
          [13.387639, 52.524753],
          [13.387614, 52.524894],
          [13.387442, 52.525847],
          [13.387423, 52.525954],
          [13.387408, 52.526033],
          [13.387375, 52.526108],
          [13.387374, 52.526118],
          [13.38734, 52.526231],
          [13.387337, 52.526239],
          [13.387308, 52.526319],
          [13.387297, 52.526347],
          [13.387283, 52.526386],
          [13.38728, 52.526411],
          [13.387196, 52.526998],
          [13.387196, 52.527031],
          [13.387211, 52.527108],
          [13.387228, 52.527168],
          [13.387388, 52.527192],
          [13.387444, 52.527202],
          [13.388154, 52.527346],
          [13.388263, 52.527368],
          [13.388404, 52.527396],
          [13.388463, 52.527408],
          [13.389147, 52.527549],
          [13.389644, 52.527656],
          [13.389711, 52.52767],
          [13.389775, 52.527684],
          [13.390198, 52.527775],
          [13.390338, 52.527805],
          [13.391396, 52.528032],
          [13.392201, 52.528188],
          [13.392273, 52.528203],
          [13.392289, 52.528206],
          [13.392352, 52.528218],
          [13.392444, 52.528237],
          [13.392651, 52.528279],
          [13.392712, 52.528292],
          [13.39314, 52.528379],
          [13.393219, 52.528396],
          [13.393512, 52.528458],
          [13.393668, 52.528491],
          [13.393814, 52.528526],
          [13.393994, 52.528571],
          [13.394591, 52.528715],
          [13.395724, 52.528996],
          [13.395999, 52.529059],
          [13.397192, 52.529349],
          [13.397264, 52.529367],
          [13.397317, 52.529378],
          [13.397565, 52.529429],
          [13.39763, 52.529432],
          [13.397719, 52.529437],
          [13.397776, 52.52944],
          [13.398689, 52.529491],
          [13.400203, 52.529577],
          [13.400792, 52.529612],
          [13.400896, 52.529599],
          [13.401012, 52.529591],
          [13.401085, 52.529592],
          [13.401337, 52.529605],
          [13.401392, 52.529609],
          [13.40144, 52.529612],
          [13.401541, 52.529618],
          [13.401737, 52.529632],
          [13.401843, 52.529638],
          [13.40297, 52.529706],
          [13.40305, 52.52971],
          [13.403261, 52.529722],
          [13.403436, 52.529724],
          [13.403615, 52.529713],
          [13.403888, 52.529684],
          [13.40535, 52.529423],
          [13.405456, 52.529405],
          [13.405506, 52.529397],
          [13.40555, 52.52939],
          [13.405602, 52.529382],
          [13.405638, 52.529376],
          [13.40746, 52.529062],
          [13.408073, 52.528961],
          [13.409138, 52.528761],
          [13.409201, 52.528749],
          [13.409405, 52.528711],
          [13.409473, 52.528696],
          [13.409897, 52.528606],
          [13.409967, 52.528591],
          [13.410146, 52.52855],
          [13.410293, 52.528517],
          [13.410361, 52.528505],
          [13.411004, 52.5284],
          [13.411086, 52.528387],
          [13.411389, 52.528326],
          [13.411679, 52.528249],
          [13.411852, 52.528201],
          [13.412215, 52.528101],
          [13.414088, 52.527583],
          [13.414236, 52.527537],
          [13.41432, 52.527507],
          [13.414772, 52.527303],
          [13.414872, 52.527246],
          [13.415202, 52.527049],
          [13.415245, 52.527023],
          [13.415405, 52.526922],
          [13.415513, 52.526857],
          [13.415525, 52.52685],
          [13.415544, 52.526839],
          [13.415556, 52.526831],
          [13.415657, 52.52677],
          [13.415781, 52.52689],
          [13.415813, 52.52692],
          [13.415835, 52.526941],
          [13.415859, 52.526965],
          [13.415945, 52.527047],
          [13.416123, 52.527239],
          [13.416143, 52.527264],
          [13.416227, 52.527366],
          [13.41677, 52.528019],
          [13.417058, 52.52832],
          [13.417087, 52.528356],
          [13.417166, 52.528458],
          [13.417325, 52.528459],
          [13.417347, 52.528459],
          [13.417366, 52.528459],
          [13.41749, 52.52846],
          [13.418213, 52.528505],
          [13.418941, 52.528551],
          [13.419001, 52.528555],
          [13.419141, 52.528564],
          [13.420105, 52.528634],
          [13.420208, 52.528642],
          [13.421046, 52.528708],
          [13.421256, 52.528724],
          [13.421348, 52.528728],
          [13.421483, 52.528717],
          [13.421543, 52.528704],
          [13.422499, 52.528497],
          [13.422697, 52.528423],
          [13.422851, 52.528385],
          [13.423305, 52.528275],
          [13.423359, 52.52826],
          [13.423592, 52.528206],
          [13.42372, 52.528174],
          [13.423763, 52.528163],
          [13.423868, 52.528136],
          [13.424085, 52.528082],
          [13.424135, 52.528074],
          [13.424483, 52.528021],
          [13.424657, 52.528015],
          [13.424751, 52.528021],
          [13.424842, 52.528033],
          [13.424993, 52.528068],
          [13.425045, 52.528006],
          [13.425066, 52.527981],
          [13.425079, 52.527967],
          [13.425103, 52.527942],
          [13.425184, 52.527885],
          [13.425334, 52.527819],
          [13.425413, 52.527784],
          [13.425523, 52.527742],
          [13.425818, 52.52763],
          [13.425877, 52.527607],
          [13.426152, 52.527495],
          [13.42632, 52.527427],
          [13.426679, 52.527281],
          [13.426883, 52.527198],
          [13.427043, 52.527133],
          [13.427123, 52.5271],
          [13.427263, 52.527043],
          [13.427802, 52.526716],
          [13.427939, 52.526634],
          [13.428041, 52.526565],
          [13.42824, 52.526438],
          [13.428493, 52.526276],
          [13.428644, 52.526179],
          [13.428811, 52.526071],
          [13.428896, 52.526016],
          [13.429047, 52.525918],
          [13.429337, 52.525737],
          [13.429597, 52.525576],
          [13.429796, 52.525453],
          [13.429893, 52.525394],
          [13.429982, 52.525341],
          [13.430141, 52.525246],
          [13.430227, 52.525195],
          [13.430302, 52.52513],
          [13.43036, 52.525063],
          [13.430405, 52.524964],
          [13.430415, 52.524915],
          [13.430422, 52.524848],
          [13.430413, 52.52479],
          [13.430392, 52.524739],
          [13.430369, 52.524697],
          [13.43024, 52.524442],
          [13.430192, 52.524356],
          [13.430106, 52.524196],
          [13.430082, 52.524152],
          [13.430022, 52.524037],
          [13.429981, 52.523963],
          [13.429883, 52.523846],
          [13.429822, 52.523749],
          [13.429748, 52.523562],
          [13.429705, 52.523431],
          [13.429702, 52.523413],
          [13.429697, 52.523391],
          [13.429678, 52.523269],
          [13.429555, 52.523264],
          [13.429476, 52.523261],
          [13.429436, 52.52326],
          [13.429064, 52.52325],
          [13.428554, 52.523239]
        ],
        "type": "LineString"
      },
      "legs": [
        {
          "steps": [],
          "summary": "",
          "weight": 263.2,
          "duration": 260.4,
          "distance": 1887
        },
        {
          "steps": [],
          "summary": "",
          "weight": 370.5,
          "duration": 370.5,
          "distance": 2845.5
        }
      ],
      "weight_name": "routability",
      "weight": 633.7,
      "duration": 630.9,
      "distance": 4732.5
    }
  ],
  "waypoints": [
    {
      "hint":
          "TP8JgEs9moUXAAAABQAAAAAAAAAgAAAAIXRPQYXNK0AAAAAAcPePQQsAAAADAAAAAAAAABAAAABo-gAA_kvMAKlYIQM8TMwArVghAwAA7wogccr9",
      "distance": 4.231521214,
      "name": "Friedrichstraße",
      "location": [13.388798, 52.517033]
    },
    {
      "hint":
          "fTvdgTsuiocGAAAACgAAAAAAAAB3AAAAppONQOodwkAAAAAA8TeEQgYAAAAKAAAAAAAAAHcAAABo-gAAfm7MABiJIQOCbswA_4ghAwAAXwUgccr9",
      "distance": 2.795148358,
      "name": "Torstraße",
      "location": [13.39763, 52.529432]
    },
    {
      "hint":
          "WyoYgP___38fAAAAUQAAACYAAAAeAAAAeosKQlNOX0Jq6iZCjsMGQh8AAABRAAAAJgAAAB4AAABo-gAASufMAOdwIQNL58wA03AhAwQAvxAgccr9",
      "distance": 2.226580806,
      "name": "Platz der Vereinten Nationen",
      "location": [13.428554, 52.523239]
    }
  ]
};

const _responseTrip = {
  "code": "Ok",
  "trips": [
    {
      "geometry":
          "mfp_I__vpAWBSBE?C?[BUBuALI@O@wAJK@UBMMC?AAKAe@FyBTC@E?IDIDA@M@]BUBSBA?E@E@A@IFWBG@C?WBm@FG@I@aBNG@i@FO@OBaBNG@M@mAFc@@}@Fu@DG?a@B[@qAF}@JA?[D_E`@SBO@ODA@UDA?ODE@GBC?uBNE?OAKCC_@AI]mCCUE[AK[iCUaBAMAMSsAE[k@sE_@_DAMACAKCQGi@AKQuACOKy@E_@G[Gc@]wBw@aFKw@y@mFCMAKIq@?KAQ?KIuDQmHEuB@U@U?OCq@?I?IASAg@ASMaF?OAi@?c@@c@Du@r@cH@U@I@G@I?G~@kJRyBf@uE@KFi@@KPuABMFc@D[@MT_C@QJ{@Ny@Ha@RiAfBuJF]DOh@yAHSf@aADIR_@JS@C@A@CJSWWEECEECOQe@a@CCUQaCkB{@y@GESO?_@?C?C?WIoCGqCAK?[MaEASMgDAi@AQ@YBKf@_ENg@D]T{ABIHm@FY@GBUJk@@IHcA?c@?QAQG]JKDC@ADCHOL]FOFUT{@BKTu@La@\\gANg@L_@DOJ[~@kBP[JSXg@^q@R]Ta@HQR]b@y@^s@Xg@JQHQP_@HQLMLKRIFAL?J@HBFBr@XNH^NHDTJNFTRRJd@LXFB@B?VB@V?N?F@jA@dBBbD?n@@j@?D?N?L@n@?d@?Z?ZAVATCd@CXCRKp@Kn@Ml@_@hBYvAEPI^Mf@K`@K^o@xBaAjDOf@_@rAM^K\\a@rACJKZOh@CD?@CFIXK\\CFyB`HK^M\\a@jACH]dAc@tAm@dBCHM\\IVABEJEHABBBDDFHBB\\\\V^BBX^RTX\\z@|@r@x@BF`AnAj@v@@?DFT\\LPzApBdAzAFFd@n@BBTZTZBDJLR^z@~ADDn@jAXf@^r@JTDHP`@DJZv@DHDLBFb@`AFPrAdD`DhIPd@FNBDBHpAbDBFTl@@@BFPZJV@BpApCHPDHd@z@b@v@\\bABH@@n@zBBHdA`ENv@BHLd@BJNj@l@tBLbABXBl@HrC@h@DlALbGHdCD`B@N?HFxBDnA@\\BpA?VA\\AFALAL?T@j@@PHrDHtC?H@`@@XJxDDnB@P@b@VC",
      "legs": [
        {
          "steps": [],
          "summary": "",
          "weight": 263.2,
          "duration": 260.4,
          "distance": 1887
        },
        {
          "steps": [],
          "summary": "",
          "weight": 370.5,
          "duration": 370.5,
          "distance": 2845.5
        },
        {
          "steps": [],
          "summary": "",
          "weight": 339.8,
          "duration": 338.6,
          "distance": 3279.8
        }
      ],
      "weight_name": "routability",
      "weight": 973.5,
      "duration": 969.5,
      "distance": 8012.3
    }
  ],
  "waypoints": [
    {
      "waypoint_index": 0,
      "trips_index": 0,
      "hint":
          "TP8JgEs9moUXAAAABQAAAAAAAAAgAAAAIXRPQYXNK0AAAAAAcPePQQsAAAADAAAAAAAAABAAAABo-gAA_kvMAKlYIQM8TMwArVghAwAA7wogccr9",
      "distance": 4.231521214,
      "name": "Friedrichstraße",
      "location": [13.388798, 52.517033]
    },
    {
      "waypoint_index": 1,
      "trips_index": 0,
      "hint":
          "fTvdgTsuiocGAAAACgAAAAAAAAB3AAAAppONQOodwkAAAAAA8TeEQgYAAAAKAAAAAAAAAHcAAABo-gAAfm7MABiJIQOCbswA_4ghAwAAXwUgccr9",
      "distance": 2.795148358,
      "name": "Torstraße",
      "location": [13.39763, 52.529432]
    },
    {
      "waypoint_index": 2,
      "trips_index": 0,
      "hint":
          "WyoYgP___38fAAAAUQAAACYAAAAeAAAAeosKQlNOX0Jq6iZCjsMGQh8AAABRAAAAJgAAAB4AAABo-gAASufMAOdwIQNL58wA03AhAwQAvxAgccr9",
      "distance": 2.226580806,
      "name": "Platz der Vereinten Nationen",
      "location": [13.428554, 52.523239]
    }
  ]
};

const _en = {
  "meta": {"capitalizeFirstLetter": true},
  "v5": {
    "constants": {
      "ordinalize": {
        "1": "1st",
        "2": "2nd",
        "3": "3rd",
        "4": "4th",
        "5": "5th",
        "6": "6th",
        "7": "7th",
        "8": "8th",
        "9": "9th",
        "10": "10th"
      },
      "direction": {
        "north": "north",
        "northeast": "northeast",
        "east": "east",
        "southeast": "southeast",
        "south": "south",
        "southwest": "southwest",
        "west": "west",
        "northwest": "northwest"
      },
      "modifier": {
        "left": "left",
        "right": "right",
        "sharp left": "sharp left",
        "sharp right": "sharp right",
        "slight left": "slight left",
        "slight right": "slight right",
        "straight": "straight",
        "uturn": "U-turn"
      },
      "lanes": {
        "xo": "Keep right",
        "ox": "Keep left",
        "xox": "Keep in the middle",
        "oxo": "Keep left or right"
      }
    },
    "modes": {
      "ferry": {
        "default": "Take the ferry",
        "name": "Take the ferry {way_name}",
        "destination": "Take the ferry towards {destination}"
      }
    },
    "phrase": {
      "two linked by distance":
          "{instruction_one}, then, in {distance}, {instruction_two}",
      "two linked": "{instruction_one}, then {instruction_two}",
      "one in distance": "In {distance}, {instruction_one}",
      "name and ref": "{name} ({ref})",
      "exit with number": "exit {exit}"
    },
    "arrive": {
      "default": {
        "default": "You have arrived at your {nth} destination",
        "upcoming": "You will arrive at your {nth} destination",
        "short": "You have arrived",
        "short-upcoming": "You will arrive",
        "named": "You have arrived at {waypoint_name}"
      },
      "left": {
        "default": "You have arrived at your {nth} destination, on the left",
        "upcoming": "You will arrive at your {nth} destination, on the left",
        "short": "You have arrived",
        "short-upcoming": "You will arrive",
        "named": "You have arrived at {waypoint_name}, on the left"
      },
      "right": {
        "default": "You have arrived at your {nth} destination, on the right",
        "upcoming": "You will arrive at your {nth} destination, on the right",
        "short": "You have arrived",
        "short-upcoming": "You will arrive",
        "named": "You have arrived at {waypoint_name}, on the right"
      },
      "sharp left": {
        "default": "You have arrived at your {nth} destination, on the left",
        "upcoming": "You will arrive at your {nth} destination, on the left",
        "short": "You have arrived",
        "short-upcoming": "You will arrive",
        "named": "You have arrived at {waypoint_name}, on the left"
      },
      "sharp right": {
        "default": "You have arrived at your {nth} destination, on the right",
        "upcoming": "You will arrive at your {nth} destination, on the right",
        "short": "You have arrived",
        "short-upcoming": "You will arrive",
        "named": "You have arrived at {waypoint_name}, on the right"
      },
      "slight right": {
        "default": "You have arrived at your {nth} destination, on the right",
        "upcoming": "You will arrive at your {nth} destination, on the right",
        "short": "You have arrived",
        "short-upcoming": "You will arrive",
        "named": "You have arrived at {waypoint_name}, on the right"
      },
      "slight left": {
        "default": "You have arrived at your {nth} destination, on the left",
        "upcoming": "You will arrive at your {nth} destination, on the left",
        "short": "You have arrived",
        "short-upcoming": "You will arrive",
        "named": "You have arrived at {waypoint_name}, on the left"
      },
      "straight": {
        "default": "You have arrived at your {nth} destination, straight ahead",
        "upcoming": "You will arrive at your {nth} destination, straight ahead",
        "short": "You have arrived",
        "short-upcoming": "You will arrive",
        "named": "You have arrived at {waypoint_name}, straight ahead"
      }
    },
    "continue": {
      "default": {
        "default": "Turn {modifier}",
        "name": "Turn {modifier} to stay on {way_name}",
        "destination": "Turn {modifier} towards {destination}",
        "exit": "Turn {modifier} onto {way_name}"
      },
      "straight": {
        "default": "Continue straight",
        "name": "Continue straight to stay on {way_name}",
        "destination": "Continue towards {destination}",
        "distance": "Continue straight for {distance}",
        "namedistance": "Continue on {way_name} for {distance}"
      },
      "sharp left": {
        "default": "Make a sharp left",
        "name": "Make a sharp left to stay on {way_name}",
        "destination": "Make a sharp left towards {destination}",
        "junction_name": "Make a sharp left at {junction_name}"
      },
      "sharp right": {
        "default": "Make a sharp right",
        "name": "Make a sharp right to stay on {way_name}",
        "destination": "Make a sharp right towards {destination}",
        "junction_name": "Make a sharp right at {junction_name}"
      },
      "slight left": {
        "default": "Make a slight left",
        "name": "Make a slight left to stay on {way_name}",
        "destination": "Make a slight left towards {destination}",
        "junction_name": "Make a slight left at {junction_name}"
      },
      "slight right": {
        "default": "Make a slight right",
        "name": "Make a slight right to stay on {way_name}",
        "destination": "Make a slight right towards {destination}",
        "junction_name": "Make a slight right at {junction_name}"
      },
      "uturn": {
        "default": "Make a U-turn",
        "name": "Make a U-turn and continue on {way_name}",
        "destination": "Make a U-turn towards {destination}",
        "junction_name": "Make a U-turn at {junction_name}"
      }
    },
    "depart": {
      "default": {
        "default": "Head {direction}",
        "name": "Head {direction} on {way_name}",
        "namedistance": "Head {direction} on {way_name} for {distance}"
      }
    },
    "end of road": {
      "default": {
        "default": "Turn {modifier}",
        "name": "Turn {modifier} onto {way_name}",
        "destination": "Turn {modifier} towards {destination}",
        "junction_name": "Turn {modifier} at {junction_name}"
      },
      "straight": {
        "default": "Continue straight",
        "name": "Continue straight onto {way_name}",
        "destination": "Continue straight towards {destination}",
        "junction_name": "Continue straight at {junction_name}"
      },
      "uturn": {
        "default": "Make a U-turn at the end of the road",
        "name": "Make a U-turn onto {way_name} at the end of the road",
        "destination":
            "Make a U-turn towards {destination} at the end of the road",
        "junction_name": "Make a U-turn at {junction_name}"
      }
    },
    "fork": {
      "default": {
        "default": "Keep {modifier} at the fork",
        "name": "Keep {modifier} onto {way_name}",
        "destination": "Keep {modifier} towards {destination}"
      },
      "slight left": {
        "default": "Keep left at the fork",
        "name": "Keep left onto {way_name}",
        "destination": "Keep left towards {destination}"
      },
      "slight right": {
        "default": "Keep right at the fork",
        "name": "Keep right onto {way_name}",
        "destination": "Keep right towards {destination}"
      },
      "sharp left": {
        "default": "Take a sharp left at the fork",
        "name": "Take a sharp left onto {way_name}",
        "destination": "Take a sharp left towards {destination}"
      },
      "sharp right": {
        "default": "Take a sharp right at the fork",
        "name": "Take a sharp right onto {way_name}",
        "destination": "Take a sharp right towards {destination}"
      },
      "uturn": {
        "default": "Make a U-turn",
        "name": "Make a U-turn onto {way_name}",
        "destination": "Make a U-turn towards {destination}"
      }
    },
    "merge": {
      "default": {
        "default": "Merge {modifier}",
        "name": "Merge {modifier} onto {way_name}",
        "destination": "Merge {modifier} towards {destination}"
      },
      "straight": {
        "default": "Merge",
        "name": "Merge onto {way_name}",
        "destination": "Merge towards {destination}"
      },
      "slight left": {
        "default": "Merge left",
        "name": "Merge left onto {way_name}",
        "destination": "Merge left towards {destination}"
      },
      "slight right": {
        "default": "Merge right",
        "name": "Merge right onto {way_name}",
        "destination": "Merge right towards {destination}"
      },
      "sharp left": {
        "default": "Merge left",
        "name": "Merge left onto {way_name}",
        "destination": "Merge left towards {destination}"
      },
      "sharp right": {
        "default": "Merge right",
        "name": "Merge right onto {way_name}",
        "destination": "Merge right towards {destination}"
      },
      "uturn": {
        "default": "Make a U-turn",
        "name": "Make a U-turn onto {way_name}",
        "destination": "Make a U-turn towards {destination}"
      }
    },
    "new name": {
      "default": {
        "default": "Continue {modifier}",
        "name": "Continue {modifier} onto {way_name}",
        "destination": "Continue {modifier} towards {destination}"
      },
      "straight": {
        "default": "Continue straight",
        "name": "Continue onto {way_name}",
        "destination": "Continue towards {destination}"
      },
      "sharp left": {
        "default": "Take a sharp left",
        "name": "Take a sharp left onto {way_name}",
        "destination": "Take a sharp left towards {destination}"
      },
      "sharp right": {
        "default": "Take a sharp right",
        "name": "Take a sharp right onto {way_name}",
        "destination": "Take a sharp right towards {destination}"
      },
      "slight left": {
        "default": "Continue slightly left",
        "name": "Continue slightly left onto {way_name}",
        "destination": "Continue slightly left towards {destination}"
      },
      "slight right": {
        "default": "Continue slightly right",
        "name": "Continue slightly right onto {way_name}",
        "destination": "Continue slightly right towards {destination}"
      },
      "uturn": {
        "default": "Make a U-turn",
        "name": "Make a U-turn onto {way_name}",
        "destination": "Make a U-turn towards {destination}"
      }
    },
    "notification": {
      "default": {
        "default": "Continue {modifier}",
        "name": "Continue {modifier} onto {way_name}",
        "destination": "Continue {modifier} towards {destination}"
      },
      "uturn": {
        "default": "Make a U-turn",
        "name": "Make a U-turn onto {way_name}",
        "destination": "Make a U-turn towards {destination}"
      }
    },
    "off ramp": {
      "default": {
        "default": "Take the ramp",
        "name": "Take the ramp onto {way_name}",
        "destination": "Take the ramp towards {destination}",
        "exit": "Take exit {exit}",
        "exit_destination": "Take exit {exit} towards {destination}"
      },
      "left": {
        "default": "Take the ramp on the left",
        "name": "Take the ramp on the left onto {way_name}",
        "destination": "Take the ramp on the left towards {destination}",
        "exit": "Take exit {exit} on the left",
        "exit_destination": "Take exit {exit} on the left towards {destination}"
      },
      "right": {
        "default": "Take the ramp on the right",
        "name": "Take the ramp on the right onto {way_name}",
        "destination": "Take the ramp on the right towards {destination}",
        "exit": "Take exit {exit} on the right",
        "exit_destination":
            "Take exit {exit} on the right towards {destination}"
      },
      "sharp left": {
        "default": "Take the ramp on the left",
        "name": "Take the ramp on the left onto {way_name}",
        "destination": "Take the ramp on the left towards {destination}",
        "exit": "Take exit {exit} on the left",
        "exit_destination": "Take exit {exit} on the left towards {destination}"
      },
      "sharp right": {
        "default": "Take the ramp on the right",
        "name": "Take the ramp on the right onto {way_name}",
        "destination": "Take the ramp on the right towards {destination}",
        "exit": "Take exit {exit} on the right",
        "exit_destination":
            "Take exit {exit} on the right towards {destination}"
      },
      "slight left": {
        "default": "Take the ramp on the left",
        "name": "Take the ramp on the left onto {way_name}",
        "destination": "Take the ramp on the left towards {destination}",
        "exit": "Take exit {exit} on the left",
        "exit_destination": "Take exit {exit} on the left towards {destination}"
      },
      "slight right": {
        "default": "Take the ramp on the right",
        "name": "Take the ramp on the right onto {way_name}",
        "destination": "Take the ramp on the right towards {destination}",
        "exit": "Take exit {exit} on the right",
        "exit_destination":
            "Take exit {exit} on the right towards {destination}"
      }
    },
    "on ramp": {
      "default": {
        "default": "Take the ramp",
        "name": "Take the ramp onto {way_name}",
        "destination": "Take the ramp towards {destination}"
      },
      "left": {
        "default": "Take the ramp on the left",
        "name": "Take the ramp on the left onto {way_name}",
        "destination": "Take the ramp on the left towards {destination}"
      },
      "right": {
        "default": "Take the ramp on the right",
        "name": "Take the ramp on the right onto {way_name}",
        "destination": "Take the ramp on the right towards {destination}"
      },
      "sharp left": {
        "default": "Take the ramp on the left",
        "name": "Take the ramp on the left onto {way_name}",
        "destination": "Take the ramp on the left towards {destination}"
      },
      "sharp right": {
        "default": "Take the ramp on the right",
        "name": "Take the ramp on the right onto {way_name}",
        "destination": "Take the ramp on the right towards {destination}"
      },
      "slight left": {
        "default": "Take the ramp on the left",
        "name": "Take the ramp on the left onto {way_name}",
        "destination": "Take the ramp on the left towards {destination}"
      },
      "slight right": {
        "default": "Take the ramp on the right",
        "name": "Take the ramp on the right onto {way_name}",
        "destination": "Take the ramp on the right towards {destination}"
      }
    },
    "rotary": {
      "default": {
        "default": {
          "default": "Enter the roundabout",
          "name": "Enter the roundabout and exit onto {way_name}",
          "destination": "Enter the roundabout and exit towards {destination}"
        },
        "name": {
          "default": "Enter {rotary_name}",
          "name": "Enter {rotary_name} and exit onto {way_name}",
          "destination": "Enter {rotary_name} and exit towards {destination}"
        },
        "exit": {
          "default": "Enter the roundabout and take the {exit_number} exit",
          "name":
              "Enter the roundabout and take the {exit_number} exit onto {way_name}",
          "destination":
              "Enter the roundabout and take the {exit_number} exit towards {destination}"
        },
        "name_exit": {
          "default": "Enter {rotary_name} and take the {exit_number} exit",
          "name":
              "Enter {rotary_name} and take the {exit_number} exit onto {way_name}",
          "destination":
              "Enter {rotary_name} and take the {exit_number} exit towards {destination}"
        }
      }
    },
    "roundabout": {
      "default": {
        "exit": {
          "default": "Enter the roundabout and take the {exit_number} exit",
          "name":
              "Enter the roundabout and take the {exit_number} exit onto {way_name}",
          "destination":
              "Enter the roundabout and take the {exit_number} exit towards {destination}"
        },
        "default": {
          "default": "Enter the roundabout",
          "name": "Enter the roundabout and exit onto {way_name}",
          "destination": "Enter the roundabout and exit towards {destination}"
        }
      }
    },
    "roundabout turn": {
      "default": {
        "default": "Make a {modifier}",
        "name": "Make a {modifier} onto {way_name}",
        "destination": "Make a {modifier} towards {destination}"
      },
      "left": {
        "default": "Turn left",
        "name": "Turn left onto {way_name}",
        "destination": "Turn left towards {destination}"
      },
      "right": {
        "default": "Turn right",
        "name": "Turn right onto {way_name}",
        "destination": "Turn right towards {destination}"
      },
      "straight": {
        "default": "Continue straight",
        "name": "Continue straight onto {way_name}",
        "destination": "Continue straight towards {destination}"
      }
    },
    "exit roundabout": {
      "default": {
        "default": "Exit the roundabout",
        "name": "Exit the roundabout onto {way_name}",
        "destination": "Exit the roundabout towards {destination}"
      }
    },
    "exit rotary": {
      "default": {
        "default": "Exit the roundabout",
        "name": "Exit the roundabout onto {way_name}",
        "destination": "Exit the roundabout towards {destination}"
      }
    },
    "turn": {
      "default": {
        "default": "Make a {modifier}",
        "name": "Make a {modifier} onto {way_name}",
        "destination": "Make a {modifier} towards {destination}",
        "junction_name": "Make a {modifier} at {junction_name}"
      },
      "left": {
        "default": "Turn left",
        "name": "Turn left onto {way_name}",
        "destination": "Turn left towards {destination}",
        "junction_name": "Turn left at {junction_name}"
      },
      "right": {
        "default": "Turn right",
        "name": "Turn right onto {way_name}",
        "destination": "Turn right towards {destination}",
        "junction_name": "Turn right at {junction_name}"
      },
      "straight": {
        "default": "Go straight",
        "name": "Go straight onto {way_name}",
        "destination": "Go straight towards {destination}",
        "junction_name": "Go straight at {junction_name}"
      }
    },
    "use lane": {
      "no_lanes": {"default": "Continue straight"},
      "default": {"default": "{lane_instruction}"}
    }
  }
};
