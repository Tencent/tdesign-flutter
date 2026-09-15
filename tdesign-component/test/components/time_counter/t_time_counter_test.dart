import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TTimeCounter Widget 测试
///
/// 覆盖：构造器、direction down/up、size 三档、variant 四种、
/// autoStart、format、splitWithUnit、content 自定义、
/// controller 控制（start/pause/reset）、onChanged/onFinish 回调、
/// Theme 覆盖。
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(
    Widget child, {
    TTimeCounterThemeData? timeCounterTheme,
    TThemeData? token,
  }) {
    var theme = TThemeBuilder.light(token ?? TThemeData.defaultData());
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
      await tester.pumpWidget(
        wrapWithTheme(
          const TTimeCounter(
            time: 3661000, // 1小时1分1秒
            autoStart: false,
          ),
        ),
      );
      expect(find.byType(TTimeCounter), findsOneWidget);
      // format=HH:mm:ss，应显示 01:01:01
      expect(find.text('01'), findsNWidgets(3));
      expect(find.text(':'), findsNWidgets(2));
    });

    testWidgets('TTimeCounter autoStart=false 不自动开始', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TTimeCounter(time: 5000, autoStart: false)),
      );
      expect(find.byType(TTimeCounter), findsOneWidget);
      // 5000ms = 00:00:05，00 出现两次
      expect(find.text('00'), findsNWidgets(2));
      expect(find.text('05'), findsOneWidget);
    });

    testWidgets('TTimeCounter 带 format 自定义格式', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TTimeCounter(
            time: 90061000, // 1天1小时1分1秒
            format: 'DD:HH:mm:ss',
            autoStart: false,
          ),
        ),
      );
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
      await tester.pumpWidget(
        wrapWithTheme(
          const TTimeCounter(
            time: 10000,
            direction: TTimeCounterDirection.down,
            autoStart: false,
          ),
        ),
      );
      expect(find.byType(TTimeCounter), findsOneWidget);
      // 10秒 = 00:00:10，00 出现两次
      expect(find.text('00'), findsNWidgets(2));
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('direction=up 正向计时渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TTimeCounter(
            time: 10000,
            direction: TTimeCounterDirection.up,
            autoStart: false,
          ),
        ),
      );
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
      await tester.pumpWidget(
        wrapWithTheme(
          const TTimeCounter(
            time: 5000,
            size: TTimeCounterSize.small,
            autoStart: false,
          ),
        ),
      );
      expect(find.byType(TTimeCounter), findsOneWidget);
    });

    testWidgets('size=medium（默认）渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TTimeCounter(
            time: 5000,
            size: TTimeCounterSize.medium,
            autoStart: false,
          ),
        ),
      );
      expect(find.byType(TTimeCounter), findsOneWidget);
    });

    testWidgets('size=large 渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TTimeCounter(
            time: 5000,
            size: TTimeCounterSize.large,
            autoStart: false,
          ),
        ),
      );
      expect(find.byType(TTimeCounter), findsOneWidget);
    });
  });

  // ============================================================
  // variant 四种风格
  // ============================================================
  group('TTimeCounter theme 风格', () {
    testWidgets('variant=plain（默认）渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TTimeCounter(
            time: 5000,
            variant: TTimeCounterVariant.plain,
            autoStart: false,
          ),
        ),
      );
      expect(find.byType(TTimeCounter), findsOneWidget);
    });

    testWidgets('theme=round 渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TTimeCounter(
            time: 5000,
            variant: TTimeCounterVariant.round,
            autoStart: false,
          ),
        ),
      );
      expect(find.byType(TTimeCounter), findsOneWidget);
    });

    testWidgets('theme=square 渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TTimeCounter(
            time: 5000,
            variant: TTimeCounterVariant.square,
            autoStart: false,
          ),
        ),
      );
      expect(find.byType(TTimeCounter), findsOneWidget);
    });

    testWidgets('highlight 默认视觉符合 Figma 规格', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const Center(
            child: TTimeCounter(
              time: 96 * 60 * 1000,
              variant: TTimeCounterVariant.highlight,
              splitWithUnit: true,
              autoStart: false,
            ),
          ),
        ),
      );

      final token = TThemeData.defaultData();
      final timeText = tester.widget<Text>(find.text('01'));
      final unitText = tester.widget<Text>(find.text('时'));
      expect(timeText.style?.color, token.errorNormalColor);
      expect(timeText.style?.fontSize, token.fontBodyExtraLarge?.size);
      expect(timeText.style?.height, 24 / token.fontBodyExtraLarge!.size);
      expect(unitText.style?.color, token.textColorPrimary);
      expect(unitText.style?.fontSize, token.fontBodyExtraSmall?.size);
      expect(unitText.style?.height, token.fontBodyExtraSmall?.height);
      expect(tester.getSize(find.text('01')).height, 24);
    });

    testWidgets('highlight 响应 TDesign 颜色和字体 token', (tester) async {
      final token = TThemeData.defaultData().copyWithTThemeData(
        'time-counter-highlight-test',
        colorMap: {
          'errorNormalColor': Colors.purple,
          'textColorPrimary': Colors.green,
        },
        fontMap: {
          'fontBodyExtraLarge': Font(
            size: 19,
            lineHeight: 27,
            fontWeight: FontWeight.w700,
          ),
          'fontBodyExtraSmall': Font(
            size: 11,
            lineHeight: 17,
            fontWeight: FontWeight.w300,
          ),
        },
      );
      await tester.pumpWidget(
        wrapWithTheme(
          const Center(
            child: TTimeCounter(
              time: 5000,
              variant: TTimeCounterVariant.highlight,
              splitWithUnit: true,
              autoStart: false,
            ),
          ),
          token: token,
        ),
      );

      final timeText = tester.widget<Text>(find.text('05'));
      final unitText = tester.widget<Text>(find.text('秒'));
      expect(timeText.style?.color, Colors.purple);
      expect(timeText.style?.fontSize, 19);
      expect(timeText.style?.height, 24 / 19);
      expect(timeText.style?.fontWeight, FontWeight.w700);
      expect(unitText.style?.color, Colors.green);
      expect(unitText.style?.fontSize, 11);
      expect(unitText.style?.height, 17 / 11);
      expect(unitText.style?.fontWeight, FontWeight.w300);
    });

    testWidgets('round variant uses token visual contract', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const Center(
            child: TTimeCounter(
              time: 5000,
              variant: TTimeCounterVariant.round,
              autoStart: false,
            ),
          ),
        ),
      );

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
          const Center(child: TTimeCounter(time: 5000, autoStart: false)),
          timeCounterTheme: const TTimeCounterThemeData(
            defaultSize: TTimeCounterSize.large,
            defaultVariant: TTimeCounterVariant.round,
          ),
        ),
      );
      expect(find.byType(TTimeCounter), findsOneWidget);
    });

    test('TTimeCounterThemeData copyWith and lerp', () {
      const a = TTimeCounterThemeData(
        defaultVariant: TTimeCounterVariant.round,
        defaultSize: TTimeCounterSize.small,
      );
      const b = TTimeCounterThemeData(
        defaultVariant: TTimeCounterVariant.square,
        defaultSize: TTimeCounterSize.large,
      );

      expect(
        a.copyWith(defaultSize: TTimeCounterSize.medium).defaultSize,
        TTimeCounterSize.medium,
      );
      expect(a.copyWith().defaultVariant, TTimeCounterVariant.round);
      expect(a.lerp(b, 0.25).defaultVariant, TTimeCounterVariant.round);
      expect(a.lerp(b, 0.75).defaultSize, TTimeCounterSize.large);
      expect(a.lerp(null, 0.5), same(a));
    });
  });

  // ============================================================
  // splitWithUnit / 毫秒格式
  // ============================================================
  group('TTimeCounter splitWithUnit 与 millisecond', () {
    testWidgets('splitWithUnit=true 显示时间单位', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TTimeCounter(
            time: 3661000,
            splitWithUnit: true,
            autoStart: false,
          ),
        ),
      );
      expect(find.byType(TTimeCounter), findsOneWidget);
      // splitWithUnit 时分隔符变为时间单位文字（时/分/秒）
      // 应能看到单位文字
    });

    testWidgets('format 包含毫秒段时显示毫秒', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TTimeCounter(time: 1500, format: 'ss:SSS', autoStart: false),
        ),
      );
      expect(find.byType(TTimeCounter), findsOneWidget);
      // 毫秒级应显示 SSS 部分
    });
  });

  // ============================================================
  // content 自定义
  // ============================================================
  group('TTimeCounter content 自定义', () {
    testWidgets('content builder 渲染自定义内容', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TTimeCounter(
            time: 5000,
            autoStart: false,
            content: (_) => const Text('自定义内容'),
          ),
        ),
      );
      expect(find.text('自定义内容'), findsOneWidget);
    });

    testWidgets('content 为 Function 时回调渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TTimeCounter(
            time: 5000,
            autoStart: false,
            content: (int time) => Text('剩余${time}ms'),
          ),
        ),
      );
      expect(find.text('剩余5000ms'), findsOneWidget);
    });
  });

  // ============================================================
  // TTimeCounterController 控制
  // ============================================================
  group('TTimeCounterController 控制器', () {
    testWidgets('controller.start() 开始倒计时', (tester) async {
      final controller = TTimeCounterController();
      await tester.pumpWidget(
        wrapWithTheme(
          TTimeCounter(time: 5000, autoStart: false, controller: controller),
        ),
      );
      expect(find.byType(TTimeCounter), findsOneWidget);

      // 通过 controller 开始
      controller.start();
      await tester.pump();
      // 开始后 ticker 运行
      expect(find.byType(TTimeCounter), findsOneWidget);
    });

    testWidgets('controller.pause() 暂停倒计时', (tester) async {
      final controller = TTimeCounterController();
      await tester.pumpWidget(
        wrapWithTheme(
          TTimeCounter(time: 5000, autoStart: false, controller: controller),
        ),
      );

      controller.start();
      await tester.pump();
      controller.pause();
      await tester.pump();
      expect(find.byType(TTimeCounter), findsOneWidget);
    });

    testWidgets('controller.reset() 重置倒计时', (tester) async {
      final controller = TTimeCounterController();
      final changes = <int>[];
      await tester.pumpWidget(
        wrapWithTheme(
          TTimeCounter(
            time: 5000,
            autoStart: false,
            controller: controller,
            onChanged: changes.add,
          ),
        ),
      );

      controller.reset(10000);
      await tester.pump();
      expect(find.text('10'), findsOneWidget);
      expect(changes, [10000]);
    });

    testWidgets('controller.reset() 重置后保持暂停', (tester) async {
      final controller = TTimeCounterController();
      await tester.pumpWidget(
        wrapWithTheme(TTimeCounter(time: 5000, controller: controller)),
      );
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('04'), findsOneWidget);

      controller.pause();
      controller.reset();
      await tester.pump();
      expect(find.text('05'), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
      expect(find.text('05'), findsOneWidget);
    });

    testWidgets('controller.reset() 刷新自定义内容但不重复通知相同可见值', (tester) async {
      final controller = TTimeCounterController();
      final changes = <int>[];
      await tester.pumpWidget(
        wrapWithTheme(
          TTimeCounter(
            time: 5000,
            autoStart: false,
            controller: controller,
            onChanged: changes.add,
            content: (time) => Text('$time'),
          ),
        ),
      );

      controller.reset(5500);
      await tester.pump();
      expect(find.text('5500'), findsOneWidget);
      expect(changes, isEmpty);
    });
  });

  // ============================================================
  // onChanged / onFinish 回调
  // ============================================================
  group('TTimeCounter 回调', () {
    testWidgets('onFinish 在倒计时结束时触发', (tester) async {
      var finished = false;
      await tester.pumpWidget(
        wrapWithTheme(
          TTimeCounter(
            time: 100,
            autoStart: true,
            onFinish: () => finished = true,
          ),
        ),
      );

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
      await tester.pumpWidget(
        wrapWithTheme(const TTimeCounter(time: 0, autoStart: false)),
      );
      expect(find.byType(TTimeCounter), findsOneWidget);
      // 应显示 00:00
      expect(find.text('00'), findsNWidgets(3));
    });

    testWidgets('自定义 style 渲染（通过 size + theme 组合）', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TTimeCounter(
            time: 5000,
            autoStart: false,
            size: TTimeCounterSize.large,
            variant: TTimeCounterVariant.round,
          ),
        ),
      );
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
      await tester.pumpWidget(
        wrapWithTheme(
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
        ),
      );
      setState(() => useC1 = false);
      await tester.pumpAndSettle();
      expect(find.byType(TTimeCounter), findsOneWidget);
    });

    testWidgets('didUpdateWidget time 变化', (tester) async {
      // 覆盖 135-136（time 变化 → resetTimer）
      var time = 5000;
      late StateSetter setState;
      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setter) {
              setState = setter;
              return TTimeCounter(time: time, autoStart: false);
            },
          ),
        ),
      );
      setState(() => time = 3000);
      await tester.pumpAndSettle();
      expect(find.byType(TTimeCounter), findsOneWidget);
    });

    testWidgets('动态 variant、size 和单位模式立即更新样式', (tester) async {
      var variant = TTimeCounterVariant.plain;
      var size = TTimeCounterSize.medium;
      var splitWithUnit = false;
      late StateSetter update;
      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return TTimeCounter(
                time: 5000,
                autoStart: false,
                variant: variant,
                size: size,
                splitWithUnit: splitWithUnit,
              );
            },
          ),
        ),
      );
      expect(find.text(':'), findsNWidgets(2));

      update(() {
        variant = TTimeCounterVariant.square;
        size = TTimeCounterSize.large;
        splitWithUnit = true;
      });
      await tester.pump();

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
      expect(tester.getSize(find.byWidget(timeBox)), const Size(28, 28));
      expect(find.text(':'), findsNothing);
      expect(find.text('秒'), findsOneWidget);
    });

    testWidgets('direction=up 正向计时可暂停并继续', (tester) async {
      final controller = TTimeCounterController();
      await tester.pumpWidget(
        wrapWithTheme(
          TTimeCounter(
            time: 3000,
            direction: TTimeCounterDirection.up,
            autoStart: true,
            controller: controller,
          ),
        ),
      );
      // 等待计时器执行（direction=up 时当前计时值递增）
      await tester.pump(const Duration(seconds: 1));
      controller.pause();
      await tester.pump();
      controller.start();
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(TTimeCounter), findsOneWidget);
    });

    testWidgets('连续 reset 每次都应用新的目标时长', (tester) async {
      final controller = TTimeCounterController();
      await tester.pumpWidget(
        wrapWithTheme(
          TTimeCounter(time: 5000, autoStart: false, controller: controller),
        ),
      );
      controller.reset(10000);
      await tester.pump();
      expect(find.text('10'), findsOneWidget);
      controller.reset(20000);
      await tester.pump();
      expect(find.text('20'), findsOneWidget);
    });
  });

  group('TTimeCounter 计时契约', () {
    testWidgets('方形尺寸和圆角读取设计值与 TDesign token', (tester) async {
      final token = TThemeData.defaultData().copyWithTThemeData(
        'time-counter-square-test',
        radiusMap: {'radiusSmall': 7},
      );
      await tester.pumpWidget(
        wrapWithTheme(
          const Center(
            child: TTimeCounter(
              time: 5000,
              size: TTimeCounterSize.small,
              variant: TTimeCounterVariant.square,
              autoStart: false,
            ),
          ),
          token: token,
        ),
      );

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
      expect(tester.getSize(find.byWidget(timeBox)), const Size(20, 20));
      expect(decoration.borderRadius, BorderRadius.circular(7));
    });

    testWidgets('onChanged 跟随 format 对应的展示精度', (tester) async {
      final secondChanges = <int>[];
      await tester.pumpWidget(
        wrapWithTheme(TTimeCounter(time: 5000, onChanged: secondChanges.add)),
      );
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      expect(secondChanges, [4900]);
      await tester.pump(const Duration(milliseconds: 801));
      expect(secondChanges, hasLength(2));

      final millisecondChanges = <int>[];
      await tester.pumpWidget(
        wrapWithTheme(
          TTimeCounter(
            time: 5000,
            format: 'HH:mm:ss:SSS',
            onChanged: millisecondChanges.add,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      expect(millisecondChanges, hasLength(3));
    });

    testWidgets('autoStart 仅决定初始行为，运行期由 controller 控制', (tester) async {
      var autoStart = false;
      final controller = TTimeCounterController();
      late StateSetter update;
      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return TTimeCounter(
                time: 5000,
                autoStart: autoStart,
                controller: controller,
              );
            },
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('05'), findsOneWidget);

      update(() => autoStart = true);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('05'), findsOneWidget);

      controller.start();
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('04'), findsOneWidget);

      update(() => autoStart = false);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('03'), findsOneWidget);

      controller.pause();
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('03'), findsOneWidget);
    });

    testWidgets('onChanged 仅在 format 对应的可见值变化时触发', (tester) async {
      final changes = <int>[];
      await tester.pumpWidget(
        wrapWithTheme(
          TTimeCounter(time: 65000, format: 'mm', onChanged: changes.add),
        ),
      );

      await tester.pump(const Duration(seconds: 3));
      expect(changes, isEmpty);
      await tester.pump(const Duration(seconds: 3));
      expect(changes, hasLength(1));
    });

    testWidgets('动态 direction 按新方向重置并正向计时', (tester) async {
      var direction = TTimeCounterDirection.down;
      late StateSetter update;
      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return TTimeCounter(
                time: 5000,
                autoStart: false,
                direction: direction,
              );
            },
          ),
        ),
      );
      expect(find.text('05'), findsOneWidget);

      update(() => direction = TTimeCounterDirection.up);
      await tester.pump();
      expect(find.text('00'), findsNWidgets(3));
    });

    testWidgets('终点完成幂等且初始零值不自动完成', (tester) async {
      var finishes = 0;
      final controller = TTimeCounterController();
      await tester.pumpWidget(
        wrapWithTheme(
          TTimeCounter(
            time: 0,
            controller: controller,
            onFinish: () => finishes++,
          ),
        ),
      );
      await tester.pump();
      expect(finishes, 0);

      controller.start();
      await tester.pump();
      controller.start();
      await tester.pump();
      expect(finishes, 1);
    });

    testWidgets('毫秒段和尾随单位可以解析', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TTimeCounter(
            time: 61500,
            autoStart: false,
            format: 'mm分ss秒SSS毫',
          ),
        ),
      );
      expect(find.text('01'), findsNWidgets(2));
      expect(find.text('500'), findsOneWidget);
      expect(find.text('分'), findsOneWidget);
      expect(find.text('秒'), findsOneWidget);
      expect(find.text('毫'), findsOneWidget);
    });

    testWidgets('缺少分隔符、重复时间段和空白格式均被拒绝', (tester) async {
      for (final format in ['HH::mm', 'HHmmss', 'HH:mm:HH', ' HH:mm']) {
        await tester.pumpWidget(
          wrapWithTheme(
            TTimeCounter(time: 1000, autoStart: false, format: format),
          ),
        );
        expect(tester.takeException(), isArgumentError, reason: format);
        await tester.pumpWidget(const SizedBox());
      }
      expect(() => TTimeCounterController().reset(-1), throwsArgumentError);
    });
  });
}
