import 'dart:async';
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

  for (final scene in _PopupConsumerScene.values) {
    testWidgets('${scene.name} keeps the shared Popup visual contract', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 640);
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
          .mergeExtension(
            const TPopupThemeData(edgeHeight: 260, drawerWidth: 280),
          )
          .mergeExtension(
            const TTextThemeData(textStyle: TextStyle(fontFamily: 'Roboto')),
          );
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          builder: (context, child) => RepaintBoundary(
            key: const Key('popup-consumer-scene'),
            child: child!,
          ),
          home: _PopupConsumerHost(scene: scene),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byKey(const Key('popup-consumer-scene')),
        matchesGoldenFile('goldens/popup_consumer_${scene.name}.png'),
      );
    });
  }
}

enum _PopupConsumerScene { actionSheet, dialog, drawer }

class _PopupConsumerHost extends StatefulWidget {
  const _PopupConsumerHost({required this.scene});

  final _PopupConsumerScene scene;

  @override
  State<_PopupConsumerHost> createState() => _PopupConsumerHostState();
}

class _PopupConsumerHostState extends State<_PopupConsumerHost> {
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
      switch (widget.scene) {
        case _PopupConsumerScene.actionSheet:
          TActionSheet.showList(
            context,
            subtitle: 'Choose an action',
            cancelText: 'Cancel',
            items: const [
              TActionSheetItem(value: 'camera', label: 'Take photo'),
              TActionSheetItem(
                value: 'album',
                label: 'Choose from album',
                subtitle: 'JPG and PNG',
              ),
            ],
          );
          break;
        case _PopupConsumerScene.dialog:
          unawaited(
            TDialog.show<void>(
              context,
              dialog: const TDialog(
                title: TText('Confirm submission'),
                content: TText('Continue to the next step after submission.'),
                actions: [
                  TDialogAction(child: Text('Cancel')),
                  TDialogAction(
                    child: Text('Confirm'),
                    role: TDialogActionRole.primary,
                  ),
                ],
              ),
            ),
          );
          break;
        case _PopupConsumerScene.drawer:
          TDrawer(
            context,
            placement: TDrawerPlacement.right,
            title: const Text('Menu'),
            items: [
              const TDrawerItem(title: 'Home'),
              const TDrawerItem(title: 'Settings'),
              const TDrawerItem(title: 'Help'),
            ],
          ).show();
          break;
      }
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
