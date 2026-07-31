import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_dropdown_menu_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

void main() {
  testWidgets('custom price panel updates, confirms and cancels draft',
      (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeModeProvider(),
        child: MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: const TDropdownMenuPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('¥100–500'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('¥100–500'));
    await tester.pumpAndSettle();

    final slider = tester.widget<RangeSlider>(find.byType(RangeSlider));
    slider.onChanged!(const RangeValues(200, 800));
    await tester.pump();
    tester.binding.handleMetricsChanged();
    await tester.pump();
    await tester.pump();
    expect(find.text('价格区间：¥200–800'), findsOneWidget);

    await tester.tap(find.text('应用价格'));
    await tester.pumpAndSettle();
    expect(find.text('¥200–800'), findsOneWidget);

    await tester.tap(find.text('¥200–800'));
    await tester.pumpAndSettle();
    tester
        .widget<RangeSlider>(find.byType(RangeSlider))
        .onChanged!(const RangeValues(300, 700));
    await tester.pump();
    expect(find.text('价格区间：¥300–700'), findsOneWidget);

    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    expect(find.text('¥200–800'), findsOneWidget);
    expect(find.text('¥300–700'), findsNothing);
  });
}
