import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  setUpAll(() async {
    final cjkFont = FontLoader('TDesign Alignment CJK')
      ..addFont(
        File(
          'example/test/fonts/TDesignAlignmentCJK-Regular.otf',
        ).readAsBytes().then(ByteData.sublistView),
      );
    await cjkFont.load();
  });

  for (final brightness in Brightness.values) {
    testWidgets('SwipeCell action text ${brightness.name}', (tester) async {
      tester.view.physicalSize = const Size(375, 120);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final token = TThemeData.defaultData();
      final baseTheme = brightness == Brightness.light
          ? TThemeBuilder.light(token)
          : TThemeBuilder.dark(token);
      final theme = baseTheme.copyWith(
        textTheme: baseTheme.textTheme.apply(
          fontFamilyFallback: const ['TDesign Alignment CJK'],
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: Center(
              child: RepaintBoundary(
                key: const Key('swipe-cell-actions'),
                child: SizedBox(
                  width: 343,
                  height: 64,
                  child: DefaultTextStyle(
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    child: TSwipeCell(
                      initialOpenSide: TSwipeCellSide.end,
                      end: TSwipeCellPanel(
                        children: const [
                          TSwipeCellAction(
                            label: '收藏',
                            backgroundColor: Color(0xFF0052D9),
                          ),
                          TSwipeCellAction(
                            label: '编辑',
                            backgroundColor: Color(0xFFED7B2F),
                          ),
                          TSwipeCellAction(
                            label: '删除',
                            backgroundColor: Color(0xFFD54941),
                          ),
                        ],
                      ),
                      child: const TCell(title: Text('左滑多操作')),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byKey(const Key('swipe-cell-actions')),
        matchesGoldenFile(
          'goldens/t_swipe_cell_actions_${brightness.name}.png',
        ),
      );
    }, tags: 'golden');
  }
}
