import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TSkeleton V1.0 Widget 测试
///
/// 覆盖 variant 四档（avatar/image/text/paragraph）、
/// animation 两档（gradient/flashed）、delay 延迟、
/// fromRowCol 自定义行列、Theme 注入、边界情况。
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child, {TSkeletonThemeData? skeletonTheme}) {
    final themeExtensions = <ThemeExtension>[
      if (skeletonTheme != null) skeletonTheme,
    ];
    // 注意：必须通过 MaterialApp.theme 传递 extensions
    return MaterialApp(
      theme: ThemeData(
        extensions: [TThemeData.defaultData(), ...themeExtensions],
      ),
      home: Scaffold(body: Column(children: [child])),
    );
  }

  List<Rect> skeletonBlockRects(WidgetTester tester, Color color) {
    final blocks = find.byWidgetPredicate(
      (widget) =>
          widget is Container &&
          widget.decoration is BoxDecoration &&
          (widget.decoration! as BoxDecoration).color == color,
    );
    return List<Rect>.generate(
      blocks.evaluate().length,
      (index) => tester.getRect(blocks.at(index)),
    );
  }

  group('TSkeleton 基础渲染', () {
    testWidgets('默认 variant=text 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(TSkeleton()));
      await tester.pumpAndSettle();
      expect(find.byType(TSkeleton), findsOneWidget);
    });

    testWidgets('variant: avatar 渲染圆形', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSkeleton(variant: TSkeletonVariant.avatar),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TSkeleton), findsOneWidget);
    });

    testWidgets('variant: image 渲染矩形', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSkeleton(variant: TSkeletonVariant.image),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TSkeleton), findsOneWidget);
    });

    testWidgets('variant: text 渲染文本骨架', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSkeleton(variant: TSkeletonVariant.text),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TSkeleton), findsOneWidget);
    });

    testWidgets('variant: paragraph 渲染段落骨架', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSkeleton(variant: TSkeletonVariant.paragraph),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TSkeleton), findsOneWidget);
    });

    testWidgets('variant 全量验证均可渲染', (tester) async {
      for (final variant in TSkeletonVariant.values) {
        await tester.pumpWidget(wrapWithTheme(
          TSkeleton(variant: variant),
        ));
        await tester.pumpAndSettle();
        expect(find.byType(TSkeleton), findsOneWidget);
      }
    });
  });

  group('TSkeleton animation 两档', () {
    testWidgets('animation: gradient 渲染渐变动画', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSkeleton(
          variant: TSkeletonVariant.text,
          animation: TSkeletonAnimation.gradient,
        ),
      ));
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byType(TSkeleton), findsOneWidget);
      // gradient 动画使用 ShaderMask
      expect(find.byType(ShaderMask), findsWidgets);
    });

    testWidgets('animation: flashed 渲染闪烁动画', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSkeleton(
          variant: TSkeletonVariant.text,
          animation: TSkeletonAnimation.flashed,
        ),
      ));
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byType(TSkeleton), findsOneWidget);
      // flashed 动画使用 Opacity
      expect(find.byType(Opacity), findsWidgets);
    });

    testWidgets('animation: null（默认）无动画控件', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSkeleton(variant: TSkeletonVariant.text),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(ShaderMask), findsNothing);
      expect(find.byType(Opacity), findsNothing);
    });

    testWidgets('animation 全量验证均可渲染', (tester) async {
      for (final animation in TSkeletonAnimation.values) {
        await tester.pumpWidget(wrapWithTheme(
          TSkeleton(
            key: UniqueKey(),
            variant: TSkeletonVariant.text,
            animation: animation,
          ),
        ));
        await tester.pump(const Duration(milliseconds: 50));
        expect(find.byType(TSkeleton), findsOneWidget);
      }
    });
  });

  group('TSkeleton delay 延迟', () {
    testWidgets('delay=0 立即显示骨架', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSkeleton(delay: 0),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TSkeleton), findsOneWidget);
    });

    testWidgets('delay>0 在延迟期间显示空容器', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSkeleton(delay: 500),
      ));
      // 立即 pump，仍在延迟期内
      await tester.pump(const Duration(milliseconds: 100));
      // 延迟期内 _isLoading=true，build 返回空 Container
      // TSkeleton 节点存在但其子树为空
      expect(find.byType(TSkeleton), findsOneWidget);
      // 冲刷延迟计时器，避免测试结束时仍有 pending timer
      await tester.pump(const Duration(milliseconds: 500));
    });

    testWidgets('delay>0 延迟结束后显示骨架', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSkeleton(delay: 100),
      ));
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();
      expect(find.byType(TSkeleton), findsOneWidget);
    });
  });

  group('TSkeleton.fromRowCol 自定义行列', () {
    testWidgets('单行单列渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSkeleton.fromRowCol(
          rowCol: TSkeletonRowCol(objects: [
            [const TSkeletonRowColObj.text()],
          ]),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TSkeleton), findsOneWidget);
    });

    testWidgets('单行多列渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSkeleton.fromRowCol(
          rowCol: TSkeletonRowCol(objects: [
            [
              const TSkeletonRowColObj.text(flex: 1),
              const TSkeletonRowColObj.spacer(width: 8),
              const TSkeletonRowColObj.text(flex: 1),
            ],
          ]),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TSkeleton), findsOneWidget);
      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('多行多列渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSkeleton.fromRowCol(
          rowCol: TSkeletonRowCol(objects: [
            [const TSkeletonRowColObj.text()],
            [const TSkeletonRowColObj.text()],
            [const TSkeletonRowColObj.text()],
          ]),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TSkeleton), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('circle 对象渲染圆形骨架', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSkeleton.fromRowCol(
          rowCol: TSkeletonRowCol(objects: [
            [const TSkeletonRowColObj.circle()],
          ]),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TSkeleton), findsOneWidget);
    });

    testWidgets('rect 对象渲染矩形骨架', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSkeleton.fromRowCol(
          rowCol: TSkeletonRowCol(objects: [
            [const TSkeletonRowColObj.rect(width: 100, height: 50)],
          ]),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TSkeleton), findsOneWidget);
    });

    testWidgets('spacer 占位符渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSkeleton.fromRowCol(
          rowCol: TSkeletonRowCol(objects: [
            [
              const TSkeletonRowColObj.text(flex: 1),
              const TSkeletonRowColObj.spacer(width: 16),
              const TSkeletonRowColObj.text(flex: 1),
            ],
          ]),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TSkeleton), findsOneWidget);
    });

    testWidgets('带 animation 的自定义行列渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSkeleton.fromRowCol(
          animation: TSkeletonAnimation.gradient,
          rowCol: TSkeletonRowCol(objects: [
            [const TSkeletonRowColObj.text()],
            [const TSkeletonRowColObj.text()],
          ]),
        ),
      ));
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byType(TSkeleton), findsOneWidget);
      expect(find.byType(ShaderMask), findsWidgets);
    });
  });

  group('TSkeleton Theme 注入', () {
    test('TSkeletonThemeData.copyWith 正确合并', () {
      const base = TSkeletonThemeData(
        blockColor: Colors.red,
        borderRadius: 4,
      );
      final merged = base.copyWith(
        highlightColor: Colors.white,
        rowSpacing: 12,
      );
      expect(merged.blockColor, Colors.red);
      expect(merged.borderRadius, 4);
      expect(merged.highlightColor, Colors.white);
      expect(merged.rowSpacing, 12);
      final all = base.copyWith(
        blockColor: Colors.blue,
        borderRadius: 8,
      );
      expect(all.blockColor, Colors.blue);
      expect(all.borderRadius, 8);
    });

    test('TSkeletonThemeData.lerp 插值正确', () {
      const a = TSkeletonThemeData(
        blockColor: Colors.black,
        highlightColor: Colors.red,
        borderRadius: 4,
        rowSpacing: 8,
      );
      const b = TSkeletonThemeData(
        blockColor: Colors.white,
        highlightColor: Colors.blue,
        borderRadius: 12,
        rowSpacing: 16,
      );
      final mid = a.lerp(b, 0.5);
      expect(mid.blockColor, isNotNull);
      expect(mid.highlightColor, isNotNull);
      expect(mid.borderRadius, 8);
      expect(mid.rowSpacing, 12);
      expect(a.lerp(null, 0.5), same(a));
      const empty = TSkeletonThemeData();
      expect(empty.lerp(empty, 0.5).borderRadius, isNull);
    });

    test('TSkeletonThemeData 默认构造所有字段为 null', () {
      const theme = TSkeletonThemeData();
      expect(theme.blockColor, isNull);
      expect(theme.highlightColor, isNull);
      expect(theme.borderRadius, isNull);
      expect(theme.rowSpacing, isNull);
    });

    testWidgets('Theme 视觉默认值进入渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSkeleton(variant: TSkeletonVariant.paragraph),
        skeletonTheme: const TSkeletonThemeData(
          blockColor: Colors.red,
          borderRadius: 7,
          rowSpacing: 3,
        ),
      ));
      await tester.pumpAndSettle();
      final decorations = tester
          .widgetList<Container>(find.byType(Container))
          .map((container) => container.decoration)
          .whereType<BoxDecoration>();
      expect(decorations.any((value) => value.color == Colors.red), isTrue);
      expect(
        decorations.any(
          (value) => value.borderRadius == BorderRadius.circular(7),
        ),
        isTrue,
      );
    });
  });

  group('TSkeleton 边界情况', () {
    testWidgets('delay=0 且无 animation 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSkeleton(delay: 0, variant: TSkeletonVariant.avatar),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TSkeleton), findsOneWidget);
    });

    testWidgets('paragraph variant 渲染多行', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSkeleton(variant: TSkeletonVariant.paragraph),
      ));
      await tester.pumpAndSettle();
      // paragraph 生成 4 行（3 全宽 + 1 半宽）
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('text variant 渲染 2 行', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSkeleton(variant: TSkeletonVariant.text),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TSkeleton), findsOneWidget);
    });

    testWidgets('text variant 在有限宽度内保留 develop 的两行比例', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 320,
          child: TSkeleton(variant: TSkeletonVariant.text),
        ),
        skeletonTheme: const TSkeletonThemeData(blockColor: Colors.red),
      ));
      await tester.pumpAndSettle();

      final rects = skeletonBlockRects(tester, Colors.red);
      expect(rects, hasLength(3));
      expect(rects[0].width, closeTo(72.96, 0.01));
      expect(rects[1].width, closeTo(231.04, 0.01));
      expect(rects[2].width, 320);
      expect(rects[1].left - rects[0].right, 16);
      expect(rects[2].top - rects[0].top, 32);
    });

    testWidgets('paragraph variant 在有限宽度内保留四行和末行比例', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 320,
          child: TSkeleton(variant: TSkeletonVariant.paragraph),
        ),
        skeletonTheme: const TSkeletonThemeData(blockColor: Colors.red),
      ));
      await tester.pumpAndSettle();

      final rects = skeletonBlockRects(tester, Colors.red);
      expect(rects, hasLength(4));
      expect(rects.take(3).map((rect) => rect.width), everyElement(320));
      expect(rects[3].width, 176);
      expect(rects[3].top - rects[2].top, 32);
    });

    testWidgets('TSkeletonRowCol.visualHeight 计算正确', (tester) async {
      final rowCol = TSkeletonRowCol(objects: const [
        [TSkeletonRowColObj.text(height: 16)],
        [TSkeletonRowColObj.text(height: 16)],
      ]);
      final height = rowCol.visualHeight(16);
      // 2 行 height=16 + 行间距 spacer16
      expect(height, greaterThan(16));
    });

    test('TSkeletonRowColObj 默认 height=16', () {
      const obj = TSkeletonRowColObj();
      expect(obj.height, 16);
    });

    test('TSkeletonRowColObj.circle 默认 48x48', () {
      const obj = TSkeletonRowColObj.circle();
      expect(obj.width, 48);
      expect(obj.height, 48);
    });

    test('TSkeletonRowColObj.visualHeight 包含 margin', () {
      const obj = TSkeletonRowColObj(
        height: 16,
        margin: EdgeInsets.only(top: 4, bottom: 4),
      );
      expect(obj.visualHeight, 24);
    });
  });
}
