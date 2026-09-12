import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child, {TSearchBarThemeData? searchTheme}) {
    var theme = TThemeBuilder.light(TThemeData.defaultData());
    if (searchTheme != null) {
      theme = theme.mergeExtension(searchTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: child),
    );
  }

  TextField field(WidgetTester tester) =>
      tester.widget<TextField>(find.byType(TextField));

  DecoratedBox inputBox(WidgetTester tester) {
    final finder = find
        .ancestor(
          of: find.byType(TextField),
          matching: find.byType(DecoratedBox),
        )
        .first;
    return tester.widget<DecoratedBox>(finder);
  }

  group('TSearchBar behavior', () {
    testWidgets('provides the TextField material context internally', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: const TSearchBar(hintText: '搜索'),
        ),
      );

      expect(find.byType(TSearchBar), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('supports controlled and initial text', (tester) async {
      final controller = TextEditingController(text: 'controlled');
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        wrap(TSearchBar(controller: controller, hintText: '搜索')),
      );

      expect(find.text('controlled'), findsOneWidget);
      expect(field(tester).decoration?.hintText, '搜索');

      await tester.pumpWidget(
        wrap(const TSearchBar(key: ValueKey('initial'), initialValue: 'first')),
      );
      expect(find.text('first'), findsOneWidget);
      expect(
        () => TSearchBar(controller: controller, initialValue: 'invalid'),
        throwsAssertionError,
      );
      await tester.pumpWidget(
        wrap(
          const TSearchBar(key: ValueKey('initial'), initialValue: 'second'),
        ),
      );
      expect(find.text('first'), findsOneWidget);
    });

    testWidgets('forwards change, submit, focus, and native input options', (
      tester,
    ) async {
      String? changed;
      String? submitted;
      bool? focused;
      final formatter = LengthLimitingTextInputFormatter(4);
      await tester.pumpWidget(
        wrap(
          TSearchBar(
            onChanged: (value) => changed = value,
            onSubmitted: (value) => submitted = value,
            onFocusChanged: (value) => focused = value,
            maxLength: 4,
            inputType: TextInputType.url,
            inputFormatters: [formatter],
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.pump();
      expect(focused, isTrue);
      await tester.enterText(find.byType(TextField), 'hello');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();

      expect(changed, 'hell');
      expect(submitted, 'hell');
      expect(field(tester).maxLength, 4);
      expect(field(tester).keyboardType, TextInputType.url);
      expect(field(tester).inputFormatters, [formatter]);
    });

    testWidgets('clear obeys enabled, readOnly, and clearable', (tester) async {
      final controller = TextEditingController(text: 'content');
      addTearDown(controller.dispose);
      var cleared = false;
      String? changed;
      await tester.pumpWidget(
        wrap(
          TSearchBar(
            controller: controller,
            onClearPressed: () => cleared = true,
            onChanged: (value) => changed = value,
          ),
        ),
      );
      expect(find.byIcon(TIcons.close_circle_filled), findsOneWidget);
      await tester.tap(find.byIcon(TIcons.close_circle_filled));
      await tester.pump();
      expect(controller.text, isEmpty);
      expect(cleared, isTrue);
      expect(changed, '');

      for (final search in [
        const TSearchBar(initialValue: 'text', enabled: false),
        const TSearchBar(initialValue: 'text', readOnly: true),
        const TSearchBar(initialValue: 'text', clearable: false),
      ]) {
        await tester.pumpWidget(wrap(search));
        expect(find.byIcon(TIcons.close_circle_filled), findsNothing);
      }
    });

    testWidgets('maxCharacter limits weighted text after IME composition', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const TSearchBar(maxCharacter: 4)));
      final formatter = field(tester).inputFormatters!.single;
      const composing = TextEditingValue(
        text: 'zhong',
        selection: TextSelection.collapsed(offset: 5),
        composing: TextRange(start: 0, end: 5),
      );
      expect(
        formatter.formatEditUpdate(TextEditingValue.empty, composing),
        composing,
      );

      await tester.enterText(find.byType(TextField), 'ab中文');
      expect(find.text('ab中'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'ab😀x');
      expect(find.text('ab😀'), findsOneWidget);
      expect(field(tester).controller?.text.runes, [0x61, 0x62, 0x1f600]);
      expect(
        () => TSearchBar(maxLength: 4, maxCharacter: 4),
        throwsAssertionError,
      );
    });

    testWidgets('action is controlled and has no implicit side effects', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'query');
      final focusNode = FocusNode();
      addTearDown(controller.dispose);
      addTearDown(focusNode.dispose);
      var pressed = false;
      await tester.pumpWidget(
        wrap(
          TSearchBar(
            controller: controller,
            focusNode: focusNode,
            actionText: '取消',
            onActionPressed: () => pressed = true,
          ),
        ),
      );
      focusNode.requestFocus();
      await tester.pump();
      await tester.tap(find.text('取消'));
      await tester.pump();

      expect(pressed, isTrue);
      expect(controller.text, 'query');
      expect(focusNode.hasFocus, isTrue);
    });

    testWidgets('disabled action uses disabled color and ignores taps', (
      tester,
    ) async {
      var pressed = false;
      await tester.pumpWidget(
        wrap(
          TSearchBar(
            enabled: false,
            actionText: '取消',
            onActionPressed: () => pressed = true,
          ),
          searchTheme: const TSearchBarThemeData(
            actionTextStyle: TextStyle(color: Colors.red),
          ),
        ),
      );

      expect(
        tester.widget<Text>(find.text('取消')).style?.color,
        TThemeData.defaultData().textDisabledColor,
      );
      await tester.tap(find.text('取消'));
      expect(pressed, isFalse);
    });
  });

  group('TSearchBar visual contract', () {
    testWidgets('defaults to the 40dp token-based component surface', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const TSearchBar(hintText: '搜索')));
      final token = TThemeData.defaultData();
      final decoration = inputBox(tester).decoration as BoxDecoration;

      expect(tester.getSize(find.byType(TSearchBar)).height, 40);
      expect(
        tester
            .getSize(
              find
                  .ancestor(
                    of: find.byType(TextField),
                    matching: find.byType(DecoratedBox),
                  )
                  .first,
            )
            .height,
        40,
      );
      expect(decoration.color, token.bgColorSecondaryContainer);
      expect(decoration.borderRadius, BorderRadius.circular(6));
      expect(tester.getSize(find.byIcon(TIcons.search)), const Size.square(24));
      expect(field(tester).style?.fontSize, token.fontBodyLarge?.size);
      expect(field(tester).style?.height, token.fontBodyLarge?.height);
      expect(
        field(tester).decoration?.hintStyle?.color,
        token.textColorPlaceholder,
      );
      expect(field(tester).decoration?.isCollapsed, isTrue);
      expect(field(tester).decoration?.contentPadding, EdgeInsets.zero);
    });

    testWidgets('instance values override component theme', (tester) async {
      await tester.pumpWidget(
        wrap(
          const TSearchBar(
            hintText: '搜索',
            variant: TSearchBarVariant.square,
            textAlignment: TSearchBarAlignment.center,
          ),
          searchTheme: const TSearchBarThemeData(
            variant: TSearchBarVariant.round,
            height: 48,
            inputBackgroundColor: Colors.red,
            cursorHeight: 20,
          ),
        ),
      );
      final decoration = inputBox(tester).decoration as BoxDecoration;

      expect(tester.getSize(find.byType(TSearchBar)).height, 48);
      expect(field(tester).textAlign, TextAlign.center);
      expect(field(tester).cursorHeight, 20);
      expect(decoration.color, Colors.red);
      expect(decoration.borderRadius, BorderRadius.circular(6));
    });

    test('theme copyWith and lerp cover visual fields', () {
      const base = TSearchBarThemeData(
        variant: TSearchBarVariant.square,
        height: 40,
        inputBackgroundColor: Colors.white,
        contentPadding: EdgeInsets.all(8),
        actionGap: 10,
      );
      const other = TSearchBarThemeData(
        variant: TSearchBarVariant.round,
        height: 48,
        inputBackgroundColor: Colors.black,
        contentPadding: EdgeInsets.all(16),
        actionGap: 20,
      );

      expect(base.copyWith(height: 44).height, 44);
      expect(base.copyWith().variant, TSearchBarVariant.square);
      expect(base.lerp(null, 0.5), same(base));
      expect(base.lerp(other, 0.25).variant, TSearchBarVariant.square);
      expect(base.lerp(other, 0.75).variant, TSearchBarVariant.round);
      expect(base.lerp(other, 0.5).height, 44);
      expect(base.lerp(other, 0.5).actionGap, 15);
    });
  });
}
