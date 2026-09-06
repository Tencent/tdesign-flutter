import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child, {TSkeletonThemeData? skeletonTheme}) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [
          TThemeData.defaultData(),
          if (skeletonTheme != null) skeletonTheme,
        ],
      ),
      home: Scaffold(body: child),
    );
  }

  List<BoxDecoration> decorations(WidgetTester tester) => tester
      .widgetList<Container>(find.byType(Container))
      .map((container) => container.decoration)
      .whereType<BoxDecoration>()
      .toList();

  group('TSkeleton preset layouts', () {
    testWidgets('renders every preset with its expected block count', (
      tester,
    ) async {
      final expectedBlocks = {
        TSkeletonVariant.avatar: 1,
        TSkeletonVariant.image: 1,
        TSkeletonVariant.text: 3,
        TSkeletonVariant.paragraph: 4,
      };

      for (final entry in expectedBlocks.entries) {
        await tester.pumpWidget(
          wrap(SizedBox(width: 320, child: TSkeleton(variant: entry.key))),
        );
        expect(
          decorations(
            tester,
          ).where((decoration) => decoration.color != Colors.transparent),
          hasLength(entry.value),
        );
      }
    });

    testWidgets('text keeps its row proportions and token row spacing', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const SizedBox(width: 320, child: TSkeleton()),
          skeletonTheme: const TSkeletonThemeData(blockColor: Colors.red),
        ),
      );

      final blocks = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration! as BoxDecoration).color == Colors.red,
      );
      expect(blocks, findsNWidgets(3));
      final first = tester.getRect(blocks.at(0));
      final second = tester.getRect(blocks.at(1));
      final third = tester.getRect(blocks.at(2));
      expect(first.width, closeTo(72.96, 0.01));
      expect(second.width, closeTo(231.04, 0.01));
      expect(second.left - first.right, 16);
      expect(third.top - first.top, 24);
    });

    testWidgets('image uses 72dp geometry and the default radius token', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const TSkeleton(variant: TSkeletonVariant.image)),
      );

      final block = find.byWidgetPredicate(
        (widget) => widget is Container && widget.decoration is BoxDecoration,
      );
      expect(tester.getSize(block), const Size(72, 72));
      expect(
        tester.widget<Container>(block).decoration,
        isA<BoxDecoration>().having(
          (decoration) => decoration.borderRadius,
          'borderRadius',
          BorderRadius.circular(6),
        ),
      );
    });
  });

  group('TSkeleton custom layout', () {
    test('default block has line defaults', () {
      const block = TSkeletonBlock();
      expect(block.height, 16);
      expect(block.flex, 1);
      expect(block.isSpacer, isFalse);
      expect(block.style.shape, TSkeletonBlockShape.rounded);
    });

    testWidgets(
      'renders fixed, flex and spacer blocks without parent Flexible',
      (tester) async {
        await tester.pumpWidget(
          wrap(
            const SizedBox(
              width: 200,
              child: TSkeleton.custom(
                layout: TSkeletonLayout(
                  rows: [
                    [
                      TSkeletonBlock.rectangle(
                        width: 40,
                        height: 20,
                        flex: null,
                      ),
                      TSkeletonBlock.spacer(width: 8),
                      TSkeletonBlock.line(flex: 1),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.byType(TSkeleton), findsOneWidget);
        expect(tester.takeException(), isNull);
        final blocks = decorations(tester);
        expect(blocks, hasLength(3));
        expect(blocks.first.borderRadius, BorderRadius.zero);
        expect(blocks[1].color, Colors.transparent);
      },
    );

    testWidgets('can be used directly in a Column and a Row', (tester) async {
      await tester.pumpWidget(
        wrap(
          const Column(
            children: [
              TSkeleton(variant: TSkeletonVariant.avatar),
              Row(children: [TSkeleton(variant: TSkeletonVariant.image)]),
            ],
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('single custom block with default flex works in a Row', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const Row(
            children: [
              TSkeleton.custom(
                layout: TSkeletonLayout(
                  rows: [
                    [TSkeletonBlock.rectangle(width: 48, height: 48)],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('TSkeleton styling', () {
    test('theme data copyWith and lerp preserve every visual default', () {
      const base = TSkeletonThemeData(blockColor: Colors.red, borderRadius: 4);
      final copied = base.copyWith(
        highlightColor: Colors.white,
        rowSpacing: 12,
      );
      expect(copied.blockColor, Colors.red);
      expect(copied.highlightColor, Colors.white);
      expect(copied.borderRadius, 4);
      expect(copied.rowSpacing, 12);
      final replaced = base.copyWith(blockColor: Colors.green, borderRadius: 8);
      expect(replaced.blockColor, Colors.green);
      expect(replaced.borderRadius, 8);

      const other = TSkeletonThemeData(
        blockColor: Colors.blue,
        highlightColor: Colors.black,
        borderRadius: 12,
        rowSpacing: 20,
      );
      final middle = copied.lerp(other, .5);
      expect(middle.blockColor, Color.lerp(Colors.red, Colors.blue, .5));
      expect(middle.highlightColor, Color.lerp(Colors.white, Colors.black, .5));
      expect(middle.borderRadius, 8);
      expect(middle.rowSpacing, 16);
      expect(base.lerp(null, .5), same(base));
      final nullNumber = <double?>[null].single;
      final empty = TSkeletonThemeData(
        borderRadius: nullNumber,
        rowSpacing: nullNumber,
      );
      expect(empty.lerp(empty, .5).borderRadius, isNull);
      expect(empty.lerp(other, .25).borderRadius, isNull);
      expect(empty.lerp(other, .75).borderRadius, 12);
      expect(other.lerp(empty, .25).rowSpacing, 20);
      expect(other.lerp(empty, .75).rowSpacing, isNull);
      expect(() => TSkeletonThemeData(borderRadius: -1), throwsAssertionError);
      expect(() => TSkeletonThemeData(rowSpacing: -1), throwsAssertionError);
    });

    testWidgets('resolves block overrides before component theme and token', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const TSkeleton.custom(
            layout: TSkeletonLayout(
              rows: [
                [
                  TSkeletonBlock.line(
                    flex: null,
                    width: 40,
                    style: TSkeletonBlockStyle(
                      color: Colors.blue,
                      borderRadius: 9,
                    ),
                  ),
                  TSkeletonBlock.line(flex: null, width: 40),
                ],
              ],
            ),
          ),
          skeletonTheme: const TSkeletonThemeData(
            blockColor: Colors.red,
            borderRadius: 5,
          ),
        ),
      );

      final blocks = decorations(tester);
      expect(blocks[0].color, Colors.blue);
      expect(blocks[0].borderRadius, BorderRadius.circular(9));
      expect(blocks[1].color, Colors.red);
      expect(blocks[1].borderRadius, BorderRadius.circular(5));
    });

    testWidgets('falls back to TDesign tokens without a Skeleton extension', (
      tester,
    ) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(wrap(const TSkeleton()));
      expect(decorations(tester).first.color, token.bgColorSecondaryContainer);
    });

    testWidgets('row spacing follows a customized spacer8 token', (
      tester,
    ) async {
      final token = TThemeData.defaultData();
      final originalSpacing = token.spacerMap['spacer8'];
      void restoreTokens() {
        if (originalSpacing == null) {
          token.spacerMap.remove('spacer8');
        } else {
          token.spacerMap['spacer8'] = originalSpacing;
        }
      }

      addTearDown(restoreTokens);
      token.spacerMap['spacer8'] = 10;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [token]),
          home: const Scaffold(body: SizedBox(width: 320, child: TSkeleton())),
        ),
      );

      final blocks = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration! as BoxDecoration).color != Colors.transparent,
      );
      expect(blocks, findsNWidgets(3));
      expect(
        tester.getRect(blocks.at(2)).top - tester.getRect(blocks.at(0)).top,
        26,
      );
      restoreTokens();
    });

    testWidgets('uses the theme highlight color for gradient animation', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const TSkeleton(animation: TSkeletonAnimation.gradient),
          skeletonTheme: const TSkeletonThemeData(highlightColor: Colors.green),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));
      final shaderMask = tester.widget<ShaderMask>(
        find.byType(ShaderMask).first,
      );
      final shader = shaderMask.shaderCallback(
        const Rect.fromLTWH(0, 0, 40, 16),
      );
      expect(shader, isNotNull);
    });
  });

  group('TSkeleton lifecycle', () {
    testWidgets('honors and updates delay', (tester) async {
      await tester.pumpWidget(
        wrap(
          const TSkeleton(
            variant: TSkeletonVariant.avatar,
            delay: Duration(milliseconds: 100),
          ),
        ),
      );
      expect(find.byType(Container), findsNothing);

      await tester.pump(const Duration(milliseconds: 100));
      expect(decorations(tester), hasLength(1));

      await tester.pumpWidget(
        wrap(
          const TSkeleton(
            variant: TSkeletonVariant.avatar,
            delay: Duration(milliseconds: 200),
          ),
        ),
      );
      expect(find.byType(Container), findsNothing);
    });

    testWidgets('switches safely between static and animated modes', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const TSkeleton()));
      expect(find.byType(ShaderMask), findsNothing);

      await tester.pumpWidget(
        wrap(const TSkeleton(animation: TSkeletonAnimation.gradient)),
      );
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byType(ShaderMask), findsWidgets);

      await tester.pumpWidget(
        wrap(const TSkeleton(animation: TSkeletonAnimation.flashed)),
      );
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byType(Opacity), findsWidgets);

      await tester.pumpWidget(wrap(const TSkeleton()));
      expect(tester.takeException(), isNull);
      expect(find.byType(ShaderMask), findsNothing);
      expect(find.byType(Opacity), findsNothing);
    });

    testWidgets('cancels pending delay when disposed', (tester) async {
      await tester.pumpWidget(
        wrap(const TSkeleton(delay: Duration(seconds: 1))),
      );
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 1));
      expect(tester.takeException(), isNull);
    });
  });
}
