import 'dart:ui' show lerpDouble;

/// Internal deferred interpolation for defaults supplied by the consuming token.
class TokenDoubleLerp {
  const TokenDoubleLerp(
    this.begin,
    this.beginLerp,
    this.end,
    this.endLerp,
    this.t,
  );

  final double? begin;
  final TokenDoubleLerp? beginLerp;
  final double? end;
  final TokenDoubleLerp? endLerp;
  final double t;

  double resolve(double fallback) => lerpDouble(
    beginLerp?.resolve(fallback) ?? begin ?? fallback,
    endLerp?.resolve(fallback) ?? end ?? fallback,
    t,
  )!;

  static TokenDoubleLerp? between(
    double? begin,
    TokenDoubleLerp? beginLerp,
    double? end,
    TokenDoubleLerp? endLerp,
    double t,
  ) => begin == null && end == null && beginLerp == null && endLerp == null
      ? null
      : TokenDoubleLerp(begin, beginLerp, end, endLerp, t);
}

/// Deferred interpolation for token-backed geometry supplied by the consumer.
class TokenValueLerp<T> {
  const TokenValueLerp(
    this.begin,
    this.beginLerp,
    this.end,
    this.endLerp,
    this.t,
    this.interpolate,
  );

  final T? begin;
  final TokenValueLerp<T>? beginLerp;
  final T? end;
  final TokenValueLerp<T>? endLerp;
  final double t;
  final T Function(T, T, double) interpolate;

  T resolve(T fallback) => interpolate(
    beginLerp?.resolve(fallback) ?? begin ?? fallback,
    endLerp?.resolve(fallback) ?? end ?? fallback,
    t,
  );

  static TokenValueLerp<T>? between<T>(
    T? begin,
    TokenValueLerp<T>? beginLerp,
    T? end,
    TokenValueLerp<T>? endLerp,
    double t,
    T Function(T, T, double) interpolate,
  ) => begin == null && end == null && beginLerp == null && endLerp == null
      ? null
      : TokenValueLerp(begin, beginLerp, end, endLerp, t, interpolate);
}
