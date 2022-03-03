## Routing Client Dart Package
![pub](https://img.shields.io/badge/pub-v0.3.1-orange)


> Package for osm routing client api 

> for now this package support only server based on osrm-backend

### client api support

* OSRM Client Api 
  * route service
  * trip service

## Installing

Add the following to your `pubspec.yaml` file:

    dependencies:
      routing_client_dart: ^0.3.1


### example for route service

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

### example for trip service

```dart
List<LngLat> waypoints = [
      LngLat(lng: 13.388860, lat: 52.517037),
      LngLat(lng: 13.397634, lat: 52.529407),
      LngLat(lng: 13.428555, lat: 52.523219),
    ];
    final manager = OSRMManager();
    final road = await manager.getTrip(
      waypoints: waypoints,
      roudTrip:true,
      destination: DestinationGeoPointOption.last,
      source: SourceGeoPointOption.first,
      geometrie: Geometries.polyline,
      steps: true,
      languageCode: "en",
    );
```