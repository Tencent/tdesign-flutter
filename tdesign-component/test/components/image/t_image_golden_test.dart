import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  setUpAll(() async {
    final flutterBin =
        File(Platform.resolvedExecutable).parent.parent.parent.parent.parent;
    final robotoFile = File(
      '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
    );
    final robotoFont = FontLoader('Roboto')
      ..addFont(robotoFile.readAsBytes().then(ByteData.sublistView));
    final materialIconsFile = File(
      '${flutterBin.path}/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
    );
    final materialIconsFont = FontLoader('MaterialIcons')
      ..addFont(materialIconsFile.readAsBytes().then(ByteData.sublistView));
    await Future.wait([robotoFont.load(), materialIconsFont.load()]);
  });

  for (final brightness in Brightness.values) {
    testWidgets('Image states ${brightness.name}', (tester) async {
      tester.view.physicalSize = const Size(420, 180);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_ImageStateScene(brightness: brightness));
      await tester.pump();

      await expectLater(
        find.byKey(const Key('image-state-scene')),
        matchesGoldenFile('goldens/t_image_states_${brightness.name}.png'),
      );
    });
  }
}

class _ImageStateScene extends StatelessWidget {
  const _ImageStateScene({required this.brightness});

  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final token = TThemeData.defaultData();
    final baseTheme = brightness == Brightness.light
        ? TThemeBuilder.light(token)
        : TThemeBuilder.dark(token);
    final theme = baseTheme.copyWith(
      textTheme: baseTheme.textTheme.apply(fontFamily: 'Roboto'),
    );

    return MaterialApp(
      theme: theme,
      home: Scaffold(
        body: Center(
          child: RepaintBoundary(
            key: const Key('image-state-scene'),
            child: ColoredBox(
              color: theme.colorScheme.surface,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ImageState(label: 'Loading', image: TImage(src: '')),
                    SizedBox(width: 16),
                    _ImageState(
                      label: 'Custom',
                      image: TImage(
                        src: '',
                        loadingWidget: Icon(Icons.sync, size: 22),
                      ),
                    ),
                    SizedBox(width: 16),
                    _ImageState(
                      label: 'Failed',
                      image: TImage(src: 'missing-image.png'),
                    ),
                    SizedBox(width: 16),
                    _ImageState(
                      label: 'Custom',
                      image: TImage(
                        src: 'missing-image.png',
                        errorWidget: Text('Error'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageState extends StatelessWidget {
  const _ImageState({
    required this.label,
    required this.image,
  });

  final String label;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TText(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        image,
      ],
    );
  }
}
