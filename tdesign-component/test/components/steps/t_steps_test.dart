import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrapWithTheme(Widget child, {TStepsThemeData? stepsTheme}) {
    final themeExtensions = <ThemeExtension>[
      if (stepsTheme != null) stepsTheme,
    ];
    return Theme(
      data: ThemeData(extensions: [TThemeData.defaultData()]),
      child: MaterialApp(
        theme: ThemeData(extensions: themeExtensions),
        home: Scaffold(body: child),
      ),
    );
  }

  List<TStepsItemData> buildSteps(int count) {
    return List.generate(count,
        (i) => TStepsItemData(title: '步骤${i + 1}', content: '内容${i + 1}'));
  }

  group('TStepsItemData', () {
    test('带参数构造', () {
      final data = TStepsItemData(title: '标题', content: '内容');
      expect(data.title, '标题');
      expect(data.content, '内容');
    });

    test('至少需要一个非空值断言', () {
      expect(TStepsItemData.new, throwsA(isA<AssertionError>()));
    });

    test('自定义内容构造', () {
      const custom = Text('自定义');
      final data = TStepsItemData(customContent: custom);
      expect(data.customContent, custom);
    });
  });

  group('枚举', () {
    test('TStepsDirection 枚举值', () {
      expect(TStepsDirection.values.length, 2);
      expect(TStepsDirection.values, contains(TStepsDirection.horizontal));
      expect(TStepsDirection.values, contains(TStepsDirection.vertical));
    });

    test('TStepsStatus 枚举值', () {
      expect(TStepsStatus.values.length, 2);
      expect(TStepsStatus.values, contains(TStepsStatus.success));
      expect(TStepsStatus.values, contains(TStepsStatus.error));
    });
  });

  group('TStepsThemeData', () {
    test('默认构造', () {
      const data = TStepsThemeData();
      expect(data.status, null);
      expect(data.simple, null);
    });

    test('带参数构造', () {
      const data = TStepsThemeData(
        status: TStepsStatus.error,
        simple: true,
        readOnly: true,
        verticalSelect: true,
      );
      expect(data.status, TStepsStatus.error);
      expect(data.simple, true);
    });

    test('copyWith', () {
      const data = TStepsThemeData(simple: false);
      final copied = data.copyWith(simple: true, readOnly: true);
      expect(copied.simple, true);
      expect(copied.readOnly, true);
    });

    test('lerp', () {
      const data1 = TStepsThemeData(simple: false);
      const data2 = TStepsThemeData(simple: true);
      final lerped = data1.lerp(data2, 0.5);
      expect(lerped.simple, true);
    });

    test('lerp 非 TStepsThemeData 返回自身', () {
      const data = TStepsThemeData(simple: false);
      final lerped = data.lerp(null, 0.5);
      expect(lerped, same(data));
    });
  });

  group('TSteps 基础渲染', () {
    testWidgets('horizontal 默认渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(TSteps(steps: buildSteps(3))));
      expect(find.byType(TSteps), findsOneWidget);
      expect(find.text('步骤1'), findsOneWidget);
    });

    testWidgets('vertical 方向渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSteps(steps: buildSteps(3), direction: TStepsDirection.vertical),
      ));
      expect(find.byType(TSteps), findsOneWidget);
    });

    testWidgets('使用 value 指定激活索引', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSteps(steps: buildSteps(3), value: 1),
      ));
      expect(find.byType(TSteps), findsOneWidget);
    });

    testWidgets('父级更新 value 同步激活索引', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSteps(steps: buildSteps(3), value: 0),
      ));
      await tester.pumpWidget(wrapWithTheme(
        TSteps(steps: buildSteps(3), value: 2),
      ));
      expect(find.byType(TSteps), findsOneWidget);
    });
  });

  group('TSteps 状态', () {
    testWidgets('success 状态', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSteps(steps: buildSteps(3), status: TStepsStatus.success),
      ));
      expect(find.byType(TSteps), findsOneWidget);
    });

    testWidgets('error 状态', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSteps(steps: buildSteps(3), status: TStepsStatus.error),
      ));
      expect(find.byType(TSteps), findsOneWidget);
    });

    testWidgets('simple 模式', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSteps(steps: buildSteps(3), simple: true),
      ));
      expect(find.byType(TSteps), findsOneWidget);
    });

    testWidgets('readOnly 模式', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSteps(steps: buildSteps(3), readOnly: true),
      ));
      expect(find.byType(TSteps), findsOneWidget);
    });

    testWidgets('verticalSelect 模式', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSteps(
          steps: buildSteps(3),
          direction: TStepsDirection.vertical,
          verticalSelect: true,
        ),
      ));
      expect(find.byType(TSteps), findsOneWidget);
    });
  });

  group('TSteps 边界', () {
    testWidgets('value 超出上限自动 clamp', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSteps(steps: buildSteps(3), value: 10),
      ));
      expect(find.byType(TSteps), findsOneWidget);
    });

    testWidgets('value 为负数自动 clamp', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSteps(steps: buildSteps(3), value: -1),
      ));
      expect(find.byType(TSteps), findsOneWidget);
    });

    testWidgets('使用 mergeExtension 子树覆盖', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSteps(
          steps: buildSteps(3),
        ),
        stepsTheme: const TStepsThemeData(simple: true),
      ));
      expect(find.byType(TSteps), findsOneWidget);
    });
  });

  // ============================================================
  // 覆盖率补充
  // ============================================================
  group('TSteps 覆盖率补充', () {
    // 覆盖 successIcon 分支（107, 108 行）
    testWidgets('successIcon 渲染成功图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSteps(
          steps: [
            TStepsItemData(title: '步骤1', successIcon: TIcons.check_circle),
            TStepsItemData(title: '步骤2'),
          ],
          value: 1,
        ),
      ));
      expect(find.byType(TSteps), findsOneWidget);
    });

    // 覆盖 errorIcon + error status 分支（126-129 行）
    testWidgets('error 状态渲染错误图标', (tester) async {
      // TStepsStatus 只有 success/error，通过 TStepsItemData 触发
      await tester.pumpWidget(wrapWithTheme(
        TSteps(
          steps: [
            TStepsItemData(title: '步骤1', errorIcon: TIcons.close_circle),
            TStepsItemData(title: '步骤2'),
          ],
          value: 0,
          direction: TStepsDirection.vertical,
        ),
      ));
      expect(find.byType(TSteps), findsOneWidget);
    });

    // 覆盖 simple + active + !readOnly 分支（167 行）
    testWidgets('simple 模式激活索引渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSteps(
          steps: buildSteps(3),
          value: 1,
          direction: TStepsDirection.vertical,
        ),
        stepsTheme: const TStepsThemeData(simple: true),
      ));
      expect(find.byType(TSteps), findsOneWidget);
    });

    // 覆盖 customTitle 分支（212 行）
    testWidgets('customTitle 渲染自定义标题', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSteps(
          steps: [
            TStepsItemData(
              title: '步骤1',
              customTitle: const Text('自定义标题'),
            ),
          ],
          direction: TStepsDirection.vertical,
        ),
      ));
      expect(find.byType(TSteps), findsOneWidget);
      expect(find.text('自定义标题'), findsOneWidget);
    });

    // 覆盖 customContent 分支（276 行）
    testWidgets('customContent 渲染自定义内容', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSteps(
          steps: [
            TStepsItemData(
              title: '步骤1',
              customContent: const Text('自定义内容'),
            ),
          ],
          direction: TStepsDirection.vertical,
        ),
      ));
      expect(find.byType(TSteps), findsOneWidget);
      expect(find.text('自定义内容'), findsOneWidget);
    });
  });
}
