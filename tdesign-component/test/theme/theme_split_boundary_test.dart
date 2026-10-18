import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  for (final dark in [false, true]) {
    testWidgets(
      'split A retains legacy geometry with custom global sizes dark=$dark',
      (tester) async {
        final defaults = TThemeData.defaultData();
        final base = dark ? defaults.dark! : defaults;
        final custom = base.copyWith(
          sizeMap: {for (var i = 1; i <= 16; i++) 'size$i': 80.0 + i},
          radiusMap: {
            'radiusSmall': 21,
            'radiusDefault': 22,
            'radiusLarge': 23,
          },
          spacerMap: {'spacer1': 31, 'spacer2': 32},
        );
        Future<void> pump(Widget child, TThemeData token) => tester.pumpWidget(
          MaterialApp(
            themeAnimationDuration: Duration.zero,
            theme:
                (dark ? TThemeBuilder.dark(token) : TThemeBuilder.light(token))
                    .mergeExtension(token),
            home: Scaffold(body: Center(child: child)),
          ),
        );
        List<BoxDecoration> boxes() => [
          ...tester
              .widgetList<DecoratedBox>(find.byType(DecoratedBox))
              .map((w) => w.decoration)
              .whereType<BoxDecoration>(),
          ...tester
              .widgetList<Container>(find.byType(Container))
              .map((w) => w.decoration)
              .whereType<BoxDecoration>(),
        ];
        for (final token in [base, custom]) {
          await pump(
            const TBadge(variant: TBadgeVariant.square, label: '8'),
            token,
          );
          expect(
            boxes().map((b) => b.borderRadius),
            contains(BorderRadius.circular(2)),
          );
          await pump(
            const TCellGroup(
              variant: TCellGroupVariant.card,
              cells: [TCell(title: Text('cell'))],
            ),
            token,
          );
          expect(
            boxes().map((b) => b.borderRadius),
            contains(BorderRadius.circular(8)),
          );
          await pump(
            SizedBox(
              width: 300,
              height: 200,
              child: TSideBar(
                value: 0,
                variant: TSideBarVariant.tag,
                onChanged: (_) {},
                children: const [
                  TSideBarItem(value: 0, label: 'one'),
                  TSideBarItem(value: 1, label: 'two'),
                ],
              ),
            ),
            token,
          );
          expect(
            boxes().map((b) => b.borderRadius),
            contains(BorderRadius.circular(9)),
          );
          await pump(
            const DefaultTabController(
              length: 2,
              child: TTabsBar(
                variant: TTabsBarVariant.tag,
                tabs: [
                  TTab(text: 'one'),
                  TTab(text: 'two'),
                ],
              ),
            ),
            token,
          );
          final inner = tester
              .widgetList<Container>(find.byType(Container))
              .where((w) => w.constraints?.minHeight == 32);
          expect(inner, hasLength(2));
          expect(
            inner.map((w) => w.padding),
            everyElement(const EdgeInsets.symmetric(horizontal: 8)),
          );
          await pump(
            TTable<String>(
              columns: [
                TTableColumn<String>(
                  id: 'value',
                  header: const Text('header'),
                  cellBuilder: (_, value, __) => Text(value),
                ),
              ],
              data: const ['cell'],
            ),
            token,
          );
          final padding = tester
              .widget<Padding>(
                find
                    .ancestor(
                      of: find.text('header'),
                      matching: find.byType(Padding),
                    )
                    .first,
              )
              .padding;
          expect(padding, const EdgeInsets.symmetric(horizontal: 16));
          for (final size in TButtonSize.values) {
            await pump(
              TButton(
                size: size,
                icon: const Icon(Icons.add),
                onPressed: () {},
                child: const Text('button'),
              ),
              token,
            );
            final style = tester
                .widget<ElevatedButton>(find.byType(ElevatedButton))
                .style!;
            expect(
              style.minimumSize!.resolve({})!.height,
              [48, 40, 32, 28][size.index],
            );
            expect(style.iconSize!.resolve({}), [24, 20, 18, 18][size.index]);
          }
        }
        expect(tester.takeException(), isNull);
      },
    );
    testWidgets(
      'split A opened Toast follows existing colors but retains 22/14 padding dark=$dark',
      (tester) async {
        final defaults = TThemeData.defaultData();
        final initial = dark ? defaults.dark! : defaults;
        final tokens = ValueNotifier(initial);
        await tester.pumpWidget(
          ValueListenableBuilder<TThemeData>(
            valueListenable: tokens,
            builder: (_, value, __) => MaterialApp(
              themeAnimationDuration: Duration.zero,
              theme:
                  (dark
                          ? TThemeBuilder.dark(value)
                          : TThemeBuilder.light(value))
                      .mergeExtension(value),
              home: const Scaffold(body: SizedBox(key: ValueKey('toast-host'))),
            ),
          ),
        );
        TToast.showText(
          'live theme',
          context: tester.element(find.byKey(const ValueKey('toast-host'))),
          duration: Duration.zero,
        );
        await tester.pump();
        Container box() => tester
            .widgetList<Container>(find.byType(Container))
            .firstWhere(
              (w) => w.padding == const EdgeInsets.fromLTRB(22, 14, 22, 14),
            );
        expect((box().decoration! as BoxDecoration).color, initial.fontGray2);
        tokens.value = initial.copyWith(
          colorMap: {'fontGray2': Colors.purple},
          sizeMap: {'size8': 80, 'size6': 60},
        );
        await tester.pumpAndSettle();
        expect((box().decoration! as BoxDecoration).color, Colors.purple);
        expect(box().padding, const EdgeInsets.fromLTRB(22, 14, 22, 14));
        TToast.dismissAll();
        await tester.pumpWidget(const SizedBox());
        tokens.dispose();
      },
    );
  }
}
