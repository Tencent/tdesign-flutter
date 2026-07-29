import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TProgress V1.0 Widget 测试
///
/// 覆盖 variant 四档（linear/circular/micro/button）、value 边界、
/// label 位置、Theme 各字段、copyWith/lerp、边界情况。
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child, {TProgressThemeData? progressTheme}) {
    final themeExtensions = <ThemeExtension>[
      if (progressTheme != null) progressTheme,
    ];
    // 注意：必须通过 MaterialApp.theme 传递 extensions，
    // 用外层 Theme 包 MaterialApp 会被 MaterialApp 默认 ThemeData.light() 覆盖，导致 extension 丢失。
    return MaterialApp(
      theme: ThemeData(
        extensions: [TThemeData.defaultData(), ...themeExtensions],
      ),
      home: Scaffold(body: child),
    );
  }

  group('TProgress 基础渲染', () {
    testWidgets('linear variant 默认渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TProgress(variant: TProgressVariant.linear, value: 0.5),
      ));
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('value 为 null 时保持 indeterminate 语义', (tester) async {
      final progress = TProgress(variant: TProgressVariant.linear);
      expect(progress.value, isNull);
      await tester.pumpWidget(wrapWithTheme(progress));
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('value 被 clamp 到 0-1 范围', (tester) async {
      final progress = TProgress(variant: TProgressVariant.linear, value: 1.5);
      expect(progress.value, 1.0);

      final progress2 =
          TProgress(variant: TProgressVariant.linear, value: -0.5);
      expect(progress2.value, 0.0);
    });

    testWidgets('circular null value renders indeterminate indicator',
        (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TProgress(variant: TProgressVariant.circular),
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('value, color and label updates refresh resolved state',
        (tester) async {
      Widget build(double value, Color color, Widget label) => wrapWithTheme(
            TProgress(
              variant: TProgressVariant.circular,
              value: value,
              label: label,
            ),
            progressTheme: TProgressThemeData(color: color),
          );

      await tester.pumpWidget(build(0.2, Colors.red, const Text('old')));
      await tester.pumpWidget(build(0.8, Colors.blue, const Text('new')));
      await tester.pump();

      expect(find.text('new'), findsOneWidget);
      expect(find.text('old'), findsNothing);
    });
  });

  group('TProgress variant 四档', () {
    testWidgets('variant: linear 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 200,
          child: TProgress(
            variant: TProgressVariant.linear,
            value: 0.5,
          ),
        ),
      ));
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('variant: circular 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TProgress(variant: TProgressVariant.circular, value: 0.6),
      ));
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('variant: micro 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TProgress(variant: TProgressVariant.micro, value: 0.3),
      ));
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('variant: button 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 200,
          child: TProgress(variant: TProgressVariant.button, value: 0.7),
        ),
      ));
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });
  });

  group('TProgress 交互形态', () {
    testWidgets('button variant 支持点击', (tester) async {
      var taps = 0;
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 200,
          child: TProgress(
            variant: TProgressVariant.button,
            value: 0.5,
            onTap: () => taps++,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(TProgress));
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('micro variant 支持点击', (tester) async {
      var taps = 0;
      await tester.pumpWidget(wrapWithTheme(
        TProgress(
          variant: TProgressVariant.micro,
          value: 0.5,
          onTap: () => taps++,
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(TProgress));
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('linear variant 不响应交互回调', (tester) async {
      var taps = 0;
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 200,
          child: TProgress(
            variant: TProgressVariant.linear,
            value: 0.5,
            onTap: () => taps++,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(TProgress));
      await tester.pump();
      expect(taps, 0);
    });
  });

  group('TProgress label 显示', () {
    testWidgets('linear value=0.5 显示 50%', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          child: TProgress(
            variant: TProgressVariant.linear,
            value: 0.5,
          ),
        ),
      ));
      await tester.pump();
      expect(find.text('50%'), findsWidgets);
    });

    testWidgets('linear value=0.0 不显示百分比文字', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          child: TProgress(
            variant: TProgressVariant.linear,
            value: 0.0,
          ),
        ),
      ));
      await tester.pump();
      // value 不为 null 时（即使是 0.0）getAutoText 仍渲染 "0%" 文本
      expect(find.text('0%'), findsWidgets);
    });

    testWidgets('labelPosition: left 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          child: TProgress(
            variant: TProgressVariant.linear,
            value: 0.5,
          ),
        ),
        progressTheme: const TProgressThemeData(
          progressLabelPosition: TProgressLabelPosition.left,
        ),
      ));
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('labelPosition: right 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          child: TProgress(
            variant: TProgressVariant.linear,
            value: 0.5,
          ),
        ),
        progressTheme: const TProgressThemeData(
          progressLabelPosition: TProgressLabelPosition.right,
        ),
      ));
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('showLabel: false 隐藏标签', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          child: TProgress(
            variant: TProgressVariant.linear,
            value: 0.5,
          ),
        ),
        progressTheme: const TProgressThemeData(showLabel: false),
      ));
      await tester.pump();
      expect(find.text('50%'), findsNothing);
    });

    testWidgets('自定义 Text 标签', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          child: TProgress(
            variant: TProgressVariant.linear,
            value: 0.5,
            label: const Text('自定义'),
          ),
        ),
      ));
      await tester.pump();
      expect(find.text('自定义'), findsWidgets);
    });

    testWidgets('Icon 标签渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TProgress(
          variant: TProgressVariant.circular,
          value: 0.5,
          label: const Icon(Icons.star),
        ),
      ));
      await tester.pump();
      expect(find.byIcon(Icons.star), findsWidgets);
    });
  });

  group('TProgress Theme', () {
    testWidgets('Theme.color 覆盖进度条颜色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 200,
          child: TProgress(variant: TProgressVariant.linear, value: 0.5),
        ),
        progressTheme: const TProgressThemeData(color: Colors.red),
      ));
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('Theme.strokeWidth 覆盖粗细', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 200,
          child: TProgress(variant: TProgressVariant.linear, value: 0.5),
        ),
        progressTheme: const TProgressThemeData(strokeWidth: 10),
      ));
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('Theme.backgroundColor 覆盖背景色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 200,
          child: TProgress(variant: TProgressVariant.linear, value: 0.5),
        ),
        progressTheme: const TProgressThemeData(backgroundColor: Colors.grey),
      ));
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('Theme.circleRadius 覆盖环形半径', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TProgress(variant: TProgressVariant.circular, value: 0.5),
        progressTheme: const TProgressThemeData(circleRadius: 150),
      ));
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('实例 label 与 Theme 位置配合渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          child: TProgress(
            variant: TProgressVariant.linear,
            value: 0.5,
            label: const Text('加载中'),
          ),
        ),
        progressTheme: const TProgressThemeData(
          progressLabelPosition: TProgressLabelPosition.left,
        ),
      ));
      await tester.pump();
      expect(find.text('加载中'), findsOneWidget);
    });

    testWidgets('Theme.animationDuration 覆盖动画时长', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 200,
          child: TProgress(variant: TProgressVariant.linear, value: 0.5),
        ),
        progressTheme: const TProgressThemeData(
          animationDuration: Duration(milliseconds: 500),
        ),
      ));
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });
  });

  group('TProgressThemeData copyWith 和 lerp', () {
    test('copyWith 部分覆盖', () {
      const theme = TProgressThemeData(
        strokeWidth: 5,
        color: Colors.red,
        circleRadius: 100,
      );
      final copied = theme.copyWith(strokeWidth: 10);
      expect(copied.strokeWidth, 10);
      expect(copied.color, Colors.red);
      expect(copied.circleRadius, 100);
    });

    test('copyWith 不覆盖时保持原值', () {
      const theme = TProgressThemeData(
        strokeWidth: 5,
        backgroundColor: Colors.blue,
      );
      final copied = theme.copyWith();
      expect(copied.strokeWidth, 5);
      expect(copied.backgroundColor, Colors.blue);
    });

    test('lerp 非 TProgressThemeData 返回自身', () {
      const theme = TProgressThemeData(strokeWidth: 5);
      final result = theme.lerp(null, 0.5);
      expect(result.strokeWidth, 5);
    });

    test('lerp strokeWidth 插值', () {
      const a = TProgressThemeData(strokeWidth: 10);
      const b = TProgressThemeData(strokeWidth: 30);
      final result = a.lerp(b, 0.5);
      expect(result.strokeWidth, 20);
    });

    test('lerp animationDuration 插值', () {
      const a =
          TProgressThemeData(animationDuration: Duration(milliseconds: 100));
      const b =
          TProgressThemeData(animationDuration: Duration(milliseconds: 300));
      final result = a.lerp(b, 0.5);
      expect(result.animationDuration?.inMilliseconds, 200);
    });

    test('lerp 两端 animationDuration 均为 null 返回 null', () {
      const a = TProgressThemeData();
      const b = TProgressThemeData();
      final result = a.lerp(b, 0.5);
      expect(result.animationDuration, isNull);
    });

    test('lerp a animationDuration 为 null 返回 b 值', () {
      const a = TProgressThemeData();
      const b =
          TProgressThemeData(animationDuration: Duration(milliseconds: 200));
      final result = a.lerp(b, 0.5);
      expect(result.animationDuration?.inMilliseconds, 200);
    });

    test('lerp b animationDuration 为 null 返回 a 值', () {
      const a =
          TProgressThemeData(animationDuration: Duration(milliseconds: 100));
      const b = TProgressThemeData();
      final result = a.lerp(b, 0.5);
      expect(result.animationDuration?.inMilliseconds, 100);
    });
  });

  group('TProgress 边界情况', () {
    testWidgets('value=1.0 满进度渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 200,
          child: TProgress(variant: TProgressVariant.linear, value: 1.0),
        ),
      ));
      await tester.pump();
      expect(find.text('100%'), findsWidgets);
    });

    testWidgets('value=0.05 小进度走 outside label 路径', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          child: TProgress(variant: TProgressVariant.linear, value: 0.05),
        ),
      ));
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('micro variant 不显示百分比文字', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TProgress(variant: TProgressVariant.micro, value: 0.5),
      ));
      await tester.pump();
      // micro 类型不显示自动文字
      expect(find.text('50%'), findsNothing);
    });

    testWidgets('circular variant 中心显示标签', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TProgress(variant: TProgressVariant.circular, value: 0.5),
      ));
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });
  });
}
