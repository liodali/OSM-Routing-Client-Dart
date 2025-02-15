## Routing Client Dart Package
![pub](https://img.shields.io/badge/pub-v1.0.7-blue)


> Package for osm routing client api 

> we support routing API for osrm-backend

> also Valhalla Route API (more APIs will be added )

> openrouteservice (coming soon)

> from 1.0.0 instruction will be included directly when requesting the route

> you can use our osrm service or valhalla service directly insteado of our RoutingManager

### client api support

* OSRM Client Api 
  * route service
  * trip service
* Valhalla Client
  * route service API

## Installing

Add the following to your `pubspec.yaml` file:

    dependencies:
      routing_client_dart: ^1.0.7


### example for osrm route service

```dart
    List<LngLat> waypoints = [
      LngLat(lng: 13.388860, lat: 52.517037),
      LngLat(lng: 13.397634, lat: 52.529407),
      LngLat(lng: 13.428555, lat: 52.523219),
    ];
    final manager = RoutingManager();
    final route = await manager.getRoute(
      OSRMRequest.route(
        waypoints: waypoints,
        geometries: Geometries.polyline,
        steps: true,
        languages: Languages.en,
      )
    );
```

### example for osrm trip service

```dart
    List<LngLat> waypoints = [
      LngLat(lng: 13.388860, lat: 52.517037),
      LngLat(lng: 13.397634, lat: 52.529407),
      LngLat(lng: 13.428555, lat: 52.523219),
    ];
    final manager = RoutingManager();
    final road = await manager.getRoute(
      OSRMRequest.trip(
        waypoints: waypoints,
        destination: DestinationGeoPointOption.last,
        source: SourceGeoPointOption.first,
        geometries: Geometries.polyline,
        steps: true,
        languages: Languages.en,
        roundTrip:false,
      )
    );
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

**Note** you can get voice instruction for valhalla instruction

**Note** more documentation will be added to soon
