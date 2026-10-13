import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/theme/t_internal_material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  statefulNativeBehaviorTests();
  ownershipBoundaryTests();
  testWidgets(
    'internal actions isolate Material styles and retain explicit styles and content',
    (tester) async {
      final token = TThemeData.defaultData();
      var pressed = 0;
      for (final m3 in [false, true]) {
        final external = ThemeData(
          useMaterial3: m3,
          extensions: [token],
          visualDensity: const VisualDensity(horizontal: 4, vertical: 4),
          iconButtonTheme: const IconButtonThemeData(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.pink),
              shape: WidgetStatePropertyAll(BeveledRectangleBorder()),
              padding: WidgetStatePropertyAll(EdgeInsets.all(60)),
            ),
          ),
        );
        ThemeData? observed;
        await tester.pumpWidget(
          MaterialApp(
            theme: external,
            home: Scaffold(
              body: Column(
                children: [
                  TInternalIconButton(
                    icon: Builder(
                      builder: (context) {
                        observed = Theme.of(context);
                        return const TIcon(TIcons.home);
                      },
                    ),
                    onPressed: () => pressed++,
                  ),
                  const TInternalIconButton(
                    onPressed: null,
                    iconSize: 18,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints.tightFor(width: 32, height: 32),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.blue),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder()),
                    ),
                    icon: Icon(Icons.home),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final buttons = tester
            .widgetList<IconButton>(find.byType(IconButton))
            .toList();
        expect(observed!.useMaterial3, m3);
        expect(
          observed!.iconButtonTheme.style!.backgroundColor!.resolve({}),
          Colors.pink,
        );
        expect(
          buttons.first.style!.backgroundColor!.resolve({}),
          Colors.transparent,
        );
        expect(buttons.first.style!.shape!.resolve({}), isA<CircleBorder>());
        expect(
          buttons.first.style!.padding!.resolve({}),
          const EdgeInsets.all(8),
        );
        expect(buttons.first.style!.visualDensity, VisualDensity.standard);
        expect(buttons.last.style!.backgroundColor!.resolve({}), Colors.blue);
        expect(
          tester.getSize(find.byType(IconButton).last),
          const Size(32, 32),
        );
        for (final state in [
          WidgetState.pressed,
          WidgetState.hovered,
          WidgetState.focused,
        ]) {
          expect(
            buttons.first.style!.overlayColor!.resolve({state}),
            isNot(Colors.transparent),
          );
        }
        expect(
          buttons.first.style!.overlayColor!.resolve({}),
          Colors.transparent,
        );
        await tester.tap(find.byType(IconButton).first);
        await tester.pumpAndSettle();
      }
      expect(pressed, 2);
    },
  );

  testWidgets(
    'ink feedback ignores Material colors while preserving explicit overlay and callbacks',
    (tester) async {
      var tapped = 0;
      for (final dark in [false, true]) {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              brightness: dark ? Brightness.dark : Brightness.light,
              hoverColor: Colors.pink,
              focusColor: Colors.pink,
              splashColor: Colors.pink,
              highlightColor: Colors.pink,
              splashFactory: NoSplash.splashFactory,
            ),
            home: Scaffold(
              body: TInternalInkWell(
                onTap: () => tapped++,
                child: const SizedBox(width: 40, height: 40),
              ),
            ),
          ),
        );
        final ink = tester.widget<InkWell>(find.byType(InkWell));
        expect(ink.splashColor, isNot(Colors.pink));
        expect(ink.hoverColor, isNot(Colors.pink));
        expect(ink.focusColor, isNot(Colors.pink));
        expect(ink.highlightColor, isNot(Colors.pink));
        expect(ink.splashFactory, InkRipple.splashFactory);
        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();
        final context = tester.element(find.byType(InkWell));
        final resolved = TInternalMaterialTheme.resolve(context);
        expect(resolved.brightness, dark ? Brightness.dark : Brightness.light);
        expect(resolved.visualDensity, VisualDensity.standard);
      }
      expect(tapped, 2);
      await tester.pumpWidget(
        const MaterialApp(
          home: Material(
            child: TInternalInkWell(
              overlayColor: WidgetStatePropertyAll(Colors.blue),
              splashColor: Colors.green,
              highlightColor: Colors.red,
              splashFactory: NoSplash.splashFactory,
              child: SizedBox(width: 40, height: 40),
            ),
          ),
        ),
      );
      final ink = tester.widget<InkWell>(find.byType(InkWell));
      expect(ink.overlayColor!.resolve({WidgetState.pressed}), Colors.blue);
      expect(ink.splashColor, Colors.green);
      expect(ink.highlightColor, Colors.red);
      expect(ink.splashFactory, NoSplash.splashFactory);
    },
  );

  testWidgets('host Material typography does not control TD content defaults', (
    tester,
  ) async {
    for (final m3 in [false, true]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(useMaterial3: m3),
          home: const Scaffold(
            body: Column(
              children: [
                TTag('tag'),
                TInput(initialValue: 'input'),
              ],
            ),
          ),
        ),
      );
      expect(
        tester
            .renderObject<RenderParagraph>(find.text('tag'))
            .text
            .style!
            .letterSpacing,
        0,
      );
      expect(
        tester
            .widget<EditableText>(find.byType(EditableText))
            .style
            .letterSpacing,
        0,
      );
    }
  });
}

