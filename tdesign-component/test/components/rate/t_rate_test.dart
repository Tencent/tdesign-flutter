import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(
    Widget child, {
    TRateThemeData? rateTheme,
    TThemeData? token,
    ColorScheme? colorScheme,
  }) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: colorScheme,
        extensions: [
          token ?? TThemeData.defaultData(),
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

      await tester.pumpWidget(wrap(const TRate(value: 2.5)));
      expect(
        tester
            .widgetList<Align>(find.byType(Align))
            .where((widget) => widget.widthFactor == 0.5),
        isEmpty,
      );
      final semantics = tester.getSemantics(find.byType(TRate));
      expect(semantics.value, '2');
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
      expect(detector.onLongPressStart, isNull);
      expect(detector.onHorizontalDragUpdate, isNull);
      await tester.tap(find.byType(TRate));
      await tester.drag(find.byType(TRate), const Offset(40, 0));
      expect(changed, isFalse);

      await tester.pumpWidget(
        wrap(TRate(value: 2, onChanged: (_) => changed = true)),
      );
      detector = tester.widget<GestureDetector>(find.byType(GestureDetector));
      expect(detector.onTapDown, isNotNull);
      expect(detector.onLongPressStart, isNotNull);
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
      await tester.pump();

      expect(starts, [1]);
      expect(changes, [3]);
      expect(ends, [3]);
      expect(
        find.byKey(const ValueKey('t-rate-value-indicator')),
        findsOneWidget,
      );
      expect(find.text('3'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 299));
      expect(
        find.byKey(const ValueKey('t-rate-value-indicator')),
        findsOneWidget,
      );
      await tester.pump(const Duration(milliseconds: 1));
      expect(
        find.byKey(const ValueKey('t-rate-value-indicator')),
        findsNothing,
      );
    });

    testWidgets('showValueIndicator false hides ordinary rating feedback', (
      tester,
    ) async {
      final changes = <double>[];
      await tester.pumpWidget(
        wrap(
          TRate(value: 1, showValueIndicator: false, onChanged: changes.add),
        ),
      );

      final rect = tester.getRect(find.byType(GestureDetector));
      await tester.tapAt(Offset(rect.left + 70, rect.center.dy));

      expect(changes, [3]);
      expect(
        find.byKey(const ValueKey('t-rate-value-indicator')),
        findsNothing,
      );

      await tester.drag(find.byType(TRate), const Offset(40, 0));
      await tester.pump();
      expect(
        find.byKey(const ValueKey('t-rate-value-indicator')),
        findsNothing,
      );
    });

    testWidgets('value indicator stays anchored to the selected item', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const TRate(value: 0, onChanged: _noop),
          rateTheme: const TRateThemeData(iconSize: 40, iconGap: 8),
        ),
      );

      final rateRect = tester.getRect(find.byType(GestureDetector));
      final indicator = find.byKey(const ValueKey('t-rate-value-indicator'));

      await tester.tapAt(Offset(rateRect.left + 4, rateRect.center.dy));
      await tester.pump();
      final firstLeft = tester
          .widget<Positioned>(
            find.ancestor(of: indicator, matching: find.byType(Positioned)),
          )
          .left;

      await tester.tapAt(Offset(rateRect.left + 34, rateRect.center.dy));
      await tester.pump();
      final sameItemLeft = tester
          .widget<Positioned>(
            find.ancestor(of: indicator, matching: find.byType(Positioned)),
          )
          .left;

      await tester.tapAt(Offset(rateRect.left + 52, rateRect.center.dy));
      await tester.pump();
      final nextItemLeft = tester
          .widget<Positioned>(
            find.ancestor(of: indicator, matching: find.byType(Positioned)),
          )
          .left;

      expect(sameItemLeft, firstLeft);
      expect(nextItemLeft! - firstLeft!, 48);
    });

    testWidgets('long press shows the anchored value indicator until release', (
      tester,
    ) async {
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
          rateTheme: const TRateThemeData(iconSize: 40, iconGap: 8),
        ),
      );

      final rateRect = tester.getRect(find.byType(GestureDetector));
      final indicator = find.byKey(const ValueKey('t-rate-value-indicator'));
      final gesture = await tester.startGesture(
        Offset(rateRect.left + 52, rateRect.center.dy),
      );
      await tester.pump(kLongPressTimeout + const Duration(milliseconds: 1));

      expect(starts, [1]);
      expect(changes, [2]);
      expect(indicator, findsOneWidget);
      final initialLeft = tester
          .widget<Positioned>(
            find.ancestor(of: indicator, matching: find.byType(Positioned)),
          )
          .left;

      await gesture.moveBy(const Offset(20, 0));
      await tester.pump();
      final movedLeft = tester
          .widget<Positioned>(
            find.ancestor(of: indicator, matching: find.byType(Positioned)),
          )
          .left;

      expect(movedLeft, initialLeft);
      await gesture.up();
      await tester.pump();

      expect(ends, [2]);
      expect(indicator, findsNothing);
    });

    testWidgets(
      'half selection always exposes choices when value indicator is hidden',
      (tester) async {
        final changes = <double>[];
        final ends = <double>[];
        await tester.pumpWidget(
          wrap(
            TRate(
              value: 0,
              allowHalf: true,
              showValueIndicator: false,
              onChanged: changes.add,
              onChangeEnd: ends.add,
            ),
          ),
        );

        final rect = tester.getRect(find.byType(GestureDetector));
        await tester.tapAt(Offset(rect.left + 3, rect.center.dy));
        await tester.pump();

        expect(
          find.byKey(const ValueKey('t-rate-half-choice')),
          findsOneWidget,
        );
        expect(find.text('0.5'), findsOneWidget);
        expect(find.text('1'), findsOneWidget);

        await tester.tap(find.text('1'));
        await tester.pump();

        expect(changes, [0.5, 1]);
        expect(ends, [1]);
        expect(find.byKey(const ValueKey('t-rate-half-choice')), findsNothing);
      },
    );

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
      expect(
        find.byKey(const ValueKey('t-rate-value-indicator')),
        findsOneWidget,
      );
      await gesture.up();
      await tester.pump();

      expect(starts, [2]);
      expect(changes, isNotEmpty);
      expect(changes.last, 5);
      expect(ends, [5]);
      expect(
        find.byKey(const ValueKey('t-rate-value-indicator')),
        findsNothing,
      );
    });

    testWidgets('dragging beyond the leading edge clears the rating', (
      tester,
    ) async {
      for (final allowHalf in [false, true]) {
        final changes = <double>[];
        final ends = <double>[];
        await tester.pumpWidget(
          wrap(
            TRate(
              value: 2,
              allowHalf: allowHalf,
              onChanged: changes.add,
              onChangeEnd: ends.add,
            ),
          ),
        );

        final rect = tester.getRect(find.byType(GestureDetector).first);
        final gesture = await tester.startGesture(rect.center);
        await gesture.moveBy(const Offset(-20, 0));
        await tester.pump();
        await gesture.moveTo(Offset(rect.left - 48, rect.center.dy));
        await tester.pump();
        await gesture.up();

        expect(changes.last, 0);
        expect(ends, [0]);
      }
    });

    testWidgets('slow horizontal drag starts and ends one lifecycle', (
      tester,
    ) async {
      final starts = <double>[];
      final ends = <double>[];
      await tester.pumpWidget(
        wrap(
          TRate(
            value: 2,
            onChanged: _noop,
            onChangeStart: starts.add,
            onChangeEnd: ends.add,
          ),
        ),
      );

      final rect = tester.getRect(find.byType(TRate));
      final gesture = await tester.startGesture(rect.center);
      await tester.pump(kPressTimeout + const Duration(milliseconds: 1));
      await gesture.moveBy(const Offset(20, 0));
      await tester.pump();
      await gesture.up();

      expect(starts, [2]);
      expect(ends, hasLength(1));
    });

    testWidgets('pointer cancellation completes one interaction lifecycle', (
      tester,
    ) async {
      final starts = <double>[];
      final ends = <double>[];
      await tester.pumpWidget(
        wrap(
          TRate(
            value: 2,
            onChanged: _noop,
            onChangeStart: starts.add,
            onChangeEnd: ends.add,
          ),
        ),
      );

      final rect = tester.getRect(find.byType(TRate));
      final gesture = await tester.startGesture(rect.center);
      await gesture.moveBy(const Offset(20, 0));
      await tester.pump();
      await gesture.cancel();
      await tester.pump();

      expect(starts, [2]);
      expect(ends, [2]);
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
      final rateIcons = find.descendant(
        of: find.byType(TRate),
        matching: find.byIcon(TIcons.star_filled),
      );
      expect(rateIcons, findsNWidgets(6));

      final rect = tester.getRect(find.byType(GestureDetector));
      await tester.tapAt(Offset(rect.left + 100, rect.center.dy));
      await tester.pump();
      expect(rateIcons, findsNWidgets(6));

      update(() {});
      await tester.pump(const Duration(milliseconds: 300));
      expect(value, 4);
      expect(rateIcons, findsNWidgets(9));
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
          rateTheme: const TRateThemeData(textWidth: 64),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('一般'), findsOneWidget);
    });

    testWidgets('long text shrinks in a bounded parent without textWidth', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const SizedBox(
            width: 200,
            child: TRate(
              value: 3,
              texts: [
                'very long description',
                'very long description',
                'very long description',
              ],
              onChanged: _noop,
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('very long description'), findsOneWidget);
    });

    testWidgets('text keeps intrinsic width in an unbounded row', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TRate(value: 3, texts: ['bad', 'ok', 'good'], onChanged: _noop),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('good'), findsOneWidget);
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

    testWidgets(
      'default colors follow explicit Material text and TDesign rate tokens',
      (tester) async {
        final token =
            TThemeData.defaultData().copyWith(
                  colorMap: {
                    'warningColor5': Colors.red,
                    'bgColorComponent': Colors.blue,
                    'textColorPrimary': Colors.green,
                  },
                  marginMap: {'spacer24': 30},
                )
                as TThemeData;
        final colorScheme = ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ).copyWith(onSurface: Colors.purple);
        await tester.pumpWidget(
          wrap(
            const TRate(
              value: 2,
              texts: ['bad', 'ok', 'good', 'great', 'best'],
              onChanged: _noop,
            ),
            token: token,
            colorScheme: colorScheme,
          ),
        );

        expect(
          tester.widget<Text>(find.text('ok')).style?.color,
          Colors.purple,
        );
        final icons = tester.widgetList<Icon>(find.byIcon(TIcons.star_filled));
        expect(icons.any((icon) => icon.color == Colors.red), isTrue);
        expect(icons.any((icon) => icon.color == Colors.blue), isTrue);
        expect(icons.any((icon) => icon.color == colorScheme.primary), isFalse);
        expect(icons.every((icon) => icon.size == 30), isTrue);
      },
    );

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
      const theme = TRateThemeData();

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
          const TRate(value: 2.5, allowHalf: true, texts: whole),
          rateTheme: theme,
        ),
      );
      expect(find.text('two'), findsOneWidget);

      await tester.pumpWidget(
        wrap(const TRate(value: 0, texts: whole), rateTheme: theme),
      );
      expect(find.text('未评分'), findsOneWidget);

      await tester.pumpWidget(
        wrap(
          const TRate(value: 0.5, allowHalf: true, texts: whole),
          rateTheme: theme,
        ),
      );
      expect(find.text('未评分'), findsOneWidget);

      await tester.pumpWidget(
        wrap(const TRate(value: 5, texts: ['short']), rateTheme: theme),
      );
      expect(find.text('未评分'), findsOneWidget);

      await tester.pumpWidget(wrap(const TRate(value: 2)));
      expect(find.text('2'), findsNothing);
    });

    testWidgets('custom icon is reused by the half choice overlay', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          TRate(
            value: 1,
            allowHalf: true,
            onChanged: _noop,
            icon: (filled) =>
                Icon(filled ? Icons.favorite : Icons.favorite_border),
          ),
        ),
      );

      final selectedBefore = find.byIcon(Icons.favorite).evaluate().length;
      final unselectedBefore = find
          .byIcon(Icons.favorite_border)
          .evaluate()
          .length;
      await tester.tap(find.byType(TRate));
      await tester.pump();

      expect(find.byKey(const ValueKey('t-rate-half-choice')), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNWidgets(selectedBefore + 2));
      expect(
        find.byIcon(Icons.favorite_border),
        findsNWidgets(unselectedBefore + 2),
      );
    });

    testWidgets('custom icon inherits component size and color', (
      tester,
    ) async {
      final themes = <IconThemeData>[];
      await tester.pumpWidget(
        wrap(
          TRate(
            value: 1,
            onChanged: _noop,
            icon: (_) => Builder(
              builder: (context) {
                themes.add(IconTheme.of(context));
                return const Icon(Icons.favorite);
              },
            ),
          ),
          rateTheme: const TRateThemeData(
            iconSize: 30,
            starColor: Colors.red,
            inactiveStarColor: Colors.blue,
          ),
        ),
      );

      expect(themes, isNotEmpty);
      expect(themes.every((theme) => theme.size == 30), isTrue);
      expect(themes.any((theme) => theme.color == Colors.red), isTrue);
      expect(themes.any((theme) => theme.color == Colors.blue), isTrue);
    });

    testWidgets('half choice stays in bounds on a narrow viewport', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const MediaQuery(
            data: MediaQueryData(size: Size(60, 120)),
            child: TRate(value: 1, allowHalf: true, onChanged: _noop),
          ),
        ),
      );

      await tester.tap(find.byType(TRate));
      await tester.pump();
      expect(find.byKey(const ValueKey('t-rate-half-choice')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('semantics exposes bounded increase and decrease actions', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    final starts = <double>[];
    final changes = <double>[];
    final ends = <double>[];
    await tester.pumpWidget(
      wrap(
        TRate(
          value: 2,
          allowHalf: true,
          onChangeStart: starts.add,
          onChanged: changes.add,
          onChangeEnd: ends.add,
        ),
      ),
    );

    final node = tester.getSemantics(find.byType(TRate));
    final data = node.getSemanticsData();
    expect(data.label, isEmpty);
    // Flutter 3.32 尚无 flagsCollection，双版本兼容期保留 hasFlag。
    // ignore: deprecated_member_use
    expect(data.hasFlag(SemanticsFlag.isSlider), isTrue);
    expect(data.hasAction(SemanticsAction.increase), isTrue);
    expect(data.hasAction(SemanticsAction.decrease), isTrue);
    expect(data.value, '2');
    expect(data.increasedValue, '2.5');
    expect(data.decreasedValue, '1.5');
    node.owner!.performAction(node.id, SemanticsAction.increase);
    await tester.pump();
    node.owner!.performAction(node.id, SemanticsAction.decrease);

    expect(starts, [2, 2]);
    expect(changes, [2.5, 1.5]);
    expect(ends, [2.5, 1.5]);
    semantics.dispose();
  });

  testWidgets('half-step semantics keeps numeric values with descriptions', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      wrap(
        const TRate(
          value: 2,
          allowHalf: true,
          texts: ['one', 'two', 'three', 'four', 'five'],
          onChanged: _noop,
        ),
      ),
    );

    final data = tester.getSemantics(find.byType(TRate)).getSemanticsData();
    expect(data.value, '2 two');
    expect(data.increasedValue, '2.5 two');
    expect(data.decreasedValue, '1.5 one');
    semantics.dispose();
  });

  testWidgets(
    'RTL starts rating from the right and fills half from the right',
    (tester) async {
      final changes = <double>[];
      await tester.pumpWidget(
        wrap(
          Directionality(
            textDirection: TextDirection.rtl,
            child: TRate(value: 0.5, allowHalf: true, onChanged: changes.add),
          ),
        ),
      );

      final half = tester
          .widgetList<Align>(find.byType(Align))
          .firstWhere((widget) => widget.widthFactor == 0.5);
      expect(half.alignment, Alignment.centerRight);

      final rect = tester.getRect(find.byType(GestureDetector).first);
      await tester.tapAt(Offset(rect.right - 2, rect.center.dy));
      expect(changes, [0.5]);
    },
  );

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
            textWidth: 50,
            textGap: 10,
            textStyle: const TextStyle(fontSize: 14),
            overlayBoxShadow: const [BoxShadow(color: Colors.green)],
          )
          .textWidth,
      50,
    );
    expect(base.lerp(null, 0.5), same(base));
    expect(base.lerp(other, 0.5).iconSize, 25);
    expect(base.lerp(other, 0.25).overlayBoxShadow, base.overlayBoxShadow);
  });
}

void _noop(double value) {}
