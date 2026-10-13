import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/theme/t_internal_material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  gradientGeometryGoldens();
  strictBoundaryGoldens();
  strictScrollGoldens();
  setUpAll(() async {
    final iconFont = FontLoader('packages/tdesign_flutter_icons/TIcons')
      ..addFont(rootBundle.load('packages/tdesign_flutter_icons/fonts/t.ttf'));
    final flutterBin = File(
      Platform.resolvedExecutable,
    ).parent.parent.parent.parent.parent;
    final robotoFont = FontLoader('Roboto')
      ..addFont(
        File(
          '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
        ).readAsBytes().then(ByteData.sublistView),
      );
    final materialFont = FontLoader('MaterialIcons')
      ..addFont(
        File(
          '${flutterBin.path}/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
        ).readAsBytes().then(ByteData.sublistView),
      );
    await Future.wait([
      iconFont.load(),
      robotoFont.load(),
      materialFont.load(),
    ]);
  });

  testWidgets('implicit Material defaults do not change TDesign visuals', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(760, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const _M3IsolationScene());
    await tester.pump(const Duration(milliseconds: 400));

    await expectLater(
      find.byKey(const Key('m3-isolation-scene')),
      matchesGoldenFile('goldens/m3_isolation_controls.png'),
    );
  });

  testWidgets('custom content retains its theme beside TD visuals', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(760, 420);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RepaintBoundary(
            key: const Key('custom-content-scene'),
            child: ColoredBox(
              color: Colors.white,
              child: Row(
                children: [
                  for (final m3 in [false, true])
                    Expanded(
                      child: Theme(
                        data: ThemeData(
                          useMaterial3: m3,
                          iconTheme: const IconThemeData(
                            color: Colors.green,
                            size: 64,
                          ),
                          textTheme: const TextTheme(
                            bodyMedium: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 28,
                              color: Colors.purple,
                            ),
                          ),
                          extensions: [TThemeData.defaultData()],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              m3 ? 'Material 3' : 'Material 2',
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(TIcons.home),
                                  Builder(
                                    builder: (context) => Text(
                                      'Custom content',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const TIcon(TIcons.home),
                                  const TText('TD built-in style'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));
    await expectLater(
      find.byKey(const Key('custom-content-scene')),
      matchesGoldenFile('goldens/m3_custom_content.png'),
    );
  });
  testWidgets(
    'owned typography and partial state styles resist ambient visuals',
    (tester) async {
      tester.view.physicalSize = const Size(760, 340);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RepaintBoundary(
              key: Key('owned-typography'),
              child: Row(
                children: [
                  Expanded(child: _OwnedTypographyColumn(m3: false)),
                  Expanded(child: _OwnedTypographyColumn(m3: true)),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byKey(const Key('owned-typography')),
        matchesGoldenFile('goldens/m3_owned_typography.png'),
      );
      final gestures = <TestGesture>[];
      for (var i = 0; i < 2; i++) {
        gestures.add(
          await tester.startGesture(
            tester.getCenter(find.byType(TButton).at(i)),
            pointer: i + 1,
          ),
        );
      }
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await expectLater(
        find.byKey(const Key('owned-typography')),
        matchesGoldenFile('goldens/m3_partial_state_pressed.png'),
      );
      for (final gesture in gestures) {
        await gesture.up();
      }
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      await expectLater(
        find.byKey(const Key('owned-typography')),
        matchesGoldenFile('goldens/m3_owned_typography.png'),
      );
    },
  );
}

class _M3IsolationScene extends StatelessWidget {
  const _M3IsolationScene();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: RepaintBoundary(
          key: Key('m3-isolation-scene'),
          child: ColoredBox(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(child: _ControlColumn(useMaterial3: false)),
                VerticalDivider(width: 1),
                Expanded(child: _ControlColumn(useMaterial3: true)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ControlColumn extends StatelessWidget {
  const _ControlColumn({required this.useMaterial3});

  final bool useMaterial3;

  @override
  Widget build(BuildContext context) {
    final token = TThemeData.defaultData();
    return Theme(
      data: ThemeData(useMaterial3: useMaterial3, extensions: [token]),
      child: ColoredBox(
        color: token.bgColorContainer,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                useMaterial3 ? 'Material 3' : 'Material 2',
                style: const TextStyle(fontFamily: 'Roboto', fontSize: 14),
              ),
              const SizedBox(height: 16),
              const TCheckbox(
                value: true,
                title: 'Checkbox',
                onChanged: _checkboxNoop,
              ),
              const TRadioGroup<String>(
                value: 'a',
                onChanged: _radioNoop,
                child: TRadio<String>(value: 'a', title: 'Radio'),
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  TSwitch(value: true, onChanged: _switchNoop),
                  SizedBox(width: 12),
                  TSwitch(value: false, onChanged: _switchNoop),
                ],
              ),
              const SizedBox(height: 20),
              TProgress.linear(value: 0.6),
              const SizedBox(height: 12),
              TProgress.linear(),
              const SizedBox(height: 20),
              const TLoading(text: 'Loading'),
              const SizedBox(height: 12),
              const Row(
                children: [
                  TLink(child: Text('Link'), onPressed: _tapNoop),
                  SizedBox(width: 12),
                  TTag('Tag'),
                  SizedBox(width: 12),
                  TBadge(label: '8'),
                ],
              ),
              const SizedBox(height: 12),
              const Row(
                children: [
                  TLink(
                    colorPreset: TLinkColorPreset.success,
                    onPressed: _tapNoop,
                    child: Text('Success link'),
                  ),
                  SizedBox(width: 12),
                  TTag('Success tag', colorPreset: TTagColorPreset.success),
                ],
              ),
              const SizedBox(height: 16),
              const TRate(value: 3),
              const SizedBox(height: 16),
              const TInput(initialValue: 'Input', hintText: 'Hint'),
              const SizedBox(height: 16),
              const DefaultTabController(
                length: 2,
                child: TTabsBar(
                  tabs: [
                    TTab(text: 'Tab A'),
                    TTab(text: 'Tab B'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Row(
                children: [
                  TIcon(TIcons.check),
                  SizedBox(width: 8),
                  TText('TDesign text'),
                ],
              ),
              const SizedBox(height: 16),
              const TSlider(value: 0.6, onChanged: _sliderNoop),
              const SizedBox(height: 12),
              const TButton(onPressed: _tapNoop, child: Text('Button')),
            ],
          ),
        ),
      ),
    );
  }
}

void _checkboxNoop(bool? value) {}

void _radioNoop(String? value) {}

void _switchNoop(bool value) {}

void _tapNoop() {}

void _sliderNoop(double value) {}

class _OwnedTypographyColumn extends StatelessWidget {
  const _OwnedTypographyColumn({required this.m3});
  final bool m3;
  @override
  Widget build(BuildContext context) {
    final data = ThemeData(
      useMaterial3: m3,
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          fontSize: 80,
          letterSpacing: 18,
          wordSpacing: 9,
          shadows: [Shadow(color: Colors.pink, blurRadius: 3)],
        ),
      ),
      elevatedButtonTheme: const ElevatedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(Colors.green),
        ),
      ),
      extensions: [TThemeData.defaultData()],
    );
    return Theme(
      data: data,
      child: Material(
        color: Colors.white,
        textStyle: data.textTheme.bodyMedium,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                m3 ? 'Material 3' : 'Material 2',
                style: const TextStyle(
                  inherit: false,
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  height: 1.4,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              const TCell(title: Text('Cell title'), required: true),
              const TDivider(child: Text('Divider label')),
              const SizedBox(height: 12),
              TButton(
                onPressed: _tapNoop,
                variant: TButtonVariant.outline,
                colorPreset: TButtonColorPreset.danger,
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.resolveWith(
                    (states) => states.contains(WidgetState.pressed)
                        ? Colors.pink
                        : null,
                  ),
                  overlayColor: WidgetStateProperty.resolveWith(
                    (states) => states.contains(WidgetState.pressed)
                        ? Colors.transparent
                        : null,
                  ),
                ),
                child: const Text('Danger'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void gradientGeometryGoldens() {
  for (final brightness in Brightness.values) {
    testWidgets(
      'gradient geometry ${brightness.name} default and pressed golden',
      (tester) async {
        tester.view.physicalSize = const Size(760, 720);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final token = brightness == Brightness.dark
            ? TThemeData.defaultData().dark!
            : TThemeData.defaultData().light;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RepaintBoundary(
                key: const Key('button-geometry-scene'),
                child: ColoredBox(
                  color: token.bgColorPage,
                  child: Row(
                    children: [
                      for (var i = 0; i < 4; i++)
                        Expanded(
                          child: _ButtonGeometryColumn(
                            column: i,
                            m3: i >= 2,
                            gradient: i.isOdd,
                            brightness: brightness,
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
        await expectLater(
          find.byKey(const Key('button-geometry-scene')),
          matchesGoldenFile(
            'goldens/button_gradient_geometry_${brightness.name}.png',
          ),
        );
        final gestures = <TestGesture>[];
        for (var i = 0; i < 4; i++) {
          gestures.add(
            await tester.startGesture(
              tester.getCenter(find.byKey(ValueKey('geometry-state-$i'))),
              pointer: i + 1,
            ),
          );
        }
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        await expectLater(
          find.byKey(const Key('button-geometry-scene')),
          matchesGoldenFile(
            'goldens/button_gradient_geometry_pressed_${brightness.name}.png',
          ),
        );
        for (final gesture in gestures) {
          await gesture.up();
        }
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await expectLater(
          find.byKey(const Key('button-geometry-scene')),
          matchesGoldenFile(
            'goldens/button_gradient_geometry_${brightness.name}.png',
          ),
        );
      },
    );
  }
}

class _ButtonGeometryColumn extends StatelessWidget {
  const _ButtonGeometryColumn({
    required this.column,
    required this.m3,
    required this.gradient,
    required this.brightness,
  });
  final int column;
  final bool m3;
  final bool gradient;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final token = brightness == Brightness.dark
        ? TThemeData.defaultData().dark!
        : TThemeData.defaultData().light;
    final data = ThemeData(
      useMaterial3: m3,
      brightness: brightness,
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 24,
          height: 1.4,
          color: Colors.purple,
        ),
      ),
      extensions: [
        token,
        if (gradient)
          TButtonThemeData(
            gradient: LinearGradient(
              colors: [token.bgColorContainer, token.bgColorContainer],
            ),
          ),
      ],
    );
    return Theme(
      data: data,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'M${m3 ? 3 : 2} ${gradient ? 'gradient' : 'ordinary'}',
            style: TextStyle(
              inherit: false,
              fontFamily: 'Roboto',
              fontSize: 14,
              height: 1.4,
              color: token.textColorPrimary,
            ),
          ),
          const SizedBox(height: 8),
          for (final size in TButtonSize.values)
            SizedBox(
              height: 60,
              child: Center(
                child: TButton(
                  size: size,
                  variant: TButtonVariant.outline,
                  colorPreset: TButtonColorPreset.danger,
                  onPressed: _tapNoop,
                  child: Text(size.name),
                ),
              ),
            ),
          const SizedBox(
            height: 48,
            child: Center(
              child: TButton(
                size: TButtonSize.extraSmall,
                shape: TButtonShape.circle,
                variant: TButtonVariant.outline,
                colorPreset: TButtonColorPreset.danger,
                onPressed: _tapNoop,
                icon: TIcon(TIcons.home),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
            child: Center(
              child: TButton(
                variant: TButtonVariant.outline,
                onPressed: _tapNoop,
                style: ButtonStyle(
                  minimumSize: WidgetStatePropertyAll(Size.zero),
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.fromLTRB(10, 3, 14, 5),
                  ),
                  side: WidgetStatePropertyAll(
                    BorderSide(color: Color(0x66000000), width: 4),
                  ),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder()),
                ),
                child: SizedBox(
                  width: 24,
                  height: 12,
                  child: ColoredBox(color: Colors.amber),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 64,
            child: Center(
              child: TButton(
                variant: TButtonVariant.outline,
                onPressed: _tapNoop,
                style: ButtonStyle(
                  minimumSize: WidgetStatePropertyAll(Size.zero),
                  fixedSize: WidgetStatePropertyAll(Size(120, 44)),
                  padding: WidgetStatePropertyAll(EdgeInsets.zero),
                  side: WidgetStatePropertyAll(
                    BorderSide(
                      color: Color(0x66000000),
                      width: 4,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                  ),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder()),
                ),
                child: SizedBox.expand(child: ColoredBox(color: Colors.amber)),
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: Center(
              child: TButton(
                key: ValueKey('geometry-state-$column'),
                size: TButtonSize.extraSmall,
                variant: TButtonVariant.outline,
                onPressed: _tapNoop,
                child: const Text('Press'),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    token.bgColorContainer,
                  ),
                  overlayColor: const WidgetStatePropertyAll(
                    Colors.transparent,
                  ),
                  side: WidgetStateProperty.resolveWith(
                    (states) => BorderSide(
                      color: const Color(0x996a1b9a),
                      width: states.contains(WidgetState.pressed) ? 6 : 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 64,
            child: Center(
              child: TButton(
                variant: TButtonVariant.outline,
                onPressed: _tapNoop,
                child: Builder(
                  builder: (context) => Text(
                    'Custom',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void strictBoundaryGoldens() {
  for (final dark in [false, true]) {
    for (final m3 in [false, true]) {
      for (final menu in [false, true]) {
        testWidgets(
          'strict TD ${menu ? 'selection menu' : 'tooltip and tile'} dark=$dark M3=$m3',
          (tester) async {
            tester.view.physicalSize = const Size(760, 420);
            tester.view.devicePixelRatio = 1;
            addTearDown(tester.view.resetPhysicalSize);
            addTearDown(tester.view.resetDevicePixelRatio);
            final token = dark
                ? TThemeData.defaultData().dark!
                : TThemeData.defaultData();
            await tester.pumpWidget(
              MaterialApp(
                theme: ThemeData(
                  brightness: dark ? Brightness.dark : Brightness.light,
                  useMaterial3: m3,
                  platform: TargetPlatform.android,
                  extensions: [token],
                  tooltipTheme: const TooltipThemeData(
                    triggerMode: TooltipTriggerMode.tap,
                    excludeFromSemantics: true,
                    decoration: BoxDecoration(color: Colors.pink),
                    textStyle: TextStyle(fontSize: 80),
                  ),
                  textSelectionTheme: const TextSelectionThemeData(
                    selectionColor: Colors.pink,
                    selectionHandleColor: Colors.green,
                  ),
                  textButtonTheme: const TextButtonThemeData(
                    style: ButtonStyle(elevation: WidgetStatePropertyAll(9)),
                  ),
                  iconTheme: const IconThemeData(color: Colors.green, size: 28),
                ),
                home: Scaffold(
                  backgroundColor: token.bgColorContainer,
                  body: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const TInput(
                          initialValue: 'Select and copy TD text',
                          prefix: Icon(Icons.home),
                        ),
                        const SizedBox(height: 24),
                        const TInternalListTile(
                          leading: SizedBox(
                            width: 20,
                            height: 20,
                            child: ColoredBox(color: Colors.blue),
                          ),
                          title: SizedBox(
                            height: 100,
                            child: Center(
                              child: TText('Tall title keeps centered leading'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        TInternalTooltip(
                          message: 'TD hint keeps native tooltip ability',
                          child: SizedBox(
                            key: const Key('strict-tip'),
                            width: 180,
                            height: 40,
                            child: Center(
                              child: TText(
                                'Long press for hint',
                                style: TextStyle(color: token.brandColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle();
            if (menu) {
              final state = tester.state<EditableTextState>(
                find.byType(EditableText),
              );
              state.widget.focusNode.requestFocus();
              await tester.pumpAndSettle();
              state.widget.controller.selection = const TextSelection(
                baseOffset: 0,
                extentOffset: 6,
              );
              await tester.pump();
              state.showToolbar();
              await tester.pumpAndSettle();
            } else {
              await tester.longPress(find.byKey(const Key('strict-tip')));
              await tester.pump(const Duration(milliseconds: 300));
            }
            // Both external M2/M3 modes must match the same owned rendering baseline.
            await expectLater(
              find.byType(Overlay).first,
              matchesGoldenFile(
                'goldens/strict_${menu ? 'selection' : 'tooltip'}_${dark ? 'dark' : 'light'}.png',
              ),
            );
            await tester.pumpWidget(const SizedBox.shrink());
            await tester.pumpAndSettle();
          },
        );
      }
    }
  }
}

void strictScrollGoldens() {
  for (final dark in [false, true]) {
    for (final m3 in [false, true]) {
      testWidgets('strict TD desktop scrollbar dark=$dark M3=$m3', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(400, 300);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final token = dark
            ? TThemeData.defaultData().dark!
            : TThemeData.defaultData();
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              useMaterial3: m3,
              brightness: dark ? Brightness.dark : Brightness.light,
              platform: TargetPlatform.windows,
              extensions: [token],
              scrollbarTheme: const ScrollbarThemeData(
                thickness: WidgetStatePropertyAll(29),
                thumbColor: WidgetStatePropertyAll(Colors.pink),
                interactive: false,
              ),
            ),
            home: Scaffold(
              backgroundColor: token.bgColorContainer,
              body: Center(
                child: TSideBar(
                  value: 0,
                  width: 103,
                  height: 180,
                  onChanged: (_) {},
                  children: List.generate(
                    12,
                    (i) => TSideBarItem(value: i, label: 'Item $i'),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        tester
            .state<ScrollableState>(find.byType(Scrollable).first)
            .position
            .jumpTo(100);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 150));
        await expectLater(
          find.byType(Scaffold),
          matchesGoldenFile(
            'goldens/strict_scroll_${dark ? 'dark' : 'light'}.png',
          ),
        );
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();
      });
    }
  }
}