void ownershipBoundaryTests() {
  testWidgets(
    'generic content retains icons and typography while TD glyphs stay owned',
    (tester) async {
      for (final m3 in [false, true]) {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              useMaterial3: m3,
              iconTheme: const IconThemeData(
                color: Colors.green,
                size: 64,
                opacity: 0.4,
                shadows: [Shadow(blurRadius: 3)],
              ),
              textTheme: const TextTheme(
                bodyMedium: TextStyle(fontSize: 31, fontFamily: 'caller-font'),
              ),
            ),
            home: const Scaffold(
              body: TInternalMaterial(
                child: Column(
                  children: [
                    Icon(Icons.home),
                    TIcon(TIcons.home),
                    Text('caller text'),
                    TText('TD text'),
                  ],
                ),
              ),
            ),
          ),
        );
        final caller = find.byIcon(Icons.home);
        final data = IconTheme.of(tester.element(caller));
        expect(data.color, Colors.green);
        expect(data.size, 64);
        expect(data.opacity, 0.4);
        expect(data.shadows!.single.blurRadius, 3);
        final td = tester.widget<Icon>(find.byIcon(TIcons.home));
        expect(td.size, 24);
        expect(td.color, TThemeData.defaultData().textColorPrimary);
        final text = tester.renderObject<RenderParagraph>(
          find.text('caller text'),
        );
        expect(text.text.style!.fontSize, 31);
        expect(text.text.style!.fontFamily, 'caller-font');
        expect(
          tester
              .renderObject<RenderParagraph>(find.text('TD text'))
              .text
              .style!
              .fontSize,
          TThemeData.defaultData().fontBodyMedium!.size,
        );
      }
    },
  );

  testWidgets('Dialog caller icon follows live inherited theme changes', (
    tester,
  ) async {
    for (final m3 in [false, true]) {
      for (final size in [64.0, 40.0]) {
        final color = size == 64 ? Colors.green : Colors.red;
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              useMaterial3: m3,
              iconTheme: IconThemeData(color: color, size: size),
            ),
            home: const Scaffold(body: TDialog(content: Icon(Icons.home))),
          ),
        );
        await tester.pumpAndSettle();
        final data = IconTheme.of(tester.element(find.byIcon(Icons.home)));
        expect(data.color, color);
        expect(data.size, size);
        expect(tester.getSize(find.byIcon(Icons.home)).height, size);
      }
    }
  });

  testWidgets(
    'native text selection and explicit selection colors survive editor isolation',
    (tester) async {
      var submitted = '';
      for (final m3 in [false, true]) {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              useMaterial3: m3,
              inputDecorationTheme: const InputDecorationTheme(
                filled: true,
                fillColor: Colors.pink,
              ),
              textSelectionTheme: const TextSelectionThemeData(
                selectionColor: Colors.pink,
                selectionHandleColor: Colors.green,
              ),
            ),
            home: Scaffold(
              body: Column(
                children: [
                  TInput(
                    initialValue: 'input',
                    onSubmitted: (value) => submitted = value,
                  ),
                  const TSearchBar(initialValue: 'search'),
                  const SelectionArea(
                    child: Column(
                      children: [
                        TText('native selection'),
                        TText(
                          'explicit selection',
                          selectionColor: Colors.yellow,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        expect(find.byType(InputDecorator), findsNothing);
        for (var index = 0; index < 2; index++) {
          tester
              .widgetList<EditableText>(find.byType(EditableText))
              .elementAt(index)
              .focusNode
              .requestFocus();
          await tester.pumpAndSettle();
          final editor = tester
              .widgetList<EditableText>(find.byType(EditableText))
              .elementAt(index);
          expect(editor.selectionColor, Colors.pink);
          expect(editor.style.letterSpacing, 0);
        }
        final texts = tester
            .widgetList<RichText>(
              find.descendant(
                of: find.byType(SelectionArea),
                matching: find.byType(RichText),
              ),
            )
            .toList();
        expect(texts.first.selectionColor, Colors.pink);
        expect(texts.last.selectionColor, Colors.yellow);
        await tester.enterText(find.byType(TextField).first, 'edited');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pump();
        expect(submitted, 'edited');
      }
    },
  );

  testWidgets(
    'tooltip keeps native timing trigger and semantics without ambient visuals',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            tooltipTheme: const TooltipThemeData(
              waitDuration: Duration(milliseconds: 50),
              showDuration: Duration(seconds: 10),
              exitDuration: Duration(milliseconds: 100),
              triggerMode: TooltipTriggerMode.tap,
              enableFeedback: false,
              excludeFromSemantics: true,
              decoration: BoxDecoration(color: Colors.pink),
              textStyle: TextStyle(fontSize: 80),
            ),
          ),
          home: const Scaffold(
            body: TInternalTooltip(
              message: 'native-tip',
              child: SizedBox(
                key: Key('tip-anchor'),
                width: 40,
                height: 40,
                child: ColoredBox(color: Colors.transparent),
              ),
            ),
          ),
        ),
      );
      final data = TooltipTheme.of(tester.element(find.byType(Tooltip)));
      expect(data.triggerMode, TooltipTriggerMode.tap);
      expect(data.waitDuration, const Duration(milliseconds: 50));
      expect(data.showDuration, const Duration(seconds: 10));
      expect(data.exitDuration, const Duration(milliseconds: 100));
      expect(data.enableFeedback, isFalse);
      expect(data.excludeFromSemantics, isTrue);
      expect(data.decoration, isNull);
      await tester.tap(find.byKey(const Key('tip-anchor')));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('native-tip'), findsOneWidget);
      expect(
        tester
            .renderObject<RenderParagraph>(find.text('native-tip'))
            .text
            .style!
            .fontSize,
        isNot(80),
      );
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    },
  );

  testWidgets('native feedback settings survive and explicit TD style wins', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          iconButtonTheme: const IconButtonThemeData(
            style: ButtonStyle(
              enableFeedback: false,
              mouseCursor: WidgetStatePropertyAll(SystemMouseCursors.forbidden),
              backgroundColor: WidgetStatePropertyAll(Colors.pink),
            ),
          ),
          elevatedButtonTheme: const ElevatedButtonThemeData(
            style: ButtonStyle(
              enableFeedback: false,
              mouseCursor: WidgetStatePropertyAll(SystemMouseCursors.forbidden),
            ),
          ),
        ),
        home: Scaffold(
          body: Column(
            children: [
              TInternalIconButton(
                onPressed: () {},
                icon: const Icon(Icons.home),
              ),
              TInternalIconButton(
                onPressed: () {},
                style: const ButtonStyle(
                  enableFeedback: true,
                  mouseCursor: WidgetStatePropertyAll(SystemMouseCursors.text),
                  backgroundColor: WidgetStatePropertyAll(Colors.blue),
                ),
                icon: const Icon(Icons.home),
              ),
              TButton(onPressed: () {}, child: const Text('native feedback')),
              TButton(
                onPressed: () {},
                style: const ButtonStyle(
                  enableFeedback: true,
                  mouseCursor: WidgetStatePropertyAll(SystemMouseCursors.text),
                ),
                child: const Text('explicit feedback'),
              ),
              Builder(
                builder: (context) => Theme(
                  data: Theme.of(context).mergeExtension(
                    const TButtonThemeData(
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.green],
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      TButton(
                        onPressed: () {},
                        child: const Text('gradient feedback'),
                      ),
                      TButton(
                        onPressed: () {},
                        style: const ButtonStyle(
                          enableFeedback: true,
                          mouseCursor: WidgetStatePropertyAll(
                            SystemMouseCursors.text,
                          ),
                        ),
                        child: const Text('explicit gradient feedback'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    final icons = tester
        .widgetList<IconButton>(find.byType(IconButton))
        .toList();
    expect(icons.first.style!.enableFeedback, isFalse);
    expect(
      icons.first.style!.mouseCursor!.resolve({}),
      SystemMouseCursors.forbidden,
    );
    expect(icons.last.style!.mouseCursor!.resolve({}), SystemMouseCursors.text);
    expect(icons.first.style!.backgroundColor!.resolve({}), Colors.transparent);
    expect(icons.last.style!.enableFeedback, isTrue);
    expect(icons.last.style!.backgroundColor!.resolve({}), Colors.blue);
    final buttons = tester
        .widgetList<ElevatedButton>(find.byType(ElevatedButton))
        .toList();
    expect(buttons.first.style!.enableFeedback, isFalse);
    expect(
      buttons.first.style!.mouseCursor!.resolve({}),
      SystemMouseCursors.forbidden,
    );
    expect(
      buttons.last.style!.mouseCursor!.resolve({}),
      SystemMouseCursors.text,
    );
    expect(buttons.last.style!.enableFeedback, isTrue);
    final ink = tester
        .widgetList<TInternalInkWell>(find.byType(TInternalInkWell))
        .toList();
    expect(ink.first.enableFeedback, isFalse);
    expect(ink.last.enableFeedback, isTrue);
    expect(
      (ink.first.mouseCursor! as WidgetStateMouseCursor).resolve({}),
      SystemMouseCursors.forbidden,
    );
    expect(
      (ink.last.mouseCursor! as WidgetStateMouseCursor).resolve({}),
      SystemMouseCursors.text,
    );
  });

  testWidgets(
    'local Material wrappers cannot inject visuals; caller content keeps wrappers',
    (tester) async {
      ThemeData? observed;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(useMaterial3: false),
          home: Scaffold(
            body: IconButtonTheme(
              data: const IconButtonThemeData(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.pink),
                  backgroundBuilder: pinkBackground,
                ),
              ),
              child: TInternalIconButton(
                onPressed: () {},
                icon: Builder(
                  builder: (context) {
                    observed = Theme.of(context);
                    expect(
                      IconButtonTheme.of(
                        context,
                      ).style!.backgroundColor!.resolve({}),
                      Colors.pink,
                    );
                    return const Icon(Icons.home);
                  },
                ),
              ),
            ),
          ),
        ),
      );
      expect(observed!.useMaterial3, isFalse);
      expect(find.byKey(const Key('injected-background')), findsNothing);
      expect(
        tester
            .widget<IconButton>(find.byType(IconButton))
            .style!
            .backgroundColor!
            .resolve({}),
        Colors.transparent,
      );
    },
  );

  testWidgets('explicit TD icon effects remain supported', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          iconTheme: const IconThemeData(
            opacity: 0.1,
            shadows: [Shadow(blurRadius: 99)],
          ),
          extensions: const [
            TSearchBarThemeData(
              clearIconTheme: IconThemeData(
                color: Colors.red,
                opacity: 0.4,
                shadows: [Shadow(blurRadius: 2)],
              ),
            ),
          ],
        ),
        home: const Scaffold(body: TSearchBar(initialValue: 'abc')),
      ),
    );
    final icon = tester.widget<Icon>(find.byIcon(TIcons.close_circle_filled));
    final paragraph = tester.renderObject<RenderParagraph>(
      find.descendant(
        of: find.byIcon(TIcons.close_circle_filled),
        matching: find.byType(RichText),
      ),
    );
    expect(paragraph.text.style!.color!.a, closeTo(0.4, 0.01));
    expect(icon.shadows!.single.blurRadius, 2);
  });

  testWidgets(
    'owned surfaces, separators and progress retain caller content and TD geometry',
    (tester) async {
      for (final dark in [false, true]) {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              brightness: dark ? Brightness.dark : Brightness.light,
              shadowColor: Colors.pink,
            ),
            home: Scaffold(
              body: Column(
                children: [
                  TInternalMaterial(
                    color: Colors.blue,
                    elevation: 2,
                    child: Builder(
                      builder: (context) {
                        expect(Theme.of(context).shadowColor, Colors.pink);
                        return const SizedBox(width: 30, height: 30);
                      },
                    ),
                  ),
                  const TInternalMaterial(type: MaterialType.transparency),
                  const TInternalDivider(),
                  const SizedBox(height: 30, child: TInternalVerticalDivider()),
                  const TInternalListTile(title: Text('plain')),
                  const TInternalListTile(
                    leading: Icon(Icons.home),
                    title: Text('leading'),
                  ),
                  const SizedBox.square(
                    dimension: 24,
                    child: TInternalCircularProgressIndicator(value: 0.5),
                  ),
                  const TInternalIcon(null),
                  const TInternalIconTheme(
                    data: IconThemeData(color: Colors.red),
                    child: TIcon(TIcons.home),
                  ),
                  const TInternalIconTheme.merge(
                    data: IconThemeData(size: 18),
                    child: TIcon(TIcons.home),
                  ),
                  const TInternalTooltip(
                    message: 'tip',
                    child: SizedBox(width: 20, height: 20),
                  ),
                ],
              ),
            ),
          ),
        );
        final surface = tester
            .widgetList<Material>(find.byType(Material))
            .firstWhere((m) => m.color == Colors.blue);
        expect(surface.shadowColor, Colors.black);
        expect(surface.surfaceTintColor, Colors.transparent);
        expect(tester.getSize(find.byType(ListTile).first).height, 56);
        expect(tester.widget<Divider>(find.byType(Divider)).indent, 0);
        expect(
          tester
              .widget<VerticalDivider>(find.byType(VerticalDivider))
              .endIndent,
          0,
        );
        expect(
          tester
              .widget<CircularProgressIndicator>(
                find.byType(CircularProgressIndicator),
              )
              .trackGap,
          0,
        );
      }
    },
  );

  testWidgets('controller writes update placeholder without changing editing', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TInput(controller: controller, hintText: 'placeholder'),
        ),
      ),
    );
    expect(find.text('placeholder'), findsOneWidget);
    expect(find.byType(InputDecorator), findsNothing);
    controller.text = 'abc';
    await tester.pump();
    expect(find.text('placeholder'), findsNothing);
    controller.clear();
    await tester.pump();
    expect(find.text('placeholder'), findsOneWidget);
    await tester.tap(find.byType(EditableText));
    await tester.enterText(find.byType(TextField), 'edited');
    expect(controller.text, 'edited');
  });
}

