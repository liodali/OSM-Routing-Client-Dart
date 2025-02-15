import 'package:routing_client_dart/src/models/route.dart';
import 'package:routing_client_dart/src/models/valhalla/valhalla_response.dart';
import 'package:routing_client_dart/src/utilities/utils.dart';
import 'package:routing_client_dart/src/utilities/valhalla_utilities.dart';

extension TripValhallaExt on Trip {
  Route toRoute({
    ValhallaUnit unit = ValhallaUnit.km,
    int accuracyExponent = 6,
  }) {
    final shapes = legs
        .map((e) => e.shape.decodeGeometry(precision: 6))
        .reduce((l1, l2) => l1 + l2);
    final insturctions =
        legs
            .map(
              (e) => e.maneuvers?.map(
                (m) => ValhallaRouteInstruction(
                  distance: switch (unit) {
                    (ValhallaUnit.km) => m.length,
                    _ => m.length * 1.6,
                  },
                  duration: m.time,
                  instruction: m.instruction,
                  verbalPostinstruction: m.verbalPostTransitionInstruction,
                  verbalPreinstruction: m.verbalPreTransitionInstruction,
                  location: shapes[m.beginShapeIndex],
                  endInstructionLocation: shapes[m.endShapeIndex],
                ),
              ),
            )
            .reduce(
              (l1, l2) =>
                  l1 != null && l2 != null ? l1.toList() + l2.toList() : null,
            )
            ?.toList();
    final road = Route(
      distance: switch (unit) {
        ValhallaUnit.km => summary.length,
        ValhallaUnit.miles => summary.length * 1.609344,
      },
      duration: summary.time,
      instructions: insturctions ?? [],
      polyline: shapes,
      polylineEncoded: shapes.encodeGeometry(),
    );

    return road;
  }
}
