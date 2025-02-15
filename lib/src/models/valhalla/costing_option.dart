import 'package:routing_client_dart/src/utilities/utils.dart';
import 'package:routing_client_dart/src/utilities/valhalla_utilities.dart';

enum AutomobileCostingOption { auto, taxi, bus }

abstract class BaseCostingOption {
  Map<String, dynamic> toMap();
}

class CostingOption extends BaseCostingOption {
  final AutomobileCostingOption automobileCostingOption;
  final int topSpeed;
  final int? fixedSpeed;
  final double? height;
  final double? width;
  final double useHighways;
  final double useTolls;
  final double useLivingStreets;
  final double useTracks;
  final double useFerry;
  final ValhallaSpeedTypes? speedTypes;
  CostingOption({
    this.automobileCostingOption = AutomobileCostingOption.auto,
    this.topSpeed = 45,
    this.fixedSpeed,
    this.speedTypes,
    this.height,
    this.width,
    this.useHighways = 0.5,
    this.useTolls = 0.5,
    this.useLivingStreets = 0.1,
    this.useTracks = 0.5,
    this.useFerry = 0.5,
  });
  @override
  Map<String, dynamic> toMap() =>
      {
          'top_speed': topSpeed,
          'useTolls': useTolls,
          'speed_types': speedTypes,
          'use_highways': useHighways,
          'use_tracks': useTracks,
          'use_living_streets': useLivingStreets,
          'use_ferry': useFerry,
        }
        ..addIfNotNull('height', height)
        ..addIfNotNull('width', width)
        ..addIfNotNull('fixed_speed', fixedSpeed);
}

class TransitCostingOption extends BaseCostingOption {
  /// User's desire to use buses. Range of values from 0 (try to avoid buses) to 1 (strong preference for riding buses).
  final double useBus;

  /// User's desire to use rail/subway/metro. Range of values from 0 (try to avoid rail) to 1 (strong preference for riding rail).
  final double useRail;

  /// User's desire to favor transfers. Range of values from 0 (try to avoid transfers) to 1 (totally comfortable with transfers).
  final double useTransfers;

  TransitCostingOption({
    this.useBus = 0.5,
    this.useRail = 0.5,
    this.useTransfers = 0.5,
  }) : assert(
         useBus >= 0 && useBus <= 1,
         'useBus value should be only between [0,1]',
       ),
       assert(
         useRail >= 0 && useRail <= 1,
         'useRail value should be only between [0,1]',
       ),
       assert(
         useTransfers >= 0 && useTransfers <= 1,
         'useTransfers value should be only between [0,1]',
       );

  @override
  Map<String, dynamic> toMap() => {
    'use_bus': useBus,
    'use_rail': useRail,
    'use_transfers': useTransfers,
  };
}

class TruckCostingOption extends CostingOption {
  final double length;
  final double weight;
  final double axleLoad;
  final double axleCount;
  final bool hazmat;
  final double? useTruckRoute;
  TruckCostingOption({
    super.topSpeed,
    super.speedTypes,
    super.fixedSpeed,
    super.useLivingStreets,
    super.width,
    super.height,
    super.useFerry,
    super.useHighways,
    super.useTolls,
    super.useTracks,
    this.length = 21.64,
    this.weight = 21.77,
    this.axleLoad = 9.07,
    this.axleCount = 5,
    this.hazmat = false,
    this.useTruckRoute = 1,
  });

  @override
  Map<String, dynamic> toMap() =>
      super.toMap()..addAll({
        "length": length,
        "weight": weight,
        "axle_oad": axleLoad,
        "axlecount": axleCount,
        "hazmat": hazmat,
        "use_truck_route": useTruckRoute,
      });
}

class MotorScooterCostingOption extends BaseCostingOption {
  /// Top speed the motorized scooter can go. Used to avoid roads with higher speeds than this value.
  final int topSpeed;

  /// A rider's propensity to use primary roads. This is a range of values from 0 to 1,
  /// where 0 attempts to avoid primary roads, and 1 indicates the rider is more comfortable riding on primary roads.
  ///  Based on the use_primary factor, roads with certain classifications
  /// and higher speeds are penalized in an attempt to avoid them when finding the best path. The default value is 0.5.
  final double usePrimary;

  /// A rider's desire to tackle hills in their routes.
  /// This is a range of values from 0 to 1, where 0 attempts to avoid hills and steep grades
  /// even if it means a longer (time and distance) path, while 1 indicates the rider does not fear hills and steeper grades. Based on the use_hills factor, penalties are applied to roads based on elevation change and grade. These penalties help the path avoid hilly roads in favor of flatter roads or less steep grades where available. Note that it is not always possible to find alternate paths to avoid hills
  /// (for example when route locations are in mountainous areas). The default value is 0.5.
  final double useHills;

  /// hanges the metric to quasi-shortest, i.e. purely distance-based costing.
  /// Note, this will disable all other costings & penalties.
  ///  Also note, shortest will not disable hierarchy pruning,
  /// leading to potentially sub-optimal routes for some costing models. The default is false.
  final bool shortest;

