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
    testWidgets('默认主标题和副标题行数与小程序一致', (tester) async {
      const radio = TRadio<String>(
        value: 'a',
        groupValue: 'a',
        title: '主标题',
        subTitle: '副标题',
      );
      const group = TRadioGroup<String>(value: 'a', options: options);

      expect(radio.titleMaxLines, 3);
      expect(radio.subTitleMaxLines, 5);
      expect(group.titleMaxLines, 3);
      expect(group.subTitleMaxLines, 5);
      expect(radio.showDivider, isTrue);
      expect(group.showDivider, isTrue);

      await tester.pumpWidget(wrap(radio));
      final title = tester.widget<Text>(find.text('主标题'));
      final subTitle = tester.widget<Text>(find.text('副标题'));
      expect(title.maxLines, 3);
      expect(title.overflow, TextOverflow.ellipsis);
      expect(subTitle.maxLines, 5);
      expect(subTitle.overflow, TextOverflow.ellipsis);
    });

    testWidgets('默认显示分割线且卡片模式与显式关闭时不显示', (tester) async {
      await tester.pumpWidget(
        wrap(
          const Column(
            children: [
              TRadio<String>(value: 'a', groupValue: 'b', title: '默认分割线'),
              TRadio<String>(
                value: 'a',
                groupValue: 'b',
                title: '关闭分割线',
                showDivider: false,
              ),
              TRadio<String>(
                value: 'a',
                groupValue: 'a',
                title: '卡片模式',
                cardMode: true,
              ),
            ],
          ),
        ),
      );

      expect(find.byType(TDivider), findsOneWidget);
    });

    testWidgets('Group 默认仅在选项之间显示分割线', (tester) async {
      await tester.pumpWidget(
        wrap(const TRadioGroup<String>(value: 'a', options: options)),
      );

      expect(find.byType(TDivider), findsNWidgets(options.length - 1));
    });

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

    testWidgets('带副标题时指示器始终与主标题行居中对齐', (tester) async {
      await tester.pumpWidget(
        wrap(
          Column(
            children: TRadioSize.values
                .map(
                  (size) => TRadio<TRadioSize>(
                    value: size,
                    groupValue: TRadioSize.medium,
                    title: '主标题-${size.name}',
                    subTitle: '副标题',
                    size: size,
                    onChanged: (_) {},
                  ),
                )
                .toList(),
          ),
        ),
      );

      for (final size in TRadioSize.values) {
        final radio = find.ancestor(
          of: find.text('主标题-${size.name}'),
          matching: find.byType(TRadio<TRadioSize>),
        );
        final indicator = size == TRadioSize.medium
            ? find.descendant(
                of: radio,
                matching: find.byIcon(TIcons.check_circle_filled),
              )
            : find.descendant(
                of: radio,
                matching: find.byWidgetPredicate(
                  (widget) =>
                      widget is CustomPaint &&
                      widget.painter.runtimeType.toString() ==
                          '_TRadioIndicatorPainter',
                ),
              );
        expect(
          tester.getCenter(indicator).dy,
          closeTo(tester.getCenter(find.text('主标题-${size.name}')).dy, 0.01),
        );
      }
    });

    testWidgets('三档块级高度保持 48 56 64 且默认规格对应小程序', (tester) async {
      await tester.pumpWidget(
        wrap(
          Column(
            children: TRadioSize.values
                .map(
                  (size) => TRadio<TRadioSize>(
                    key: ValueKey(size),
                    value: size,
                    groupValue: TRadioSize.medium,
                    title: size.name,
                    size: size,
                    onChanged: (_) {},
                  ),
                )
                .toList(),
          ),
        ),
      );

      for (final (size, expectedHeight) in const [
        (TRadioSize.small, 48.0),
        (TRadioSize.medium, 56.0),
        (TRadioSize.large, 64.0),
      ]) {
        final gesture = find.descendant(
          of: find.byKey(ValueKey(size)),
          matching: find.byType(GestureDetector),
        );
        expect(tester.getSize(gesture).height, expectedHeight);
      }
    });

    testWidgets('块高、指示器和卡片高度均读取 TDesign token', (tester) async {
      final token = TThemeData.defaultData().copyWithTThemeData(
        'radio-size-token-test',
        marginMap: const {
          'spacer4': 5,
          'spacer8': 9,
          'spacer16': 18,
          'spacer24': 27,
          'spacer48': 51,
        },
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(token),
          home: Scaffold(
            body: Column(
              children: [
                TRadio<String>(
                  key: const ValueKey('token-block'),
                  value: 'a',
                  groupValue: 'a',
                  title: '块级',
                  showDivider: false,
                  onChanged: (_) {},
                ),
                TRadio<String>(
                  key: const ValueKey('token-card'),
                  value: 'b',
                  groupValue: 'b',
                  title: '卡片',
                  subTitle: '说明',
                  cardMode: true,
                  onChanged: (_) {},
                ),
              ],
            ),
          ),
        ),
      );

      Finder gesture(String key) => find.descendant(
        of: find.byKey(ValueKey(key)),
        matching: find.byType(GestureDetector),
      );
      final selectedIcon = tester.widget<Icon>(
        find.descendant(
          of: find.byKey(const ValueKey('token-block')),
          matching: find.byIcon(TIcons.check_circle_filled),
        ),
      );

      expect(tester.getSize(gesture('token-block')).height, 60);
      expect(tester.getSize(gesture('token-card')).height, 87);
      expect(selectedIcon.size, 27);
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

    testWidgets('Material TextTheme 颜色不覆盖标题和副标题语义色', (tester) async {
      final token = TThemeData.defaultData();
      final theme = TThemeBuilder.light(token).copyWith(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.purple),
          bodyMedium: TextStyle(color: Colors.orange),
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: TRadio<String>(
              value: 'a',
              groupValue: 'a',
              title: '主标题',
              subTitle: '副标题',
              onChanged: (_) {},
            ),
          ),
        ),
      );

      final title = tester.widget<Text>(find.text('主标题'));
      final subTitle = tester.widget<Text>(find.text('副标题'));
      expect(title.style?.color, token.textColorPrimary);
      expect(subTitle.style?.color, token.textColorSecondary);
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
      final selectedIcon = tester.widget<Icon>(
        find.byIcon(TIcons.check_circle_filled),
      );

      expect(indicator.width, 24.0);
      expect(indicator.height, 24.0);
      expect(selectedIcon.size, 24.0);
      expect(selectedIcon.color, token.brandNormalColor);
    });

    testWidgets('check 和默认 fill 使用同尺寸 TDesign 图标', (tester) async {
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
              TRadio<String>(
                value: 'd',
                groupValue: 'd',
                iconType: TRadioIconType.dot,
                onChanged: (_) {},
              ),
            ],
          ),
        ),
      );

      final painters = radioIndicatorPainters(tester);
      final checkIcon = tester.widget<Icon>(find.byIcon(TIcons.check));
      final fillIcon = tester.widget<Icon>(
        find.byIcon(TIcons.check_circle_filled),
      );
      expect(checkIcon.size, 24);
      expect(checkIcon.color, token.brandNormalColor);
      expect(fillIcon.size, 24);
      expect(fillIcon.color, token.brandNormalColor);
      expect(painters.map((painter) => painter.iconType), [
        TRadioIconType.fill,
        TRadioIconType.dot,
      ]);
      expect(painters.map((painter) => painter.selected), [false, true]);
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
                subTitle: '描述信息',
                onChanged: (_) {},
              ),
              const TRadio<String>(value: 'b', groupValue: 'b', title: '禁用选中'),
            ],
          ),
        ),
      );

      final painters = radioIndicatorPainters(tester);
      final disabledIcon = tester.widget<Icon>(
        find.byIcon(TIcons.check_circle_filled),
      );
      final subTitle = tester.widget<Text>(find.text('描述信息'));
      final disabledTitle = tester.widget<Text>(find.text('禁用选中'));

      expect(painters.single.selected, isFalse);
      expect(painters.single.color, token.componentBorderColor);
      expect(disabledIcon.color, token.brandDisabledColor);
      expect(subTitle.style?.color, token.textColorSecondary);
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

      final selectedIcon = tester.widget<Icon>(
        find.byIcon(TIcons.check_circle_filled),
      );
      final title = tester.widget<Text>(find.text('主题单选'));
      final spacing = tester.widget<SizedBox>(
        find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.width == 12,
        ),
      );

      expect(selectedIcon.color, Colors.red);
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
