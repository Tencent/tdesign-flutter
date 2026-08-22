import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child, {TLinkThemeData? linkTheme}) {
    final token = TThemeData.defaultData();
    var theme = TThemeBuilder.light(token);
    if (linkTheme != null) {
      theme = theme.mergeExtension(linkTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: Center(child: child)),
    );
  }

  TextStyle linkStyle(WidgetTester tester, String text) {
    return DefaultTextStyle.of(tester.element(find.text(text))).style;
  }

  testWidgets('默认为 medium / default 且不自动生成图标', (tester) async {
    final token = TThemeData.defaultData();
    await tester.pumpWidget(
      wrap(const TLink(child: Text('跳转链接'), onPressed: _noop)),
    );

    final style = linkStyle(tester, '跳转链接');
    expect(style.fontSize, 14);
    expect(style.height, 22 / 14);
    expect(style.color, token.textColorPrimary);
    expect(find.byType(Icon), findsNothing);
  });

  testWidgets('下划线、前置图标和后置图标可同时组合', (tester) async {
    await tester.pumpWidget(
      wrap(
        const TLink(
          child: Text('组合链接'),
          prefixIcon: Icon(Icons.link),
          suffixIcon: Icon(Icons.open_in_new),
          underline: true,
          onPressed: _noop,
        ),
      ),
    );

    expect(find.byIcon(Icons.link), findsOneWidget);
    expect(find.byIcon(Icons.open_in_new), findsOneWidget);
    final decoration = tester
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .map((widget) => widget.decoration)
        .whereType<BoxDecoration>()
        .where((value) => value.border != null);
    expect(decoration, isNotEmpty);
  });

  testWidgets('只渲染显式传入的单侧图标', (tester) async {
    await tester.pumpWidget(
      wrap(
        const Column(
          children: [
            TLink(
              child: Text('前置'),
              prefixIcon: Icon(Icons.arrow_back),
              onPressed: _noop,
            ),
            TLink(
              child: Text('后置'),
              suffixIcon: Icon(Icons.arrow_forward),
              onPressed: _noop,
            ),
          ],
        ),
      ),
    );

    expect(find.byType(Icon), findsNWidgets(2));
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
  });

  testWidgets('图标尺寸与图文间距默认对齐小程序', (tester) async {
    await tester.pumpWidget(
      wrap(
        const TLink(
          child: Text('图标链接'),
          prefixIcon: Icon(Icons.link),
          suffixIcon: Icon(Icons.open_in_new),
          size: TLinkSize.small,
          onPressed: _noop,
        ),
      ),
    );

    final iconTheme = IconTheme.of(tester.element(find.byIcon(Icons.link)));
    expect(iconTheme.size, 14);
    final gaps = tester
        .widgetList<SizedBox>(find.byType(SizedBox))
        .where((widget) => widget.width == 4);
    expect(gaps.length, 2);
  });

  testWidgets('没有内容时图标之间不生成图文间距', (tester) async {
    await tester.pumpWidget(
      wrap(
        const TLink(
          prefixIcon: Icon(Icons.link),
          suffixIcon: Icon(Icons.open_in_new),
          onPressed: _noop,
        ),
      ),
    );

    final gaps = tester
        .widgetList<SizedBox>(
          find.descendant(
            of: find.byType(TLink),
            matching: find.byType(SizedBox),
          ),
        )
        .where((widget) => widget.width == 4);
    expect(gaps, isEmpty);
  });

  testWidgets('点击回调与禁用契约一致', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      wrap(
        Column(
          children: [
            TLink(child: const Text('可点击'), onPressed: () => taps += 1),
            const TLink(child: Text('禁用'), onPressed: null),
          ],
        ),
      ),
    );

    await tester.tap(find.text('可点击'));
    await tester.tap(find.text('禁用'), warnIfMissed: false);
    expect(taps, 1);
    expect(
      linkStyle(tester, '禁用').color,
      TThemeData.defaultData().textDisabledColor,
    );
  });

  testWidgets('悬浮/焦点/按下使用 active Token 反馈', (tester) async {
    final token = TThemeData.defaultData();
    await tester.pumpWidget(
      wrap(
        const TLink(
          child: Text('交互链接'),
          colorScheme: TLinkColorScheme.primary,
          onPressed: _noop,
        ),
      ),
    );

    final inkWell = tester.widget<InkWell>(find.byType(InkWell));
    inkWell.onHover?.call(true);
    await tester.pump();
    expect(linkStyle(tester, '交互链接').color, token.brandClickColor);

    inkWell.onHover?.call(false);
    await tester.pump();
    expect(linkStyle(tester, '交互链接').color, token.brandNormalColor);
  });

  testWidgets('实例参数覆盖组件 Theme 默认值', (tester) async {
    await tester.pumpWidget(
      wrap(
        const TLink(
          child: Text('优先级'),
          size: TLinkSize.small,
          colorScheme: TLinkColorScheme.danger,
          underline: false,
          onPressed: _noop,
        ),
        linkTheme: const TLinkThemeData(
          defaultSize: TLinkSize.large,
          defaultColorScheme: TLinkColorScheme.success,
          underline: true,
          textStyle: TextStyle(fontWeight: FontWeight.w700),
          iconGap: 12,
        ),
      ),
    );

    final style = linkStyle(tester, '优先级');
    expect(style.fontSize, 12);
    expect(style.fontWeight, FontWeight.w700);
    expect(style.color, TThemeData.defaultData().errorNormalColor);
  });

  testWidgets('保留 child 显式 TextStyle 的 Flutter 原生覆盖语义', (tester) async {
    await tester.pumpWidget(
      wrap(
        const TLink(
          child: Text('自定义', style: TextStyle(color: Colors.purple)),
          onPressed: _noop,
        ),
      ),
    );

    expect(tester.widget<Text>(find.text('自定义')).style?.color, Colors.purple);
  });

  testWidgets('提供 link 语义和 tooltip', (tester) async {
    await tester.pumpWidget(
      wrap(
        const TLink(
          child: Text('官网'),
          semanticLabel: '打开官网',
          tooltip: '查看官网',
          onPressed: _noop,
        ),
      ),
    );

    expect(find.byType(Tooltip), findsOneWidget);
    final semanticsFinder = find.descendant(
      of: find.byType(TLink),
      matching: find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.link == true,
      ),
    );
    expect(semanticsFinder, findsOneWidget);
    final semantics = tester.widget<Semantics>(semanticsFinder);
    expect(semantics.properties.label, '打开官网');
    expect(semantics.properties.link, isTrue);
  });
}

void _noop() {}
