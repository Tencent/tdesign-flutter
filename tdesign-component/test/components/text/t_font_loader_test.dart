import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 覆盖 [TFontLoaderWidget] 的 build/initState，以及 [TFontLoader.load] 的异常分支。
///
/// 说明：真正的网络字体下载（FontLoader + NetworkAssetBundle）属平台/网络依赖，
/// 在测试环境不可达，标记为已知例外；本测试覆盖非网络路径与失败回退分支。
void main() {
  Widget wrap(Widget child) => Theme(
    data: ThemeData(extensions: [TThemeData.defaultData()]),
    child: MaterialApp(home: Scaffold(body: child)),
  );

  group('TFontLoader', () {
    test('load 传入非法 URL 进入 catch 分支并返回 false', () async {
      // 非法 URI 触发 Uri.parse 抛异常 -> 被 catch 捕获 -> 返回 false
      final result = await TFontLoader.load(
        name: 'bad',
        fontFamilyUrl: '::invalid::',
      );
      expect(result, isFalse);
    });
  });

  group('TFontLoaderWidget', () {
    testWidgets('TText 设置 fontFamilyUrl 触发懒加载 Widget（不实际下载）', (tester) async {
      // fontFamily 为 null，loadFont 内部 if 为 false，跳过网络请求，仅构建
      await tester.pumpWidget(
        wrap(const TText('加载字体', fontFamilyUrl: 'http://example.com/font.ttf')),
      );
      // 内部回退渲染出一个 TText
      expect(find.byType(TText), findsWidgets);
    });

    testWidgets('空 fontFamilyUrl 跳过加载并保持回退渲染', (tester) async {
      await tester.pumpWidget(
        wrap(
          TFontLoaderWidget(
            textWidget: TText(
              '空地址',
              fontFamily: FontFamily(fontFamily: 'NoLoadFont'),
            ),
            fontFamilyUrl: '',
          ),
        ),
      );
      await tester.pump();

      expect(find.text('空地址'), findsOneWidget);
      expect(
        tester
            .widgetList<TText>(find.byType(TText))
            .any((text) => text.data == '空地址' && text.isInFontLoader),
        isTrue,
      );
    });

    testWidgets('富文本加载回退不会丢失 textSpan', (tester) async {
      await tester.pumpWidget(
        wrap(
          const TFontLoaderWidget(
            textWidget: TText.rich(
              TextSpan(
                children: [
                  TextSpan(text: '富文本'),
                  TextSpan(text: '内容'),
                ],
              ),
            ),
            fontFamilyUrl: '',
          ),
        ),
      );

      expect(find.text('富文本内容', findRichText: true), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('空 fontFamily 跳过加载并保持回退渲染', (tester) async {
      await tester.pumpWidget(
        wrap(
          TText(
            '空字体名',
            fontFamily: FontFamily(fontFamily: ''),
            fontFamilyUrl: 'http://example.com/font.ttf',
          ),
        ),
      );
      await tester.pump();

      expect(find.text('空字体名'), findsOneWidget);
      expect(
        tester
            .widgetList<TText>(find.byType(TText))
            .any((text) => text.data == '空字体名' && text.isInFontLoader),
        isTrue,
      );
    });

    testWidgets('fontFamily + 非空 URL 进入加载失败回退分支', (tester) async {
      await tester.pumpWidget(
        wrap(
          TText(
            '加载失败回退',
            fontFamily: FontFamily(fontFamily: 'BadFontForTest'),
            fontFamilyUrl: '::invalid::',
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 10));

      expect(find.text('加载失败回退'), findsOneWidget);
    });
  });
}
