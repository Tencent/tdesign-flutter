import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/sidebar/t_wrap_sidebar_item.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrapWithTheme(Widget child, {TSideBarThemeData? sideBarTheme}) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [
          TThemeData.defaultData(),
          if (sideBarTheme != null) sideBarTheme,
        ],
      ),
      home: Scaffold(body: child),
    );
  }

  List<TSideBarItem> buildItems({int count = 5}) {
    return List.generate(
      count,
      (i) => TSideBarItem(value: i, label: '选项${i + 1}'),
    );
  }

  group('TSideBarItem', () {
    test('默认构造', () {
      const item = TSideBarItem();
      expect(item.value, -1);
      expect(item.label, '');
      expect(item.disabled, false);
      expect(item.badge, null);
      expect(item.icon, null);
      expect(item.textStyle, null);
    });

    test('带参数构造', () {
      const item = TSideBarItem(value: 1, label: '选项', disabled: true);
      expect(item.value, 1);
      expect(item.label, '选项');
      expect(item.disabled, true);
    });
  });

  group('TSideBarVariant', () {
    test('枚举值', () {
      expect(TSideBarVariant.values.length, 2);
      expect(TSideBarVariant.values, contains(TSideBarVariant.normal));
      expect(TSideBarVariant.values, contains(TSideBarVariant.outline));
    });
  });

  group('TSideBarThemeData', () {
    test('默认构造', () {
      const data = TSideBarThemeData();
      expect(data.style, null);
      expect(data.height, null);
      expect(data.selectedColor, null);
    });

    test('copyWith', () {
      const data = TSideBarThemeData(height: 400);
      final copied = data.copyWith(height: 500, selectedColor: Colors.red);
      expect(copied.height, 500);
      expect(copied.selectedColor, Colors.red);
    });

    test('lerp', () {
      const data1 = TSideBarThemeData(height: 400);
      const data2 = TSideBarThemeData(height: 500);
      final lerped = data1.lerp(data2, 0.5);
      expect(lerped.height, 450);
    });

    test('lerp 非 TSideBarThemeData 返回自身', () {
      const data = TSideBarThemeData(height: 400);
      final lerped = data.lerp(null, 0.5);
      expect(lerped, same(data));
    });
  });

  group('TSideBar 基础渲染', () {
    testWidgets('基础渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(value: 0, children: buildItems(), onChanged: (_) {}),
      ));
      expect(find.byType(TSideBar), findsOneWidget);
      expect(find.text('选项1'), findsOneWidget);
      expect(find.text('选项5'), findsOneWidget);
    });

    testWidgets('value 指定选中项', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(value: 2, children: buildItems(), onChanged: (_) {}),
      ));
      await tester.pumpAndSettle();
      final dynamic state = tester.state(find.byType(TSideBar));
      expect(state.currentValue, 2);
      expect(state.currentIndex, 2);
    });

    testWidgets('空 children 不崩溃', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSideBar(value: 0, children: []),
      ));
      expect(find.byType(TSideBar), findsOneWidget);
    });

    testWidgets('value 无匹配项时不选中', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(value: 99, children: buildItems(), onChanged: (_) {}),
      ));
      final dynamic state = tester.state(find.byType(TSideBar));
      expect(state.currentValue, isNull);
      expect(state.currentIndex, isNull);
    });
  });

  group('TSideBar 样式与 Theme', () {
    testWidgets('normal 样式', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(
          value: 0,
          style: TSideBarVariant.normal,
          children: buildItems(),
          onChanged: (_) {},
        ),
      ));
      expect(find.byType(TSideBar), findsOneWidget);
    });

    testWidgets('outline 样式', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(
          value: 0,
          style: TSideBarVariant.outline,
          children: buildItems(),
          onChanged: (_) {},
        ),
      ));
      expect(find.byType(TSideBar), findsOneWidget);
    });

    testWidgets('ThemeData 设置默认 style 和 height', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(value: 0, children: buildItems(), onChanged: (_) {}),
        sideBarTheme: const TSideBarThemeData(
          style: TSideBarVariant.outline,
          height: 500,
          selectedColor: Colors.red,
          unSelectedColor: Colors.grey,
          selectedBgColor: Colors.blue,
          unSelectedBgColor: Colors.white,
          selectedTextStyle: TextStyle(fontWeight: FontWeight.bold),
          contentPadding: EdgeInsets.all(8),
        ),
      ));
      expect(find.byType(TSideBar), findsOneWidget);
    });

    testWidgets('构造器参数覆盖 ThemeData', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(
          value: 0,
          children: buildItems(),
          onChanged: (_) {},
          selectedColor: Colors.blue,
          unSelectedColor: Colors.green,
          selectedBgColor: Colors.yellow,
          unSelectedBgColor: Colors.black12,
          selectedTextStyle: const TextStyle(color: Colors.purple),
          contentPadding: const EdgeInsets.all(4),
          height: 300,
        ),
        sideBarTheme: const TSideBarThemeData(selectedColor: Colors.red),
      ));
      expect(find.byType(TSideBar), findsOneWidget);
    });
  });

  group('TSideBar 交互', () {
    testWidgets('点击触发 onChanged 但不自行改选中态', (tester) async {
      int? changedValue;
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(
          value: 0,
          children: buildItems(),
          onChanged: (value) => changedValue = value,
        ),
      ));
      await tester.tap(find.text('选项3'));
      await tester.pumpAndSettle();
      final dynamic state = tester.state(find.byType(TSideBar));
      expect(changedValue, 2);
      expect(state.currentValue, 0);
    });

    testWidgets('父级回写 value 后同步高亮', (tester) async {
      var value = 0;
      late StateSetter setState;
      await tester.pumpWidget(wrapWithTheme(
        StatefulBuilder(
          builder: (context, setter) {
            setState = setter;
            return TSideBar(
              value: value,
              children: buildItems(),
              onChanged: (next) => setState(() => value = next),
            );
          },
        ),
      ));
      await tester.tap(find.text('选项4'));
      await tester.pumpAndSettle();
      final dynamic state = tester.state(find.byType(TSideBar));
      expect(state.currentValue, 3);
      expect(state.currentIndex, 3);
    });

    testWidgets('disabled 项不可点击', (tester) async {
      int? selectedValue;
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(
          value: 0,
          children: const [
            TSideBarItem(value: 0, label: '可用'),
            TSideBarItem(value: 1, label: '禁用', disabled: true),
          ],
          onChanged: (value) => selectedValue = value,
        ),
      ));
      await tester.tap(find.text('禁用'));
      await tester.pumpAndSettle();
      expect(selectedValue, null);
    });

    testWidgets('重复点击当前项不触发 onChanged', (tester) async {
      var callCount = 0;
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(
          value: 0,
          children: buildItems(),
          onChanged: (_) => callCount++,
        ),
      ));
      await tester.tap(find.text('选项1'));
      await tester.pumpAndSettle();
      expect(callCount, 0);
    });

    testWidgets('onChanged 为 null 时禁用整栏', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(value: 0, children: buildItems()),
      ));
      final opacity =
          tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity));
      expect(opacity.opacity, 0.4);
    });
  });

  group('TSideBar loading', () {
    testWidgets('loading 状态', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(value: 0, loading: true, children: buildItems()),
      ));
      expect(find.byType(TLoading), findsOneWidget);
    });

    testWidgets('自定义 loadingWidget', (tester) async {
      const loadingKey = Key('loading');
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(
          value: 0,
          loading: true,
          loadingWidget: const Text('加载中', key: loadingKey),
          children: buildItems(),
        ),
      ));
      expect(find.byKey(loadingKey), findsOneWidget);
    });
  });

  group('TWrapSideBarItem 覆盖率补充', () {
    testWidgets('normal 样式未选中且未指定 unSelectedBgColor', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TWrapSideBarItem(
          style: TSideBarVariant.normal,
          label: '短',
          value: 1,
          disabled: false,
        ),
      ));
      expect(find.byType(TWrapSideBarItem), findsOneWidget);
    });

    testWidgets('默认文案样式尊重 Flutter TextTheme', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TWrapSideBarItem(
          style: TSideBarVariant.normal,
          label: '默认',
          value: 1,
          disabled: false,
        ),
      ));

      final text = tester.widget<Text>(find.text('默认'));
      final textTheme = Theme.of(tester.element(find.text('默认'))).textTheme;
      expect(text.style?.fontSize, textTheme.bodyMedium?.fontSize);
      expect(text.style?.height, textTheme.bodyMedium?.height);
    });

    testWidgets('选中且设置 selectedTextStyle 颜色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TWrapSideBarItem(
          style: TSideBarVariant.normal,
          label: '选',
          value: 2,
          selected: true,
          disabled: false,
          icon: Icons.star,
          selectedTextStyle: TextStyle(color: Colors.red),
        ),
      ));
      expect(find.byType(TWrapSideBarItem), findsOneWidget);
    });

    testWidgets('带图标和 badge 时保留主行内容', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TWrapSideBarItem(
          style: TSideBarVariant.normal,
          label: '短',
          value: 3,
          disabled: false,
          icon: Icons.star,
          badge: TBadge(label: '1'),
        ),
      ));
      expect(find.byType(TWrapSideBarItem), findsOneWidget);
      final icon = tester.getRect(find.byIcon(Icons.star));
      final label = tester.getRect(find.text('短'));
      final badge = tester.getRect(find.byType(TBadge));
      expect(icon.right, lessThanOrEqualTo(label.left));
      expect(badge.top, lessThan(label.top));
    });

    testWidgets('长标签与浮层 badge 可共同渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TWrapSideBarItem(
          style: TSideBarVariant.normal,
          label: '很长很长的标签内容xxx',
          value: 4,
          disabled: false,
          badge: TBadge(label: '9'),
        ),
      ));
      expect(find.byType(TWrapSideBarItem), findsOneWidget);
      expect(find.text('很长很长的标签内容xxx'), findsOneWidget);
      expect(find.byType(TBadge), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('长标签在窄宽度下保持单行省略', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const Center(
          child: SizedBox(
            width: 120,
            child: TWrapSideBarItem(
              style: TSideBarVariant.normal,
              label: '这是一个非常非常长的侧边栏标题',
              value: 5,
              disabled: false,
              badge: TBadge(label: '9'),
            ),
          ),
        ),
      ));

      expect(tester.takeException(), isNull);
      final text = tester.widget<Text>(find.text('这是一个非常非常长的侧边栏标题'));
      expect(text.maxLines, 1);
      expect(text.overflow, TextOverflow.ellipsis);
    });
  });

  group('内部展示项映射', () {
    testWidgets('findSideItem 可按 value 查找当前展示项', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSideBar(value: 0, children: buildItems(count: 3), onChanged: (_) {}),
      ));
      final dynamic state = tester.state(find.byType(TSideBar));
      final dynamic item = state.findSideItem(2);
      expect(item.value, 2);
      expect(item.index, 2);
    });

    testWidgets('didUpdateWidget children 和 value 变化', (tester) async {
      var count = 3;
      var value = 0;
      late StateSetter setState;
      await tester.pumpWidget(wrapWithTheme(
        StatefulBuilder(
          builder: (context, setter) {
            setState = setter;
            return TSideBar(
              children: buildItems(count: count),
              value: value,
              onChanged: (_) {},
            );
          },
        ),
      ));
      setState(() {
        count = 5;
        value = 4;
      });
      await tester.pumpAndSettle();
      final dynamic state = tester.state(find.byType(TSideBar));
      expect(state.currentValue, 4);
    });

    testWidgets('value 更新到超出视口项触发滚动路径', (tester) async {
      var value = 0;
      late StateSetter setState;
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 120,
          child: StatefulBuilder(
            builder: (context, setter) {
              setState = setter;
              return TSideBar(
                children: buildItems(count: 20),
                value: value,
                onChanged: (_) {},
              );
            },
          ),
        ),
      ));
      setState(() => value = 10);
      await tester.pumpAndSettle();
      expect(find.byType(TSideBar), findsOneWidget);
      final sideBarRect = tester.getRect(find.byType(TSideBar));
      final selectedCenter = tester.getCenter(find.text('选项11'));
      expect(selectedCenter.dy,
          inInclusiveRange(sideBarRect.top, sideBarRect.bottom));
    });
  });
}
