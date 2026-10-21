import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../helpers/text_layout_assertions.dart';

String _label(int index) => index == 1 ? 'OK' : 'ActionAAAAAAAAAA$index';

void main() {
  testWidgets(
    'text footer supports LayoutBuilder and explicit action padding',
    (tester) async {
      await tester.pumpWidget(
        textLayoutApp(
          TDialog(
            title: const TText('Confirm'),
            actions: [
              TDialogAction(
                variant: TButtonVariant.text,
                closeOnPressed: false,
                style: const ButtonStyle(
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    expect(constraints.hasBoundedWidth, isTrue);
                    return const TText(
                      'Custom',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontFamily: 'Ahem'),
                    );
                  },
                ),
              ),
              const TDialogAction(
                variant: TButtonVariant.text,
                child: TText('OK'),
              ),
            ],
          ),
          viewport: const Size(320, 812),
          scale: 2,
        ),
      );
      await tester.pumpAndSettle();
      final button = find.ancestor(
        of: find.text('Custom'),
        matching: find.byType(TButton),
      );
      expectTextFits(tester, 'Custom', container: button, ellipsized: true);
      expect(tester.getSize(button).height, 72);
      final other = find.ancestor(
        of: find.text('OK'),
        matching: find.byType(TButton),
      );
      expect(tester.getSize(other).height, 72);
      expect(tester.takeException(), isNull);
    },
  );
  for (final dark in [false, true]) {
    for (final scale in [1.0, 2.0]) {
      for (final count in [1, 2, 3]) {
        for (final textFooter in [false, true]) {
          for (final multiline in [false, true]) {
            if (textFooter && count > 2) {
              continue;
            }
            testWidgets(
              'dialog narrow actions dark=$dark scale=$scale count=$count text=$textFooter multiline=$multiline',
              (tester) async {
                var taps = 0;
                await tester.pumpWidget(
                  textLayoutApp(
                    SizedBox(
                      width: 288,
                      child: TDialog(
                        title: const TText('Confirm'),
                        actions: List.generate(
                          count,
                          (index) => TDialogAction(
                            variant: textFooter ? TButtonVariant.text : null,
                            role: index == 0
                                ? TDialogActionRole.primary
                                : TDialogActionRole.normal,
                            closeOnPressed: false,
                            onPressed: () => taps++,
                            child: TText(
                              _label(index),
                              maxLines: multiline ? null : 1,
                              overflow: multiline
                                  ? TextOverflow.clip
                                  : TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Ahem',
                                color: Colors.pink,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    viewport: const Size(320, 812),
                    dark: dark,
                    scale: scale,
                  ),
                );
                await tester.pumpAndSettle();
                for (var index = 0; index < count; index++) {
                  final label = _label(index);
                  final button = find.ancestor(
                    of: find.text(label),
                    matching: find.byType(TButton),
                  );
                  final paragraph = expectTextFits(
                    tester,
                    label,
                    container: button,
                    ellipsized: !multiline && index != 1,
                  );
                  expect(paragraph.text.style!.fontSize, 16);
                  expect(paragraph.text.style!.fontWeight, FontWeight.w600);
                  expect(paragraph.text.style!.color, Colors.pink);
                  if (textFooter && !multiline) {
                    expect(tester.getSize(button).height, scale == 1 ? 56 : 64);
                  }
                  if (textFooter) {
                    final first = find.ancestor(
                      of: find.text(_label(0)),
                      matching: find.byType(TButton),
                    );
                    expect(
                      tester.getSize(button).height,
                      tester.getSize(first).height,
                    );
                  }
                  await tester.tap(button);
                }
                expect(taps, count);
                expect(tester.takeException(), isNull);
              },
            );
          }
        }
      }
    }
  }
}
