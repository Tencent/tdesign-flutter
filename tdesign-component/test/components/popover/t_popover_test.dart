import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TPopover 组件 Widget 测试
///
/// 覆盖 TPopoverColorScheme、TPopoverPlacement、内容渲染、箭头、回调等。
void main() {
  /// 构建带主题的测试壳
  Widget wrapWithTheme(Widget child, {TPopoverThemeData? popoverTheme}) {
    var theme = TThemeBuilder.light(TThemeData.defaultData());
    if (popoverTheme != null) {
      theme = theme.mergeExtension(popoverTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: child),
    );
  }

  Finder arrowContainerFinder() => find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).border != null,
      );

  // ============================================================
  // 枚举验证
  // ============================================================
  group('枚举', () {
    test('TPopoverColorScheme 有六个值', () {
      expect(TPopoverColorScheme.values.length, 6);
      expect(TPopoverColorScheme.values, contains(TPopoverColorScheme.dark));
      expect(TPopoverColorScheme.values, contains(TPopoverColorScheme.light));
      expect(TPopoverColorScheme.values, contains(TPopoverColorScheme.info));
      expect(TPopoverColorScheme.values, contains(TPopoverColorScheme.success));
      expect(TPopoverColorScheme.values, contains(TPopoverColorScheme.warning));
      expect(TPopoverColorScheme.values, contains(TPopoverColorScheme.error));
    });

    test('TPopoverPlacement 有十二个值', () {
      expect(TPopoverPlacement.values.length, 12);
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.top));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.bottom));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.left));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.right));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.topLeft));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.topRight));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.bottomLeft));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.bottomRight));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.leftTop));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.leftBottom));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.rightTop));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.rightBottom));
    });
  });

  // ============================================================
  // TPopoverWidget 基础渲染
  // ============================================================
  group('TPopoverWidget 基础渲染', () {
    testWidgets('渲染文本内容', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          return Center(
            child: TPopoverWidget(
              context: context,
              content: '气泡内容',
            ),
          );
        }),
      ));
      await tester.pump();

      expect(find.byType(TPopoverWidget), findsOneWidget);
      expect(find.text('气泡内容'), findsOneWidget);
    });

    testWidgets('默认文本样式和背景色来自 token', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          return Center(
            child: TPopoverWidget(
              context: context,
              content: '默认气泡',
            ),
          );
        }),
      ));
      await tester.pump();

      final text = tester.widget<Text>(find.text('默认气泡'));
      expect(text.style?.color, token.textColorAnti);
      expect(text.style?.fontSize, token.fontBodyLarge?.size);
      expect(text.style?.height, token.fontBodyLarge?.height);

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(TPopoverWidget),
              matching: find.byWidgetPredicate(
                (widget) =>
                    widget is Container && widget.decoration is BoxDecoration,
              ),
            )
            .first,
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, token.grayColor14);
    });

    testWidgets('长文本默认限制在测量宽度内并允许换行', (tester) async {
      const longContent = '这是一段非常非常非常非常非常非常非常长的气泡内容，用于验证默认宽度不会横向无限延伸';
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          return Center(
            child: TPopoverWidget(
              context: context,
              content: longContent,
            ),
          );
        }),
      ));
      await tester.pump();

      final containerFinder = find
          .descendant(
            of: find.byType(TPopoverWidget),
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is Container && widget.decoration is BoxDecoration,
            ),
          )
          .first;
      final container = tester.widget<Container>(containerFinder);
      final text = tester.widget<Text>(find.text(longContent));
      expect(container.constraints?.maxWidth, lessThanOrEqualTo(300));
      expect(tester.getSize(containerFinder).width, lessThanOrEqualTo(300));
      expect(text.maxLines, isNull);
      expect(text.overflow, isNull);
      expect(tester.takeException(), isNull);
    });

    testWidgets('contentWidget 自定义内容渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          return Center(
            child: TPopoverWidget(
              context: context,
              contentWidget: const Text('自定义Widget'),
              width: 100,
              height: 50,
            ),
          );
        }),
      ));
      await tester.pump();

      expect(find.text('自定义Widget'), findsOneWidget);
    });

    testWidgets('contentWidget 未指定 width/height 抛出断言', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: Builder(builder: (context) {
          return TPopoverWidget(
            context: context,
            contentWidget: const Text('无尺寸'),
          );
        }),
      ));

      expect(tester.takeException(), isA<FlutterError>());
    });
  });

  // ============================================================
  // colorScheme 颜色方案
  // ============================================================
  group('TPopoverWidget colorScheme', () {
    for (final scheme in TPopoverColorScheme.values) {
      testWidgets('colorScheme: $scheme 渲染正常', (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          Builder(builder: (context) {
            return Center(
              child: TPopoverWidget(
                context: context,
                content: '${scheme.name}气泡',
                colorScheme: scheme,
              ),
            );
          }),
        ));
        await tester.pump();

        expect(find.text('${scheme.name}气泡'), findsOneWidget);
      });
    }
  });

  // ============================================================
  // placement 定位方向
  // ============================================================
  group('TPopoverWidget placement', () {
    for (final placement in TPopoverPlacement.values) {
      testWidgets('placement: $placement 渲染正常', (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          Builder(builder: (context) {
            return Center(
              child: TPopoverWidget(
                context: context,
                content: '${placement.name}定位',
                placement: placement,
              ),
            );
          }),
        ));
        await tester.pump();

        expect(find.text('${placement.name}定位'), findsOneWidget);
      });
    }
  });

  // ============================================================
  // showArrow 箭头
  // ============================================================
  group('TPopoverWidget 箭头', () {
    testWidgets('showArrow: true 渲染箭头', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          return Center(
            child: TPopoverWidget(
              context: context,
              content: '有箭头',
              placement: TPopoverPlacement.bottom,
              showArrow: true,
            ),
          );
        }),
      ));
      await tester.pump();

      // 箭头使用 Container + BoxDecoration(border:)
      expect(find.text('有箭头'), findsOneWidget);
    });

    testWidgets('showArrow: false 不渲染箭头', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          return Center(
            child: TPopoverWidget(
              context: context,
              content: '无箭头',
              showArrow: false,
            ),
          );
        }),
      ));
      await tester.pump();

      expect(find.text('无箭头'), findsOneWidget);
    });

    testWidgets('自定义 arrowSize', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          return Center(
            child: TPopoverWidget(
              context: context,
              content: '大箭头',
              arrowSize: 16,
              placement: TPopoverPlacement.top,
            ),
          );
        }),
      ));
      await tester.pump();
      expect(find.text('大箭头'), findsOneWidget);
    });
  });

  // ============================================================
  // padding / width / height / radius
  // ============================================================
  group('TPopoverWidget 尺寸', () {
    testWidgets('自定义 padding 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          return Center(
            child: TPopoverWidget(
              context: context,
              content: '内边距',
              padding: const EdgeInsets.all(20),
            ),
          );
        }),
      ));
      await tester.pump();
      expect(find.text('内边距'), findsOneWidget);
    });

    testWidgets('自定义 width 和 height', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          return Center(
            child: TPopoverWidget(
              context: context,
              content: '固定尺寸',
              width: 200,
              height: 80,
            ),
          );
        }),
      ));
      await tester.pump();
      expect(find.text('固定尺寸'), findsOneWidget);
    });

    testWidgets('自定义 radius 圆角', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          return Center(
            child: TPopoverWidget(
              context: context,
              content: '圆角',
              radius: BorderRadius.circular(20),
            ),
          );
        }),
      ));
      await tester.pump();
      expect(find.text('圆角'), findsOneWidget);
    });

    testWidgets('theme applies padding, radius and arrow size', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          return Center(
            child: TPopoverWidget(
              context: context,
              content: '主题气泡',
            ),
          );
        }),
        popoverTheme: const TPopoverThemeData(
          padding: EdgeInsets.all(10),
          borderRadius: 20,
          arrowSize: 16,
        ),
      ));
      await tester.pump();

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(TPopoverWidget),
              matching: find.byWidgetPredicate(
                (widget) =>
                    widget is Container && widget.decoration is BoxDecoration,
              ),
            )
            .first,
      );
      final decoration = container.decoration! as BoxDecoration;
      final arrow = tester.widget<Container>(arrowContainerFinder());

      expect(decoration.borderRadius, BorderRadius.circular(20));
      expect(container.padding, const EdgeInsets.all(10));
      expect(
        ((arrow.decoration! as BoxDecoration).border as Border?)?.bottom.width,
        16,
      );
    });
  });

  testWidgets('showPopover uses theme barrierColor', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: TThemeBuilder.light(TThemeData.defaultData()).mergeExtension(
        const TPopoverThemeData(barrierColor: Colors.black54),
      ),
      home: Builder(builder: (context) {
        return Scaffold(
          body: Center(
            child: TextButton(
              onPressed: () {
                TPopover.showPopover(
                  context: context,
                  content: '气泡',
                  placement: TPopoverPlacement.bottom,
                );
              },
              child: const Text('open'),
            ),
          ),
        );
      }),
    ));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final barrier =
        tester.widgetList<ModalBarrier>(find.byType(ModalBarrier)).last;
    expect(barrier.color, Colors.black54);
  });

  // ============================================================
  // showPopover 静态方法
  // ============================================================
  group('TPopover.showPopover', () {
    testWidgets('showPopover 弹出气泡', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          ctx = context;
          return const SizedBox();
        }),
      ));

      unawaited(TPopover.showPopover(
        context: ctx,
        content: '弹出气泡',
        placement: TPopoverPlacement.bottom,
      ));
      await tester.pumpAndSettle();

      expect(find.text('弹出气泡'), findsOneWidget);
    });

    testWidgets('showPopover 带 colorScheme', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          ctx = context;
          return const SizedBox();
        }),
      ));

      unawaited(TPopover.showPopover(
        context: ctx,
        content: '成功气泡',
        colorScheme: TPopoverColorScheme.success,
      ));
      await tester.pumpAndSettle();

      expect(find.text('成功气泡'), findsOneWidget);
    });

    testWidgets('closeOnClickOutside: true 点击外部关闭', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          ctx = context;
          return const SizedBox();
        }),
      ));

      unawaited(TPopover.showPopover(
        context: ctx,
        content: '可关闭',
        closeOnClickOutside: true,
      ));
      await tester.pumpAndSettle();

      expect(find.text('可关闭'), findsOneWidget);

      // 点击外部关闭
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(find.text('可关闭'), findsNothing);
    });
  });

  // ============================================================
  // 主题覆盖
  // ============================================================
  group('TPopover 主题覆盖', () {
    testWidgets('TPopoverThemeData 注入后正常渲染', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(wrapWithTheme(
        Builder(builder: (context) {
          ctx = context;
          return const SizedBox();
        }),
        popoverTheme: const TPopoverThemeData(
          colorScheme: TPopoverColorScheme.dark,
          backgroundColor: Colors.black,
          borderRadius: 8,
          arrowSize: 10,
          minWidth: 50,
          maxHeight: 200,
          boxShadow: [
            BoxShadow(color: Colors.purple, blurRadius: 4),
          ],
        ),
      ));

      unawaited(TPopover.showPopover(
        context: ctx,
        content: '主题气泡',
      ));
      await tester.pumpAndSettle();

      expect(find.text('主题气泡'), findsOneWidget);
      final themedContainer = tester
          .widgetList<Container>(find.byType(Container))
          .firstWhere((container) {
        final decoration = container.decoration;
        return decoration is BoxDecoration &&
            decoration.boxShadow?.first.color == Colors.purple;
      });
      expect(
        (themedContainer.decoration! as BoxDecoration).boxShadow?.first.color,
        Colors.purple,
      );
    });

    test('TPopoverThemeData merge 合并', () {
      const base = TPopoverThemeData(
        backgroundColor: Colors.white,
        borderRadius: 4,
        boxShadow: [BoxShadow(color: Colors.black)],
      );
      const override = TPopoverThemeData(borderRadius: 8);
      final merged = base.merge(override);
      expect(merged.backgroundColor, Colors.white);
      expect(merged.borderRadius, 8);
      expect(merged.boxShadow, base.boxShadow);
    });

    test('TPopoverThemeData copyWith', () {
      const original = TPopoverThemeData(backgroundColor: Colors.white);
      final copied = original.copyWith(
        backgroundColor: Colors.grey,
        boxShadow: const [BoxShadow(color: Colors.red)],
      );
      expect(copied.backgroundColor, Colors.grey);
      expect(copied.boxShadow?.first.color, Colors.red);
      expect(
        original
            .lerp(
              const TPopoverThemeData(
                boxShadow: [BoxShadow(color: Colors.blue)],
              ),
              0.75,
            )
            .boxShadow
            ?.first
            .color,
        Colors.blue,
      );
    });
  });
}
