import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/link/t_link_resolve.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    theme: TThemeBuilder.light(TThemeData.defaultData()),
    home: Scaffold(body: child),
  );

  testWidgets('size 解析使用完整字体 Token', (tester) async {
    await tester.pumpWidget(wrap(const SizedBox()));
    final context = tester.element(find.byType(SizedBox));

    final small = TLinkResolve.resolveTextStyle(
      context: context,
      size: TLinkSize.small,
      theme: null,
      color: Colors.black,
    );
    final medium = TLinkResolve.resolveTextStyle(
      context: context,
      size: TLinkSize.medium,
      theme: null,
      color: Colors.black,
    );
    final large = TLinkResolve.resolveTextStyle(
      context: context,
      size: TLinkSize.large,
      theme: null,
      color: Colors.black,
    );

    expect((small.fontSize, small.height), (12, 20 / 12));
    expect((medium.fontSize, medium.height), (14, 22 / 14));
    expect((large.fontSize, large.height), (16, 24 / 16));
  });

  testWidgets('Theme 只覆盖显式 TextStyle 字段', (tester) async {
    await tester.pumpWidget(wrap(const SizedBox()));
    final context = tester.element(find.byType(SizedBox));
    final style = TLinkResolve.resolveTextStyle(
      context: context,
      size: TLinkSize.medium,
      theme: const TLinkThemeData(
        textStyle: TextStyle(fontWeight: FontWeight.w700),
      ),
      color: Colors.red,
    );

    expect(style.fontSize, 14);
    expect(style.height, 22 / 14);
    expect(style.fontWeight, FontWeight.w700);
    expect(style.color, Colors.red);
  });

  testWidgets('图标尺寸与间距对齐小程序', (tester) async {
    await tester.pumpWidget(wrap(const SizedBox()));
    final context = tester.element(find.byType(SizedBox));

    expect(
      TLinkResolve.resolveIconSize(size: TLinkSize.small, theme: null),
      14,
    );
    expect(
      TLinkResolve.resolveIconSize(size: TLinkSize.medium, theme: null),
      16,
    );
    expect(
      TLinkResolve.resolveIconSize(size: TLinkSize.large, theme: null),
      18,
    );
    expect(TLinkResolve.resolveIconGap(context: context, theme: null), 4);
    expect(
      TLinkResolve.resolveIconGap(
        context: context,
        theme: const TLinkThemeData(iconGap: 10),
      ),
      10,
    );
  });

  testWidgets('normal / active / disabled 使用对应语义 Token', (tester) async {
    final token = TThemeData.defaultData();
    await tester.pumpWidget(wrap(const SizedBox()));
    final context = tester.element(find.byType(SizedBox));

    expect(
      TLinkResolve.resolveColor(
        context: context,
        colorScheme: TLinkColorScheme.defaultTheme,
        theme: null,
        isDisabled: false,
        isActive: false,
      ),
      token.textColorPrimary,
    );
    expect(
      TLinkResolve.resolveColor(
        context: context,
        colorScheme: TLinkColorScheme.defaultTheme,
        theme: null,
        isDisabled: false,
        isActive: true,
      ),
      token.brandClickColor,
    );
    expect(
      TLinkResolve.resolveColor(
        context: context,
        colorScheme: TLinkColorScheme.primary,
        theme: null,
        isDisabled: true,
        isActive: false,
      ),
      token.brandDisabledColor,
    );
  });

  testWidgets('所有语义颜色方案均覆盖三种状态', (tester) async {
    await tester.pumpWidget(wrap(const SizedBox()));
    final context = tester.element(find.byType(SizedBox));
    for (final scheme in TLinkColorScheme.values) {
      for (final state in const [
        (false, false),
        (false, true),
        (true, false),
      ]) {
        expect(
          TLinkResolve.resolveColor(
            context: context,
            colorScheme: scheme,
            theme: null,
            isDisabled: state.$1,
            isActive: state.$2,
          ),
          isA<Color>(),
        );
      }
    }
  });
}
