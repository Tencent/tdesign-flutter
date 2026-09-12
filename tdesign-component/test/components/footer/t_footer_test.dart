import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget app(Widget child, {TFooterThemeData? theme}) => MaterialApp(
    theme: ThemeData(
      extensions: [TThemeData.defaultData(), if (theme != null) theme],
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

  testWidgets('multiple links use a 22 pixel divider', (tester) async {
    await tester.pumpWidget(
      app(const TFooter(links: [Text('链接一'), Text('链接二')], text: '版权信息')),
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox && widget.width == 1 && widget.height == 22,
      ),
      findsOneWidget,
    );
  });

  testWidgets('link content keeps its intrinsic width in the footer', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        TFooter(
          links: [
            TLink(child: const Text('底部链接'), onPressed: () {}),
          ],
          text: '版权信息',
        ),
      ),
    );
    expect(find.text('底部链接'), findsOneWidget);
    expect(
      find.ancestor(
        of: find.text('底部链接'),
        matching: find.byType(IntrinsicWidth),
      ),
      findsOneWidget,
    );
  });

  testWidgets('logo takes precedence over links and text', (tester) async {
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
    expect(find.text('版权'), findsNothing);
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
