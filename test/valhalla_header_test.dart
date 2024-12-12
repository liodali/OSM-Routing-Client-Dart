import 'package:flutter_test/flutter_test.dart';
import 'package:routing_client_dart/routing_client_dart.dart';
import 'package:routing_client_dart/src/models/request_helper.dart';

void main() {
  test('test assert empty waypoints in valhalla header', () {
    expect(() => ValhallaRequest(waypoints: []), throwsA(isA<AssertionError>()));
    expect(
      () => ValhallaRequest(waypoints: [
        LngLat(
          lng: -73.991379,
          lat: 40.730930,
        )
      ]),
      throwsA(
        isA<AssertionError>(),
      ),
    );
    expect(
      () => ValhallaRequest(waypoints: [
        LngLat(
          lng: -73.991379,
          lat: 40.730930,
        ),
        LngLat(
          lng: -73.991379,
          lat: 40.730930,
        ),
        LngLat(
          lng: -73.991379,
          lat: 40.730930,
        )
      ]),
      throwsA(
        isA<AssertionError>(),
      ),
    );
  });
  test('test valhalla header', () {
    final header = ValhallaRequest(
      waypoints: [
        LngLat(
          lng: -73.991379,
          lat: 40.730930,
        ),
        LngLat(
          lng: -73.991562,
          lat: 40.749706,
        ),
      ],
    );
    expect(header.encodeHeader(), {
      'locations': [
        {
          "lat": 40.730930,
          "lon": -73.991379,
        },
        {
          "lat": 40.749706,
          "lon": -73.991562,
        },
      ],
      'costing': 'auto',
      'units': 'km',
      'language': 'en-US',
      'directions_type': 'instructions',
      'format': 'json',
      'alternates': 2,
    });
  });
}
