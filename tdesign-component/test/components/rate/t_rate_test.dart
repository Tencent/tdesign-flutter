import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child, {TRateThemeData? rateTheme}) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [
          TThemeData.defaultData(),
          if (rateTheme != null) rateTheme,
        ],
      ),
      home: Scaffold(body: Center(child: child)),
    );
  }

  group('TRate controlled behavior', () {
    testWidgets('renders zero, whole and half values', (tester) async {
      await tester.pumpWidget(wrap(const TRate(value: 0)));
      expect(find.byIcon(TIcons.star_filled), findsNWidgets(5));

      await tester.pumpWidget(wrap(const TRate(value: 3)));
      expect(find.byIcon(TIcons.star_filled), findsNWidgets(8));

      await tester.pumpWidget(wrap(const TRate(value: 2.5, allowHalf: true)));
      final align = tester
          .widgetList<Align>(find.byType(Align))
          .firstWhere((widget) => widget.widthFactor == 0.5);
      expect(align.widthFactor, 0.5);
    });

    testWidgets('count controls the number of items', (tester) async {
      await tester.pumpWidget(wrap(const TRate(value: 0, count: 3)));
      expect(find.byIcon(TIcons.star_filled), findsNWidgets(3));
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('onChanged null is the only disabled state', (tester) async {
      var changed = false;
      await tester.pumpWidget(wrap(const TRate(value: 2)));

      var detector = tester.widget<GestureDetector>(
        find.byType(GestureDetector),
      );
      expect(detector.onTapDown, isNull);
      expect(detector.onHorizontalDragUpdate, isNull);
      await tester.tap(find.byType(TRate));
      await tester.drag(find.byType(TRate), const Offset(40, 0));
      expect(changed, isFalse);

      await tester.pumpWidget(
        wrap(TRate(value: 2, onChanged: (_) => changed = true)),
      );
      detector = tester.widget<GestureDetector>(find.byType(GestureDetector));
      expect(detector.onTapDown, isNotNull);
      expect(detector.onHorizontalDragUpdate, isNotNull);
    });

    testWidgets('tap reports start, changed and end values', (tester) async {
      final starts = <double>[];
      final changes = <double>[];
      final ends = <double>[];
      await tester.pumpWidget(
        wrap(
          TRate(
            value: 1,
            onChangeStart: starts.add,
            onChanged: changes.add,
            onChangeEnd: ends.add,
          ),
        ),
      );

      final rect = tester.getRect(find.byType(GestureDetector));
      await tester.tapAt(Offset(rect.left + 70, rect.center.dy));

      expect(starts, [1]);
      expect(changes, [3]);
      expect(ends, [3]);
    });

    testWidgets('half selection exposes half and whole choices after tap', (
      tester,
    ) async {
      final changes = <double>[];
      final ends = <double>[];
      await tester.pumpWidget(
        wrap(
          TRate(
            value: 0,
            allowHalf: true,
            onChanged: changes.add,
            onChangeEnd: ends.add,
          ),
        ),
      );

      final rect = tester.getRect(find.byType(GestureDetector));
      await tester.tapAt(Offset(rect.left + 3, rect.center.dy));
      await tester.pump();

      expect(find.byKey(const ValueKey('t-rate-half-choice')), findsOneWidget);
      expect(find.text('0.5'), findsOneWidget);
      expect(find.text('1.0'), findsOneWidget);

      await tester.tap(find.text('1.0'));
      await tester.pump();

      expect(changes, [0.5, 1]);
      expect(ends, [1]);
      expect(find.byKey(const ValueKey('t-rate-half-choice')), findsNothing);
    });

    testWidgets('half choice remains visible after a controlled value update', (
      tester,
    ) async {
      var value = 0.0;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) => TRate(
              value: value,
              allowHalf: true,
              onChanged: (next) => setState(() => value = next),
            ),
          ),
        ),
      );

      final rect = tester.getRect(find.byType(GestureDetector));
      await tester.tapAt(Offset(rect.left + 3, rect.center.dy));
      await tester.pump();

      expect(value, 0.5);
      expect(find.byKey(const ValueKey('t-rate-half-choice')), findsOneWidget);
    });

    testWidgets('half choice keeps trigger subtree theme in root overlay', (
      tester,
    ) async {
      final base = TThemeBuilder.light(TThemeData.defaultData());
      final localToken = TThemeData.defaultData().copyWith(
        colorMap: {'bgColorContainer': Colors.yellow},
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: base,
          home: Scaffold(
            body: Theme(
              data: base
                  .mergeExtension(localToken)
                  .mergeExtension(
                    const TRateThemeData(
                      overlayBoxShadow: [
                        BoxShadow(color: Colors.purple, blurRadius: 3),
                      ],
                    ),
                  ),
              child: const TRate(value: 1, allowHalf: true, onChanged: _noop),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TRate));
      await tester.pump();
      final popup = tester.widget<Container>(
        find.byKey(const ValueKey('t-rate-half-choice')),
      );
      final decoration = popup.decoration! as BoxDecoration;
      expect(decoration.color, Colors.yellow);
      expect(decoration.boxShadow?.single.color, Colors.purple);
    });

    testWidgets('horizontal drag reports lifecycle and clamps the value', (
      tester,
    ) async {
      final starts = <double>[];
      final changes = <double>[];
      final ends = <double>[];
      await tester.pumpWidget(
        wrap(
          TRate(
            value: 2,
            onChangeStart: starts.add,
            onChanged: changes.add,
            onChangeEnd: ends.add,
          ),
        ),
      );

      final rect = tester.getRect(find.byType(GestureDetector));
      final gesture = await tester.startGesture(rect.center);
      await gesture.moveBy(const Offset(20, 0));
      await tester.pump();
      await gesture.moveTo(rect.centerRight + const Offset(100, 0));
      await tester.pump();
      await gesture.up();

      expect(starts, [2]);
      expect(changes, isNotEmpty);
      expect(changes.last, 5);
      expect(ends, [5]);
    });

    testWidgets('external value remains the rendering source of truth', (
      tester,
    ) async {
      var value = 1.0;
      late StateSetter update;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return TRate(value: value, onChanged: (next) => value = next);
            },
          ),
        ),
      );
      expect(find.byIcon(TIcons.star_filled), findsNWidgets(6));

      final rect = tester.getRect(find.byType(GestureDetector));
      await tester.tapAt(Offset(rect.left + 100, rect.center.dy));
      await tester.pump();
      expect(find.byIcon(TIcons.star_filled), findsNWidgets(6));

      update(() {});
      await tester.pump();
      expect(value, 4);
      expect(find.byIcon(TIcons.star_filled), findsNWidgets(9));
    });
  });

  group('TRate content and theme', () {
    testWidgets('text rating fits a narrow cell in vertical demo layout', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const SizedBox(
            width: 279,
            child: TCell(
              title: TText('评分文案'),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 8),
                child: TRate(
                  value: 3,
                  texts: ['很差', '较差', '一般', '满意', '惊喜'],
                  onChanged: _noop,
                ),
              ),
            ),
          ),
          rateTheme: const TRateThemeData(showText: true, textWidth: 64),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('一般'), findsOneWidget);
    });

    testWidgets('custom builder receives selected and unselected states', (
      tester,
    ) async {
      final states = <bool>[];
      await tester.pumpWidget(
        wrap(
          TRate(
            value: 1.5,
            allowHalf: true,
            icon: (filled) {
              states.add(filled);
              return Icon(filled ? Icons.favorite : Icons.favorite_border);
            },
          ),
        ),
      );

      expect(states.where((value) => value), hasLength(5));
      expect(states.where((value) => !value), hasLength(5));
      expect(find.byIcon(Icons.favorite), findsNWidgets(2));
      expect(find.byIcon(Icons.favorite_border), findsNWidgets(5));
    });

    testWidgets('theme controls colors, dimensions and text', (tester) async {
      const style = TextStyle(color: Colors.purple, fontSize: 18);
      await tester.pumpWidget(
        wrap(
          const TRate(
            value: 2,
            texts: ['bad', 'ok', 'good', 'great', 'best'],
            onChanged: _noop,
          ),
          rateTheme: const TRateThemeData(
            starColor: Colors.red,
            inactiveStarColor: Colors.blue,
            iconSize: 30,
            iconGap: 4,
            showText: true,
            textWidth: 80,
            textGap: 12,
            textStyle: style,
          ),
        ),
      );

      expect(find.text('ok'), findsOneWidget);
      expect(tester.widget<Text>(find.text('ok')).style, style);
      final icons = tester.widgetList<Icon>(find.byIcon(TIcons.star_filled));
      expect(icons.any((icon) => icon.color == Colors.red), isTrue);
      expect(icons.any((icon) => icon.color == Colors.blue), isTrue);
      expect(icons.every((icon) => icon.size == 30), isTrue);
      expect(
        find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.width == 80,
        ),
        findsOneWidget,
      );
    });

    testWidgets('disabled colors come from global tokens', (tester) async {
      await tester.pumpWidget(
        wrap(
          const TRate(value: 1),
          rateTheme: const TRateThemeData(
            starColor: Colors.red,
            inactiveStarColor: Colors.blue,
          ),
        ),
      );
      final icons = tester.widgetList<Icon>(find.byIcon(TIcons.star_filled));
      expect(icons.any((icon) => icon.color == Colors.red), isFalse);
      expect(icons.any((icon) => icon.color == Colors.blue), isFalse);
    });

    testWidgets('text supports whole, half and fallback indexes', (
      tester,
    ) async {
      const whole = ['one', 'two', 'three', 'four', 'five'];
      const half = ['0.5', '1', '1.5', '2', '2.5', '3', '3.5', '4', '4.5', '5'];
      const theme = TRateThemeData(showText: true);

      await tester.pumpWidget(
        wrap(
          const TRate(value: 2, texts: whole, onChanged: _noop),
          rateTheme: theme,
        ),
      );
      expect(find.text('two'), findsOneWidget);
      expect(tester.widget<Text>(find.text('two')).style?.color, isNotNull);

      await tester.pumpWidget(
        wrap(
          const TRate(value: 2.5, allowHalf: true, texts: half),
          rateTheme: theme,
        ),
      );
      expect(find.text('2.5'), findsOneWidget);

      await tester.pumpWidget(
        wrap(const TRate(value: 0, texts: whole), rateTheme: theme),
      );
      expect(find.text('0.0'), findsOneWidget);

      await tester.pumpWidget(
        wrap(const TRate(value: 5, texts: ['short']), rateTheme: theme),
      );
      expect(find.text('5.0'), findsOneWidget);
    });
  });

  test('constructor rejects invalid values', () {
    expect(() => TRate(value: -1), throwsAssertionError);
    expect(() => TRate(value: 6), throwsAssertionError);
    expect(() => TRate(value: 0, count: 0), throwsAssertionError);
  });

  test('TRateThemeData copyWith and lerp', () {
    const base = TRateThemeData(
      starColor: Colors.red,
      inactiveStarColor: Colors.grey,
      iconSize: 20,
      iconGap: 4,
      showText: false,
      textWidth: 40,
      textGap: 8,
      textStyle: TextStyle(fontSize: 12),
      overlayBoxShadow: [BoxShadow(color: Colors.red)],
    );
    const other = TRateThemeData(
      starColor: Colors.blue,
      inactiveStarColor: Colors.black,
      iconSize: 30,
      iconGap: 8,
      showText: true,
      textWidth: 60,
      textGap: 12,
      textStyle: TextStyle(fontSize: 16),
      overlayBoxShadow: [BoxShadow(color: Colors.blue)],
    );

    expect(base.copyWith().iconSize, 20);
    expect(
      base
          .copyWith(
            starColor: Colors.green,
            inactiveStarColor: Colors.white,
            iconSize: 24,
            iconGap: 6,
            showText: true,
            textWidth: 50,
            textGap: 10,
            textStyle: const TextStyle(fontSize: 14),
            overlayBoxShadow: const [BoxShadow(color: Colors.green)],
          )
          .showText,
      isTrue,
    );
    expect(base.lerp(null, 0.5), same(base));
    expect(base.lerp(other, 0.25).showText, isFalse);
    expect(base.lerp(other, 0.75).showText, isTrue);
    expect(base.lerp(other, 0.5).iconSize, 25);
    expect(base.lerp(other, 0.25).overlayBoxShadow, base.overlayBoxShadow);
  });
}

void _noop(double value) {}
