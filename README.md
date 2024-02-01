## Routing Client Dart Package
![pub](https://img.shields.io/badge/pub-v0.5.3-orange)


> Package for osm routing client api 

> for now this package support only server based on osrm-backend

### client api support

* OSRM Client Api 
  * route service
  * trip service

## Installing

Add the following to your `pubspec.yaml` file:

    dependencies:
      routing_client_dart: ^0.5.3


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
      geometries: Geometries.polyline,
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
      roundTrip:false,
      source: SourceGeoPointOption.first,
      destination: DestinationGeoPointOption.last,
      geometries: Geometries.polyline,
      steps: true,
      languageCode: "en",
    );
```

### build instruction from road

```dart
    final instructions = await manager.buildInstructions(road);
```

### example for check Location in Road

```dart
final currentLocation = LngLat.fromList(lnglat: [13.389147, 52.527549]);
    final isOnPath =
await roadManager.isOnPath(road, currentLocation, tolerance: 5);
```

### Example to get next navigation instruction of current Location



```dart
final currentLocation = LngLat.fromList(lnglat: [13.389147, 52.527549]);
    final isOnPath =
final instruction = await roadManager.nextInstruction(instructions, road, currentLocation, tolerance: 5);

```
**Warning** the precision of `LngLat` should be 5 if the road contain `polylineEncoded`, or the same precies as `LngLat` in `polylines`

**Note** you can get some inaccurate information `nextInstruction`,for that we will be happy for yours contributions
