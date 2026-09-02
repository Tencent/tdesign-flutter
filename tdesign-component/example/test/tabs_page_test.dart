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
    expect(page.children.map((module) => module.children.length), [8, 1, 3]);

    final element = tester.element(find.byType(TTabsPage));
    TTabsBar barAt(int moduleIndex, int itemIndex) {
      final built = page.children[moduleIndex].children[itemIndex].builder(
        element,
      );
      if (built is DefaultTabController) {
        return built.child as TTabsBar;
      }
      throw TestFailure('示例未使用局部 DefaultTabController');
    }

    final lineBar = barAt(2, 0);
    final tagBar = barAt(2, 1);
    final cardBar = barAt(2, 2);
    expect(lineBar.variant, TTabsBarVariant.line);
    expect(tagBar.variant, TTabsBarVariant.tag);
    expect(cardBar.variant, TTabsBarVariant.card);
    for (final bar in [lineBar, tagBar, cardBar]) {
      expect(bar.controller, isNull);
      expect(bar.indicator, isNull);
      expect(bar.decoration, isNull);
    }

    final scrollBar = barAt(0, 4);
    expect(scrollBar.tabs, hasLength(6));
    expect(scrollBar.isScrollable, isTrue);

    final item = page.children[0].children[6];
    expect(item.desc, '带徽标选项卡');

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
  });
}
