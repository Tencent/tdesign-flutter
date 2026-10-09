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

    testWidgets('禁用态分别使用轨道和滑块回退色', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(wrap(const TSwitch(value: true)));

      var widget = tester.widget<TCupertinoSwitch>(
        find.byType(TCupertinoSwitch),
      );
      expect(widget.activeColor, token.brandColorDisabled);
      expect(widget.trackColor, token.bgColorComponentDisabled);
      expect(widget.thumbColor, token.fontWhite1);
      expect(
        find.descendant(
          of: find.byType(TSwitch),
          matching: find.byWidgetPredicate(
            (child) => child is Opacity && child.opacity == 0.4,
          ),
        ),
        findsNothing,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.dark(token),
          home: const Scaffold(body: TSwitch(value: true)),
        ),
      );
      await tester.pumpAndSettle();
      final darkToken = token.dark ?? token;
      widget = tester.widget<TCupertinoSwitch>(find.byType(TCupertinoSwitch));
      expect(widget.activeColor, darkToken.brandColorDisabled);
      expect(widget.trackColor, darkToken.bgColorComponentDisabled);
      expect(widget.thumbColor, darkToken.fontWhite2);

      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.dark(token),
          home: const Scaffold(body: TSwitch(value: true, onChanged: _noop)),
        ),
      );
      widget = tester.widget<TCupertinoSwitch>(find.byType(TCupertinoSwitch));
      expect(widget.thumbColor, darkToken.textColorAnti);
    });

    testWidgets('禁用图文内容分别跟随开启和关闭轨道色', (tester) async {
      const switchTheme = TSwitchThemeData(
        disabledTrackOnColor: Colors.orange,
        disabledTrackOffColor: Colors.purple,
      );

      for (final variant in [TSwitchVariant.text, TSwitchVariant.icon]) {
        for (final value in [false, true]) {
          await tester.pumpWidget(
            wrap(
              TSwitch(value: value, variant: variant),
              switchTheme: switchTheme,
            ),
          );
          await tester.pumpAndSettle();

          final expectedColor = value ? Colors.orange : Colors.purple;
          if (variant == TSwitchVariant.text) {
            final label = tester.widget<Text>(find.text(value ? '开' : '关'));
            expect(label.style?.color, expectedColor);
          } else {
            final icon = tester.widget<Icon>(
              find.byIcon(value ? TIcons.check : TIcons.close),
            );
            expect(icon.color, expectedColor);
          }
        }
      }
    });

    testWidgets('加载色随明暗模式变化且可由组件 Theme 覆盖', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(wrap(const TSwitch(value: true, loading: true)));
      var indicator = tester.widget<TCircleIndicator>(
        find.byType(TCircleIndicator),
      );
      expect(indicator.color, token.brandColor);

      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.dark(token),
          home: const Scaffold(body: TSwitch(value: true, loading: true)),
        ),
      );
      await tester.pump(const Duration(milliseconds: 250));
      indicator = tester.widget<TCircleIndicator>(
        find.byType(TCircleIndicator),
      );
      expect(indicator.color, (token.dark ?? token).fontWhite1);

      await tester.pumpWidget(
        wrap(
          const TSwitch(value: true, loading: true),
          switchTheme: const TSwitchThemeData(
            disabledTrackOnColor: Colors.orange,
            disabledTrackOffColor: Colors.purple,
            disabledThumbColor: Colors.green,
            loadingColor: Colors.red,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 250));
      final widget = tester.widget<TCupertinoSwitch>(
        find.byType(TCupertinoSwitch),
      );
      expect(widget.activeColor, Colors.orange);
      expect(widget.trackColor, Colors.purple);
      expect(widget.thumbColor, Colors.green);
      indicator = tester.widget<TCircleIndicator>(
        find.byType(TCircleIndicator),
      );
      expect(indicator.color, Colors.red);
    });

    testWidgets('loading state is disabled and overrides thumb variant', (
      tester,
    ) async {
      var called = false;
      await tester.pumpWidget(
        wrap(
          TSwitch(
            value: true,
            loading: true,
            variant: TSwitchVariant.icon,
            onChanged: (_) => called = true,
          ),
        ),
      );

      await tester.tap(find.byType(TCupertinoSwitch), warnIfMissed: false);
      expect(called, isFalse);
      expect(find.byType(TCircleIndicator), findsOneWidget);
      expect(find.byIcon(TIcons.check), findsNothing);

      await tester.pumpWidget(
        wrap(
          TSwitch(
            value: true,
            variant: TSwitchVariant.icon,
            onChanged: (_) => called = true,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(TCircleIndicator), findsNothing);
      expect(find.byIcon(TIcons.check), findsOneWidget);
      await tester.tap(find.byType(TCupertinoSwitch));
      expect(called, isTrue);
    });
  });

  group('TSwitch variants and sizes', () {
    test('variant enum contains content shapes only', () {
      expect(TSwitchVariant.values, const [
        TSwitchVariant.filled,
        TSwitchVariant.text,
        TSwitchVariant.icon,
      ]);
    });

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
      'instance semantics and Theme visual values have separate owners',
      (tester) async {
        const theme = TSwitchThemeData(
          trackOnColor: Colors.red,
          trackOffColor: Colors.green,
          thumbContentOnColor: Colors.blue,
          thumbContentOffColor: Colors.orange,
          thumbContentOnFont: TextStyle(fontSize: 16),
          thumbContentOffFont: TextStyle(fontSize: 12),
        );
        await tester.pumpWidget(
          wrap(
            const TSwitch(
              value: true,
              size: TSwitchSize.small,
              variant: TSwitchVariant.text,
              onChanged: _noop,
            ),
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

      final defaults = TSwitchResolve.resolve(context: context);
      final token = TThemeData.defaultData();
      expect(defaults.trackOnColor, context.tTheme.brandColor);
      expect(
        defaults.trackOffColor,
        context.tTheme.bgColorSecondaryContainerActive,
      );
      expect(defaults.thumbColor, context.tTheme.textColorAnti);
      expect(defaults.thumbContentOnFont.fontSize, token.fontBodyMedium?.size);

      final themed = TSwitchResolve.resolve(
        context: context,
        theme: const TSwitchThemeData(
          trackOnColor: Colors.red,
          trackOffColor: Colors.green,
          thumbColor: Colors.pink,
          thumbContentOnColor: Colors.blue,
          thumbContentOffColor: Colors.orange,
          thumbContentOnFont: TextStyle(fontSize: 18),
          thumbContentOffFont: TextStyle(fontSize: 10),
        ),
      );
      expect(themed.trackOnColor, Colors.red);
      expect(themed.trackOffColor, Colors.green);
      expect(themed.thumbColor, Colors.pink);
      expect(themed.thumbContentOnColor, Colors.blue);
      expect(themed.thumbContentOffColor, Colors.orange);
      expect(themed.thumbContentOnFont.fontSize, 18);
      expect(themed.thumbContentOffFont.fontSize, 10);
    });

    testWidgets('unselected track paints with the component Token fallback', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const TSwitch(value: false, onChanged: _noop)),
      );

      final track = tester.widget<TCupertinoSwitch>(
        find.byType(TCupertinoSwitch),
      );
      expect(
        track.trackColor,
        TThemeData.defaultData().bgColorSecondaryContainerActive,
      );
      expect(track.trackColor, const Color(0xffdcdcdc));
    });

    test('ThemeData copyWith and lerp cover all fields', () {
      const base = TSwitchThemeData(
        trackOnColor: Colors.red,
        trackOffColor: Colors.green,
        thumbColor: Colors.red,
        disabledTrackOnColor: Colors.red,
        disabledTrackOffColor: Colors.green,
        disabledThumbColor: Colors.blue,
        loadingColor: Colors.orange,
        thumbContentOnColor: Colors.blue,
        thumbContentOffColor: Colors.orange,
        thumbContentOnFont: TextStyle(fontSize: 12),
        thumbContentOffFont: TextStyle(fontSize: 10),
      );
      const other = TSwitchThemeData(
        trackOnColor: Colors.black,
        trackOffColor: Colors.white,
        thumbColor: Colors.black,
        disabledTrackOnColor: Colors.black,
        disabledTrackOffColor: Colors.white,
        disabledThumbColor: Colors.purple,
        loadingColor: Colors.yellow,
        thumbContentOnColor: Colors.purple,
        thumbContentOffColor: Colors.yellow,
        thumbContentOnFont: TextStyle(fontSize: 20),
        thumbContentOffFont: TextStyle(fontSize: 18),
      );

      final copied = base.copyWith(
        trackOnColor: Colors.black,
        trackOffColor: Colors.white,
        thumbColor: Colors.black,
        disabledTrackOnColor: Colors.black,
        disabledTrackOffColor: Colors.white,
        disabledThumbColor: Colors.purple,
        loadingColor: Colors.yellow,
        thumbContentOnColor: Colors.purple,
        thumbContentOffColor: Colors.yellow,
        thumbContentOnFont: const TextStyle(fontSize: 20),
        thumbContentOffFont: const TextStyle(fontSize: 18),
      );
      expect(copied.trackOnColor, Colors.black);
      expect(copied.trackOffColor, Colors.white);
      expect(copied.thumbColor, Colors.black);
      expect(copied.disabledTrackOnColor, Colors.black);
      expect(copied.disabledTrackOffColor, Colors.white);
      expect(copied.disabledThumbColor, Colors.purple);
      expect(copied.loadingColor, Colors.yellow);
      expect(copied.thumbContentOnColor, Colors.purple);
      expect(copied.thumbContentOffColor, Colors.yellow);
      expect(copied.thumbContentOnFont?.fontSize, 20);
      expect(copied.thumbContentOffFont?.fontSize, 18);
      expect(base.lerp(null, 0.5), same(base));
      expect(base.lerp(other, 0), same(base));
      expect(base.lerp(other, 1), same(other));

      final midpoint = base.lerp(other, 0.5);
      expect(midpoint.trackOnColor, Color.lerp(Colors.red, Colors.black, 0.5));
      expect(
        midpoint.trackOffColor,
        Color.lerp(Colors.green, Colors.white, 0.5),
      );
      expect(midpoint.thumbColor, Color.lerp(Colors.red, Colors.black, 0.5));
      expect(
        midpoint.disabledTrackOnColor,
        Color.lerp(Colors.red, Colors.black, 0.5),
      );
      expect(
        midpoint.disabledTrackOffColor,
        Color.lerp(Colors.green, Colors.white, 0.5),
      );
      expect(
        midpoint.disabledThumbColor,
        Color.lerp(Colors.blue, Colors.purple, 0.5),
      );
      expect(
        midpoint.loadingColor,
        Color.lerp(Colors.orange, Colors.yellow, 0.5),
      );
      expect(
        midpoint.thumbContentOnColor,
        Color.lerp(Colors.blue, Colors.purple, 0.5),
      );
      expect(
        midpoint.thumbContentOffColor,
        Color.lerp(Colors.orange, Colors.yellow, 0.5),
      );
      expect(midpoint.thumbContentOnFont?.fontSize, 16);
      expect(midpoint.thumbContentOffFont?.fontSize, 14);

      const unset = TSwitchThemeData();
      expect(unset.lerp(unset, 0.5).disabledThumbColor, isNull);
      expect(unset.lerp(base, 0.25).disabledThumbColor, isNull);
      expect(unset.lerp(base, 0.75).disabledThumbColor, Colors.blue);
      expect(base.lerp(unset, 0.25).disabledThumbColor, Colors.blue);
      expect(base.lerp(unset, 0.75).disabledThumbColor, isNull);
    });
  });

  group('TCupertinoSwitch interaction', () {
    testWidgets('updates render state when controlled properties change', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const TCupertinoSwitch(
            value: false,
            onChanged: _noop,
            activeColor: Colors.red,
            trackColor: Colors.green,
            thumbColor: Colors.white,
          ),
        ),
      );

      await tester.pumpWidget(
        wrap(
          const TCupertinoSwitch(
            value: true,
            onChanged: null,
            activeColor: Colors.blue,
            trackColor: Colors.orange,
            thumbColor: Colors.black,
          ),
          direction: TextDirection.rtl,
        ),
      );
      await tester.pumpAndSettle();

      final updated = tester.widget<TCupertinoSwitch>(
        find.byType(TCupertinoSwitch),
      );
      expect(updated.value, isTrue);
      expect(updated.onChanged, isNull);
      expect(updated.activeColor, Colors.blue);
      expect(updated.trackColor, Colors.orange);
      expect(updated.thumbColor, Colors.black);
      expect(
        Directionality.of(tester.element(find.byType(TCupertinoSwitch))),
        TextDirection.rtl,
      );
    });

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
      expect(widget.toStringDeep(), contains('value: off'));
      expect(widget.toStringDeep(), contains('disabled'));
    });
  });
}

void _noop(bool _) {}
