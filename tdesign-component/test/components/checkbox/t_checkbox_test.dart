import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child, {TCheckboxThemeData? checkboxTheme}) {
    var theme = TThemeBuilder.light(TThemeData.defaultData());
    if (checkboxTheme != null) {
      theme = theme.mergeExtension(checkboxTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: child),
    );
  }

  group('TCheckbox v1 单项行为', () {
    testWidgets('点击后按受控值反向回调', (tester) async {
      bool? changed;
      await tester.pumpWidget(
        wrap(
          TCheckbox(
            value: false,
            title: '复选项',
            onChanged: (value) => changed = value,
          ),
        ),
      );

      await tester.tap(find.text('复选项'));
      await tester.pump();

      expect(changed, isTrue);
    });

    testWidgets('选中态点击后回调 false', (tester) async {
      bool? changed;
      await tester.pumpWidget(
        wrap(
          TCheckbox(
            value: true,
            title: '复选项',
            onChanged: (value) => changed = value,
          ),
        ),
      );

      await tester.tap(find.text('复选项'));
      await tester.pump();

      expect(changed, isFalse);
    });

    testWidgets('value=null 表示半选并可切换为 true', (tester) async {
      bool? changed;
      await tester.pumpWidget(
        wrap(
          TCheckbox(
            value: null,
            title: '半选',
            onChanged: (value) => changed = value,
          ),
        ),
      );

      await tester.tap(find.text('半选'));
      await tester.pump();

      expect(changed, isTrue);
    });

    testWidgets('onChanged 为 null 时禁用', (tester) async {
      await tester.pumpWidget(wrap(const TCheckbox(value: false, title: '禁用')));

      await tester.tap(find.text('禁用'));
      await tester.pump();

      final checkbox = tester.widget<TCheckbox>(find.byType(TCheckbox));
      expect(checkbox.onChanged, isNull);
    });
  });

  group('TCheckbox v1 视觉参数', () {
    testWidgets('纯指示器在默认 48×48 热区内居中', (tester) async {
      await tester.pumpWidget(wrap(TCheckbox(value: false, onChanged: (_) {})));

      final checkbox = find.byType(TCheckbox);
      final gesture = find.descendant(
        of: checkbox,
        matching: find.byType(GestureDetector),
      );
      final indicator = find.byIcon(TIcons.rectangle);

      expect(tester.getSize(gesture), const Size.square(48));
      expect(tester.getCenter(indicator), tester.getCenter(gesture));
    });

    testWidgets('纯指示器在紧凑 24×24 热区内居中', (tester) async {
      final compactTheme = TThemeBuilder.light(TThemeData.defaultData())
          .copyWith(
            checkboxTheme: const CheckboxThemeData(
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          );
      await tester.pumpWidget(
        MaterialApp(
          theme: compactTheme,
          home: Scaffold(body: TCheckbox(value: false, onChanged: (_) {})),
        ),
      );

      final checkbox = find.byType(TCheckbox);
      final gesture = find.descendant(
        of: checkbox,
        matching: find.byType(GestureDetector),
      );
      final indicator = find.byIcon(TIcons.rectangle);

      expect(tester.getSize(gesture), const Size.square(24));
      expect(tester.getCenter(indicator), tester.getCenter(gesture));
    });

    testWidgets('完整主题下默认选中图标使用品牌色且不受全局 IconTheme 污染', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(
        wrap(TCheckbox(value: true, title: '复选项', onChanged: (_) {})),
      );

      final icon = tester.widget<Icon>(
        find.byIcon(TIcons.check_rectangle_filled),
      );
      expect(icon.size, 24.0);
      expect(icon.color, token.brandNormalColor);
    });

    testWidgets('完整主题下启用未选、禁用选中和文字颜色使用对应 token', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(
        wrap(
          Column(
            children: [
              TCheckbox(value: false, title: '未选', onChanged: (_) {}),
              const TCheckbox(value: true, title: '禁用选中'),
            ],
          ),
        ),
      );

      final uncheckedIcon = tester.widget<Icon>(find.byIcon(TIcons.rectangle));
      final disabledCheckedIcon = tester.widget<Icon>(
        find.byIcon(TIcons.check_rectangle_filled),
      );
      final disabledTitle = tester.widget<Text>(find.text('禁用选中'));

      expect(uncheckedIcon.color, token.componentBorderColor);
      expect(disabledCheckedIcon.color, token.brandDisabledColor);
      expect(disabledTitle.style?.color, token.textDisabledColor);
    });

    testWidgets('Theme 视觉 token 可覆盖选中色、标题色和内容间距', (tester) async {
      await tester.pumpWidget(
        wrap(
          TCheckbox(value: true, title: '主题复选', onChanged: (_) {}),
          checkboxTheme: const TCheckboxThemeData(
            selectColor: Colors.red,
            titleColor: Colors.green,
            spacing: 12,
          ),
        ),
      );

      final icon = tester.widget<Icon>(
        find.byIcon(TIcons.check_rectangle_filled),
      );
      final title = tester.widget<Text>(find.text('主题复选'));
      final spacing = tester.widget<SizedBox>(
        find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.width == 12,
        ),
      );

      expect(icon.color, Colors.red);
      expect(title.style?.color, Colors.green);
      expect(spacing.width, 12);
    });

    testWidgets('文案继承 Flutter TextTheme 且组件颜色优先', (tester) async {
      final theme = TThemeBuilder.light(TThemeData.defaultData())
          .copyWith(
            textTheme: const TextTheme(
              bodyLarge: TextStyle(
                color: Colors.orange,
                fontSize: 18,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
              bodyMedium: TextStyle(
                color: Colors.purple,
                fontSize: 15,
                height: 1.3,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
          .mergeExtension(const TCheckboxThemeData(titleColor: Colors.green));
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: TCheckbox(
              value: false,
              title: '标题',
              subTitle: '副标题',
              onChanged: (_) {},
            ),
          ),
        ),
      );

      final title = tester.widget<Text>(find.text('标题')).style!;
      final subTitle = tester.widget<Text>(find.text('副标题')).style!;
      expect(title.color, Colors.green);
      expect(title.fontSize, 18);
      expect(title.height, 1.4);
      expect(title.fontWeight, FontWeight.w600);
      expect(subTitle.color, Colors.purple);
      expect(subTitle.fontSize, 15);
      expect(subTitle.height, 1.3);
      expect(subTitle.fontWeight, FontWeight.w500);
    });

    testWidgets('标题、副标题、分割线可渲染', (tester) async {
      await tester.pumpWidget(
        wrap(
          TCheckbox(
            value: true,
            title: '标题',
            subTitle: '副标题',
            showDivider: true,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('标题'), findsOneWidget);
      expect(find.text('副标题'), findsOneWidget);
      expect(find.byType(TDivider), findsOneWidget);
    });

    testWidgets('三种尺寸和左右内容方向可构建', (tester) async {
      for (final size in TCheckboxSize.values) {
        await tester.pumpWidget(
          wrap(
            TCheckbox(
              value: false,
              title: 'size-$size',
              size: size,
              contentDirection: TContentDirection.left,
              onChanged: (_) {},
            ),
          ),
        );
        expect(find.text('size-$size'), findsOneWidget);
      }
    });

    testWidgets('customIconBuilder 接收 value/disabled 状态', (tester) async {
      await tester.pumpWidget(
        wrap(
          TCheckbox(
            value: true,
            onChanged: (_) {},
            customIconBuilder: (context, value, disabled) {
              return Text('$value $disabled');
            },
          ),
        ),
      );

      expect(find.text('true false'), findsOneWidget);
    });

    testWidgets('cardMode 可构建卡片视觉', (tester) async {
      await tester.pumpWidget(
        wrap(
          TCheckbox(
            value: true,
            title: '卡片',
            cardMode: true,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('卡片'), findsOneWidget);
    });

    testWidgets('无界宽度下按内容自然收缩且不触发 flex 异常', (tester) async {
      await tester.pumpWidget(
        wrap(
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: TCheckbox(
              value: false,
              title: '无界宽度复选项',
              subTitle: '副标题',
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      final size = tester.getSize(find.byType(TCheckbox));
      expect(size.width.isFinite, isTrue);
      expect(size.width, greaterThan(0));
    });

    testWidgets('有界宽度下仍填满父级', (tester) async {
      await tester.pumpWidget(
        wrap(
          SizedBox(
            width: 320,
            child: TCheckbox(value: false, title: '有界宽度复选项', onChanged: (_) {}),
          ),
        ),
      );

      expect(tester.getSize(find.byType(TCheckbox)).width, 320);
    });

    testWidgets('大尺寸纯控件和 check 变体可构建', (tester) async {
      await tester.pumpWidget(
        wrap(
          TCheckbox(value: false, size: TCheckboxSize.large, onChanged: (_) {}),
          checkboxTheme: const TCheckboxThemeData(
            variant: TCheckboxVariant.check,
          ),
        ),
      );

      expect(find.byType(TCheckbox), findsOneWidget);
    });
  });

  group('TCheckboxThemeData', () {
    test('copyWith 覆盖字段', () {
      const theme = TCheckboxThemeData(selectColor: Colors.red, spacing: 4);
      final copied = theme.copyWith(
        disableColor: Colors.grey,
        titleColor: Colors.green,
        subTitleColor: Colors.yellow,
        backgroundColor: Colors.black,
        spacing: 8,
        insetSpacing: 12,
        customSpace: const EdgeInsets.all(4),
      );

      expect(copied.selectColor, Colors.red);
      expect(copied.disableColor, Colors.grey);
      expect(copied.titleColor, Colors.green);
      expect(copied.subTitleColor, Colors.yellow);
      expect(copied.backgroundColor, Colors.black);
      expect(copied.spacing, 8);
      expect(copied.insetSpacing, 12);
      expect(copied.customSpace, const EdgeInsets.all(4));

      final unchanged = theme.copyWith();
      expect(unchanged.variant, theme.variant);
      expect(unchanged.selectColor, theme.selectColor);
      expect(unchanged.spacing, theme.spacing);
    });

    test('lerp 支持非同类型、端点和中间值', () {
      const a = TCheckboxThemeData(
        variant: TCheckboxVariant.square,
        selectColor: Colors.red,
        spacing: 4,
        customSpace: EdgeInsets.all(4),
      );
      const b = TCheckboxThemeData(
        variant: TCheckboxVariant.circle,
        selectColor: Colors.blue,
        spacing: 8,
        customSpace: EdgeInsets.all(12),
      );

      expect(a.lerp(null, 0.5), same(a));
      expect(a.lerp(b, 0), same(a));
      expect(a.lerp(b, 1), same(b));
      final mid = a.lerp(b, 0.75);
      expect(mid.variant, TCheckboxVariant.circle);
      expect(mid.spacing, 7);
      expect(mid.customSpace, const EdgeInsets.all(10));
    });

    testWidgets('Theme 注入可渲染', (tester) async {
      await tester.pumpWidget(
        wrap(
          TCheckbox(value: true, title: '主题', onChanged: (_) {}),
          checkboxTheme: const TCheckboxThemeData(
            selectColor: Colors.red,
            titleColor: Colors.green,
            customSpace: EdgeInsets.all(6),
          ),
        ),
      );

      expect(find.text('主题'), findsOneWidget);
    });
  });
}
