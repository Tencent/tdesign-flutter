import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child, {TSearchBarThemeData? searchTheme}) {
    final token = TThemeData.defaultData();
    var theme = TThemeBuilder.light(token);
    if (searchTheme != null) {
      theme = theme.mergeExtension(searchTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: Center(child: child)),
    );
  }

  TextField textField(WidgetTester tester) =>
      tester.widget<TextField>(find.byType(TextField));

  Finder inputContainerFinder() => find
      .ancestor(
        of: find.byType(TextField),
        matching: find.byWidgetPredicate(
          (widget) => widget is Container && widget.decoration != null,
        ),
      )
      .first;

  Container inputContainer(WidgetTester tester) => tester.widget<Container>(
        inputContainerFinder(),
      );

  group('TSearchBar v1 behavior', () {
    testWidgets('renders hint and controller text', (tester) async {
      final controller = TextEditingController(text: 'initial');
      await tester.pumpWidget(wrap(TSearchBar(
        controller: controller,
        hintText: 'search',
      )));

      expect(find.byType(TSearchBar), findsOneWidget);
      expect(find.text('initial'), findsOneWidget);
      expect(textField(tester).decoration?.hintText, 'search');
      controller.dispose();
    });

    testWidgets('initialValue initializes internal controller once',
        (tester) async {
      await tester.pumpWidget(wrap(const TSearchBar(initialValue: 'first')));
      expect(find.text('first'), findsOneWidget);

      await tester.pumpWidget(wrap(const TSearchBar(initialValue: 'second')));
      expect(find.text('first'), findsOneWidget);
      expect(find.text('second'), findsNothing);
    });

    testWidgets('onChanged and onSubmitted are forwarded', (tester) async {
      String? changed;
      String? submitted;
      await tester.pumpWidget(wrap(TSearchBar(
        onChanged: (value) => changed = value,
        onSubmitted: (value) => submitted = value,
      )));

      await tester.enterText(find.byType(TextField), 'hello');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();

      expect(changed, 'hello');
      expect(submitted, 'hello');
    });

    testWidgets('enabled false disables input', (tester) async {
      await tester.pumpWidget(wrap(const TSearchBar(
        initialValue: 'disabled',
        enabled: false,
      )));

      expect(textField(tester).enabled, isFalse);
      expect(find.byIcon(TIcons.close_circle_filled), findsOneWidget);
    });

    testWidgets('readOnly true keeps input focusable but not editable by user',
        (tester) async {
      await tester.pumpWidget(wrap(const TSearchBar(readOnly: true)));

      expect(textField(tester).readOnly, isTrue);
      expect(textField(tester).enabled, isTrue);
    });

    testWidgets('clear button clears text and fires callbacks', (tester) async {
      final controller = TextEditingController(text: 'content');
      var cleared = false;
      String? changed;
      await tester.pumpWidget(wrap(TSearchBar(
        controller: controller,
        onClearPressed: () => cleared = true,
        onChanged: (value) => changed = value,
      )));
      await tester.pump();

      await tester.tap(find.byIcon(TIcons.close_circle_filled));
      await tester.pump();

      expect(controller.text, isEmpty);
      expect(cleared, isTrue);
      expect(changed, '');
      controller.dispose();
    });

    testWidgets('cancel button appears on focus and clears text',
        (tester) async {
      final controller = TextEditingController(text: 'query');
      var cancelled = false;
      String? changed;
      await tester.pumpWidget(wrap(TSearchBar(
        controller: controller,
        needCancel: true,
        cancelText: '取消',
        onCancelPressed: () => cancelled = true,
        onChanged: (value) => changed = value,
      )));

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(find.text('取消'), findsOneWidget);

      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();

      expect(controller.text, isEmpty);
      expect(cancelled, isTrue);
      expect(changed, '');
      controller.dispose();
    });

    testWidgets('updates controller and focusNode when widgets change',
        (tester) async {
      final firstController = TextEditingController(text: 'first');
      final secondController = TextEditingController(text: 'second');
      final firstFocus = FocusNode();
      final secondFocus = FocusNode();

      await tester.pumpWidget(wrap(TSearchBar(
        controller: firstController,
        focusNode: firstFocus,
      )));
      expect(find.text('first'), findsOneWidget);

      await tester.pumpWidget(wrap(TSearchBar(
        controller: secondController,
        focusNode: secondFocus,
      )));
      expect(find.text('second'), findsOneWidget);

      firstController.dispose();
      secondController.dispose();
      firstFocus.dispose();
      secondFocus.dispose();
    });
  });

  group('TSearchBar theme', () {
    testWidgets('theme controls variant, alignment, padding, and height',
        (tester) async {
      await tester.pumpWidget(wrap(
        const TSearchBar(hintText: 'theme'),
        searchTheme: const TSearchBarThemeData(
          variant: TSearchBarVariant.round,
          textAlignment: TSearchBarAlignment.center,
          padding: EdgeInsets.all(20),
          backgroundColor: Colors.red,
          cursorHeight: 24,
          autoHeight: true,
        ),
      ));

      expect(textField(tester).textAlign, TextAlign.center);
      expect(textField(tester).cursorHeight, 24);
      expect(find.byType(TSearchBar), findsOneWidget);
    });

    testWidgets('uses develop search field icon sizing', (tester) async {
      await tester.pumpWidget(wrap(
        const TSearchBar(hintText: 'theme'),
        searchTheme: const TSearchBarThemeData(
          variant: TSearchBarVariant.round,
          textAlignment: TSearchBarAlignment.center,
        ),
      ));

      final token = TThemeData.defaultData();
      final inputDecoration =
          inputContainer(tester).decoration as BoxDecoration;
      final searchIcon = tester.widget<Icon>(find.byIcon(TIcons.search));
      expect(textField(tester).textAlign, TextAlign.center);
      expect(inputDecoration.color, token.bgColorSecondaryContainer);
      expect(inputDecoration.borderRadius, BorderRadius.circular(28));
      expect(searchIcon.size, 24);
    });

    testWidgets('default layout matches develop visual tokens', (tester) async {
      await tester.pumpWidget(wrap(const TSearchBar(hintText: 'theme')));

      final token = TThemeData.defaultData();
      final inputDecoration =
          inputContainer(tester).decoration as BoxDecoration;
      final searchBarSize = tester.getSize(find.byType(TSearchBar));
      final inputSize = tester.getSize(inputContainerFinder());
      final searchIcon = tester.widget<Icon>(find.byIcon(TIcons.search));
      final field = textField(tester);
      final fieldDecoration = textField(tester).decoration;

      expect(searchBarSize.height, 56);
      expect(inputSize.height, 40);
      expect(inputDecoration.color, token.bgColorSecondaryContainer);
      expect(inputDecoration.borderRadius, BorderRadius.circular(4));
      expect(searchIcon.size, 24);
      expect(field.textAlignVertical, TextAlignVertical.center);
      expect(field.style?.height, token.fontBodyLarge?.height);
      expect(fieldDecoration?.filled, isFalse);
      expect(fieldDecoration?.fillColor, Colors.transparent);
      expect(fieldDecoration?.isCollapsed, isTrue);
      expect(fieldDecoration?.hintMaxLines, 1);
      expect(fieldDecoration?.contentPadding, EdgeInsets.zero);
    });

    testWidgets('custom decoration still keeps collapsed search layout',
        (tester) async {
      await tester.pumpWidget(wrap(
        const TSearchBar(
          hintText: 'custom',
          decoration: InputDecoration(
            helperText: 'helper',
          ),
        ),
      ));

      final fieldDecoration = textField(tester).decoration;
      expect(fieldDecoration?.helperText, 'helper');
      expect(fieldDecoration?.filled, isFalse);
      expect(fieldDecoration?.fillColor, Colors.transparent);
      expect(fieldDecoration?.isCollapsed, isTrue);
      expect(fieldDecoration?.hintMaxLines, 1);
      expect(fieldDecoration?.contentPadding, EdgeInsets.zero);
    });

    test('TSearchBarThemeData copyWith and lerp', () {
      const base = TSearchBarThemeData(
        variant: TSearchBarVariant.square,
        textAlignment: TSearchBarAlignment.left,
        backgroundColor: Colors.white,
        padding: EdgeInsets.all(8),
        cursorHeight: 18,
        autoHeight: false,
      );
      const other = TSearchBarThemeData(
        variant: TSearchBarVariant.round,
        textAlignment: TSearchBarAlignment.center,
        backgroundColor: Colors.black,
        padding: EdgeInsets.all(16),
        cursorHeight: 28,
        autoHeight: true,
      );

      expect(base.copyWith(variant: TSearchBarVariant.round).variant,
          TSearchBarVariant.round);
      expect(base.copyWith().variant, TSearchBarVariant.square);
      expect(base.lerp(null, 0.5), same(base));
      expect(base.lerp(other, 0.25).textAlignment, TSearchBarAlignment.left);
      expect(base.lerp(other, 0.75).textAlignment, TSearchBarAlignment.center);
      expect(base.lerp(other, 0.5).cursorHeight, 23);
    });
  });
}
