import 'dart:ui' show SemanticsAction, SemanticsFlag;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TCollapse V1.0 Widget 测试
///
/// 覆盖 mode 两档（multiple/accordion）、展开/折叠交互、
/// onExpansionChanged/onChanged 回调、TCollapsePanel 参数、
/// Theme 注入、边界情况。
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child, {TCollapseThemeData? collapseTheme}) {
    final themeExtensions = <ThemeExtension>[
      if (collapseTheme != null) collapseTheme,
    ];
    // 注意：必须通过 MaterialApp.theme 传递 extensions
    return MaterialApp(
      theme: ThemeData(
        extensions: [TThemeData.defaultData(), ...themeExtensions],
      ),
      // 常规用例放在滚动页面中；有界 Scaffold.body 另有回归测试覆盖。
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );
  }

  /// 读取第 index 个面板对应 AnimatedCrossFade 的折叠状态
  /// （TCollapse 折叠时 body 仍以 opacity:0 形式保留在树中，
  /// 故不能靠 find.text(...).findsNothing 判断，应检查 crossFadeState）
  CrossFadeState panelCrossFadeState(WidgetTester tester, int index) {
    final crossFades = tester.widgetList<AnimatedCrossFade>(
      find.byType(AnimatedCrossFade),
    );
    return crossFades.elementAt(index).crossFadeState;
  }

  /// 构建一个简单的面板
  TCollapsePanel<String> buildPanel({
    required String title,
    required String bodyText,
    bool isExpanded = false,
    String? value,
    TCollapseIconTextBuilder? expandIconTextBuilder,
    bool disabled = false,
    TCollapsePlacement placement = TCollapsePlacement.bottom,
    Key? key,
    String? semanticsLabel,
    Widget? body,
    double? bodyHeight,
  }) {
    return TCollapsePanel(
      key: key,
      headerBuilder: (context, expanded) => Text(title),
      body: body ?? Text(bodyText),
      bodyHeight: bodyHeight,
      isExpanded: isExpanded,
      value: value,
      expandIconTextBuilder: expandIconTextBuilder,
      disabled: disabled,
      placement: placement,
      semanticsLabel: semanticsLabel,
    );
  }

  group('TCollapse 基础渲染', () {
    testWidgets('multiple 模式渲染单个面板', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse(
            children: [buildPanel(title: '标题1', bodyText: '内容1')],
          ),
        ),
      );
      expect(find.byType(TCollapse<String>), findsOneWidget);
      expect(find.text('标题1'), findsOneWidget);
    });

    testWidgets('multiple 模式渲染多个面板', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse(
            children: [
              buildPanel(title: '标题A', bodyText: '内容A'),
              buildPanel(title: '标题B', bodyText: '内容B'),
            ],
          ),
        ),
      );
      expect(find.text('标题A'), findsOneWidget);
      expect(find.text('标题B'), findsOneWidget);
    });

    testWidgets('bodyHeight 为滚动内容提供有界高度', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse(
            children: [
              buildPanel(
                title: '列表',
                bodyText: '',
                isExpanded: true,
                bodyHeight: 120,
                body: ListView(children: const [Text('第一项'), Text('第二项')]),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      final constrainedBody = tester.widget<SizedBox>(
        find
            .ancestor(
              of: find.byType(ListView),
              matching: find.byType(SizedBox),
            )
            .first,
      );
      expect(constrainedBody.height, 120);
    });

    testWidgets('accordion 模式渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse(
            mode: TCollapseMode.accordion,
            value: 'v1',
            children: [
              buildPanel(title: '面板1', bodyText: '内容1', value: 'v1'),
              buildPanel(title: '面板2', bodyText: '内容2', value: 'v2'),
            ],
          ),
        ),
      );
      expect(find.byType(TCollapse<String>), findsOneWidget);
      expect(find.text('面板1'), findsOneWidget);
      expect(find.text('面板2'), findsOneWidget);
    });
  });

  group('TCollapse 展开折叠交互', () {
    testWidgets('multiple 模式点击展开面板', (tester) async {
      // multiple 模式为受控组件：点击仅通过 onExpansionChanged 通知当前状态，
      // 由父级取反后回写 isExpanded 完成展开/折叠。
      var expanded = false;
      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setState) {
              return TCollapse(
                onExpansionChanged: (index, isExpanded) =>
                    setState(() => expanded = !isExpanded),
                children: [
                  buildPanel(
                    title: '标题',
                    bodyText: '展开内容',
                    isExpanded: expanded,
                  ),
                ],
              );
            },
          ),
        ),
      );
      // 初始折叠，内容不可见（AnimatedCrossFade 处于 showFirst）
      expect(panelCrossFadeState(tester, 0), CrossFadeState.showFirst);

      // 点击标题展开
      await tester.tap(find.text('标题'));
      await tester.pumpAndSettle();

      // 展开后 crossFade 处于 showSecond
      expect(panelCrossFadeState(tester, 0), CrossFadeState.showSecond);
    });

    testWidgets('multiple 模式点击折叠已展开面板', (tester) async {
      var expanded = true;
      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setState) {
              return TCollapse(
                onExpansionChanged: (index, isExpanded) =>
                    setState(() => expanded = !isExpanded),
                children: [
                  buildPanel(
                    title: '标题',
                    bodyText: '展开内容',
                    isExpanded: expanded,
                  ),
                ],
              );
            },
          ),
        ),
      );
      // 初始展开
      expect(panelCrossFadeState(tester, 0), CrossFadeState.showSecond);

      // 点击标题折叠
      await tester.tap(find.text('标题'));
      await tester.pumpAndSettle();

      // 折叠后 crossFade 处于 showFirst
      expect(panelCrossFadeState(tester, 0), CrossFadeState.showFirst);
    });

    testWidgets('onExpansionChanged 回调被调用', (tester) async {
      int? calledIndex;
      bool? calledIsExpanded;

      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse(
            children: [buildPanel(title: '标题', bodyText: '内容')],
            onExpansionChanged: (index, isExpanded) {
              calledIndex = index;
              calledIsExpanded = isExpanded;
            },
          ),
        ),
      );

      await tester.tap(find.text('标题'));
      await tester.pumpAndSettle();

      expect(calledIndex, 0);
      expect(calledIsExpanded, false); // 点击时是折叠状态，回调传 false
    });

    testWidgets('accordion 模式切换面板', (tester) async {
      var value = 'v1';
      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setState) => TCollapse<String>(
              mode: TCollapseMode.accordion,
              value: value,
              onChanged: (next) => setState(() => value = next ?? ''),
              children: [
                buildPanel(title: '面板1', bodyText: '内容1', value: 'v1'),
                buildPanel(title: '面板2', bodyText: '内容2', value: 'v2'),
              ],
            ),
          ),
        ),
      );
      expect(panelCrossFadeState(tester, 0), CrossFadeState.showSecond);
      expect(panelCrossFadeState(tester, 1), CrossFadeState.showFirst);

      await tester.tap(find.text('面板2'));
      await tester.pumpAndSettle();

      expect(value, 'v2');
      expect(panelCrossFadeState(tester, 0), CrossFadeState.showFirst);
      expect(panelCrossFadeState(tester, 1), CrossFadeState.showSecond);
    });

    testWidgets('accordion 模式 onChanged 回调被调用', (tester) async {
      String? changedValue;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => wrapWithTheme(
            TCollapse(
              mode: TCollapseMode.accordion,
              value: changedValue,
              onChanged: (val) {
                setState(() => changedValue = val);
              },
              children: [
                buildPanel(title: '面板1', bodyText: '内容1', value: 'v1'),
                buildPanel(title: '面板2', bodyText: '内容2', value: 'v2'),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('面板1'));
      await tester.pumpAndSettle();

      expect(changedValue, 'v1');
    });
  });

  group('TCollapsePanel 参数', () {
    testWidgets('expandIconTextBuilder 自定义展开文案', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse(
            children: [
              buildPanel(
                title: '标题',
                bodyText: '内容',
                expandIconTextBuilder: (context, isExpanded) =>
                    isExpanded ? '收起' : '展开',
              ),
            ],
          ),
        ),
      );
      expect(find.text('展开'), findsOneWidget);
    });

    testWidgets('expandIconTextBuilder 展开后文案变为收起', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse(
            children: [
              buildPanel(
                title: '标题',
                bodyText: '内容',
                isExpanded: true,
                expandIconTextBuilder: (context, isExpanded) =>
                    isExpanded ? '收起' : '展开',
              ),
            ],
          ),
        ),
      );
      expect(find.text('收起'), findsOneWidget);
    });

    testWidgets('backgroundColor 自定义面板背景色', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse<String>(
            children: [
              TCollapsePanel<String>(
                headerBuilder: (context, expanded) => const Text('标题'),
                body: const Text('内容'),
                backgroundColor: Colors.blue.shade100,
              ),
            ],
          ),
        ),
      );
      expect(find.byType(TCollapse<String>), findsOneWidget);
    });

    testWidgets('多个面板初始混合展开状态', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse(
            children: [
              buildPanel(title: '面板1', bodyText: '内容1', isExpanded: true),
              buildPanel(title: '面板2', bodyText: '内容2', isExpanded: false),
              buildPanel(title: '面板3', bodyText: '内容3', isExpanded: true),
            ],
          ),
        ),
      );
      expect(find.text('内容1'), findsOneWidget);
      expect(panelCrossFadeState(tester, 1), CrossFadeState.showFirst);
      expect(find.text('内容3'), findsOneWidget);
    });
  });

  group('TCollapse Theme 注入', () {
    testWidgets('默认展开图标使用 placeholder token', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse(
            children: [buildPanel(title: '标题', bodyText: '内容')],
          ),
        ),
      );
      expect(
        tester.widget<Icon>(find.byIcon(Icons.expand_more)).color,
        token.textColorPlaceholder,
      );
    });

    testWidgets('TCollapseThemeData.variant=card 渲染卡片风格', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse(
            children: [
              buildPanel(title: '标题1', bodyText: '内容1'),
              buildPanel(title: '标题2', bodyText: '内容2'),
              buildPanel(title: '标题3', bodyText: '内容3'),
            ],
          ),
          collapseTheme: const TCollapseThemeData(
            variant: TCollapseVariant.card,
          ),
        ),
      );
      final materials = tester.widgetList<Material>(
        find.descendant(
          of: find.byType(TCollapse<String>),
          matching: find.byType(Material),
        ),
      );
      expect(
        materials.any((material) => material.borderRadius != null),
        isTrue,
      );
    });

    testWidgets('TCollapseThemeData.variant=block（默认）无圆角 Material', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse(
            children: [buildPanel(title: '标题', bodyText: '内容')],
          ),
        ),
      );
      final materials = tester.widgetList<Material>(
        find.descendant(
          of: find.byType(TCollapse<String>),
          matching: find.byType(Material),
        ),
      );
      expect(
        materials.any((material) => material.borderRadius != null),
        isFalse,
      );
    });

    testWidgets('TCollapseThemeData.backgroundColor 覆盖面板背景色', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse(
            children: [buildPanel(title: '标题', bodyText: '内容')],
          ),
          collapseTheme: const TCollapseThemeData(
            backgroundColor: Colors.green,
          ),
        ),
      );
      final materials = tester.widgetList<Material>(
        find.descendant(
          of: find.byType(TCollapse<String>),
          matching: find.byType(Material),
        ),
      );
      expect(
        materials.any((material) => material.color == Colors.green),
        isTrue,
      );
    });

    testWidgets('实例 variant 优先于 Theme variant', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse(
            variant: TCollapseVariant.block,
            children: [buildPanel(title: '标题', bodyText: '内容')],
          ),
          collapseTheme: const TCollapseThemeData(
            variant: TCollapseVariant.card,
          ),
        ),
      );
      final materials = tester.widgetList<Material>(
        find.descendant(
          of: find.byType(TCollapse<String>),
          matching: find.byType(Material),
        ),
      );
      expect(
        materials.any((material) => material.borderRadius != null),
        isFalse,
      );
    });

    testWidgets('文字、图标、分隔线、内容间距和卡片形态可由 Theme 控制', (tester) async {
      const theme = TCollapseThemeData(
        variant: TCollapseVariant.card,
        headerTextStyle: TextStyle(color: Colors.red),
        contentTextStyle: TextStyle(color: Colors.blue),
        iconColor: Colors.purple,
        dividerColor: Colors.orange,
        contentPadding: EdgeInsets.zero,
        cardMargin: EdgeInsets.zero,
        cardBorderRadius: BorderRadius.all(Radius.circular(12)),
      );
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse(
            children: [
              buildPanel(title: '主题标题', bodyText: '主题内容', isExpanded: true),
            ],
          ),
          collapseTheme: theme,
        ),
      );
      expect(
        DefaultTextStyle.of(tester.element(find.text('主题标题'))).style.color,
        Colors.red,
      );
      expect(
        DefaultTextStyle.of(tester.element(find.text('主题内容'))).style.color,
        Colors.blue,
      );
      expect(
        tester.widget<Icon>(find.byIcon(Icons.expand_less)).color,
        Colors.purple,
      );
      expect(
        tester
            .widgetList<Divider>(find.byType(Divider))
            .every((divider) => divider.color == Colors.orange),
        isTrue,
      );
      final card = tester
          .widgetList<Material>(
            find.descendant(
              of: find.byType(TCollapse<String>),
              matching: find.byType(Material),
            ),
          )
          .firstWhere((material) => material.borderRadius != null);
      expect(card.borderRadius, theme.cardBorderRadius);
    });

    test('TCollapseThemeData.copyWith 正确合并', () {
      const base = TCollapseThemeData(
        variant: TCollapseVariant.card,
        elevation: 2,
      );
      final merged = base.copyWith(backgroundColor: Colors.red);
      expect(merged.variant, TCollapseVariant.card);
      expect(merged.elevation, 2);
      expect(merged.backgroundColor, Colors.red);
      final all = base.copyWith(
        variant: TCollapseVariant.block,
        animationDuration: const Duration(milliseconds: 500),
        elevation: 6,
      );
      expect(all.variant, TCollapseVariant.block);
      expect(all.animationDuration, const Duration(milliseconds: 500));
      expect(all.elevation, 6);
    });

    test('TCollapseThemeData.lerp 插值正确', () {
      const a = TCollapseThemeData(
        elevation: 0,
        variant: TCollapseVariant.block,
      );
      const b = TCollapseThemeData(
        elevation: 4,
        variant: TCollapseVariant.card,
      );
      final mid = a.lerp(b, 0.5);
      expect(mid.elevation, 4); // t<0.5 取 a，t>=0.5 取 b，0.5 取 b
      expect(a.lerp(null, 0.5), same(a));
    });
  });

  group('TCollapse 边界情况', () {
    testWidgets('可直接放在 Scaffold.body 的有界布局中', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [TThemeData.defaultData()]),
          home: Scaffold(
            body: TCollapse(
              onExpansionChanged: (_, __) {},
              children: [buildPanel(title: '标题', bodyText: '内容')],
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('标题'), findsOneWidget);
    });

    testWidgets('标题语义包含展开状态', (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse(
            onExpansionChanged: (_, __) {},
            children: [
              buildPanel(title: '标题', bodyText: '内容', semanticsLabel: '标题'),
            ],
          ),
        ),
      );
      final headerSemantics = find.ancestor(
        of: find.text('标题'),
        matching: find.byWidgetPredicate(
          (widget) => widget is Semantics && widget.properties.expanded != null,
        ),
      );
      final node = tester.getSemantics(headerSemantics);
      expect(node.label, '标题');
      expect(node.hasFlag(SemanticsFlag.hasExpandedState), isTrue);
      expect(node.hasFlag(SemanticsFlag.isExpanded), isFalse);
      expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
      semantics.dispose();
    });

    testWidgets('禁用面板不响应点击并暴露禁用语义', (tester) async {
      var callbackCount = 0;
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse(
            onExpansionChanged: (_, __) => callbackCount += 1,
            children: [
              buildPanel(title: '禁用标题', bodyText: '内容', disabled: true),
            ],
          ),
        ),
      );
      await tester.tap(find.text('禁用标题'));
      expect(callbackCount, 0);
      final node = tester.getSemantics(find.text('禁用标题'));
      expect(node.hasFlag(SemanticsFlag.hasEnabledState), isTrue);
      expect(node.hasFlag(SemanticsFlag.isEnabled), isFalse);
      expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
      expect(
        DefaultTextStyle.of(tester.element(find.text('禁用标题'))).style.color,
        TThemeData.defaultData().textDisabledColor,
      );
      expect(
        tester.widget<Icon>(find.byIcon(Icons.expand_more)).color,
        TThemeData.defaultData().textDisabledColor,
      );
      semantics.dispose();
    });

    testWidgets('top placement 在标题上方展开内容', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse(
            children: [
              buildPanel(
                title: '标题',
                bodyText: '内容',
                isExpanded: true,
                placement: TCollapsePlacement.top,
              ),
            ],
          ),
        ),
      );
      expect(
        tester.getTopLeft(find.text('内容')).dy,
        lessThan(tester.getTopLeft(find.text('标题')).dy),
      );
    });

    testWidgets('320 宽度和 2 倍字体下长文本不溢出', (tester) async {
      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
        tester.platformDispatcher.clearTextScaleFactorTestValue();
      });
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse(
            onExpansionChanged: (_, __) {},
            children: [
              buildPanel(
                title: '这是一个用于验证窄屏和大字体布局的很长标题',
                bodyText: '这是较长的折叠内容，用于验证内容可以自然换行。',
                isExpanded: true,
                expandIconTextBuilder: (_, __) => '收起',
              ),
            ],
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('面板 key 在重排后保留 body 状态', (tester) async {
      var reversed = false;
      late StateSetter setState;

      TCollapsePanel<String> statefulPanel(String id) {
        return TCollapsePanel(
          key: ValueKey(id),
          headerBuilder: (_, __) => Text('标题$id'),
          body: _StatefulPanelBody(id: id),
          isExpanded: true,
        );
      }

      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setter) {
              setState = setter;
              final panels = [statefulPanel('A'), statefulPanel('B')];
              return TCollapse(
                children: reversed ? panels.reversed.toList() : panels,
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('A:0'));
      await tester.pump();
      expect(find.text('A:1'), findsOneWidget);

      setState(() => reversed = true);
      await tester.pump();
      expect(find.text('A:1'), findsOneWidget);
      expect(find.text('B:0'), findsOneWidget);
    });

    testWidgets('空 children 列表不崩溃', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TCollapse<String>(children: [])),
      );
      expect(find.byType(TCollapse<String>), findsOneWidget);
    });

    testWidgets('animationDuration 自定义动画时长', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse(
            animationDuration: const Duration(milliseconds: 100),
            children: [buildPanel(title: '标题', bodyText: '内容')],
          ),
        ),
      );
      expect(find.byType(TCollapse<String>), findsOneWidget);
    });

    testWidgets('elevation 参数渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse(
            elevation: 4,
            children: [buildPanel(title: '标题', bodyText: '内容')],
          ),
        ),
      );
      expect(find.byType(TCollapse<String>), findsOneWidget);
    });

    testWidgets('accordion 模式初始 value 为 null 时不展开任何面板', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse(
            mode: TCollapseMode.accordion,
            children: [
              buildPanel(title: '面板1', bodyText: '内容1', value: 'v1'),
              buildPanel(title: '面板2', bodyText: '内容2', value: 'v2'),
            ],
          ),
        ),
      );
      expect(panelCrossFadeState(tester, 0), CrossFadeState.showFirst);
      expect(panelCrossFadeState(tester, 1), CrossFadeState.showFirst);
    });
  });

  // ============================================================
  // 覆盖率补充
  // ============================================================
  group('TCollapse 覆盖率补充', () {
    testWidgets('accordion + value 断言', (tester) async {
      // 覆盖 101/103（_allPanelsHaveValue / _allPanelsHaveDistinctValues 断言）
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse(
            mode: TCollapseMode.accordion,
            value: 'v1',
            children: [
              buildPanel(title: '面板1', bodyText: '内容1', value: 'v1'),
              buildPanel(title: '面板2', bodyText: '内容2', value: 'v2'),
            ],
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(TCollapse<String>), findsOneWidget);
    });

    testWidgets('mode 从 accordion 变为 multiple', (tester) async {
      // 覆盖 106-107（didUpdateWidget 中 mode != accordion → _searchPanelByValue）
      var mode = TCollapseMode.accordion;
      late StateSetter setState;
      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setter) {
              setState = setter;
              return TCollapse(
                mode: mode,
                value: 'v1',
                children: [
                  buildPanel(title: '面板1', bodyText: '内容1', value: 'v1'),
                  buildPanel(title: '面板2', bodyText: '内容2', value: 'v2'),
                ],
                onChanged: (_) {},
              );
            },
          ),
        ),
      );
      setState(() => mode = TCollapseMode.multiple);
      await tester.pumpAndSettle();
      expect(find.byType(TCollapse<String>), findsOneWidget);
    });

    testWidgets('accordion 只通知被点击面板并等待 value 回写', (tester) async {
      final changes = <String>[];
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse(
            mode: TCollapseMode.accordion,
            value: 'v1',
            onExpansionChanged: (index, isExpanded) {
              changes.add('$index:$isExpanded');
            },
            children: [
              buildPanel(title: '面板A', bodyText: '内容A', value: 'v1'),
              buildPanel(title: '面板B', bodyText: '内容B', value: 'v2'),
            ],
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('面板B'));
      await tester.pumpAndSettle();
      expect(changes, ['1:false']);
      expect(panelCrossFadeState(tester, 0), CrossFadeState.showSecond);
      expect(panelCrossFadeState(tester, 1), CrossFadeState.showFirst);
    });
  });
}

class _StatefulPanelBody extends StatefulWidget {
  const _StatefulPanelBody({required this.id});

  final String id;

  @override
  State<_StatefulPanelBody> createState() => _StatefulPanelBodyState();
}

class _StatefulPanelBodyState extends State<_StatefulPanelBody> {
  var count = 0;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => setState(() => count += 1),
      child: Text('${widget.id}:$count'),
    );
  }
}