Widget pinkBackground(
  BuildContext context,
  Set<WidgetState> states,
  Widget? child,
) => ColoredBox(
  key: const Key('injected-background'),
  color: Colors.pink,
  child: child,
);

void statefulNativeBehaviorTests() {
  for (final m3 in [false, true]) {
    for (final gradient in [false, true]) {
      testWidgets(
        'stateful mouse cursor retains original native fallback M3=$m3 gradient=$gradient',
        (tester) async {
          final inherited = WidgetStateProperty.resolveWith<MouseCursor?>(
            (s) => s.contains(WidgetState.disabled)
                ? SystemMouseCursors.forbidden
                : s.contains(WidgetState.focused)
                ? SystemMouseCursors.precise
                : SystemMouseCursors.grab,
          );
          final partial = WidgetStateProperty.resolveWith<MouseCursor?>(
            (s) => s.contains(WidgetState.hovered)
                ? SystemMouseCursors.text
                : null,
          );
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(
                useMaterial3: m3,
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                    mouseCursor: inherited,
                    enableFeedback: false,
                  ),
                ),
                iconButtonTheme: IconButtonThemeData(
                  style: ButtonStyle(
                    mouseCursor: inherited,
                    enableFeedback: false,
                  ),
                ),
                extensions: [
                  TThemeData.defaultData(),
                  if (gradient)
                    const TButtonThemeData(
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.grey],
                      ),
                    ),
                ],
              ),
              home: Scaffold(
                body: Column(
                  children: [
                    TInternalIconButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        mouseCursor: partial,
                        foregroundColor: WidgetStateProperty.resolveWith(
                          (s) => s.contains(WidgetState.pressed)
                              ? Colors.pink
                              : null,
                        ),
                      ),
                      icon: const Icon(Icons.home),
                    ),
                    TButton(
                      onPressed: () {},
                      style: ButtonStyle(mouseCursor: partial),
                      child: const Text('cursor'),
                    ),
                  ],
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final iconStyle = tester
              .widget<IconButton>(find.byType(IconButton))
              .style!;
          final buttonCursor = gradient
              ? tester
                        .widget<TInternalInkWell>(find.byType(TInternalInkWell))
                        .mouseCursor!
                    as WidgetStateMouseCursor
              : tester
                    .widget<ElevatedButton>(find.byType(ElevatedButton))
                    .style!
                    .mouseCursor!;
          final states = [
            <WidgetState>{},
            {WidgetState.hovered},
            {WidgetState.focused},
            {WidgetState.disabled},
            {WidgetState.pressed},
          ];
          final expected = [
            SystemMouseCursors.grab,
            SystemMouseCursors.text,
            SystemMouseCursors.precise,
            SystemMouseCursors.forbidden,
            SystemMouseCursors.grab,
          ];
          for (var i = 0; i < states.length; i++) {
            expect(buttonCursor.resolve(states[i]), expected[i]);
            expect(iconStyle.mouseCursor!.resolve(states[i]), expected[i]);
          }
          final region = tester.widget<MouseRegion>(
            find
                .descendant(
                  of: find.byType(TButton),
                  matching: find.byType(MouseRegion),
                )
                .first,
          );
          expect(region.cursor, SystemMouseCursors.grab);
          expect(iconStyle.enableFeedback, isFalse);
          expect(
            iconStyle.foregroundColor!.resolve({}),
            TThemeData.defaultData().textColorPrimary,
          );
          expect(
            iconStyle.foregroundColor!.resolve({WidgetState.pressed}),
            Colors.pink,
          );
        },
      );
    }
  }
}
