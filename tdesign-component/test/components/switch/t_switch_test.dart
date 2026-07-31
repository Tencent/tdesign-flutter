import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/loading/t_circle_indicator.dart';
import 'package:tdesign_flutter/src/components/switch/t_cupertino_switch.dart';
import 'package:tdesign_flutter/src/components/switch/t_switch_resolve.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(
    Widget child, {
    TSwitchThemeData? switchTheme,
    TextDirection direction = TextDirection.ltr,
  }) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [
          TThemeData.defaultData(),
          if (switchTheme != null) switchTheme,
        ],
      ),
      home: Directionality(
        textDirection: direction,
        child: Scaffold(body: Center(child: child)),
      ),
    );
  }

  group('TSwitch v1 controlled behavior', () {
    testWidgets('renders controlled values and reports the next value', (
      tester,
    ) async {
      bool? changed;
      await tester.pumpWidget(
        wrap(TSwitch(value: false, onChanged: (value) => changed = value)),
      );

      expect(find.byType(TCupertinoSwitch), findsOneWidget);
      await tester.tap(find.byType(TCupertinoSwitch));
      await tester.pump();
      expect(changed, isTrue);

      await tester.pumpWidget(
        wrap(TSwitch(value: true, onChanged: (value) => changed = value)),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(TCupertinoSwitch));
      expect(changed, isFalse);
    });

    testWidgets('onChanged null is the only disabled state', (tester) async {
      await tester.pumpWidget(wrap(const TSwitch(value: false)));

      final switchWidget = tester.widget<TCupertinoSwitch>(
        find.byType(TCupertinoSwitch),
      );
      expect(switchWidget.onChanged, isNull);
      expect(switchWidget.disabledOpacity, 1);
      expect(
        find.byWidgetPredicate(
          (widget) => widget is IgnorePointer && widget.ignoring,
        ),
        findsOneWidget,
      );
    });

    testWidgets('loading variant is disabled even with callback', (
      tester,
    ) async {
      var called = false;
      await tester.pumpWidget(
        wrap(
          TSwitch(
            value: true,
            variant: TSwitchVariant.loading,
            onChanged: (_) => called = true,
          ),
        ),
      );

      await tester.tap(find.byType(TCupertinoSwitch), warnIfMissed: false);
      expect(called, isFalse);
      expect(find.byType(TCircleIndicator), findsOneWidget);
    });
  });

  group('TSwitch variants and sizes', () {
    testWidgets('text variant uses default and custom labels', (tester) async {
      await tester.pumpWidget(
        wrap(
          const TSwitch(
            value: true,
            variant: TSwitchVariant.text,
            onChanged: _noop,
          ),
        ),
      );
      expect(find.text('开'), findsOneWidget);

      await tester.pumpWidget(
        wrap(
          const TSwitch(
            value: false,
            variant: TSwitchVariant.text,
            openText: 'YES',
            closeText: 'NO',
            onChanged: _noop,
          ),
        ),
      );
      expect(find.text('NO'), findsOneWidget);
    });

    testWidgets('text stays centered in the active and inactive thumb', (
      tester,
    ) async {
      for (final value in [false, true]) {
        await tester.pumpWidget(
          wrap(
            TCell(
              title: const Text('文字开关'),
              note: TSwitch(
                value: value,
                variant: TSwitchVariant.text,
                onChanged: _noop,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final switchRect = tester.getRect(find.byType(TSwitch));
        final text = tester.widget<Text>(find.text(value ? '开' : '关'));
        final textRect = tester.getRect(find.text(value ? '开' : '关'));
        final expectedCenterX = switchRect.left + (value ? 31.0 : 14.0);

        expect(text.style?.height, 1);
        expect(textRect.height, lessThanOrEqualTo(16));
        expect(textRect.center.dx, closeTo(expectedCenterX, 0.5));
        expect(textRect.center.dy, closeTo(switchRect.center.dy, 0.5));
      }
    });

    testWidgets('text variant keeps long labels inside the thumb', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const TSwitch(
            value: true,
            variant: TSwitchVariant.text,
            openText: 'LONG',
            onChanged: _noop,
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      final text = tester.widget<Text>(find.text('LONG'));
      expect(text.maxLines, 1);
      expect(text.overflow, TextOverflow.ellipsis);
    });

    testWidgets('icon and filled variants render their expected thumb', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const TSwitch(
            value: true,
            variant: TSwitchVariant.icon,
            onChanged: _noop,
          ),
        ),
      );
      expect(find.byIcon(TIcons.check), findsOneWidget);

      await tester.pumpWidget(
        wrap(
          const TSwitch(
            value: false,
            variant: TSwitchVariant.icon,
            onChanged: _noop,
          ),
        ),
      );
      expect(find.byIcon(TIcons.close), findsOneWidget);

      await tester.pumpWidget(
        wrap(
          const TSwitch(
            value: false,
            variant: TSwitchVariant.filled,
            onChanged: _noop,
          ),
        ),
      );
      expect(find.byIcon(TIcons.close), findsNothing);
    });

    testWidgets('all sizes use stable dimensions', (tester) async {
      for (final entry in const [
        (TSwitchSize.large, 52.0, 32.0),
        (TSwitchSize.medium, 45.0, 28.0),
        (TSwitchSize.small, 39.0, 24.0),
      ]) {
        await tester.pumpWidget(
          wrap(TSwitch(value: false, size: entry.$1, onChanged: _noop)),
        );
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is SizedBox &&
                widget.width == entry.$2 &&
                widget.height == entry.$3,
          ),
          findsOneWidget,
        );
      }
    });
  });

  group('TSwitch theme and resolver', () {
    testWidgets(
      'theme supplies defaults and instance semantics override them',
      (tester) async {
        const theme = TSwitchThemeData(
          defaultSize: TSwitchSize.small,
          defaultVariant: TSwitchVariant.text,
          trackOnColor: Colors.red,
          trackOffColor: Colors.green,
          thumbContentOnColor: Colors.blue,
          thumbContentOffColor: Colors.orange,
          thumbContentOnFont: TextStyle(fontSize: 16),
          thumbContentOffFont: TextStyle(fontSize: 12),
        );
        await tester.pumpWidget(
          wrap(
            const TSwitch(value: true, onChanged: _noop),
            switchTheme: theme,
          ),
        );
        expect(find.text('开'), findsOneWidget);

        await tester.pumpWidget(
          wrap(
            const TSwitch(
              value: true,
              size: TSwitchSize.large,
              variant: TSwitchVariant.icon,
              onChanged: _noop,
            ),
            switchTheme: theme,
          ),
        );
        expect(find.byIcon(TIcons.check), findsOneWidget);
      },
    );

    testWidgets('resolver falls back to token and uses theme overrides', (
      tester,
    ) async {
      late BuildContext context;
      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (value) {
              context = value;
              return const SizedBox();
            },
          ),
        ),
      );

      final defaults = TSwitchResolve.resolve(context: context, enabled: true);
      final token = TThemeData.defaultData();
      expect(defaults.trackOnColor, context.tTheme.brandNormalColor);
      expect(defaults.thumbContentOnFont.fontSize, token.fontBodyMedium?.size);

      final themed = TSwitchResolve.resolve(
        context: context,
        enabled: true,
        theme: const TSwitchThemeData(
          trackOnColor: Colors.red,
          trackOffColor: Colors.green,
          thumbContentOnColor: Colors.blue,
          thumbContentOffColor: Colors.orange,
          thumbContentOnFont: TextStyle(fontSize: 18),
          thumbContentOffFont: TextStyle(fontSize: 10),
        ),
      );
      expect(themed.trackOnColor, Colors.red);
      expect(themed.trackOffColor, Colors.green);
      expect(themed.thumbContentOnColor, Colors.blue);
      expect(themed.thumbContentOffColor, Colors.orange);
      expect(themed.thumbContentOnFont.fontSize, 18);
      expect(themed.thumbContentOffFont.fontSize, 10);
    });

    test('ThemeData copyWith and lerp cover all fields', () {
      const base = TSwitchThemeData(
        defaultSize: TSwitchSize.small,
        defaultVariant: TSwitchVariant.filled,
        trackOnColor: Colors.red,
        trackOffColor: Colors.green,
        thumbContentOnColor: Colors.blue,
        thumbContentOffColor: Colors.orange,
        thumbContentOnFont: TextStyle(fontSize: 12),
        thumbContentOffFont: TextStyle(fontSize: 10),
      );
      const other = TSwitchThemeData(
        defaultSize: TSwitchSize.large,
        defaultVariant: TSwitchVariant.icon,
        trackOnColor: Colors.black,
        trackOffColor: Colors.white,
        thumbContentOnColor: Colors.purple,
        thumbContentOffColor: Colors.yellow,
        thumbContentOnFont: TextStyle(fontSize: 20),
        thumbContentOffFont: TextStyle(fontSize: 18),
      );

      expect(base.copyWith().defaultSize, TSwitchSize.small);
      expect(
        base
            .copyWith(
              defaultSize: TSwitchSize.large,
              defaultVariant: TSwitchVariant.text,
              trackOnColor: Colors.black,
              trackOffColor: Colors.white,
              thumbContentOnColor: Colors.purple,
              thumbContentOffColor: Colors.yellow,
              thumbContentOnFont: const TextStyle(fontSize: 20),
              thumbContentOffFont: const TextStyle(fontSize: 18),
            )
            .trackOnColor,
        Colors.black,
      );
      expect(base.lerp(null, 0.5), same(base));
      expect(base.lerp(other, 0), same(base));
      expect(base.lerp(other, 1), same(other));
      expect(base.lerp(other, 0.25).defaultSize, TSwitchSize.small);
      expect(base.lerp(other, 0.75).defaultSize, TSwitchSize.large);
    });
  });

  group('TCupertinoSwitch interaction', () {
    testWidgets('drag works in LTR and RTL and external updates animate', (
      tester,
    ) async {
      for (final direction in TextDirection.values) {
        bool? changed;
        await tester.pumpWidget(
          wrap(
            TCupertinoSwitch(
              value: false,
              onChanged: (value) => changed = value,
              activeColor: Colors.red,
              trackColor: Colors.green,
              thumbColor: Colors.white,
              thumbView: const Icon(Icons.check),
              dragStartBehavior: DragStartBehavior.down,
            ),
            direction: direction,
          ),
        );
        final delta = direction == TextDirection.ltr
            ? const Offset(80, 0)
            : const Offset(-80, 0);
        await tester.drag(find.byType(TCupertinoSwitch), delta);
        await tester.pumpAndSettle();
        expect(changed, isTrue);

        await tester.pumpWidget(
          wrap(
            const TCupertinoSwitch(value: true, onChanged: _noop),
            direction: direction,
          ),
        );
        await tester.pumpAndSettle();
      }
    });

    testWidgets('disabled switch ignores taps and exposes diagnostics', (
      tester,
    ) async {
      const widget = TCupertinoSwitch(value: false, onChanged: null);
      await tester.pumpWidget(wrap(widget));
      await tester.tap(find.byType(TCupertinoSwitch));
      await tester.pumpAndSettle();
      expect(widget.toStringShort(), contains('TCupertinoSwitch'));
    });
  });
}

void _noop(bool _) {}
