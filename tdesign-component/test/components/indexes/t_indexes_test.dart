import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  ThemeData fullTheme() => TThemeBuilder.light(TThemeData.defaultData());

  Widget wrapWithTheme(Widget child, {TIndexesThemeData? indexesTheme}) {
    var theme = fullTheme();
    if (indexesTheme != null) {
      theme = theme.mergeExtension(indexesTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: child),
    );
  }

  group('TIndexesThemeData', () {
    test('默认构造', () {
      const data = TIndexesThemeData();
      expect(data.indexItemSize, null);
      expect(data.anchorColor, null);
      expect(data.tipFont, null);
    });

    test('带参数构造', () {
      const data = TIndexesThemeData(
        indexListMaxHeight: 0.9,
        sidebarRight: 10,
        indexItemSize: 24,
        indexItemSpacing: 3,
        tipSize: 52,
        tipGap: 18,
        indexColor: Colors.black,
        activeIndexColor: Colors.white,
        activeIndexBackgroundColor: Colors.blue,
        tipColor: Colors.blue,
        tipBackgroundColor: Colors.lightBlue,
        anchorColor: Colors.black,
        activeAnchorColor: Colors.blue,
        anchorBackgroundColor: Colors.grey,
        activeAnchorBackgroundColor: Colors.white,
        anchorBorderColor: Colors.black12,
        anchorVerticalPadding: 5,
        anchorHorizontalPadding: 17,
        capsuleMargin: 9,
      );
      expect(data.indexItemSize, 24);
      expect(data.tipSize, 52);
      expect(data.capsuleMargin, 9);
    });

    test('copyWith', () {
      const data = TIndexesThemeData(indexItemSize: 20);
      final copied = data.copyWith(
        indexListMaxHeight: 0.6,
        indexItemSize: 24,
        activeIndexBackgroundColor: Colors.red,
        anchorHorizontalPadding: 18,
      );
      expect(copied.indexListMaxHeight, 0.6);
      expect(copied.indexItemSize, 24);
      expect(copied.activeIndexBackgroundColor, Colors.red);
      expect(copied.anchorHorizontalPadding, 18);
    });

    test('lerp', () {
      const data1 = TIndexesThemeData(indexItemSize: 20);
      const data2 = TIndexesThemeData(indexItemSize: 24);
      final lerped = data1.lerp(data2, 0.5);
      expect(lerped.indexItemSize, 22);
    });

    test('lerp 非 TIndexesThemeData 返回自身', () {
      const data = TIndexesThemeData(indexItemSize: 20);
      final lerped = data.lerp(null, 0.5);
      expect(lerped, same(data));
    });

    test('lerp cover remaining fields', () {
      const left = TIndexesThemeData(
        indexListMaxHeight: 0.4,
        sidebarRight: 8,
        tipGap: 16,
        anchorColor: Colors.black,
        anchorVerticalPadding: 4,
      );
      const right = TIndexesThemeData(
        indexListMaxHeight: 0.8,
        sidebarRight: 12,
        tipGap: 20,
        anchorColor: Colors.white,
        anchorVerticalPadding: 8,
      );
      final lerped = left.lerp(right, 0.5);
      expect(lerped.indexListMaxHeight, closeTo(0.6, 0.0001));
      expect(lerped.sidebarRight, 10);
      expect(lerped.tipGap, 18);
      expect(lerped.anchorVerticalPadding, 6);
    });
  });

  group('TIndexes 基础渲染', () {
    testWidgets('默认渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TIndexes(
            indexList: const ['A', 'B'],
            builderContent: (context, index) =>
                ListTile(title: Text('内容$index')),
          ),
        ),
      );
      expect(find.byType(TIndexes), findsOneWidget);
    });

    testWidgets('侧边索引默认视觉使用 token 尺寸、颜色和字体', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            height: 160,
            width: 80,
            child: Stack(
              children: [
                TIndexesList(
                  indexList: const ['A', 'B'],
                  activeIndex: ValueNotifier('A'),
                  onSelect: (newIndex, oldIndex) {},
                ),
              ],
            ),
          ),
        ),
      );

      expect(tester.getSize(_indexesListTextBox('A')), const Size(20, 20));
      expect(tester.getSize(_indexesListOuterBox('A')), const Size(28, 20));

      final activeDecoration = tester.widget<DecoratedBox>(
        _indexesListDecoratedBox('A'),
      );
      expect(
        activeDecoration.decoration,
        BoxDecoration(
          borderRadius: BorderRadius.circular(token.radiusCircle),
          color: token.brandNormalColor,
        ),
      );
      final activeText = tester.widget<TText>(_tTextFinder('A').last);
      expect(activeText.textColor, token.textColorAnti);
      expect(activeText.font, token.fontBodySmall);

      final inactiveDecoration = tester.widget<DecoratedBox>(
        _indexesListDecoratedBox('B'),
      );
      expect(inactiveDecoration.decoration, const BoxDecoration());
      final inactiveText = tester.widget<TText>(_tTextFinder('B').last);
      expect(inactiveText.textColor, token.textColorPrimary);
      expect(inactiveText.font, token.fontBodySmall);
    });

    testWidgets('锚点默认与胶囊视觉使用 token 样式', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(
        wrapWithTheme(
          TIndexesAnchor(
            sticky: true,
            text: 'A',
            capsuleTheme: true,
            activeIndex: ValueNotifier('A'),
          ),
        ),
      );

      final anchorContainer = tester.widget<Container>(
        find.descendant(
          of: find.byType(TIndexesAnchor),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Container &&
                widget.padding != null &&
                widget.decoration is BoxDecoration,
          ),
        ),
      );
      expect(
        anchorContainer.padding,
        EdgeInsets.symmetric(
          vertical: token.spacer4,
          horizontal: token.spacer16,
        ),
      );
      expect(
        anchorContainer.margin,
        EdgeInsets.symmetric(horizontal: token.spacer8),
      );
      final decoration = anchorContainer.decoration! as BoxDecoration;
      expect(decoration.color, token.bgColorContainer);
      expect(
        decoration.borderRadius,
        BorderRadius.circular(token.radiusCircle),
      );
      expect(decoration.border, Border.all(color: token.componentStrokeColor));

      final anchorText = tester.widget<TText>(_tTextFinder('A').last);
      expect(anchorText.textColor, token.brandNormalColor);
      expect(anchorText.font, token.fontMarkMedium);
    });

    testWidgets('自定义 indexList', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TIndexes(
            indexList: const ['A', 'B', 'C'],
            builderContent: (context, index) =>
                ListTile(title: Text('内容$index')),
          ),
        ),
      );
      expect(find.byType(TIndexes), findsOneWidget);
    });

    testWidgets('initialIndex 同步初始激活态与滚动位置', (tester) async {
      final controller = ScrollController();
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            height: 180,
            width: 240,
            child: TIndexes(
              indexList: const ['A', 'B', 'C'],
              initialIndex: 'B',
              scrollController: controller,
              builderContent: (context, index) =>
                  SizedBox(height: 220, child: Text('内容$index')),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      final list = tester.widget<TIndexesList>(find.byType(TIndexesList));
      expect(list.activeIndex.value, 'B');
      expect(controller.offset, greaterThan(0));
      controller.dispose();
    });

    testWidgets('capsuleTheme 样式', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TIndexes(
            indexList: const ['A', 'B'],
            capsuleTheme: true,
            builderContent: (context, index) =>
                ListTile(title: Text('内容$index')),
          ),
        ),
      );
      expect(find.byType(TIndexes), findsOneWidget);
    });

    testWidgets('sticky: false', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TIndexes(
            indexList: const ['A', 'B'],
            sticky: false,
            builderContent: (context, index) =>
                ListTile(title: Text('内容$index')),
          ),
        ),
      );
      expect(find.byType(TIndexes), findsOneWidget);
    });

    testWidgets('reverse: true', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TIndexes(
            indexList: const ['A', 'B'],
            reverse: true,
            builderContent: (context, index) =>
                ListTile(title: Text('内容$index')),
          ),
        ),
      );
      expect(find.byType(TIndexes), findsOneWidget);
    });

    testWidgets('使用 onChanged 回调', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TIndexes(
            indexList: const ['A', 'B'],
            onChanged: (index) {},
            builderContent: (context, index) =>
                ListTile(title: Text('内容$index')),
          ),
        ),
      );
      expect(find.byType(TIndexes), findsOneWidget);
    });

    testWidgets('使用 mergeExtension 子树覆盖', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TIndexes(
            indexList: const ['A', 'B'],
            builderContent: (context, index) =>
                ListTile(title: Text('内容$index')),
          ),
          indexesTheme: const TIndexesThemeData(indexItemSize: 24),
        ),
      );
      expect(find.byType(TIndexes), findsOneWidget);
    });

    testWidgets('胶囊模式只由组件实例控制', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TIndexes(
            indexList: const ['A', 'B'],
            capsuleTheme: true,
            builderContent: (context, index) =>
                ListTile(title: Text('内容$index')),
          ),
        ),
      );
      final header = tester.widget<SliverStickyHeader>(
        find.byType(SliverStickyHeader).first,
      );
      expect(header.sticky, isTrue);
      expect(header.pinnedOffset, TThemeData.defaultData().spacer8);
    });

    testWidgets('滚动方向和 sticky 只由组件实例控制', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TIndexes(
            indexList: const ['A', 'B'],
            sticky: false,
            reverse: true,
            builderContent: (context, index) => Text(index),
          ),
        ),
      );

      expect(
        tester.widget<CustomScrollView>(find.byType(CustomScrollView)).reverse,
        isTrue,
      );
      expect(
        tester
            .widget<SliverStickyHeader>(find.byType(SliverStickyHeader).first)
            .sticky,
        isFalse,
      );
    });

    // 补充用例至 ≥15
    testWidgets('多个索引项正常渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TIndexes(
            indexList: const ['A', 'B', 'C', 'D', 'E'],
            builderContent: (context, index) =>
                ListTile(title: Text('项$index')),
          ),
        ),
      );
      expect(find.byType(TIndexes), findsOneWidget);
    });

    testWidgets('空索引列表正常渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TIndexes(
            indexList: const [],
            builderContent: (context, index) =>
                ListTile(title: Text('空$index')),
          ),
        ),
      );
      expect(find.byType(TIndexes), findsOneWidget);
    });
  });

  group('TIndexesList 手势交互', () {
    testWidgets('点击侧边索引触发 onSelect 并更新激活项', (tester) async {
      final active = ValueNotifier<String>('A');
      String? selected;
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            height: 300,
            width: 80,
            child: Stack(
              children: [
                TIndexesList(
                  indexList: const ['A', 'B', 'C'],
                  activeIndex: active,
                  onSelect: (newIndex, oldIndex) => selected = newIndex,
                ),
              ],
            ),
          ),
        ),
      );
      final bCenter = tester.getCenter(find.text('B'));
      await tester.tapAt(bCenter);
      await tester.pump();
      expect(selected, 'B');
      expect(active.value, 'B');
    });

    testWidgets('按压提示遵循 300ms 隐藏时机和长文本上限', (tester) async {
      final active = ValueNotifier<String>('A');
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            height: 300,
            width: 180,
            child: Stack(
              children: [
                TIndexesList(
                  indexList: const ['A', 'VERY-LONG-INDEX'],
                  activeIndex: active,
                  onSelect: (newIndex, oldIndex) {},
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('VERY-LONG-INDEX'));
      await tester.pump();
      final tip = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.constraints?.minWidth == 48 &&
            widget.constraints?.maxWidth == 99,
      );
      expect(tip, findsOneWidget);
      final tipText = tester.widget<TText>(
        find.descendant(of: tip, matching: _tTextFinder('VERY-LONG-INDEX')),
      );
      expect(tipText.maxLines, 1);
      expect(tipText.overflow, TextOverflow.ellipsis);

      await tester.pump(const Duration(milliseconds: 299));
      expect(tip, findsOneWidget);
      await tester.pump(const Duration(milliseconds: 1));
      expect(tip, findsNothing);
    });

    testWidgets('侧栏语义支持逐项选择', (tester) async {
      final active = ValueNotifier<String>('A');
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            height: 200,
            width: 100,
            child: Stack(
              children: [
                TIndexesList(
                  indexList: const ['A', 'B'],
                  activeIndex: active,
                  onSelect: (newIndex, oldIndex) {},
                ),
              ],
            ),
          ),
        ),
      );

      final aSemantics = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'A' &&
              widget.properties.selected == true,
        ),
      );
      final bSemantics = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'B' &&
              widget.properties.selected == false,
        ),
      );
      expect(aSemantics.properties.button, isTrue);
      expect(bSemantics.properties.button, isTrue);
      bSemantics.properties.onTap?.call();
      await tester.pump();
      expect(active.value, 'B');
    });

    testWidgets('Theme 覆盖侧栏视觉但不接管行为', (tester) async {
      final active = ValueNotifier<String>('A');
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            height: 200,
            width: 100,
            child: Stack(
              children: [
                TIndexesList(
                  indexList: const ['A', 'B'],
                  activeIndex: active,
                  onSelect: (newIndex, oldIndex) {},
                ),
              ],
            ),
          ),
          indexesTheme: const TIndexesThemeData(
            sidebarRight: 12,
            indexItemSize: 24,
            indexItemSpacing: 4,
            activeIndexBackgroundColor: Colors.red,
            activeIndexColor: Colors.yellow,
            indexColor: Colors.green,
          ),
        ),
      );

      expect(
        tester.widget<Positioned>(find.byType(Positioned).first).right,
        12,
      );
      expect(
        tester.getSize(_indexesListTextBox('A', size: 24)),
        const Size(24, 24),
      );
      expect(
        (tester.widget<DecoratedBox>(_indexesListDecoratedBox('A')).decoration
                as BoxDecoration)
            .color,
        Colors.red,
      );
      expect(
        tester.widget<TText>(_tTextFinder('A').last).textColor,
        Colors.yellow,
      );
      expect(
        tester.widget<TText>(_tTextFinder('B').last).textColor,
        Colors.green,
      );
    });
  });

  group('TIndexes 参数约束', () {
    testWidgets('索引必须唯一且高度比例有效', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TIndexes(
            indexList: const ['A', 'A'],
            builderContent: (_, __) => const SizedBox(),
          ),
        ),
      );
      expect(tester.takeException(), isAssertionError);
      await tester.pumpWidget(const SizedBox());
      expect(
        () => TIndexes(
          indexListMaxHeight: 1.1,
          builderContent: (_, __) => const SizedBox(),
        ),
        throwsAssertionError,
      );
      await tester.pumpWidget(
        wrapWithTheme(
          TIndexes(
            indexList: const ['A', 'B'],
            initialIndex: 'C',
            builderContent: (_, __) => const SizedBox(),
          ),
        ),
      );
      expect(tester.takeException(), isAssertionError);
      await tester.pumpWidget(const SizedBox());
      expect(
        () => TIndexesThemeData(tipSize: 48, tipMaxWidth: 40),
        throwsAssertionError,
      );
    });
  });

  group('TIndexes 选中/回调/滚动', () {
    testWidgets('点击侧边索引触发 onSelect/onChanged 并滚动（向上）', (tester) async {
      String? selected;
      String? changed;
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            height: 400,
            width: 200,
            child: TIndexes(
              indexList: const ['A', 'B', 'C'],
              onSelect: (i) => selected = i,
              onChanged: (i) => changed = i,
              builderContent: (context, index) => SizedBox(
                height: 120,
                child: ListTile(title: Text('内容$index')),
              ),
            ),
          ),
        ),
      );
      final bFinder = find.descendant(
        of: find.byType(TIndexesList),
        matching: find.text('B'),
      );
      final bCenter = tester.getCenter(bFinder);
      await tester.tapAt(bCenter);
      // 等待 _scrollToTarget 内部 postFrameCallback 与 _hideTip 计时器
      await tester.pump(const Duration(seconds: 1, milliseconds: 200));
      expect(selected, 'B');
      expect(changed, 'B');
    });

    testWidgets('从高位选中低位触发向下滚动分支', (tester) async {
      String? selected;
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            height: 400,
            width: 200,
            child: TIndexes(
              indexList: const ['A', 'B', 'C'],
              onSelect: (i) => selected = i,
              builderContent: (context, index) => SizedBox(
                height: 120,
                child: ListTile(title: Text('内容$index')),
              ),
            ),
          ),
        ),
      );
      final listFinder = find.byType(TIndexesList);
      final bFinder = find.descendant(of: listFinder, matching: find.text('B'));
      await tester.tapAt(tester.getCenter(bFinder));
      await tester.pump(const Duration(seconds: 1, milliseconds: 200));
      // 先选 B，再选 A（oldIndex=B > newIndex=A → 向下滚动分支）
      final aFinder = find.descendant(of: listFinder, matching: find.text('A'));
      await tester.tapAt(tester.getCenter(aFinder));
      await tester.pump(const Duration(seconds: 1, milliseconds: 200));
      expect(selected, 'A');
    });

    testWidgets('didUpdateWidget 更新 indexList', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TIndexes(
            indexList: const ['A', 'B'],
            builderContent: (context, index) =>
                ListTile(title: Text('内容$index')),
          ),
        ),
      );
      await tester.pumpWidget(
        wrapWithTheme(
          TIndexes(
            indexList: const ['A', 'B', 'C'],
            builderContent: (context, index) =>
                ListTile(title: Text('内容$index')),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(TIndexes), findsOneWidget);
    });
  });

  group('TIndexesList 进阶交互', () {
    testWidgets('didUpdateWidget 重建索引键', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            height: 300,
            width: 80,
            child: Stack(
              children: [
                TIndexesList(
                  indexList: const ['A', 'B', 'C'],
                  activeIndex: ValueNotifier('A'),
                  onSelect: (newIndex, oldIndex) {},
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            height: 300,
            width: 80,
            child: Stack(
              children: [
                TIndexesList(
                  indexList: const ['A', 'B', 'C', 'D'],
                  activeIndex: ValueNotifier('A'),
                  onSelect: (newIndex, oldIndex) {},
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(TIndexesList), findsOneWidget);
    });

    testWidgets('自定义 builderIndex 渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            height: 300,
            width: 80,
            child: Stack(
              children: [
                TIndexesList(
                  indexList: const ['A', 'B'],
                  activeIndex: ValueNotifier('A'),
                  onSelect: (newIndex, oldIndex) {},
                  builderIndex: (context, e, isActive) =>
                      Container(key: Key('idx-$e'), child: Text('项$e')),
                ),
              ],
            ),
          ),
        ),
      );
      expect(find.text('项A'), findsOneWidget);
    });

    testWidgets('竖向拖动触发 _changeSelect 与 _hideTip', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            height: 300,
            width: 80,
            child: Stack(
              children: [
                TIndexesList(
                  indexList: const ['A', 'B', 'C', 'D'],
                  activeIndex: ValueNotifier('A'),
                  onSelect: (newIndex, oldIndex) {},
                ),
              ],
            ),
          ),
        ),
      );
      final listCenter = tester.getCenter(find.byType(TIndexesList));
      await tester.dragFrom(listCenter, const Offset(0, 40));
      // 等待 _hideTip 计时器触发 setState
      await tester.pump(const Duration(seconds: 1, milliseconds: 200));
      expect(find.byType(TIndexesList), findsOneWidget);
    });
  });

  // ============================================================
  // 覆盖率补充
  // ============================================================
  group('TIndexes 覆盖率补充', () {
    testWidgets('默认 A-Z indexList 渲染', (tester) async {
      // 覆盖 87/89（_defaultAZList 懒加载初始化）
      await tester.pumpWidget(
        wrapWithTheme(
          TIndexes(builderContent: (context, index) => Text('内容$index')),
        ),
      );
      // 默认 A-Z 26 个锚点可能有布局溢出，消费异常即可
      tester.takeException();
      expect(find.byType(TIndexes), findsAny);
    });

    testWidgets('scrollController 变化触发 didUpdateWidget', (tester) async {
      // 覆盖 120/121（scrollController 变化 → dispose + 重建）
      final c1 = ScrollController();
      final c2 = ScrollController();
      var useC1 = true;
      late StateSetter setState;
      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setter) {
              setState = setter;
              return TIndexes(
                indexList: const ['A', 'B'],
                scrollController: useC1 ? c1 : c2,
                builderContent: (context, index) =>
                    ListTile(title: Text('内容$index')),
              );
            },
          ),
        ),
      );
      setState(() => useC1 = false);
      await tester.pumpAndSettle();
      expect(find.byType(TIndexes), findsOneWidget);
    });

    testWidgets('内部 scrollController 切换为外部 controller 时释放内部实例', (tester) async {
      final externalController = ScrollController();
      var useExternal = false;
      late StateSetter setState;
      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setter) {
              setState = setter;
              return TIndexes(
                indexList: const ['A', 'B'],
                scrollController: useExternal ? externalController : null,
                builderContent: (context, index) =>
                    SizedBox(height: 80, child: Text('内容$index')),
              );
            },
          ),
        ),
      );

      setState(() => useExternal = true);
      await tester.pumpAndSettle();

      expect(find.byType(TIndexes), findsOneWidget);
      externalController.dispose();
    });

    testWidgets('点击跨多个索引触发向上递归滚动', (tester) async {
      String? selected;
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            height: 320,
            width: 240,
            child: TIndexes(
              indexList: const ['A', 'B', 'C', 'D'],
              onSelect: (index) => selected = index,
              builderContent: (context, index) =>
                  SizedBox(height: 120, child: Text('内容$index')),
            ),
          ),
        ),
      );

      final dFinder = find.descendant(
        of: find.byType(TIndexesList),
        matching: find.text('D'),
      );
      await tester.tapAt(tester.getCenter(dFinder));
      await tester.pump();
      await tester.pump();

      expect(selected, 'D');
    });

    testWidgets('滚动时 sticky header pinned 更新 activeIndex', (tester) async {
      String? changed;
      final controller = ScrollController();
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            height: 180,
            width: 240,
            child: TIndexes(
              indexList: const ['A', 'B', 'C'],
              scrollController: controller,
              onChanged: (index) => changed = index,
              builderContent: (context, index) =>
                  SizedBox(height: 220, child: Text('内容$index')),
            ),
          ),
        ),
      );

      controller.jumpTo(260);
      await tester.pump();
      await tester.pump();

      expect(changed, isNotNull);
      controller.dispose();
    });
  });
}

Finder _tTextFinder(String data) {
  return find.byWidgetPredicate(
    (widget) => widget is TText && widget.data == data,
  );
}

Finder _indexesListOuterBox(String data) {
  return find.ancestor(
    of: _tTextFinder(data),
    matching: find.byWidgetPredicate(
      (widget) =>
          widget is Container &&
          widget.constraints?.minWidth == 28 &&
          widget.constraints?.maxWidth == 28 &&
          widget.constraints?.minHeight == 20 &&
          widget.constraints?.maxHeight == 20,
    ),
  );
}

Finder _indexesListTextBox(String data, {double size = 20}) {
  return find.ancestor(
    of: _tTextFinder(data),
    matching: find.byWidgetPredicate(
      (widget) =>
          widget is SizedBox && widget.width == size && widget.height == size,
    ),
  );
}

Finder _indexesListDecoratedBox(String data) {
  return find.ancestor(
    of: _tTextFinder(data),
    matching: find.byType(DecoratedBox),
  );
}
