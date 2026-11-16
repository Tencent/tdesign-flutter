import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  // 小尺寸按钮的文字应在垂直方向居中（issue #1233）。
  // TextStyle.height 会引入行高余量，默认 leadingDistribution=proportional
  // 按字体 ascent/descent 分配，ascent 更大时文字视觉偏下。
  for (final size in TButtonSize.values) {
    testWidgets('label is vertically centred size=${size.name}', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TButton(
                size: size,
                onPressed: () {},
                child: const Text('OK'),
              ),
            ),
          ),
        ),
      );

      final paragraph = tester.renderObject<RenderParagraph>(
        find.descendant(of: find.byType(TButton), matching: find.byType(RichText)),
      );
      final style = paragraph.text.style!;
      print('SIZE=${size.name} fontSize=${style.fontSize} height=${style.height} leading=${style.leadingDistribution}');

      expect(
        style.leadingDistribution,
        TextLeadingDistribution.even,
        reason: 'size=${size.name} 的文字行高余量应上下均分，否则视觉偏下',
      );
    });
  }
}
