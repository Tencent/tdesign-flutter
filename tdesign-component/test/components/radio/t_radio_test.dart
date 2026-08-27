import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child, {TRadioThemeData? radioTheme}) {
    var theme = TThemeBuilder.light(TThemeData.defaultData());
    if (radioTheme != null) {
      theme = theme.mergeExtension(radioTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: child),
    );
  }

  const options = [
    TRadioOption(value: 'a', label: '选项 A'),
    TRadioOption(value: 'b', label: '选项 B', subTitle: '说明 B'),
    TRadioOption(value: 'c', label: '选项 C', disabled: true),
  ];

  List<dynamic> radioIndicatorPainters(WidgetTester tester) {
    return tester
        .widgetList<CustomPaint>(find.byType(CustomPaint))
        .map((paint) => paint.painter)
        .where(
          (painter) =>
              painter != null &&
              painter.runtimeType.toString() == '_TRadioIndicatorPainter',
        )
        .map((painter) => painter as dynamic)
        .toList();
  }

  group('TRadio v1 单项行为', () {
    testWidgets('按 groupValue 渲染选中态并触发 onChanged', (tester) async {
      String? changed;
      await tester.pumpWidget(
        wrap(
          TRadio<String>(
            value: 'a',
            groupValue: 'b',
            title: '选项 A',
            onChanged: (value) => changed = value,
          ),
        ),
      );

      await tester.tap(find.text('选项 A'));
      await tester.pump();

      expect(changed, 'a');
    });

    testWidgets('onChanged 为 null 时禁用', (tester) async {
      await tester.pumpWidget(
        wrap(const TRadio<String>(value: 'a', groupValue: 'a', title: '选项 A')),
      );

      await tester.tap(find.text('选项 A'));
      await tester.pump();
      expect(find.text('选项 A'), findsOneWidget);
    });

    testWidgets('自定义 iconBuilder 生效', (tester) async {
      await tester.pumpWidget(
        wrap(
          TRadio<String>(
            value: 'a',
            groupValue: 'a',
            onChanged: (_) {},
            customIconBuilder: (context, selected, disabled) {
              return Text('$selected $disabled');
            },
          ),
        ),
      );

      expect(find.text('true false'), findsOneWidget);
      expect(radioIndicatorPainters(tester), isEmpty);
    });

    testWidgets('large + contentDirection.left + divider + subTitle 可构建', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          TRadio<String>(
            value: 'a',
            groupValue: 'b',
            title: '大尺寸',
            subTitle: '副标题',
            size: TRadioSize.large,
            contentDirection: TContentDirection.left,
            showDivider: true,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('大尺寸'), findsOneWidget);
      expect(find.text('副标题'), findsOneWidget);
      expect(find.byType(TDivider), findsOneWidget);
    });
  });

  group('TRadio v1 视觉参数', () {
    testWidgets('块级单行内容使用 56 高度且分割线从正文起点开始', (tester) async {
      await tester.pumpWidget(
        wrap(
          SizedBox(
            width: 320,
            child: TRadio<String>(
              value: 'a',
              groupValue: 'b',
              title: '单选',
              showDivider: true,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      final radio = find.byType(TRadio<String>);
      final gesture = find.descendant(
        of: radio,
        matching: find.byType(GestureDetector),
      );
      final dividerLine = find.descendant(
        of: find.byType(TDivider),
        matching: find.byWidgetPredicate(
          (widget) => widget is Container && widget.color != null,
        ),
      );

      expect(tester.getSize(gesture).height, 56);
      expect(tester.getTopLeft(dividerLine).dx, 48);
      expect(tester.getSize(dividerLine).height, 0.5);
    });

    testWidgets('纯指示器在默认 48×48 热区内居中', (tester) async {
      await tester.pumpWidget(
        wrap(TRadio<String>(value: 'a', groupValue: 'b', onChanged: (_) {})),
      );

      final radio = find.byType(TRadio<String>);
      final gesture = find.descendant(
        of: radio,
        matching: find.byType(GestureDetector),
      );
      final indicator = find.descendant(
        of: radio,
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is CustomPaint &&
              widget.painter.runtimeType.toString() ==
                  '_TRadioIndicatorPainter',
        ),
      );

      expect(tester.getSize(gesture), const Size.square(48));
      expect(tester.getCenter(indicator), tester.getCenter(gesture));
    });

    testWidgets('纯指示器在紧凑 24×24 热区内居中', (tester) async {
      final compactTheme = TThemeBuilder.light(TThemeData.defaultData())
          .copyWith(
            radioTheme: const RadioThemeData(
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          );
      await tester.pumpWidget(
        MaterialApp(
          theme: compactTheme,
          home: Scaffold(
            body: TRadio<String>(
              value: 'a',
              groupValue: 'b',
              onChanged: (_) {},
            ),
          ),
        ),
      );

      final radio = find.byType(TRadio<String>);
      final gesture = find.descendant(
        of: radio,
        matching: find.byType(GestureDetector),
      );
      final indicator = find.descendant(
        of: radio,
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is CustomPaint &&
              widget.painter.runtimeType.toString() ==
                  '_TRadioIndicatorPainter',
        ),
      );

      expect(tester.getSize(gesture), const Size.square(24));
      expect(tester.getCenter(indicator), tester.getCenter(gesture));
    });

    testWidgets('文本样式继承 Material TextTheme 的字号、行高和字重', (tester) async {
      const globalStyle = TextStyle(
        fontSize: 22,
        height: 1.4,
        fontWeight: FontWeight.w600,
      );
      var theme = TThemeBuilder.light(
        TThemeData.defaultData(),
      ).copyWith(textTheme: const TextTheme(bodyLarge: globalStyle));
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: TRadio<String>(
              value: 'a',
              groupValue: 'a',
              title: '全局样式',
              subTitle: '副标题',
              onChanged: (_) {},
            ),
          ),
        ),
      );

      final title = tester.widget<Text>(find.text('全局样式'));
      final subTitle = tester.widget<Text>(find.text('副标题'));
      expect(title.style?.fontSize, 22);
      expect(title.style?.height, 1.4);
      expect(title.style?.fontWeight, FontWeight.w600);
      expect(subTitle.style?.fontSize, 14);
    });

    testWidgets('完整主题下选中指示器使用品牌色并保持 24 尺寸', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(
        wrap(
          TRadio<String>(
            value: 'a',
            groupValue: 'a',
            title: '选项 A',
            onChanged: (_) {},
          ),
        ),
      );

      final indicator = tester
          .widgetList<SizedBox>(find.byType(SizedBox))
          .firstWhere((box) => box.width == 24.0 && box.height == 24.0);
      final painter = radioIndicatorPainters(tester).single;

      expect(indicator.width, 24.0);
      expect(indicator.height, 24.0);
      expect(painter.selected, isTrue);
      expect(painter.color, token.brandNormalColor);
      expect(painter.iconType, TRadioIconType.fill);
    });

    testWidgets('内置指示器支持 check 和 fill 样式并使用反色 token', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(
        wrap(
          Column(
            children: [
              TRadio<String>(
                value: 'a',
                groupValue: 'a',
                iconType: TRadioIconType.check,
                onChanged: (_) {},
              ),
              TRadio<String>(
                value: 'b',
                groupValue: 'b',
                iconType: TRadioIconType.fill,
                onChanged: (_) {},
              ),
              TRadio<String>(
                value: 'c',
                groupValue: 'none',
                iconType: TRadioIconType.fill,
                onChanged: (_) {},
              ),
            ],
          ),
        ),
      );

      final painters = radioIndicatorPainters(tester);
      expect(painters.map((painter) => painter.iconType), [
        TRadioIconType.check,
        TRadioIconType.fill,
        TRadioIconType.fill,
      ]);
      expect(painters[1].markColor, token.textColorAnti);
      expect(painters.map((painter) => painter.selected), [true, true, false]);
    });

    testWidgets('完整主题下未选、禁用和文字颜色使用对应 token', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(
        wrap(
          Column(
            children: [
              TRadio<String>(
                value: 'a',
                groupValue: 'b',
                title: '未选',
                onChanged: (_) {},
              ),
              const TRadio<String>(value: 'b', groupValue: 'b', title: '禁用选中'),
            ],
          ),
        ),
      );

      final painters = radioIndicatorPainters(tester);
      final disabledTitle = tester.widget<Text>(find.text('禁用选中'));

      expect(painters[0].selected, isFalse);
      expect(painters[0].color, token.componentBorderColor);
      expect(painters[1].selected, isTrue);
      expect(painters[1].color, token.brandDisabledColor);
      expect(disabledTitle.style?.color, token.textDisabledColor);
    });

    testWidgets('Theme 视觉 token 可覆盖选中色、标题色和内容间距', (tester) async {
      await tester.pumpWidget(
        wrap(
          TRadio<String>(
            value: 'a',
            groupValue: 'a',
            title: '主题单选',
            onChanged: (_) {},
          ),
          radioTheme: const TRadioThemeData(
            selectColor: Colors.red,
            titleColor: Colors.green,
            spacing: 12,
          ),
        ),
      );

      final painter = radioIndicatorPainters(tester).single;
      final title = tester.widget<Text>(find.text('主题单选'));
      final spacing = tester.widget<SizedBox>(
        find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.width == 12,
        ),
      );

      expect(painter.color, Colors.red);
      expect(title.style?.color, Colors.green);
      expect(spacing.width, 12);
    });

    testWidgets('无界宽度下按内容自然收缩且不触发 flex 异常', (tester) async {
      await tester.pumpWidget(
        wrap(
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: TRadio<String>(
              value: 'a',
              groupValue: 'b',
              title: '无界宽度单选项',
              subTitle: '副标题',
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      final size = tester.getSize(find.byType(TRadio<String>));
      expect(size.width.isFinite, isTrue);
      expect(size.width, greaterThan(0));
    });

    testWidgets('有界宽度下仍填满父级', (tester) async {
      await tester.pumpWidget(
        wrap(
          SizedBox(
            width: 320,
            child: TRadio<String>(
              value: 'a',
              groupValue: 'b',
              title: '有界宽度单选项',
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(tester.getSize(find.byType(TRadio<String>)).width, 320);
    });
  });

  group('TRadioGroup v1 受控行为', () {
    testWidgets('点击 option 触发互斥选中回调', (tester) async {
      String? changed;
      await tester.pumpWidget(
        wrap(
          TRadioGroup<String>(
            value: 'a',
            options: options,
            onChanged: (value) => changed = value,
          ),
        ),
      );

      await tester.tap(find.text('选项 B'));
      await tester.pump();

      expect(changed, 'b');
      expect(find.text('说明 B'), findsOneWidget);
    });

    testWidgets('onChanged 为 null 时整组禁用', (tester) async {
      await tester.pumpWidget(
        wrap(const TRadioGroup<String>(value: 'a', options: options)),
      );

      await tester.tap(find.text('选项 A'));
      await tester.pump();
      expect(find.text('选项 A'), findsOneWidget);
    });

    testWidgets('禁用 option 不触发回调', (tester) async {
      String? changed;
      await tester.pumpWidget(
        wrap(
          TRadioGroup<String>(
            value: 'a',
            options: options,
            onChanged: (value) => changed = value,
          ),
        ),
      );

      await tester.tap(find.text('选项 C'));
      await tester.pump();

      expect(changed, isNull);
    });
  });

  group('TRadioGroup v1 布局与自定义项', () {
    testWidgets('透传指示器样式和标题行数', (tester) async {
      await tester.pumpWidget(
        wrap(
          const TRadioGroup<String>(
            value: 'a',
            options: options,
            iconType: TRadioIconType.fill,
            titleMaxLines: 2,
            subTitleMaxLines: 3,
          ),
        ),
      );

      final painters = radioIndicatorPainters(tester);
      final title = tester.widget<Text>(find.text('选项 A'));
      final subTitle = tester.widget<Text>(find.text('说明 B'));
      expect(
        painters.every((painter) => painter.iconType == TRadioIconType.fill),
        isTrue,
      );
      expect(title.maxLines, 2);
      expect(subTitle.maxLines, 3);
    });

    testWidgets('横向多列布局可构建', (tester) async {
      await tester.pumpWidget(
        wrap(
          const SizedBox(
            width: 240,
            child: TRadioGroup<String>(
              value: 'a',
              options: options,
              direction: Axis.horizontal,
              columns: 2,
            ),
          ),
        ),
      );

      expect(find.byType(TRadioGroup<String>), findsOneWidget);
      expect(find.byType(Wrap), findsOneWidget);
    });

    testWidgets('cardMode 使用卡片组布局', (tester) async {
      await tester.pumpWidget(
        wrap(
          const TRadioGroup<String>(
            value: 'a',
            options: options,
            cardMode: true,
          ),
        ),
      );

      expect(find.text('选项 A'), findsOneWidget);
      expect(find.text('选项 B'), findsOneWidget);
    });

    testWidgets('itemBuilder 由 Group 接管点击和语义', (tester) async {
      String? changed;
      await tester.pumpWidget(
        wrap(
          TRadioGroup<String>(
            value: 'a',
            options: options,
            onChanged: (value) => changed = value,
            itemBuilder: (context, option, selected, disabled) {
              return Text('${option.label} $selected $disabled');
            },
          ),
        ),
      );

      await tester.tap(find.text('选项 B false false'));
      await tester.pump();

      expect(changed, 'b');
    });

    test('columns 必须大于 0', () {
      expect(
        () => TRadioGroup<String>(value: null, options: options, columns: 0),
        throwsAssertionError,
      );
    });
  });

  group('TRadioThemeData', () {
    test('copyWith 覆盖字段', () {
      const theme = TRadioThemeData(selectColor: Colors.red, spacing: 4);
      final copied = theme.copyWith(
        disableColor: Colors.grey,
        titleColor: Colors.green,
        subTitleColor: Colors.yellow,
        backgroundColor: Colors.black,
        spacing: 8,
        insetSpacing: 12,
      );

      expect(copied.selectColor, Colors.red);
      expect(copied.disableColor, Colors.grey);
      expect(copied.titleColor, Colors.green);
      expect(copied.subTitleColor, Colors.yellow);
      expect(copied.backgroundColor, Colors.black);
      expect(copied.spacing, 8);
      expect(copied.insetSpacing, 12);
    });

    test('lerp 支持非同类型和中间值', () {
      const a = TRadioThemeData(selectColor: Colors.red, spacing: 4);
      const b = TRadioThemeData(selectColor: Colors.blue, spacing: 8);

      expect(a.lerp(null, 0.5), same(a));
      final mid = a.lerp(b, 0.5);
      expect(mid.selectColor, Color.lerp(Colors.red, Colors.blue, 0.5));
      expect(mid.spacing, 6);
    });

    testWidgets('Theme 注入可渲染', (tester) async {
      await tester.pumpWidget(
        wrap(
          TRadio<String>(
            value: 'a',
            groupValue: 'a',
            title: '主题',
            onChanged: (_) {},
          ),
        ),
      );

      await tester.pumpWidget(
        wrap(
          TRadio<String>(
            value: 'a',
            groupValue: 'a',
            title: '主题',
            onChanged: (_) {},
          ),
          radioTheme: const TRadioThemeData(
            selectColor: Colors.red,
            titleColor: Colors.green,
          ),
        ),
      );

      expect(find.text('主题'), findsOneWidget);
    });
  });
}
