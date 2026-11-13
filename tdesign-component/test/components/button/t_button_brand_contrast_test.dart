import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 主色填充按钮的文字颜色固定取 textColorAnti（白），不看主色亮度。
/// 主题生成器提供的黄色预设 #f3b814 上，白字对比度只有 1.8:1，读不清。
/// 这里断言：浅色主色上必须换成深色文字。
void main() {
  Widget wrap(TThemeData theme, Widget child) => MaterialApp(
        theme: ThemeData(extensions: [theme]),
        home: Scaffold(body: child),
      );

  testWidgets('浅色主色上主按钮文字不用白色', (tester) async {
    final theme = TThemeData.defaultData().copyWith(
      colorMap: {'brandColor': const Color(0xFFF3B814)},
    );

    await tester.pumpWidget(
      wrap(
        theme,
        const TButton(
          child: Text('Button'),
          variant: TButtonVariant.fill,
          colorPreset: TButtonColorPreset.primary,
          onPressed: _noop,
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('Button'));
    final style = text.style ?? DefaultTextStyle.of(tester.element(find.text('Button'))).style;
    final color = style.color;

    expect(color, isNotNull);
    // 白色在 #f3b814 上对比度 1.8:1，必须换掉
    expect(color, isNot(const Color(0xFFFFFFFF)));
  });

  testWidgets('深色主色上主按钮文字仍用白色', (tester) async {
    final theme = TThemeData.defaultData();

    await tester.pumpWidget(
      wrap(
        theme,
        const TButton(
          child: Text('Button'),
          variant: TButtonVariant.fill,
          colorPreset: TButtonColorPreset.primary,
          onPressed: _noop,
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('Button'));
    final style = text.style ?? DefaultTextStyle.of(tester.element(find.text('Button'))).style;
    expect(style.color, const Color(0xFFFFFFFF));
  });
}

void _noop() {}
