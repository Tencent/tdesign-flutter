import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 拉起一个空 MaterialApp，触发 TThemeData.defaultData() 默认单例，
/// 供 calculator 在 BuildContext 中读主题色/字号使用。
Future<BuildContext> _pumpContext(WidgetTester tester) async {
  late BuildContext captured;
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            captured = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    ),
  );
  return captured;
}

void main() {
  group('ItemDistanceCalculator 行为', () {
    const calculator = ItemDistanceCalculator();

    testWidgets('4 档距离映射 - calculateFontWeight 离散赋值',
        (tester) async {
      final context = await _pumpContext(tester);
      expect(calculator.calculateFontWeight(context, 0), FontWeight.w700);
      expect(calculator.calculateFontWeight(context, 0.4), FontWeight.w700);
      expect(calculator.calculateFontWeight(context, 1), FontWeight.w500);
      expect(calculator.calculateFontWeight(context, 2), FontWeight.w400);
      expect(calculator.calculateFontWeight(context, 3), FontWeight.w300);
      // 远超 distance 仍 clamp 到第 4 档
      expect(calculator.calculateFontWeight(context, 100), FontWeight.w300);
    });

    testWidgets('4 档距离映射 - calculateFont 按主题字号缩放',
        (tester) async {
      final context = await _pumpContext(tester);
      final baseSize = TTheme.of(context).fontBodyLarge?.size ?? 16.0;
      // 选中档 1.00x，紧邻 0.94x，近边 0.88x，最远 0.82x
      expect(calculator.calculateFont(context, 0), baseSize * 1.00);
      expect(calculator.calculateFont(context, 1), baseSize * 0.94);
      expect(calculator.calculateFont(context, 2), baseSize * 0.88);
      expect(calculator.calculateFont(context, 3), baseSize * 0.82);
      // round().clamp(0,3)：0.4 → 0 档，2.6 → 3 档
      expect(calculator.calculateFont(context, 0.4), baseSize * 1.00);
      expect(calculator.calculateFont(context, 2.6), baseSize * 0.82);
    });

    testWidgets('4 档距离映射 - calculateColor 主色 ↔ 占位色',
        (tester) async {
      final context = await _pumpContext(tester);
      final theme = TTheme.of(context);
      final primary = theme.textColorPrimary;
      final placeholder = theme.textColorPlaceholder;

      // 0 档 mix=0 → 主色
      expect(calculator.calculateColor(context, 0), primary);
      // 3 档 mix=1 → 占位色
      expect(calculator.calculateColor(context, 3), placeholder);
      // 1 档 mix=0.55，2 档 mix=0.78，使用 Color.lerp 与契约对齐
      expect(
        calculator.calculateColor(context, 1),
        Color.lerp(primary, placeholder, 0.55),
      );
      expect(
        calculator.calculateColor(context, 2),
        Color.lerp(primary, placeholder, 0.78),
      );
    });

    test('4 档距离映射 - calculateOpacity 选中不透明 / 其它 0.75', () {
      expect(calculator.calculateOpacity(0), 1.00);
      // distance.round() >= 1 → 0.75。注意 0.4.round() == 0 仍是选中档。
      expect(calculator.calculateOpacity(0.6), 0.75);
      expect(calculator.calculateOpacity(1), 0.75);
      expect(calculator.calculateOpacity(2), 0.75);
      expect(calculator.calculateOpacity(100), 0.75);
    });

    testWidgets('继承覆盖 - 子类重写 calculateColor 后, calculateFont 不受影响',
        (tester) async {
      final context = await _pumpContext(tester);

      // 自定义：第 0 档用 brand 颜色,其它档位继承默认行为
      const brandColor = Color(0xFF00BFFF);
      const custom = _BrandCalculator(brandColor);

      expect(custom.calculateColor(context, 0), brandColor);
      // 继承自父类的 calculateColor 在非 0 档走默认 lerp 逻辑
      final theme = TTheme.of(context);
      expect(
        custom.calculateColor(context, 1),
        Color.lerp(theme.textColorPrimary, theme.textColorPlaceholder, 0.55),
      );
      // 继承自父类的 calculateFontWeight 不变
      expect(custom.calculateFontWeight(context, 0), FontWeight.w700);
      expect(custom.calculateFontWeight(context, 1), FontWeight.w500);
    });
  });
}

/// 重写 calculateColor 的子类示例：第 0 档（选中）固定返回 brand 色。
class _BrandCalculator extends ItemDistanceCalculator {
  const _BrandCalculator(this.brandColor);
  final Color brandColor;

  @override
  Color calculateColor(BuildContext context, double distance) {
    if (distance.round().clamp(0, 3) == 0) {
      return brandColor;
    }
    return super.calculateColor(context, distance);
  }
}
