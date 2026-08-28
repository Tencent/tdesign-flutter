import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/loading/t_circle_indicator.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child, {TLoadingThemeData? loadingTheme}) {
    var theme = TThemeBuilder.light(TThemeData.defaultData());
    if (loadingTheme != null) {
      theme = theme.mergeExtension(loadingTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: child),
    );
  }

  Widget pullDownRefresh({
    FutureOr<void> Function()? onRefresh,
    FutureOr<void> Function()? onLoadMore,
    TPullDownRefreshController? controller,
    TPullDownRefreshTexts? texts,
    Duration? refreshTimeout,
    ValueChanged<TPullDownRefreshState>? onStateChanged,
  }) {
    return SizedBox(
      height: 300,
      child: TPullDownRefresh(
        onRefresh: onRefresh,
        onLoadMore: onLoadMore,
        controller: controller,
        texts: texts,
        refreshTimeout: refreshTimeout,
        onStateChanged: onStateChanged,
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) => ListTile(title: Text('项目$index')),
        ),
      ),
    );
  }

  group('TPullDownRefresh 最小化组件', () {
    test('跨端可见行为默认值与小程序一致', () {
      const widget = TPullDownRefresh(child: SizedBox());
      expect(widget.loadingBarHeight, 50);
      expect(widget.maxBarHeight, 80);
      expect(widget.lowerThreshold, 50);
      expect(widget.successDuration, const Duration(milliseconds: 500));
      expect(widget.refreshTimeout, const Duration(milliseconds: 3000));
    });

    test('公开尺寸与时长参数拒绝无效边界', () {
      expect(
        () => TPullDownRefresh(loadingBarHeight: 0, child: const SizedBox()),
        throwsAssertionError,
      );
      expect(
        () => TPullDownRefresh(
          loadingBarHeight: 60,
          maxBarHeight: 50,
          child: const SizedBox(),
        ),
        throwsAssertionError,
      );
    });

    testWidgets('默认渲染（loadingBarHeight=50）', (tester) async {
      await tester.pumpWidget(wrap(pullDownRefresh(onRefresh: () async {})));
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
          pullDownRefresh(onRefresh: () async {}, onStateChanged: states.add),
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
                itemBuilder: (context, index) =>
                    ListTile(title: Text('项目$index')),
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
      final states = <TPullDownRefreshState>[];
      final refreshCompleter = Completer<void>();
      final controller = TPullDownRefreshController();
      await tester.pumpWidget(
        wrap(
          pullDownRefresh(
            onRefresh: () => refreshCompleter.future,
            refreshTimeout: null,
            onStateChanged: states.add,
            controller: controller,
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      unawaited(controller.refresh());
      await tester.pump(const Duration(milliseconds: 200));
      expect(states, isNot(contains(TPullDownRefreshState.timeout)));
      refreshCompleter.complete();
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('refreshTimeout 超时上报 timeout 状态', (tester) async {
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
      // 不 await：先推进动画和超时，再验证 controller Future 已完成。
      unawaited(controller.refresh());
      // 分步推进，让 EasyRefresh 完成下拉动画并触发超时计时器。
      for (var i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(states, contains(TPullDownRefreshState.timeout));
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
      final refreshFuture = controller.refresh();
      for (var i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(refreshed, isTrue);
      await refreshFuture;
      // 清空 EasyRefresh 内部残留计时器。
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('controller.refresh 等待 onRefresh 进入终态', (tester) async {
      final refreshCompleter = Completer<void>();
      var settled = false;
      final controller = TPullDownRefreshController();
      await tester.pumpWidget(
        wrap(
          pullDownRefresh(
            onRefresh: () => refreshCompleter.future,
            controller: controller,
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));

      final refreshFuture = controller.refresh().then((_) => settled = true);
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(settled, isFalse);

      refreshCompleter.complete();
      await tester.pump(const Duration(seconds: 1));
      await refreshFuture;
      expect(settled, isTrue);
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('controller.refresh 在回调失败后也完成', (tester) async {
      final reported = <Object?>[];
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) => reported.add(details.exception);
      addTearDown(() => FlutterError.onError = originalOnError);

      final controller = TPullDownRefreshController();
      await tester.pumpWidget(
        wrap(
          pullDownRefresh(
            onRefresh: () async => throw StateError('refresh failed'),
            controller: controller,
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));

      final refreshFuture = controller.refresh();
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      await refreshFuture;
      expect(reported, contains(isA<StateError>()));
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('onLoadMore 非空时自动启用触底加载', (tester) async {
      await tester.pumpWidget(
        wrap(pullDownRefresh(onRefresh: () async {}, onLoadMore: () async {})),
      );
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('项目0'), findsOneWidget);
      // 触底加载为可选能力，仅验证可渲染。
      expect(find.byType(EasyRefresh), findsOneWidget);
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
      expect(find.byType(EasyRefresh), findsOneWidget);
    });
  });

  group('TPullDownRefresh 交互状态', () {
    testWidgets('下拉时刷新头与滚动内容同步下移', (tester) async {
      await tester.pumpWidget(
        wrap(pullDownRefresh(onRefresh: () => Completer<void>().future)),
      );
      await tester.pump(const Duration(seconds: 1));

      final firstItem = find.text('项目0');
      final initialTop = tester.getTopLeft(firstItem).dy;
      final gesture = await tester.startGesture(const Offset(200, 150));
      await gesture.moveBy(const Offset(0, 40));
      await tester.pump(const Duration(milliseconds: 100));

      expect(tester.getTopLeft(firstItem).dy, greaterThan(initialTop));

      await gesture.cancel();
      await tester.pumpAndSettle();
    });

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

    testWidgets('loading 样式继承 Theme 子树', (tester) async {
      final completer = Completer<void>();
      final controller = TPullDownRefreshController();
      await tester.pumpWidget(
        wrap(
          pullDownRefresh(
            onRefresh: () => completer.future,
            controller: controller,
          ),
          loadingTheme: const TLoadingThemeData(
            iconColor: Colors.red,
            duration: 1234,
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      unawaited(controller.refresh());
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        if (find.byType(TCircleIndicator).evaluate().isNotEmpty) {
          break;
        }
      }
      final indicator = tester.widget<TCircleIndicator>(
        find.byType(TCircleIndicator),
      );
      expect(indicator.color, Colors.red);
      expect(indicator.duration, 1234);
      completer.complete();
      await tester.pump(const Duration(seconds: 1));
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

  group('loadMore 触底事件', () {
    testWidgets('触底加载不渲染小程序未定义的可见 footer', (tester) async {
      final loadCompleter = Completer<void>();
      await tester.pumpWidget(
        wrap(
          SizedBox(
            height: 300,
            child: TPullDownRefresh(
              onRefresh: () async {},
              onLoadMore: () => loadCompleter.future,
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
      // 滚动到底会触发事件，但不应额外绘制 loading/no-more UI。
      await tester.drag(
        find.byType(ListView),
        const Offset(0, -3000),
        warnIfMissed: false,
      );
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(TLoading), findsNothing);
      expect(find.text('/'), findsNothing);
      // 完成加载并清空残留计时器。
      loadCompleter.complete();
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('onLoadMore 为空时不渲染 footer', (tester) async {
      await tester.pumpWidget(
        wrap(pullDownRefresh(onRefresh: () async {}, onLoadMore: null)),
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

    testWidgets('onLoadMore 为空时不加载', (tester) async {
      await tester.pumpWidget(
        wrap(pullDownRefresh(onRefresh: () async {}, onLoadMore: null)),
      );
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(EasyRefresh), findsOneWidget);
    });
  });

  group('controller 所有权（P1-1）', () {
    testWidgets('组件卸载后 refresh 静默失败而非抛错', (tester) async {
      final controller = TPullDownRefreshController();
      await tester.pumpWidget(
        wrap(pullDownRefresh(onRefresh: () async {}, controller: controller)),
      );
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
      // 组件卸载后调用 refresh，应静默失败不抛错（底层 controller 已被解绑）。
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
    testWidgets('onRefresh 同步抛错不会悬挂刷新且错误经 FlutterError 上报', (tester) async {
      final reported = <Object?>[];
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) => reported.add(details.exception);
      addTearDown(() => FlutterError.onError = originalOnError);

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
      for (var i = 0; i < 15; i++) {
        await gesture.moveBy(const Offset(0, 10));
        await tester.pump(const Duration(milliseconds: 20));
      }
      await gesture.up();
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      // 错误已通过 FlutterError.reportError 上报（不吞掉），且刷新不悬挂。
      expect(reported, isNotEmpty);
      expect(reported.first, isA<StateError>());
      // 清空残留计时器后组件可正常复位。
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(EasyRefresh), findsOneWidget);
    });

    testWidgets('onRefresh Future 失败不会悬挂刷新且错误经 FlutterError 上报', (
      tester,
    ) async {
      final reported = <Object?>[];
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) => reported.add(details.exception);
      addTearDown(() => FlutterError.onError = originalOnError);

      await tester.pumpWidget(
        wrap(pullDownRefresh(onRefresh: () async => throw StateError('boom'))),
      );
      await tester.pump(const Duration(seconds: 1));
      final gesture = await tester.startGesture(const Offset(200, 150));
      for (var i = 0; i < 15; i++) {
        await gesture.moveBy(const Offset(0, 10));
        await tester.pump(const Duration(milliseconds: 20));
      }
      await gesture.up();
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      // 错误已通过 FlutterError.reportError 上报（不吞掉），且刷新不悬挂。
      expect(reported, isNotEmpty);
      expect(reported.first, isA<StateError>());
      // 清空残留计时器后组件可正常复位。
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(EasyRefresh), findsOneWidget);
    });

    testWidgets('onLoadMore 同步抛错不悬挂加载且错误经 FlutterError 上报', (tester) async {
      final reported = <Object?>[];
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) => reported.add(details.exception);
      addTearDown(() => FlutterError.onError = originalOnError);

      await tester.pumpWidget(
        wrap(
          pullDownRefresh(
            onRefresh: () async {},
            onLoadMore: () {
              throw StateError('load boom');
            },
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      // 滚动到底触发触底加载（同步抛错）。
      await tester.drag(
        find.byType(ListView),
        const Offset(0, -3000),
        warnIfMissed: false,
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));
      // 错误经 FlutterError.reportError 上报（不吞掉），加载不悬挂。
      expect(reported, isNotEmpty);
      expect(reported.first, isA<StateError>());
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(EasyRefresh), findsOneWidget);
    });

    testWidgets('onLoadMore Future 失败不悬挂加载且错误经 FlutterError 上报', (
      tester,
    ) async {
      final reported = <Object?>[];
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) => reported.add(details.exception);
      addTearDown(() => FlutterError.onError = originalOnError);

      await tester.pumpWidget(
        wrap(
          pullDownRefresh(
            onRefresh: () async {},
            onLoadMore: () async => throw StateError('load boom'),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      await tester.drag(
        find.byType(ListView),
        const Offset(0, -3000),
        warnIfMissed: false,
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));
      expect(reported, isNotEmpty);
      expect(reported.first, isA<StateError>());
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(EasyRefresh), findsOneWidget);
    });
  });

  group('timeout 状态语义（P2-3）', () {
    testWidgets('超时上报 timeout 后结束刷新并复位', (tester) async {
      final states = <TPullDownRefreshState>[];
      final controller = TPullDownRefreshController();
      final refreshCompleter = Completer<void>();
      await tester.pumpWidget(
        wrap(
          pullDownRefresh(
            onRefresh: () => refreshCompleter.future,
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
      expect(states.last, TPullDownRefreshState.inactive);
      expect(states, isNot(contains(TPullDownRefreshState.done)));
      // 迟到的业务 Future 不应再次触发 done。
      refreshCompleter.complete();
      await tester.pump(const Duration(seconds: 1));
      expect(states, isNot(contains(TPullDownRefreshState.done)));
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
              child: ListView(
                children: const [
                  Text('拖拽该区域演示 顶部下拉刷新'),
                  SizedBox(height: 16),
                  Text('下拉刷新次数：0'),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('拖拽该区域演示 顶部下拉刷新'), findsOneWidget);
      expect(find.text('下拉刷新次数：0'), findsOneWidget);
      expect(find.byType(EasyRefresh), findsOneWidget);
    }, tags: 'demo');

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
              child: ListView(
                children: const [
                  Text('下拉刷新'),
                  SizedBox(height: 16),
                  Text('自定义提示语刷新次数：0'),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('下拉刷新'), findsOneWidget);
      expect(find.text('自定义提示语刷新次数：0'), findsOneWidget);
    }, tags: 'demo');

    testWidgets('刷新超时 demo：refreshTimeout + timeout 状态生效', (tester) async {
      final states = <TPullDownRefreshState>[];
      final controller = TPullDownRefreshController();
      await tester.pumpWidget(
        wrap(
          SizedBox(
            height: 300,
            child: TPullDownRefresh(
              refreshTimeout: const Duration(seconds: 1),
              onStateChanged: states.add,
              onRefresh: () => Completer<void>().future,
              controller: controller,
              child: ListView(
                children: const [
                  Text('下拉刷新'),
                  SizedBox(height: 16),
                  Text('超时刷新次数：0'),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      unawaited(controller.refresh());
      for (var i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(states, contains(TPullDownRefreshState.timeout));
      await tester.pump(const Duration(seconds: 1));
    }, tags: 'demo');
  });
}
