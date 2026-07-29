import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_badge_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

void main() {
  Widget buildPage() {
    return ChangeNotifierProvider(
      create: (_) => ThemeModeProvider(),
      child: MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: const TBadgePage(),
      ),
    );
  }

  testWidgets('包裹型示例统一通过 TBadge.child 管理位置', (tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pump();

    final badges = tester.widgetList<TBadge>(find.byType(TBadge)).toList();
    expect(badges, isNotEmpty);
    expect(badges.every((badge) => badge.child != null), isTrue);

    final customChildBadges = badges.where((badge) {
      final child = badge.child;
      return child is Container &&
          child.constraints?.maxWidth == 40 &&
          child.constraints?.maxHeight == 40;
    }).toList();
    expect(customChildBadges, hasLength(3));
  });

  testWidgets('零值示例明确区分显示和隐藏', (tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pump();

    final zeroBadges = tester
        .widgetList<TBadge>(find.byType(TBadge))
        .where((badge) => badge.count == 0 && badge.child is Container)
        .toList();

    expect(zeroBadges, hasLength(2));
    expect(zeroBadges.where((badge) => badge.showZero), hasLength(1));
    expect(zeroBadges.where((badge) => !badge.showZero), hasLength(1));
  });
}
