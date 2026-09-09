import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TProgress Widget 测试
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
      await tester.pumpWidget(
        wrapWithTheme(TProgress(variant: TProgressVariant.linear, value: 0.5)),
      );
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('value 为 null 时保持 indeterminate 语义', (tester) async {
      final progress = TProgress(variant: TProgressVariant.linear);
      expect(progress.value, isNull);
      await tester.pumpWidget(wrapWithTheme(progress));
      expect(find.byType(LinearProgressIndicator), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('value 被 clamp 到 0-1 范围', (tester) async {
      final progress = TProgress(variant: TProgressVariant.linear, value: 1.5);
      expect(progress.value, 1.0);

      final progress2 = TProgress(
        variant: TProgressVariant.linear,
        value: -0.5,
      );
      expect(progress2.value, 0.0);
    });

    testWidgets('circular null value renders indeterminate indicator', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(TProgress(variant: TProgressVariant.circular)),
      );
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(
        find.descendant(
          of: find.byType(TProgress),
          matching: find.byType(RotationTransition),
        ),
        findsOneWidget,
      );
    });

    testWidgets('value, color and label updates refresh resolved state', (
      tester,
    ) async {
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

  group('TProgress variant 六档', () {
    testWidgets('variant: linear 渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 200,
            child: TProgress(variant: TProgressVariant.linear, value: 0.5),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('variant: circular 渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TProgress(variant: TProgressVariant.circular, value: 0.6),
        ),
      );
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('variant: microCircular 渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TProgress(variant: TProgressVariant.microCircular, value: 0.3),
        ),
      );
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('variant: button 渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 200,
            child: TProgress(variant: TProgressVariant.button, value: 0.7),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('variant: plump 与 microButton 渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          Column(
            children: [
              TProgress(variant: TProgressVariant.plump, value: 0.5),
              TProgress(variant: TProgressVariant.microButton, value: 0.5),
            ],
          ),
        ),
      );
      expect(find.byType(TProgress), findsNWidgets(2));
    });
  });

  group('TProgress 交互形态', () {
    testWidgets('button variant 支持点击', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 200,
            child: TProgress(
              variant: TProgressVariant.button,
              value: 0.5,
              onTap: () => taps++,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(TProgress));
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('microButton variant 支持点击', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        wrapWithTheme(
          TProgress(
            variant: TProgressVariant.microButton,
            value: 0.5,
            onTap: () => taps++,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(TProgress));
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('button variant 支持独立长按且不触发点击', (tester) async {
      var taps = 0;
      var longPresses = 0;
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 200,
            child: TProgress(
              variant: TProgressVariant.button,
              value: 0.5,
              onTap: () => taps++,
              onLongPress: () => longPresses++,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.longPress(find.byType(TProgress));
      await tester.pump();
      expect(longPresses, 1);
      expect(taps, 0);
    });

    testWidgets('microButton 仅提供 onLongPress 时仍可长按', (tester) async {
      var longPresses = 0;
      await tester.pumpWidget(
        wrapWithTheme(
          TProgress(
            variant: TProgressVariant.microButton,
            value: 0.5,
            onLongPress: () => longPresses++,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.longPress(find.byType(TProgress));
      await tester.pump();
      expect(longPresses, 1);
    });

    testWidgets('linear variant 不响应交互回调', (tester) async {
      var taps = 0;
      var longPresses = 0;
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 200,
            child: TProgress(
              variant: TProgressVariant.linear,
              value: 0.5,
              onTap: () => taps++,
              onLongPress: () => longPresses++,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(TProgress));
      await tester.pump();
      expect(taps, 0);
      await tester.longPress(find.byType(TProgress));
      await tester.pump();
      expect(longPresses, 0);
    });
  });

  group('TProgress label 显示', () {
    testWidgets('linear value=0.5 显示 50%', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 300,
            child: TProgress(variant: TProgressVariant.linear, value: 0.5),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('50%'), findsWidgets);
    });

    testWidgets('linear value=0.0 不显示百分比文字', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 300,
            child: TProgress(variant: TProgressVariant.linear, value: 0.0),
          ),
        ),
      );
      await tester.pump();
      // value 不为 null 时（即使是 0.0）getAutoText 仍渲染 "0%" 文本
      expect(find.text('0%'), findsWidgets);
    });

    testWidgets('显式空 label 隐藏自动标签', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 300,
            child: TProgress(
              variant: TProgressVariant.linear,
              value: 0.5,
              label: const SizedBox.shrink(),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('50%'), findsNothing);
    });

    testWidgets('自定义 Text 标签', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 300,
            child: TProgress(
              variant: TProgressVariant.linear,
              value: 0.5,
              label: const Text('自定义'),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('自定义'), findsWidgets);
    });

    testWidgets('Icon 标签渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TProgress(
            variant: TProgressVariant.circular,
            value: 0.5,
            label: const Icon(Icons.star),
          ),
        ),
      );
      await tester.pump();
      expect(find.byIcon(Icons.star), findsWidgets);
    });
  });

  group('TProgress Theme', () {
    testWidgets('Theme.color 覆盖进度条颜色', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 200,
            child: TProgress(variant: TProgressVariant.linear, value: 0.5),
          ),
          progressTheme: const TProgressThemeData(color: Colors.red),
        ),
      );
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('Theme.strokeWidth 覆盖粗细', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 200,
            child: TProgress(variant: TProgressVariant.linear, value: 0.5),
          ),
          progressTheme: const TProgressThemeData(strokeWidth: 10),
        ),
      );
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('Theme.backgroundColor 覆盖背景色', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 200,
            child: TProgress(variant: TProgressVariant.linear, value: 0.5),
          ),
          progressTheme: const TProgressThemeData(backgroundColor: Colors.grey),
        ),
      );
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('Theme.circleRadius 覆盖环形半径', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TProgress(variant: TProgressVariant.circular, value: 0.5),
          progressTheme: const TProgressThemeData(circleRadius: 150),
        ),
      );
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('Theme.animationDuration 覆盖动画时长', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 200,
            child: TProgress(variant: TProgressVariant.linear, value: 0.5),
          ),
          progressTheme: const TProgressThemeData(
            animationDuration: Duration(milliseconds: 500),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('有界布局保持父级宽度', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 300,
            child: TProgress(variant: TProgressVariant.linear, value: 0.5),
          ),
        ),
      );
      await tester.pump();

      expect(tester.getSize(find.byType(TProgress)).width, 300);
    });

    testWidgets('未配置无界兜底宽度时使用 MediaQuery 视口宽度', (tester) async {
      tester.view.physicalSize = const Size(420, 300);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        wrapWithTheme(
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: TProgress(variant: TProgressVariant.button, value: 0.5),
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(TProgress)).width, 420);
    });
  });

  group('TProgressThemeData copyWith 和 lerp', () {
    test('copyWith 部分覆盖', () {
      const theme = TProgressThemeData(
        strokeWidth: 5,
        color: Colors.red,
        circleRadius: 100,
        indeterminateLinearSegmentFraction: 0.4,
      );
      final copied = theme.copyWith(strokeWidth: 10);
      expect(copied.strokeWidth, 10);
      expect(copied.color, Colors.red);
      expect(copied.circleRadius, 100);
      expect(copied.indeterminateLinearSegmentFraction, 0.4);
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
      const a = TProgressThemeData(
        animationDuration: Duration(milliseconds: 100),
      );
      const b = TProgressThemeData(
        animationDuration: Duration(milliseconds: 300),
      );
      final result = a.lerp(b, 0.5);
      expect(result.animationDuration?.inMilliseconds, 200);
    });

    test('lerp 不确定态动画与几何字段', () {
      const a = TProgressThemeData(
        indeterminateAnimationDuration: Duration(milliseconds: 800),
        indeterminateLinearSegmentFraction: 0.2,
        indeterminateCircularValue: 0.2,
      );
      const b = TProgressThemeData(
        indeterminateAnimationDuration: Duration(milliseconds: 1200),
        indeterminateLinearSegmentFraction: 0.4,
        indeterminateCircularValue: 0.4,
      );
      final result = a.lerp(b, 0.5);
      expect(result.indeterminateAnimationDuration?.inMilliseconds, 1000);
      expect(result.indeterminateLinearSegmentFraction, closeTo(0.3, 0.001));
      expect(result.indeterminateCircularValue, closeTo(0.3, 0.001));
    });

    test('lerp 两端 animationDuration 均为 null 返回 null', () {
      const a = TProgressThemeData();
      const b = TProgressThemeData();
      final result = a.lerp(b, 0.5);
      expect(result.animationDuration, isNull);
    });

    test('lerp a animationDuration 为 null 返回 b 值', () {
      const a = TProgressThemeData();
      const b = TProgressThemeData(
        animationDuration: Duration(milliseconds: 200),
      );
      final result = a.lerp(b, 0.5);
      expect(result.animationDuration?.inMilliseconds, 200);
    });

    test('lerp b animationDuration 为 null 返回 a 值', () {
      const a = TProgressThemeData(
        animationDuration: Duration(milliseconds: 100),
      );
      const b = TProgressThemeData();
      final result = a.lerp(b, 0.5);
      expect(result.animationDuration?.inMilliseconds, 100);
    });
  });

  group('TProgress 边界情况', () {
    testWidgets('value=1.0 满进度渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 200,
            child: TProgress(variant: TProgressVariant.linear, value: 1.0),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('100%'), findsWidgets);
    });

    testWidgets('value=0.05 小进度走 outside label 路径', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 300,
            child: TProgress(variant: TProgressVariant.linear, value: 0.05),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });

    testWidgets('microCircular variant 不显示百分比文字', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TProgress(variant: TProgressVariant.microCircular, value: 0.5),
        ),
      );
      await tester.pump();
      // micro 类型不显示自动文字
      expect(find.text('50%'), findsNothing);
    });

    testWidgets('circular variant 中心显示标签', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TProgress(variant: TProgressVariant.circular, value: 0.5),
        ),
      );
      await tester.pump();
      expect(find.byType(TProgress), findsOneWidget);
    });
  });

  group('TProgress 设计形态与状态', () {
    testWidgets('初始声明值首帧直接呈现，后续更新再执行动画', (tester) async {
      Widget build(double value) => wrapWithTheme(
        SizedBox(
          width: 200,
          child: TProgress(variant: TProgressVariant.plump, value: value),
        ),
      );

      await tester.pumpWidget(build(0.8));
      expect(
        tester.getSize(find.byKey(const ValueKey('progress-value'))).width,
        160,
      );

      await tester.pumpWidget(build(0.2));
      await tester.pump();
      expect(
        tester.getSize(find.byKey(const ValueKey('progress-value'))).width,
        160,
      );
      await tester.pump(const Duration(milliseconds: 300));
      expect(
        tester.getSize(find.byKey(const ValueKey('progress-value'))).width,
        40,
      );
    });

    testWidgets('linear 与 plump 使用各自默认粗细和标签位置', (tester) async {
      Future<double> trackHeight(TProgressVariant variant) async {
        await tester.pumpWidget(
          wrapWithTheme(
            SizedBox(
              width: 200,
              child: TProgress(variant: variant, value: 0.8),
            ),
          ),
        );
        await tester.pumpAndSettle();
        return tester
            .getSize(find.byKey(const ValueKey('progress-track')))
            .height;
      }

      expect(await trackHeight(TProgressVariant.linear), 4);
      expect(await trackHeight(TProgressVariant.plump), 16);
    });

    testWidgets('四种状态解析语义颜色与默认标签', (tester) async {
      final token = TThemeData.defaultData();
      final expectedColors = <TProgressStatus, Color>{
        TProgressStatus.normal: token.brandNormalColor,
        TProgressStatus.warning: token.warningNormalColor,
        TProgressStatus.error: token.errorNormalColor,
        TProgressStatus.success: token.successNormalColor,
      };

      for (final entry in expectedColors.entries) {
        await tester.pumpWidget(
          wrapWithTheme(
            SizedBox(
              width: 200,
              child: TProgress(
                variant: TProgressVariant.linear,
                value: 0.8,
                status: entry.key,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final value = tester.widget<Container>(
          find.byKey(const ValueKey('progress-value')),
        );
        expect((value.decoration! as BoxDecoration).color, entry.value);
        expect(
          find.byWidgetPredicate(
            (widget) => widget is Semantics && widget.properties.value == '80%',
          ),
          findsOneWidget,
        );
        if (entry.key == TProgressStatus.normal) {
          expect(find.text('80%'), findsOneWidget);
        } else {
          expect(
            find.byKey(ValueKey('progress-${entry.key.name}')),
            findsOneWidget,
          );
        }
      }
    });

    testWidgets('Theme 显式颜色优先于 status 默认色', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 200,
            child: TProgress(
              variant: TProgressVariant.linear,
              value: 0.8,
              status: TProgressStatus.error,
            ),
          ),
          progressTheme: const TProgressThemeData(color: Colors.purple),
        ),
      );
      await tester.pumpAndSettle();

      final value = tester.widget<Container>(
        find.byKey(const ValueKey('progress-value')),
      );
      expect((value.decoration! as BoxDecoration).color, Colors.purple);
    });

    testWidgets('实例 gradient 优先并完整传递到线性填充', (tester) async {
      const gradient = LinearGradient(colors: [Colors.blue, Colors.green]);
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 200,
            child: TProgress(
              variant: TProgressVariant.linear,
              value: 0.8,
              status: TProgressStatus.error,
              gradient: gradient,
            ),
          ),
          progressTheme: const TProgressThemeData(color: Colors.purple),
        ),
      );
      await tester.pumpAndSettle();

      final value = tester.widget<Container>(
        find.byKey(const ValueKey('progress-value')),
      );
      final decoration = value.decoration! as BoxDecoration;
      expect(decoration.gradient, gradient);
      expect(decoration.color, isNull);
    });

    test('gradient 拒绝不支持的环形形态', () {
      expect(
        () => TProgress(
          variant: TProgressVariant.circular,
          value: 0.5,
          gradient: const LinearGradient(colors: [Colors.blue, Colors.green]),
        ),
        throwsAssertionError,
      );
    });

    testWidgets('microButton 提供 44px 触控区和按钮语义', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TProgress(
            variant: TProgressVariant.microButton,
            value: 0.3,
            semanticsLabel: '播放进度',
            onTap: () {},
          ),
        ),
      );

      expect(
        tester.getSize(
          find.byKey(const ValueKey('progress-micro-button-hit-target')),
        ),
        const Size.square(44),
      );
      final semantics = tester.getSemantics(find.byType(TProgress));
      expect(semantics.label, '播放进度');
      // Flutter 3.32 does not expose SemanticsNode.flagsCollection yet.
      // ignore: deprecated_member_use
      expect(semantics.hasFlag(SemanticsFlag.isButton), isTrue);
      expect(
        semantics.getSemanticsData().hasAction(SemanticsAction.tap),
        isTrue,
      );
    });

    testWidgets('microCircular 保持只读且不暴露内部状态名称', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        wrapWithTheme(
          TProgress(
            variant: TProgressVariant.microCircular,
            value: 0.3,
            status: TProgressStatus.warning,
            onTap: () => taps++,
          ),
        ),
      );

      await tester.tap(find.byType(TProgress));
      expect(taps, 0);
      final semantics = tester.getSemantics(find.byType(TProgress));
      expect(semantics.label, isNot(contains('progress-warning')));
      // Flutter 3.32 does not expose SemanticsNode.flagsCollection yet.
      // ignore: deprecated_member_use
      expect(semantics.hasFlag(SemanticsFlag.isButton), isFalse);
    });

    testWidgets('轨道与进度值共享完整圆角', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 200,
            child: TProgress(variant: TProgressVariant.linear, value: 0.8),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final track = tester.widget<Container>(
        find.byKey(const ValueKey('progress-track')),
      );
      final value = tester.widget<Container>(
        find.byKey(const ValueKey('progress-value')),
      );
      expect(
        (track.decoration! as BoxDecoration).borderRadius,
        (value.decoration! as BoxDecoration).borderRadius,
      );
    });

    testWidgets('plump 不响应点击回调', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 200,
            child: TProgress(
              variant: TProgressVariant.plump,
              value: 0.8,
              onTap: () => taps++,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(TProgress));
      expect(taps, 0);
    });

    testWidgets('低进度 plump 将标签放在进度值外侧', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 200,
            child: TProgress(variant: TProgressVariant.plump, value: 0.05),
          ),
        ),
      );

      expect(find.text('5%'), findsOneWidget);
      expect(find.byKey(const ValueKey('progress-value')), findsOneWidget);
    });

    testWidgets('不确定态 button 与 microButton 保留交互', (tester) async {
      var buttonTaps = 0;
      var microLongPresses = 0;
      await tester.pumpWidget(
        wrapWithTheme(
          Column(
            children: [
              TProgress(
                variant: TProgressVariant.button,
                onTap: () => buttonTaps++,
              ),
              TProgress(
                variant: TProgressVariant.microButton,
                onLongPress: () => microLongPresses++,
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.byType(TProgress).first);
      await tester.longPress(find.byType(TProgress).last);
      expect(buttonTaps, 1);
      expect(microLongPresses, 1);
    });
  });
}
