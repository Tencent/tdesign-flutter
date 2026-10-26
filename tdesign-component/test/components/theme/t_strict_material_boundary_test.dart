import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/theme/t_internal_material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../helpers/custom_content_theme_scene.dart';

void main() {
  testWidgets('Dialog custom content keeps its explicit local TD text theme', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(760, 420);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const CustomContentThemeScene());
    await tester.pump(const Duration(milliseconds: 400));

    // Verify the same M2/M3 scene as Golden without platform-dependent pixels.
    final tdLabels = find.descendant(
      of: find.byType(TText),
      matching: find.byType(Text),
    );
    expect(tdLabels, findsNWidgets(2));
    for (final element in tdLabels.evaluate()) {
      final text = element.widget as Text;
      final token = Theme.of(element).extension<TThemeData>()!;
      expect(text.style!.fontSize, token.fontBodyMedium!.size);
      expect(text.style!.height, token.fontBodyMedium!.height);
      expect(text.style!.color, token.textColorPrimary);
    }
    final nativeLabels = find.text('Custom content');
    expect(nativeLabels, findsNWidgets(2));
    for (final element in nativeLabels.evaluate()) {
      final text = element.widget as Text;
      expect(text.style!.fontSize, 28);
      expect(text.style!.color, Colors.purple);
      expect(IconTheme.of(element).color, Colors.green);
      expect(IconTheme.of(element).size, 64);
    }
  });

  for (final m3 in [false, true]) {
    testWidgets(
      'owned native labels isolate selection but custom text keeps it M3=$m3',
      (tester) async {
        final cases = <(Widget, List<String>)>[
          (
            const TSteps.progress(steps: [TStepsItemData(title: 'step')]),
            ['1'],
          ),
          (
            const TSteps.progress(
              direction: TStepsDirection.vertical,
              steps: [TStepsItemData(title: 'step')],
            ),
            ['1'],
          ),
          (TProgress.linear(value: 0.42), ['42%']),
          (
            const SizedBox(
              height: 100,
              child: Stack(children: [TFab(text: 'owned-fab')]),
            ),
            ['owned-fab'],
          ),
          (
            const TConfirmDialog(
              title: 'owned-title',
              content: 'owned-content',
              buttonText: 'owned-action',
            ),
            ['owned-title', 'owned-content', 'owned-action'],
          ),
          (TUpload(files: const [], layout: TUploadLayout.list), ['Upload']),
        ];
        for (final (child, labels) in cases) {
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(
                useMaterial3: m3,
                textSelectionTheme: const TextSelectionThemeData(
                  selectionColor: Colors.pink,
                ),
              ),
              home: Scaffold(
                body: SelectionArea(
                  child: Column(
                    children: [
                      child,
                      const Text('caller-text'),
                      TButton(
                        onPressed: () {},
                        child: const Text(
                          'explicit-caller',
                          selectionColor: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          for (final label in labels) {
            final paragraph = tester.renderObject<RenderParagraph>(
              find.descendant(
                of: find.text(label),
                matching: find.byType(RichText),
              ),
            );
            expect(
              paragraph.selectionColor,
              TThemeData.defaultData().brandColor.withValues(alpha: 0.4),
              reason: label,
            );
          }
          expect(
            tester
                .renderObject<RenderParagraph>(
                  find.descendant(
                    of: find.text('caller-text'),
                    matching: find.byType(RichText),
                  ),
                )
                .selectionColor,
            Colors.pink,
          );
          expect(
            tester
                .renderObject<RenderParagraph>(
                  find.descendant(
                    of: find.text('explicit-caller'),
                    matching: find.byType(RichText),
                  ),
                )
                .selectionColor,
            Colors.orange,
          );
          expect(tester.takeException(), isNull);
        }
      },
    );
    testWidgets('owned scrolling ignores ambient Material defaults M3=$m3', (
      tester,
    ) async {
      final caller = ThemeData(
        useMaterial3: m3,
        platform: TargetPlatform.android,
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: caller,
          home: Scaffold(
            body: TSideBar(
              value: 0,
              onChanged: (_) {},
              height: 120,
              children: List.generate(
                10,
                (i) => TSideBarItem(value: i, label: 'item$i'),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(GlowingOverscrollIndicator), findsNothing);
      expect(find.byType(StretchingOverscrollIndicator), findsNothing);
      final scrollable = tester.state<ScrollableState>(
        find.byType(Scrollable).first,
      );
      await tester.drag(find.byType(ListView), const Offset(0, -150));
      await tester.pumpAndSettle();
      expect(scrollable.position.pixels, greaterThan(0));
    });
    testWidgets(
      'editor isolates selection and menu while slots retain caller themes M3=$m3',
      (tester) async {
        String? copied;
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          (call) async {
            if (call.method == 'Clipboard.setData') {
              copied = (call.arguments as Map)['text'] as String?;
            }
            if (call.method == 'Clipboard.hasStrings') {
              return {'value': copied?.isNotEmpty ?? false};
            }
            if (call.method == 'Clipboard.getData') {
              return {'text': copied};
            }
            return null;
          },
        );
        addTearDown(
          () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
            SystemChannels.platform,
            null,
          ),
        );
        ThemeData? observed;
        final caller = ThemeData(
          useMaterial3: m3,
          platform: TargetPlatform.android,
          textButtonTheme: const TextButtonThemeData(
            style: ButtonStyle(elevation: WidgetStatePropertyAll(9)),
          ),
          textSelectionTheme: const TextSelectionThemeData(
            selectionColor: Colors.pink,
            selectionHandleColor: Colors.green,
          ),
        );
        await tester.pumpWidget(
          MaterialApp(
            theme: caller,
            home: Scaffold(
              body: TInput(
                initialValue: 'owned input',
                prefix: Builder(
                  builder: (context) {
                    observed = Theme.of(context);
                    return const Icon(Icons.home);
                  },
                ),
              ),
            ),
          ),
        );
        expect(observed!.textSelectionTheme.selectionHandleColor, Colors.green);
        final field = tester.widget<EditableText>(find.byType(EditableText));
        field.focusNode.requestFocus();
        await tester.pumpAndSettle();
        field.controller.selection = const TextSelection(
          baseOffset: 0,
          extentOffset: 5,
        );
        await tester.pump();
        expect(
          tester.widget<EditableText>(find.byType(EditableText)).selectionColor,
          TThemeData.defaultData().brandColor.withValues(alpha: 0.4),
        );
        expect(
          TextSelectionTheme.of(
            tester.element(find.byType(EditableText)),
          ).selectionHandleColor,
          TThemeData.defaultData().brandColor,
        );
        final state = tester.state<EditableTextState>(
          find.byType(EditableText),
        );
        expect(state.showToolbar(), isTrue);
        await tester.pumpAndSettle();
        final buttons = find.byType(TextButton);
        expect(buttons, findsWidgets);
        final menuContext = tester.element(buttons.first);
        expect(
          TextButtonTheme.of(menuContext).style?.elevation?.resolve({}),
          isNot(9),
        );
        expect(
          tester
              .widgetList<Material>(
                find.descendant(
                  of: buttons.first,
                  matching: find.byType(Material),
                ),
              )
              .any((m) => m.elevation == 9),
          isFalse,
        );
        expect(Theme.of(menuContext).textTheme.bodyMedium!.letterSpacing, 0);
        // Copy retains the native controller/selection semantics.
        state.copySelection(SelectionChangedCause.toolbar);
        await tester.pump();
        expect(copied, 'owned');
        expect(field.controller.text, 'owned input');
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();
      },
    );
  }
  testWidgets(
    'desktop chrome and custom scrollable themes have distinct owners',
    (tester) async {
      for (final platform in [
        TargetPlatform.windows,
        TargetPlatform.macOS,
        TargetPlatform.linux,
        TargetPlatform.iOS,
        TargetPlatform.fuchsia,
      ]) {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              platform: platform,
              scrollbarTheme: const ScrollbarThemeData(
                thickness: WidgetStatePropertyAll(29),
                interactive: false,
              ),
            ),
            home: Scaffold(
              body: SizedBox(
                height: 120,
                child: TInternalScrollScope(
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 300,
                        child: Builder(
                          builder: (context) {
                            expect(
                              ScrollbarTheme.of(context).thickness!.resolve({}),
                              29,
                            );
                            return const Text('caller');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final bars = tester.widgetList<RawScrollbar>(find.byType(RawScrollbar));
        if ([
          TargetPlatform.windows,
          TargetPlatform.macOS,
          TargetPlatform.linux,
        ].contains(platform)) {
          expect(bars.single.thickness, 6);
          expect(bars.single.interactive, isTrue);
          expect(
            bars.single.thumbColor,
            TThemeData.defaultData().textColorPlaceholder,
          );
        } else {
          expect(bars, isEmpty);
        }
      }
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: TargetPlatform.windows),
          home: const Scaffold(
            body: TInternalScrollScope(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(width: 1000),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(RawScrollbar), findsNothing);
    },
  );
  testWidgets(
    'internal ListTile alignment is stable under an internal M2/M3 switch',
    (tester) async {
      for (final m3 in [false, true]) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  final owned =
                      const TInternalListTile(
                            leading: SizedBox(
                              key: Key('leading'),
                              width: 20,
                              height: 20,
                            ),
                            title: SizedBox(height: 100, width: 150),
                          ).build(context)
                          as Theme;
                  return Theme(
                    // Simulate an internal implementation switch, not an external configuration.
                    // ignore: deprecated_member_use
                    data: owned.data.copyWith(useMaterial3: m3),
                    child: owned.child,
                  );
                },
              ),
            ),
          ),
        );
        final tile = tester.widget<ListTile>(find.byType(ListTile));
        expect(tile.titleAlignment, ListTileTitleAlignment.center);
        expect(
          tester.getTopLeft(find.byKey(const Key('leading'))).dy -
              tester.getTopLeft(find.byType(ListTile)).dy,
          48,
        );
      }
    },
  );
  testWidgets(
    'explicit TD feedback and native custom content themes survive nearby component themes',
    (tester) async {
      ButtonStyle? callerStyle;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconButtonTheme(
              data: const IconButtonThemeData(
                style: ButtonStyle(
                  enableFeedback: true,
                  foregroundColor: WidgetStatePropertyAll(Colors.pink),
                ),
              ),
              child: Column(
                children: [
                  TInternalIconButton(
                    onPressed: () {},
                    style: const ButtonStyle(enableFeedback: false),
                    icon: Builder(
                      builder: (context) {
                        callerStyle = IconButtonTheme.of(context).style;
                        return const Icon(Icons.home);
                      },
                    ),
                  ),
                  TButton(
                    onPressed: () {},
                    style: const ButtonStyle(enableFeedback: false),
                    child: const Text('explicit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      expect(callerStyle!.enableFeedback, isTrue);
      expect(callerStyle!.foregroundColor!.resolve({}), Colors.pink);
      expect(
        tester
            .widget<IconButton>(find.byType(IconButton))
            .style!
            .enableFeedback,
        isFalse,
      );
      expect(
        tester
            .widget<ElevatedButton>(find.byType(ElevatedButton))
            .style!
            .enableFeedback,
        isFalse,
      );
    },
  );
  testWidgets(
    'native menu labels retain actual TD typography on all platforms',
    (tester) async {
      for (final platform in TargetPlatform.values) {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              platform: platform,
              extensions: const [
                TTextThemeData(
                  textStyle: TextStyle(
                    fontSize: 23,
                    letterSpacing: 2,
                    fontFamily: 'TDMenuProbe',
                  ),
                ),
              ],
            ),
            home: const Scaffold(body: TInput(initialValue: 'owned input')),
          ),
        );
        await tester.pumpAndSettle();
        final state = tester.state<EditableTextState>(
          find.byType(EditableText),
        );
        state.widget.focusNode.requestFocus();
        await tester.pumpAndSettle();
        state.widget.controller.selection = const TextSelection(
          baseOffset: 0,
          extentOffset: 5,
        );
        await tester.pump();
        expect(state.showToolbar(), isTrue);
        await tester.pumpAndSettle();
        final label = tester.renderObject<RenderParagraph>(find.text('Copy'));
        expect(label.text.style!.fontSize, 23);
        expect(label.text.style!.fontFamily, 'TDMenuProbe');
        expect(label.text.style!.letterSpacing, 2);
        if (platform == TargetPlatform.macOS) {
          expect(
            label.text.style!.color,
            TThemeData.defaultData().textColorPrimary,
          );
          final mouse = await tester.createGesture(
            kind: PointerDeviceKind.mouse,
          );
          await mouse.addPointer(location: Offset.zero);
          await mouse.moveTo(tester.getCenter(find.text('Copy')));
          await tester.pumpAndSettle();
          expect(
            tester
                .renderObject<RenderParagraph>(find.text('Copy'))
                .text
                .style!
                .color,
            Colors.white,
          );
          await mouse.removePointer();
        }

        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();
      }
    },
  );
  testWidgets(
    'tooltip defaults retain readable contrast in both brightness modes',
    (tester) async {
      for (final dark in [false, true]) {
        final token = dark
            ? TThemeData.defaultData().dark!
            : TThemeData.defaultData();
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              brightness: dark ? Brightness.dark : Brightness.light,
              extensions: [token],
            ),
            home: const Scaffold(
              body: TInternalTooltip(
                message: 'contrast',
                child: SizedBox(width: 40, height: 40),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final theme = TooltipTheme.of(tester.element(find.byType(Tooltip)));
        final background = (theme.decoration! as BoxDecoration).color!;
        final foreground = theme.textStyle!.color!;
        final bright =
            background.computeLuminance() > foreground.computeLuminance()
            ? background
            : foreground;
        final dim = bright == background ? foreground : background;
        expect(
          (bright.computeLuminance() + 0.05) / (dim.computeLuminance() + 0.05),
          greaterThan(4.5),
        );
        expect(foreground, dark ? token.fontGray1 : token.textColorAnti);
      }
    },
  );
}
