import 'package:flutter/material.dart';
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
    expect(groups.first.children, hasLength(7));
    expect(groups.last.dimension, 44);
    expect(groups.last.cascading, TAvatarGroupCascading.rightUp);
    expect(groups.last.children, hasLength(6));
  });
}
