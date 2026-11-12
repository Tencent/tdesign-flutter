import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../helpers/text_layout_assertions.dart';

void main() {
  const label = 'AAAAAAAAAA';
  for (final gradient in [false, true]) {
    for (final dark in [false, true]) {
      for (final scale in [1.0, 2.0]) {
        testWidgets(
          'narrow button grows gradient=$gradient dark=$dark scale=$scale',
          (tester) async {
            await tester.pumpWidget(
              textLayoutApp(
                SizedBox(
                  width: 190,
                  child: TButton(
                    onPressed: () {},
                    child: const TText(
                      label,
                      style: TextStyle(fontFamily: 'Ahem'),
                    ),
                  ),
                ),
                dark: dark,
                gradient: gradient,
                scale: scale,
              ),
            );
            final paragraph = expectTextFits(
              tester,
              label,
              container: find.byType(TButton),
            );
            expect(paragraph.text.style!.fontSize, 16);
            expect(paragraph.text.style!.fontWeight, FontWeight.w600);
            expect(
              tester.getSize(find.byType(TButton)).height,
              greaterThan(40),
            );
            expect(tester.takeException(), isNull);
          },
        );
        testWidgets(
          'fixed button ellipsis and explicit color gradient=$gradient dark=$dark scale=$scale',
          (tester) async {
            var taps = 0;
            final height = scale == 1 ? 40.0 : 64.0;
            await tester.pumpWidget(
              textLayoutApp(
                TButton(
                  onPressed: () => taps++,
                  style: ButtonStyle(
                    fixedSize: WidgetStatePropertyAll(Size(190, height)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add, size: 20),
                      SizedBox(width: 4),
                      Expanded(
                        child: TText(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Ahem',
                            color: Colors.pink,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                dark: dark,
                gradient: gradient,
                scale: scale,
              ),
            );
            final paragraph = expectTextFits(
              tester,
              label,
              container: find.byType(TButton),
              ellipsized: true,
            );
            expect(paragraph.text.style!.color, Colors.pink);
            expect(tester.getSize(find.byType(TButton)).height, height);
            await tester.tap(find.byType(TButton));
            expect(taps, 1);
            expect(tester.takeException(), isNull);
          },
        );
      }
    }
  }
}
