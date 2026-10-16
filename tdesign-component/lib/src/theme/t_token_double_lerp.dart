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
