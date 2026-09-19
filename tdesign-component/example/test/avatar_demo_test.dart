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
    expect(groups.first.dimension, 48);
    expect(groups.first.maxCount, 5);
    expect(groups.first.children, hasLength(6));
    expect(groups.last.dimension, 48);
    expect(groups.last.cascading, TAvatarGroupCascading.endUp);
    expect(groups.last.children, hasLength(6));
  });

  testWidgets('带徽标头像由 TBadge 绑定锚点并使用设计视觉偏移', (tester) async {
    await pumpFullDemoPage(tester, avatarDemoPageTestSpec, ThemeMode.light);

    final badges = tester.widgetList<TBadge>(find.byType(TBadge)).toList();
    expect(badges, hasLength(3));
    expect(badges.first.variant, TBadgeVariant.dot);
    expect(badges.every((badge) => badge.child is TAvatar), isTrue);
    expect(badges.every((badge) => badge.alignment == null), isTrue);
    expect(badges.map((badge) => badge.offset), const [
      Offset(-1, 2),
      Offset(-5, 6),
      Offset(-5, 6),
    ]);

    final avatarFinders = List.generate(
      3,
      (index) => find.byType(TAvatar).at(index + 6),
    );
    final badgeFinders = List.generate(3, find.byType(Badge).at);
    expect(tester.getSize(badgeFinders[0]), const Size.square(10));
    expect(tester.getSize(badgeFinders[1]), const Size.square(16));
    expect(tester.getSize(badgeFinders[2]).height, 16);
    const expectedOffsets = [Offset(-1, 2), Offset(-5, 6), Offset(-5, 6)];
    for (var index = 0; index < badgeFinders.length; index++) {
      final badgeRect = tester.getRect(badgeFinders[index]);
      final avatarRect = tester.getRect(avatarFinders[index]);
      expect(badgeRect.center, avatarRect.topRight + expectedOffsets[index]);
    }
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
