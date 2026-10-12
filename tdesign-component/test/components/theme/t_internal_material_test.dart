import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/theme/t_internal_material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
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
        expect(
          resolved.textSelectionTheme.cursorColor,
          TThemeData.defaultData().brandColor,
        );
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
