import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 覆盖 [TSelectTag] 的选中/未选中、colorScheme、variant、icon、size 与 onChanged 分支。
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
    testWidgets('选中 success 继承 Tag 组件色，未选中不套用 success 色', (tester) async {
      const success = Color(0xFF126B43);
      const successLight = Color(0xFFB1E7C3);
      final onChanged = (bool _) {};
      await tester.pumpWidget(
        wrap(
          Column(
            children: [
              TSelectTag(
                '选中成功',
                value: true,
                onChanged: onChanged,
                colorScheme: TTagColorScheme.success,
                variant: TTagVariant.light,
              ),
              TSelectTag(
                '未选成功',
                value: false,
                onChanged: onChanged,
                colorScheme: TTagColorScheme.success,
                variant: TTagVariant.light,
              ),
            ],
          ),
          tagTheme: const TTagThemeData(
            successColor: success,
            successLightColor: successLight,
          ),
        ),
      );

      Color? fill(String label) {
        final container = tester.widget<Container>(
          find
              .descendant(
                of: find.widgetWithText(TSelectTag, label),
                matching: find.byWidgetPredicate(
                  (widget) =>
                      widget is Container && widget.decoration is BoxDecoration,
                ),
              )
              .first,
        );
        return (container.decoration! as BoxDecoration).color;
      }

      expect(fill('选中成功'), successLight);
      expect(tester.widget<Text>(find.text('选中成功')).style!.color, success);
      expect(fill('未选成功'), isNot(successLight));
    });

    testWidgets('未选中且无回调（defaultTheme）', (tester) async {
      await tester.pumpWidget(wrap(const TSelectTag('标签', value: false)));
      expect(find.byType(TSelectTag), findsOneWidget);
      expect(find.text('标签'), findsOneWidget);

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
      final text = tester.widget<Text>(find.text('标签'));
      expect(decoration.color, token.bgColorComponentDisabled);
      expect(text.style?.color, token.textColorDisabled);
    });

    testWidgets('文字垂直居中且宽度按内容自适应', (tester) async {
      await tester.pumpWidget(wrap(const TSelectTag('居中', value: false)));

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
      await tester.pumpWidget(
        wrap(
          TSelectTag(
            '点击',
            value: false,
            colorScheme: TTagColorScheme.primary,
            variant: TTagVariant.light,
            icon: Icons.star,
            size: TTagSize.small,
            onChanged: (v) => changed = v,
          ),
        ),
      );
      expect(find.byType(TSelectTag), findsOneWidget);
      // 点击触发 onChanged（取反：false -> true）
      await tester.tap(find.byType(TSelectTag));
      await tester.pump();
      expect(changed, isTrue);
      expect(tester.widget<TTag>(find.byType(TTag)).variant, TTagVariant.light);
    });

    testWidgets('无 onChanged 时使用禁用态，即使 value 为 true', (tester) async {
      await tester.pumpWidget(
        wrap(
          const TSelectTag(
            '选中',
            value: true,
            colorScheme: TTagColorScheme.danger,
            icon: Icons.check,
            size: TTagSize.large,
          ),
        ),
      );
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

      expect(decoration.color, token.bgColorComponentDisabled);
      expect(text.style?.color, token.textColorDisabled);
      expect(icon.color, token.textColorDisabled);
    });

    testWidgets('选中 danger 继承 Tag 组件 Token，未选中不受影响', (tester) async {
      const customDanger = Color(0xFF123ABC);
      Widget selected(bool value) => wrap(
        TSelectTag(
          '可选危险',
          value: value,
          colorScheme: TTagColorScheme.danger,
          onChanged: (_) {},
        ),
        tagTheme: const TTagThemeData(dangerColor: customDanger),
      );

      BoxDecoration decoration() {
        final container = tester.widget<Container>(
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
        return container.decoration! as BoxDecoration;
      }

      await tester.pumpWidget(selected(true));
      expect(decoration().color, customDanger);
      await tester.pumpWidget(selected(false));
      expect(decoration().color, isNot(customDanger));
    });
  });
}
