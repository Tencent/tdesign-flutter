import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child) {
    final theme = TThemeBuilder.light(TThemeData.defaultData());
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: child),
    );
  }

  group('TTitle', () {
    testWidgets('h1 映射 fontHeadlineLarge', (tester) async {
      await tester.pumpWidget(wrap(const TTitle('标题', level: TTitleLevel.h1)));
      final text = tester.widget<Text>(find.text('标题'));
      final token = tester.element(find.text('标题')).tTheme.fontHeadlineLarge;
      expect(text.style?.fontSize, token?.size);
      expect(text.style?.height, token?.height);
    });

    testWidgets('h6 映射 fontTitleSmall', (tester) async {
      await tester.pumpWidget(wrap(const TTitle('标题', level: TTitleLevel.h6)));
      final text = tester.widget<Text>(find.text('标题'));
      final token = tester.element(find.text('标题')).tTheme.fontTitleSmall;
      expect(text.style?.fontSize, token?.size);
      expect(text.style?.height, token?.height);
    });

    testWidgets('默认 level 为 h1', (tester) async {
      await tester.pumpWidget(wrap(const TTitle('标题')));
      final text = tester.widget<Text>(find.text('标题'));
      final token = tester.element(find.text('标题')).tTheme.fontHeadlineLarge;
      expect(text.style?.fontSize, token?.size);
    });
  });

  group('TParagraph', () {
    testWidgets('默认字号为 fontBodyMedium', (tester) async {
      await tester.pumpWidget(wrap(const TParagraph('段落')));
      final text = tester.widget<Text>(find.text('段落'));
      final token = tester.element(find.text('段落')).tTheme.fontBodyMedium;
      expect(text.style?.fontSize, token?.size);
      expect(text.style?.height, token?.height);
    });
  });

  group('TTypography', () {
    testWidgets('text 子组件构造 TText', (tester) async {
      await tester.pumpWidget(wrap(TTypography.text('基础文本')));
      expect(find.text('基础文本'), findsOneWidget);
    });

    testWidgets('title 子组件构造 TTitle', (tester) async {
      await tester.pumpWidget(
        wrap(TTypography.title('标题', level: TTitleLevel.h2)),
      );
      final text = tester.widget<Text>(find.text('标题'));
      final token = tester.element(find.text('标题')).tTheme.fontHeadlineMedium;
      expect(text.style?.fontSize, token?.size);
    });

    testWidgets('paragraph 子组件构造 TParagraph', (tester) async {
      await tester.pumpWidget(wrap(TTypography.paragraph('段落')));
      final text = tester.widget<Text>(find.text('段落'));
      final token = tester.element(find.text('段落')).tTheme.fontBodyMedium;
      expect(text.style?.fontSize, token?.size);
    });
  });

  group('TText interactive', () {
    testWidgets('copyable 显示复制图标并回调 onCopied', (tester) async {
      var copied = false;
      await tester.pumpWidget(
        wrap(
          TText(
            '可复制文本',
            copyable: true,
            onCopied: () => copied = true,
          ),
        ),
      );
      expect(find.text('可复制文本'), findsOneWidget);
      expect(find.byType(TIcon), findsOneWidget);

      await tester.tap(find.byType(TIcon));
      await tester.pump();
      expect(copied, isTrue);
      // 复制成功后切换到 check 图标
      expect(
        tester.widget<TIcon>(find.byType(TIcon)).icon,
        TIcons.check,
      );
    });

    testWidgets('expandable 展开收起回调', (tester) async {
      bool? lastState;
      await tester.pumpWidget(
        wrap(
          TText(
            '这是一段用于测试展开收起能力的较长文本内容，'
            '默认显示两行，展开后可查看完整内容。',
            maxLines: 2,
            expandable: true,
            onExpandedChange: (v) => lastState = v,
          ),
        ),
      );
      expect(find.text('展开'), findsOneWidget);
      await tester.tap(find.text('展开'));
      await tester.pump();
      expect(lastState, isTrue);
      expect(find.text('收起'), findsOneWidget);
    });

    testWidgets('受控 expanded 由外部驱动', (tester) async {
      var lastState = false;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) {
              return TText(
                '受控展开的文本内容用于测试外部驱动状态',
                maxLines: 2,
                expandable: true,
                expanded: lastState,
                onExpandedChange: (v) {
                  setState(() => lastState = v);
                },
              );
            },
          ),
        ),
      );
      expect(find.text('展开'), findsOneWidget);
      await tester.tap(find.text('展开'));
      await tester.pump();
      expect(lastState, isTrue);
      expect(find.text('收起'), findsOneWidget);
    });
  });
}
