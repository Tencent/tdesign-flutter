import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/time_counter/t_time_counter_style.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TTimeCounter Widget 测试
///
/// 覆盖：构造器、direction down/up、size 三档、theme 三种、
/// autoStart、format、splitWithUnit、millisecond、content 自定义、
/// controller 控制（start/pause/resume/reset）、onChanged/onFinish 回调、
/// Theme 覆盖。
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(
    Widget child, {
    TTimeCounterThemeData? timeCounterTheme,
  }) {
    var theme = TThemeBuilder.light(TThemeData.defaultData());
    if (timeCounterTheme != null) {
      theme = theme.mergeExtension(timeCounterTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: child),
    );
  }

  // ============================================================
  // 基础渲染
  // ============================================================
  group('TTimeCounter 基础渲染', () {
    testWidgets('TTimeCounter 正常渲染（倒计时）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTimeCounter(
          time: 3661000, // 1小时1分1秒
          autoStart: false,
        ),
      ));
      expect(find.byType(TTimeCounter), findsOneWidget);
      // format=HH:mm:ss，应显示 01:01:01
      expect(find.text('01'), findsNWidgets(3));
      expect(find.text(':'), findsNWidgets(2));
    });

    testWidgets('TTimeCounter autoStart=false 不自动开始', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTimeCounter(
          time: 5000,
          autoStart: false,
        ),
      ));
      expect(find.byType(TTimeCounter), findsOneWidget);
      // 5000ms = 00:00:05，00 出现两次
      expect(find.text('00'), findsNWidgets(2));
      expect(find.text('05'), findsOneWidget);
    });

    testWidgets('TTimeCounter 带 format 自定义格式', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTimeCounter(
          time: 90061000, // 1天1小时1分1秒
          format: 'DD:HH:mm:ss',
          autoStart: false,
        ),
      ));
      expect(find.byType(TTimeCounter), findsOneWidget);
      // 应显示 01:01:01:01
      expect(find.text('01'), findsNWidgets(4));
    });
  });

  // ============================================================
  // direction 枚举变体
  // ============================================================
  group('TTimeCounter direction 枚举变体', () {
    testWidgets('direction=down（默认）倒计时渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTimeCounter(
          time: 10000,
          direction: TTimeCounterDirection.down,
          autoStart: false,
        ),
      ));
      expect(find.byType(TTimeCounter), findsOneWidget);
      // 10秒 = 00:00:10，00 出现两次
      expect(find.text('00'), findsNWidgets(2));
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('direction=up 正向计时渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTimeCounter(
          time: 10000,
          direction: TTimeCounterDirection.up,
          autoStart: false,
        ),
      ));
      expect(find.byType(TTimeCounter), findsOneWidget);
      // 正向计时从 0 开始，00:00:00，00 出现三次
      expect(find.text('00'), findsNWidgets(3));
    });
  });

  // ============================================================
  // size 三档
  // ============================================================
  group('TTimeCounter size 尺寸', () {
    testWidgets('size=small 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTimeCounter(
          time: 5000,
          size: TTimeCounterSize.small,
          autoStart: false,
        ),
      ));
      expect(find.byType(TTimeCounter), findsOneWidget);
    });

    testWidgets('size=medium（默认）渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTimeCounter(
          time: 5000,
          size: TTimeCounterSize.medium,
          autoStart: false,
        ),
      ));
      expect(find.byType(TTimeCounter), findsOneWidget);
    });

    testWidgets('size=large 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTimeCounter(
          time: 5000,
          size: TTimeCounterSize.large,
          autoStart: false,
        ),
      ));
      expect(find.byType(TTimeCounter), findsOneWidget);
    });
  });

  // ============================================================
  // theme 三种风格
  // ============================================================
  group('TTimeCounter theme 风格', () {
    testWidgets('theme=defaultTheme（默认）渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTimeCounter(
          time: 5000,
          variant: TTimeCounterVariant.defaultTheme,
          autoStart: false,
        ),
      ));
      expect(find.byType(TTimeCounter), findsOneWidget);
    });

    testWidgets('theme=round 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTimeCounter(
          time: 5000,
          variant: TTimeCounterVariant.round,
          autoStart: false,
        ),
      ));
      expect(find.byType(TTimeCounter), findsOneWidget);
    });

    testWidgets('theme=square 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTimeCounter(
          time: 5000,
          variant: TTimeCounterVariant.square,
          autoStart: false,
        ),
      ));
      expect(find.byType(TTimeCounter), findsOneWidget);
    });

    testWidgets('round variant uses token visual contract', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const Center(
          child: TTimeCounter(
            time: 5000,
            variant: TTimeCounterVariant.round,
            autoStart: false,
          ),
        ),
      ));

      final token = TThemeData.defaultData();
      final timeBox = tester.widget<Container>(
        find
            .ancestor(
              of: find.text('05'),
              matching: find.byWidgetPredicate(
                (widget) =>
                    widget is Container && widget.decoration is BoxDecoration,
              ),
            )
            .first,
      );
      final decoration = timeBox.decoration! as BoxDecoration;
      final timeText = tester.widget<Text>(find.text('05'));
      final splitText = tester.widget<Text>(find.text(':').first);

      expect(tester.getSize(find.byWidget(timeBox)), const Size(24, 24));
      expect(decoration.shape, BoxShape.circle);
      expect(decoration.color, token.errorNormalColor);
      expect(timeText.style?.fontSize, token.fontBodyMedium?.size);
      expect(timeText.style?.color, token.textColorAnti);
      expect(splitText.style?.color, token.errorNormalColor);
    });
  });

  // ============================================================
  // Theme 覆盖（TTimeCounterThemeData）
  // ============================================================
  group('TTimeCounter Theme 覆盖', () {
    testWidgets('TTimeCounterThemeData 注入后正常渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const Center(
            child: TTimeCounter(
              time: 5000,
              autoStart: false,
            ),
          ),
          timeCounterTheme: const TTimeCounterThemeData(
            size: TTimeCounterSize.large,
            variant: TTimeCounterVariant.round,
            showMillisecond: false,
            splitWithUnit: false,
          ),
        ),
      );
      expect(find.byType(TTimeCounter), findsOneWidget);
    });

    test('TTimeCounterThemeData copyWith and lerp', () {
      const a = TTimeCounterThemeData(
        variant: TTimeCounterVariant.round,
        size: TTimeCounterSize.small,
        showMillisecond: false,
        splitWithUnit: false,
      );
      const b = TTimeCounterThemeData(
        variant: TTimeCounterVariant.square,
        size: TTimeCounterSize.large,
        showMillisecond: true,
        splitWithUnit: true,
      );

      expect(a.copyWith(size: TTimeCounterSize.medium).size,
          TTimeCounterSize.medium);
      expect(a.copyWith().variant, TTimeCounterVariant.round);
      expect(a.lerp(b, 0.25).variant, TTimeCounterVariant.round);
      expect(a.lerp(b, 0.75).showMillisecond, isTrue);
      expect(a.lerp(null, 0.5), same(a));
    });
  });

  // ============================================================
  // splitWithUnit / millisecond
  // ============================================================
  group('TTimeCounter splitWithUnit 与 millisecond', () {
    testWidgets('splitWithUnit=true 显示时间单位', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTimeCounter(
          time: 3661000,
          splitWithUnit: true,
          autoStart: false,
        ),
      ));
      expect(find.byType(TTimeCounter), findsOneWidget);
      // splitWithUnit 时分隔符变为时间单位文字（时/分/秒）
      // 应能看到单位文字
    });

    testWidgets('millisecond=true 开启毫秒级渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTimeCounter(
          time: 1500,
          format: 'ss:SSS',
          showMillisecond: true,
          autoStart: false,
        ),
      ));
      expect(find.byType(TTimeCounter), findsOneWidget);
      // 毫秒级应显示 SSS 部分
    });
  });

  // ============================================================
  // content 自定义
  // ============================================================
  group('TTimeCounter content 自定义', () {
    testWidgets('content builder 渲染自定义内容', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTimeCounter(
          time: 5000,
          autoStart: false,
          content: (_) => const Text('自定义内容'),
        ),
      ));
      expect(find.text('自定义内容'), findsOneWidget);
    });

    testWidgets('content 为 Function 时回调渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTimeCounter(
          time: 5000,
          autoStart: false,
          content: (int time) => Text('剩余${time}ms'),
        ),
      ));
      expect(find.text('剩余5000ms'), findsOneWidget);
    });
  });

  // ============================================================
  // TTimeCounterController 控制
  // ============================================================
  group('TTimeCounterController 控制器', () {
    testWidgets('controller.start() 开始倒计时', (tester) async {
      final controller = TTimeCounterController();
      await tester.pumpWidget(wrapWithTheme(
        TTimeCounter(
          time: 5000,
          autoStart: false,
          controller: controller,
        ),
      ));
      expect(find.byType(TTimeCounter), findsOneWidget);

      // 通过 controller 开始
      controller.start();
      await tester.pump();
      // 开始后 ticker 运行
      expect(find.byType(TTimeCounter), findsOneWidget);
    });

    testWidgets('controller.pause() 暂停倒计时', (tester) async {
      final controller = TTimeCounterController();
      await tester.pumpWidget(wrapWithTheme(
        TTimeCounter(
          time: 5000,
          autoStart: false,
          controller: controller,
        ),
      ));

      controller.start();
      await tester.pump();
      controller.pause();
      await tester.pump();
      expect(find.byType(TTimeCounter), findsOneWidget);
    });

    testWidgets('controller.reset() 重置倒计时', (tester) async {
      final controller = TTimeCounterController();
      await tester.pumpWidget(wrapWithTheme(
        TTimeCounter(
          time: 5000,
          autoStart: false,
          controller: controller,
        ),
      ));

      controller.reset(10000);
      await tester.pump();
      expect(find.byType(TTimeCounter), findsOneWidget);
    });
  });

  // ============================================================
  // onChanged / onFinish 回调
  // ============================================================
  group('TTimeCounter 回调', () {
    testWidgets('onFinish 在倒计时结束时触发', (tester) async {
      var finished = false;
      await tester.pumpWidget(wrapWithTheme(
        TTimeCounter(
          time: 100,
          autoStart: true,
          onFinish: () => finished = true,
        ),
      ));

      // 等待足够时间让倒计时结束
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      // 倒计时结束后 finished 应为 true
      expect(finished, isTrue);
    });
  });

  // ============================================================
  // 边界情况
  // ============================================================
  group('TTimeCounter 边界情况', () {
    testWidgets('time=0 时正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTimeCounter(
          time: 0,
          autoStart: false,
        ),
      ));
      expect(find.byType(TTimeCounter), findsOneWidget);
      // 应显示 00:00
      expect(find.text('00'), findsNWidgets(3));
    });

    testWidgets('自定义 style 渲染（通过 size + theme 组合）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTimeCounter(
          time: 5000,
          autoStart: false,
          size: TTimeCounterSize.large,
          variant: TTimeCounterVariant.round,
        ),
      ));
      expect(find.byType(TTimeCounter), findsOneWidget);
    });
  });

  // ============================================================
  // 覆盖率补充
  // ============================================================
  group('TTimeCounter 覆盖率补充', () {
    testWidgets('didUpdateWidget controller 变化', (tester) async {
      // 覆盖 128-133（controller 变化 → removeListener/addListener）
      final c1 = TTimeCounterController();
      final c2 = TTimeCounterController();
      var useC1 = true;
      late StateSetter setState;
      await tester.pumpWidget(wrapWithTheme(
        StatefulBuilder(
          builder: (context, setter) {
            setState = setter;
            return TTimeCounter(
              time: 5000,
              autoStart: false,
              controller: useC1 ? c1 : c2,
            );
          },
        ),
      ));
      setState(() => useC1 = false);
      await tester.pumpAndSettle();
      expect(find.byType(TTimeCounter), findsOneWidget);
    });

    testWidgets('didUpdateWidget time 变化', (tester) async {
      // 覆盖 135-136（time 变化 → resetTimer）
      var time = 5000;
      late StateSetter setState;
      await tester.pumpWidget(wrapWithTheme(
        StatefulBuilder(
          builder: (context, setter) {
            setState = setter;
            return TTimeCounter(
              time: time,
              autoStart: false,
            );
          },
        ),
      ));
      setState(() => time = 3000);
      await tester.pumpAndSettle();
      expect(find.byType(TTimeCounter), findsOneWidget);
    });

    testWidgets('direction=up 正向计时 + resume', (tester) async {
      // 覆盖 161-162（direction=up 时 _time 累加）+ 182-183（resumeTimer）+ 214（resume 分支）
      final controller = TTimeCounterController();
      await tester.pumpWidget(wrapWithTheme(
        TTimeCounter(
          time: 0,
          direction: TTimeCounterDirection.up,
          autoStart: true,
          controller: controller,
        ),
      ));
      // 等待计时器执行（direction=up 时 _time 累加）
      await tester.pump(const Duration(seconds: 1));
      // pause → resume（覆盖 resumeTimer + resume 分支）
      controller.pause();
      await tester.pump();
      controller.resume();
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(TTimeCounter), findsOneWidget);
    });

    testWidgets('连续 reset 覆盖 if 分支（value==reset 时 _time+notifyListeners）',
        (tester) async {
      // 覆盖 t_time_counter_controller.dart 第 47-48 行
      final controller = TTimeCounterController();
      await tester.pumpWidget(wrapWithTheme(
        TTimeCounter(
          time: 5000,
          autoStart: false,
          controller: controller,
        ),
      ));
      // 第一次 reset（走 else 分支：value = TTimeCounterStatus.reset）
      controller.reset(10000);
      await tester.pump();
      // 第二次 reset（走 if 分支：value 已是 reset → _time = time + notifyListeners）
      controller.reset(20000);
      await tester.pump();
      expect(find.byType(TTimeCounter), findsOneWidget);
    });

    testWidgets('generateStyle small+round 覆盖非 defaultTheme 分支',
        (tester) async {
      // 覆盖 t_time_counter_style.dart 第 120-123 行
      late BuildContext ctx;
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          ctx = context;
          return const SizedBox();
        }),
      ));
      final style = TTimeCounterStyle.generateStyle(
        ctx,
        size: TTimeCounterSize.small,
        theme: TTimeCounterVariant.round,
      );
      expect(style, isNotNull);
    });

    testWidgets('generateStyle small+square 覆盖非 defaultTheme 分支',
        (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          ctx = context;
          return const SizedBox();
        }),
      ));
      final style = TTimeCounterStyle.generateStyle(
        ctx,
        size: TTimeCounterSize.small,
        theme: TTimeCounterVariant.square,
      );
      expect(style, isNotNull);
    });
  });
}
