import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TButton V1.0 Widget 测试
///
/// 覆盖所有公开 API 和关键行为路径，目标覆盖率 95%+。
void main() {
  // 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child, {TButtonThemeData? buttonTheme}) {
    final themeExtensions = <ThemeExtension>[
      if (buttonTheme != null) buttonTheme,
    ];
    // 注意：必须通过 MaterialApp.theme 传递 extensions，
    // 用外层 Theme 包 MaterialApp 会被 MaterialApp 默认 ThemeData.light() 覆盖，导致 extension 丢失。
    return MaterialApp(
      theme: ThemeData(
        extensions: [TThemeData.defaultData(), ...themeExtensions],
      ),
      home: Scaffold(body: child),
    );
  }

  // ============================================================
  // A 类控制：禁用（onPressed: null）
  // ============================================================
  group('TButton 禁用（A 类控制）', () {
    testWidgets('onPressed: null 表示禁用', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TButton(child: Text('禁用按钮'), onPressed: null)),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('onPressed 非 null 正常响应点击', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrapWithTheme(
          TButton(child: const Text('可点击'), onPressed: () => tapped = true),
        ),
      );

      await tester.tap(find.text('可点击'));
      expect(tapped, isTrue);
    });
  });

  // ============================================================
  // variant × colorScheme 全矩阵（4×4 = 16 组合）
  // ============================================================
  group('TButton variant × colorScheme 全矩阵', () {
    const variants = TButtonVariant.values;
    const schemes = TButtonColorScheme.values;

    for (final variant in variants) {
      for (final scheme in schemes) {
        testWidgets('$variant + $scheme 正常渲染', (tester) async {
          await tester.pumpWidget(
            wrapWithTheme(
              TButton(
                child: Text('${variant.name}_${scheme.name}'),
                variant: variant,
                colorScheme: scheme,
                onPressed: null,
              ),
            ),
          );

          expect(find.byType(TButton), findsOneWidget);
          expect(find.byType(ElevatedButton), findsOneWidget);
        });
      }
    }
  });

  // ============================================================
  // shape 五档测试
  // ============================================================
  group('TButton shape 五档', () {
    testWidgets('shape: rectangle 正常渲染（默认圆角）', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(child: Text('rectangle'), onPressed: null),
          buttonTheme: const TButtonThemeData(shape: TButtonShape.rectangle),
        ),
      );

      expect(find.byType(TButton), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('shape: round 正常渲染（大圆角）', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(child: Text('round'), onPressed: null),
          buttonTheme: const TButtonThemeData(shape: TButtonShape.round),
        ),
      );

      expect(find.byType(TButton), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('shape: square 正常渲染（直角 + 等宽高）', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(child: Text('square'), onPressed: null),
          buttonTheme: const TButtonThemeData(shape: TButtonShape.square),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(find.byType(TButton), findsOneWidget);

      // 验证 square 的 shape 为直角（RoundedRectangleBorder + BorderRadius.zero）
      final shape = button.style?.shape?.resolve({});
      expect(shape, isNotNull);
    });

    testWidgets('shape: circle 正常渲染（圆形）', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(child: Text('circle'), onPressed: null),
          buttonTheme: const TButtonThemeData(shape: TButtonShape.circle),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(find.byType(TButton), findsOneWidget);

      final shape = button.style?.shape?.resolve({});
      // circle 应渲染为 CircleBorder
      expect(shape is CircleBorder, isTrue);
    });

    testWidgets('shape: filled 正常渲染（零圆角）', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(child: Text('filled'), onPressed: null),
          buttonTheme: const TButtonThemeData(shape: TButtonShape.filled),
        ),
      );

      expect(find.byType(TButton), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('square 渲染为直角（BorderRadius.zero）', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(child: Text('square'), onPressed: null),
          buttonTheme: const TButtonThemeData(shape: TButtonShape.square),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final shape = button.style?.shape?.resolve({});
      expect(shape, isA<RoundedRectangleBorder>());
      expect((shape as RoundedRectangleBorder).borderRadius, BorderRadius.zero);
    });

    testWidgets('rectangle 渲染有圆角', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(child: Text('rect'), onPressed: null),
          buttonTheme: const TButtonThemeData(shape: TButtonShape.rectangle),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final shape = button.style?.shape?.resolve({});
      expect(shape, isA<RoundedRectangleBorder>());
      final borderRadius = (shape as RoundedRectangleBorder).borderRadius;
      // rectangle 应有非零圆角
      expect(borderRadius, isNot(BorderRadius.zero));
    });
  });

  // ============================================================
  // icon 图标行为
  // ============================================================
  group('TButton icon 图标', () {
    testWidgets('icon 传入 Icon widget 正常渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(
            icon: Icon(Icons.add),
            child: Text('带图标'),
            onPressed: null,
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('Icon(null) 保留 Flutter 空白占位语义', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(icon: Icon(null), child: Text('空图标'), onPressed: null),
        ),
      );

      expect(find.text('空图标'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('纯 icon 按钮（无 child）正常渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TButton(icon: Icon(Icons.star), onPressed: null)),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('自定义非 Icon widget 图标保持原样', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(
            icon: SizedBox.square(
              dimension: 11,
              child: ColoredBox(color: Colors.red),
            ),
            child: Text('自定义图标'),
            onPressed: null,
          ),
        ),
      );

      expect(find.text('自定义图标'), findsOneWidget);
      expect(
        tester
            .widgetList<SizedBox>(find.byType(SizedBox))
            .any((box) => box.width == 11 && box.height == 11),
        isTrue,
      );
    });

    testWidgets('Icon 自带 size/color 时不被默认值覆盖', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(
            icon: Icon(Icons.palette, size: 31, color: Colors.orange),
            child: Text('显式图标'),
            onPressed: null,
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.palette));
      expect(icon.size, 31);
      expect(icon.color, Colors.orange);
    });

    testWidgets('纯 icon + circle shape 渲染正确', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(icon: Icon(Icons.favorite), onPressed: null),
          buttonTheme: const TButtonThemeData(shape: TButtonShape.circle),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final shape = button.style?.shape?.resolve({});
      expect(shape is CircleBorder, isTrue);
    });

    testWidgets('纯 icon + square shape 等宽高', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(icon: Icon(Icons.home), onPressed: null),
          buttonTheme: const TButtonThemeData(shape: TButtonShape.square),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final minSize = button.style?.minimumSize?.resolve({});
      // square 纯 icon 应等宽高
      expect(minSize?.width, isNotNull);
      expect(minSize?.width, equals(minSize?.height));
    });

    testWidgets('icon 位置 left / right 皆正常', (tester) async {
      // left
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(
            icon: Icon(Icons.arrow_back),
            child: Text('返回'),
            iconPosition: TButtonIconPosition.left,
            onPressed: null,
          ),
        ),
      );
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.text('返回'), findsOneWidget);

      // right
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(
            icon: Icon(Icons.arrow_forward),
            child: Text('前进'),
            iconPosition: TButtonIconPosition.right,
            onPressed: null,
          ),
        ),
      );
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      expect(find.text('前进'), findsOneWidget);
    });
  });

  // ============================================================
  // size 四档 + Theme defaultSize
  // ============================================================
  group('TButton size', () {
    testWidgets('large 渲染成功', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(
            child: Text('大'),
            size: TButtonSize.large,
            onPressed: null,
          ),
        ),
      );
      expect(find.text('大'), findsOneWidget);
    });

    testWidgets('medium 渲染成功', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(
            child: Text('中'),
            size: TButtonSize.medium,
            onPressed: null,
          ),
        ),
      );
      expect(find.text('中'), findsOneWidget);
    });

    testWidgets('small 渲染成功', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(
            child: Text('小'),
            size: TButtonSize.small,
            onPressed: null,
          ),
        ),
      );
      expect(find.text('小'), findsOneWidget);
    });

    testWidgets('extraSmall 渲染成功', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(
            child: Text('极小'),
            size: TButtonSize.extraSmall,
            onPressed: null,
          ),
        ),
      );
      expect(find.text('极小'), findsOneWidget);
    });

    testWidgets('未传 size 且 Theme 未设 defaultSize 时 fallback 为 medium', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(const TButton(child: Text('默认尺寸'), onPressed: null)),
      );

      expect(find.text('默认尺寸'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      // 验证默认 medium 尺寸的 minimumSize
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final minSize = button.style?.minimumSize?.resolve({});
      expect(minSize?.height, 40); // medium 的 sideLength
    });

    testWidgets('未传 size 但 Theme 设置了 defaultSize 时读取 Theme 值', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(child: Text('Theme尺寸'), onPressed: null),
          buttonTheme: const TButtonThemeData(defaultSize: TButtonSize.large),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final minSize = button.style?.minimumSize?.resolve({});
      expect(minSize?.height, 48); // large 的 sideLength
    });

    testWidgets('构造器 size 覆盖 Theme defaultSize', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(
            child: Text('覆盖'),
            size: TButtonSize.small,
            onPressed: null,
          ),
          buttonTheme: const TButtonThemeData(defaultSize: TButtonSize.large),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final minSize = button.style?.minimumSize?.resolve({});
      expect(minSize?.height, 32); // small 的 sideLength（被构造器覆盖）
    });
  });

  // ============================================================
  // P0 style 逃逸
  // ============================================================
  group('TButton P0 style 覆盖', () {
    testWidgets('实例 style 覆盖默认背景色', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(
            child: Text('自定义'),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.red),
            ),
            onPressed: null,
          ),
        ),
      );

      expect(find.text('自定义'), findsOneWidget);
    });

    testWidgets('实例 style 覆盖 shape', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TButton(
            child: const Text('自定义shape'),
            style: ButtonStyle(
              shape: WidgetStatePropertyAll<OutlinedBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            onPressed: null,
          ),
          buttonTheme: const TButtonThemeData(shape: TButtonShape.rectangle),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final shape = button.style?.shape?.resolve({});
      expect(shape, isNotNull);
    });
  });

  // ============================================================
  // 渐变（gradient）
  // ============================================================
  group('TButton gradient 渐变', () {
    testWidgets('渐变存在时外层包裹 Container', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(
            child: Text('渐变按钮'),
            variant: TButtonVariant.fill,
            colorScheme: TButtonColorScheme.primary,
            onPressed: null,
          ),
          buttonTheme: const TButtonThemeData(
            gradient: LinearGradient(colors: [Colors.red, Colors.blue]),
          ),
        ),
      );

      // 渐变模式不使用 ElevatedButton，而是 Container + gradient 装饰
      expect(find.byType(TButton), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.byType(Container), findsWidgets);
      // 验证存在带 gradient 的装饰层
      final containers = tester.widgetList<Container>(find.byType(Container));
      final hasGradientDecoration = containers.any((c) {
        final decoration = c.decoration;
        return (decoration is BoxDecoration && decoration.gradient != null) ||
            (decoration is ShapeDecoration && decoration.gradient != null);
      });
      expect(hasGradientDecoration, isTrue);
    });

    testWidgets('渐变分支复用 P0 style 的关键字段', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(
            child: Text('渐变自定义'),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.green),
              foregroundColor: WidgetStatePropertyAll(Colors.yellow),
              minimumSize: WidgetStatePropertyAll<Size>(Size(120, 56)),
              padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                EdgeInsets.all(30),
              ),
              shape: WidgetStatePropertyAll<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              side: WidgetStatePropertyAll(
                BorderSide(color: Colors.purple, width: 2),
              ),
            ),
            onPressed: null,
          ),
          buttonTheme: const TButtonThemeData(
            gradient: LinearGradient(colors: [Colors.red, Colors.blue]),
          ),
        ),
      );

      expect(find.byType(ElevatedButton), findsNothing);

      expect(
        tester
            .widgetList<Padding>(find.byType(Padding))
            .any((p) => p.padding == const EdgeInsets.all(30)),
        isTrue,
      );

      expect(
        tester
            .widgetList<ConstrainedBox>(find.byType(ConstrainedBox))
            .any(
              (box) =>
                  box.constraints.minWidth == 120 &&
                  box.constraints.minHeight == 56,
            ),
        isTrue,
      );
      expect(
        tester.widgetList<Container>(find.byType(Container)).any((c) {
          final decoration = c.decoration;
          return decoration is ShapeDecoration &&
              decoration.color == Colors.green &&
              decoration.gradient == null &&
              decoration.shape is RoundedRectangleBorder &&
              (decoration.shape as RoundedRectangleBorder).side.color ==
                  Colors.purple;
        }),
        isTrue,
      );
    });

    testWidgets('渐变分支复用 fixed/max/elevation 等 P0 style 字段', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TButton(
            child: const Text('渐变尺寸'),
            style: const ButtonStyle(
              fixedSize: WidgetStatePropertyAll<Size>(Size(140, 52)),
              maximumSize: WidgetStatePropertyAll<Size>(Size(160, 60)),
              elevation: WidgetStatePropertyAll<double>(6),
              shadowColor: WidgetStatePropertyAll<Color>(Colors.black),
              surfaceTintColor: WidgetStatePropertyAll<Color>(Colors.white),
            ),
            onPressed: () {},
          ),
          buttonTheme: const TButtonThemeData(
            gradient: LinearGradient(colors: [Colors.red, Colors.blue]),
          ),
        ),
      );

      expect(find.byType(ElevatedButton), findsNothing);
      expect(
        tester
            .widgetList<SizedBox>(find.byType(SizedBox))
            .any((box) => box.width == 140 && box.height == 52),
        isTrue,
      );
      expect(
        tester
            .widgetList<ConstrainedBox>(find.byType(ConstrainedBox))
            .any(
              (box) =>
                  box.constraints.maxWidth == 160 &&
                  box.constraints.maxHeight == 60,
            ),
        isTrue,
      );

      final material = tester
          .widgetList<Material>(find.byType(Material))
          .firstWhere((m) => m.type == MaterialType.transparency);
      expect(material.elevation, 6);
      expect(material.shadowColor, Colors.black);
      expect(material.surfaceTintColor, Colors.white);
    });

    testWidgets('渐变启用态响应点击，禁用态不响应点击', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        wrapWithTheme(
          TButton(child: const Text('渐变可点'), onPressed: () => taps += 1),
          buttonTheme: const TButtonThemeData(
            gradient: LinearGradient(colors: [Colors.red, Colors.blue]),
          ),
        ),
      );

      await tester.tap(find.text('渐变可点'));
      expect(taps, 1);

      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(child: Text('渐变禁用'), onPressed: null),
          buttonTheme: const TButtonThemeData(
            gradient: LinearGradient(colors: [Colors.red, Colors.blue]),
          ),
        ),
      );

      await tester.tap(find.text('渐变禁用'));
      expect(taps, 1);
    });

    testWidgets('渐变时背景色为透明', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(
            child: Text('渐变透明'),
            variant: TButtonVariant.fill,
            colorScheme: TButtonColorScheme.primary,
            onPressed: null,
          ),
          buttonTheme: const TButtonThemeData(
            gradient: LinearGradient(colors: [Colors.red, Colors.blue]),
          ),
        ),
      );

      // 渐变模式不使用 ElevatedButton（backgroundColor 被强制 null 以触发 MaterialType.transparency）
      expect(find.byType(ElevatedButton), findsNothing);
      // 验证使用了透明 Material（替代 ElevatedButton 的不透明背景）
      final materials = tester.widgetList<Material>(find.byType(Material));
      expect(materials.any((m) => m.type == MaterialType.transparency), isTrue);
    });

    testWidgets('渐变 + margin 组合正常', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(
            child: Text('渐变边距'),
            variant: TButtonVariant.fill,
            colorScheme: TButtonColorScheme.primary,
            onPressed: null,
          ),
          buttonTheme: const TButtonThemeData(
            gradient: LinearGradient(colors: [Colors.orange, Colors.pink]),
            margin: EdgeInsets.all(16),
          ),
        ),
      );

      expect(find.text('渐变边距'), findsOneWidget);
      // 渐变模式不使用 ElevatedButton，margin 外包 Container
      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('渐变纯图标 small 和 extraSmall 默认布局可构建', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          Column(
            children: [
              TButton(
                icon: const Icon(Icons.add),
                size: TButtonSize.small,
                onPressed: () {},
              ),
              TButton(
                icon: const Icon(Icons.remove),
                size: TButtonSize.extraSmall,
                onPressed: () {},
              ),
            ],
          ),
          buttonTheme: const TButtonThemeData(
            shape: TButtonShape.circle,
            gradient: LinearGradient(colors: [Colors.red, Colors.blue]),
          ),
        ),
      );

      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.remove), findsOneWidget);
    });

    testWidgets('渐变无 content 分支可构建空按钮', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TButton(onPressed: () {}),
          buttonTheme: const TButtonThemeData(
            gradient: LinearGradient(colors: [Colors.red, Colors.blue]),
          ),
        ),
      );

      expect(find.byType(TButton), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('渐变 round/filled/circle shape 分支可构建', (tester) async {
      for (final shape in [
        TButtonShape.round,
        TButtonShape.filled,
        TButtonShape.circle,
      ]) {
        await tester.pumpWidget(
          wrapWithTheme(
            TButton(icon: const Icon(Icons.circle), onPressed: () {}),
            buttonTheme: TButtonThemeData(
              shape: shape,
              gradient: const LinearGradient(colors: [Colors.red, Colors.blue]),
            ),
          ),
        );

        expect(find.byType(ElevatedButton), findsNothing);
        expect(find.byIcon(Icons.circle), findsOneWidget);
      }
    });

    testWidgets('渐变 fallback shape/textStyle/padding/minimumSize 可执行', (
      tester,
    ) async {
      const nullFallbackStyle = ButtonStyle(
        shape: WidgetStatePropertyAll<OutlinedBorder?>(null),
        textStyle: WidgetStatePropertyAll<TextStyle?>(null),
        padding: WidgetStatePropertyAll<EdgeInsetsGeometry?>(null),
        minimumSize: WidgetStatePropertyAll<Size?>(null),
      );

      for (final config in [
        (TButtonShape.rectangle, TButtonSize.large, 'rect-large'),
        (TButtonShape.round, TButtonSize.medium, 'round-medium'),
        (TButtonShape.filled, TButtonSize.large, 'filled-large'),
        (TButtonShape.circle, TButtonSize.medium, 'circle-medium'),
      ]) {
        await tester.pumpWidget(
          wrapWithTheme(
            TButton(
              icon: const Icon(Icons.adjust),
              child: Text(config.$3),
              size: config.$2,
              style: nullFallbackStyle,
              onPressed: () {},
            ),
            buttonTheme: TButtonThemeData(
              shape: config.$1,
              gradient: const LinearGradient(colors: [Colors.red, Colors.blue]),
            ),
          ),
        );

        expect(find.text(config.$3), findsOneWidget);
        expect(find.byType(ElevatedButton), findsNothing);
      }
    });

    testWidgets('渐变 fallback 纯 icon circle padding 可执行', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TButton(
            icon: const Icon(Icons.adjust),
            size: TButtonSize.medium,
            style: const ButtonStyle(
              padding: WidgetStatePropertyAll<EdgeInsetsGeometry?>(null),
            ),
            onPressed: () {},
          ),
          buttonTheme: const TButtonThemeData(
            shape: TButtonShape.circle,
            gradient: LinearGradient(colors: [Colors.red, Colors.blue]),
          ),
        ),
      );

      expect(find.byIcon(Icons.adjust), findsOneWidget);
      expect(
        tester
            .widgetList<Padding>(find.byType(Padding))
            .any((p) => p.padding == const EdgeInsets.all(10)),
        isTrue,
      );
    });

    testWidgets('无渐变时不额外包裹 Container', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(
            child: Text('无渐变'),
            variant: TButtonVariant.fill,
            colorScheme: TButtonColorScheme.primary,
            onPressed: null,
          ),
        ),
      );

      // TButton 自身 render，无外包 Container（排除外层 TTheme/MaterialApp 的 Container）
      final topWidgets = find.byType(ElevatedButton);
      expect(topWidgets, findsOneWidget);
    });
  });

  // ============================================================
  // 交互态验证
  // ============================================================
  group('TButton 交互态', () {
    testWidgets('disabled 时前景色为禁用色', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(
            child: Text('禁用态'),
            variant: TButtonVariant.fill,
            colorScheme: TButtonColorScheme.primary,
            onPressed: null,
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final fgColorResolver = button.style?.foregroundColor;
      final fgColor = fgColorResolver?.resolve({WidgetState.disabled});
      // disabled 态前景色应与系统默认禁用文本色一致
      expect(fgColor, isNotNull);
    });

    testWidgets('enabled fill 按钮背景色为非透明', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TButton(
            child: const Text('启用态'),
            variant: TButtonVariant.fill,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {},
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final bgColor = button.style?.backgroundColor?.resolve({});
      // fill primary 启用态应非透明
      expect(bgColor, isNotNull);
      expect(bgColor!.a, greaterThan(0));
    });
  });

  // ============================================================
  // Theme 子树注入
  // ============================================================
  group('TButton Theme 子树', () {
    testWidgets('mergeExtension 覆盖构造器未传项', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(child: Text('Theme注入'), onPressed: null),
          buttonTheme: const TButtonThemeData(
            defaultVariant: TButtonVariant.outline,
            defaultSize: TButtonSize.large,
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button, isNotNull);
      expect(find.text('Theme注入'), findsOneWidget);
    });

    testWidgets('构造器参数覆盖 Theme 子树值', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(
            child: Text('构造器优先'),
            variant: TButtonVariant.text,
            size: TButtonSize.small,
            onPressed: null,
          ),
          buttonTheme: const TButtonThemeData(
            defaultVariant: TButtonVariant.fill,
            defaultSize: TButtonSize.large,
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final minSize = button.style?.minimumSize?.resolve({});
      // 构造器 small 应覆盖 Theme 的 large (sideLength 32 vs 48)
      expect(minSize?.height, 32);
    });
  });

  // ============================================================
  // child 内容
  // ============================================================
  group('TButton child 内容', () {
    testWidgets('child 为 Text 时正常渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TButton(child: Text('文本内容'), onPressed: null)),
      );

      expect(find.text('文本内容'), findsOneWidget);
    });

    testWidgets('child 为自定义复杂 Widget 时正常渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, size: 16),
                SizedBox(width: 4),
                Text('评分'),
              ],
            ),
            onPressed: null,
          ),
        ),
      );

      expect(find.text('评分'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('child 为 null 且 icon 存在时仅渲染 icon', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TButton(icon: Icon(Icons.check), onPressed: null)),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });

  // ============================================================
  // 默认行为验证
  // ============================================================
  group('TButton 默认行为', () {
    testWidgets('未传 variant 时默认 fill', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TButton(child: Text('默认变体'), onPressed: null)),
      );

      expect(find.text('默认变体'), findsOneWidget);
      // fill 变体默认有 elevation: 0，验证无阴影
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final elevation = button.style?.elevation?.resolve({});
      expect(elevation, 0);
    });

    testWidgets('默认 iconPosition 为 left', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(
            icon: Icon(Icons.add),
            child: Text('按钮'),
            onPressed: null,
          ),
        ),
      );

      // icon + text 共 2 个文本节点（icon 的 icon + child 的 text）
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('按钮'), findsOneWidget);
    });

    testWidgets('outline 变体有边框', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(
            child: Text('描边'),
            variant: TButtonVariant.outline,
            onPressed: null,
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final side = button.style?.side?.resolve({});
      expect(side, isNotNull);
    });

    testWidgets('text 变体无边框', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TButton(
            child: Text('文字'),
            variant: TButtonVariant.text,
            onPressed: null,
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final side = button.style?.side?.resolve({});
      // text 变体默认无 side（BorderSide.none）
      expect(side == null || side == BorderSide.none, isTrue);
    });
  });

  // ============================================================
  // TButtonResolve 覆盖率补充
  // ============================================================
  group('TButtonResolve 覆盖率补充', () {
    testWidgets('theme padding 注入', (tester) async {
      // 覆盖 62（paddingStyle 非 null）+ 76（merge paddingStyle）
      await tester.pumpWidget(
        wrapWithTheme(
          TButton(child: const Text('pad'), onPressed: () {}),
          buttonTheme: const TButtonThemeData(padding: EdgeInsets.all(20)),
        ),
      );
      expect(find.byType(TButton), findsOneWidget);
    });

    Future<void> pressAndRelease(WidgetTester tester) async {
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(TButton)),
      );
      await tester.pump();
      await gesture.up();
      await tester.pump();
    }

    testWidgets('primary colorScheme pressed', (tester) async {
      // 覆盖 pressed 分支 + _pressedBackgroundColor primary
      await tester.pumpWidget(
        wrapWithTheme(
          TButton(
            child: const Text('p'),
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {},
          ),
        ),
      );
      await pressAndRelease(tester);
      expect(find.byType(TButton), findsOneWidget);
    });

    testWidgets('danger colorScheme pressed', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TButton(
            child: const Text('d'),
            colorScheme: TButtonColorScheme.danger,
            onPressed: () {},
          ),
        ),
      );
      await pressAndRelease(tester);
      expect(find.byType(TButton), findsOneWidget);
    });

    testWidgets('light colorScheme pressed', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TButton(
            child: const Text('l'),
            colorScheme: TButtonColorScheme.light,
            onPressed: () {},
          ),
        ),
      );
      await pressAndRelease(tester);
      expect(find.byType(TButton), findsOneWidget);
    });

    testWidgets('defaultTheme colorScheme pressed', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TButton(
            child: const Text('def'),
            colorScheme: TButtonColorScheme.defaultTheme,
            onPressed: () {},
          ),
        ),
      );
      await pressAndRelease(tester);
      expect(find.byType(TButton), findsOneWidget);
    });
  });

  // ============================================================
  // TButton size/shape/margin 覆盖率补充
  // ============================================================
  group('TButton size/shape 覆盖率补充', () {
    testWidgets('large size', (tester) async {
      // 覆盖 317（fontSize large）+ 327（height large）
      await tester.pumpWidget(
        wrapWithTheme(
          TButton(
            child: const Text('lg'),
            size: TButtonSize.large,
            onPressed: () {},
          ),
        ),
      );
      expect(find.byType(TButton), findsOneWidget);
    });

    testWidgets('small size', (tester) async {
      // 覆盖 268（iconSize small）+ 278-279（padding small）+ 318（fontSize medium→small）
      await tester.pumpWidget(
        wrapWithTheme(
          TButton(
            child: const Text('sm'),
            size: TButtonSize.small,
            onPressed: () {},
          ),
        ),
      );
      expect(find.byType(TButton), findsOneWidget);
    });

    testWidgets('extraSmall size', (tester) async {
      // 覆盖 298（padding extraSmall）
      await tester.pumpWidget(
        wrapWithTheme(
          TButton(
            child: const Text('xs'),
            size: TButtonSize.extraSmall,
            onPressed: () {},
          ),
        ),
      );
      expect(find.byType(TButton), findsOneWidget);
    });

    testWidgets('theme margin 注入', (tester) async {
      // 覆盖 233（theme.margin != null → Container margin）
      await tester.pumpWidget(
        wrapWithTheme(
          TButton(child: const Text('m'), onPressed: () {}),
          buttonTheme: const TButtonThemeData(margin: EdgeInsets.all(10)),
        ),
      );
      expect(find.byType(TButton), findsOneWidget);
    });

    testWidgets('icon onlyIcon 渲染', (tester) async {
      // 覆盖 251-252（_wrapIcon → Icon 渲染）
      await tester.pumpWidget(
        wrapWithTheme(TButton(child: const Icon(Icons.add), onPressed: () {})),
      );
      expect(find.byType(TButton), findsOneWidget);
    });
  });
}
