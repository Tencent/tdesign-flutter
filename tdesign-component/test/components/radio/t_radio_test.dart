import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

Widget controlledRadio<T>({
  Key? key,
  required T value,
  required T? selectedValue,
  ValueChanged<T>? onChanged,
  String? title,
  String? subTitle,
  TRadioSize size = TRadioSize.medium,
  TRadioIconType iconType = TRadioIconType.fill,
  TRadioVariant variant = TRadioVariant.block,
  TContentDirection contentDirection = TContentDirection.right,
  int titleMaxLines = 3,
  int subTitleMaxLines = 5,
  TRadioIconBuilder? customIconBuilder,
}) {
  return TRadioGroup<T>(
    value: selectedValue,
    onChanged: onChanged,
    child: TRadio<T>(
      key: key,
      value: value,
      title: title,
      subTitle: subTitle,
      size: size,
      iconType: iconType,
      variant: variant,
      contentDirection: contentDirection,
      titleMaxLines: titleMaxLines,
      subTitleMaxLines: subTitleMaxLines,
      customIconBuilder: customIconBuilder,
    ),
  );
}

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

  group('TRadio 单项行为', () {
    testWidgets('默认主标题和副标题行数与小程序一致', (tester) async {
      final radio = controlledRadio<String>(
        value: 'a',
        selectedValue: 'a',
        title: '主标题',
        subTitle: '副标题',
      );
      await tester.pumpWidget(wrap(radio));
      final radioWidget = tester.widget<TRadio<String>>(
        find.byType(TRadio<String>),
      );
      expect(radioWidget.titleMaxLines, 3);
      expect(radioWidget.subTitleMaxLines, 5);
      final title = tester.widget<Text>(find.text('主标题'));
      final subTitle = tester.widget<Text>(find.text('副标题'));
      expect(title.maxLines, 3);
      expect(title.overflow, TextOverflow.ellipsis);
      expect(subTitle.maxLines, 5);
      expect(subTitle.overflow, TextOverflow.ellipsis);
    });

    testWidgets('仅 block options 默认显示项间分割线', (tester) async {
      await tester.pumpWidget(
        wrap(
          const Column(
            children: [
              TRadioGroup<String>.options(value: 'a', options: options),
              TRadioGroup<String>.options(
                value: 'a',
                options: options,
                variant: TRadioVariant.inline,
              ),
            ],
          ),
        ),
      );

      expect(find.byType(TDivider), findsNWidgets(options.length - 1));
    });

    testWidgets('Group 默认仅在选项之间显示分割线', (tester) async {
      await tester.pumpWidget(
        wrap(const TRadioGroup<String>.options(value: 'a', options: options)),
      );

      expect(find.byType(TDivider), findsNWidgets(options.length - 1));
    });

    testWidgets('按 Group value 渲染选中态并触发 onChanged', (tester) async {
      String? changed;
      await tester.pumpWidget(
        wrap(
          controlledRadio<String>(
            value: 'a',
            selectedValue: 'b',
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
        wrap(
          controlledRadio<String>(
            value: 'a',
            selectedValue: 'a',
            title: '选项 A',
          ),
        ),
      );

      await tester.tap(find.text('选项 A'));
      await tester.pump();
      expect(find.text('选项 A'), findsOneWidget);
    });

    testWidgets('自定义 iconBuilder 生效', (tester) async {
      await tester.pumpWidget(
        wrap(
          controlledRadio<String>(
            value: 'a',
            selectedValue: 'a',
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
          TRadioGroup<String>.options(
            value: 'a',
            options: const [
              TRadioOption(value: 'a', label: '大尺寸', subTitle: '副标题'),
              TRadioOption(value: 'b', label: '第二项'),
            ],
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

  group('TRadio 视觉参数', () {
    testWidgets('块级单行内容使用 56 高度且分割线与正文左侧对齐', (tester) async {
      await tester.pumpWidget(
        wrap(
          SizedBox(
            width: 320,
            child: TRadioGroup<String>.options(
              value: 'a',
              options: const [
                TRadioOption(value: 'a', label: '单选'),
                TRadioOption(value: 'b', label: '第二项'),
              ],
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

      expect(tester.getSize(gesture.first).height, 56);
      expect(
        tester.getTopLeft(dividerLine).dx,
        tester.getTopLeft(find.text('单选')).dx,
      );
      expect(tester.getSize(dividerLine).height, 0.5);
      final dividerBackground = find.ancestor(
        of: find.byType(TDivider),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is ColoredBox &&
              widget.color == TThemeData.defaultData().bgColorContainer,
        ),
      );
      expect(dividerBackground, findsOneWidget);
      expect(tester.getSize(dividerBackground).width, 320);
    });

    testWidgets('卡片单行文案在边框内居中且四周均为 spacer16', (tester) async {
      await tester.pumpWidget(
        wrap(
          SizedBox(
            width: 320,
            child: Column(
              children: [
                controlledRadio<String>(
                  key: const ValueKey('vertical-card'),
                  value: 'a',
                  selectedValue: 'a',
                  title: '纵向卡片',
                  variant: TRadioVariant.card,
                  onChanged: (_) {},
                ),
                controlledRadio<String>(
                  key: const ValueKey('horizontal-card'),
                  value: 'b',
                  selectedValue: 'a',
                  title: '横向卡片',
                  variant: TRadioVariant.card,
                  onChanged: (_) {},
                ),
              ],
            ),
          ),
        ),
      );

      for (final key in const ['vertical-card', 'horizontal-card']) {
        final radio = find.byKey(ValueKey(key));
        final card = find.descendant(
          of: radio,
          matching: find.byWidgetPredicate(
            (widget) => widget.runtimeType.toString() == 'TSelectionCard',
          ),
        );
        final title = find.descendant(
          of: radio,
          matching: find.text(key == 'vertical-card' ? '纵向卡片' : '横向卡片'),
        );
        final content = find
            .descendant(of: card, matching: find.byType(Column))
            .first;
        expect(tester.getCenter(title).dy, tester.getCenter(card).dy);
        expect(tester.getTopLeft(title).dy - tester.getTopLeft(card).dy, 16);
        expect(
          tester.getBottomRight(card).dy - tester.getBottomRight(title).dy,
          16,
        );
        expect(tester.getTopLeft(content).dx - tester.getTopLeft(card).dx, 16);
        expect(
          tester.getBottomRight(card).dx - tester.getBottomRight(content).dx,
          16,
        );
      }
    });

    testWidgets('带副标题时指示器始终与主标题行居中对齐', (tester) async {
      await tester.pumpWidget(
        wrap(
          Column(
            children: TRadioSize.values
                .map(
                  (size) => controlledRadio<TRadioSize>(
                    value: size,
                    selectedValue: TRadioSize.medium,
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
                  (size) => controlledRadio<TRadioSize>(
                    key: ValueKey(size),
                    value: size,
                    selectedValue: TRadioSize.medium,
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
                controlledRadio<String>(
                  key: const ValueKey('token-block'),
                  value: 'a',
                  selectedValue: 'a',
                  title: '块级',
                  onChanged: (_) {},
                ),
                controlledRadio<String>(
                  key: const ValueKey('token-card'),
                  value: 'b',
                  selectedValue: 'b',
                  title: '卡片',
                  subTitle: '说明',
                  variant: TRadioVariant.card,
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
        wrap(
          controlledRadio<String>(
            value: 'a',
            selectedValue: 'b',
            onChanged: (_) {},
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
            body: controlledRadio<String>(
              value: 'a',
              selectedValue: 'b',
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
            body: controlledRadio<String>(
              value: 'a',
              selectedValue: 'a',
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
            body: controlledRadio<String>(
              value: 'a',
              selectedValue: 'a',
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
          controlledRadio<String>(
            value: 'a',
            selectedValue: 'a',
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
              controlledRadio<String>(
                value: 'a',
                selectedValue: 'a',
                iconType: TRadioIconType.check,
                onChanged: (_) {},
              ),
              controlledRadio<String>(
                value: 'b',
                selectedValue: 'b',
                iconType: TRadioIconType.fill,
                onChanged: (_) {},
              ),
              controlledRadio<String>(
                value: 'c',
                selectedValue: 'none',
                iconType: TRadioIconType.fill,
                onChanged: (_) {},
              ),
              controlledRadio<String>(
                value: 'd',
                selectedValue: 'd',
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
              controlledRadio<String>(
                value: 'a',
                selectedValue: 'b',
                title: '未选',
                subTitle: '描述信息',
                onChanged: (_) {},
              ),
              controlledRadio<String>(
                value: 'b',
                selectedValue: 'b',
                title: '禁用选中',
              ),
              controlledRadio<String>(
                value: 'c',
                selectedValue: 'b',
                title: '禁用未选',
              ),
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

      expect(painters, hasLength(2));
      expect(painters.first.selected, isFalse);
      expect(painters.first.color, token.componentBorderColor);
      expect(painters.first.backgroundColor, isNull);
      expect(painters.last.selected, isFalse);
      expect(painters.last.color, token.componentBorderColor);
      expect(painters.last.backgroundColor, token.bgColorComponentDisabled);
      expect(token.componentBorderColor, const Color(0xFFDCDCDC));
      expect(token.bgColorComponentDisabled, const Color(0xFFEEEEEE));
      expect(disabledIcon.color, token.brandDisabledColor);
      expect(subTitle.style?.color, token.textColorSecondary);
      expect(disabledTitle.style?.color, token.textDisabledColor);
    });

    testWidgets('Theme 视觉 token 可覆盖选中色、标题色和内容间距', (tester) async {
      await tester.pumpWidget(
        wrap(
          controlledRadio<String>(
            value: 'a',
            selectedValue: 'a',
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
            child: controlledRadio<String>(
              value: 'a',
              selectedValue: 'b',
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
            child: controlledRadio<String>(
              value: 'a',
              selectedValue: 'b',
              title: '有界宽度单选项',
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(tester.getSize(find.byType(TRadio<String>)).width, 320);
    });
  });

  group('TRadioGroup 受控行为', () {
    testWidgets('点击已选项仍回传当前值且只回调一次', (tester) async {
      var calls = 0;
      String? changed;
      await tester.pumpWidget(
        wrap(
          TRadioGroup<String>.options(
            value: 'a',
            options: const [TRadioOption(value: 'a', label: '选项 A')],
            onChanged: (value) {
              calls += 1;
              changed = value;
            },
          ),
        ),
      );

      await tester.tap(find.text('选项 A'));
      await tester.pump();

      expect(calls, 1);
      expect(changed, 'a');
    });

    testWidgets('点击 option 触发互斥选中回调', (tester) async {
      String? changed;
      await tester.pumpWidget(
        wrap(
          TRadioGroup<String>(
            value: 'a',
            onChanged: (value) => changed = value,
            child: const Row(
              children: [
                TRadio<String>(value: 'a', title: '选项 A'),
                TRadio<String>(value: 'b', title: '选项 B', subTitle: '说明 B'),
              ],
            ),
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
        wrap(const TRadioGroup<String>.options(value: 'a', options: options)),
      );

      await tester.tap(find.text('选项 A'));
      await tester.pump();
      expect(find.text('选项 A'), findsOneWidget);
    });

    testWidgets('禁用 option 不触发回调', (tester) async {
      String? changed;
      await tester.pumpWidget(
        wrap(
          TRadioGroup<String>.options(
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

  group('TRadioGroup 布局与自定义项', () {
    testWidgets('inline 只保留内容高度且仍由 Group 触发一次回调', (tester) async {
      var calls = 0;
      String? changed;
      await tester.pumpWidget(
        wrap(
          TRadioGroup<String>(
            value: 'a',
            onChanged: (value) {
              calls += 1;
              changed = value;
            },
            child: const TRadio<String>(
              value: 'b',
              title: '行内选项',
              variant: TRadioVariant.inline,
            ),
          ),
        ),
      );

      final gesture = find.descendant(
        of: find.byType(TRadio<String>),
        matching: find.byType(GestureDetector),
      );
      expect(tester.getSize(gesture).height, 24);
      expect(find.byType(TDivider), findsNothing);

      await tester.tap(find.text('行内选项'));
      await tester.pump();
      expect(calls, 1);
      expect(changed, 'b');
    });

    testWidgets('TRadio 缺少同类型 Group 时抛出清晰错误', (tester) async {
      await tester.pumpWidget(
        wrap(const TRadio<String>(value: 'a', title: '孤立选项')),
      );

      final error = tester.takeException();
      expect(error, isA<FlutterError>());
      expect(error.toString(), contains('requires a TRadioGroup<String>'));
    });

    testWidgets('单项 disabled 不影响同组其他选项', (tester) async {
      String? changed;
      await tester.pumpWidget(
        wrap(
          TRadioGroup<String>(
            value: 'a',
            onChanged: (value) => changed = value,
            child: const Row(
              children: [
                TRadio<String>(value: 'a', title: '禁用项', disabled: true),
                TRadio<String>(value: 'b', title: '可用项'),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('禁用项'));
      await tester.pump();
      expect(changed, isNull);

      await tester.tap(find.text('可用项'));
      await tester.pump();
      expect(changed, 'b');
    });

    test('非 block variant 禁止开启分割线', () {
      expect(
        () => TRadioGroup<String>.options(
          value: null,
          options: options,
          variant: TRadioVariant.inline,
          showDivider: true,
        ),
        throwsAssertionError,
      );
    });

    testWidgets('透传指示器样式和标题行数', (tester) async {
      await tester.pumpWidget(
        wrap(
          const TRadioGroup<String>.options(
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

    testWidgets('inline 横向布局按内容收缩且四字标题不折行', (tester) async {
      await tester.pumpWidget(
        wrap(
          const SizedBox(
            width: 343,
            child: TRadioGroup<String>.options(
              value: 'a',
              options: [
                TRadioOption(value: 'a', label: '单选标题'),
                TRadioOption(value: 'b', label: '单选标题'),
                TRadioOption(value: 'c', label: '上限四字'),
              ],
              direction: Axis.horizontal,
              columns: 3,
              variant: TRadioVariant.inline,
            ),
          ),
        ),
      );

      final radios = find.byType(TRadio<String>);
      final top = tester.getTopLeft(radios.first).dy;
      expect(tester.getTopLeft(radios.at(1)).dy, top);
      expect(tester.getTopLeft(radios.at(2)).dy, top);
      expect(tester.getSize(find.text('上限四字')).height, 24);
      expect(tester.getSize(radios.first).width, lessThan(343 / 3));
    });

    testWidgets('block 横向多列布局可构建', (tester) async {
      await tester.pumpWidget(
        wrap(
          const SizedBox(
            width: 240,
            child: TRadioGroup<String>.options(
              value: 'a',
              options: options,
              direction: Axis.horizontal,
              columns: 2,
            ),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate((widget) => widget is TRadioGroup<String>),
        findsOneWidget,
      );
      expect(find.byType(Wrap), findsOneWidget);
    });

    testWidgets('card variant 使用卡片组布局', (tester) async {
      await tester.pumpWidget(
        wrap(
          const TRadioGroup<String>.options(
            value: 'a',
            options: options,
            variant: TRadioVariant.card,
          ),
        ),
      );

      expect(find.text('选项 A'), findsOneWidget);
      expect(find.text('选项 B'), findsOneWidget);
    });

    testWidgets('自定义 child 仍由真实 TRadio 接管点击和语义', (tester) async {
      String? changed;
      await tester.pumpWidget(
        wrap(
          TRadioGroup<String>(
            value: 'a',
            onChanged: (value) => changed = value,
            child: const Wrap(
              children: [
                TRadio<String>(value: 'a', title: '选项 A'),
                TRadio<String>(value: 'b', title: '选项 B'),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('选项 B'));
      await tester.pump();

      expect(changed, 'b');
    });

    test('columns 必须大于 0', () {
      expect(
        () => TRadioGroup<String>.options(
          value: null,
          options: options,
          columns: 0,
        ),
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
          controlledRadio<String>(
            value: 'a',
            selectedValue: 'a',
            title: '主题',
            onChanged: (_) {},
          ),
        ),
      );

      await tester.pumpWidget(
        wrap(
          controlledRadio<String>(
            value: 'a',
            selectedValue: 'a',
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
