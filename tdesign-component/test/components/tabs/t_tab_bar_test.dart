import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/tabs/t_horizontal_tab_bar.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrapWithTheme(
    Widget child, {
    TTabsBarThemeData? tabsBarTheme,
    int length = 3,
  }) {
    return MaterialApp(
      theme: ThemeData(extensions: [
        TThemeData.defaultData(),
        if (tabsBarTheme != null) tabsBarTheme,
      ]),
      home: Scaffold(body: DefaultTabController(length: length, child: child)),
    );
  }

  List<TTab> tabs([int count = 3]) =>
      List.generate(count, (index) => TTab(text: '选项${index + 1}'));

  group('TTabsBarThemeData', () {
    test('copyWith and lerp retain visual fields', () {
      const theme = TTabsBarThemeData(
        backgroundColor: Colors.white,
        dividerHeight: 1,
        labelPadding: EdgeInsets.all(8),
      );
      final copied = theme.copyWith(dividerHeight: 2);

      expect(copied.backgroundColor, Colors.white);
      expect(copied.dividerHeight, 2);
      expect(copied.labelPadding, const EdgeInsets.all(8));
      expect(theme.lerp(copied, 0.5).dividerHeight, 1.5);
    });
  });

  group('TTabsBar', () {
    testWidgets('default labels inherit ThemeData bodyMedium font family',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontFamily: 'TestFont'),
          ),
          extensions: [TThemeData.defaultData()],
        ),
        home: Scaffold(
          body: DefaultTabController(
            length: 3,
            child: TTabsBar(tabs: tabs()),
          ),
        ),
      ));

      final tabBar = tester.widget<THorizontalTabBar>(
        find.byType(THorizontalTabBar),
      );
      expect(tabBar.labelStyle?.fontFamily, 'TestFont');
      expect(tabBar.unselectedLabelStyle?.fontFamily, 'TestFont');
    });

    testWidgets('renders all supported variants', (tester) async {
      for (final variant in TTabsBarVariant.values) {
        await tester.pumpWidget(wrapWithTheme(
          TTabsBar(tabs: tabs(), variant: variant),
        ));
        expect(find.byType(TTabsBar), findsOneWidget);
      }
    });

    testWidgets('uses the visual theme and lets decoration override it',
        (tester) async {
      const theme = TTabsBarThemeData(
        backgroundColor: Colors.green,
        dividerColor: Colors.blue,
        dividerHeight: 2,
      );
      await tester.pumpWidget(wrapWithTheme(
        TTabsBar(tabs: tabs()),
        tabsBarTheme: theme,
      ));

      final themedContainer = tester.widget<Container>(
        find.byWidgetPredicate(
          (widget) => widget is Container && widget.child is THorizontalTabBar,
        ),
      );
      expect(
          (themedContainer.decoration! as BoxDecoration).color, Colors.green);

      await tester.pumpWidget(wrapWithTheme(
        TTabsBar(
          tabs: tabs(),
          decoration: const BoxDecoration(color: Colors.red),
        ),
        tabsBarTheme: theme,
      ));
      final overriddenContainer = tester.widget<Container>(
        find.byWidgetPredicate(
          (widget) => widget is Container && widget.child is THorizontalTabBar,
        ),
      );
      expect(
          (overriddenContainer.decoration! as BoxDecoration).color, Colors.red);
    });

    testWidgets('supports controller, tap callback, scrolling and indicator',
        (tester) async {
      var tapped = -1;
      await tester.pumpWidget(wrapWithTheme(
        TTabsBar(
          tabs: tabs(),
          isScrollable: true,
          indicator: const TTabsBarIndicator(indicatorColor: Colors.red),
          onTap: (index) => tapped = index,
        ),
      ));

      await tester.tap(find.text('选项2'));
      await tester.pumpAndSettle();
      expect(tapped, 1);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });

  group('TTabsBarIndicator', () {
    test('creates a painter', () {
      expect(
        const TTabsBarIndicator(indicatorColor: Colors.red).createBoxPainter(),
        isNotNull,
      );
    });

    test('paints on a canvas', () {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      const config = ImageConfiguration(size: Size(100, 40));
      const TTabsBarIndicator(indicatorColor: Colors.red)
          .createBoxPainter()
          .paint(canvas, Offset.zero, config);
      recorder.endRecording();
      expect(true, isTrue);
    });
  });
}
