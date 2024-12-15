import 'dart:math';

/// Utility functions that are used my both PolyUtil and SphericalUtil.
///
/// credit from [https://github.com/KohlsAdrian/google_maps_utils/blob/master/lib/utils/math_utils.dart]
class MathUtil {
  /// Restrict x to the range [low, high].
  static double clamp(double x, double low, double high) {
    return x < low ? low : (x > high ? high : x);
  }

  /// Wraps the given value into the inclusive-exclusive interval between min and max.
  ///
  /// @param n   The value to wrap.
  /// @param min The minimum.
  /// @param max The maximum.
  static double wrap(double n, double min, double max) {
    return (n >= min && n < max) ? n : (mod(n - min, max - min) + min);
  }

  /// Returns the non-negative remainder of x / m.
  ///
  /// @param x The operand.
  /// @param m The modulus.
  static double mod(double x, double m) {
    return ((x % m) + m) % m;
  }

  /// Returns mercator Y corresponding to latitude.
  /// See http://en.wikipedia.org/wiki/Mercator_projection .
  static double mercator(double lat) {
    return log(tan(lat * 0.5 + pi / 4));
  }

  /// Returns latitude from mercator Y.
  static double inverseMercator(double y) {
    return 2 * atan(exp(y)) - pi / 2;
  }

  /// Returns haversine(angle-in-radians).
  /// hav(x) == (1 - cos(x)) / 2 == sin(x / 2)^2.
  static double hav(double x) {
    double sinHalf = sin(x * 0.5);
    return sinHalf * sinHalf;
  }

  static double inverseHaversine(double value) {
    return 2 * asin(sqrt(value));
  }

  /// Computes inverse haversine. Has good numerical stability around 0.
  /// arcHav(x) == acos(1 - 2 * x) == 2 * asin(sqrt(x)).
  /// The argument must be in [0, 1], and the result is positive.
  static double arcHav(double x) {
    return 2 * asin(sqrt(x));
  }

  // Given h==hav(x), returns sin(abs(x)).
  static double sinFromHav(double h) {
    return 2 * sqrt(h * (1 - h));
  }

  // Returns hav(asin(x)).
  static double havFromSin(double x) {
    double x2 = x * x;
    return x2 / (1 + sqrt(1 - x2)) * .5;
  }

  // Returns sin(arcHav(x) + arcHav(y)).
  static double sinSumFromHav(double x, double y) {
    double a = sqrt(x * (1 - x));
    double b = sqrt(y * (1 - y));
    return 2 * (a + b - 2 * (a * y + b * x));
  }

  /// Returns hav() of distance from (lat1, lng1) to (lat2, lng2) on the unit sphere.
  static double havDistance(double lat1, double lat2, double dLng) {
    return hav(lat1 - lat2) + hav(dLng) * cos(lat1) * cos(lat2);
  }

  static double sinDeltaBearing(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
    double lat3,
    double lng3,
  ) {
    double sinLat1 = sin(lat1);
    double cosLat2 = cos(lat2);
    double cosLat3 = cos(lat3);
    double lat31 = lat3 - lat1;
    double lng31 = lng3 - lng1;
    double lat21 = lat2 - lat1;
    double lng21 = lng2 - lng1;
    double a = sin(lng31) * cosLat3;
    double c = sin(lng21) * cosLat2;
    double b = sin(lat31) + 2 * sinLat1 * cosLat3 * MathUtil.hav(lng31);
    double d = sin(lat21) + 2 * sinLat1 * cosLat2 * MathUtil.hav(lng21);
    double denom = (a * a + b * b) * (c * c + d * d);
    return denom <= 0 ? 1 : (a * d - b * c) / sqrt(denom);
  }
}
