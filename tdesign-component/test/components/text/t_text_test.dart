import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class _NonlinearTextScaler extends TextScaler {
  const _NonlinearTextScaler();

  @override
  double scale(double fontSize) =>
      fontSize < 20 ? fontSize * 1.8 : fontSize * 1.4;

  @override
  double get textScaleFactor => 1.4;
}

void main() {
  Widget wrap(Widget child, {TTextThemeData? textTheme}) {
    var theme = TThemeBuilder.light(TThemeData.defaultData());
    if (textTheme != null) {
      theme = theme.mergeExtension(textTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: child),
    );
  }

  testWidgets('默认使用 TDesign bodyLarge Token', (tester) async {
    await tester.pumpWidget(wrap(const TText('文本')));
    final text = tester.widget<Text>(find.text('文本'));
    final context = tester.element(find.text('文本'));
    expect(text.style?.fontSize, context.tTheme.fontBodyLarge?.size);
    expect(text.style?.height, context.tTheme.fontBodyLarge?.height);
    expect(text.style?.color, context.tTheme.textColorPrimary);
  });

  testWidgets('未设置 textScaler 时继承 MediaQuery 非线性缩放器', (tester) async {
    const scaler = _NonlinearTextScaler();
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(textScaler: scaler),
          child: Scaffold(body: TText('缩放')),
        ),
      ),
    );
    final text = tester.widget<Text>(find.text('缩放'));
    final richText = tester.widget<RichText>(find.byType(RichText).last);
    expect(text.textScaler, isNull);
    expect(richText.textScaler.scale(10), 18);
    expect(richText.textScaler.scale(30), 42);
  });

  testWidgets('显式 textScaler、语义标识和选区颜色透传', (tester) async {
    const scaler = TextScaler.linear(1.2);
    await tester.pumpWidget(
      wrap(
        const TText(
          '原生参数',
          textScaler: scaler,
          semanticsIdentifier: 'text-id',
          selectionColor: Colors.cyan,
        ),
      ),
    );
    final text = tester.widget<Text>(find.text('原生参数'));
    expect(text.textScaler, scaler);
    expect(text.semanticsIdentifier, 'text-id');
    expect(text.selectionColor, Colors.cyan);
  });

  testWidgets('Theme font/textStyle 和段落字段生效', (tester) async {
    const heightBehavior = TextHeightBehavior(
      applyHeightToFirstAscent: false,
      applyHeightToLastDescent: false,
    );
    const strut = StrutStyle(fontSize: 18, height: 1.3);
    await tester.pumpWidget(
      wrap(
        const TText('主题'),
        textTheme: TTextThemeData(
          font: Font(size: 18, lineHeight: 26),
          textStyle: const TextStyle(color: Colors.orange),
          strutStyle: strut,
          textWidthBasis: TextWidthBasis.longestLine,
          textHeightBehavior: heightBehavior,
        ),
      ),
    );
    final text = tester.widget<Text>(find.text('主题'));
    expect(text.style?.fontSize, 18);
    expect(text.style?.height, 26 / 18);
    expect(text.style?.color, Colors.orange);
    expect(text.strutStyle, strut);
    expect(text.textWidthBasis, TextWidthBasis.longestLine);
    expect(text.textHeightBehavior, heightBehavior);
  });

  testWidgets('实例 style 覆盖便利参数且 Paint 不触发断言', (tester) async {
    final foreground = Paint()..color = Colors.purple;
    await tester.pumpWidget(
      wrap(
        TText(
          'Paint',
          textColor: Colors.blue,
          style: TextStyle(foreground: foreground),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    final text = tester.widget<Text>(find.text('Paint'));
    expect(text.style?.foreground, foreground);
    expect(text.style?.color, isNull);
  });

  test('裸 TTextSpan 保持空样式', () {
    final span = TTextSpan(
      text: '继承',
      semanticsIdentifier: 'span-id',
      locale: const Locale('zh', 'CN'),
      spellOut: false,
    );
    expect(span.style, isNull);
    expect(span.semanticsIdentifier, 'span-id');
    expect(span.locale, const Locale('zh', 'CN'));
    expect(span.spellOut, isFalse);
  });

  testWidgets('TText.rich 根样式与 TTextSpan 局部样式组合', (tester) async {
    final child = TTextSpan(text: '子文本', textColor: Colors.red);
    await tester.pumpWidget(
      wrap(
        TText.rich(
          TextSpan(children: [child]),
          font: Font(size: 24, lineHeight: 32),
          textColor: Colors.blue,
        ),
      ),
    );
    expect(find.text('子文本'), findsOneWidget);
    expect(child.style?.color, Colors.red);
    expect(child.style?.fontSize, isNull);
  });

  testWidgets('getRawText 复用全部原生参数和样式解析', (tester) async {
    const source = TText(
      '原生 Text',
      textColor: Colors.teal,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      semanticsIdentifier: 'raw-id',
    );
    await tester.pumpWidget(
      wrap(Builder(builder: (context) => source.getRawText(context: context))),
    );
    expect(find.byType(TText), findsNothing);
    final text = tester.widget<Text>(find.text('原生 Text'));
    expect(text.style?.color, Colors.teal);
    expect(text.maxLines, 1);
    expect(text.overflow, TextOverflow.ellipsis);
    expect(text.semanticsIdentifier, 'raw-id');
  });

  testWidgets('父 Center 负责行盒垂直居中', (tester) async {
    await tester.pumpWidget(
      wrap(
        const SizedBox(
          key: Key('box'),
          width: 160,
          height: 80,
          child: Center(child: TText('中文 English 😀')),
        ),
      ),
    );
    final boxCenter = tester.getCenter(find.byKey(const Key('box')));
    final textCenter = tester.getCenter(find.text('中文 English 😀'));
    expect(textCenter.dy, closeTo(boxCenter.dy, 0.01));
  });

  testWidgets('不同线性缩放下行盒保持几何居中且不裁切', (tester) async {
    final heights = <double>[];

    for (final scale in const [1.0, 1.5, 2.0]) {
      await tester.pumpWidget(
        wrap(
          SizedBox(
            key: const Key('scaled-box'),
            width: 240,
            height: 96,
            child: Center(
              child: TText(
                '中文 English 😀',
                key: const Key('scaled-text'),
                textScaler: TextScaler.linear(scale),
              ),
            ),
          ),
        ),
      );

      final boxRect = tester.getRect(find.byKey(const Key('scaled-box')));
      final textRect = tester.getRect(find.byKey(const Key('scaled-text')));
      heights.add(textRect.height);

      expect(textRect.center.dy, closeTo(boxRect.center.dy, 0.01));
      expect(textRect.top, greaterThanOrEqualTo(boxRect.top));
      expect(textRect.bottom, lessThanOrEqualTo(boxRect.bottom));
      expect(tester.takeException(), isNull);
    }

    expect(heights[1], greaterThan(heights[0]));
    expect(heights[2], greaterThan(heights[1]));
  });

  testWidgets('中文英文 emoji 多行混排在缩放后不裁切', (tester) async {
    const content = '中文 English 😀\n第二行 Mixed text 🚀';
    await tester.pumpWidget(
      wrap(
        const SizedBox(
          key: Key('multiline-box'),
          width: 240,
          height: 144,
          child: Center(
            child: TText(
              content,
              key: Key('multiline-text'),
              textScaler: TextScaler.linear(2),
            ),
          ),
        ),
      ),
    );

    final boxRect = tester.getRect(find.byKey(const Key('multiline-box')));
    final textRect = tester.getRect(find.byKey(const Key('multiline-text')));
    final paragraph = tester.renderObject<RenderParagraph>(
      find.byKey(const Key('multiline-text')),
    );

    expect(textRect.center.dy, closeTo(boxRect.center.dy, 0.01));
    expect(textRect.top, greaterThanOrEqualTo(boxRect.top));
    expect(textRect.bottom, lessThanOrEqualTo(boxRect.bottom));
    expect(paragraph.didExceedMaxLines, isFalse);
    expect(textRect.height, greaterThan(48));
    expect(tester.takeException(), isNull);
  });

  testWidgets('父 Row.center 负责图标与文字的中心对齐', (tester) async {
    await tester.pumpWidget(
      wrap(
        const SizedBox(
          height: 64,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.info, key: Key('center-icon'), size: 24),
              SizedBox(width: 8),
              TText('中文 English 😀', key: Key('center-text')),
            ],
          ),
        ),
      ),
    );

    final iconCenter = tester.getCenter(find.byKey(const Key('center-icon')));
    final textCenter = tester.getCenter(find.byKey(const Key('center-text')));
    expect(textCenter.dy, closeTo(iconCenter.dy, 0.01));
  });

  testWidgets('TText.rich 使用与普通文本一致的父级居中契约', (tester) async {
    await tester.pumpWidget(
      wrap(
        const SizedBox(
          key: Key('rich-box'),
          width: 200,
          height: 80,
          child: Center(
            child: TText.rich(
              TextSpan(
                children: [
                  TextSpan(text: '中文 '),
                  TextSpan(text: 'English', style: TextStyle(fontSize: 20)),
                  TextSpan(text: ' 😀'),
                ],
              ),
              key: Key('rich-text'),
            ),
          ),
        ),
      ),
    );

    final boxRect = tester.getRect(find.byKey(const Key('rich-box')));
    final textRect = tester.getRect(find.byKey(const Key('rich-text')));
    expect(textRect.center.dy, closeTo(boxRect.center.dy, 0.01));
    expect(textRect.top, greaterThanOrEqualTo(boxRect.top));
    expect(textRect.bottom, lessThanOrEqualTo(boxRect.bottom));
  });

  testWidgets('父级 baseline 布局同时支持 TText 与原生 Text', (tester) async {
    await tester.pumpWidget(
      wrap(
        const Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            TText('中文 😀', style: TextStyle(fontSize: 24)),
            Text('English', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
    final tTextRender = tester.renderObject<RenderParagraph>(
      find.text('中文 😀'),
    );
    final nativeRender = tester.renderObject<RenderParagraph>(
      find.text('English'),
    );
    final tTextBaseline =
        tester.getTopLeft(find.text('中文 😀')).dy +
        tTextRender.getDryBaseline(
          BoxConstraints.tight(tTextRender.size),
          TextBaseline.alphabetic,
        )!;
    final nativeBaseline =
        tester.getTopLeft(find.text('English')).dy +
        nativeRender.getDryBaseline(
          BoxConstraints.tight(nativeRender.size),
          TextBaseline.alphabetic,
        )!;
    expect(tTextBaseline, closeTo(nativeBaseline, 0.01));
  });

  test('TTextThemeData copyWith 与 lerp 使用统一字段', () {
    const textHeightBehavior = TextHeightBehavior(
      applyHeightToFirstAscent: false,
    );
    final original = TTextThemeData(
      font: Font(size: 16, lineHeight: 24),
      textStyle: const TextStyle(color: Colors.red),
      strutStyle: const StrutStyle(fontSize: 16),
      textWidthBasis: TextWidthBasis.longestLine,
      textHeightBehavior: textHeightBehavior,
    );
    final copied = original.copyWith(
      textStyle: const TextStyle(color: Colors.blue),
    );
    expect(copied.font, original.font);
    expect(copied.textStyle?.color, Colors.blue);
    expect(copied.strutStyle, original.strutStyle);
    expect(copied.textWidthBasis, original.textWidthBasis);
    expect(copied.textHeightBehavior, original.textHeightBehavior);
    expect(original.lerp(null, 0), same(original));
    final other = TTextThemeData(
      font: Font(size: 20, lineHeight: 28),
      textStyle: const TextStyle(color: Colors.blue),
      strutStyle: const StrutStyle(fontSize: 20),
      textWidthBasis: TextWidthBasis.parent,
      textHeightBehavior: const TextHeightBehavior(
        applyHeightToLastDescent: false,
      ),
    );
    final beforeMidpoint = original.lerp(other, 0.25);
    expect(beforeMidpoint.font, same(original.font));
    expect(beforeMidpoint.strutStyle, original.strutStyle);
    expect(beforeMidpoint.textWidthBasis, original.textWidthBasis);
    expect(beforeMidpoint.textHeightBehavior, original.textHeightBehavior);
    expect(
      original.lerp(other, 1).textStyle?.color,
      isSameColorAs(Colors.blue),
    );
    final afterMidpoint = original.lerp(other, 0.75);
    expect(afterMidpoint.font, same(other.font));
    expect(afterMidpoint.strutStyle, other.strutStyle);
    expect(afterMidpoint.textWidthBasis, other.textWidthBasis);
    expect(afterMidpoint.textHeightBehavior, other.textHeightBehavior);
  });
}
