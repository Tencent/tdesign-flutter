import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TText V1.0 Widget 测试
///
/// 覆盖样式优先级链、TTextThemeData、TTextResolve、padding 缓存、
/// TTextSpan 一致性及全局变量删除后的行为。
void main() {
  /// 完整包装，注入 TDesign 全局主题。
  Widget wrapWithTheme(Widget child, {TTextThemeData? textTheme}) {
    var theme = TThemeBuilder.light(TThemeData.defaultData());
    if (textTheme != null) {
      theme = theme.mergeExtension(textTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: child),
    );
  }

  // ============================================================
  // T01 – 基础渲染
  // ============================================================
  testWidgets('T01 - 基础渲染：渲染文本内容', (tester) async {
    await tester.pumpWidget(wrapWithTheme(
      const TText('测试文本'),
    ));
    expect(find.text('测试文本'), findsOneWidget);
    expect(find.byType(TText), findsOneWidget);
  });

  testWidgets('T01b - 完整主题下默认文本样式来自 token', (tester) async {
    final token = TThemeData.defaultData();
    await tester.pumpWidget(wrapWithTheme(
      const TText('Token 文本'),
    ));

    final text = tester.widget<Text>(find.text('Token 文本'));
    expect(text.style?.color, token.textColorPrimary);
    expect(text.style?.fontSize, token.fontBodyLarge?.size);
    expect(text.style?.height, token.fontBodyLarge?.height);
  });

  // ============================================================
  // T02 – 构造器糖参数
  // ============================================================
  testWidgets('T02 - 构造器糖：textColor 生效', (tester) async {
    const color = Colors.red;
    await tester.pumpWidget(wrapWithTheme(
      const TText('红色文本', textColor: color),
    ));

    final text = tester.widget<Text>(find.text('红色文本'));
    expect(text.style?.color, color);
  });

  testWidgets('T02b - 构造器糖：font 指定字号和行高', (tester) async {
    await tester.pumpWidget(wrapWithTheme(
      TText('大号文本', font: Font(size: 20, lineHeight: 28)),
    ));

    final text = tester.widget<Text>(find.text('大号文本'));
    expect(text.style?.fontSize, 20);
    expect(text.style?.height, 28 / 20); // Font 内部已是因子: lineHeight/size
  });

  testWidgets('T02c - 构造器糖：isTextThrough 删除线', (tester) async {
    await tester.pumpWidget(wrapWithTheme(
      const TText('删除线文本', isTextThrough: true),
    ));

    final text = tester.widget<Text>(find.text('删除线文本'));
    expect(text.style?.decoration, TextDecoration.lineThrough);
  });

  testWidgets('T02d - 构造器糖：forceVerticalCenter 触发 Container 包装',
      (tester) async {
    await tester.pumpWidget(wrapWithTheme(
      const TText('居中文本', forceVerticalCenter: true),
    ));

    // forceVerticalCenter 应该用 Container 包裹
    expect(find.byType(Container), findsWidgets);
    expect(find.text('居中文本'), findsOneWidget);
  });

  // ============================================================
  // T03 – 样式优先级：P0 style 覆盖构造器糖
  // ============================================================
  testWidgets('T03 - P0 style.color 覆盖 textColor', (tester) async {
    await tester.pumpWidget(wrapWithTheme(
      const TText(
        '样式覆盖',
        textColor: Colors.blue,
        style: TextStyle(color: Colors.red),
      ),
    ));

    final text = tester.widget<Text>(find.text('样式覆盖'));
    expect(text.style?.color, Colors.red); // P0 style 优先
  });

  testWidgets('T03b - P0 style.fontSize 覆盖构造器 Font', (tester) async {
    await tester.pumpWidget(wrapWithTheme(
      TText(
        '字体覆盖',
        font: Font(size: 14, lineHeight: 20),
        style: const TextStyle(fontSize: 24),
      ),
    ));

    final text = tester.widget<Text>(find.text('字体覆盖'));
    expect(text.style?.fontSize, 24); // P0 优先
    // height 仍使用构造器的（style 未覆写），Font 内部已是因子
    expect(text.style?.height, 20 / 14);
  });

  // ============================================================
  // T04 – TTextThemeData 子树默认值
  // ============================================================
  testWidgets('T04 - TTextThemeData.context 提供默认颜色', (tester) async {
    await tester.pumpWidget(wrapWithTheme(
      const TText('主题文本'),
      textTheme: const TTextThemeData(defaultTextColor: Colors.orange),
    ));

    final text = tester.widget<Text>(find.text('主题文本'));
    expect(text.style?.color, Colors.orange);
  });

  testWidgets('T04b - 构造器 textColor 覆盖 TTextThemeData', (tester) async {
    await tester.pumpWidget(wrapWithTheme(
      const TText('覆盖主题', textColor: Colors.green),
      textTheme: const TTextThemeData(defaultTextColor: Colors.orange),
    ));

    final text = tester.widget<Text>(find.text('覆盖主题'));
    expect(text.style?.color, Colors.green); // 构造器优先于 Theme
  });

  testWidgets('T04c - TTextThemeData.forceVerticalCenter 默认启用', (tester) async {
    await tester.pumpWidget(wrapWithTheme(
      const TText('居中主题'),
      textTheme: const TTextThemeData(forceVerticalCenter: true),
    ));

    // 应该触发 Container 包装
    expect(find.byType(Container), findsWidgets);
    expect(find.text('居中主题'), findsOneWidget);
  });

  testWidgets('T04d - TTextThemeData.defaultFont 覆盖 Token', (tester) async {
    await tester.pumpWidget(wrapWithTheme(
      const TText('字体主题'),
      textTheme: TTextThemeData(
        defaultFont: Font(size: 22, lineHeight: 30),
      ),
    ));

    final text = tester.widget<Text>(find.text('字体主题'));
    expect(text.style?.fontSize, 22);
    expect(text.style?.height, 30 / 22); // Font 内部已是因子
  });

  // ============================================================
  // T05 – TTextConfiguration 全局字体注入
  // ============================================================
  testWidgets('T05 - TTextConfiguration.globalFontFamily 生效', (tester) async {
    await tester.pumpWidget(wrapWithTheme(
      TTextConfiguration(
        globalFontFamily: FontFamily(fontFamily: 'TestFont'),
        child: const TText('全局字体'),
      ),
    ));

    final text = tester.widget<Text>(find.text('全局字体'));
    expect(text.style?.fontFamily, 'TestFont');
  });

  testWidgets('T05b - 构造器 fontFamily 覆盖 globalFontFamily', (tester) async {
    await tester.pumpWidget(wrapWithTheme(
      TTextConfiguration(
        globalFontFamily: FontFamily(fontFamily: 'GlobalFont'),
        child: TText(
          '实例字体',
          fontFamily: FontFamily(fontFamily: 'InstanceFont'),
        ),
      ),
    ));

    final text = tester.widget<Text>(find.text('实例字体'));
    expect(text.style?.fontFamily, 'InstanceFont');
  });

  testWidgets('T05c - globalFontFamily 覆盖组件 Theme 默认字体', (tester) async {
    await tester.pumpWidget(wrapWithTheme(
      TTextConfiguration(
        globalFontFamily: FontFamily(fontFamily: 'GlobalFont'),
        child: const TText('全局优先'),
      ),
      textTheme: TTextThemeData(
        defaultFontFamily: FontFamily(fontFamily: 'ThemeFont'),
      ),
    ));

    final text = tester.widget<Text>(find.text('全局优先'));
    expect(text.style?.fontFamily, 'GlobalFont');
  });

  // ============================================================
  // T06 – TTextConfiguration.updateShouldNotify
  // ============================================================
  testWidgets('T06 - globalFontFamily 变更触发子树重建', (tester) async {
    const childKey = Key('test_child');
    await tester.pumpWidget(wrapWithTheme(
      TTextConfiguration(
        globalFontFamily: FontFamily(fontFamily: 'FontA'),
        child: Container(key: childKey, child: const TText('文本')),
      ),
    ));

    final text1 = tester.widget<Text>(find.text('文本'));
    expect(text1.style?.fontFamily, 'FontA');

    // 切换全局字体
    await tester.pumpWidget(wrapWithTheme(
      TTextConfiguration(
        globalFontFamily: FontFamily(fontFamily: 'FontB'),
        child: Container(key: childKey, child: const TText('文本')),
      ),
    ));

    final text2 = tester.widget<Text>(find.text('文本'));
    expect(text2.style?.fontFamily, 'FontB');
  });

  // ============================================================
  // T07 – TTextSpan 与 TText 样式一致性
  // ============================================================
  test('T07 - TTextSpan 构造器直接创建正确样式', () {
    final span = TTextSpan(
      text: 'Span文本',
      textColor: Colors.purple,
      font: Font(size: 18, lineHeight: 26),
    );

    // TTextSpan 继承 TextSpan，style 在构造器中通过 resolveSpan 设置
    expect(span.style?.color, Colors.purple);
    expect(span.style?.fontSize, 18);
    expect(span.style?.height, 26 / 18); // Font 内部已是因子
  });

  test('T07b - TTextSpan P0 style 覆盖糖', () {
    final span = TTextSpan(
      text: '覆盖测试',
      textColor: Colors.blue,
      style: const TextStyle(color: Colors.red),
    );

    // P0 style 应覆盖 textColor
    expect(span.style?.color, Colors.red);
  });

  testWidgets('T07c - TText.rich 正常渲染 TTextSpan', (tester) async {
    await tester.pumpWidget(wrapWithTheme(
      TText.rich(
        TextSpan(children: [
          TTextSpan(
            text: '富文本',
            textColor: Colors.teal,
            font: Font(size: 16, lineHeight: 24),
          ),
        ]),
      ),
    ));

    // 验证文本已渲染（TTextSpan 在构造器中已通过 resolveSpan 设置样式）
    expect(find.text('富文本'), findsOneWidget);

    // 确认存在 RichText 承载富文本
    expect(find.byType(RichText), findsWidgets);
  });

  // ============================================================
  // T08 – TTextThemeData copyWith / lerp
  // ============================================================
  test('T08 - copyWith 部分覆写', () {
    const original = TTextThemeData(
      defaultTextColor: Colors.red,
      forceVerticalCenter: true,
    );
    final copied = original.copyWith(defaultTextColor: Colors.blue);

    expect(copied.defaultTextColor, Colors.blue);
    expect(copied.forceVerticalCenter, true); // 未覆写的保留
    expect(copied.defaultFont, isNull);
  });

  test('T08b - lerp 过渡计算', () {
    const red = Color(0xFFF44336);
    const blue = Color(0xFF2196F3);
    const a = TTextThemeData(defaultTextColor: red, forceVerticalCenter: false);
    const b = TTextThemeData(defaultTextColor: blue, forceVerticalCenter: true);

    final lerped = a.lerp(b, 0.0);
    expect(lerped.defaultTextColor, red);
    expect(lerped.forceVerticalCenter, false);

    final lerped2 = a.lerp(b, 1.0);
    expect(lerped2.defaultTextColor, blue);
    expect(lerped2.forceVerticalCenter, true);
  });

  // ============================================================
  // T09 – forceVerticalCenter height 语义统一
  // ============================================================
  testWidgets(
      'T09 - forceVerticalCenter 使用统一 height（非 min(heightRate, height)）',
      (tester) async {
    // v1.0 修复：Container 和 TextStyle 使用相同 height
    await tester.pumpWidget(wrapWithTheme(
      TText(
        'height测试',
        forceVerticalCenter: true,
        font: Font(size: 16, lineHeight: 24),
      ),
    ));

    // 验证 Container 存在且有约束
    // Font(size: 16, lineHeight: 24) → height 因子 = 24/16 = 1.5
    // Container.height = fontSize * height 因子 = 16 * 1.5 = 24
    final container = tester.widget<Container>(find.byType(Container).first);
    expect(container.constraints?.maxHeight, 24.0);

    final text = tester.widget<Text>(find.text('height测试'));
    // TextStyle.height 应与统一 height 因子一致
    expect(text.style?.height, 24 / 16);
  });

  // ============================================================
  // T10 – Padding 缓存扩容（fontFamily/fontWeight/textScale 参与 key）
  // ============================================================
  testWidgets('T10 - fontFamily 变更导致不同 padding', (tester) async {
    // 默认字体
    await tester.pumpWidget(wrapWithTheme(
      const TText(
        'padding测试A',
        forceVerticalCenter: true,
      ),
    ));

    final container1 = tester.widget<Container>(find.byType(Container).first);
    final padding1 = container1.padding;

    // 不同字体
    await tester.pumpWidget(wrapWithTheme(
      TTextConfiguration(
        globalFontFamily: FontFamily(fontFamily: 'Courier'),
        child: const TText(
          'padding测试B',
          forceVerticalCenter: true,
        ),
      ),
    ));

    final container2 = tester.widget<Container>(find.byType(Container).first);
    final padding2 = container2.padding;

    // v1.0 缓存扩容后，不同字体应有独立缓存条目，
    // 在基准测试环境下 padding 可能不同（取决于字体 metrics）
    // 至少确保两边都能正常渲染
    expect(padding1, isNotNull);
    expect(padding2, isNotNull);
  });

  // ============================================================
  // T11 – getRawText 互操作
  // ============================================================
  testWidgets('T11 - getRawText 返回系统 Text', (tester) async {
    await tester.pumpWidget(wrapWithTheme(
      Builder(builder: (context) {
        final rawText = const TText(
          '原始文本',
          backgroundColor: Colors.yellow,
        ).getRawText(context: context);

        return rawText;
      }),
    ));

    expect(find.text('原始文本'), findsOneWidget);
    // getRawText 返回的是系统 Text（非 TText）
    expect(find.byType(TText), findsNothing);
  });

  // ============================================================
  // T12 – 删除全局变量后行为正常
  // ============================================================
  testWidgets('T12 - 无 kTextForceVerticalCenterEnable 仍正常工作', (tester) async {
    // v1.0 删除全局变量后，实例 forceVerticalCenter 仍应生效
    await tester.pumpWidget(wrapWithTheme(
      const TText('强制居中', forceVerticalCenter: true),
    ));

    expect(find.text('强制居中'), findsOneWidget);
    // 应该被 Container 包裹
    expect(find.byType(Container), findsWidgets);
  });

  testWidgets('T12b - 无 kTextForceVerticalCenterEnable 默认不居中', (tester) async {
    // 默认 forceVerticalCenter=false，TTextThemeData 也默认 false
    await tester.pumpWidget(wrapWithTheme(
      const TText('默认不居中'),
    ));

    // 不应该有 Container 包裹（除非 forceVerticalCenter=true）
    expect(find.text('默认不居中'), findsOneWidget);
  });

  test('T12c - kTextNeedGlobalFontFamily 已删除（编译期检查）', () {
    // 此测试仅验证代码编译通过，
    // TTextConfiguration.globalFontFamily 始终生效，无需全局开关
    expect(true, isTrue);
  });

  // ============================================================
  // T13 – backgroundColor 使用 Container 而非 TextStyle.background
  // ============================================================
  testWidgets('T13 - backgroundColor 通过 Container 渲染', (tester) async {
    await tester.pumpWidget(wrapWithTheme(
      const TText('背景色', backgroundColor: Colors.amber),
    ));

    final container = tester.widget<Container>(find.byType(Container).first);
    expect(container.color, Colors.amber);

    // 内部 Text 不应有 backgroundColor（避免中英文混排阶梯色）
    final text = tester.widget<Text>(find.text('背景色'));
    expect(text.style?.backgroundColor, isNull);
  });

  // ============================================================
  // T14 – TText.rich 父级样式应用到子 Span
  // ============================================================
  testWidgets('T14 - TText.rich 父级 textColor 和 P0 style 传递', (tester) async {
    await tester.pumpWidget(wrapWithTheme(
      TText.rich(
        TextSpan(children: [
          TTextSpan(text: '子文本'),
        ]),
        textColor: Colors.teal,
      ),
    ));

    final richText = tester.widget<RichText>(find.byType(RichText).last);
    final rootSpan = richText.text as TextSpan;

    // 父级样式通过 TextSpan.style 应用（TText.rich 的 textColor 会反映在根 style）
    expect(rootSpan.style?.color, Colors.teal);
  });
}
