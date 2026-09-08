import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';
import 'package:tdesign_flutter_example/page/t_badge_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

void main() {
  Widget buildPage() => ChangeNotifierProvider(
    create: (_) => ThemeModeProvider(),
    child: MaterialApp(
      theme: TThemeBuilder.light(TThemeData.defaultData()),
      home: const TBadgePage(),
    ),
  );

  testWidgets('公开分组、文案和示例顺序与设计稿一致', (tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pump();

    final page = tester.widget<ExamplePage>(find.byType(ExamplePage));
    expect(page.desc, '用于告知用户，该区域的状态变化或者待处理任务的数量。');
    expect(page.children.map((module) => module.title), [
      '组件类型',
      '组件样式',
      '组件尺寸',
    ]);
    expect(page.children[0].children.map((item) => item.desc), [
      '红点徽标',
      '数字徽标',
      '自定义徽标',
    ]);
    expect(page.children[1].children.map((item) => item.desc), [
      '圆形徽标',
      '方形徽标',
      '气泡徽标',
      '左侧带状角标',
      '右侧带状角标',
      '左侧三角角标',
      '右侧三角角标',
    ]);
    expect(page.children[2].children.map((item) => item.desc), [
      'Large',
      'Medium',
    ]);
    expect(page.floatingActionButton, isNull);
    expect(page.showTestModule, isFalse);
  });

  testWidgets('设计稿形态、尺寸、偏移和中尺寸按钮均进入公开 Demo', (tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pump();

    final page = tester.widget<ExamplePage>(find.byType(ExamplePage));

    Future<void> pumpItem(int moduleIndex, int itemIndex) async {
      final item = page.children[moduleIndex].children[itemIndex];
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: Scaffold(body: Builder(builder: item.builder)),
        ),
      );
      await tester.pump();
    }

    await pumpItem(0, 0);
    expect(
      tester
          .widgetList<TBadge>(find.byType(TBadge))
          .where((badge) => badge.variant == TBadgeVariant.dot),
      hasLength(3),
    );
    expect(
      tester
          .widgetList<TButton>(find.byType(TButton))
          .every((button) => button.size == TButtonSize.medium),
      isTrue,
    );

    await pumpItem(0, 2);
    expect(
      tester.widget<TBadge>(find.byType(TBadge)).offset,
      const Offset(-16, 0),
    );

    for (final (itemIndex, variants) in [
      (0, [TBadgeVariant.normal]),
      (1, [TBadgeVariant.square]),
      (2, [TBadgeVariant.bubble]),
      (3, [TBadgeVariant.ribbonLeft]),
      (4, [TBadgeVariant.ribbonRight]),
      (5, [TBadgeVariant.triangleLeft]),
      (6, [TBadgeVariant.triangleRight]),
    ]) {
      await pumpItem(1, itemIndex);
      expect(
        tester
            .widgetList<TBadge>(find.byType(TBadge))
            .map((badge) => badge.variant),
        variants,
      );
    }

    await pumpItem(2, 0);
    expect(tester.widget<TBadge>(find.byType(TBadge)).size, TBadgeSize.large);
    await pumpItem(2, 1);
    expect(tester.widget<TBadge>(find.byType(TBadge)).size, TBadgeSize.medium);
  });
}
