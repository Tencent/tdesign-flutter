import 'dart:convert';
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
    final robotoFile = File(
      '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
    );
    final robotoFont = FontLoader('Roboto')
      ..addFont(robotoFile.readAsBytes().then(ByteData.sublistView));
    await Future.wait([iconFont.load(), robotoFont.load()]);
  });

  for (final brightness in Brightness.values) {
    testWidgets('Upload enabled and disabled ${brightness.name}', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(720, 760);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_UploadStateScene(brightness: brightness));

      await expectLater(
        find.byKey(const Key('upload-state-scene')),
        matchesGoldenFile('goldens/t_upload_states_${brightness.name}.png'),
      );
    });
  }
}

class _UploadStateScene extends StatelessWidget {
  const _UploadStateScene({required this.brightness});

  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final token = TThemeData.defaultData();
    final baseTheme = brightness == Brightness.light
        ? TThemeBuilder.light(token)
        : TThemeBuilder.dark(token);
    final theme = baseTheme.copyWith(
      textTheme: baseTheme.textTheme.apply(fontFamily: 'Roboto'),
      primaryTextTheme: baseTheme.primaryTextTheme.apply(fontFamily: 'Roboto'),
    );

    return MaterialApp(
      theme: theme,
      home: Scaffold(
        body: Center(
          child: RepaintBoundary(
            key: const Key('upload-state-scene'),
            child: ColoredBox(
              color: theme.colorScheme.surface,
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _UploadState(
                      label: 'Grid states',
                      layout: TUploadLayout.grid,
                    ),
                    SizedBox(height: 24),
                    _UploadState(
                      label: 'List states',
                      layout: TUploadLayout.list,
                    ),
                    SizedBox(height: 24),
                    _DisabledUploadState(),
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

class _UploadState extends StatelessWidget {
  const _UploadState({required this.label, required this.layout});

  final String label;
  final TUploadLayout layout;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TText(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 10),
        SizedBox(
          width: 640,
          child: TUpload(
            layout: layout,
            files: const [
              TUploadFile(
                id: 'uploading',
                name: 'uploading.png',
                status: TUploadFileStatus.uploading,
                progress: 0.5,
              ),
              TUploadFile(
                id: 'error',
                name: 'error.png',
                status: TUploadFileStatus.error,
                errorText: 'Upload failed',
              ),
              TUploadFile(
                id: 'retry',
                name: 'retry.png',
                status: TUploadFileStatus.retryableError,
                errorText: 'Retry',
              ),
              TUploadFile(
                id: 'success',
                name: 'success.png',
                status: TUploadFileStatus.success,
                size: 2048,
              ),
            ],
            maxFiles: 4,
            onChanged: _ignore,
            onFileTap: _ignoreFile,
          ),
        ),
      ],
    );
  }
}

class _DisabledUploadState extends StatelessWidget {
  const _DisabledUploadState();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TText(
          'Disabled existing image',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 80,
          child: TUpload(
            files: [
              TUploadFile(
                id: 'disabled',
                name: 'disabled.png',
                status: TUploadFileStatus.success,
                bytes: base64Decode(
                  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
                ),
              ),
            ],
            onChanged: null,
          ),
        ),
      ],
    );
  }
}

void _ignore(List<TUploadFile> value) {}

void _ignoreFile(TUploadFile value) {}
