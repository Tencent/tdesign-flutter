import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  ThemeData fullTheme() => TThemeBuilder.light(TThemeData.defaultData());

  Widget app(Widget child, {ThemeData? theme}) => MaterialApp(
        theme: theme ?? fullTheme(),
        home: Scaffold(body: Center(child: child)),
      );

  testWidgets('renders bounded count and child', (tester) async {
    await tester.pumpWidget(app(
      const TBadge(count: 120, maxCount: 99, child: Text('Inbox')),
    ));

    expect(find.text('99+'), findsOneWidget);
    expect(find.text('Inbox'), findsOneWidget);
  });

  testWidgets('showZero controls zero visibility', (tester) async {
    await tester.pumpWidget(app(const TBadge(showZero: false)));
    expect(tester.widget<Badge>(find.byType(Badge)).isLabelVisible, isFalse);

    await tester.pumpWidget(app(const TBadge()));
    expect(tester.widget<Badge>(find.byType(Badge)).isLabelVisible, isTrue);
  });

  testWidgets('dot has no label and is always visible', (tester) async {
    await tester.pumpWidget(app(
      const TBadge(variant: TBadgeVariant.dot, showZero: false),
    ));

    final badge = tester.widget<Badge>(find.byType(Badge));
    expect(badge.label, isNull);
    expect(badge.isLabelVisible, isTrue);
  });

  testWidgets('small variant resolves a compact size', (tester) async {
    await tester.pumpWidget(app(
      const TBadge(count: 8, variant: TBadgeVariant.small),
    ));

    expect(tester.widget<Badge>(find.byType(Badge)).largeSize, 12);
  });

  testWidgets('default visual style is driven by TDesign tokens',
      (tester) async {
    final token = TThemeData.defaultData();
    await tester.pumpWidget(app(
      const TBadge(count: 8, child: Text('Inbox')),
    ));

    final badge = tester.widget<Badge>(find.byType(Badge));
    expect(badge.backgroundColor, token.errorNormalColor);
    expect(badge.textColor, token.textColorAnti);
    expect(badge.largeSize, 16);
    expect(badge.smallSize, 6);
    expect(badge.padding, const EdgeInsets.symmetric(horizontal: 4));
    expect(badge.textStyle?.fontSize, token.fontMarkExtraSmall?.size);
    expect(badge.textStyle?.height, token.fontMarkExtraSmall?.height);
    expect(badge.textStyle?.color, token.textColorAnti);
  });

  testWidgets('onTap is the only interaction switch', (tester) async {
    var taps = 0;
    await tester.pumpWidget(app(TBadge(count: 1, onTap: () => taps++)));

    await tester.tap(find.byType(TBadge));
    expect(taps, 1);
    expect(find.byType(GestureDetector), findsWidgets);

    await tester.pumpWidget(app(const TBadge(count: 1)));
    expect(
        find.descendant(
          of: find.byType(TBadge),
          matching: find.byType(GestureDetector),
        ),
        findsNothing);
  });

  testWidgets('border uses TDesign visual extension', (tester) async {
    const extension = TBadgeThemeData(
      borderColor: Colors.green,
      borderWidth: 2,
    );
    await tester.pumpWidget(app(
      const TBadge(count: 2, border: true),
      theme: fullTheme().mergeExtension(extension),
    ));

    final box = tester.widget<DecoratedBox>(find.byType(DecoratedBox).last);
    final decoration = box.decoration as BoxDecoration;
    expect(decoration.color, TThemeData.defaultData().errorNormalColor);
    expect(decoration.border, Border.all(color: Colors.green, width: 2));
  });

  test('theme data copyWith and lerp preserve visual fields', () {
    const data = TBadgeThemeData(
      borderColor: Colors.red,
      borderWidth: 1,
    );
    expect(data.copyWith(borderWidth: 2).borderWidth, 2);
    expect(data.copyWith().borderColor, Colors.red);
    expect(
        data.lerp(const TBadgeThemeData(borderWidth: 3), 0.5).borderWidth, 2);
  });

  test('invalid values are rejected', () {
    expect(() => TBadge(count: -1), throwsAssertionError);
    expect(() => TBadge(maxCount: 0), throwsAssertionError);
  });
}
