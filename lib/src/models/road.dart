import 'package:osrm_dart/src/models/lng_lat.dart';

class Road {
  final double distance;
  final double time;
  List<RoadInstructions> instructions = [];

  Road.minimize({required this.distance, required this.time});

  Road({
    required this.distance,
    required this.time,
    required this.instructions,
  });

  Road.withError()
      : time = 0.0,
        distance = 0.0;
}

class RoadInstructions {
  final String instruction;
  final LngLat location;

  RoadInstructions({
    required this.instruction,
    required this.location,
  });
}
