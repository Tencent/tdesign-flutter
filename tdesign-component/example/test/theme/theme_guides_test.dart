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
    final tag = find.widgetWithText(TButton, '主要按钮');
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

  testWidgets('Custom guide renders interactive buttons with scoped styles', (
    tester,
  ) async {
    await tester.pumpWidget(const CustomThemeExample());
    await tester.pumpAndSettle();
    Finder button(String text) => find.widgetWithText(TButton, text);
    BuildContext context(String text) => tester.element(button(text));
    double radius(String text) {
      final rendered = tester.widget<ElevatedButton>(
        find.descendant(
          of: button(text),
          matching: find.byType(ElevatedButton),
        ),
      );
      final shape =
          rendered.style!.shape!.resolve({})! as RoundedRectangleBorder;
      return (shape.borderRadius as BorderRadius).topLeft.x;
    }

    double iconSpacing(String text) {
      final icon = find.descendant(
        of: button(text),
        matching: find.byType(Icon),
      );
      return tester.getTopLeft(find.text(text)).dx -
          tester.getTopRight(icon).dx;
    }

    for (final text in ['全局按钮', '局部按钮', '大号按钮']) {
      expect(iconSpacing(text), closeTo(4, 0.01));
    }
    await tester.tap(find.text('图标间距：4'));
    await tester.pumpAndSettle();
    for (final text in ['全局按钮', '局部按钮', '大号按钮']) {
      expect(iconSpacing(text), closeTo(16, 0.01));
    }
    expect(find.byType(TTag), findsNothing);
    expect(radius('全局按钮'), 6);
    expect(radius('局部按钮'), 24);
    expect(tester.getSize(button('全局按钮')).width, lessThan(300));
    await tester.tap(find.text('绿色'));
    await tester.pumpAndSettle();
    for (final text in ['全局按钮', '局部按钮', '大号按钮']) {
      expect(context(text).tTheme.brandColor, const Color(0xFF2BA471));
    }
    await tester.tap(find.text('全局圆角：6'));
    await tester.pumpAndSettle();
    expect(radius('全局按钮'), 16);
    expect(radius('局部按钮'), 24);
    expect(radius('大号按钮'), 16);
    expect(tester.widget<TButton>(button('大号按钮')).size, TButtonSize.large);
    for (final text in ['全局按钮', '局部按钮', '大号按钮']) {
      await tester.tap(button(text));
      await tester.pumpAndSettle();
      expect(find.text('当前点击：$text'), findsOneWidget);
    }
    await tester.tap(find.text('自定义色'));
    await tester.pumpAndSettle();
    expect(context('局部按钮').tTheme.brandColor, const Color(0xFF834EC2));
    expect(radius('局部按钮'), 24);
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
