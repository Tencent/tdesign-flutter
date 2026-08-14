// Theme 档2 Widget 验收测试
//
// 验证 Theme 接入是否正确（对应 component-acceptance-standard.md 四章 档2）：
//   1. Token 真读取：修改 TThemeData 主色后，组件确实使用该色
//   2. 优先级覆盖：P0 实例 > P1 组件 Theme > P2 Material > P4 Token
//   3. 子树 mergeExtension：Theme.of(context).mergeExtension 覆盖构造器未传项
//
// 运行：flutter test test/acceptance/theme_acceptance_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 验收辅助：用 TThemeData + 组件 Theme 包裹组件
Widget wrapWithTheme(
  Widget child, {
  TThemeData? tThemeData,
  TButtonThemeData? buttonTheme,
}) {
  var theme = TThemeBuilder.light(tThemeData ?? TThemeData.defaultData());
  if (buttonTheme != null) {
    theme = theme.mergeExtension(buttonTheme);
  }
  return MaterialApp(
    theme: theme,
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  // ============================================================
  // 档2-1：Token 真读取验证
  // ============================================================
  group('Theme 档2-1：Token 真读取', () {
    testWidgets('TButton 文字色取自 Token 而非常量', (tester) async {
      // 使用默认 Token 渲染 TButton
      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('Token测试'),
          variant: TButtonVariant.fill,
          colorScheme: TButtonColorScheme.primary,
        ),
      ));

      // 验证按钮存在且可渲染
      expect(find.byType(TButton), findsOneWidget);
      expect(find.text('Token测试'), findsOneWidget);

      // 获取 TThemeData，验证 brandNormalColor 存在
      final element = tester.element(find.byType(TButton));
      final tThemeData = Theme.of(element).extension<TThemeData>();
      expect(tThemeData, isNotNull);
      expect(tThemeData!.brandNormalColor, isNotNull);
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.style?.backgroundColor?.resolve({}),
          tThemeData.brandNormalColor);
    });

    testWidgets('TTag 颜色取自 Token 主题', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TTag(
          '标签',
          colorScheme: TTagColorScheme.primary,
        ),
      ));

      expect(find.byType(TTag), findsOneWidget);
      expect(find.text('标签'), findsOneWidget);

      final element = tester.element(find.byType(TTag));
      final tThemeData = Theme.of(element).extension<TThemeData>();
      expect(tThemeData, isNotNull);
      expect(tThemeData!.brandNormalColor, isNotNull);
    });
  });

  // ============================================================
  // 档2-2：优先级覆盖验证（P0 实例 > P1 组件 Theme > P4 Token）
  // ============================================================
  group('Theme 档2-2：优先级覆盖', () {
    testWidgets('P0 实例参数覆盖 P1 组件 Theme', (tester) async {
      // 组件 Theme 设置 defaultVariant=outline，实例传 variant=fill
      // 实例应胜出
      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('优先级'),
          variant: TButtonVariant.fill,
          colorScheme: TButtonColorScheme.primary,
        ),
        buttonTheme:
            const TButtonThemeData(defaultVariant: TButtonVariant.outline),
      ));

      expect(find.byType(TButton), findsOneWidget);
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.style?.backgroundColor?.resolve({}),
          TThemeData.defaultData().brandNormalColor);
      expect(button.style?.side?.resolve({}), isNull);
    });

    testWidgets('P1 组件 Theme 覆盖 P4 Token 默认', (tester) async {
      // 不传实例 variant，但传组件 Theme defaultVariant
      // 组件 Theme 应生效
      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('Theme覆盖'),
          colorScheme: TButtonColorScheme.primary,
        ),
        buttonTheme:
            const TButtonThemeData(defaultVariant: TButtonVariant.outline),
      ));

      expect(find.byType(TButton), findsOneWidget);
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.style?.side?.resolve({})?.color,
          TThemeData.defaultData().brandNormalColor);
    });

    testWidgets('P4 Token 作为最终默认值', (tester) async {
      // 不传实例参数，不传组件 Theme
      // 应使用 Token 默认值
      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('默认'),
          colorScheme: TButtonColorScheme.primary,
        ),
      ));

      expect(find.byType(TButton), findsOneWidget);
      // Token 默认色应存在
      final element = tester.element(find.byType(TButton));
      final tThemeData = Theme.of(element).extension<TThemeData>();
      expect(tThemeData, isNotNull);
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.style?.backgroundColor?.resolve({}),
          tThemeData!.brandNormalColor);
    });
  });

  // ============================================================
  // 档2-3：子树 mergeExtension 覆盖
  // ============================================================
  group('Theme 档2-3：子树 mergeExtension', () {
    testWidgets('mergeExtension 覆盖构造器未传项', (tester) async {
      // 用 Theme.of(context).mergeExtension 包裹 TButton
      // 验证构造器未传的项被 Theme 覆盖
      final buttonKey = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: Scaffold(
            body: Center(
              child: Builder(
                builder: (context) {
                  // 子树注入 TButtonThemeData
                  return Theme(
                    data: Theme.of(context).mergeExtension(
                      const TButtonThemeData(shape: TButtonShape.circle),
                    ),
                    child: TButton(
                      key: buttonKey,
                      child: const Text('merge'),
                      variant: TButtonVariant.fill,
                      colorScheme: TButtonColorScheme.primary,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // 验证按钮正常渲染
      expect(find.byType(TButton), findsOneWidget);
      expect(find.text('merge'), findsOneWidget);
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.style?.shape?.resolve({}), isA<CircleBorder>());
    });

    testWidgets('mergeExtension 不覆盖已传实例参数', (tester) async {
      // 实例传 variant=fill，mergeExtension 传 defaultVariant=outline
      // 实例应胜出
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: Scaffold(
            body: Center(
              child: Builder(
                builder: (context) {
                  return Theme(
                    data: Theme.of(context).mergeExtension(
                      const TButtonThemeData(
                          defaultVariant: TButtonVariant.outline),
                    ),
                    child: const TButton(
                      child: Text('实例优先'),
                      variant: TButtonVariant.fill,
                      colorScheme: TButtonColorScheme.primary,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.byType(TButton), findsOneWidget);
      expect(find.text('实例优先'), findsOneWidget);
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.style?.side?.resolve({}), isNull);
    });
  });

  // ============================================================
  // 档2-4：light / dark Token 切换
  // ============================================================
  group('Theme 档2-4：light / dark Token 切换', () {
    testWidgets('light 模式 Token 正常', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('light'),
          variant: TButtonVariant.fill,
          colorScheme: TButtonColorScheme.primary,
        ),
      ));

      expect(find.byType(TButton), findsOneWidget);
    });

    testWidgets('自定义 Token 注入', (tester) async {
      // 注入自定义 TThemeData（修改 brandNormalColor）
      final defaultTheme = TThemeData.defaultData();
      final customTheme = defaultTheme.copyWith(
        colorMap: {'brandNormalColor': Colors.purple},
      ) as TThemeData;

      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('custom'),
          variant: TButtonVariant.fill,
          colorScheme: TButtonColorScheme.primary,
        ),
        tThemeData: customTheme,
      ));

      expect(find.byType(TButton), findsOneWidget);
      final element = tester.element(find.byType(TButton));
      final tThemeData = Theme.of(element).extension<TThemeData>();
      expect(tThemeData!.brandNormalColor, Colors.purple);
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.style?.backgroundColor?.resolve({}), Colors.purple);
    });
  });

  // ============================================================
  // 档2-5：TSwipeCell 组件级 Theme 覆盖
  // ============================================================
  group('Theme 档2-5：TSwipeCell 组件级 Theme 覆盖', () {
    Widget wrapSwipe(Widget child, {TSwipeCellThemeData? swipeTheme}) {
      var theme = TThemeBuilder.light(TThemeData.defaultData());
      if (swipeTheme != null) {
        theme = theme.mergeExtension(swipeTheme);
      }
      return MaterialApp(
        theme: theme,
        home: Scaffold(body: Center(child: child)),
      );
    }

    testWidgets('P1 actionBackgroundColor 覆盖 P0 未传背景色', (tester) async {
      await tester.pumpWidget(wrapSwipe(
        TSwipeCell(
          child: const SizedBox(width: 300, height: 60, child: Text('Row')),
          end: TSwipeCellPanel(
            children: const [TSwipeCellAction(label: 'Action')],
          ),
          initialOpenSide: TSwipeCellSide.end,
        ),
        swipeTheme: const TSwipeCellThemeData(
          actionBackgroundColor: Colors.orange,
        ),
      ));
      await tester.pumpAndSettle();
      final container = tester.widget<Container>(
        find.ancestor(of: find.text('Action'), matching: find.byType(Container)).first,
      );
      expect(container.color, Colors.orange);
    });

    testWidgets('P0 backgroundColor 覆盖 P1 主题背景色', (tester) async {
      await tester.pumpWidget(wrapSwipe(
        TSwipeCell(
          child: const SizedBox(width: 300, height: 60, child: Text('Row')),
          end: TSwipeCellPanel(
            children: const [TSwipeCellAction(label: 'Action', backgroundColor: Colors.red)],
          ),
          initialOpenSide: TSwipeCellSide.end,
        ),
        swipeTheme: const TSwipeCellThemeData(
          actionBackgroundColor: Colors.orange,
        ),
      ));
      await tester.pumpAndSettle();
      final container = tester.widget<Container>(
        find.ancestor(of: find.text('Action'), matching: find.byType(Container)).first,
      );
      expect(container.color, Colors.red);
    });

    testWidgets('P1 actionIconColor 覆盖 P4 Token 默认色', (tester) async {
      await tester.pumpWidget(wrapSwipe(
        TSwipeCell(
          child: const SizedBox(width: 300, height: 60, child: Text('Row')),
          end: TSwipeCellPanel(
            children: const [TSwipeCellAction(icon: Icons.edit, label: 'Action')],
          ),
          initialOpenSide: TSwipeCellSide.end,
        ),
        swipeTheme: const TSwipeCellThemeData(
          actionIconColor: Colors.teal,
        ),
      ));
      await tester.pumpAndSettle();
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.color, Colors.teal);
    });

    testWidgets('P1 actionTextStyle 覆盖 label 文字样式', (tester) async {
      await tester.pumpWidget(wrapSwipe(
        TSwipeCell(
          child: const SizedBox(width: 300, height: 60, child: Text('Row')),
          end: TSwipeCellPanel(
            children: const [TSwipeCellAction(label: 'Action')],
          ),
          initialOpenSide: TSwipeCellSide.end,
        ),
        swipeTheme: const TSwipeCellThemeData(
          actionTextStyle: TextStyle(
            color: Colors.deepPurple,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
      await tester.pumpAndSettle();
      final text = tester.widget<TText>(find.byType(TText));
      expect(text.style?.color, Colors.deepPurple);
      expect(text.style?.fontSize, 20);
    });

    testWidgets('P1 actionIconSize 覆盖内置默认图标尺寸 18', (tester) async {
      await tester.pumpWidget(wrapSwipe(
        TSwipeCell(
          child: const SizedBox(width: 300, height: 60, child: Text('Row')),
          end: TSwipeCellPanel(
            children: const [TSwipeCellAction(icon: Icons.edit)],
          ),
          initialOpenSide: TSwipeCellSide.end,
        ),
        swipeTheme: const TSwipeCellThemeData(actionIconSize: 28),
      ));
      await tester.pumpAndSettle();
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, 28);
    });

    testWidgets('P1 actionSpacing 覆盖内置默认间距 2', (tester) async {
      await tester.pumpWidget(wrapSwipe(
        TSwipeCell(
          child: const SizedBox(width: 300, height: 60, child: Text('Row')),
          end: TSwipeCellPanel(
            children: const [
              TSwipeCellAction(icon: Icons.edit, label: 'Action'),
            ],
          ),
          initialOpenSide: TSwipeCellSide.end,
        ),
        swipeTheme: const TSwipeCellThemeData(actionSpacing: 12),
      ));
      await tester.pumpAndSettle();
      final spacing = tester.widget<SizedBox>(
        find.ancestor(
          of: find.text('Action'),
          matching: find.byWidgetPredicate(
            (w) => w is SizedBox && w.width == 12,
          ),
        ),
      );
      expect(spacing.width, 12);
    });

    testWidgets('未配置 iconColor 时 icon 颜色回退到 P4 Token', (tester) async {
      await tester.pumpWidget(wrapSwipe(
        TSwipeCell(
          child: const SizedBox(width: 300, height: 60, child: Text('Row')),
          end: TSwipeCellPanel(
            children: const [TSwipeCellAction(icon: Icons.edit)],
          ),
          initialOpenSide: TSwipeCellSide.end,
        ),
      ));
      await tester.pumpAndSettle();
      final icon = tester.widget<Icon>(find.byType(Icon));
      final tTheme = Theme.of(tester.element(find.byType(Icon)))
          .extension<TThemeData>()!;
      expect(icon.color, tTheme.textColorAnti);
    });
  });
}
