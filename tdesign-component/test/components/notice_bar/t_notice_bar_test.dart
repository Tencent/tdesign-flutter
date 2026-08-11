import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TNoticeBar Widget 测试
///
/// 覆盖 variant 四档、marquee 滚动、prefix/suffix 图标、
/// left/right 自定义 widget、onPressed 回调、
/// Theme 注入、边界情况。
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child, {TNoticeBarThemeData? noticeBarTheme}) {
    final themeExtensions = <ThemeExtension>[
      if (noticeBarTheme != null) noticeBarTheme,
    ];
    // 注意：必须通过 MaterialApp.theme 传递 extensions
    return MaterialApp(
      theme: ThemeData(
        extensions: [TThemeData.defaultData(), ...themeExtensions],
      ),
      home: Scaffold(body: child),
    );
  }

  group('TNoticeBar 基础渲染', () {
    testWidgets('字符串内容渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(content: '这是一条公告'),
      ));
      expect(find.byType(TNoticeBar), findsOneWidget);
      expect(find.text('这是一条公告'), findsOneWidget);
    });

    testWidgets('List<String> 内容渲染第一条', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(items: ['第一条', '第二条']),
      ));
      expect(find.byType(TNoticeBar), findsOneWidget);
      // 非 marquee 模式下显示第一条
      expect(find.text('第一条'), findsOneWidget);
    });

    testWidgets('null 内容渲染空容器', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(),
      ));
      expect(find.byType(TNoticeBar), findsOneWidget);
    });
  });

  group('TNoticeBar variant 四档', () {
    testWidgets('variant: info（默认）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(content: '信息公告'),
        noticeBarTheme: const TNoticeBarThemeData(variant: TNoticeBarVariant.info),
      ));
      expect(find.byType(TNoticeBar), findsOneWidget);
    });

    testWidgets('variant: success', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(content: '成功公告'),
        noticeBarTheme: const TNoticeBarThemeData(variant: TNoticeBarVariant.success),
      ));
      expect(find.byType(TNoticeBar), findsOneWidget);
    });

    testWidgets('variant: warning', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(content: '警告公告'),
        noticeBarTheme: const TNoticeBarThemeData(variant: TNoticeBarVariant.warning),
      ));
      expect(find.byType(TNoticeBar), findsOneWidget);
    });

    testWidgets('variant: error', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(content: '错误公告'),
        noticeBarTheme: const TNoticeBarThemeData(variant: TNoticeBarVariant.error),
      ));
      expect(find.byType(TNoticeBar), findsOneWidget);
    });

    testWidgets('variant 全量验证均可渲染', (tester) async {
      for (final variant in TNoticeBarVariant.values) {
        await tester.pumpWidget(wrapWithTheme(
          TNoticeBar(content: variant.name),
          noticeBarTheme: TNoticeBarThemeData(variant: variant),
        ));
        expect(find.byType(TNoticeBar), findsOneWidget);
      }
    });
  });

  group('TNoticeBar 图标与自定义内容', () {
    testWidgets('prefixIcon 渲染左侧图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(content: '带前缀图标', prefixIcon: Icons.info),
      ));
      expect(find.byIcon(Icons.info), findsOneWidget);
    });

    testWidgets('suffixIcon 渲染右侧图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(content: '带后缀图标', suffixIcon: Icons.close),
      ));
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('left 自定义 widget 优先于 prefixIcon', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(
          content: '内容',
          left: Text('自定义左侧'),
          prefixIcon: Icons.info,
        ),
      ));
      expect(find.text('自定义左侧'), findsOneWidget);
      // prefixIcon 不应渲染
      expect(find.byIcon(Icons.info), findsNothing);
    });

    testWidgets('right 自定义 widget 优先于 suffixIcon', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(
          content: '内容',
          right: Text('自定义右侧'),
          suffixIcon: Icons.close,
        ),
      ));
      expect(find.text('自定义右侧'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('同时设置 left 和 right 自定义 widget', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(
          content: '中间内容',
          left: Icon(Icons.star),
          right: Icon(Icons.arrow_forward),
        ),
      ));
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      expect(find.text('中间内容'), findsOneWidget);
    });
  });

  group('TNoticeBar marquee 滚动', () {
    testWidgets('marquee=true 水平方向启用 SingleChildScrollView', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(
          content: '这是一条很长的跑马灯公告内容用于测试滚动',
          marquee: true,
        ),
      ));
      await tester.pump();
      expect(find.byType(TNoticeBar), findsOneWidget);
      // marquee 模式下会创建 SingleChildScrollView
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('marquee=false（默认）不创建滚动视图', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(content: '静态公告'),
      ));
      expect(find.byType(SingleChildScrollView), findsNothing);
    });

    testWidgets('marquee=true 垂直方向渲染多条内容', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(
          items: ['第一行', '第二行', '第三行'],
          direction: Axis.vertical,
          marquee: true,
        ),
      ));
      await tester.pump();
      expect(find.byType(TNoticeBar), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('marquee=true 且 content 为 List 时垂直滚动渲染全部行', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(
          items: ['A', 'B', 'C'],
          direction: Axis.vertical,
          marquee: true,
        ),
      ));
      await tester.pump();
      // 垂直 marquee 会渲染所有行 + 第一行重复
      expect(find.text('A'), findsWidgets);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
    });
  });

  group('TNoticeBar onPressed 回调', () {
    testWidgets('未提供 onPressed 时内置区域不创建点击手势', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(
          content: '静态公告',
          prefixIcon: Icons.info,
          suffixIcon: Icons.close,
        ),
      ));

      expect(find.byType(GestureDetector), findsNothing);
    });

    testWidgets('点击内容区域触发 onPressed', (tester) async {
      TNoticeBarTapTarget? triggered;
      await tester.pumpWidget(wrapWithTheme(
        TNoticeBar(
          content: '可点击的公告',
          onPressed: (trigger) => triggered = trigger,
        ),
      ));
      await tester.tap(find.text('可点击的公告'));
      expect(triggered, TNoticeBarTapTarget.content);
    });

    testWidgets('点击 prefixIcon 触发 onPressed', (tester) async {
      TNoticeBarTapTarget? triggered;
      await tester.pumpWidget(wrapWithTheme(
        TNoticeBar(
          content: '内容',
          prefixIcon: Icons.info,
          onPressed: (trigger) => triggered = trigger,
        ),
      ));
      await tester.tap(find.byIcon(Icons.info));
      expect(triggered, TNoticeBarTapTarget.prefix);
    });

    testWidgets('点击 suffixIcon 触发 onPressed', (tester) async {
      TNoticeBarTapTarget? triggered;
      await tester.pumpWidget(wrapWithTheme(
        TNoticeBar(
          content: '内容',
          suffixIcon: Icons.close,
          onPressed: (trigger) => triggered = trigger,
        ),
      ));
      await tester.tap(find.byIcon(Icons.close));
      expect(triggered, TNoticeBarTapTarget.suffix);
    });

    testWidgets('自定义左右插槽由自身处理点击且不触发公告栏回调',
        (tester) async {
      var leftPressed = 0;
      var rightPressed = 0;
      var noticeBarPressed = 0;
      await tester.pumpWidget(wrapWithTheme(
        TNoticeBar(
          content: '内容',
          left: TButton(
            child: const Text('左侧按钮'),
            onPressed: () => leftPressed++,
          ),
          right: TButton(
            child: const Text('右侧按钮'),
            onPressed: () => rightPressed++,
          ),
          onPressed: (_) => noticeBarPressed++,
        ),
      ));

      await tester.tap(find.text('左侧按钮'));
      await tester.tap(find.text('右侧按钮'));

      expect(leftPressed, 1);
      expect(rightPressed, 1);
      expect(noticeBarPressed, 0);
    });
  });

  group('TNoticeBar Theme 注入', () {
    testWidgets('TNoticeBarThemeData.backgroundColor 覆盖背景色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(content: '内容'),
        noticeBarTheme: const TNoticeBarThemeData(backgroundColor: Colors.orange),
      ));
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.color, Colors.orange);
    });

    testWidgets('TNoticeBarThemeData.textStyle 覆盖文字样式', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(content: '样式测试'),
        noticeBarTheme: const TNoticeBarThemeData(
          textStyle: TextStyle(fontSize: 20, color: Colors.red),
        ),
      ));
      expect(find.byType(TNoticeBar), findsOneWidget);
    });

    testWidgets('TNoticeBarThemeData.padding 覆盖内边距', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(content: '内容'),
        noticeBarTheme: const TNoticeBarThemeData(
          padding: EdgeInsets.all(20),
        ),
      ));
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.padding, const EdgeInsets.all(20));
    });

    testWidgets('TNoticeBarThemeData.height 覆盖文字高度', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(content: '内容'),
        noticeBarTheme: const TNoticeBarThemeData(height: 30),
      ));
      expect(find.byType(TNoticeBar), findsOneWidget);
    });

    test('TNoticeBarThemeData.merge 正确合并', () {
      const base = TNoticeBarThemeData(
        variant: TNoticeBarVariant.info,
        height: 22,
      );
      const override = TNoticeBarThemeData(height: 30);
      final merged = base.merge(override);
      expect(merged.variant, TNoticeBarVariant.info);
      expect(merged.height, 30);
    });

    test('TNoticeBarThemeData.copyWith 正确合并', () {
      const base = TNoticeBarThemeData(height: 22);
      final merged = base.copyWith(padding: const EdgeInsets.all(8));
      expect(merged.height, 22);
      expect(merged.padding, const EdgeInsets.all(8));
    });

    test('TNoticeBarThemeData.lerp 插值正确', () {
      const a = TNoticeBarThemeData(height: 22);
      const b = TNoticeBarThemeData(height: 30);
      final mid = a.lerp(b, 0.5);
      expect(mid.height, 26);
    });

    testWidgets('TNoticeBarThemeData.resolve 根据 variant 解析颜色', (tester) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(content: '内容'),
        noticeBarTheme: const TNoticeBarThemeData(variant: TNoticeBarVariant.warning),
      ));
      capturedContext = tester.element(find.byType(TNoticeBar));
      const theme = TNoticeBarThemeData(variant: TNoticeBarVariant.warning);
      final resolved = theme.resolve(capturedContext);
      expect(resolved.backgroundColor, isNotNull);
      expect(resolved.leftIconColor, isNotNull);
    });
  });

  group('TNoticeBar 边界情况', () {
    testWidgets('maxLines 参数影响静态文本行数', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(
          content: '这是一段很长的文本内容用于测试最大行数的限制效果',
          maxLines: 2,
        ),
      ));
      expect(find.byType(TNoticeBar), findsOneWidget);
    });

    testWidgets('direction 默认为 horizontal', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(content: '内容'),
      ));
      final noticeBar = tester.widget<TNoticeBar>(find.byType(TNoticeBar));
      expect(noticeBar.direction, Axis.horizontal);
    });

    testWidgets('空字符串内容渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(content: ''),
      ));
      expect(find.byType(TNoticeBar), findsOneWidget);
    });

    testWidgets('空 List 内容不崩溃', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(items: <String>[]),
      ));
      expect(find.byType(TNoticeBar), findsOneWidget);
    });
  });

  // ============================================================
  // 滚动定时器补充
  // ============================================================
  group('TNoticeBar 滚动定时器', () {
    testWidgets('marquee 水平滚动 Timer.periodic 触发', (tester) async {
      // 覆盖 _scroll 的 Timer.periodic 回调（115-128，含 else 分支）
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(
          content: '这是一条很长的通知栏消息用于测试水平滚动定时器周期触发',
          marquee: true,
        ),
      ));
      // _scroll 用 Timer.periodic(1秒) 无限循环，pump 5 秒让回调触发多次
      // （覆盖 if 分支 + else 分支 offset >= scrollDistance - remainder）
      await tester.pump(const Duration(seconds: 5));
      // 替换为空 widget 以 dispose TNoticeBar（cancel Timer.periodic）
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container())));
      expect(find.byType(TNoticeBar), findsNothing);
    });

    testWidgets('marquee 垂直滚动 Timer.periodic 触发', (tester) async {
      // 覆盖 _step 的 Timer.periodic 回调（137-147）
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(
          items: ['消息一', '消息二', '消息三'],
          direction: Axis.vertical,
          marquee: true,
          interval: Duration(seconds: 1),
        ),
      ));
      // _step 用 Timer.periodic，pump 5 秒让回调触发多次（覆盖 step >= content.length 重置）
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container())));
      expect(find.byType(TNoticeBar), findsNothing);
    });

    testWidgets('marquee 短文本不触发滚动 _getEmptyWidth', (tester) async {
      // 覆盖 _getEmptyWidth（文本宽度 < 容器宽度时不滚动）
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(
          content: '短',
          marquee: true,
        ),
      ));
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container())));
      expect(find.byType(TNoticeBar), findsNothing);
    });

    testWidgets('marquee + left 自定义 widget 渲染', (tester) async {
      // 覆盖 left widget 分支
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(
          content: '带自定义widget的长文本消息内容用于测试滚动',
          left: Icon(Icons.info),
          marquee: true,
        ),
      ));
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container())));
      expect(find.byType(TNoticeBar), findsNothing);
    });

    testWidgets('marquee 长文本滚动到尽头触发 else 分支', (tester) async {
      // 覆盖 120-127（_scroll else 分支：offset >= scrollDistance - remainder）
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(
          content: '这是一条非常非常长的通知栏消息用于测试水平滚动到尽头后的重置逻辑需要足够长的文本才能触发else分支',
          marquee: true,
        ),
      ));
      // pump 12 秒让 Timer.periodic 多次触发到 else 分支
      await tester.pump(const Duration(seconds: 12));
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container())));
      expect(find.byType(TNoticeBar), findsNothing);
    });

    testWidgets('marquee 垂直滚动 step 超过 content.length 触发重置', (tester) async {
      // 覆盖 141（_step 中 step >= content.length → _scrollController!.jumpTo(0)）
      await tester.pumpWidget(wrapWithTheme(
        const TNoticeBar(
          items: ['消息一', '消息二'],
          direction: Axis.vertical,
          marquee: true,
          interval: Duration(seconds: 1),
        ),
      ));
      // pump 10 秒让 Timer.periodic 多次触发到 step >= content.length
      await tester.pump(const Duration(seconds: 10));
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container())));
      expect(find.byType(TNoticeBar), findsNothing);
    });
  });
}
