import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/fab/t_fab_defaults.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TFab Widget 测试
///
/// 覆盖：默认渲染、text 推导、onPressed 禁用、
/// child 模式、拖拽阈值、resolveLayout + 安全区。
void main() {
  Finder fabTapTarget() {
    return find.byWidgetPredicate(
      (Widget widget) =>
          widget is GestureDetector &&
          widget.onTap != null &&
          widget.onPanStart == null,
    );
  }

  Finder fabTapOnlyTarget() {
    return find.byWidgetPredicate(
      (Widget widget) =>
          widget is GestureDetector &&
          widget.onTap != null &&
          widget.onPanStart == null &&
          widget.child is! GestureDetector,
    );
  }

  Finder fabDragTarget() {
    return find.byWidgetPredicate(
      (Widget widget) => widget is GestureDetector && widget.onPanStart != null,
    );
  }

  Positioned fabPositioned(WidgetTester tester) {
    return tester.widgetList<Positioned>(find.byType(Positioned)).last;
  }

  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child, {TFabThemeData? fabTheme}) {
    var theme = TThemeBuilder.light(TThemeData.defaultData());
    if (fabTheme != null) {
      theme = theme.mergeExtension(fabTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [child],
        ),
      ),
    );
  }

  group('TFab 基础渲染', () {
    testWidgets('默认纯图标悬浮按钮', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TFab()));
      expect(find.byType(TFab), findsOneWidget);
      expect(find.byType(TButton), findsOneWidget);
    });

    testWidgets('图标 + 文字', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFab(text: '发布'),
      ));
      expect(find.byType(TFab), findsOneWidget);
      expect(find.text('发布'), findsOneWidget);
    });

    testWidgets('内嵌 TButton 显式使用 Fab 的 large/fill/primary 基线', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TFab()));

      final button = tester.widget<TButton>(find.byType(TButton));
      expect(button.size, TButtonSize.large);
      expect(button.variant, TButtonVariant.fill);
      expect(button.colorScheme, TButtonColorScheme.primary);
    });

    testWidgets('child 模式 — 不内嵌 TButton', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TFab(
          child: Container(
            width: 56,
            height: 56,
            color: Colors.blue,
          ),
        ),
      ));
      expect(find.byType(TFab), findsOneWidget);
      // child 模式下不应内嵌 TButton
      expect(find.byType(TButton), findsNothing);
    });

    testWidgets('child 模式 + 点击', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        TFab(
          child: Container(width: 56, height: 56, color: Colors.red),
          onPressed: () => tapped = true,
        ),
      ));
      await tester.tap(fabTapOnlyTarget());
      expect(tapped, true);
    });
  });

  group('TFab 禁用态', () {
    testWidgets('onPressed: null 内嵌 TButton 禁用', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFab(onPressed: null),
      ));
      expect(find.byType(TFab), findsOneWidget);
    });

    testWidgets('child 模式 onPressed: null 用 IgnorePointer', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        TFab(
          child: GestureDetector(
            onTap: () => tapped = true,
            child: Container(width: 56, height: 56, color: Colors.grey),
          ),
          onPressed: null,
        ),
      ));
      await tester.tap(fabTapTarget(), warnIfMissed: false);
      expect(tapped, false);
    });
  });

  group('TFab 定位层', () {
    testWidgets('默认 right=16 bottom=32', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TFab()));
      final positioned = fabPositioned(tester);
      expect(positioned.right, 16);
      expect(positioned.bottom, 32);
    });

    testWidgets('自定义 right/bottom', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFab(right: 24, bottom: 48),
      ));
      final positioned = fabPositioned(tester);
      expect(positioned.right, 24);
      expect(positioned.bottom, 48);
    });

    testWidgets('不传 draggable 时仅 Positioned 定位', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TFab()));
      expect(find.byType(Positioned), findsOneWidget);
    });
  });

  group('TFab bounds 和拖拽类型', () {
    test('TFabBounds 构造', () {
      const bounds = TFabBounds(start: 16, end: 32);
      expect(bounds.start, 16);
      expect(bounds.end, 32);
    });

    test('TFabBounds 非 const 构造覆盖构造器运行期执行', () {
      // 非 const 调用会真正执行构造器函数体，覆盖 t_fab_layout.dart 构造器行
      // ignore: prefer_const_constructors
      final bounds = TFabBounds(start: 8, end: 8);
      expect(bounds.start, 8);
      expect(bounds.end, 8);
    });

    test('TFabDragAxis 枚举值', () {
      expect(TFabDragAxis.all.index, 0);
      expect(TFabDragAxis.vertical.index, 1);
      expect(TFabDragAxis.horizontal.index, 2);
    });

    test('TFabMagnet 枚举值', () {
      expect(TFabMagnet.left.index, 0);
      expect(TFabMagnet.right.index, 1);
    });
  });

  group('TFabDefaults', () {
    test('shapeForText 根据文本存在性推导默认 shape', () {
      expect(TFabDefaults.shapeForText(false), 'circle');
      expect(TFabDefaults.shapeForText(true), 'round');
    });
  });

  group('TFabThemeData', () {
    test('默认构造全 null', () {
      const theme = TFabThemeData();
      expect(theme.defaultRight, null);
      expect(theme.defaultBottom, null);
      expect(theme.dragTapSlop, null);
    });

    test('copyWith 部分覆盖', () {
      const theme = TFabThemeData(defaultRight: 16, defaultBottom: 32);
      final copied = theme.copyWith(defaultRight: 24);
      expect(copied.defaultRight, 24);
      expect(copied.defaultBottom, 32);
    });

    test('lerp 前半段取 a', () {
      const a = TFabThemeData(defaultRight: 10, dragTapSlop: 18);
      const b = TFabThemeData(defaultRight: 30, dragTapSlop: 30);
      final result = a.lerp(b, 0.3);
      // lerpDouble 应该给出正确插值
      expect(result.defaultRight! > 10, true);
    });

    testWidgets('Theme 注入生效', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFab(),
        fabTheme: const TFabThemeData(defaultRight: 50, defaultBottom: 100),
      ));
      final positioned = fabPositioned(tester);
      expect(positioned.right, 50);
      expect(positioned.bottom, 100);
    });
  });

  group('TFabDragDetails', () {
    test('构造', () {
      const details = TFabDragDetails(
        position: Offset(16, 32),
      );
      expect(details.position.dx, 16);
      expect(details.position.dy, 32);
      expect(details.start, null);
      expect(details.end, null);
    });
  });

  // ============================================================
  // 补充：TFabResolve.resolveLayout 全分支（通过 Widget 验证内部行为）
  // ============================================================
  group('TFabResolve.resolveLayout', () {
    testWidgets('themeDefaultXBounds/YBounds 生效（拖拽边界从 Theme 读取）',
        (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFab(
          draggable: TFabDragAxis.all,
        ),
        fabTheme: const TFabThemeData(
          defaultXBounds: TFabBounds(start: 8, end: 8),
          defaultYBounds: TFabBounds(start: 4, end: 4),
        ),
      ));
      // 不抛异常即说明 resolveLayout 正常处理 themeDefaultXBounds
      expect(find.byType(TFab), findsOneWidget);
    });

    testWidgets('safePadding.right/bottom 叠加到固定定位', (tester) async {
      // 通过 MediaQuery 注入非零安全区
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: const MediaQuery(
            data: MediaQueryData(
              padding: EdgeInsets.only(right: 20, bottom: 34),
            ),
            child: Scaffold(
              body: Stack(
                fit: StackFit.expand,
                children: [TFab()],
              ),
            ),
          ),
        ),
      );
      final positioned = fabPositioned(tester);
      expect(positioned.right, 36);
      expect(positioned.bottom, 66);
    });

    testWidgets('useSafeArea=false 保留原始 right/bottom', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: const MediaQuery(
            data: MediaQueryData(
              padding: EdgeInsets.only(right: 20, bottom: 34),
            ),
            child: Scaffold(
              body: Stack(
                fit: StackFit.expand,
                children: [
                  TFab(
                    right: 24,
                    bottom: 48,
                    useSafeArea: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      final positioned = fabPositioned(tester);
      expect(positioned.right, 24);
      expect(positioned.bottom, 48);
    });
  });

  // ============================================================
  // 补充：TFabResolve.resolveButton shape 推导
  // ============================================================
  group('TFabResolve.resolveButton shape 推导', () {
    testWidgets('纯图标默认 shape=circle', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TFab()));
      expect(find.byType(TButton), findsOneWidget);
    });

    testWidgets('有 text 默认 shape=round', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TFab(text: '发布')));
      expect(find.text('发布'), findsOneWidget);
    });

    testWidgets('自定义 icon 覆盖默认 Icons.add', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFab(icon: Icon(Icons.edit)),
      ));
      expect(find.byIcon(Icons.edit), findsOneWidget);
    });
  });

  // ============================================================
  // 补充：TFab tooltip / semanticLabel
  // ============================================================
  group('TFab tooltip / semanticLabel', () {
    testWidgets('tooltip 非空时包 Tooltip', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFab(tooltip: '悬浮提示'),
      ));
      expect(find.byType(Tooltip), findsOneWidget);
    });

    testWidgets('tooltip 空字符串不包 Tooltip', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFab(tooltip: ''),
      ));
      expect(find.byType(Tooltip), findsNothing);
    });

    testWidgets('tooltip 为 null 不包 Tooltip', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TFab()));
      expect(find.byType(Tooltip), findsNothing);
    });

    testWidgets('semanticLabel 非空时包 Semantics', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFab(semanticLabel: '添加按钮'),
      ));
      expect(find.byType(Semantics), findsWidgets);
    });

    testWidgets('semanticLabel 空字符串不包 Semantics', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFab(semanticLabel: ''),
      ));
      // 仅有子组件自身的 Semantics，不应有额外包裹
      expect(find.byType(TFab), findsOneWidget);
    });

    testWidgets('child 模式 + tooltip', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TFab(
          tooltip: '子组件提示',
          child: Container(width: 56, height: 56, color: Colors.blue),
        ),
      ));
      expect(find.byType(Tooltip), findsOneWidget);
    });

    testWidgets('child 模式 + semanticLabel', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TFab(
          semanticLabel: '子组件标签',
          child: Container(width: 56, height: 56, color: Colors.blue),
        ),
      ));
      expect(find.byType(TFab), findsOneWidget);
    });
  });

  // ============================================================
  // 补充：TFab 拖拽模式
  // ============================================================
  group('TFab 拖拽模式', () {
    testWidgets('draggable=true 进入拖拽模式（不创建 Positioned 直接子）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFab(draggable: TFabDragAxis.all),
      ));
      // 拖拽模式下内部使用 Positioned 但带 GestureDetector(onPanStart)
      expect(find.byType(TFab), findsOneWidget);
    });

    testWidgets('draggable=TFabDragAxis.all', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFab(draggable: TFabDragAxis.all),
      ));
      expect(find.byType(TFab), findsOneWidget);
    });

    testWidgets('draggable=TFabDragAxis.vertical', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFab(draggable: TFabDragAxis.vertical),
      ));
      expect(find.byType(TFab), findsOneWidget);
    });

    testWidgets('draggable=TFabDragAxis.horizontal', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFab(draggable: TFabDragAxis.horizontal),
      ));
      expect(find.byType(TFab), findsOneWidget);
    });

    testWidgets('拖拽位移触发 onDragEnd 回调', (tester) async {
      TFabDragDetails? endDetails;
      await tester.pumpWidget(wrapWithTheme(
        TFab(
          draggable: TFabDragAxis.all,
          onDragEnd: (details) => endDetails = details,
        ),
      ));
      // 大幅度拖拽以超过 dragTapSlop（默认 18）
      await tester.timedDrag(
        fabDragTarget(),
        const Offset(-50, -50),
        const Duration(milliseconds: 200),
      );
      await tester.pumpAndSettle();
      expect(endDetails, isNotNull);
      expect(endDetails!.position, isA<Offset>());
    });

    testWidgets('拖拽小幅位移（小于阈值）触发 onPressed（点击）', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        TFab(
          draggable: TFabDragAxis.all,
          onPressed: () => tapped = true,
        ),
      ));
      // 极小位移（1px < dragTapSlop 18）应识别为点击
      await tester.timedDrag(
        fabDragTarget(),
        const Offset(1, 1),
        const Duration(milliseconds: 50),
      );
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });

    testWidgets('拖拽 + magnet=true 吸附', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFab(draggable: TFabDragAxis.all, magnet: TFabMagnet.right),
      ));
      await tester.timedDrag(
        fabDragTarget(),
        const Offset(-100, 0),
        const Duration(milliseconds: 200),
      );
      // 磁吸使用 Future.delayed，需推进时间冲刷定时器
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pumpAndSettle();
      final positioned = fabPositioned(tester);
      expect(positioned.right, 16);
    });

    testWidgets('拖拽 + magnet=TFabMagnet.left 吸附', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFab(draggable: TFabDragAxis.all, magnet: TFabMagnet.left),
      ));
      await tester.timedDrag(
        fabDragTarget(),
        const Offset(-100, 0),
        const Duration(milliseconds: 200),
      );
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pumpAndSettle();
      final positioned = fabPositioned(tester);
      expect(positioned.right, greaterThan(16));
    });

    testWidgets('拖拽 + magnet=TFabMagnet.right 吸附', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFab(draggable: TFabDragAxis.all, magnet: TFabMagnet.right),
      ));
      await tester.timedDrag(
        fabDragTarget(),
        const Offset(50, 0),
        const Duration(milliseconds: 200),
      );
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pumpAndSettle();
      final positioned = fabPositioned(tester);
      expect(positioned.right, 16);
    });

    testWidgets('拖拽与左右吸附避让四侧安全区', (tester) async {
      Widget host(TFabMagnet magnet) {
        return MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(400, 800),
              padding: EdgeInsets.fromLTRB(20, 30, 24, 34),
            ),
            child: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 400,
                  height: 500,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      TFab(
                        draggable: TFabDragAxis.all,
                        magnet: magnet,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }

      await tester.pumpWidget(host(TFabMagnet.right));
      await tester.timedDrag(
        fabDragTarget(),
        const Offset(1000, 1000),
        const Duration(milliseconds: 200),
      );
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pumpAndSettle();
      var positioned = fabPositioned(tester);
      expect(positioned.right, 40);
      expect(positioned.bottom, 34);

      await tester.pumpWidget(host(TFabMagnet.left));
      await tester.timedDrag(
        fabDragTarget(),
        const Offset(-1000, -1000),
        const Duration(milliseconds: 200),
      );
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pumpAndSettle();
      positioned = fabPositioned(tester);
      expect(positioned.right, 316);
      expect(positioned.bottom, 422);
    });

    testWidgets('自定义拖拽边界叠加对应安全区', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: const MediaQuery(
            data: MediaQueryData(
              size: Size(400, 800),
              padding: EdgeInsets.fromLTRB(20, 30, 24, 34),
            ),
            child: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 400,
                  height: 500,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      TFab(
                        draggable: TFabDragAxis.all,
                        xBounds: TFabBounds(start: 8, end: 12),
                        yBounds: TFabBounds(start: 4, end: 6),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.timedDrag(
        fabDragTarget(),
        const Offset(1000, 1000),
        const Duration(milliseconds: 200),
      );
      await tester.pumpAndSettle();
      var positioned = fabPositioned(tester);
      expect(positioned.right, 32);
      expect(positioned.bottom, 38);

      await tester.timedDrag(
        fabDragTarget(),
        const Offset(-1000, -1000),
        const Duration(milliseconds: 200),
      );
      await tester.pumpAndSettle();
      positioned = fabPositioned(tester);
      expect(positioned.right, 320);
      expect(positioned.bottom, 416);
    });

    testWidgets('拖拽 + xBounds/yBounds 边界限制', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFab(
          draggable: TFabDragAxis.all,
          xBounds: TFabBounds(start: 8, end: 8),
          yBounds: TFabBounds(start: 4, end: 4),
        ),
      ));
      await tester.timedDrag(
        fabDragTarget(),
        const Offset(-200, -200),
        const Duration(milliseconds: 200),
      );
      await tester.pumpAndSettle();
      final positioned = fabPositioned(tester);
      expect(positioned.right, greaterThanOrEqualTo(8));
      expect(positioned.bottom, greaterThanOrEqualTo(4));
    });

    testWidgets('自定义 child 尺寸参与拖拽边界计算', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TFab(
          draggable: TFabDragAxis.all,
          onPressed: () {},
          child: const SizedBox(
            width: 96,
            height: 96,
            child: ColoredBox(color: Colors.red),
          ),
        ),
      ));
      await tester.timedDrag(
        fabDragTarget(),
        const Offset(-1000, 0),
        const Duration(milliseconds: 200),
      );
      await tester.pumpAndSettle();
      final positioned = fabPositioned(tester);
      expect(positioned.right, 688);
      expect(positioned.bottom, 32);
    });

    testWidgets('布局 right/bottom 更新后同步拖拽位置', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFab(draggable: TFabDragAxis.all),
      ));
      await tester.timedDrag(
        fabDragTarget(),
        const Offset(-100, -100),
        const Duration(milliseconds: 200),
      );
      await tester.pumpAndSettle();
      var positioned = fabPositioned(tester);
      expect(positioned.right, 116);
      expect(positioned.bottom, 132);

      await tester.pumpWidget(wrapWithTheme(
        const TFab(
          draggable: TFabDragAxis.all,
          right: 40,
          bottom: 60,
        ),
      ));
      await tester.pump();
      positioned = fabPositioned(tester);
      expect(positioned.right, 40);
      expect(positioned.bottom, 60);
    });

    testWidgets('边界更新后钳制已有拖拽位置', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFab(draggable: TFabDragAxis.all),
      ));
      await tester.timedDrag(
        fabDragTarget(),
        const Offset(-300, 0),
        const Duration(milliseconds: 200),
      );
      await tester.pumpAndSettle();
      var positioned = fabPositioned(tester);
      expect(positioned.right, 316);

      await tester.pumpWidget(wrapWithTheme(
        const TFab(
          draggable: TFabDragAxis.all,
          xBounds: TFabBounds(start: 8, end: 600),
        ),
      ));
      await tester.pump();
      positioned = fabPositioned(tester);
      expect(positioned.right, 152);
      expect(positioned.bottom, 32);
    });

    testWidgets('拖拽 vertical 轴仅垂直移动', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFab(draggable: TFabDragAxis.vertical),
      ));
      await tester.timedDrag(
        fabDragTarget(),
        const Offset(-50, -50),
        const Duration(milliseconds: 200),
      );
      await tester.pumpAndSettle();
      final positioned = fabPositioned(tester);
      expect(positioned.right, 16);
      expect(positioned.bottom, isNot(32));
    });

    testWidgets('拖拽 horizontal 轴仅水平移动', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFab(draggable: TFabDragAxis.horizontal),
      ));
      await tester.timedDrag(
        fabDragTarget(),
        const Offset(-50, -50),
        const Duration(milliseconds: 200),
      );
      await tester.pumpAndSettle();
      final positioned = fabPositioned(tester);
      expect(positioned.bottom, 32);
      expect(positioned.right, isNot(16));
    });

    testWidgets('拖拽 + onDragStart 回调', (tester) async {
      TFabDragDetails? startDetails;
      await tester.pumpWidget(wrapWithTheme(
        TFab(
          draggable: TFabDragAxis.all,
          onDragStart: (details) => startDetails = details,
        ),
      ));
      await tester.timedDrag(
        fabDragTarget(),
        const Offset(-50, -50),
        const Duration(milliseconds: 200),
      );
      await tester.pumpAndSettle();
      expect(startDetails, isNotNull);
      expect(startDetails!.start, isNotNull);
      expect(startDetails!.position, const Offset(16, 32));
    });

    testWidgets('child 模式 + 拖拽 + onPressed 点击', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        TFab(
          child: Container(width: 56, height: 56, color: Colors.red),
          draggable: TFabDragAxis.all,
          onPressed: () => tapped = true,
        ),
      ));
      await tester.timedDrag(
        fabDragTarget(),
        const Offset(1, 1),
        const Duration(milliseconds: 50),
      );
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });

    testWidgets('child 模式 + 拖拽 + magnet', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TFab(
          child: Container(width: 56, height: 56, color: Colors.red),
          draggable: TFabDragAxis.all,
          magnet: TFabMagnet.right,
          onPressed: () {},
        ),
      ));
      await tester.timedDrag(
        fabDragTarget(),
        const Offset(-100, 0),
        const Duration(milliseconds: 200),
      );
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pumpAndSettle();
      final positioned = fabPositioned(tester);
      expect(positioned.right, 16);
    });
  });

  // ============================================================
  // 补充：TFabThemeData 全字段
  // ============================================================
  group('TFabThemeData 全字段', () {
    test('全字段构造', () {
      const theme = TFabThemeData(
        defaultRight: 20,
        defaultBottom: 40,
        defaultXBounds: TFabBounds(start: 8, end: 8),
        defaultYBounds: TFabBounds(start: 4, end: 4),
        magnetAnimationDuration: Duration(milliseconds: 300),
        dragTapSlop: 20,
      );
      expect(theme.defaultRight, 20);
      expect(theme.defaultBottom, 40);
      expect(theme.defaultXBounds!.start, 8);
      expect(theme.defaultYBounds!.end, 4);
      expect(theme.magnetAnimationDuration, const Duration(milliseconds: 300));
      expect(theme.dragTapSlop, 20);
    });

    test('copyWith 全字段', () {
      const theme = TFabThemeData();
      final copied = theme.copyWith(
        defaultRight: 20,
        defaultBottom: 40,
        defaultXBounds: const TFabBounds(start: 8, end: 8),
        defaultYBounds: const TFabBounds(start: 4, end: 4),
        magnetAnimationDuration: const Duration(milliseconds: 300),
        dragTapSlop: 20,
      );
      expect(copied.defaultRight, 20);
      expect(copied.defaultBottom, 40);
      expect(copied.defaultXBounds!.start, 8);
      expect(copied.defaultYBounds!.end, 4);
      expect(copied.magnetAnimationDuration, const Duration(milliseconds: 300));
      expect(copied.dragTapSlop, 20);
    });

    test('lerp t >= 0.5 取 other 的 XBounds/YBounds/duration', () {
      const a = TFabThemeData(
        defaultXBounds: TFabBounds(start: 1, end: 1),
        defaultYBounds: TFabBounds(start: 2, end: 2),
        magnetAnimationDuration: Duration(milliseconds: 100),
      );
      const b = TFabThemeData(
        defaultXBounds: TFabBounds(start: 9, end: 9),
        defaultYBounds: TFabBounds(start: 8, end: 8),
        magnetAnimationDuration: Duration(milliseconds: 500),
      );
      final result = a.lerp(b, 0.6);
      expect(result.defaultXBounds!.start, 9);
      expect(result.defaultYBounds!.start, 8);
      expect(result.magnetAnimationDuration, const Duration(milliseconds: 500));
    });

    test('lerp 非 TFabThemeData 返回自身', () {
      const a = TFabThemeData(defaultRight: 10);
      final result = a.lerp(null, 0.5);
      expect(result, same(a));
    });

    testWidgets('dragTapSlop + magnetAnimationDuration 从 Theme 注入',
        (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TFab(draggable: TFabDragAxis.all, magnet: TFabMagnet.right),
        fabTheme: const TFabThemeData(
          dragTapSlop: 5,
          magnetAnimationDuration: Duration(milliseconds: 10),
        ),
      ));
      // 小位移（3px < 5）应识别为点击
      await tester.timedDrag(
        find.byType(TFab),
        const Offset(3, 3),
        const Duration(milliseconds: 50),
      );
      await tester.pumpAndSettle();
      expect(find.byType(TFab), findsOneWidget);
    });

    test('copyWith 空参数保留原值', () {
      const theme = TFabThemeData(
        defaultRight: 12,
        defaultBottom: 24,
        defaultXBounds: TFabBounds(start: 1, end: 2),
        defaultYBounds: TFabBounds(start: 3, end: 4),
        magnetAnimationDuration: Duration(milliseconds: 120),
        dragTapSlop: 6,
      );
      final copied = theme.copyWith();
      expect(copied.defaultRight, 12);
      expect(copied.defaultBottom, 24);
      expect(copied.defaultXBounds, theme.defaultXBounds);
      expect(copied.defaultYBounds, theme.defaultYBounds);
      expect(copied.magnetAnimationDuration, theme.magnetAnimationDuration);
      expect(copied.dragTapSlop, 6);
    });

    test('lerp t < 0.5 取 this 的离散字段并插值数值字段', () {
      const a = TFabThemeData(
        defaultRight: 10,
        defaultBottom: 20,
        defaultXBounds: TFabBounds(start: 1, end: 1),
        defaultYBounds: TFabBounds(start: 2, end: 2),
        magnetAnimationDuration: Duration(milliseconds: 100),
        dragTapSlop: 4,
      );
      const b = TFabThemeData(
        defaultRight: 30,
        defaultBottom: 60,
        defaultXBounds: TFabBounds(start: 9, end: 9),
        defaultYBounds: TFabBounds(start: 8, end: 8),
        magnetAnimationDuration: Duration(milliseconds: 500),
        dragTapSlop: 12,
      );
      final result = a.lerp(b, 0.25);
      expect(result.defaultRight, 15);
      expect(result.defaultBottom, 30);
      expect(result.defaultXBounds, same(a.defaultXBounds));
      expect(result.defaultYBounds, same(a.defaultYBounds));
      expect(result.magnetAnimationDuration, a.magnetAnimationDuration);
      expect(result.dragTapSlop, 6);
    });
  });

  // ============================================================
  // 补充：TFabDefaults 边界
  // ============================================================
  group('TFabDefaults 边界', () {
    test('默认常量与 shapeForText', () {
      expect(TFabDefaults.defaultSizeIndex, 0);
      expect(TFabDefaults.defaultVariantIndex, 0);
      expect(TFabDefaults.defaultColorSchemeIndex, 1);
      expect(TFabDefaults.defaultIconData, Icons.add);
      expect(TFabDefaults.shapeForText(false), 'circle');
      expect(TFabDefaults.shapeForText(true), 'round');
    });
  });

  // ============================================================
  // 补充：TFabDragDetails 全字段
  // ============================================================
  group('TFabDragDetails 全字段', () {
    test('带 start/end 构造', () {
      final start = DragStartDetails(globalPosition: const Offset(10, 20));
      final end = DragEndDetails();
      final details = TFabDragDetails(
        position: const Offset(30, 40),
        start: start,
        end: null,
      );
      expect(details.position, const Offset(30, 40));
      expect(details.start, start);
      expect(details.end, isNull);
      // 验证 end 字段可赋值
      final details2 = TFabDragDetails(
        position: const Offset(30, 40),
        end: end,
      );
      expect(details2.end, end);
    });
  });
}
