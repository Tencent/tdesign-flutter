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
    final original = TTextThemeData(
      font: Font(size: 16, lineHeight: 24),
      textStyle: const TextStyle(color: Colors.red),
    );
    final copied = original.copyWith(
      textStyle: const TextStyle(color: Colors.blue),
    );
    expect(copied.font, original.font);
    expect(copied.textStyle?.color, Colors.blue);
    expect(
      original
          .lerp(
            const TTextThemeData(textStyle: TextStyle(color: Colors.blue)),
            1,
          )
          .textStyle
          ?.color,
      isSameColorAs(Colors.blue),
    );
  });
}
