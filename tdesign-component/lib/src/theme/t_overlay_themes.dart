import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Retains local inherited themes while allowing the overlay's global theme
/// to keep changing after it opens.
@internal
class TOverlayThemes {
  TOverlayThemes.capture({required BuildContext from, required BuildContext to})
    : _captured = InheritedTheme.capture(from: from, to: to),
      _baseline = Theme.of(to);

  final CapturedThemes _captured;
  final ThemeData _baseline;

  Widget wrap(BuildContext context, Widget child) => Builder(
    builder: (context) {
      final live = Theme.of(context);
      return _captured.wrap(
        Builder(
          builder: (context) {
            final local = Theme.of(context);
            return Theme(
              data: local.copyWith(
                brightness: local.brightness == _baseline.brightness
                    ? live.brightness
                    : local.brightness,
                colorScheme: local.colorScheme == _baseline.colorScheme
                    ? live.colorScheme
                    : local.colorScheme,
                textTheme: local.textTheme == _baseline.textTheme
                    ? live.textTheme
                    : local.textTheme,
                extensions: {
                  ...live.extensions,
                  for (final entry in local.extensions.entries)
                    if (entry.value != _baseline.extensions[entry.key])
                      entry.key: entry.value,
                }.values,
              ),
              child: child,
            );
          },
        ),
      );
    },
  );
}
