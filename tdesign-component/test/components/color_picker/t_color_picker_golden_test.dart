import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TColorPicker 视觉回归：覆盖 multiple 类型完整形态在 light / dark 两种
/// 主题下的关键区块（色板 / 滑块 / 分段格式区 / 系统预设色板）。
///
/// 字体加载与固定 viewport 写法对齐 `test/components/upload/t_upload_golden_test.dart`。
void main() {
  setUpAll(() async {
    final iconFont = FontLoader('packages/tdesign_flutter_icons/TIcons')
      ..addFont(rootBundle.load('packages/tdesign_flutter_icons/fonts/t.ttf'));
    final flutterBin = File(
      Platform.resolvedExecutable,
    ).parent.parent.parent.parent.parent;
    final robotoFile = File(
      '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
    );
    final robotoFont = FontLoader('Roboto')
      ..addFont(robotoFile.readAsBytes().then(ByteData.sublistView));
    await Future.wait([iconFont.load(), robotoFont.load()]);
  });

  for (final brightness in Brightness.values) {
    testWidgets('ColorPicker multiple type ${brightness.name}', (tester) async {
      tester.view.physicalSize = const Size(720, 720);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_ColorPickerScene(brightness: brightness));
      await expectLater(
        find.byKey(const Key('color-picker-golden-scene')),
        matchesGoldenFile(
          'goldens/t_color_picker_multiple_${brightness.name}.png',
        ),
      );
    });
  }
}

class _ColorPickerScene extends StatelessWidget {
  const _ColorPickerScene({required this.brightness});

  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final token = TThemeData.defaultData();
    final baseTheme = brightness == Brightness.light
        ? TThemeBuilder.light(token)
        : TThemeBuilder.dark(token);
    // 固定字体，规避不同宿主缺字导致的字形差异。
    final theme = baseTheme.copyWith(
      textTheme: baseTheme.textTheme.apply(fontFamily: 'Roboto'),
      primaryTextTheme: baseTheme.primaryTextTheme.apply(fontFamily: 'Roboto'),
    );

    return MaterialApp(
      theme: theme,
      home: Scaffold(
        body: Center(
          child: RepaintBoundary(
            key: const Key('color-picker-golden-scene'),
            child: Container(
              color: brightness == Brightness.light
                  ? Colors.white
                  : const Color(0xFF181818),
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: 360,
                child: TColorPicker(
                  value: '#0052D9',
                  type: TColorPickerType.multiple,
                  enableAlpha: true,
                  clearable: true,
                  onChanged: (value, change) {},
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
