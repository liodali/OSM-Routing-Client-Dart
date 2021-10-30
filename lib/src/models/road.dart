import 'package:osrm_dart/src/models/lng_lat.dart';

class Road {
  final double distance;
  final double duration;
  List<RoadInstruction> instructions = [];
  final String polylineEncoded;
  bool _isError = false;
  RoadDetailInfo details = RoadDetailInfo();

  Road.empty()
      : distance = 0.0,
        duration = 0.0,
        polylineEncoded = "";

  Road.minimize({
    required this.distance,
    required this.duration,
    required this.polylineEncoded,
  });

  Road({
    required this.distance,
    required this.duration,
    required this.instructions,
    required this.polylineEncoded,
  });

  Road.withError()
      : duration = 0.0,
        distance = 0.0,
        polylineEncoded = "",
        _isError = true;

  bool get canDrawRoad => !_isError;

  Road copyWith({
    double? distance,
    double? duration,
    List<RoadInstruction>? instructions,
    String? polylineEncoded,
  }) {
    return Road(
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      instructions: instructions ?? this.instructions,
      polylineEncoded: polylineEncoded ?? this.polylineEncoded,
    );
  }
}

class RoadInstruction {
  double distance;
  double duration;
  final String instruction;
  final LngLat location;

  RoadInstruction({

    required this.distance,
    required this.duration,
    required this.instruction,
    required this.location,
  });
}

class RoadDetailInfo {
  List<RoadLeg> roadLegs = [];
  RoadDetailInfo();
}

class RoadLeg {
  final double distance;
  final double duration;

  RoadLeg(
    this.distance,
    this.duration,
  );
}

