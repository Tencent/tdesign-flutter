import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  final token = TThemeData.defaultData();

  ThemeData fullTheme({BadgeThemeData? badgeTheme}) {
    final theme = TThemeBuilder.light(token);
    return badgeTheme == null ? theme : theme.copyWith(badgeTheme: badgeTheme);
  }

  ThemeData bareTokenTheme() => ThemeData(
    extensions: <ThemeExtension<dynamic>>[token, const TBadgeThemeData()],
  );

  Widget app(
    Widget child, {
    ThemeData? theme,
    BadgeThemeData? localBadgeTheme,
  }) {
    final content = localBadgeTheme == null
        ? child
        : BadgeTheme(data: localBadgeTheme, child: child);
    return MaterialApp(
      theme: theme ?? fullTheme(),
      home: Scaffold(body: Center(child: content)),
    );
  }

  Badge badgeOf(WidgetTester tester) =>
      tester.widget<Badge>(find.byType(Badge));

  group('数量与可见性', () {
    testWidgets('显示普通数量并保留 child', (tester) async {
      await tester.pumpWidget(
        app(const TBadge(label: '8', child: Text('Inbox'))),
      );

      expect(find.text('8'), findsOneWidget);
      expect(find.text('Inbox'), findsOneWidget);
    });

    testWidgets('label 原样展示数字', (tester) async {
      await tester.pumpWidget(app(const TBadge(label: '99')));

      expect(find.text('99'), findsOneWidget);
      expect(find.text('99+'), findsNothing);
    });

    testWidgets('label 支持 99+ 等自定义文本', (tester) async {
      await tester.pumpWidget(app(const TBadge(label: '99+')));

      expect(find.text('99+'), findsOneWidget);
      expect(find.text('120'), findsNothing);
    });

    testWidgets('label 更新后同步展示', (tester) async {
      await tester.pumpWidget(app(const TBadge(label: '8')));
      expect(find.text('8'), findsOneWidget);

      await tester.pumpWidget(app(const TBadge(label: '10')));
      expect(find.text('8'), findsNothing);
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('showZero 控制零值，隐藏时仍保留 child', (tester) async {
      const childKey = Key('badge-child');
      await tester.pumpWidget(
        app(
          const TBadge(
            label: '0',
            showZero: false,
            child: SizedBox(key: childKey, width: 24, height: 20),
          ),
        ),
      );

      expect(badgeOf(tester).isLabelVisible, isFalse);
      expect(find.text('0'), findsNothing);
      expect(tester.getSize(find.byKey(childKey)), const Size(24, 20));

      await tester.pumpWidget(app(const TBadge(label: '0')));
      expect(badgeOf(tester).isLabelVisible, isTrue);
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('dot 忽略 showZero 并始终不创建文字标签', (tester) async {
      await tester.pumpWidget(
        app(
          const TBadge(label: '0', variant: TBadgeVariant.dot, showZero: false),
        ),
      );

      final badge = badgeOf(tester);
      expect(badge.label, isNull);
      expect(badge.isLabelVisible, isTrue);
      expect(find.text('0'), findsNothing);
    });

    testWidgets('label 支持任意短文本和空值隐藏', (tester) async {
      expect(const TBadge(label: 'NEW').label, 'NEW');

      await tester.pumpWidget(app(const TBadge(label: null)));
      expect(badgeOf(tester).isLabelVisible, isFalse);
    });
  });

  group('布局与形态', () {
    testWidgets('文字标签使用 TText 收紧单行外侧行高并均分 leading', (tester) async {
      await tester.pumpWidget(app(const TBadge(label: '8')));

      final label = tester.widget<TText>(find.widgetWithText(TText, '8'));
      expect(label.style?.fontSize, token.fontMarkExtraSmall?.size);
      expect(label.style?.height, token.fontMarkExtraSmall?.height);
      expect(label.style?.fontWeight, token.fontMarkExtraSmall?.fontWeight);
      expect(label.style?.leadingDistribution, TextLeadingDistribution.even);
      expect(label.textHeightBehavior?.applyHeightToFirstAscent, isFalse);
      expect(label.textHeightBehavior?.applyHeightToLastDescent, isFalse);
    });

    testWidgets('显式 leadingDistribution 保持 BadgeTheme 配置', (tester) async {
      const textStyle = TextStyle(
        fontSize: 11,
        height: 1.4,
        leadingDistribution: TextLeadingDistribution.proportional,
      );
      await tester.pumpWidget(
        app(
          const TBadge(label: '12'),
          localBadgeTheme: const BadgeThemeData(textStyle: textStyle),
        ),
      );

      final label = tester.widget<TText>(find.widgetWithText(TText, '12'));
      expect(badgeOf(tester).textStyle, textStyle);
      expect(
        label.style?.leadingDistribution,
        TextLeadingDistribution.proportional,
      );
    });

    testWidgets('单字符与多字符标签在文本缩放后仍由徽标容器居中', (tester) async {
      const key8 = Key('badge-8');
      const key12 = Key('badge-12');
      const key99Plus = Key('badge-99-plus');
      await tester.pumpWidget(
        app(
          const MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TBadge(key: key8, label: '8'),
                SizedBox(width: 8),
                TBadge(key: key12, label: '12'),
                SizedBox(width: 8),
                TBadge(key: key99Plus, label: '99+'),
              ],
            ),
          ),
        ),
      );

      for (final (key, text) in [
        (key8, '8'),
        (key12, '12'),
        (key99Plus, '99+'),
      ]) {
        final badge = find.byKey(key);
        final label = find.descendant(
          of: badge,
          matching: find.widgetWithText(TText, text),
        );
        expect(
          (tester.getCenter(label).dy - tester.getCenter(badge).dy).abs(),
          lessThan(0.01),
        );
      }
    });

    testWidgets('无 child 时 normal 是独立徽标', (tester) async {
      await tester.pumpWidget(app(const TBadge(label: '8')));

      final size = tester.getSize(find.byType(Badge));
      expect(size.height, 16);
      expect(size.width, greaterThanOrEqualTo(16));
    });

    testWidgets('无 child 时 dot 使用圆点尺寸而非占位尺寸', (tester) async {
      await tester.pumpWidget(app(const TBadge(variant: TBadgeVariant.dot)));

      expect(tester.getSize(find.byType(Badge)), const Size(8, 8));
    });

    testWidgets('有 child 时 dot 仍使用 8px 圆点尺寸', (tester) async {
      await tester.pumpWidget(
        app(
          const TBadge(
            variant: TBadgeVariant.dot,
            child: SizedBox(width: 24, height: 24),
          ),
        ),
      );

      expect(badgeOf(tester).smallSize, 8);
      expect(tester.getSize(find.byType(TBadge)), const Size(24, 24));
    });

    testWidgets('无 child 且隐藏时收敛为零尺寸', (tester) async {
      await tester.pumpWidget(app(const TBadge(showZero: false)));

      expect(tester.getSize(find.byType(Badge)), Size.zero);
    });

    testWidgets('large 使用 fontMarkSmall 与 20px 行盒', (tester) async {
      await tester.pumpWidget(
        app(const TBadge(label: '8', size: TBadgeSize.large)),
      );

      expect(badgeOf(tester).largeSize, 20);
      expect(tester.getSize(find.byType(Badge)).height, 20);
      final label = tester.widget<TText>(find.widgetWithText(TText, '8'));
      expect(label.style?.fontSize, token.fontMarkSmall?.size);
      expect(label.style?.height, token.fontMarkSmall?.height);
      expect(
        badgeOf(tester).padding,
        const EdgeInsets.symmetric(horizontal: 5),
      );
    });

    testWidgets('实例 offset 优先于 BadgeTheme offset', (tester) async {
      await tester.pumpWidget(
        app(
          const TBadge(label: '8', offset: Offset(7, 9)),
          localBadgeTheme: const BadgeThemeData(offset: Offset(1, 2)),
        ),
      );

      expect(badgeOf(tester).offset, const Offset(7, 9));
    });

    testWidgets('square 与 bubble 使用各自结构形态', (tester) async {
      await tester.pumpWidget(
        app(
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TBadge(label: '8', variant: TBadgeVariant.square),
              SizedBox(width: 8),
              TBadge(label: '领取积分', variant: TBadgeVariant.bubble),
            ],
          ),
        ),
      );

      expect(find.text('8'), findsOneWidget);
      expect(find.text('领取积分'), findsOneWidget);
      expect(find.byType(DecoratedBox), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('左右 ribbon 与 triangle 贴合 child 且不溢出', (tester) async {
      await tester.pumpWidget(
        app(
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TBadge(
                label: 'NEW',
                variant: TBadgeVariant.ribbonLeft,
                child: SizedBox(width: 120, height: 48),
              ),
              TBadge(
                label: 'NEW',
                variant: TBadgeVariant.ribbonRight,
                child: SizedBox(width: 120, height: 48),
              ),
              TBadge(
                label: 'NEW',
                variant: TBadgeVariant.triangleLeft,
                child: SizedBox(width: 120, height: 48),
              ),
              TBadge(
                label: 'NEW',
                variant: TBadgeVariant.triangleRight,
                child: SizedBox(width: 120, height: 48),
              ),
            ],
          ),
        ),
      );

      expect(find.text('NEW'), findsNWidgets(4));
      expect(find.byType(CustomPaint), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('全部形态在 1.0、1.5、2.0 文本缩放下保持锚定尺寸', (tester) async {
      for (final scale in [1.0, 1.5, 2.0]) {
        await tester.pumpWidget(
          app(
            MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(scale)),
              child: Wrap(
                children: [
                  for (final variant in TBadgeVariant.values)
                    TBadge(
                      label: 'NEW',
                      variant: variant,
                      child: const SizedBox.square(dimension: 48),
                    ),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(TBadge), findsNWidgets(TBadgeVariant.values.length));
        for (final badge in find.byType(TBadge).evaluate()) {
          expect(
            tester.getSize(find.byWidget(badge.widget)),
            const Size(48, 48),
          );
        }
        expect(tester.takeException(), isNull, reason: 'text scale $scale');
      }
    });

    testWidgets('corner 的 left/right 是物理方位且不受 RTL 翻转', (tester) async {
      const leftKey = Key('rtl-left-corner');
      const rightKey = Key('rtl-right-corner');
      await tester.pumpWidget(
        app(
          const Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TBadge(
                  key: leftKey,
                  label: 'L',
                  variant: TBadgeVariant.ribbonLeft,
                  child: SizedBox(width: 96, height: 48),
                ),
                SizedBox(width: 16),
                TBadge(
                  key: rightKey,
                  label: 'R',
                  variant: TBadgeVariant.ribbonRight,
                  child: SizedBox(width: 96, height: 48),
                ),
              ],
            ),
          ),
        ),
      );

      double relativeCornerX(Key key) {
        final badge = find.byKey(key);
        final paint = find.descendant(
          of: badge,
          matching: find.byType(CustomPaint),
        );
        return tester.getCenter(paint).dx - tester.getTopLeft(badge).dx;
      }

      expect(relativeCornerX(leftKey), lessThan(48));
      expect(relativeCornerX(rightKey), greaterThan(48));
    });

    testWidgets('corner 遵循 showZero 并在隐藏时保留 child', (tester) async {
      const childKey = Key('hidden-corner-child');
      await tester.pumpWidget(
        app(
          const TBadge(
            label: '0',
            showZero: false,
            variant: TBadgeVariant.triangleRight,
            child: SizedBox(key: childKey, width: 96, height: 48),
          ),
        ),
      );

      expect(
        find.descendant(
          of: find.byType(TBadge),
          matching: find.byType(CustomPaint),
        ),
        findsNothing,
      );
      expect(find.text('0'), findsNothing);
      expect(tester.getSize(find.byKey(childKey)), const Size(96, 48));
    });

    testWidgets('corner 支持描边、点击与等值 painter 更新', (tester) async {
      var taps = 0;
      Widget borderedCorner() => app(
        TBadge(
          label: 'NEW',
          variant: TBadgeVariant.ribbonRight,
          border: true,
          onTap: () => taps++,
          child: const SizedBox(width: 96, height: 48),
        ),
      );

      await tester.pumpWidget(borderedCorner());
      await tester.tap(find.byType(TBadge));
      expect(taps, 1);

      // 以等值的新 delegate 更新，覆盖 shouldRepaint 的完整比较链。
      await tester.pumpWidget(borderedCorner());
      expect(tester.takeException(), isNull);
    });

    testWidgets('alignment 和 offset 改变实际徽标位置', (tester) async {
      const topEndKey = Key('top-end');
      const bottomStartKey = Key('bottom-start');
      const offsetKey = Key('bottom-start-offset');
      await tester.pumpWidget(
        app(
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              BadgeTheme(
                data: BadgeThemeData(
                  alignment: AlignmentDirectional.topEnd,
                  offset: Offset.zero,
                ),
                child: TBadge(
                  key: topEndKey,
                  label: '8',
                  child: SizedBox.square(dimension: 40),
                ),
              ),
              SizedBox(width: 32),
              BadgeTheme(
                data: BadgeThemeData(
                  alignment: AlignmentDirectional.bottomStart,
                  offset: Offset.zero,
                ),
                child: TBadge(
                  key: bottomStartKey,
                  label: '8',
                  child: SizedBox.square(dimension: 40),
                ),
              ),
              SizedBox(width: 32),
              BadgeTheme(
                data: BadgeThemeData(
                  alignment: AlignmentDirectional.bottomStart,
                  offset: Offset(3, 4),
                ),
                child: TBadge(
                  key: offsetKey,
                  label: '8',
                  child: SizedBox.square(dimension: 40),
                ),
              ),
            ],
          ),
        ),
      );

      Offset relativeLabelCenter(Key badgeKey) {
        final badgeFinder = find.byKey(badgeKey);
        final labelFinder = find.descendant(
          of: badgeFinder,
          matching: find.text('8'),
        );
        return tester.getCenter(labelFinder) - tester.getTopLeft(badgeFinder);
      }

      final topEnd = relativeLabelCenter(topEndKey);
      final bottomStart = relativeLabelCenter(bottomStartKey);
      final withOffset = relativeLabelCenter(offsetKey);

      expect(topEnd.dx, greaterThan(bottomStart.dx));
      expect(topEnd.dy, lessThan(bottomStart.dy));
      expect(withOffset - bottomStart, const Offset(3, 4));
    });

    testWidgets('相同尺寸的标准与自定义 child 使用一致的徽标位置', (tester) async {
      const standardKey = Key('standard-badge');
      const customKey = Key('custom-badge');
      await tester.pumpWidget(
        app(
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TBadge(
                key: standardKey,
                label: '8',
                child: SizedBox.square(dimension: 40),
              ),
              SizedBox(width: 32),
              TBadge(
                key: customKey,
                label: '8',
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: SizedBox.square(dimension: 40),
                ),
              ),
            ],
          ),
        ),
      );

      Offset relativeLabelPosition(Key badgeKey) {
        final badgeFinder = find.byKey(badgeKey);
        final labelFinder = find.descendant(
          of: badgeFinder,
          matching: find.text('8'),
        );
        return tester.getTopLeft(labelFinder) - tester.getTopLeft(badgeFinder);
      }

      expect(
        relativeLabelPosition(customKey),
        relativeLabelPosition(standardKey),
      );
    });

    testWidgets('border 不引入双层 padding 或改变徽标尺寸', (tester) async {
      const plainKey = Key('plain');
      const borderedKey = Key('bordered');
      await tester.pumpWidget(
        app(
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TBadge(key: plainKey, label: '88'),
              SizedBox(width: 20),
              TBadge(key: borderedKey, label: '88', border: true),
            ],
          ),
        ),
      );

      expect(
        tester.getSize(find.byKey(borderedKey)),
        tester.getSize(find.byKey(plainKey)),
      );
    });

    testWidgets('dot 开启 border 后仍保持可见和圆点尺寸', (tester) async {
      await tester.pumpWidget(
        app(const TBadge(variant: TBadgeVariant.dot, border: true)),
      );

      expect(tester.getSize(find.byType(Badge)), const Size(8, 8));
      final decorations = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .map((box) => box.decoration)
          .whereType<BoxDecoration>();
      expect(
        decorations.any((decoration) => decoration.border != null),
        isTrue,
      );
    });
  });

  group('主题解析', () {
    testWidgets('TThemeBuilder 不投影 smallSize 且 TBadge 使用 8px Dot', (
      tester,
    ) async {
      final theme = TThemeBuilder.light(TThemeData.defaultData());
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(
            body: Row(
              children: [
                Badge(),
                TBadge(variant: TBadgeVariant.dot),
              ],
            ),
          ),
        ),
      );

      expect(theme.badgeTheme.smallSize, isNull);
      expect(tester.getSize(find.byType(Badge).first), const Size.square(6));
      expect(tester.getSize(find.byType(Badge).last), const Size.square(8));
    });

    testWidgets('完整 TDesign Theme 映射默认视觉 token', (tester) async {
      await tester.pumpWidget(app(const TBadge(label: '8')));

      final badge = badgeOf(tester);
      expect(badge.backgroundColor, token.errorNormalColor);
      expect(badge.textColor, token.textColorAnti);
      expect(badge.largeSize, 16);
      expect(badge.smallSize, 8);
      expect(badge.padding, const EdgeInsets.symmetric(horizontal: 4));
      expect(badge.textStyle?.fontSize, token.fontMarkExtraSmall?.size);
      expect(badge.textStyle?.height, token.fontMarkExtraSmall?.height);
    });

    testWidgets('裸 TThemeData 仍兜底颜色和基础尺寸', (tester) async {
      await tester.pumpWidget(
        app(const TBadge(label: '8'), theme: bareTokenTheme()),
      );

      final badge = badgeOf(tester);
      expect(badge.backgroundColor, token.errorNormalColor);
      expect(badge.textColor, token.textColorAnti);
      expect(badge.largeSize, 16);
      expect(badge.smallSize, 8);
      expect(badge.padding, const EdgeInsets.symmetric(horizontal: 4));
    });

    testWidgets('ThemeData.badgeTheme 可控制完整视觉', (tester) async {
      const badgeTheme = BadgeThemeData(
        backgroundColor: Colors.green,
        textColor: Colors.yellow,
        smallSize: 8,
        largeSize: 20,
        textStyle: TextStyle(fontSize: 13, height: 1.2),
        padding: EdgeInsets.symmetric(horizontal: 7),
        alignment: AlignmentDirectional.bottomEnd,
        offset: Offset(2, 3),
      );
      await tester.pumpWidget(
        app(
          const TBadge(label: '8', child: SizedBox(width: 24, height: 24)),
          theme: fullTheme(badgeTheme: badgeTheme),
        ),
      );

      final badge = badgeOf(tester);
      expect(badge.backgroundColor, Colors.green);
      expect(badge.textColor, Colors.yellow);
      expect(badge.smallSize, 8);
      expect(badge.largeSize, 20);
      expect(badge.textStyle, badgeTheme.textStyle);
      expect(badge.padding, badgeTheme.padding);
      expect(badge.alignment, badgeTheme.alignment);
      expect(badge.offset, badgeTheme.offset);
    });

    testWidgets('TThemeBuilder 投影不覆盖 TBadge 两档尺寸 token', (tester) async {
      await tester.pumpWidget(
        app(
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TBadge(label: '8'),
              TBadge(label: '8', size: TBadgeSize.large),
            ],
          ),
        ),
      );

      final badges = tester.widgetList<Badge>(find.byType(Badge)).toList();
      expect(badges[0].largeSize, 16);
      expect(badges[0].padding, const EdgeInsets.symmetric(horizontal: 4));
      expect(badges[0].textStyle?.fontSize, token.fontMarkExtraSmall?.size);
      expect(badges[1].largeSize, 20);
      expect(badges[1].padding, const EdgeInsets.symmetric(horizontal: 5));
      expect(badges[1].textStyle?.fontSize, token.fontMarkSmall?.size);
    });

    testWidgets('large 保留与中号默认数值相同的显式全局主题', (tester) async {
      final baseTheme = fullTheme();
      final projectedBadgeTheme = baseTheme.badgeTheme;
      final explicitBadgeTheme = BadgeThemeData(
        textStyle: projectedBadgeTheme.textStyle,
        padding: projectedBadgeTheme.padding,
        largeSize: 24,
      );
      await tester.pumpWidget(
        app(
          const TBadge(label: '8', size: TBadgeSize.large),
          theme: baseTheme.copyWith(badgeTheme: explicitBadgeTheme),
        ),
      );

      final badge = badgeOf(tester);
      expect(badge.largeSize, 24);
      expect(badge.textStyle, explicitBadgeTheme.textStyle);
      expect(badge.padding, explicitBadgeTheme.padding);
    });

    testWidgets('局部 BadgeTheme 按字段覆盖并继承全局未设置字段', (tester) async {
      const globalTheme = BadgeThemeData(
        backgroundColor: Colors.red,
        textColor: Colors.yellow,
        smallSize: 7,
        largeSize: 18,
        textStyle: TextStyle(fontSize: 12),
        padding: EdgeInsets.symmetric(horizontal: 5),
        alignment: AlignmentDirectional.topStart,
        offset: Offset(1, 2),
      );
      await tester.pumpWidget(
        app(
          const TBadge(label: '8', child: SizedBox(width: 24, height: 24)),
          theme: fullTheme(badgeTheme: globalTheme),
          localBadgeTheme: const BadgeThemeData(
            backgroundColor: Colors.green,
            largeSize: 22,
          ),
        ),
      );

      final badge = badgeOf(tester);
      expect(badge.backgroundColor, Colors.green);
      expect(badge.largeSize, 22);
      expect(badge.textColor, globalTheme.textColor);
      expect(badge.smallSize, globalTheme.smallSize);
      expect(badge.textStyle, globalTheme.textStyle);
      expect(badge.padding, globalTheme.padding);
      expect(badge.alignment, globalTheme.alignment);
      expect(badge.offset, globalTheme.offset);
    });

    testWidgets('Flutter textTheme 在 BadgeTheme 未指定文字样式时生效', (tester) async {
      const labelStyle = TextStyle(fontSize: 15, height: 1.1);
      final theme = bareTokenTheme().copyWith(
        textTheme: const TextTheme(labelSmall: labelStyle),
      );
      await tester.pumpWidget(app(const TBadge(label: '8'), theme: theme));

      expect(badgeOf(tester).textStyle?.fontSize, labelStyle.fontSize);
      expect(badgeOf(tester).textStyle?.height, labelStyle.height);
    });

    testWidgets('TBadgeThemeData 控制描边，局部 BadgeTheme 控制内容色', (tester) async {
      const extension = TBadgeThemeData(
        borderColor: Colors.green,
        borderWidth: 2,
      );
      await tester.pumpWidget(
        app(
          const TBadge(label: '2', border: true),
          theme: fullTheme().mergeExtension(extension),
          localBadgeTheme: const BadgeThemeData(
            backgroundColor: Colors.orange,
            textColor: Colors.black,
          ),
        ),
      );

      final decoration = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .map((box) => box.decoration)
          .whereType<BoxDecoration>()
          .singleWhere((decoration) => decoration.border != null);
      expect(decoration.color, Colors.orange);
      expect(decoration.border, Border.all(color: Colors.green, width: 2));
      expect(badgeOf(tester).textColor, Colors.black);
    });
  });

  group('交互与 ThemeExtension', () {
    testWidgets('onTap 是唯一交互开关', (tester) async {
      var taps = 0;
      await tester.pumpWidget(app(TBadge(label: '1', onTap: () => taps++)));

      await tester.tap(find.byType(TBadge));
      expect(taps, 1);
      expect(
        find.descendant(
          of: find.byType(TBadge),
          matching: find.byType(GestureDetector),
        ),
        findsOneWidget,
      );

      await tester.pumpWidget(app(const TBadge(label: '1')));
      expect(
        find.descendant(
          of: find.byType(TBadge),
          matching: find.byType(GestureDetector),
        ),
        findsNothing,
      );
    });

    test('TBadgeThemeData copyWith 和 lerp 覆盖完整分支', () {
      const data = TBadgeThemeData(borderColor: Colors.red, borderWidth: 1);
      expect(data.copyWith(borderWidth: 2).borderWidth, 2);
      expect(data.copyWith().borderColor, Colors.red);
      expect(
        data.lerp(const TBadgeThemeData(borderWidth: 3), 0.5).borderWidth,
        2,
      );
      expect(data.lerp(null, 0.5), same(data));
    });
  });
}
