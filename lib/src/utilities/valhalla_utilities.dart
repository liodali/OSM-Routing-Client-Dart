enum ValhallaFormat { json, orsm, gpx, pbf }

enum ValhallaUnit { miles, km }

enum ValhallaDirectionsType { instructions, maneuvers, none }

enum ValhallaCoasting { auto, bus, taxi, pedestrian, bicycle }

enum ValhallaSpeedTypes { freeflow, constrained, predicted, current }

enum ValhallaBicycleType {
  /// a road-style bicycle with narrow tires that is generally lightweight and designed for speed on paved surfaces.
  road("Road"),

  /// a bicycle made mostly for city riding or casual riding on roads and paths with good surfaces.
  hybrid("Hybrid"),
  city("City"),

  /// a cyclo-cross bicycle, which is similar to a road bicycle but with wider tires suitable to rougher surfaces.
  cross("Cross"),

  /// a mountain bicycle suitable for most surfaces but generally heavier and slower on paved surfaces.
  mountain("Mountain");

  const ValhallaBicycleType(this.name);

  final String name;
}