  MotorScooterCostingOption({
    this.topSpeed = 45,
    this.usePrimary = 1,
    this.useHills = 0,
    this.shortest = false,
  });

  @override
  Map<String, dynamic> toMap() => {
    "top_speed": topSpeed,
    "use_Primary": usePrimary,
    "use_hills": useHills,
    "shortest": shortest,
  };
}

class BicycleCostingOption extends BaseCostingOption {
  final ValhallaBicycleType bicycleType;
  final double cyclingSpeed;
  final double useRoads;
  final double useHills;
  final double useFerry;
  final double useLivingStreets;
  final double avoidBadAurfaces;
  final bool shortest;

  BicycleCostingOption({
    this.bicycleType = ValhallaBicycleType.hybrid,
    required this.cyclingSpeed,
    this.useRoads = 0.5,
    this.useHills = 0.5,
    this.useFerry = 0.5,
    this.useLivingStreets = 0.5,
    this.avoidBadAurfaces = 0.25,
    this.shortest = false,
  }) : assert(useFerry >= 0 || useFerry <= 1.0),
       assert(useHills >= 0 || useHills <= 1.0),
       assert(useLivingStreets >= 0 || useLivingStreets <= 1.0),
       assert(avoidBadAurfaces >= 0 || avoidBadAurfaces <= 1.0),
       assert(useRoads >= 0 || useRoads <= 1.0);

  @override
  Map<String, dynamic> toMap() => {
    "bicycle_type": bicycleType.name,
    "cycling_speed": cyclingSpeed,
    "use_roads": useRoads,
    "use_hills": useHills,
    "use_ferry": useFerry,
    "use_living_streets": useLivingStreets,
    "avoid_bad_surfaces": avoidBadAurfaces,
    "shortest": shortest,
  };
}

class PedestrianCostingOption extends BaseCostingOption {
  final double walkingSpeed;
  final double walkwayFactor;
  final double? maxDistance;
  final double useLivingStreets;
  final double useTracks;
  final double useFerry;
  final bool shortest;
  final int servicePenalty;
  final int serviceFactor;
  final double useHills;
  final double sidewalkFactor;
  final double alleyFactor;
  final double drivewayFactor;
  final int stepPenalty;
  final int maxHikingDifficulty;
  final int useLit;
  final int? transitStartEndMaxDistance;
  final int? transitTransferMaxDistance;
  PedestrianCostingOption({
    this.walkingSpeed = 5.1,
    this.walkwayFactor = 1.0,
    this.maxDistance = 100,
    this.useLivingStreets = 0.5,
    this.useTracks = 0.5,
    this.useFerry = 0.5,
    this.shortest = false,
    this.servicePenalty = 0,
    this.serviceFactor = 1,
    this.useHills = 0.5,
    this.sidewalkFactor = 1,
    this.alleyFactor = 2,
    this.drivewayFactor = 5.0,
    this.stepPenalty = 0,
    this.maxHikingDifficulty = 1,
    this.useLit = 0,
    this.transitStartEndMaxDistance,
    this.transitTransferMaxDistance,
  }) : assert(useFerry >= 0 || useFerry <= 1.0),
       assert(useTracks >= 0 || useTracks <= 1.0),
       assert(useLit >= 0 || useLivingStreets <= 1.0),
       assert(useLivingStreets >= 0 || useLivingStreets <= 1.0),
       assert(maxHikingDifficulty >= 0 || useLivingStreets <= 6.0),
       assert(walkingSpeed >= 0.5 || walkingSpeed <= 25.0);
  @override
  Map<String, dynamic> toMap() {
    final map = {
      'walking_speed': walkingSpeed,
      'walkway_factor': walkwayFactor,
      'use_tracks': useTracks,
      'use_ferry': useFerry,
      'use_living_streets': useLivingStreets,
      'shortest': shortest,
      'service_penalty': servicePenalty,
      'service_factor': 1,
      'use_hills': 0.5,
      'sidewalk_factor': 1,
      'alley_factor': 2,
      'driveway_factor': 5,
      'step_penalty': 0,
      'max_hiking_difficulty': 1,
      'use_lit': 0,
      'transit_start_end_max_distance': 2145,
      'transit_transfer_max_distance': 800,
    };

    if (maxDistance != null) {
      map.putIfAbsent('max_distance', () => maxDistance!);
    }
    if (transitStartEndMaxDistance != null) {
      map.putIfAbsent(
        'transit_start_end_max_distance',
        () => transitStartEndMaxDistance!,
      );
    }
    if (transitTransferMaxDistance != null) {
      map.putIfAbsent(
        'transit_transfer_max_distance',
        () => transitTransferMaxDistance!,
      );
    }
    return map;
  }
}

String costingOptionNameKey(BaseCostingOption option) => switch (option) {
  PedestrianCostingOption _ => 'pedestrian',
  BicycleCostingOption _ => 'bicycle',
  MotorScooterCostingOption _ => 'transit',
  TruckCostingOption _ => 'truck',
  TransitCostingOption _ => 'transit',
  CostingOption option => option.automobileCostingOption.name,
  _ => throw Exception('Unkonw BaseCostingOption type'),
};
