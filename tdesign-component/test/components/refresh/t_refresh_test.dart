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

  group('TRefreshThemeData', () {
    test('仅保存视觉字段', () {
      const base = TRefreshThemeData(
        loadingIcon: TLoadingIcon.circle,
        loadingIconColor: Colors.blue,
        loadingTextColor: Colors.black,
        backgroundColor: Colors.white,
      );
      const override = TRefreshThemeData(
        loadingIcon: TLoadingIcon.point,
        loadingIconColor: Colors.red,
        loadingTextColor: Colors.grey,
        backgroundColor: Colors.red,
      );

      final merged = base.merge(override);
      expect(merged.loadingIcon, TLoadingIcon.point);
      expect(merged.loadingIconColor, Colors.red);
      expect(merged.loadingTextColor, Colors.grey);
      expect(merged.backgroundColor, Colors.red);
      expect(base.merge(null), same(base));

      final copied = base.copyWith(backgroundColor: Colors.blue);
      expect(copied.loadingIcon, TLoadingIcon.circle);
      expect(copied.loadingIconColor, Colors.blue);
      expect(copied.loadingTextColor, Colors.black);
      expect(copied.backgroundColor, Colors.blue);

      final lerped = base.lerp(override, 0.75);
      expect(lerped.loadingIcon, TLoadingIcon.point);
      expect(lerped.loadingIconColor,
          Color.lerp(Colors.blue, Colors.red, 0.75));
      expect(lerped.loadingTextColor,
          Color.lerp(Colors.black, Colors.grey, 0.75));
      expect(lerped.backgroundColor, Color.lerp(Colors.white, Colors.red, 0.75));
      expect(base.lerp(null, 0.5), same(base));
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
    });

    test('行为参数由实例直接控制', () {
      final header = TRefreshHeader(
        extent: 60,
        triggerDistance: 80,
        float: true,
        overScroll: false,
        completeDuration: const Duration(seconds: 2),
        enableHapticFeedback: false,
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
            loadingIconColor: Colors.purple,
            loadingTextColor: Colors.teal,
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

    testWidgets('Theme loading 颜色可覆盖 loading 取色', (tester) async {
      // 用未完成的 Future 保持刷新处于 processing 状态，确保 TLoading 渲染。
      final completer = Completer<void>();
      await tester.pumpWidget(
        wrap(
          refreshView(onRefresh: () => completer.future),
          refreshTheme: const TRefreshThemeData(
            loadingIconColor: Colors.purple,
            loadingTextColor: Colors.teal,
          ),
        ),
      );
      // 下拉并释放，触发 processing 状态，渲染 TLoading。
      final gesture = await tester.startGesture(const Offset(200, 150));
      await gesture.moveBy(const Offset(0, 160));
      await tester.pump(const Duration(milliseconds: 300));
      await gesture.up();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(TLoading), findsWidgets);
      // 校验经主题覆盖后的 loading 取色。
      final loadingTheme =
          Theme.of(tester.element(find.byType(TLoading).first))
              .extension<TLoadingThemeData>();
      expect(loadingTheme?.iconColor, Colors.purple);
      expect(loadingTheme?.textColor, Colors.teal);
      // 结束刷新，避免悬挂的 Future 影响后续断言。
      completer.complete();
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets('未设置 loading 颜色时回退到全局主题色', (tester) async {
      final completer = Completer<void>();
      await tester.pumpWidget(
        wrap(refreshView(onRefresh: () => completer.future)),
      );
      // 下拉并释放，触发 processing 状态，渲染 TLoading。
      final gesture = await tester.startGesture(const Offset(200, 150));
      await gesture.moveBy(const Offset(0, 160));
      await tester.pump(const Duration(milliseconds: 300));
      await gesture.up();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(TLoading), findsWidgets);
      // 未设置 loadingIconColor / loadingTextColor 时，应回退到全局品牌色 / 占位文案色。
      final buildContext = tester.element(find.byType(TLoading).first);
      final loadingTheme =
          Theme.of(buildContext).extension<TLoadingThemeData>();
      expect(loadingTheme?.iconColor, buildContext.tTheme.brandNormalColor);
      expect(loadingTheme?.textColor,
          buildContext.tTheme.textColorPlaceholder);
      completer.complete();
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets('刷新完成后可再次下拉刷新（连续多次）', (tester) async {
      var refreshCount = 0;
      await tester.pumpWidget(
        wrap(
          refreshView(onRefresh: () async {
            refreshCount++;
          }),
        ),
      );

      // 第一次下拉刷新。
      var gesture = await tester.startGesture(const Offset(200, 150));
      await gesture.moveBy(const Offset(0, 160));
      await tester.pump(const Duration(milliseconds: 300));
      await gesture.up();
      // 等待 processing 完成 + 复位回弹。
      await tester.pump(const Duration(seconds: 2));
      await tester.pump(const Duration(seconds: 2));
      expect(refreshCount, 1);
      expect(find.byType(TLoading), findsNothing);

      // 第二次下拉刷新：若复位兜底失效，将无法再次进入 processing。
      gesture = await tester.startGesture(const Offset(200, 150));
      await gesture.moveBy(const Offset(0, 160));
      await tester.pump(const Duration(milliseconds: 300));
      await gesture.up();
      await tester.pump(const Duration(seconds: 2));
      await tester.pump(const Duration(seconds: 2));
      expect(refreshCount, 2);
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
}
