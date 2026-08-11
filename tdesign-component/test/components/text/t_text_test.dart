import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TText Widget 测试
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
    await tester.pumpWidget(wrapWithTheme(const TText('测试文本')));
    expect(find.text('测试文本'), findsOneWidget);
    expect(find.byType(TText), findsOneWidget);
  });

  testWidgets('T01a - GlobalKey 只绑定 TText 自身', (tester) async {
    final key = GlobalKey();
    await tester.pumpWidget(wrapWithTheme(TText('唯一 key', key: key)));

    expect(key.currentWidget, isA<TText>());
    expect(find.text('唯一 key'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('T01b - 完整主题下过滤 Material 自动 DefaultTextStyle 并使用 Token', (
    tester,
  ) async {
    await tester.pumpWidget(wrapWithTheme(const TText('Token 文本')));

    final text = tester.widget<Text>(find.text('Token 文本'));
    final context = tester.element(find.text('Token 文本'));
    final token = context.tTheme;
    expect(text.style?.color, token.textColorPrimary);
    expect(text.style?.fontSize, token.fontBodyLarge?.size);
    expect(text.style?.height, token.fontBodyLarge?.height);
  });

  testWidgets('T01c - 未显式缩放时继承 MediaQuery 无障碍字号', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(body: TText('系统缩放')),
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('系统缩放'));
    final richText = tester.widget<RichText>(find.byType(RichText).last);
    expect(text.textScaler, isNull);
    expect(richText.textScaler.scale(10), 20);
  });

  // ============================================================
  // T02 – 构造器糖参数
  // ============================================================
  testWidgets('T02 - 构造器糖：textColor 生效', (tester) async {
    const color = Colors.red;
    await tester.pumpWidget(
      wrapWithTheme(const TText('红色文本', textColor: color)),
    );

    final text = tester.widget<Text>(find.text('红色文本'));
    expect(text.style?.color, color);
  });

  testWidgets('T02b - 构造器糖：font 指定字号和行高', (tester) async {
    await tester.pumpWidget(
      wrapWithTheme(TText('大号文本', font: Font(size: 20, lineHeight: 28))),
    );

    final text = tester.widget<Text>(find.text('大号文本'));
    expect(text.style?.fontSize, 20);
    expect(text.style?.height, 28 / 20); // Font 内部已是因子: lineHeight/size
  });

  testWidgets('T02c - 构造器糖：isTextThrough 删除线', (tester) async {
    await tester.pumpWidget(
      wrapWithTheme(const TText('删除线文本', isTextThrough: true)),
    );

    final text = tester.widget<Text>(find.text('删除线文本'));
    expect(text.style?.decoration, TextDecoration.lineThrough);
  });

  // ============================================================
  // T03 – 样式优先级：P0 style 覆盖构造器糖
  // ============================================================
  testWidgets('T03 - P0 style.color 覆盖 textColor', (tester) async {
    await tester.pumpWidget(
      wrapWithTheme(
        const TText(
          '样式覆盖',
          textColor: Colors.blue,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('样式覆盖'));
    expect(text.style?.color, Colors.red); // P0 style 优先
  });

  testWidgets('T03b - P0 style.fontSize 覆盖构造器 Font', (tester) async {
    await tester.pumpWidget(
      wrapWithTheme(
        TText(
          '字体覆盖',
          font: Font(size: 14, lineHeight: 20),
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('字体覆盖'));
    expect(text.style?.fontSize, 24); // P0 优先
    // height 仍使用构造器的（style 未覆写），Font 内部已是因子
    expect(text.style?.height, 20 / 14);
  });

  // ============================================================
  // T04 – TTextThemeData 子树默认值
  // ============================================================
  testWidgets('T04 - TTextThemeData.context 提供默认颜色', (tester) async {
    await tester.pumpWidget(
      wrapWithTheme(
        const TText('主题文本'),
        textTheme: const TTextThemeData(defaultTextColor: Colors.orange),
      ),
    );

    final text = tester.widget<Text>(find.text('主题文本'));
    expect(text.style?.color, Colors.orange);
  });

  testWidgets('T04b - 构造器 textColor 覆盖 TTextThemeData', (tester) async {
    await tester.pumpWidget(
      wrapWithTheme(
        const TText('覆盖主题', textColor: Colors.green),
        textTheme: const TTextThemeData(defaultTextColor: Colors.orange),
      ),
    );

    final text = tester.widget<Text>(find.text('覆盖主题'));
    expect(text.style?.color, Colors.green); // 构造器优先于 Theme
  });

  testWidgets('T04d - TTextThemeData.defaultFont 覆盖 Token', (tester) async {
    await tester.pumpWidget(
      wrapWithTheme(
        const TText('字体主题'),
        textTheme: TTextThemeData(defaultFont: Font(size: 22, lineHeight: 30)),
      ),
    );

    final text = tester.widget<Text>(find.text('字体主题'));
    expect(text.style?.fontSize, 22);
    expect(text.style?.height, 30 / 22); // Font 内部已是因子
  });

  // ============================================================
  // T05 – TTextConfiguration 全局字体注入
  // ============================================================
  testWidgets('T05 - TTextConfiguration.globalFontFamily 生效', (tester) async {
    await tester.pumpWidget(
      wrapWithTheme(
        TTextConfiguration(
          globalFontFamily: FontFamily(fontFamily: 'TestFont'),
          child: const TText('全局字体'),
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('全局字体'));
    expect(text.style?.fontFamily, 'TestFont');
  });

  testWidgets('T05b - 构造器 fontFamily 覆盖 globalFontFamily', (tester) async {
    await tester.pumpWidget(
      wrapWithTheme(
        TTextConfiguration(
          globalFontFamily: FontFamily(fontFamily: 'GlobalFont'),
          child: TText(
            '实例字体',
            fontFamily: FontFamily(fontFamily: 'InstanceFont'),
          ),
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('实例字体'));
    expect(text.style?.fontFamily, 'InstanceFont');
  });

  testWidgets('T05c - globalFontFamily 覆盖组件 Theme 默认字体', (tester) async {
    await tester.pumpWidget(
      wrapWithTheme(
        TTextConfiguration(
          globalFontFamily: FontFamily(fontFamily: 'GlobalFont'),
          child: const TText('全局优先'),
        ),
        textTheme: TTextThemeData(
          defaultFontFamily: FontFamily(fontFamily: 'ThemeFont'),
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('全局优先'));
    expect(text.style?.fontFamily, 'GlobalFont');
  });

  testWidgets('T05d - DefaultTextStyle 控制未显式指定的文本样式', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: [TThemeData.defaultData()]),
        home: const Scaffold(
          body: DefaultTextStyle(
            style: TextStyle(color: Colors.pink, fontSize: 21, height: 1.7),
            child: TText('Flutter默认文本'),
          ),
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('Flutter默认文本'));
    expect(text.style?.color, Colors.pink);
    expect(text.style?.fontSize, 21);
    expect(text.style?.height, 1.7);
  });

  testWidgets('T05e - ThemeData.textTheme 控制未显式指定的文本样式', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: [TThemeData.defaultData()],
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.indigo, fontSize: 19),
          ),
        ),
        home: const Scaffold(body: TText('Material默认文本')),
      ),
    );

    final text = tester.widget<Text>(find.text('Material默认文本'));
    expect(text.style?.color, Colors.indigo);
    expect(text.style?.fontSize, 19);
  });

  testWidgets('T05f - TTextThemeData 既有字段作为子树默认值生效', (tester) async {
    const textHeightBehavior = TextHeightBehavior(
      applyHeightToFirstAscent: false,
      applyHeightToLastDescent: false,
    );
    const strutStyle = StrutStyle(fontSize: 17, height: 1.3);
    await tester.pumpWidget(
      wrapWithTheme(
        const TText('主题字段'),
        textTheme: const TTextThemeData(
          defaultBackgroundColor: Colors.cyan,
          strutStyle: strutStyle,
          textWidthBasis: TextWidthBasis.longestLine,
          textHeightBehavior: textHeightBehavior,
          textScaleFactor: 1.2,
        ),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container).first);
    expect(container.color, Colors.cyan);

    final text = tester.widget<Text>(find.text('主题字段'));
    expect(text.strutStyle, strutStyle);
    expect(text.textWidthBasis, TextWidthBasis.longestLine);
    expect(text.textHeightBehavior, textHeightBehavior);
    expect(text.textScaler?.scale(10), 12);
  });

  // ============================================================
  // T06 – TTextConfiguration.updateShouldNotify
  // ============================================================
  testWidgets('T06 - globalFontFamily 变更触发子树重建', (tester) async {
    const childKey = Key('test_child');
    await tester.pumpWidget(
      wrapWithTheme(
        TTextConfiguration(
          globalFontFamily: FontFamily(fontFamily: 'FontA'),
          child: Container(key: childKey, child: const TText('文本')),
        ),
      ),
    );

    final text1 = tester.widget<Text>(find.text('文本'));
    expect(text1.style?.fontFamily, 'FontA');

    // 切换全局字体
    await tester.pumpWidget(
      wrapWithTheme(
        TTextConfiguration(
          globalFontFamily: FontFamily(fontFamily: 'FontB'),
          child: Container(key: childKey, child: const TText('文本')),
        ),
      ),
    );

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
    await tester.pumpWidget(
      wrapWithTheme(
        TText.rich(
          TextSpan(
            children: [
              TTextSpan(
                text: '富文本',
                textColor: Colors.teal,
                font: Font(size: 16, lineHeight: 24),
              ),
            ],
          ),
        ),
      ),
    );

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
      defaultFontWeight: FontWeight.w600,
    );
    final copied = original.copyWith(defaultTextColor: Colors.blue);

    expect(copied.defaultTextColor, Colors.blue);
    expect(copied.defaultFontWeight, FontWeight.w600);
    expect(copied.defaultFont, isNull);
  });

  test('T08b - lerp 过渡计算', () {
    const red = Color(0xFFF44336);
    const blue = Color(0xFF2196F3);
    const a = TTextThemeData(defaultTextColor: red);
    const b = TTextThemeData(defaultTextColor: blue);

    final lerped = a.lerp(b, 0.0);
    expect(lerped.defaultTextColor, red);

    final lerped2 = a.lerp(b, 1.0);
    expect(lerped2.defaultTextColor, blue);
  });

  // ============================================================
  // T11 – getRawText 互操作
  // ============================================================
  testWidgets('T11 - getRawText 返回系统 Text', (tester) async {
    await tester.pumpWidget(
      wrapWithTheme(
        Builder(
          builder: (context) {
            final rawText = const TText(
              '原始文本',
              backgroundColor: Colors.yellow,
            ).getRawText(context: context);

            return rawText;
          },
        ),
      ),
    );

    expect(find.text('原始文本'), findsOneWidget);
    // getRawText 返回的是系统 Text（非 TText）
    expect(find.byType(TText), findsNothing);
  });

  // ============================================================
  // T13 – backgroundColor 使用 Container 而非 TextStyle.background
  // ============================================================
  testWidgets('T13 - backgroundColor 通过 Container 渲染', (tester) async {
    await tester.pumpWidget(
      wrapWithTheme(const TText('背景色', backgroundColor: Colors.amber)),
    );

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
    await tester.pumpWidget(
      wrapWithTheme(
        TText.rich(
          TextSpan(children: [TTextSpan(text: '子文本')]),
          textColor: Colors.teal,
        ),
      ),
    );

    final richText = tester.widget<RichText>(find.byType(RichText).last);
    final rootSpan = richText.text as TextSpan;

    // 父级样式通过 TextSpan.style 应用（TText.rich 的 textColor 会反映在根 style）
    expect(rootSpan.style?.color, Colors.teal);
  });
}
