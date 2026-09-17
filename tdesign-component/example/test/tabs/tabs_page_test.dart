import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';
import 'package:tdesign_flutter_example/page/t_tabs_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

void main() {
  testWidgets('Tabs 公开分组只通过语义 API 展示组件能力', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeModeProvider(),
        child: MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: const TTabsPage(),
        ),
      ),
    );
    await tester.pump();

    final page = tester.widget<ExamplePage>(find.byType(ExamplePage));
    expect(page.children.map((module) => module.title), [
      '组件类型',
      '组件状态',
      '组件样式',
    ]);
    expect(page.children.map((module) => module.children.length), [8, 1, 4]);

    final element = tester.element(find.byType(TTabsPage));
    Widget builtAt(int moduleIndex, int itemIndex) {
      return page.children[moduleIndex].children[itemIndex].builder(element);
    }

    TTabsBar findBar(Widget widget) {
      if (widget is TTabsBar) {
        return widget;
      }
      if (widget is DefaultTabController) {
        return findBar(widget.child);
      }
      if (widget is SizedBox && widget.child != null) {
        return findBar(widget.child!);
      }
      if (widget is Column) {
        return widget.children.map(findBar).first;
      }
      throw TestFailure('示例中未找到 TTabsBar');
    }

    TTabsBar barAt(int moduleIndex, int itemIndex) =>
        findBar(builtAt(moduleIndex, itemIndex));

    expect(page.children[0].children.map((item) => item.desc), [
      '均分选项卡',
      '',
      '',
      '',
      '等距选项卡',
      '带图标选项卡',
      '带徽标选项卡',
      '带内容区选项卡',
    ]);
    expect(page.children[1].children.single.desc, '选项卡状态');
    expect(page.children[2].children.map((item) => item.desc), [
      '选项卡尺寸',
      '',
      '选项卡样式',
      '',
    ]);

    final splitBars = List.generate(4, (index) => barAt(0, index));
    expect(splitBars.map((bar) => bar.tabs.length), [2, 3, 4, 5]);
    expect(splitBars[0].tabs.map((tab) => tab.text), ['选项', '选项']);
    expect(splitBars[1].tabs.map((tab) => tab.text), ['选项', '选项', '上限六个文字']);
    expect(splitBars[2].tabs.map((tab) => tab.text), [
      '选项',
      '选项',
      '选项',
      '上限四字',
    ]);
    expect(splitBars[3].tabs.map((tab) => tab.text), [
      '选项',
      '选项',
      '选项',
      '选项',
      '上限四字',
    ]);

    final iconBar = barAt(0, 5);
    expect(iconBar.tabs, hasLength(3));
    expect(iconBar.tabs.map((tab) => tab.text), ['选项', '选项', '选项']);
    expect(iconBar.tabs.every((tab) => tab.icon is Icon), isTrue);

    final contentExample = builtAt(0, 7) as SizedBox;
    final contentController = contentExample.child! as DefaultTabController;
    final contentColumn = contentController.child as Column;
    final contentBar = contentColumn.children.first as TTabsBar;
    final contentView =
        (contentColumn.children.last as Expanded).child as TTabsBarView;
    expect(contentController.length, 4);
    expect(contentBar.tabs.map((tab) => tab.text), [
      '选项一',
      '选项二',
      '选项三',
      '选项四',
    ]);
    expect(contentView.controller, isNull);
    expect(contentView.children, hasLength(4));
    final contentTexts = contentView.children.map((child) {
      return (child as Center).child! as TText;
    });
    expect(contentTexts.map((text) => text.data), everyElement('内容区'));
    expect(
      contentTexts.map((text) => text.textColor),
      everyElement(element.tTheme.textColorPlaceholder),
    );

    final statusBar = barAt(1, 0);
    expect(statusBar.tabs.map((tab) => tab.text), ['选中', '默认', '禁用']);
    expect(statusBar.tabs.map((tab) => tab.enabled), [true, true, false]);

    final smallBar = barAt(2, 0);
    final largeBar = barAt(2, 1);
    expect(smallBar.size, TTabsBarSize.small);
    expect(largeBar.size, TTabsBarSize.large);

    final lineBar = barAt(2, 2);
    final tagBar = barAt(2, 3);
    expect(lineBar.variant, TTabsBarVariant.line);
    expect(tagBar.variant, TTabsBarVariant.tag);
    for (final bar in [lineBar, tagBar]) {
      expect(bar.tabs.map((tab) => tab.text), ['选项', '选项', '选项', '选项']);
    }
    for (final bar in [lineBar, tagBar]) {
      expect(bar.controller, isNull);
      expect(bar.indicator, isNull);
      expect(bar.decoration, isNull);
    }

    final spacedBar = barAt(0, 4);
    expect(spacedBar.tabs, hasLength(6));
    expect(spacedBar.isScrollable, isFalse);
    expect(spacedBar.tabs.every((tab) => tab.text == '选项'), isTrue);

    final bar = barAt(0, 6);
    expect(bar.tabs, hasLength(3));
    final badges = bar.tabs.take(2).map((tab) => tab.child! as TBadge).toList();
    expect(badges.map((badge) => badge.variant), [
      TBadgeVariant.dot,
      TBadgeVariant.normal,
    ]);
    expect(badges.every((badge) => badge.child is Row), isTrue);
    expect(bar.tabs[2].child, isNull);
    expect(bar.tabs[2].icon, isA<Icon>());
    for (final badge in badges) {
      final row = badge.child! as Row;
      expect((row.children.last as Text).data, '选项');
    }
    expect(bar.tabs[2].text, '选项');
  });

  testWidgets('Tabs 等距选项卡在 375px 宽度下均匀铺满', (tester) async {
    tester.view.physicalSize = const Size(375, 200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: Scaffold(
          body: DefaultTabController(
            length: 6,
            child: TTabsBar(
              tabs: List.generate(6, (_) => const TTab(text: '选项')),
            ),
          ),
        ),
      ),
    );

    final labels = find.text('选项');
    expect(labels, findsNWidgets(6));
    final centers = List.generate(
      6,
      (index) => tester.getCenter(labels.at(index)).dx,
    );
    for (var index = 1; index < centers.length; index++) {
      expect(centers[index] - centers[index - 1], moreOrLessEquals(62.5));
    }
    expect(centers.first, moreOrLessEquals(31.25));
    expect(centers.last, moreOrLessEquals(343.75));
  });
}
