import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/theme/t_overlay_themes.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  for (final scoped in [false, true]) {
    testWidgets('opened overlay follows global theme; local token=$scoped', (
      tester,
    ) async {
      final initial = TThemeData.defaultData().copyWith(sizeMap: {'size8': 42});
      final localToken = initial.copyWith(sizeMap: {'size8': 71});
      final theme = ValueNotifier(TThemeBuilder.light(initial));
      OverlayEntry? entry;
      TThemeData? seen;
      TextStyle? localStyle;
      await tester.pumpWidget(
        ValueListenableBuilder<ThemeData>(
          valueListenable: theme,
          builder: (_, data, child) => MaterialApp(theme: data, home: child),
          child: Builder(
            builder: (root) => Theme(
              data: Theme.of(root)
                  .mergeExtension(
                    const TTextThemeData(textStyle: TextStyle(fontSize: 37)),
                  )
                  .copyWith(
                    extensions: [
                      ...Theme.of(root).extensions.values.where(
                        (e) =>
                            e is! TTextThemeData &&
                            (!scoped || e is! TThemeData),
                      ),
                      const TTextThemeData(textStyle: TextStyle(fontSize: 37)),
                      if (scoped) localToken,
                    ],
                  ),
              child: Builder(
                builder: (source) => TextButton(
                  onPressed: () {
                    final captured = TOverlayThemes.capture(
                      from: source,
                      to: root,
                    );
                    entry = OverlayEntry(
                      builder: (context) => captured.wrap(
                        context,
                        Builder(
                          builder: (context) {
                            seen = context.tTheme;
                            localStyle = Theme.of(
                              context,
                            ).extension<TTextThemeData>()?.textStyle;
                            return const SizedBox();
                          },
                        ),
                      ),
                    );
                    Overlay.of(source).insert(entry!);
                  },
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(seen!.size8, scoped ? 71 : 42);
      theme.value = TThemeBuilder.light(
        initial.copyWith(sizeMap: {'size8': 53}),
      );
      await tester.pumpAndSettle();
      expect(seen!.size8, scoped ? 71 : 53);
      expect(localStyle!.fontSize, 37);
      theme.value = theme.value.copyWith(extensions: const []);
      await tester.pumpAndSettle();
      expect(seen!.size8, scoped ? 71 : 24);
      expect(localStyle!.fontSize, 37);
      entry!.remove();
      entry!.dispose();
      await tester.pumpWidget(const SizedBox());
      theme.dispose();
    });
  }
}
