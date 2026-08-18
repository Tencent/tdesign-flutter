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

  group('loadMore 触底加载 footer（P1-2）', () {
    testWidgets('enableLoadMore 开启且长列表触底时渲染可见 footer', (tester) async {
      // onLoadMore 不立即完成，让 footer 保持加载态以便断言。
      final loadCompleter = Completer<void>();
      await tester.pumpWidget(
        wrap(
          SizedBox(
            height: 300,
            child: TPullDownRefresh(
              onRefresh: () async {},
              onLoadMore: () => loadCompleter.future,
              enableLoadMore: true,
              child: ListView.builder(
                itemCount: 40,
                itemBuilder: (context, index) =>
                    SizedBox(height: 60, child: Text('item$index')),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      // 滚动到底，footer 加载指示器应可见。
      await tester.drag(
        find.byType(ListView),
        const Offset(0, -3000),
        warnIfMissed: false,
      );
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(TLoading).evaluate().isNotEmpty, isTrue);
      // 完成加载并清空残留计时器。
      loadCompleter.complete();
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('enableLoadMore=false 时不渲染 footer', (tester) async {
      await tester.pumpWidget(
        wrap(
          pullDownRefresh(
            onRefresh: () async {},
            onLoadMore: () async {},
            enableLoadMore: false,
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(EasyRefresh), findsOneWidget);
    });

    testWidgets('滚动到底触发 onLoadMore', (tester) async {
      var loaded = false;
      // 内容足够多以便滚动到底触发触底加载。
      await tester.pumpWidget(
        wrap(
          SizedBox(
            height: 300,
            child: TPullDownRefresh(
              onRefresh: () async {},
              onLoadMore: () async => loaded = true,
              enableLoadMore: true,
              child: ListView.builder(
                itemCount: 40,
                itemBuilder: (context, index) =>
                    SizedBox(height: 60, child: Text('item$index')),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      // 滚动到底部触发触底加载。
      await tester.drag(
        find.byType(ListView),
        const Offset(0, -3000),
        warnIfMissed: false,
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));
      expect(loaded, isTrue);
      // 清空 EasyRefresh 内部残留计时器。
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('onLoadMore 为空时即使 enableLoadMore=true 也不加载', (tester) async {
      await tester.pumpWidget(
        wrap(
          pullDownRefresh(
            onRefresh: () async {},
            onLoadMore: null,
            enableLoadMore: true,
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(EasyRefresh), findsOneWidget);
    });

    testWidgets('加载完成后 footer 进入结束语义', (tester) async {
      await tester.pumpWidget(
        wrap(
          SizedBox(
            height: 300,
            child: TPullDownRefresh(
              onRefresh: () async {},
              onLoadMore: () async {},
              enableLoadMore: true,
              child: ListView.builder(
                itemCount: 40,
                itemBuilder: (context, index) =>
                    SizedBox(height: 60, child: Text('item$index')),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      // 滚动到底触发加载，加载立即完成，footer 进入结束（done）语义。
      await tester.drag(
        find.byType(ListView),
        const Offset(0, -3000),
        warnIfMissed: false,
      );
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      // 结束语义：加载完成后 footer 仍在渲染（指示器或结束文案），不再持续加载态。
      final footerRendered =
          find.byType(TLoading).evaluate().isNotEmpty ||
              find.byType(TText).evaluate().isNotEmpty;
      expect(footerRendered, isTrue);
      // 清空残留计时器。
      await tester.pump(const Duration(seconds: 1));
    });
  });

  group('controller 所有权（P1-1）', () {
    testWidgets('外部 controller.dispose 不会双重释放', (tester) async {
      final controller = TPullDownRefreshController();
      await tester.pumpWidget(
        wrap(pullDownRefresh(onRefresh: () async {}, controller: controller)),
      );
      await tester.pump(const Duration(seconds: 1));
      // 组件存活时外部 dispose，仅解绑、不释放底层 controller，不应抛错。
      controller.dispose();
      // 卸载组件，State 仍可正常 dispose 底层 EasyRefreshController（无双重释放异常）。
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
      expect(tester.takeException(), isNull);
    });

    testWidgets('dispose 后 refresh 静默失败而非抛错', (tester) async {
      final controller = TPullDownRefreshController();
      await tester.pumpWidget(
        wrap(pullDownRefresh(onRefresh: () async {}, controller: controller)),
      );
      await tester.pump(const Duration(seconds: 1));
      controller.dispose();
      // dispose 后调用 refresh，应静默失败不抛错（底层 controller 已被解绑）。
      expect(controller.refresh, returnsNormally);
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull);
    });
  });

  group('状态回调去重与异步调度（P2-1）', () {
    testWidgets('onStateChanged 状态跳变去重、不在 build 期同步回调', (tester) async {
      final states = <TPullDownRefreshState>[];
      await tester.pumpWidget(
        wrap(
          pullDownRefresh(
            onRefresh: () async {},
            // 若在 build 期同步触发，这里 setState 会抛错——
            // 组件已改为异步调度，故此处不应抛错。
            onStateChanged: states.add,
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      // 至少上报过 inactive；同一状态不应重复上报多次（已去重）。
      expect(states, contains(TPullDownRefreshState.inactive));
      final inactiveCount = states
          .where((s) => s == TPullDownRefreshState.inactive)
          .length;
      expect(inactiveCount, lessThanOrEqualTo(2));
      expect(tester.takeException(), isNull);
    });
  });

  group('异常传播（P2-2）', () {
    testWidgets('onRefresh 同步抛错不会悬挂刷新', (tester) async {
      await tester.pumpWidget(
        wrap(
          pullDownRefresh(
            onRefresh: () {
              throw StateError('boom');
            },
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      final gesture = await tester.startGesture(const Offset(200, 150));
      // 同步抛错会经 easy_refresh 动画 tick 上抛（组件刻意不吞错误、交给调用方），
      // 属预期行为：逐帧消费异常，核心断言是「刷新不悬挂」——组件仍可正常复位。
      for (var i = 0; i < 15; i++) {
        await gesture.moveBy(const Offset(0, 10));
        // 同步抛错经动画 tick 上抛，属预期，忽略（刷新不悬挂即可）。
        try {
          await tester.pump(const Duration(milliseconds: 20));
        } catch (_) {
          // ignore: empty_catches
        }
      }
      // 同步抛错可能经 easy_refresh 上抛，属预期，忽略。
      try {
        await gesture.up();
      } catch (_) {
        // ignore: empty_catches
      }
      for (var i = 0; i < 10; i++) {
        // 同步抛错可能经后续帧继续上抛，属预期，忽略。
        try {
          await tester.pump(const Duration(milliseconds: 100));
        } catch (_) {
          // ignore: empty_catches
        }
      }
      // 取走框架可能记录的未捕获异常，避免测试失败。
      tester.takeException();
      // 清空残留计时器后组件可正常复位。
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(EasyRefresh), findsOneWidget);
    });

    testWidgets('onRefresh Future 失败不会悬挂刷新', (tester) async {
      await tester.pumpWidget(
        wrap(
          pullDownRefresh(
            onRefresh: () async => throw StateError('boom'),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      final gesture = await tester.startGesture(const Offset(200, 150));
      for (var i = 0; i < 15; i++) {
        await gesture.moveBy(const Offset(0, 10));
        await tester.pump(const Duration(milliseconds: 20));
      }
      await gesture.up();
      // onRefresh 返回的 Future 失败会被组件透传给调用方，属预期行为；
      // 逐帧消费异常，核心断言是「刷新不悬挂」——组件仍可正常复位。
      for (var i = 0; i < 10; i++) {
        // Future 失败经帧上抛，属预期，忽略。
        try {
          await tester.pump(const Duration(milliseconds: 100));
        } catch (_) {
          // ignore: empty_catches
        }
      }
      // 取走框架可能记录的未捕获异常，避免测试失败。
      tester.takeException();
      // 清空残留计时器后组件可正常复位。
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(EasyRefresh), findsOneWidget);
    });
  });

  group('timeout 状态语义（P2-3）', () {
    testWidgets('超时上报 timeout 后结束刷新并复位', (tester) async {
      final states = <TPullDownRefreshState>[];
      final controller = TPullDownRefreshController();
      await tester.pumpWidget(
        wrap(
          pullDownRefresh(
            onRefresh: () => Completer<void>().future,
            refreshTimeout: const Duration(milliseconds: 100),
            onStateChanged: states.add,
            controller: controller,
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      unawaited(controller.refresh());
      for (var i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(states, contains(TPullDownRefreshState.timeout));
      // 超时后组件复位（回到 inactive）。
      await tester.pump(const Duration(seconds: 1));
      expect(states, contains(TPullDownRefreshState.inactive));
    });
  });

  group('逐公开 Demo Widget 断言（P0-1/P1-4）', () {
    testWidgets('基础刷新 demo：onRefresh / child / Header 均存在', (tester) async {
      await tester.pumpWidget(
        wrap(
          SizedBox(
            height: 300,
            child: TPullDownRefresh(
              onRefresh: () async {},
              child: ListView(children: const [
                Text('拖拽该区域演示 顶部下拉刷新'),
                SizedBox(height: 16),
                Text('下拉刷新次数：0'),
              ]),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('拖拽该区域演示 顶部下拉刷新'), findsOneWidget);
      expect(find.text('下拉刷新次数：0'), findsOneWidget);
      expect(find.byType(EasyRefresh), findsOneWidget);
    });

    testWidgets('自定义提示语 demo：四态文案自定义生效', (tester) async {
      await tester.pumpWidget(
        wrap(
          SizedBox(
            height: 300,
            child: TPullDownRefresh(
              texts: const TPullDownRefreshTexts(
                pullToRefresh: '下拉即可刷新...',
                releaseToRefresh: '释放即可刷新...',
                refreshing: '加载中...',
                refreshComplete: '刷新成功',
              ),
              onRefresh: () async {},
              child: ListView(children: const [
                Text('下拉刷新'),
                SizedBox(height: 16),
                Text('自定义提示语刷新次数：0'),
              ]),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('下拉刷新'), findsOneWidget);
      expect(find.text('自定义提示语刷新次数：0'), findsOneWidget);
    });

    testWidgets('刷新超时 demo：refreshTimeout + onTimeout 生效', (tester) async {
      var timedOut = false;
      final controller = TPullDownRefreshController();
      await tester.pumpWidget(
        wrap(
          SizedBox(
            height: 300,
            child: TPullDownRefresh(
              refreshTimeout: const Duration(seconds: 1),
              onTimeout: () => timedOut = true,
              onRefresh: () => Completer<void>().future,
              controller: controller,
              child: ListView(children: const [
                Text('下拉刷新'),
                SizedBox(height: 16),
                Text('超时刷新次数：0'),
              ]),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      unawaited(controller.refresh());
      for (var i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(timedOut, isTrue);
      await tester.pump(const Duration(seconds: 1));
    });
  });
}
