import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'avatar_demo_test_spec.dart';
import 'demo_page_test_utils.dart';

void main() {
  registerDemoStructureTests(avatarDemoPageTestSpec);

  testWidgets('公开 Demo 的头像组使用设计规格', (tester) async {
    await pumpFullDemoPage(tester, avatarDemoPageTestSpec, ThemeMode.light);

    final groups = tester.widgetList<TAvatarGroup>(find.byType(TAvatarGroup));
    expect(groups, hasLength(2));
    expect(groups.first.dimension, 44);
    expect(groups.first.maxCount, 5);
    expect(groups.first.children, hasLength(6));
    expect(groups.last.dimension, 44);
    expect(groups.last.cascading, TAvatarGroupCascading.endUp);
    expect(groups.last.children, hasLength(6));
  });

  testWidgets('尺寸示例代码不依赖页面私有组件', (tester) async {
    await pumpFullDemoPage(tester, avatarDemoPageTestSpec, ThemeMode.light);

    final source = await rootBundle.loadString(
      'assets/code/avatar._buildSizeAvatar.txt',
    );
    expect(source, contains('Widget avatarRow(TAvatarSize size)'));
    expect(source, isNot(contains('_AvatarSizeRow')));
  });
}
