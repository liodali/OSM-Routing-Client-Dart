import 'package:flutter_test/flutter_test.dart';
import 'package:osrm_dart/osrm_dart.dart';
import 'package:osrm_dart/src/models/lng_lat.dart';
import 'package:osrm_dart/src/osrm_manager.dart';
import 'package:osrm_dart/src/utilities/utils.dart';

void main() {
  test("transform waypoint to string", (){
    List<LngLat> waypoints = [
      LngLat(lng: 13.388860, lat: 52.517037),
      LngLat(lng: 13.397634, lat: 52.529407),
      LngLat(lng: 13.428555, lat: 52.523219),
    ];
    expect(waypoints.toWaypoints(), "13.38886,52.517037;13.397634,52.529407;13.428555,52.523219");
  });
  test("test generate URL", () {
    String waypoint =
        "13.388860,52.517037;13.397634,52.529407;13.428555,52.523219";
    final manager = OSRMManager();
    final urlGenerated = manager.generatePath(
      waypoint,
      geometrie: Geometries.polyline,
      steps: true,
    );
    String shouldBrUrl = "$oSRMServer/routed-car/route/v1/diving/$waypoint?alternatives=false&steps=true&overview=full&geometries=polyline";
    expect(urlGenerated, shouldBrUrl);
  });

  test("test get road ", ()async {
    List<LngLat> waypoints = [
      LngLat(lng: 13.388860, lat: 52.517037),
      LngLat(lng: 13.397634, lat: 52.529407),
      LngLat(lng: 13.428555, lat: 52.523219),
    ];
    final manager = OSRMManager();
    final road = await manager.getRoad(
      waypoints: waypoints,
      geometrie: Geometries.polyline,
      steps: true,
      languageCode: "en"
    );
    expect(road.distance, 4.7238);
  });


}
