import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_route.dart';
import 'package:tdesign_flutter_example/config.dart';
import 'package:tdesign_flutter_example/page/theme/custom_theme_example.dart';
import 'package:tdesign_flutter_example/page/theme/dark_mode_example.dart';

void main() {
  testWidgets('Dark guide switches modes and follows system brightness', (
    tester,
  ) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    await tester.pumpWidget(const DarkModeExample());
    await tester.pumpAndSettle();
    final tag = find.byType(TTag);
    expect(Theme.of(tester.element(tag)).brightness, Brightness.light);
    await tester.tap(find.text('深色'));
    await tester.pumpAndSettle();
    expect(Theme.of(tester.element(tag)).brightness, Brightness.dark);
    await tester.tap(find.text('浅色'));
    await tester.pumpAndSettle();
    expect(Theme.of(tester.element(tag)).brightness, Brightness.light);
    await tester.tap(find.text('跟随系统'));
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    await tester.pumpAndSettle();
    expect(Theme.of(tester.element(tag)).brightness, Brightness.dark);
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    await tester.pumpAndSettle();
    expect(Theme.of(tester.element(tag)).brightness, Brightness.light);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Custom guide changes brand and keeps local radius isolated', (
    tester,
  ) async {
    await tester.pumpWidget(const CustomThemeExample());
    await tester.pumpAndSettle();
    Finder tag(String text) => find.byWidgetPredicate(
      (widget) => widget is TTag && widget.text == text,
    );
    BuildContext context(String text) => tester.element(tag(text));
    expect(context('全局标签').tTheme.brandColor, const Color(0xFF0052D9));
    await tester.tap(find.text('绿色'));
    await tester.pumpAndSettle();
    for (final text in ['全局标签', '局部标签', '大号标签']) {
      expect(context(text).tTheme.brandColor, const Color(0xFF2BA471));
    }
    await tester.tap(find.text('切换全局圆角（当前 6）'));
    await tester.pumpAndSettle();
    expect(
      Theme.of(context('全局标签')).extension<TTagThemeData>()!.squareBorderRadius,
      16,
    );
    expect(
      Theme.of(context('局部标签')).extension<TTagThemeData>()!.squareBorderRadius,
      24,
    );
    expect(
      Theme.of(context('大号标签')).extension<TTagThemeData>()!.squareBorderRadius,
      16,
    );
    expect(tester.widget<TTag>(tag('大号标签')).size, TTagSize.large);
    await tester.tap(find.text('自定义色'));
    await tester.pumpAndSettle();
    expect(context('局部标签').tTheme.brandColor, const Color(0xFF834EC2));
    expect(
      Theme.of(context('局部标签')).extension<TTagThemeData>()!.squareBorderRadius,
      24,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Guide routes open the actual generated demo widgets', (
    tester,
  ) async {
    TExampleRoute.init();
    for (final entry in {
      'dark-mode': DarkModeExample,
      'custom-theme': CustomThemeExample,
    }.entries) {
      final route = TExampleRoute.onGenerateRoute(
        RouteSettings(name: entry.key),
      );
      expect(route, isNotNull);
      final model = exampleMap['全局配置']!.singleWhere(
        (model) => model.name == entry.key,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => model.pageBuilder(context, model),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(entry.value), findsOneWidget);
      expect(find.byType(TNavBar), findsOneWidget);
      expect(find.byType(AppBar), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    }
  });
}
