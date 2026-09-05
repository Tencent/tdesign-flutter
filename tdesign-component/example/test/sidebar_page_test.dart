import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'sidebar_demo_test_spec.dart';

void main() {
  testWidgets('SideBar 公开入口与锚点详情对齐设计数据', (tester) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      sidebarDemoPageTestSpec,
      ThemeMode.light,
    );

    expect(find.text('非通栏选项样式'), findsNothing);
    expect(find.text('延迟加载'), findsNothing);
    await tester.tap(find.text('锚点用法'));
    await tester.pumpAndSettle();

    final sideBar = tester.widget<TSideBar>(find.byType(TSideBar));
    expect(sideBar.width, 103);
    expect(sideBar.value, 1);
    expect(sideBar.style, TSideBarVariant.line);
    expect(sideBar.children, hasLength(10));
    expect(sideBar.children[1].badge?.variant, TBadgeVariant.dot);
    expect(sideBar.children[2].badge?.label, '8');

    await tester.tap(find.text('选项').at(2));
    await tester.pumpAndSettle();
    expect(tester.widget<TSideBar>(find.byType(TSideBar)).value, 2);
  });
}
