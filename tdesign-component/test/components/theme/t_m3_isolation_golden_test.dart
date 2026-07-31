import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
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
    await Future.wait([iconFont.load(), robotoFont.load()]);
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
              const TRadio<String>(
                value: 'a',
                groupValue: 'a',
                title: 'Radio',
                onChanged: _radioNoop,
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
              TProgress(variant: TProgressVariant.linear, value: 0.6),
              const SizedBox(height: 12),
              TProgress(variant: TProgressVariant.linear),
              const SizedBox(height: 20),
              const TLoading(size: TLoadingSize.medium, text: 'Loading'),
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
                    colorScheme: TLinkColorScheme.success,
                    onPressed: _tapNoop,
                    child: Text('Success link'),
                  ),
                  SizedBox(width: 12),
                  TTag('Success tag', colorScheme: TTagColorScheme.success),
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
