import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 覆盖 [TSelectTag] 的选中/未选中、colorScheme、icon、size 与 onChanged 分支。
void main() {
  Widget wrap(Widget child, {TTagThemeData? tagTheme}) {
    var theme = TThemeBuilder.light(TThemeData.defaultData());
    if (tagTheme != null) {
      theme = theme.mergeExtension(tagTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: child),
    );
  }

  group('TSelectTag', () {
    testWidgets('未选中且无回调（defaultTheme）', (tester) async {
      await tester.pumpWidget(wrap(
        const TSelectTag('标签', value: false),
      ));
      expect(find.byType(TSelectTag), findsOneWidget);
      expect(find.text('标签'), findsOneWidget);
    });

    testWidgets('文字垂直居中且宽度按内容自适应', (tester) async {
      await tester.pumpWidget(wrap(
        const TSelectTag('居中', value: false),
      ));

      final tagContainerFinder = find.descendant(
        of: find.byType(TSelectTag),
        matching: find.byWidgetPredicate(
          (widget) => widget is Container && widget.decoration is BoxDecoration,
        ),
      );
      final tagRect = tester.getRect(tagContainerFinder.first);
      final textRect = tester.getRect(find.text('居中'));
      final textWidget = tester.widget<Text>(find.text('居中'));

      expect((tagRect.center.dy - textRect.center.dy).abs(), lessThan(1));
      expect(tagRect.width, lessThan(120));
      expect(textWidget.style?.height, isNull);
    });

    testWidgets('未选中带 onChanged，点击触发取反回调', (tester) async {
      var changed = false;
      await tester.pumpWidget(wrap(
        TSelectTag(
          '点击',
          value: false,
          colorScheme: TTagColorScheme.primary,
          icon: Icons.star,
          size: TTagSize.small,
          onChanged: (v) => changed = v,
        ),
      ));
      expect(find.byType(TSelectTag), findsOneWidget);
      // 点击触发 onChanged（取反：false -> true）
      await tester.tap(find.byType(TSelectTag));
      await tester.pump();
      expect(changed, isTrue);
    });

    testWidgets('选中态带 colorScheme/icon/size 且 onChanged 为 null',
        (tester) async {
      await tester.pumpWidget(wrap(
        const TSelectTag(
          '选中',
          value: true,
          colorScheme: TTagColorScheme.danger,
          icon: Icons.check,
          size: TTagSize.large,
        ),
      ));
      expect(find.byType(TSelectTag), findsOneWidget);

      final token = TThemeData.defaultData();
      final tagContainer = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(TSelectTag),
              matching: find.byWidgetPredicate(
                (widget) =>
                    widget is Container && widget.decoration is BoxDecoration,
              ),
            )
            .first,
      );
      final decoration = tagContainer.decoration as BoxDecoration;
      final text = tester.widget<Text>(find.text('选中'));
      final icon = tester.widget<Icon>(find.byIcon(Icons.check));

      expect(decoration.color, token.errorNormalColor);
      expect(text.style?.color, token.textColorAnti);
      expect(icon.color, token.textColorAnti);
      expect(text.style?.color, isNot(token.textDisabledColor));
    });
  });
}
