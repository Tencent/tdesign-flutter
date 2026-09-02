import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrapWithTheme(Widget child, {TTabsBarThemeData? tabsBarTheme}) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [
          TThemeData.defaultData(),
          if (tabsBarTheme != null) tabsBarTheme,
        ],
      ),
      home: Scaffold(body: child),
    );
  }

  group('TTab', () {
    test('constructors keep the compact content API', () {
      const textTab = TTab(text: '文本');
      expect(textTab.text, '文本');
      expect(textTab.enabled, isTrue);

      const childTab = TTab(child: Text('自定义'), enabled: false);
      expect(childTab.child, isA<Text>());
      expect(childTab.enabled, isFalse);

      const iconTab = TTab(text: '星标', icon: Icon(Icons.star));
      expect(iconTab.icon, isA<Icon>());
      expect(iconTab.text, '星标');

      const iconOnlyTab = TTab(icon: Icon(Icons.star));
      expect(iconOnlyTab.icon, isA<Icon>());

      expect(TTab.new, throwsAssertionError);
      expect(
        () => TTab(text: '文本', child: const Text('自定义')),
        throwsAssertionError,
      );
    });

    testWidgets('renders text, icon+text, composed badge and disabled states', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DefaultTabController(
            length: 4,
            child: TTabsBar(
              tabs: [
                TTab(text: '文本'),
                TTab(text: '图文', icon: Icon(Icons.home)),
                TTab(
                  child: TBadge(
                    variant: TBadgeVariant.dot,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.notifications),
                        SizedBox(width: 4),
                        Text('徽标图文'),
                      ],
                    ),
                  ),
                ),
                TTab(text: '禁用', enabled: false),
              ],
            ),
          ),
        ),
      );

      expect(find.text('文本'), findsOneWidget);
      expect(find.text('图文'), findsOneWidget);
      expect(find.text('徽标图文'), findsOneWidget);
      expect(find.byIcon(Icons.notifications), findsOneWidget);
      expect(find.text('禁用'), findsOneWidget);
      expect(find.byType(TBadge), findsOneWidget);
    });

    testWidgets(
      'disabled tab uses semantic text and icon colors and ignores tap',
      (tester) async {
        final controller = TabController(length: 2, vsync: tester);
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrapWithTheme(
            TTabsBar(
              controller: controller,
              tabs: const [
                TTab(text: '可用'),
                TTab(text: '禁用', icon: Icon(Icons.block), enabled: false),
              ],
            ),
          ),
        );

        final disabledColor = TThemeData.defaultData().textDisabledColor;
        final paragraph = tester.renderObject<RenderParagraph>(find.text('禁用'));
        expect(paragraph.text.style?.color, disabledColor);
        expect(
          IconTheme.of(tester.element(find.byIcon(Icons.block))).color,
          disabledColor,
        );

        await tester.tap(find.text('禁用'), warnIfMissed: false);
        await tester.pumpAndSettle();
        expect(controller.index, 0);

        await tester.pumpWidget(
          wrapWithTheme(
            TTabsBar(
              controller: controller,
              tabs: const [
                TTab(text: '可用'),
                TTab(text: '禁用', icon: Icon(Icons.block), enabled: false),
              ],
            ),
            tabsBarTheme: const TTabsBarThemeData(
              disabledLabelStyle: TextStyle(color: Colors.purple),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final themedParagraph = tester.renderObject<RenderParagraph>(
          find.text('禁用'),
        );
        expect(themedParagraph.text.style?.color, Colors.purple);
      },
    );

    testWidgets('keeps composed badge configuration, text and icon intact', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DefaultTabController(
            length: 1,
            child: TTabsBar(
              tabs: [
                TTab(
                  child: TBadge(
                    label: '8',
                    border: true,
                    showZero: false,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.apps),
                        SizedBox(width: 4),
                        Text('选项1'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('选项1'), findsOneWidget);
      expect(find.byIcon(Icons.apps), findsOneWidget);
      expect(find.byType(TBadge), findsOneWidget);
      final badge = tester.widget<TBadge>(find.byType(TBadge));
      expect(badge.border, isTrue);
      expect(badge.showZero, isFalse);
      expect(tester.getSize(find.text('选项1')).isEmpty, isFalse);
      expect(tester.getSize(find.byIcon(Icons.apps)).isEmpty, isFalse);
      expect(
        tester.getRect(find.byIcon(Icons.apps)).right,
        lessThanOrEqualTo(tester.getRect(find.text('选项1')).left),
      );
    });

    testWidgets('renders custom child content', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DefaultTabController(
            length: 1,
            child: TTabsBar(tabs: [TTab(child: Text('子内容'))]),
          ),
        ),
      );

      expect(find.text('子内容'), findsOneWidget);
    });

    testWidgets('renders an icon-only tab and reports its preferred size', (
      tester,
    ) async {
      final tab = TTab(key: UniqueKey(), icon: const Icon(Icons.star));
      expect(tab.preferredSize, const Size.fromHeight(46));

      await tester.pumpWidget(
        wrapWithTheme(
          DefaultTabController(length: 1, child: TTabsBar(tabs: [tab])),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('uses DefaultTextStyle fontSize fallback', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const DefaultTabController(
            length: 1,
            child: DefaultTextStyle(
              style: TextStyle(fontSize: 20),
              child: TTabsBar(tabs: [TTab(text: '字号')]),
            ),
          ),
        ),
      );

      expect(find.text('字号'), findsOneWidget);
    });

    testWidgets('long label stays single-line and fades overflow', (
      tester,
    ) async {
      const longLabel = '这是一个非常非常非常长的标签文本用于验证不会换行和撑坏布局';
      await tester.pumpWidget(
        wrapWithTheme(
          const DefaultTabController(
            length: 1,
            child: TTabsBar(tabs: [TTab(text: longLabel)]),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text(longLabel));
      expect(text.softWrap, isFalse);
      expect(text.overflow, TextOverflow.fade);
    });
  });

  group('TTabsBarView', () {
    testWidgets('renders children with default and explicit physics', (
      tester,
    ) async {
      final controller = TabController(length: 2, vsync: tester);
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrapWithTheme(
          TTabsBarView(
            controller: controller,
            physics: const BouncingScrollPhysics(),
            children: const [Text('第一页'), Text('第二页')],
          ),
        ),
      );

      expect(find.byType(TTabsBarView), findsOneWidget);
      expect(find.text('第一页'), findsOneWidget);
    });

    testWidgets('defaults to non-scrollable physics when omitted', (
      tester,
    ) async {
      final controller = TabController(length: 2, vsync: tester);
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrapWithTheme(
          TTabsBarView(
            controller: controller,
            children: const [Text('第一页'), Text('第二页')],
          ),
        ),
      );

      expect(find.byType(TTabsBarView), findsOneWidget);
    });
  });
}
