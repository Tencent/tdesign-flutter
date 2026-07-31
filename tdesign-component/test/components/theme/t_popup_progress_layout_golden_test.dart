import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  setUpAll(() async {
    final flutterBin = File(
      Platform.resolvedExecutable,
    ).parent.parent.parent.parent.parent;
    final robotoFont = FontLoader('Roboto')
      ..addFont(
        File(
          '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
        ).readAsBytes().then(ByteData.sublistView),
      );
    await robotoFont.load();
  });

  testWidgets('Popup theme size and Progress unbounded width visual contract', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(420, 360);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final baseTheme = TThemeBuilder.light(TThemeData.defaultData());
    final theme = baseTheme
        .copyWith(
          textTheme: baseTheme.textTheme.apply(fontFamily: 'Roboto'),
          primaryTextTheme: baseTheme.primaryTextTheme.apply(
            fontFamily: 'Roboto',
          ),
        )
        .mergeExtension(const TPopupThemeData(edgeHeight: 220))
        .mergeExtension(
          const TProgressThemeData(
            color: Color(0xFF0052D9),
            backgroundColor: Color(0xFFE7E7E7),
            fallbackLinearWidth: 180,
            showLabel: false,
          ),
        );
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        builder: (context, child) => RepaintBoundary(
          key: const Key('popup-progress-layout-scene'),
          child: child!,
        ),
        home: const _PopupProgressLayoutScene(),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byKey(const Key('popup-progress-layout-scene')),
      matchesGoldenFile('goldens/popup_progress_layout.png'),
    );
  });
}

class _PopupProgressLayoutScene extends StatefulWidget {
  const _PopupProgressLayoutScene();

  @override
  State<_PopupProgressLayoutScene> createState() =>
      _PopupProgressLayoutSceneState();
}

class _PopupProgressLayoutSceneState extends State<_PopupProgressLayoutScene> {
  bool _opened = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_opened) {
      return;
    }
    _opened = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      TPopup.show(
        context,
        options: TPopupOptions.bottom(
          headerBuilder: null,
          child: const _ProgressMatrix(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF3F3F3),
      body: Center(
        child: Text(
          'Viewport',
          style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
        ),
      ),
    );
  }
}

class _ProgressMatrix extends StatelessWidget {
  const _ProgressMatrix();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.tTheme.bgColorContainer,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bounded',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Roboto',
                fontSize: 14,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 12),
            TProgress(variant: TProgressVariant.linear, value: 0.6),
            const SizedBox(height: 24),
            const Text(
              'Unbounded fallback',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Roboto',
                fontSize: 14,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: TProgress(variant: TProgressVariant.linear, value: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}
