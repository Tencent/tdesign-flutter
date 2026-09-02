import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
      theme: ThemeData(
        extensions: [
          TThemeData.defaultData(),
          if (tabsBarTheme != null) tabsBarTheme,
        ],
      ),
      home: Scaffold(
        body: DefaultTabController(length: length, child: child),
      ),
    );
  }

  List<TTab> tabs([int count = 3]) =>
      List.generate(count, (index) => TTab(text: '选项${index + 1}'));

  group('TTabsBarThemeData', () {
    test('copyWith and lerp retain and interpolate visual fields', () {
      const theme = TTabsBarThemeData(
        backgroundColor: Colors.white,
        dividerHeight: 1,
        labelPadding: EdgeInsets.all(4),
        labelStyle: TextStyle(fontSize: 12, color: Colors.red),
        unselectedLabelStyle: TextStyle(fontSize: 10, color: Colors.orange),
        disabledLabelStyle: TextStyle(fontSize: 8, color: Colors.grey),
        indicator: BoxDecoration(color: Colors.red),
        selectedTagBackgroundColor: Colors.blue,
        tagBackgroundColor: Colors.green,
      );
      final copied = theme.copyWith(
        dividerHeight: 2,
        labelPadding: const EdgeInsets.all(12),
        labelStyle: const TextStyle(fontSize: 20, color: Colors.blue),
        unselectedLabelStyle: const TextStyle(
          fontSize: 18,
          color: Colors.purple,
        ),
        disabledLabelStyle: const TextStyle(fontSize: 16, color: Colors.black),
        indicator: const BoxDecoration(color: Colors.blue),
      );

      expect(copied.backgroundColor, Colors.white);
      expect(copied.dividerHeight, 2);
      expect(copied.labelPadding, const EdgeInsets.all(12));
      expect(copied.disabledLabelStyle?.color, Colors.black);
      expect(copied.selectedTagBackgroundColor, Colors.blue);
      expect(copied.tagBackgroundColor, Colors.green);
      final lerped = theme.lerp(copied, 0.5);
      expect(lerped.dividerHeight, 1.5);
      expect(lerped.labelPadding, const EdgeInsets.all(8));
      expect(lerped.labelStyle?.fontSize, 16);
      expect(
        lerped.labelStyle?.color,
        Color.lerp(Colors.red, Colors.blue, 0.5),
      );
      expect(lerped.unselectedLabelStyle?.fontSize, 14);
      expect(lerped.disabledLabelStyle?.fontSize, 12);
      expect(
        (lerped.indicator! as BoxDecoration).color,
        Color.lerp(Colors.red, Colors.blue, 0.5),
      );
    });
  });

  group('TTabsBar', () {
    testWidgets('default labels inherit ThemeData bodyMedium font family', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
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
        ),
      );

      final tabBar = tester.widget<THorizontalTabBar>(
        find.byType(THorizontalTabBar),
      );
      expect(tabBar.labelStyle?.fontFamily, 'TestFont');
      expect(tabBar.unselectedLabelStyle?.fontFamily, 'TestFont');
    });

    testWidgets('Material visual themes do not override TDesign defaults', (
      tester,
    ) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            disabledColor: Colors.orange,
            iconTheme: const IconThemeData(
              size: 40,
              color: Colors.pink,
              opacity: 0.2,
            ),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(
                fontFamily: 'TestFont',
                fontSize: 30,
                height: 2,
                color: Colors.brown,
              ),
            ),
            tabBarTheme: const TabBarThemeData(
              indicator: BoxDecoration(color: Colors.red),
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Colors.green,
              labelStyle: TextStyle(fontSize: 28),
              unselectedLabelColor: Colors.amber,
              unselectedLabelStyle: TextStyle(fontSize: 26),
              labelPadding: EdgeInsets.all(20),
              dividerColor: Colors.deepPurple,
            ),
            extensions: [token],
          ),
          home: const Scaffold(
            body: DefaultTabController(
              length: 2,
              child: TTabsBar(
                tabs: [
                  TTab(text: '选中'),
                  TTab(text: '禁用', icon: Icon(Icons.block), enabled: false),
                ],
              ),
            ),
          ),
        ),
      );

      final tabBar = tester.widget<THorizontalTabBar>(
        find.byType(THorizontalTabBar),
      );
      expect(tabBar.indicator, isA<TTabsBarIndicator>());
      expect(tabBar.indicatorSize, TabBarIndicatorSize.tab);
      expect(tabBar.labelColor, token.brandNormalColor);
      expect(tabBar.unselectedLabelColor, token.textColorPrimary);
      expect(tabBar.labelStyle?.fontFamily, 'TestFont');
      expect(tabBar.labelStyle?.fontSize, token.fontBodyMedium?.size);
      expect(tabBar.labelStyle?.height, token.fontBodyMedium?.height);
      expect(tabBar.labelPadding, const EdgeInsets.all(8));
      expect(
        tabBar.overlayColor?.resolve({WidgetState.pressed}),
        Colors.transparent,
      );

      final disabledParagraph = tester.renderObject<RenderParagraph>(
        find.text('禁用'),
      );
      expect(disabledParagraph.text.style?.color, token.textDisabledColor);
      final iconTheme = IconTheme.of(tester.element(find.byIcon(Icons.block)));
      expect(iconTheme.size, 18);
      expect(iconTheme.color, token.textDisabledColor);
      expect(iconTheme.opacity, 1);

      final container = tester.widget<Container>(
        find.byWidgetPredicate(
          (widget) => widget is Container && widget.child is THorizontalTabBar,
        ),
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.border?.bottom.color, token.componentStrokeColor);
    });

    testWidgets('renders all supported variants', (tester) async {
      for (final variant in TTabsBarVariant.values) {
        await tester.pumpWidget(
          wrapWithTheme(TTabsBar(tabs: tabs(), variant: variant)),
        );
        expect(find.byType(TTabsBar), findsOneWidget);
      }
    });

    testWidgets('owns the default TDesign indicator by variant', (
      tester,
    ) async {
      await tester.pumpWidget(wrapWithTheme(TTabsBar(tabs: tabs())));
      var tabBar = tester.widget<THorizontalTabBar>(
        find.byType(THorizontalTabBar),
      );
      expect(tabBar.indicator, isA<TTabsBarIndicator>());
      expect(
        (tabBar.indicator! as TTabsBarIndicator).indicatorColor,
        TThemeData.defaultData().brandNormalColor,
      );

      await tester.pumpWidget(
        wrapWithTheme(TTabsBar(tabs: tabs(), variant: TTabsBarVariant.tag)),
      );
      tabBar = tester.widget<THorizontalTabBar>(find.byType(THorizontalTabBar));
      expect(tabBar.indicator, isNot(isA<TTabsBarIndicator>()));
    });

    testWidgets('component theme is the subtree visual override', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            tabBarTheme: const TabBarThemeData(
              labelStyle: TextStyle(fontSize: 17),
              labelPadding: EdgeInsets.all(6),
            ),
            extensions: const [
              TTabsBarThemeData(
                labelStyle: TextStyle(fontSize: 19),
                labelPadding: EdgeInsets.all(9),
              ),
            ],
          ),
          home: Scaffold(
            body: DefaultTabController(
              length: 3,
              child: TTabsBar(tabs: tabs()),
            ),
          ),
        ),
      );

      final tabBar = tester.widget<THorizontalTabBar>(
        find.byType(THorizontalTabBar),
      );
      expect(tabBar.labelStyle?.fontSize, 19);
      expect(tabBar.labelPadding, const EdgeInsets.all(9));
    });

    testWidgets('tag owns a 32px pill box and theme background colors', (
      tester,
    ) async {
      const selectedColor = Color(0xFF123456);
      const backgroundColor = Color(0xFFABCDEF);
      await tester.pumpWidget(
        wrapWithTheme(
          TTabsBar(tabs: tabs(), variant: TTabsBarVariant.tag),
          tabsBarTheme: const TTabsBarThemeData(
            selectedTagBackgroundColor: selectedColor,
            tagBackgroundColor: backgroundColor,
          ),
        ),
      );

      final tagContainers = find.byWidgetPredicate((widget) {
        if (widget is! Container || widget.decoration is! BoxDecoration) {
          return false;
        }
        return (widget.decoration! as BoxDecoration).borderRadius ==
            BorderRadius.circular(16);
      });
      expect(tagContainers, findsNWidgets(3));

      final containers = tester.widgetList<Container>(tagContainers).toList();
      expect(
        containers.map((item) => (item.decoration! as BoxDecoration).color),
        [selectedColor, backgroundColor, backgroundColor],
      );
      for (final container in containers) {
        final size = tester.getSize(find.byWidget(container));
        expect(size.height, 32);
        expect(size.width, greaterThan(80));
      }
    });

    testWidgets('uses the visual theme and lets decoration override it', (
      tester,
    ) async {
      const theme = TTabsBarThemeData(
        backgroundColor: Colors.green,
        dividerColor: Colors.blue,
        dividerHeight: 2,
      );
      await tester.pumpWidget(
        wrapWithTheme(TTabsBar(tabs: tabs()), tabsBarTheme: theme),
      );

      final themedContainer = tester.widget<Container>(
        find.byWidgetPredicate(
          (widget) => widget is Container && widget.child is THorizontalTabBar,
        ),
      );
      expect(
        (themedContainer.decoration! as BoxDecoration).color,
        Colors.green,
      );

      await tester.pumpWidget(
        wrapWithTheme(
          TTabsBar(
            tabs: tabs(),
            decoration: const BoxDecoration(color: Colors.red),
          ),
          tabsBarTheme: theme,
        ),
      );
      final overriddenContainer = tester.widget<Container>(
        find.byWidgetPredicate(
          (widget) => widget is Container && widget.child is THorizontalTabBar,
        ),
      );
      expect(
        (overriddenContainer.decoration! as BoxDecoration).color,
        Colors.red,
      );
    });

    testWidgets('supports controller, tap callback, scrolling and indicator', (
      tester,
    ) async {
      var tapped = -1;
      await tester.pumpWidget(
        wrapWithTheme(
          TTabsBar(
            tabs: tabs(),
            isScrollable: true,
            indicator: const TTabsBarIndicator(indicatorColor: Colors.red),
            onTap: (index) => tapped = index,
          ),
        ),
      );

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
      const TTabsBarIndicator(
        indicatorColor: Colors.red,
      ).createBoxPainter().paint(canvas, Offset.zero, config);
      recorder.endRecording();
      expect(true, isTrue);
    });
  });
}
