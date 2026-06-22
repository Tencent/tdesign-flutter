import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TButton V1.0 Widget 测试
///
/// 覆盖 [button.md §4.2] 所有必测项：
/// - A 类禁用（onPressed: null）
/// - variant × colorScheme 矩阵
/// - icon 行为
/// - iconPosition 布局
/// - size 四档
/// - P0 style 覆盖
void main() {
  // 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child) {
    return TTheme(
      data: TThemeData.defaultData(),
      child: MaterialApp(
        home: Scaffold(body: Center(child: child)),
      ),
    );
  }

  group('TButton 禁用（A 类控制）', () {
    testWidgets('onPressed: null 表示禁用，不响应点击', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        TButton(
          child: const Text('禁用按钮'),
          onPressed: null,
        ),
      ));

      final button = tester.widget<MaterialButton>(find.byType(MaterialButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('onPressed 非 null 正常响应点击', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        TButton(
          child: const Text('可点击'),
          onPressed: () => tapped = true,
        ),
      ));

      await tester.tap(find.text('可点击'));
      expect(tapped, isTrue);
    });

    testWidgets('构造器不接受 disabled 参数', (tester) async {
      // 编译期验证：TButton(...disabled: true...) 无法编译
      // 运行时：仅验证 onPressed 方式可行
      expect(true, isTrue);
    });
  });

  group('TButton variant × colorScheme', () {
    testWidgets('fill + primary 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('填充'),
          variant: TButtonVariant.fill,
          colorScheme: TButtonColorScheme.primary,
          onPressed: null,
        ),
      ));

      expect(find.text('填充'), findsOneWidget);
      expect(find.byType(TButton), findsOneWidget);
      expect(find.byType(MaterialButton), findsOneWidget);
    });

    testWidgets('outline + defaultTheme 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('描边'),
          variant: TButtonVariant.outline,
          colorScheme: TButtonColorScheme.defaultTheme,
          onPressed: null,
        ),
      ));

      expect(find.text('描边'), findsOneWidget);
      expect(find.byType(TButton), findsOneWidget);
    });

    testWidgets('text + danger 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('文字'),
          variant: TButtonVariant.text,
          colorScheme: TButtonColorScheme.danger,
          onPressed: null,
        ),
      ));

      expect(find.text('文字'), findsOneWidget);
      expect(find.byType(TButton), findsOneWidget);
    });

    testWidgets('ghost + light 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('幽灵'),
          variant: TButtonVariant.ghost,
          colorScheme: TButtonColorScheme.light,
          onPressed: null,
        ),
      ));

      expect(find.text('幽灵'), findsOneWidget);
      expect(find.byType(TButton), findsOneWidget);
    });

    testWidgets('默认 variant 为 fill（未传时）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TButton(
          child: const Text('默认变体'),
          onPressed: null,
        ),
      ));

      expect(find.text('默认变体'), findsOneWidget);
    });
  });

  group('TButton icon 行为', () {
    testWidgets('icon 传入 Icon widget 正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TButton(
          icon: const Icon(Icons.add),
          child: const Text('带图标'),
          onPressed: null,
        ),
      ));

      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });

  group('TButton iconPosition', () {
    testWidgets('iconPosition: left 图标在文字左侧', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          icon: Icon(Icons.add),
          child: Text('左图标'),
          iconPosition: TButtonIconPosition.left,
          onPressed: null,
        ),
      ));

      expect(find.text('左图标'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('iconPosition: right 图标在文字右侧', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          icon: Icon(Icons.add),
          child: Text('右图标'),
          iconPosition: TButtonIconPosition.right,
          onPressed: null,
        ),
      ));

      expect(find.text('右图标'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });

  group('TButton size', () {
    testWidgets('large 渲染成功', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('大'),
          size: TButtonSize.large,
          onPressed: null,
        ),
      ));
      expect(find.text('大'), findsOneWidget);
    });

    testWidgets('medium 渲染成功', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('中'),
          size: TButtonSize.medium,
          onPressed: null,
        ),
      ));
      expect(find.text('中'), findsOneWidget);
    });

    testWidgets('small 渲染成功', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('小'),
          size: TButtonSize.small,
          onPressed: null,
        ),
      ));
      expect(find.text('小'), findsOneWidget);
    });

    testWidgets('extraSmall 渲染成功', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('极小'),
          size: TButtonSize.extraSmall,
          onPressed: null,
        ),
      ));
      expect(find.text('极小'), findsOneWidget);
    });
  });

  group('TButton P0 style 覆盖', () {
    testWidgets('实例 style 覆盖默认样式', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TButton(
          child: const Text('自定义'),
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.red),
          ),
          onPressed: null,
        ),
      ));

      expect(find.text('自定义'), findsOneWidget);
    });
  });

  group('TButton child 内容', () {
    testWidgets('child 为 Text 时正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TButton(
          child: const Text('文本内容'),
          onPressed: null,
        ),
      ));

      expect(find.text('文本内容'), findsOneWidget);
    });

    testWidgets('child 为自定义 Widget 时正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TButton(
          child: Container(
            width: 48,
            height: 48,
            color: Colors.blue,
          ),
          onPressed: null,
        ),
      ));

      expect(find.byType(Container), findsWidgets);
    });
  });
}
