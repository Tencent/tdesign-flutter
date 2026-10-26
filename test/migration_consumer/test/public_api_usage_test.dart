import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

Widget host(
  Widget child, {
  List<ThemeExtension<dynamic>> extensions = const [],
}) {
  final theme = ThemeData(
    extensions: [TThemeData.defaultData(), ...extensions],
  );
  return MaterialApp(
    theme: theme,
    home: Scaffold(body: child),
  );
}

TThemeData copyTheme(TThemeData theme) =>
    theme.copyWith(spacerMap: {'spacer': 10});

TThemeData transitionTheme(TThemeData theme, TThemeData other) =>
    theme.lerp(other, 0.5);

void main() {
  test('TThemeData operations return the public concrete type', () {
    final token = TThemeData.defaultData().copyWith(name: 'consumer');
    final copied = copyTheme(token).copyWith(radiusMap: {'radiusDefault': 20});
    expect(copied.name, 'consumer');
    expect(copied.spacerMap['spacer'], 10);
    expect(copied.radiusMap['radiusDefault'], 20);
    expect(transitionTheme(token, copied).name, 'consumer');
  });

  testWidgets(
    'TabBar Theme height and inline items work through the public API',
    (tester) async {
      var tapped = -1;
      await tester.pumpWidget(
        host(
          TTabBar(
            type: TTabBarType.iconText,
            value: 0,
            onChanged: (index) => tapped = index,
            useSafeArea: false,
            iconTextLayout: TTabBarIconTextLayout.inline,
            navigationTabs: [
              TTabBarItemConfig(
                tabText: 'One',
                selectedIcon: const Icon(Icons.home),
                unselectedIcon: const Icon(Icons.home),
                onTap: () => tapped = 0,
              ),
              TTabBarItemConfig(
                tabText: 'Two',
                selectedIcon: const Icon(Icons.star),
                unselectedIcon: const Icon(Icons.star),
                onTap: () => tapped = 1,
              ),
            ],
          ),
          extensions: [const TTabBarThemeData(barHeight: 64)],
        ),
      );
      expect(tester.getSize(find.byType(TTabBar)).height, 64);
      await tester.tap(find.text('Two'));
      expect(tapped, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Popover commands consume the migrated local Theme and colorPreset',
    (tester) async {
      final controller = TPopoverController();
      await tester.pumpWidget(
        host(
          Center(
            child: TPopoverAnchor(
              controller: controller,
              content: const Text('Popover body'),
              colorPreset: TPopoverColorPreset.primary,
              showArrow: false,
              builder: (context, controller, child) => TextButton(
                onPressed: controller.open,
                child: const Text('Open'),
              ),
            ),
          ),
          extensions: [
            const TPopoverThemeData(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              barrierColor: Color(0x33000000),
              padding: EdgeInsets.all(8),
            ),
          ],
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('Popover body'), findsOneWidget);
      controller.close();
      await tester.pumpAndSettle();
      expect(find.text('Popover body'), findsNothing);
      final closed = TPopover.showPopover(
        context: tester.element(find.text('Open')),
        content: const Text('One-shot'),
        colorPreset: TPopoverColorPreset.primary,
        showArrow: false,
      );
      await tester.pumpAndSettle();
      expect(find.text('One-shot'), findsOneWidget);
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      await closed;
      expect(find.text('One-shot'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Popup migrated overlay and options open and close externally', (
    tester,
  ) async {
    await tester.pumpWidget(host(const Center(child: Text('Anchor'))));
    final handle = TPopup.show(
      tester.element(find.text('Anchor')),
      options: TPopupOptions.bottom(
        child: const SizedBox(height: 80, child: Text('Panel')),
        animationDuration: const Duration(milliseconds: 120),
        overlay: const TPopupOverlayConfig(color: Color(0x33000000)),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Panel'), findsOneWidget);
    handle.close();
    await tester.pumpAndSettle();
    expect(find.text('Panel'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
