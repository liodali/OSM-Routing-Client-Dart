import 'dart:convert';

import 'package:dio/dio.dart';

import 'models/lng_lat.dart';
import 'utilities/utils.dart';

class OSRMManager {
  final String server;
  final RoadType roadType;
  final dio = Dio();

  OSRMManager()
      : server = oSRMServer,
        roadType = RoadType.car;

  OSRMManager.custom({
    required this.server,
    this.roadType = RoadType.car,
  });

  Future getRoad({
    required List<LngLat> waypoints,
    RoadType roadType = RoadType.car,
    int alternative = 0,
    bool steps = true,
    Overview overview = Overview.full,
    Geometries geometrie = Geometries.geojson,
  }) async {
    String path = await generatePath(
      waypoints.toWaypoints(),
      alternative: alternative,
      steps: steps,
      overview: overview,
      geometrie: geometrie,
    );
    final response = await dio.get(path);
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.data);
    } else {
      return null;
    }
  }
}

extension OSRMPrivateFunct on OSRMManager {
  @visibleForTesting
  String generatePath(
    String waypoints, {
    RoadType roadType = RoadType.car,
    int alternative = 0,
    bool steps = true,
    Overview overview = Overview.full,
    Geometries geometrie = Geometries.polyline,
  })  {
    String url = "$server/routed-${roadType.value}/route/v1/diving/$waypoints";
    String option = "";
    option += "alternatives=${alternative <= 0 ? false : alternative}&";
    option += "steps=$steps&";
    option += "overview=${overview.value}&";
    option += "geometries=${geometrie.value}";

    return "$url${option.isNotEmpty ? "?$option" : ""}";
  }
}
