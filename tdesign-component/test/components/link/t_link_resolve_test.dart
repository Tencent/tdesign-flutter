import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/link/t_link_resolve.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 覆盖 [TLinkResolve] 的全部静态解析方法与颜色映射分支。
void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: ThemeData(extensions: [TThemeData.defaultData()]),
        home: Scaffold(body: child),
      );

  // ============================================================
  // 无需 context 的纯解析方法
  // ============================================================
  group('TLinkResolve 字号/图标/间距解析', () {
    test('resolveFontSize 各 size 默认值', () {
      expect(
          TLinkResolve.resolveFontSize(size: TLinkSize.small, theme: null), 12);
      expect(TLinkResolve.resolveFontSize(size: TLinkSize.medium, theme: null),
          14);
      expect(
          TLinkResolve.resolveFontSize(size: TLinkSize.large, theme: null), 16);
    });

    test('resolveFontSize 优先级：instance > theme > 默认', () {
      expect(
          TLinkResolve.resolveFontSize(
              size: TLinkSize.medium, theme: null, instanceFontSize: 20),
          20);
      expect(
          TLinkResolve.resolveFontSize(
              size: TLinkSize.medium,
              theme: const TLinkThemeData(fontSize: 18)),
          18);
    });

    test('resolveIconSize 各 size 默认值与 theme 优先级', () {
      expect(
          TLinkResolve.resolveIconSize(size: TLinkSize.small, theme: null), 14);
      expect(TLinkResolve.resolveIconSize(size: TLinkSize.medium, theme: null),
          16);
      expect(
          TLinkResolve.resolveIconSize(size: TLinkSize.large, theme: null), 18);
      expect(
          TLinkResolve.resolveIconSize(
              size: TLinkSize.medium,
              theme: const TLinkThemeData(iconSize: 22)),
          22);
    });

    test('resolveGap 各 size 默认值与 theme 优先级', () {
      final small = TLinkResolve.resolveGap(size: TLinkSize.small, theme: null);
      expect(small.$1, 6.05);
      expect(small.$2, 6.63);
      final medium =
          TLinkResolve.resolveGap(size: TLinkSize.medium, theme: null);
      expect(medium.$1, 6.34);
      expect(medium.$2, 7);
      final large = TLinkResolve.resolveGap(size: TLinkSize.large, theme: null);
      expect(large.$1, 8);
      expect(large.$2, 8);
      final themed = TLinkResolve.resolveGap(
        size: TLinkSize.medium,
        theme: const TLinkThemeData(leftGapWithIcon: 3, rightGapWithIcon: 4),
      );
      expect(themed.$1, 3);
      expect(themed.$2, 4);
    });
  });

  // ============================================================
  // 需要 context 的颜色解析（覆盖正常/禁用 × 各 colorScheme）
  // ============================================================
  group('TLinkResolve 颜色解析', () {
    Future<BuildContext> _context(WidgetTester tester) async {
      await tester.pumpWidget(wrap(const SizedBox()));
      return tester.element(find.byType(SizedBox));
    }

    testWidgets('resolveColor 正常态覆盖全部 colorScheme', (tester) async {
      final context = await _context(tester);
      for (final scheme in TLinkColorScheme.values) {
        final color = TLinkResolve.resolveColor(
          context: context,
          colorScheme: scheme,
          theme: null,
          isDisabled: false,
        );
        expect(color, isA<Color>());
      }
    });

    testWidgets('resolveColor 禁用态覆盖全部 colorScheme', (tester) async {
      final context = await _context(tester);
      for (final scheme in TLinkColorScheme.values) {
        final color = TLinkResolve.resolveColor(
          context: context,
          colorScheme: scheme,
          theme: null,
          isDisabled: true,
        );
        expect(color, isA<Color>());
      }
    });

    testWidgets('resolveColor 优先级：instance > theme > scheme', (tester) async {
      final context = await _context(tester);
      // instance 优先
      expect(
        TLinkResolve.resolveColor(
          context: context,
          colorScheme: TLinkColorScheme.primary,
          theme: const TLinkThemeData(color: Colors.green),
          isDisabled: false,
          instanceColor: Colors.purple,
        ),
        Colors.purple,
      );
      // theme 次之
      expect(
        TLinkResolve.resolveColor(
          context: context,
          colorScheme: TLinkColorScheme.danger,
          theme: const TLinkThemeData(color: Colors.green),
          isDisabled: false,
        ),
        Colors.green,
      );
    });
  });
}
