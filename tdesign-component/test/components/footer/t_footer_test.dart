import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  final linksLayout = find.descendant(
    of: find.byType(TFooter),
    matching: find.byWidgetPredicate((widget) => widget is Wrap),
  );

  List<Widget> boxLinks(int count, {double height = 22}) => [
    for (var i = 0; i < count; i++)
      SizedBox(key: ValueKey('link-$i'), width: 56, height: height),
  ];

  RenderBox linkRender(WidgetTester tester) => tester.renderObject(linksLayout);

  Widget app(Widget child, {TFooterThemeData? theme, TThemeData? token}) =>
      MaterialApp(
        theme: ThemeData(
          extensions: [
            token ?? TThemeData.defaultData(),
            if (theme != null) theme,
          ],
        ),
        home: Scaffold(body: child),
      );

  testWidgets('text-only footer renders the copyright', (tester) async {
    await tester.pumpWidget(app(const TFooter(text: '版权所有')));
    expect(find.text('版权所有'), findsOneWidget);
  });

  testWidgets('links and text compose without a duplicated variant', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(const TFooter(links: [Text('链接一'), Text('链接二')], text: '版权信息')),
    );
    expect(find.text('链接一'), findsOneWidget);
    expect(find.text('链接二'), findsOneWidget);
    expect(find.text('版权信息'), findsOneWidget);
  });

  testWidgets('single link has no divider', (tester) async {
    await tester.pumpWidget(
      app(const TFooter(links: [Text('唯一链接')], text: '版权信息')),
    );
    expect(find.text('唯一链接'), findsOneWidget);
    expect(find.text('版权信息'), findsOneWidget);
  });

  testWidgets('multiple links keep spacing and paint a 22 pixel divider', (
    tester,
  ) async {
    await tester.pumpWidget(app(TFooter(links: boxLinks(2))));
    final layout = linkRender(tester);
    expect(layout.size, const Size(161, 22));
    expect(
      tester.getSize(find.byKey(const ValueKey('link-0'))),
      const Size(56, 22),
    );
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('link-1'))).dx -
          tester.getTopRight(find.byKey(const ValueKey('link-0'))).dx,
      25,
    );
    expect(
      layout,
      paints..rect(
        rect: const Rect.fromLTWH(80, 0, 1, 22),
        color: TThemeData.defaultData().componentStroke,
      ),
    );
    expect(layout, paintsExactlyCountTimes(#drawRect, 1));
  });

  testWidgets('single link keeps natural size and has no divider', (
    tester,
  ) async {
    await tester.pumpWidget(app(TFooter(links: boxLinks(1, height: 10))));
    expect(linkRender(tester).size, const Size(80, 10));
    expect(linkRender(tester), paintsExactlyCountTimes(#drawRect, 0));
  });

  for (final width in [375.0, 160.0, 80.0]) {
    for (final count in [1, 2]) {
      testWidgets('$count TLinks keep a single text line at width $width', (
        tester,
      ) async {
        tester.view.physicalSize = Size(width, 700);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          app(
            Column(
              children: [
                TFooter(
                  links: [
                    for (var i = 0; i < count; i++)
                      TLink(
                        child: Text('底部链接', key: ValueKey('text-$i')),
                        onPressed: () {},
                      ),
                  ],
                  text: '版权信息',
                ),
              ],
            ),
          ),
        );
        for (var i = 0; i < count; i++) {
          final paragraph = tester.renderObject<RenderParagraph>(
            find.byKey(ValueKey('text-$i')),
          );
          expect(paragraph.size.height, lessThan(30));
          expect(paragraph.size.width, greaterThan(40));
        }
        expect(tester.getCenter(linksLayout).dx, closeTo(width / 2, 0.01));
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('wrapped links only paint dividers within each run', (
    tester,
  ) async {
    for (final (width, count, dividerCount) in [
      (375.0, 3, 2),
      (170.0, 3, 1),
      (160.0, 2, 0),
      (80.0, 3, 0),
    ]) {
      await tester.pumpWidget(
        app(
          Column(
            children: [
              SizedBox(
                width: width,
                child: TFooter(links: boxLinks(count)),
              ),
            ],
          ),
        ),
      );
      expect(
        linkRender(tester),
        paintsExactlyCountTimes(#drawRect, dividerCount),
      );
      if (dividerCount == 0) {
        final first = tester.getRect(find.byKey(const ValueKey('link-0')));
        final second = tester.getRect(find.byKey(const ValueKey('link-1')));
        expect(second.top - first.bottom, 4);
        expect(second.center.dx, closeTo(first.center.dx, 0.01));
      }
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('dividers are vertically centered and follow RTL order', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        const Directionality(
          textDirection: TextDirection.rtl,
          child: TFooter(
            links: [
              SizedBox(key: ValueKey('first'), width: 56, height: 40),
              SizedBox(key: ValueKey('second'), width: 56, height: 10),
            ],
          ),
        ),
      ),
    );
    expect(
      tester.getCenter(find.byKey(const ValueKey('first'))).dx,
      greaterThan(tester.getCenter(find.byKey(const ValueKey('second'))).dx),
    );
    expect(
      linkRender(tester),
      paints..rect(rect: const Rect.fromLTWH(80, 9, 1, 22)),
    );
    expect(linkRender(tester), paintsExactlyCountTimes(#drawRect, 1));
  });

  testWidgets('divider color updates without changing link layout', (
    tester,
  ) async {
    for (final color in [Colors.red, Colors.blue, Colors.blue]) {
      await tester.pumpWidget(
        app(
          TFooter(links: boxLinks(2)),
          token: TThemeData.defaultData().copyWith(
            colorMap: {'componentStroke': color},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(linkRender(tester), paints..rect(color: color));
      expect(linkRender(tester).size, const Size(161, 22));
    }
  });

  testWidgets('wrapped links remain clickable after resizing', (tester) async {
    final taps = <int>[];
    for (final width in [375.0, 80.0]) {
      await tester.pumpWidget(
        app(
          Column(
            children: [
              SizedBox(
                width: width,
                child: TFooter(
                  links: [
                    for (var i = 0; i < 2; i++)
                      TLink(child: Text('链接$i'), onPressed: () => taps.add(i)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      await tester.tap(find.text('链接0'));
      await tester.tap(find.text('链接1'));
    }
    expect(taps, [0, 1, 0, 1]);
  });

  testWidgets('links support intrinsic parent sizing', (tester) async {
    await tester.pumpWidget(
      app(
        Center(
          child: IntrinsicWidth(child: TFooter(links: boxLinks(2))),
        ),
      ),
    );
    expect(tester.getSize(find.byType(TFooter)).width, 161);
    expect(linkRender(tester), paintsExactlyCountTimes(#drawRect, 1));
  });

  testWidgets('link slots can depend on available layout constraints', (
    tester,
  ) async {
    BoxConstraints? available;
    await tester.pumpWidget(
      app(
        Column(
          children: [
            SizedBox(
              width: 375,
              child: TFooter(
                links: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      available = constraints;
                      return TLink(child: const Text('底部链接'), onPressed: () {});
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    expect(available!.maxWidth, 351);
    expect(find.text('底部链接'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('logo takes precedence over links and composes with text', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        const TFooter(
          logo: SizedBox(key: ValueKey('logo'), width: 104, height: 24),
          links: [Text('链接')],
          text: '版权',
        ),
      ),
    );
    expect(find.byKey(const ValueKey('logo')), findsOneWidget);
    expect(find.text('链接'), findsNothing);
    expect(find.text('版权'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('版权')).dy,
      lessThan(tester.getTopLeft(find.byKey(const ValueKey('logo'))).dy),
    );
  });

  testWidgets('link spacing and brand gap follow spacing tokens', (
    tester,
  ) async {
    final token = TThemeData.defaultData().copyWith(
      name: 'footer-spacing',
      spacerMap: {'spacer': 10, 'spacer1': 18},
    );
    await tester.pumpWidget(
      app(
        const TFooter(
          logo: SizedBox(key: ValueKey('logo'), width: 32, height: 32),
          text: '品牌',
        ),
        token: token,
      ),
    );

    expect(
      find.descendant(
        of: find.byType(TFooter),
        matching: find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.height == 10,
        ),
      ),
      findsOneWidget,
    );

    await tester.pumpWidget(
      app(const TFooter(links: [Text('链接一'), Text('链接二')]), token: token),
    );
    final links = find.text('链接一');
    final paddings = tester.widgetList<Padding>(
      find.ancestor(of: links, matching: find.byType(Padding)),
    );
    expect(
      paddings.any(
        (padding) =>
            padding.padding == const EdgeInsets.symmetric(horizontal: 18),
      ),
      isTrue,
    );
  });

  testWidgets('long text remains one line and ellipsizes', (tester) async {
    await tester.pumpWidget(
      app(
        const SizedBox(
          width: 120,
          child: TFooter(text: '这是一个非常非常长的页脚文案用于验证不溢出'),
        ),
      ),
    );
    final text = tester.widget<Text>(find.text('这是一个非常非常长的页脚文案用于验证不溢出'));
    expect(text.maxLines, 1);
    expect(text.overflow, TextOverflow.ellipsis);
    expect(text.softWrap, isFalse);
  });

  testWidgets('theme height constrains the footer', (tester) async {
    await tester.pumpWidget(
      app(
        const TFooter(text: '主题高度'),
        theme: const TFooterThemeData(height: 100),
      ),
    );
    expect(tester.getSize(find.byType(TFooter)).height, 100);
  });

  test('theme copyWith and lerp cover height', () {
    const a = TFooterThemeData(height: 10);
    const b = TFooterThemeData(height: 30);
    expect(a.copyWith(height: 20).height, 20);
    expect(a.copyWith().height, 10);
    expect(a.lerp(b, 0.5).height, 20);
    expect(a.lerp(null, 0.5), same(a));
  });
}
