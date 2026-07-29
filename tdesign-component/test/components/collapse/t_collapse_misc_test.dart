import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/collapse/t_nonanimated_expand_icon.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 覆盖折叠图标的深浅色主题路径。
void main() {
  group('TNonAnimatedExpandIcon', () {
    testWidgets('深色主题下使用传入颜色', (tester) async {
      final token = TThemeData.defaultData().dark!;
      await tester.pumpWidget(MaterialApp(
        theme: TThemeBuilder.dark(TThemeData.defaultData()),
        home: Scaffold(
          body: TNonAnimatedExpandIcon(
            isExpanded: false,
            padding: EdgeInsets.zero,
            color: token.textColorPlaceholder,
          ),
        ),
      ));
      final icon = tester.widget<Icon>(find.byIcon(Icons.expand_more));
      expect(icon.color, token.textColorPlaceholder);
      expect(find.byType(IconButton), findsNothing);
    });

    testWidgets('浅色主题下使用传入颜色', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(MaterialApp(
        theme: TThemeBuilder.light(token),
        home: Scaffold(
          body: TNonAnimatedExpandIcon(
            isExpanded: true,
            padding: EdgeInsets.zero,
            color: token.textColorPlaceholder,
          ),
        ),
      ));
      final icon = tester.widget<Icon>(find.byIcon(Icons.expand_less));
      expect(icon.color, token.textColorPlaceholder);
    });
  });
}
