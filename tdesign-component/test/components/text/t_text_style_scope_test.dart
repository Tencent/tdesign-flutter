import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/text/t_text_style_scope.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  testWidgets('组合组件样式同时到达 TText 和原生 Text', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: const Scaffold(
          body: TTextStyleScope(
            style: TextStyle(
              color: Colors.deepPurple,
              fontSize: 18,
              height: 1.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            child: Column(children: [TText('TDesign'), Text('原生')]),
          ),
        ),
      ),
    );

    final tdesign = tester.widget<Text>(find.text('TDesign'));
    final native = tester.widget<Text>(find.text('原生'));
    final nativeDefault = DefaultTextStyle.of(tester.element(find.text('原生')));
    expect(tdesign.style?.color, Colors.deepPurple);
    expect(tdesign.style?.fontSize, 18);
    expect(tdesign.style?.height, 1.5);
    expect(native.style, isNull);
    expect(nativeDefault.style.color, Colors.deepPurple);
    expect(nativeDefault.maxLines, 1);
    expect(nativeDefault.overflow, TextOverflow.ellipsis);
    expect(nativeDefault.softWrap, isFalse);
  });

  testWidgets('保留父 TText Theme 段落字段，插槽和实例样式逐级覆盖', (tester) async {
    final theme = TThemeBuilder.light(TThemeData.defaultData()).mergeExtension(
      const TTextThemeData(
        textStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
        textWidthBasis: TextWidthBasis.longestLine,
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: const Scaffold(
          body: TTextStyleScope(
            style: TextStyle(fontSize: 20),
            child: Column(
              children: [
                TText('继承'),
                TText('实例', style: TextStyle(color: Colors.orange)),
              ],
            ),
          ),
        ),
      ),
    );

    final inherited = tester.widget<Text>(find.text('继承'));
    final instance = tester.widget<Text>(find.text('实例'));
    expect(inherited.style?.fontSize, 20);
    expect(inherited.style?.color, Colors.blue);
    expect(inherited.style?.fontWeight, FontWeight.w600);
    expect(inherited.textWidthBasis, TextWidthBasis.longestLine);
    expect(instance.style?.color, Colors.orange);
    expect(instance.style?.fontSize, 20);
  });
}
