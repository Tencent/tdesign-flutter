/// CSS declaration sets supplied separately for each mode and shared metrics.
class CssThemeParts {
  /// Creates CSS parts. [extra] overrides declarations in each mode.
  const CssThemeParts({
    required this.light,
    required this.dark,
    this.extra = '',
  });

  /// Light-mode declarations.
  final String light;

  /// Dark-mode declarations.
  final String dark;

  /// Shared declarations, such as font metrics and dimensions.
  final String extra;
}

/// Sparse overrides for TDesign Flutter theme adapters.
///
/// Absent or unsupported CSS values are omitted. Merge each result into the
/// receiver's pristine default theme rather than the previous override result.
class FlutterThemeTokens {
  /// Creates token groups. Each map uses the current Flutter token names.
  const FlutterThemeTokens({
    required this.ref,
    required this.color,
    required this.font,
    required this.fontMetric,
    required this.radius,
    required this.shadow,
    required this.insetShadow,
    required this.margin,
  });

  /// Semantic color references to leaf palette tokens.
  final Map<String, Object> ref;

  /// Colors in Flutter #RRGGBB or #AARRGGBB notation.
  final Map<String, Object> color;

  /// Sparse composite font fields: size and/or lineHeight.
  ///
  /// The receiver fills omitted fields and weight from its own default theme.
  final Map<String, Object> font;

  /// Independent font size and line-height metrics.
  final Map<String, Object> fontMetric;

  /// Nonnegative logical-pixel radii.
  final Map<String, Object> radius;

  /// Outer shadows, represented as lists of layer maps.
  final Map<String, Object> shadow;

  /// Edge inset shadows represented by color and width.
  final Map<String, Object> insetShadow;

  /// Global Flutter spacers (the protocol group is named margin).
  final Map<String, Object> margin;

  /// Returns a JSON-serializable map; no Flutter objects are included.
  Map<String, Object> toJson() => {
        'ref': ref,
        'color': color,
        'font': font,
        'fontMetric': fontMetric,
        'radius': radius,
        'shadow': shadow,
        'insetShadow': insetShadow,
        'margin': margin,
      };
}

/// Independent light and dark token overrides.
class FlutterThemeOverrides {
  /// Creates the two converted modes.
  const FlutterThemeOverrides({required this.light, required this.dark});

  /// Overrides applied to the receiver's default light theme.
  final FlutterThemeTokens light;

  /// Overrides applied to the receiver's default dark theme.
  final FlutterThemeTokens dark;

  /// Returns the existing light/dark Flutter JSON protocol structure.
  Map<String, Object> toJson() => {
        'light': light.toJson(),
        'dark': dark.toJson(),
      };
}
