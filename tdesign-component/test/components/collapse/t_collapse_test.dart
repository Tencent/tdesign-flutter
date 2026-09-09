import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TCollapse Widget 测试。
///
/// 覆盖统一 value/onChanged 状态、multiple/accordion、组级与单项禁用、
/// Header 扩展点、Theme、布局和契约断言。
void main() {
  Widget wrapWithTheme(Widget child, {TCollapseThemeData? collapseTheme}) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [
          TThemeData.defaultData(),
          if (collapseTheme != null) collapseTheme,
        ],
      ),
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );
  }

  CrossFadeState panelCrossFadeState(WidgetTester tester, int index) {
    return tester
        .widgetList<AnimatedCrossFade>(find.byType(AnimatedCrossFade))
        .elementAt(index)
        .crossFadeState;
  }

  TCollapsePanel<String> buildPanel({
    required String value,
    required String title,
    required String bodyText,
    bool disabled = false,
    TCollapsePlacement placement = TCollapsePlacement.bottom,
    Key? key,
    String? semanticsLabel,
    Widget? body,
    double? bodyHeight,
    TCollapsePanelBuilder? leadingBuilder,
    TCollapsePanelBuilder? trailingBuilder,
    TCollapsePanelBuilder? expandIconBuilder = defaultExpandIconBuilder,
  }) {
    return TCollapsePanel<String>(
      key: key,
      value: value,
      headerBuilder: (context, expanded) => Text(title),
      body: body ?? Text(bodyText),
      bodyHeight: bodyHeight,
      disabled: disabled,
      placement: placement,
      semanticsLabel: semanticsLabel,
      leadingBuilder: leadingBuilder,
      trailingBuilder: trailingBuilder,
      expandIconBuilder: expandIconBuilder,
    );
  }

  group('TCollapse 基础渲染', () {
    testWidgets('multiple 模式按 value 渲染多个面板', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse<String>(
            value: const ['a'],
            children: [
              buildPanel(value: 'a', title: '标题A', bodyText: '内容A'),
              buildPanel(value: 'b', title: '标题B', bodyText: '内容B'),
            ],
          ),
        ),
      );

      expect(find.byType(TCollapse<String>), findsOneWidget);
      expect(panelCrossFadeState(tester, 0), CrossFadeState.showSecond);
      expect(panelCrossFadeState(tester, 1), CrossFadeState.showFirst);
    });

    testWidgets('accordion 模式按列表中的唯一 value 渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse<String>(
            mode: TCollapseMode.accordion,
            value: const ['b'],
            children: [
              buildPanel(value: 'a', title: '标题A', bodyText: '内容A'),
              buildPanel(value: 'b', title: '标题B', bodyText: '内容B'),
            ],
          ),
        ),
      );

      expect(panelCrossFadeState(tester, 0), CrossFadeState.showFirst);
      expect(panelCrossFadeState(tester, 1), CrossFadeState.showSecond);
    });

    testWidgets('bodyHeight 为滚动内容提供有界高度', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse<String>(
            value: const ['list'],
            children: [
              buildPanel(
                value: 'list',
                title: '列表',
                bodyText: '',
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

    testWidgets('短内容与标题保持左对齐', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse<String>(
            value: const ['a'],
            children: [buildPanel(value: 'a', title: '标题', bodyText: '短内容')],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        tester.getTopLeft(find.text('短内容')).dx,
        tester.getTopLeft(find.text('标题')).dx,
      );
    });
  });

  group('TCollapse 统一受控交互', () {
    testWidgets('multiple 模式返回添加后的完整列表', (tester) async {
      var value = ['a'];
      late List<String> callbackValue;
      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setState) => TCollapse<String>(
              value: value,
              onChanged: (next) {
                callbackValue = next;
                setState(() => value = next);
              },
              children: [
                buildPanel(value: 'a', title: '标题A', bodyText: '内容A'),
                buildPanel(value: 'b', title: '标题B', bodyText: '内容B'),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('标题B'));
      await tester.pumpAndSettle();

      expect(value, ['a', 'b']);
      expect(panelCrossFadeState(tester, 1), CrossFadeState.showSecond);
      expect(() => callbackValue.add('c'), throwsUnsupportedError);
    });

    testWidgets('multiple 模式返回移除后的完整列表', (tester) async {
      var value = ['a', 'b'];
      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setState) => TCollapse<String>(
              value: value,
              onChanged: (next) => setState(() => value = next),
              children: [
                buildPanel(value: 'a', title: '标题A', bodyText: '内容A'),
                buildPanel(value: 'b', title: '标题B', bodyText: '内容B'),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('标题A'));
      await tester.pumpAndSettle();

      expect(value, ['b']);
      expect(panelCrossFadeState(tester, 0), CrossFadeState.showFirst);
    });

    testWidgets('accordion 模式切换和收起时返回完整列表', (tester) async {
      var value = ['a'];
      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setState) => TCollapse<String>(
              mode: TCollapseMode.accordion,
              value: value,
              onChanged: (next) => setState(() => value = next),
              children: [
                buildPanel(value: 'a', title: '标题A', bodyText: '内容A'),
                buildPanel(value: 'b', title: '标题B', bodyText: '内容B'),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('标题B'));
      await tester.pumpAndSettle();
      expect(value, ['b']);

      await tester.tap(find.text('标题B'));
      await tester.pumpAndSettle();
      expect(value, isEmpty);
    });

    testWidgets('未回写 value 时视图保持受控值', (tester) async {
      List<String>? nextValue;
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse<String>(
            value: const ['a'],
            onChanged: (next) => nextValue = next,
            children: [
              buildPanel(value: 'a', title: '标题A', bodyText: '内容A'),
              buildPanel(value: 'b', title: '标题B', bodyText: '内容B'),
            ],
          ),
        ),
      );

      await tester.tap(find.text('标题B'));
      await tester.pumpAndSettle();

      expect(nextValue, ['a', 'b']);
      expect(panelCrossFadeState(tester, 0), CrossFadeState.showSecond);
      expect(panelCrossFadeState(tester, 1), CrossFadeState.showFirst);
    });
  });

  group('TCollapsePanel Header 扩展点', () {
    testWidgets('leadingBuilder 和 trailingBuilder 收到展开状态', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse<String>(
            value: const ['a'],
            onChanged: (_) {},
            children: [
              buildPanel(
                value: 'a',
                title: '标题',
                bodyText: '内容',
                leadingBuilder: (context, expanded) =>
                    Text(expanded ? '左开' : '左关'),
                trailingBuilder: (context, expanded) =>
                    Text(expanded ? '收起' : '展开'),
              ),
            ],
          ),
        ),
      );

      expect(find.text('左开'), findsOneWidget);
      expect(find.text('收起'), findsOneWidget);
      expect(
        DefaultTextStyle.of(tester.element(find.text('收起'))).style.fontSize,
        TThemeData.defaultData().fontBodyMedium?.size,
      );
    });

    testWidgets('trailingBuilder 随受控状态更新', (tester) async {
      var value = ['a'];
      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setState) => TCollapse<String>(
              value: value,
              onChanged: (next) => setState(() => value = next),
              children: [
                buildPanel(
                  value: 'a',
                  title: '标题',
                  bodyText: '内容',
                  trailingBuilder: (context, expanded) =>
                      Text(expanded ? '收起' : '展开'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('收起'));
      await tester.pumpAndSettle();
      expect(find.text('展开'), findsOneWidget);
    });

    testWidgets('默认、隐藏和自定义展开图标三态', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse<String>(
            value: const [],
            onChanged: (_) {},
            children: [
              buildPanel(value: 'default', title: '默认', bodyText: '内容'),
              buildPanel(
                value: 'hidden',
                title: '隐藏',
                bodyText: '内容',
                expandIconBuilder: null,
              ),
              buildPanel(
                value: 'custom',
                title: '自定义',
                bodyText: '内容',
                expandIconBuilder: (context, expanded) =>
                    const Icon(Icons.add, key: ValueKey('custom-icon')),
              ),
            ],
          ),
        ),
      );

      expect(find.byIcon(Icons.expand_more), findsOneWidget);
      expect(find.byKey(const ValueKey('custom-icon')), findsOneWidget);
      final hiddenHeader = find.ancestor(
        of: find.text('隐藏'),
        matching: find.byType(InkWell),
      );
      expect(
        find.descendant(of: hiddenHeader, matching: find.byType(Icon)),
        findsNothing,
      );
    });

    testWidgets('隐藏图标但保留 trailing 时提供尾部间距', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse<String>(
            value: const [],
            onChanged: (_) {},
            children: [
              buildPanel(
                value: 'a',
                title: '标题',
                bodyText: '内容',
                trailingBuilder: (context, expanded) => const Text('操作'),
                expandIconBuilder: null,
              ),
            ],
          ),
        ),
      );

      expect(find.text('操作'), findsOneWidget);
      expect(find.byType(Icon), findsNothing);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('backgroundColor 自定义面板背景色', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse<String>(
            value: const [],
            children: [
              TCollapsePanel<String>(
                value: 'a',
                headerBuilder: (context, expanded) => const Text('标题'),
                body: const Text('内容'),
                backgroundColor: Colors.blue,
              ),
            ],
          ),
        ),
      );

      expect(
        tester
            .widgetList<Material>(find.byType(Material))
            .any((material) => material.color == Colors.blue),
        isTrue,
      );
    });
  });

  group('TCollapse Theme 注入', () {
    testWidgets('默认展开图标使用 placeholder token', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse<String>(
            value: const [],
            onChanged: (_) {},
            children: [
              TCollapsePanel<String>(
                value: 'a',
                headerBuilder: (context, expanded) => const Text('标题'),
                body: const Text('内容'),
              ),
            ],
          ),
        ),
      );

      expect(
        IconTheme.of(tester.element(find.byIcon(Icons.expand_more))).color,
        token.textColorPlaceholder,
      );
    });

    testWidgets('Theme 和实例 variant 按优先级解析', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse<String>(
            value: const [],
            variant: TCollapseVariant.block,
            children: [buildPanel(value: 'a', title: '标题', bodyText: '内容')],
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

    testWidgets('Theme card、样式、间距和圆角生效', (tester) async {
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
          TCollapse<String>(
            value: const ['a'],
            onChanged: (_) {},
            children: [
              TCollapsePanel<String>(
                value: 'a',
                headerBuilder: (context, expanded) => const Text('主题标题'),
                body: const Text('主题内容'),
              ),
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
        IconTheme.of(tester.element(find.byIcon(Icons.expand_less))).color,
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

    test('TCollapseThemeData copyWith 和 lerp', () {
      const base = TCollapseThemeData(
        variant: TCollapseVariant.card,
        elevation: 2,
      );
      final merged = base.copyWith(backgroundColor: Colors.red);
      expect(merged.variant, TCollapseVariant.card);
      expect(merged.elevation, 2);
      expect(merged.backgroundColor, Colors.red);

      const other = TCollapseThemeData(
        variant: TCollapseVariant.block,
        elevation: 4,
      );
      expect(base.lerp(other, 0.5).elevation, 4);
      expect(base.lerp(null, 0.5), same(base));
    });
  });

  group('TCollapse 禁用、语义与边界', () {
    testWidgets('onChanged 为 null 时整组禁用并使用禁用视觉', (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse<String>(
            value: const [],
            children: [
              buildPanel(
                value: 'a',
                title: '组级禁用',
                bodyText: '内容',
                semanticsLabel: '组级禁用',
                trailingBuilder: (context, expanded) => const Text('操作'),
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('组级禁用'));
      await tester.pumpAndSettle();
      expect(panelCrossFadeState(tester, 0), CrossFadeState.showFirst);
      final semanticsWidget = tester.widget<Semantics>(
        find.ancestor(
          of: find.text('组级禁用'),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Semantics && widget.properties.expanded != null,
          ),
        ),
      );
      expect(semanticsWidget.properties.enabled, isFalse);
      expect(semanticsWidget.properties.onTap, isNull);
      expect(
        DefaultTextStyle.of(tester.element(find.text('组级禁用'))).style.color,
        TThemeData.defaultData().textDisabledColor,
      );
      expect(
        DefaultTextStyle.of(tester.element(find.text('操作'))).style.color,
        TThemeData.defaultData().textDisabledColor,
      );
      semantics.dispose();
    });

    testWidgets('Panel disabled 只禁用当前项', (tester) async {
      var value = <String>[];
      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setState) => TCollapse<String>(
              value: value,
              onChanged: (next) => setState(() => value = next),
              children: [
                buildPanel(
                  value: 'disabled',
                  title: '禁用项',
                  bodyText: '内容',
                  disabled: true,
                ),
                buildPanel(value: 'enabled', title: '可用项', bodyText: '内容'),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('禁用项'));
      await tester.pumpAndSettle();
      expect(value, isEmpty);

      await tester.tap(find.text('可用项'));
      await tester.pumpAndSettle();
      expect(value, ['enabled']);
    });

    testWidgets('top placement 在标题上方展开内容', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse<String>(
            value: const ['a'],
            children: [
              buildPanel(
                value: 'a',
                title: '标题',
                bodyText: '内容',
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

    testWidgets('窄屏和大字体下 Header 扩展点不溢出', (tester) async {
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
          TCollapse<String>(
            value: const ['a'],
            onChanged: (_) {},
            children: [
              buildPanel(
                value: 'a',
                title: '这是一个用于验证窄屏和大字体布局的很长标题',
                bodyText: '这是较长的折叠内容，用于验证内容可以自然换行。',
                trailingBuilder: (context, expanded) => const Text('收起'),
              ),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('面板默认 value key 在重排后保留 body 状态', (tester) async {
      var reversed = false;
      late StateSetter setState;

      TCollapsePanel<String> statefulPanel(String id) {
        return TCollapsePanel<String>(
          value: id,
          headerBuilder: (_, __) => Text('标题$id'),
          body: _StatefulPanelBody(id: id),
        );
      }

      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setter) {
              setState = setter;
              final panels = [statefulPanel('A'), statefulPanel('B')];
              return TCollapse<String>(
                value: const ['A', 'B'],
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

    testWidgets('空列表、动画时长和 elevation 可渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TCollapse<String>(
            value: [],
            animationDuration: Duration(milliseconds: 100),
            elevation: 4,
            children: [],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(TCollapse<String>), findsOneWidget);
    });
  });

  group('TCollapse 契约断言', () {
    testWidgets('重复 Panel value 被拒绝', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse<String>(
            value: const [],
            children: [
              buildPanel(value: 'a', title: 'A', bodyText: '内容'),
              buildPanel(value: 'a', title: 'B', bodyText: '内容'),
            ],
          ),
        ),
      );
      expect(tester.takeException(), isAssertionError);
    });

    testWidgets('重复展开 value 被拒绝', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse<String>(
            value: const ['a', 'a'],
            children: [buildPanel(value: 'a', title: 'A', bodyText: '内容')],
          ),
        ),
      );
      expect(tester.takeException(), isAssertionError);
    });

    testWidgets('不存在的展开 value 被拒绝', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse<String>(
            value: const ['missing'],
            children: [buildPanel(value: 'a', title: 'A', bodyText: '内容')],
          ),
        ),
      );
      expect(tester.takeException(), isAssertionError);
    });

    testWidgets('accordion 多个展开 value 被拒绝', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TCollapse<String>(
            mode: TCollapseMode.accordion,
            value: const ['a', 'b'],
            children: [
              buildPanel(value: 'a', title: 'A', bodyText: '内容'),
              buildPanel(value: 'b', title: 'B', bodyText: '内容'),
            ],
          ),
        ),
      );
      expect(tester.takeException(), isAssertionError);
    });
  });
}

Widget defaultExpandIconBuilder(BuildContext context, bool isExpanded) {
  return Icon(isExpanded ? Icons.expand_less : Icons.expand_more);
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
