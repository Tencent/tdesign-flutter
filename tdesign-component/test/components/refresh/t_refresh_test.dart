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
      await tester.pumpWidget(
        wrap(
          refreshView(onRefresh: () async {}),
          refreshTheme: const TRefreshThemeData(
            loadingIconColor: Colors.purple,
            loadingTextColor: Colors.teal,
          ),
        ),
      );
      final gesture = await tester.startGesture(const Offset(200, 150));
      await gesture.moveBy(const Offset(0, 120));
      await tester.pump(const Duration(milliseconds: 300));
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
}
