## 1.0.7:
* remove isolate to support wasm
* bump dart sdk to 3.7
## 1.0.6:
* fix nextInstruction implementation
* decode geometry in osrm road if geometry as given is string
## 1.0.5:
* fix copy instruction in getOSRMRoad #26
## 1.0.4:
* improve internally osrm_service,valhalla_service
## 1.0.3:
* change the name RoadType to `RoutingType`
## 1.0.2:
* export route model 
## 1.0.1: 
* forget to export OSRMRequest & ValhallaRequest
## 1.0.0: add valhalla route API
* break changes:
    * replace OSRMManager with RoutingManager
    * replace getRoad with getRoute
    * remove buildInstruction ( becone integrated automatically with route object )
    * replace Road by Route
    * replace return of OSRM api to OSRMRoad
* create OSRMService for osrm apis
* create ValhallaService for valhalla apis

## 0.5.5: fix bug
* fix bug related to generate path for getRoute
## 0.5.4:
* remove unnecessary dependency
* add check for nullable in road for attribute geometry
* thanks for @eshjordan, @derklaro  for their contribution 
## 0.5.3:
* add destinations to get all destination from road
## 0.5.2:
* remove some unnecessary files
## 0.5.1:
* fix bug
## 0.5.0: 
* add `isOnPath`,`nextInstruction` in OSRMManager
* support new languages for instructions
## 0.4.3: fix bug #16
* fix compute `parseRoad`in mobile platform
## 0.4.2: fix bugs
* fix load json for instructionsHelper
## 0.4.1: fix bugs
* fix uninitialized dio in OSRMManager default constructor
* remove instructions from road classes
## 0.4.0: re-implementation for buildInstruction
## 0.3.2: update dependency
## 0.3.1:
* fix parse route when configure geometry to geojson
* add new attribute polyline
## 0.3.0+1:
* fix parse data
## 0.3.0: trip service
* add new method `getTrip` that implement req call to trip service for osrm
## 0.2.0:  
* add get route alternatives inside road
## 0.1.1: fix parse json
* fix parse duration value from road json
## 0.1.0:
* support osrm client
* add example in readme