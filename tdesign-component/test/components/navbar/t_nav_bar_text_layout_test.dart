import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../helpers/text_layout_assertions.dart';

void main() {
  const label = 'AAAAAAAAAA';
  for (final dark in [false, true]) {
    for (final scale in [1.0, 2.0]) {
      for (final composite in [false, true]) {
        testWidgets(
          'narrow navbar ellipsis dark=$dark scale=$scale composite=$composite',
          (tester) async {
            var backs = 0;
            var actions = 0;
            const text = TText(label, style: TextStyle(fontFamily: 'Ahem'));
            await tester.pumpWidget(
              textLayoutApp(
                SizedBox(
                  width: composite ? 250 : 150,
                  child: TNavBar(
                    height: scale == 1 ? 48 : 72,
                    useDefaultBack: true,
                    onBack: () => backs++,
                    actions: [
                      TNavBarItem(
                        icon: TIcons.ellipsis,
                        onTap: () => actions++,
                      ),
                    ],
                    title: composite
                        ? const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(child: text),
                              Icon(Icons.add, size: 24),
                            ],
                          )
                        : text,
                  ),
                ),
                dark: dark,
                scale: scale,
              ),
            );
            final paragraph = expectTextFits(
              tester,
              label,
              container: find.byType(TNavBar),
              ellipsized: true,
            );
            expect(paragraph.text.style!.fontSize, 18);
            expect(paragraph.text.style!.fontWeight, FontWeight.w600);
            expect(paragraph.maxLines, 1);
            expect(paragraph.overflow, TextOverflow.ellipsis);
            final titleRect = tester.getRect(
              find.descendant(
                of: find.text(label),
                matching: find.byType(RichText),
              ),
            );
            expect(
              titleRect.left,
              greaterThanOrEqualTo(
                tester.getRect(find.byIcon(TIcons.chevron_left)).right,
              ),
            );
            expect(
              titleRect.right,
              lessThanOrEqualTo(
                tester.getRect(find.byIcon(TIcons.ellipsis)).left,
              ),
            );
            await tester.tap(find.byIcon(TIcons.chevron_left));
            await tester.tap(find.byIcon(TIcons.ellipsis));
            expect(backs, 1);
            expect(actions, 1);
            expect(tester.takeException(), isNull);
          },
        );
      }
      testWidgets(
        'navbar explicit subtitle and adequate height dark=$dark scale=$scale',
        (tester) async {
          await tester.pumpWidget(
            textLayoutApp(
              const SizedBox(
                width: 300,
                child: TNavBar(
                  height: 96,
                  title: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TText('Title', style: TextStyle(fontFamily: 'Ahem')),
                      TText(
                        'Subtitle',
                        style: TextStyle(
                          fontFamily: 'Ahem',
                          fontSize: 12,
                          height: 1.5,
                          color: Colors.pink,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              dark: dark,
              scale: scale,
            ),
          );
          expectTextFits(tester, 'Title', container: find.byType(TNavBar));
          final subtitle = expectTextFits(
            tester,
            'Subtitle',
            container: find.byType(TNavBar),
          );
          expect(subtitle.text.style!.fontSize, 12);
          expect(subtitle.text.style!.color, Colors.pink);
          expect(subtitle.text.style!.fontWeight, FontWeight.w400);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
