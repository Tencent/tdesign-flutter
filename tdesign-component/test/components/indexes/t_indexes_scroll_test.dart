import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  setUpAll(() async {
    await (FontLoader('TDesignGoldenCJK')..addFont(
          File(
            'example/test/fonts/TDesignGoldenCJK-Regular.otf',
          ).readAsBytes().then(ByteData.sublistView),
        ))
        .load();
    await (FontLoader('packages/tdesign_flutter/TCloudNumber')..addFont(
          File(
            'assets/tdesign/TCloudNumberVF.ttf',
          ).readAsBytes().then(ByteData.sublistView),
        ))
        .load();
    final flutterBin = File(
      Platform.resolvedExecutable,
    ).parent.parent.parent.parent.parent;
    await (FontLoader('Roboto')..addFont(
          File(
            '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
          ).readAsBytes().then(ByteData.sublistView),
        ))
        .load();
    await (FontLoader('TDesignAlignmentCJK')..addFont(
          File(
            'example/test/fonts/TDesignAlignmentCJK-Regular.otf',
          ).readAsBytes().then(ByteData.sublistView),
        ))
        .load();
  });
  testWidgets(
    'overflowing index strip scrolls without selecting, then tap selects the visible item',
    (tester) async {
      final active = ValueNotifier('A');
      addTearDown(active.dispose);
      var callbacks = 0;
      Widget page({
        double scale = 3,
        int count = 26,
        double height = 250,
        TIndexesThemeData? theme,
      }) => MaterialApp(
        theme: ThemeData(
          extensions: [TThemeData.defaultData(), if (theme != null) theme],
        ),
        home: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(scale)),
          child: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                height: height,
                child: Stack(
                  children: [
                    TIndexesList(
                      indexList: List.generate(
                        count,
                        (i) => String.fromCharCode(65 + i),
                      ),
                      activeIndex: active,
                      onSelect: (_, __) => callbacks++,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpWidget(page());
      await tester.pumpAndSettle();
      final scroller = find.byType(SingleChildScrollView);
      expect(scroller, findsOneWidget);
      final controller = tester
          .widget<SingleChildScrollView>(scroller)
          .controller!;
      await tester.drag(scroller, const Offset(0, -130));
      await tester.pumpAndSettle();
      expect(controller.offset, greaterThan(0));
      expect(callbacks, 0);
      expect(active.value, 'A');
      final visible = find.byType(Text).evaluate().where((e) {
        final box = e.renderObject! as RenderBox;
        final y = box.localToGlobal(box.size.center(Offset.zero)).dy;
        final view = tester.getRect(scroller);
        return y > view.top + 30 && y < view.bottom - 30;
      }).first;
      final letter = (visible.widget as Text).data!;
      await tester.tap(find.byWidget(visible.widget));
      await tester.pump();
      expect(active.value, letter);
      expect(callbacks, 1);
      active.value = 'Z';
      await tester.pumpAndSettle();
      expect(controller.offset, greaterThan(130));
      await tester.pumpWidget(page(scale: 3, height: 180));
      await tester.pumpAndSettle();
      final viewport = tester.getRect(scroller);
      final activeRect = tester.getRect(find.text('Z'));
      expect(activeRect.top, greaterThanOrEqualTo(viewport.top));
      expect(activeRect.bottom, lessThanOrEqualTo(viewport.bottom + .01));
      expect(callbacks, 1);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(page(scale: 1, count: 2));
      await tester.pumpAndSettle();
      expect(find.byType(SingleChildScrollView), findsNothing);
      await tester.tap(find.text('B'));
      await tester.pumpAndSettle();
      expect(active.value, 'B');
      expect(callbacks, 2);
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('A').last),
      );
      await gesture.moveTo(tester.getCenter(find.text('B').last));
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.text('A').last));
      await gesture.up();
      await tester.pumpAndSettle();
      expect(active.value, 'A');
      expect(callbacks, greaterThan(2));
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'index strip preserves explicit TD slots and custom content theme',
    (tester) async {
      final active = ValueNotifier('A');
      addTearDown(active.dispose);
      final font = Font(size: 18, lineHeight: 24);
      Widget page({bool custom = false}) => MaterialApp(
        theme: ThemeData(
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.purple),
          ),
          extensions: [
            TThemeData.defaultData(),
            TIndexesThemeData(
              indexItemSize: 20,
              tipSize: 40,
              indexFont: font,
              activeIndexFont: font,
              indexColor: Colors.orange,
            ),
          ],
        ),
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(3)),
          child: Scaffold(
            body: SizedBox(
              height: 200,
              child: Stack(
                children: [
                  TIndexesList(
                    indexList: const ['A', 'B'],
                    activeIndex: active,
                    onSelect: (_, __) {},
                    builderIndex: custom
                        ? (context, index, _) => Text(
                            'custom $index',
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpWidget(page());
      await tester.pumpAndSettle();
      final text = tester.widget<Text>(find.text('B'));
      expect(text.style!.fontSize, 18);
      expect(text.style!.color, Colors.orange);
      final slot = find
          .ancestor(
            of: find.text('B'),
            matching: find.byWidgetPredicate(
              (w) => w is Container && w.constraints?.maxHeight == 20,
            ),
          )
          .first;
      expect(tester.getSize(slot).height, 20);
      expect(find.byType(SingleChildScrollView), findsNothing);
      await tester.pumpWidget(page(custom: true));
      await tester.pumpAndSettle();
      expect(
        tester.widget<Text>(find.text('custom A')).style!.color,
        Colors.purple,
      );
      final customSlot = find
          .ancestor(
            of: find.text('custom A'),
            matching: find.byWidgetPredicate(
              (w) => w is SizedBox && w.height == 20,
            ),
          )
          .first;
      expect(tester.getSize(customSlot).height, 20);
      expect(tester.takeException(), isNull);
    },
  );
}
