## Routing Client Dart Package
![pub](https://img.shields.io/badge/pub-v0.2.0-orange)


> Package for osm routing client api 

> for now this package support only server based on osrm-backendi

### client api support

* OSRM Client Api

## Installing

Add the following to your `pubspec.yaml` file:

    dependencies:
      routing_client_dart: ^0.2.0


### example 

```dart
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
      languageCode: "en",
    );
```
