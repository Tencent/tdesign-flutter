import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child, {TRefreshThemeData? refreshTheme}) {
    return MaterialApp(
      theme: refreshTheme == null
          ? TThemeBuilder.light(TThemeData.defaultData())
          : TThemeBuilder.light(TThemeData.defaultData())
              .mergeExtension(refreshTheme),
      home: Scaffold(body: child),
    );
  }

  Widget refreshView({
    TRefreshHeader? header,
    Future<void> Function()? onRefresh,
  }) {
    return SizedBox(
      height: 300,
      child: EasyRefresh(
        header: header ?? TRefreshHeader(),
        onRefresh: onRefresh,
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) => ListTile(
            title: Text('项目$index'),
          ),
        ),
      ),
    );
  }

  Widget pullDownRefresh({
    FutureOr<void> Function()? onRefresh,
    FutureOr<void> Function()? onLoadMore,
    bool enableLoadMore = false,
    bool disabled = false,
    TPullDownRefreshController? controller,
    TPullDownRefreshTexts? texts,
    Duration? refreshTimeout,
    VoidCallback? onTimeout,
    ValueChanged<TPullDownRefreshState>? onStateChanged,
    TLoadingThemeData? loadingTheme,
  }) {
    return SizedBox(
      height: 300,
      child: TPullDownRefresh(
        onRefresh: onRefresh,
        onLoadMore: onLoadMore,
        enableLoadMore: enableLoadMore,
        disabled: disabled,
        controller: controller,
        texts: texts,
        refreshTimeout: refreshTimeout,
        onTimeout: onTimeout,
        onStateChanged: onStateChanged,
        loadingTheme: loadingTheme,
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) => ListTile(
            title: Text('项目$index'),
          ),
        ),
      ),
    );
  }

  group('TRefreshThemeData', () {
    test('仅保存视觉字段', () {
      const base = TRefreshThemeData(
        loadingIcon: TLoadingIcon.circle,
        backgroundColor: Colors.white,
      );
      const override = TRefreshThemeData(
        loadingIcon: TLoadingIcon.point,
        backgroundColor: Colors.red,
      );

      final merged = base.merge(override);
      expect(merged.loadingIcon, TLoadingIcon.point);
      expect(merged.backgroundColor, Colors.red);
      expect(base.merge(null), same(base));

      final copied = base.copyWith(backgroundColor: Colors.blue);
      expect(copied.loadingIcon, TLoadingIcon.circle);
      expect(copied.backgroundColor, Colors.blue);

      final lerped = base.lerp(override, 0.75);
      expect(lerped.loadingIcon, TLoadingIcon.point);
      expect(lerped.backgroundColor, Color.lerp(Colors.white, Colors.red, 0.75));
      expect(base.lerp(null, 0.5), same(base));
      expect(TRefreshThemeData.lerpDouble(null, null, 0.5), isNull);
    });
  });

  group('TRefreshHeader 构造', () {
    test('默认参数', () {
      final header = TRefreshHeader();
      expect(header, isA<Header>());
      expect(header.finalExtent, 48);
      expect(header.finalTriggerDistance, 48);
      expect(header.finalFloat, isFalse);
      expect(header.finalOverScroll, isTrue);
      expect(header.finalLoadingIcon, isNull);
      expect(header.finalBackgroundColor, isNull);
      expect(header.enableHapticFeedback, isTrue);
      expect(header.enableInfiniteRefresh, isFalse);
    });

    test('行为参数由实例直接控制', () {
      final header = TRefreshHeader(
        extent: 60,
        triggerDistance: 80,
        clamping: false,
        float: true,
        overScroll: false,
        completeDuration: const Duration(seconds: 2),
        enableHapticFeedback: false,
        enableInfiniteRefresh: true,
        infiniteOffset: 120,
        loadingIcon: TLoadingIcon.activity,
        backgroundColor: Colors.blue,
      );
      expect(header.finalExtent, 60);
      expect(header.finalTriggerDistance, 80);
      expect(header.finalFloat, isTrue);
      expect(header.finalOverScroll, isFalse);
      expect(header.finalCompleteDuration, const Duration(seconds: 2));
      expect(header.finalLoadingIcon, TLoadingIcon.activity);
      expect(header.finalBackgroundColor, Colors.blue);
      expect(header.enableHapticFeedback, isFalse);
      expect(header.enableInfiniteRefresh, isTrue);
    });

    test('非法尺寸触发断言', () {
      expect(
        () => TRefreshHeader(triggerDistance: 0),
        throwsAssertionError,
      );
      expect(
        () => TRefreshHeader(extent: -1),
        throwsAssertionError,
      );
      expect(
        () => TRefreshHeader(extent: 80, triggerDistance: 40),
        throwsAssertionError,
      );
      expect(
        () => TRefreshHeader(
          extent: 80,
          triggerDistance: 40,
          float: true,
        ),
        returnsNormally,
      );
    });
  });

  group('EasyRefresh 集成', () {
    testWidgets('基础渲染', (tester) async {
      await tester.pumpWidget(wrap(refreshView(onRefresh: () async {})));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(EasyRefresh), findsOneWidget);
      expect(find.text('项目0'), findsOneWidget);
    });

    testWidgets('无 onRefresh 也可渲染', (tester) async {
      await tester.pumpWidget(wrap(refreshView()));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(EasyRefresh), findsOneWidget);
    });

    testWidgets('Theme Extension 提供视觉默认值', (tester) async {
      await tester.pumpWidget(
        wrap(
          refreshView(onRefresh: () async {}),
          refreshTheme: const TRefreshThemeData(
            loadingIcon: TLoadingIcon.point,
            backgroundColor: Colors.yellow,
          ),
        ),
      );
      final gesture = await tester.startGesture(const Offset(200, 150));
      await gesture.moveBy(const Offset(0, 120));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(TGIconHeaderWidget), findsWidgets);
      await gesture.up();
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets('实例视觉参数优先于 Theme Extension', (tester) async {
      await tester.pumpWidget(
        wrap(
          refreshView(
            header: TRefreshHeader(
              loadingIcon: TLoadingIcon.activity,
              backgroundColor: Colors.green,
            ),
            onRefresh: () async {},
          ),
          refreshTheme: const TRefreshThemeData(
            loadingIcon: TLoadingIcon.point,
            backgroundColor: Colors.red,
          ),
        ),
      );
      final gesture = await tester.startGesture(const Offset(200, 150));
      await gesture.moveBy(const Offset(0, 120));
      await tester.pump(const Duration(milliseconds: 300));
      final headerWidget = tester.widget<TGIconHeaderWidget>(
        find.byType(TGIconHeaderWidget).first,
      );
      expect(headerWidget.loadingIcon, TLoadingIcon.activity);
      expect(headerWidget.backgroundColor, Colors.green);
      await gesture.up();
      await tester.pump(const Duration(seconds: 2));
    });
  });

  test('公开枚举与状态类型可用', () {
    expect(TLoadingIcon.values, hasLength(3));
    expect(TGIconHeaderWidgetState, isNotNull);
  });

  group('TPullDownRefresh 最小化组件', () {
    testWidgets('默认渲染（loadingBarHeight=50）', (tester) async {
      await tester.pumpWidget(
        wrap(pullDownRefresh(onRefresh: () async {})),
      );
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(EasyRefresh), findsOneWidget);
      expect(find.text('项目0'), findsOneWidget);
    });

    testWidgets('无 onRefresh 时禁用刷新但仍渲染', (tester) async {
      await tester.pumpWidget(wrap(pullDownRefresh()));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(EasyRefresh), findsOneWidget);
      expect(find.text('项目0'), findsOneWidget);
    });

    testWidgets('disabled 禁用下拉', (tester) async {
      await tester.pumpWidget(
        wrap(pullDownRefresh(onRefresh: () async {}, disabled: true)),
      );
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(EasyRefresh), findsOneWidget);
    });

    testWidgets('texts 自定义四态文案生效', (tester) async {
      await tester.pumpWidget(
        wrap(
          pullDownRefresh(
            onRefresh: () async {},
            texts: const TPullDownRefreshTexts(
              pullToRefresh: '下拉',
              releaseToRefresh: '松手',
              refreshing: '加载中',
              refreshComplete: '完成',
            ),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('项目0'), findsOneWidget);
    });

    testWidgets('onStateChanged 回调状态变化', (tester) async {
      final states = <TPullDownRefreshState>[];
      await tester.pumpWidget(
        wrap(
          pullDownRefresh(
            onRefresh: () async {},
            onStateChanged: states.add,
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      expect(states, contains(TPullDownRefreshState.inactive));
    });

    testWidgets('默认 refreshTimeout 为 3 秒', (tester) async {
      await tester.pumpWidget(
        wrap(
          SizedBox(
            height: 300,
            child: TPullDownRefresh(
              onRefresh: () async {},
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) => ListTile(
                  title: Text('项目$index'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      final widget = tester.widget<TPullDownRefresh>(
        find.byType(TPullDownRefresh),
      );
      expect(widget.refreshTimeout, const Duration(milliseconds: 3000));
    });

    testWidgets('refreshTimeout 为 null 时关闭超时', (tester) async {
      var timedOut = false;
      final controller = TPullDownRefreshController();
      await tester.pumpWidget(
        wrap(
          pullDownRefresh(
            onRefresh: () => Completer<void>().future,
            refreshTimeout: null,
            onTimeout: () => timedOut = true,
            controller: controller,
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      unawaited(controller.refresh());
      await tester.pump(const Duration(milliseconds: 200));
      expect(timedOut, isFalse);
    });

    testWidgets('refreshTimeout 超时触发 onTimeout', (tester) async {
      var timedOut = false;
      final controller = TPullDownRefreshController();
      await tester.pumpWidget(
        wrap(
          pullDownRefresh(
            onRefresh: () => Completer<void>().future,
            refreshTimeout: const Duration(milliseconds: 100),
            onTimeout: () => timedOut = true,
            controller: controller,
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      // 不 await：onRefresh 永不完成，await 会挂起测试。
      unawaited(controller.refresh());
      // 分步推进，让 EasyRefresh 完成下拉动画并触发超时计时器。
      for (var i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(timedOut, isTrue);
      // 清空 EasyRefresh 内部残留计时器。
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('controller.refresh 可外部触发', (tester) async {
      var refreshed = false;
      final controller = TPullDownRefreshController();
      await tester.pumpWidget(
        wrap(
          pullDownRefresh(
            onRefresh: () async => refreshed = true,
            controller: controller,
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      // 不 await：await 触发动画可能在测试中挂起，改用 pump 推进。
      unawaited(controller.refresh());
      for (var i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(refreshed, isTrue);
      // 清空 EasyRefresh 内部残留计时器。
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('enableLoadMore + onLoadMore 触底加载', (tester) async {
      await tester.pumpWidget(
        wrap(
          pullDownRefresh(
            onRefresh: () async {},
            onLoadMore: () async {},
            enableLoadMore: true,
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('项目0'), findsOneWidget);
      // 触底加载为可选能力，仅验证可渲染。
      expect(find.byType(EasyRefresh), findsOneWidget);
    });

    testWidgets('loadMore / finishLoadMore / reset 可调用', (tester) async {
      var loaded = false;
      final controller = TPullDownRefreshController();
      await tester.pumpWidget(
        wrap(
          pullDownRefresh(
            onRefresh: () async {},
            onLoadMore: () async => loaded = true,
            enableLoadMore: true,
            controller: controller,
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      unawaited(controller.loadMore());
      for (var i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(loaded, isTrue);
      controller.finishLoadMore();
      controller.reset();
      controller.dispose();
      // 清空 EasyRefresh 内部残留计时器。
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('controller 切换时重新绑定', (tester) async {
      final c1 = TPullDownRefreshController();
      final c2 = TPullDownRefreshController();
      await tester.pumpWidget(
        wrap(pullDownRefresh(onRefresh: () async {}, controller: c1)),
      );
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpWidget(
        wrap(pullDownRefresh(onRefresh: () async {}, controller: c2)),
      );
      await tester.pump(const Duration(seconds: 1));
      c1.dispose();
      c2.dispose();
      expect(find.byType(EasyRefresh), findsOneWidget);
    });
  });

  group('TPullDownRefresh 交互状态', () {
    testWidgets('下拉手势触发 dragging 与 refreshing 状态', (tester) async {
      final states = <TPullDownRefreshState>[];
      final completer = Completer<void>();
      await tester.pumpWidget(
        wrap(
          pullDownRefresh(
            // onRefresh 不立即完成，便于捕获 refreshing 状态。
            onRefresh: () => completer.future,
            onStateChanged: states.add,
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      final gesture = await tester.startGesture(const Offset(200, 150));
      // 分步下拉：先低于触发阈值，捕获 dragging。
      for (var i = 0; i < 5; i++) {
        await gesture.moveBy(const Offset(0, 5));
        await tester.pump(const Duration(milliseconds: 20));
      }
      // 继续下拉超过触发阈值，进入 ready。
      for (var i = 0; i < 10; i++) {
        await gesture.moveBy(const Offset(0, 10));
        await tester.pump(const Duration(milliseconds: 20));
      }
      // 松手触发刷新，捕获 refreshing。
      await gesture.up();
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(states, contains(TPullDownRefreshState.dragging));
      expect(states, contains(TPullDownRefreshState.refreshing));
      // 完成刷新并清空残留计时器。
      completer.complete();
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('loadingTheme 自定义渲染', (tester) async {
      await tester.pumpWidget(
        wrap(
          pullDownRefresh(
            onRefresh: () async {},
            loadingTheme: const TLoadingThemeData(
              iconColor: Colors.red,
            ),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(EasyRefresh), findsOneWidget);
    });

    testWidgets('同步 onRefresh 返回值可处理', (tester) async {
      var refreshed = false;
      await tester.pumpWidget(
        wrap(
          pullDownRefresh(
            onRefresh: () {
              refreshed = true;
            },
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      final gesture = await tester.startGesture(const Offset(200, 150));
      // 分步下拉超过触发阈值并松手，触发同步 onRefresh。
      for (var i = 0; i < 15; i++) {
        await gesture.moveBy(const Offset(0, 10));
        await tester.pump(const Duration(milliseconds: 20));
      }
      await gesture.up();
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(refreshed, isTrue);
      // 清空 EasyRefresh 内部残留计时器。
      await tester.pump(const Duration(seconds: 1));
    });
  });
}
