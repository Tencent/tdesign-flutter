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

  testWidgets('带徽标头像使用设计尺寸与越界偏移', (tester) async {
    await pumpFullDemoPage(tester, avatarDemoPageTestSpec, ThemeMode.light);

    final badges = tester.widgetList<TBadge>(find.byType(TBadge)).toList();
    expect(badges, hasLength(3));
    expect(badges.first.variant, TBadgeVariant.dot);

    final badgePositions = tester
        .widgetList<Positioned>(find.byType(Positioned))
        .where((positioned) {
          final child = positioned.child;
          return child is TBadge ||
              (child is BadgeTheme && child.child is TBadge);
        })
        .toList();
    expect(badgePositions, hasLength(3));
    expect(
      badgePositions,
      everyElement(
        isA<Positioned>()
            .having((positioned) => positioned.right, 'right', -4)
            .having((positioned) => positioned.top, 'top', -4),
      ),
    );

    final dotTheme = badgePositions.first.child as BadgeTheme;
    expect(dotTheme.data.smallSize, 10);

    final avatarFinders = List.generate(
      3,
      (index) => find.byType(TAvatar).at(index + 6),
    );
    final badgeFinders = List.generate(3, find.byType(TBadge).at);
    expect(tester.getSize(badgeFinders[0]), const Size.square(10));
    expect(tester.getSize(badgeFinders[1]), const Size.square(16));
    expect(tester.getSize(badgeFinders[2]).height, 16);
    expect(
      tester.getTopLeft(badgeFinders[0]) - tester.getTopLeft(avatarFinders[0]),
      const Offset(42, -4),
    );
    expect(
      tester.getTopLeft(badgeFinders[1]) - tester.getTopLeft(avatarFinders[1]),
      const Offset(36, -4),
    );
    for (var index = 0; index < badgeFinders.length; index++) {
      final badgeRect = tester.getRect(badgeFinders[index]);
      final avatarRect = tester.getRect(avatarFinders[index]);
      expect(badgeRect.right - avatarRect.right, 4);
      expect(badgeRect.top - avatarRect.top, -4);
    }

    final badgeStacks = tester
        .widgetList<Stack>(find.byType(Stack))
        .where(
          (stack) => stack.children.any(
            (child) => child is Positioned && badgePositions.contains(child),
          ),
        );
    expect(
      badgeStacks,
      everyElement(
        isA<Stack>().having(
          (stack) => stack.clipBehavior,
          'clipBehavior',
          Clip.none,
        ),
      ),
    );
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
