import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  tokenGeometryTransitions();
  testWidgets(
    'BackTop actual layout uses token endpoints instead of raw interpolated fields',
    (tester) async {
      final token = TThemeData.defaultData().copyWith(
        sizeMap: {'size13': 80, 'size12': 60},
      );
      for (final shape in TBackTopShape.values) {
        for (final t in [0.0, 0.5, 1.0]) {
          final component = const TBackTopThemeData().lerp(
            const TBackTopThemeData(roundSize: 40, halfCircleHeight: 20),
            t,
          );
          await tester.pumpWidget(
            MaterialApp(
              themeAnimationDuration: Duration.zero,
              theme: TThemeBuilder.light(token).mergeExtension(component),
              home: Scaffold(
                body: Center(child: TBackTop(shape: shape)),
              ),
            ),
          );
          final container = tester
              .widgetList<Container>(
                find.descendant(
                  of: find.byType(TBackTop),
                  matching: find.byType(Container),
                ),
              )
              .firstWhere((w) => w.decoration is ShapeDecoration);
          final actual = tester.getSize(find.byWidget(container));
          expect(
            actual.height,
            shape == TBackTopShape.circle ? 80 - 40 * t : 60 - 40 * t,
          );
        }
      }
    },
  );

  testWidgets('Table interpolation begins at its effective token padding', (
    tester,
  ) async {
    final component = const TTableThemeData().lerp(
      const TTableThemeData(cellPadding: EdgeInsets.all(20)),
      0,
    );
    final token = TThemeData.defaultData();
    await tester.pumpWidget(
      MaterialApp(
        theme: TThemeBuilder.light(token).mergeExtension(component),
        home: Scaffold(
          body: TTable<String>(
            columns: [
              TTableColumn<String>(
                id: 'a',
                header: const Text('head'),
                cellBuilder: (_, value, __) => Text(value),
              ),
            ],
            data: const ['cell'],
          ),
        ),
      ),
    );
    final padding = tester
        .widget<Padding>(
          find
              .ancestor(of: find.text('head'), matching: find.byType(Padding))
              .first,
        )
        .padding;
    expect(padding, const EdgeInsets.symmetric(horizontal: 12));
  });
}

void tokenGeometryTransitions() {
  test(
    'TBackTopThemeData.roundSize uses effective token during nullable and interrupted transitions',
    () {
      const absent = TBackTopThemeData();
      const configured = TBackTopThemeData(roundSize: 40);
      expect(absent.lerp(absent, 0.5).resolveRoundSize(80), 80);
      expect(absent.lerp(configured, 0).resolveRoundSize(80), 80);
      expect(absent.lerp(configured, 1).resolveRoundSize(80), 40);
      final midway = absent.lerp(configured, 0.5);
      expect(midway.resolveRoundSize(80), 60);
      expect(configured.lerp(absent, 0.5).resolveRoundSize(80), 60);
      expect(midway.copyWith().resolveRoundSize(80), 60);
      expect(midway.lerp(absent, 0.5).resolveRoundSize(80), 70);
      expect(midway.copyWith(roundSize: 40).resolveRoundSize(80), 40);
    },
  );
  test(
    'TBackTopThemeData.halfCircleHeight uses effective token during nullable and interrupted transitions',
    () {
      const absent = TBackTopThemeData();
      const configured = TBackTopThemeData(halfCircleHeight: 20);
      expect(absent.lerp(absent, 0.5).resolveHalfCircleHeight(60), 60);
      expect(absent.lerp(configured, 0).resolveHalfCircleHeight(60), 60);
      expect(absent.lerp(configured, 1).resolveHalfCircleHeight(60), 20);
      final midway = absent.lerp(configured, 0.5);
      expect(midway.resolveHalfCircleHeight(60), 40);
      expect(configured.lerp(absent, 0.5).resolveHalfCircleHeight(60), 40);
      expect(midway.copyWith().resolveHalfCircleHeight(60), 40);
      expect(midway.lerp(absent, 0.5).resolveHalfCircleHeight(60), 50);
      expect(
        midway.copyWith(halfCircleHeight: 20).resolveHalfCircleHeight(60),
        20,
      );
    },
  );
  test(
    'TBackTopThemeData.halfCircleHorizontalPadding uses effective token during nullable and interrupted transitions',
    () {
      const absent = TBackTopThemeData();
      const configured = TBackTopThemeData(halfCircleHorizontalPadding: 8);
      expect(
        absent.lerp(absent, 0.5).resolveHalfCircleHorizontalPadding(24),
        24,
      );
      expect(
        absent.lerp(configured, 0).resolveHalfCircleHorizontalPadding(24),
        24,
      );
      expect(
        absent.lerp(configured, 1).resolveHalfCircleHorizontalPadding(24),
        8,
      );
      final midway = absent.lerp(configured, 0.5);
      expect(midway.resolveHalfCircleHorizontalPadding(24), 16);
      expect(
        configured.lerp(absent, 0.5).resolveHalfCircleHorizontalPadding(24),
        16,
      );
      expect(midway.copyWith().resolveHalfCircleHorizontalPadding(24), 16);
      expect(
        midway.lerp(absent, 0.5).resolveHalfCircleHorizontalPadding(24),
        20,
      );
      expect(
        midway
            .copyWith(halfCircleHorizontalPadding: 8)
            .resolveHalfCircleHorizontalPadding(24),
        8,
      );
    },
  );
  test(
    'TBackTopThemeData.contentGap uses effective token during nullable and interrupted transitions',
    () {
      const absent = TBackTopThemeData();
      const configured = TBackTopThemeData(contentGap: 4);
      expect(absent.lerp(absent, 0.5).resolveContentGap(12), 12);
      expect(absent.lerp(configured, 0).resolveContentGap(12), 12);
      expect(absent.lerp(configured, 1).resolveContentGap(12), 4);
      final midway = absent.lerp(configured, 0.5);
      expect(midway.resolveContentGap(12), 8);
      expect(configured.lerp(absent, 0.5).resolveContentGap(12), 8);
      expect(midway.copyWith().resolveContentGap(12), 8);
      expect(midway.lerp(absent, 0.5).resolveContentGap(12), 10);
      expect(midway.copyWith(contentGap: 4).resolveContentGap(12), 4);
    },
  );
  test(
    'TTabBarThemeData.barHeight uses effective token during nullable and interrupted transitions',
    () {
      const absent = TTabBarThemeData();
      const configured = TTabBarThemeData(barHeight: 40);
      expect(absent.lerp(absent, 0.5).resolveBarHeight(80), 80);
      expect(absent.lerp(configured, 0).resolveBarHeight(80), 80);
      expect(absent.lerp(configured, 1).resolveBarHeight(80), 40);
      final midway = absent.lerp(configured, 0.5);
      expect(midway.resolveBarHeight(80), 60);
      expect(configured.lerp(absent, 0.5).resolveBarHeight(80), 60);
      expect(midway.copyWith().resolveBarHeight(80), 60);
      expect(midway.lerp(absent, 0.5).resolveBarHeight(80), 70);
      expect(midway.copyWith(barHeight: 40).resolveBarHeight(80), 40);
    },
  );
  test(
    'TCellThemeData.cardBorderRadius uses effective token during nullable and interrupted transitions',
    () {
      const absent = TCellThemeData();
      final configured = TCellThemeData(
        cardBorderRadius: BorderRadius.circular(12),
      );
      expect(
        absent
            .lerp(absent, 0.5)
            .resolveCardBorderRadius(BorderRadius.circular(20)),
        BorderRadius.circular(20),
      );
      expect(
        absent
            .lerp(configured, 0)
            .resolveCardBorderRadius(BorderRadius.circular(20)),
        BorderRadius.circular(20),
      );
      expect(
        absent
            .lerp(configured, 1)
            .resolveCardBorderRadius(BorderRadius.circular(20)),
        BorderRadius.circular(12),
      );
      final midway = absent.lerp(configured, 0.5);
      expect(
        midway.resolveCardBorderRadius(BorderRadius.circular(20)),
        BorderRadius.circular(16),
      );
      expect(
        configured
            .lerp(absent, 0.5)
            .resolveCardBorderRadius(BorderRadius.circular(20)),
        BorderRadius.circular(16),
      );
      expect(
        midway.copyWith().resolveCardBorderRadius(BorderRadius.circular(20)),
        BorderRadius.circular(16),
      );
      expect(
        midway
            .lerp(absent, 0.5)
            .resolveCardBorderRadius(BorderRadius.circular(20)),
        BorderRadius.circular(18),
      );
      expect(
        midway
            .copyWith(cardBorderRadius: BorderRadius.zero)
            .resolveCardBorderRadius(BorderRadius.circular(20)),
        BorderRadius.zero,
      );
    },
  );
  test(
    'TTableThemeData.cellPadding uses effective token during nullable and interrupted transitions',
    () {
      const absent = TTableThemeData();
      const configured = TTableThemeData(
        cellPadding: EdgeInsetsDirectional.only(start: 10, end: 30),
      );
      expect(
        absent
            .lerp(absent, 0.5)
            .resolveCellPadding(
              const EdgeInsetsDirectional.only(start: 30, end: 10),
            ),
        const EdgeInsetsDirectional.only(start: 30, end: 10),
      );
      expect(
        absent
            .lerp(configured, 0)
            .resolveCellPadding(
              const EdgeInsetsDirectional.only(start: 30, end: 10),
            ),
        const EdgeInsetsDirectional.only(start: 30, end: 10),
      );
      expect(
        absent
            .lerp(configured, 1)
            .resolveCellPadding(
              const EdgeInsetsDirectional.only(start: 30, end: 10),
            ),
        const EdgeInsetsDirectional.only(start: 10, end: 30),
      );
      final midway = absent.lerp(configured, 0.5);
      expect(
        midway.resolveCellPadding(
          const EdgeInsetsDirectional.only(start: 30, end: 10),
        ),
        const EdgeInsetsDirectional.only(start: 20, end: 20),
      );
      expect(
        configured
            .lerp(absent, 0.5)
            .resolveCellPadding(
              const EdgeInsetsDirectional.only(start: 30, end: 10),
            ),
        const EdgeInsetsDirectional.only(start: 20, end: 20),
      );
      expect(
        midway.copyWith().resolveCellPadding(
          const EdgeInsetsDirectional.only(start: 30, end: 10),
        ),
        const EdgeInsetsDirectional.only(start: 20, end: 20),
      );
      expect(
        midway
            .lerp(absent, 0.5)
            .resolveCellPadding(
              const EdgeInsetsDirectional.only(start: 30, end: 10),
            ),
        const EdgeInsetsDirectional.only(start: 25, end: 15),
      );
      expect(
        midway
            .copyWith(cellPadding: EdgeInsets.zero)
            .resolveCellPadding(
              const EdgeInsetsDirectional.only(start: 30, end: 10),
            ),
        EdgeInsets.zero,
      );
    },
  );
  test(
    'TDrawerThemeData.titlePadding uses effective token during nullable and interrupted transitions',
    () {
      const absent = TDrawerThemeData();
      const configured = TDrawerThemeData(titlePadding: EdgeInsets.all(10));
      expect(
        absent.lerp(absent, 0.5).resolveTitlePadding(const EdgeInsets.all(30)),
        const EdgeInsets.all(30),
      );
      expect(
        absent
            .lerp(configured, 0)
            .resolveTitlePadding(const EdgeInsets.all(30)),
        const EdgeInsets.all(30),
      );
      expect(
        absent
            .lerp(configured, 1)
            .resolveTitlePadding(const EdgeInsets.all(30)),
        const EdgeInsets.all(10),
      );
      final midway = absent.lerp(configured, 0.5);
      expect(
        midway.resolveTitlePadding(const EdgeInsets.all(30)),
        const EdgeInsets.all(20),
      );
      expect(
        configured
            .lerp(absent, 0.5)
            .resolveTitlePadding(const EdgeInsets.all(30)),
        const EdgeInsets.all(20),
      );
      expect(
        midway.copyWith().resolveTitlePadding(const EdgeInsets.all(30)),
        const EdgeInsets.all(20),
      );
      expect(
        midway.lerp(absent, 0.5).resolveTitlePadding(const EdgeInsets.all(30)),
        const EdgeInsets.all(25),
      );
      expect(
        midway
            .copyWith(titlePadding: EdgeInsets.zero)
            .resolveTitlePadding(const EdgeInsets.all(30)),
        EdgeInsets.zero,
      );
    },
  );
  test(
    'TDrawerThemeData.itemPadding uses effective token during nullable and interrupted transitions',
    () {
      const absent = TDrawerThemeData();
      const configured = TDrawerThemeData(itemPadding: EdgeInsets.all(10));
      expect(
        absent.lerp(absent, 0.5).resolveItemPadding(const EdgeInsets.all(30)),
        const EdgeInsets.all(30),
      );
      expect(
        absent.lerp(configured, 0).resolveItemPadding(const EdgeInsets.all(30)),
        const EdgeInsets.all(30),
      );
      expect(
        absent.lerp(configured, 1).resolveItemPadding(const EdgeInsets.all(30)),
        const EdgeInsets.all(10),
      );
      final midway = absent.lerp(configured, 0.5);
      expect(
        midway.resolveItemPadding(const EdgeInsets.all(30)),
        const EdgeInsets.all(20),
      );
      expect(
        configured
            .lerp(absent, 0.5)
            .resolveItemPadding(const EdgeInsets.all(30)),
        const EdgeInsets.all(20),
      );
      expect(
        midway.copyWith().resolveItemPadding(const EdgeInsets.all(30)),
        const EdgeInsets.all(20),
      );
      expect(
        midway.lerp(absent, 0.5).resolveItemPadding(const EdgeInsets.all(30)),
        const EdgeInsets.all(25),
      );
      expect(
        midway
            .copyWith(itemPadding: EdgeInsets.zero)
            .resolveItemPadding(const EdgeInsets.all(30)),
        EdgeInsets.zero,
      );
    },
  );
  test(
    'TDrawerThemeData.itemIconGap uses effective token during nullable and interrupted transitions',
    () {
      const absent = TDrawerThemeData();
      const configured = TDrawerThemeData(itemIconGap: 8);
      expect(absent.lerp(absent, 0.5).resolveItemIconGap(24), 24);
      expect(absent.lerp(configured, 0).resolveItemIconGap(24), 24);
      expect(absent.lerp(configured, 1).resolveItemIconGap(24), 8);
      final midway = absent.lerp(configured, 0.5);
      expect(midway.resolveItemIconGap(24), 16);
      expect(configured.lerp(absent, 0.5).resolveItemIconGap(24), 16);
      expect(midway.copyWith().resolveItemIconGap(24), 16);
      expect(midway.lerp(absent, 0.5).resolveItemIconGap(24), 20);
      expect(midway.copyWith(itemIconGap: 8).resolveItemIconGap(24), 8);
    },
  );
  test(
    'TSearchBarThemeData.contentPadding uses effective token during nullable and interrupted transitions',
    () {
      const absent = TSearchBarThemeData();
      const configured = TSearchBarThemeData(
        contentPadding: EdgeInsets.all(10),
      );
      expect(
        absent
            .lerp(absent, 0.5)
            .resolveContentPadding(const EdgeInsets.all(30)),
        const EdgeInsets.all(30),
      );
      expect(
        absent
            .lerp(configured, 0)
            .resolveContentPadding(const EdgeInsets.all(30)),
        const EdgeInsets.all(30),
      );
      expect(
        absent
            .lerp(configured, 1)
            .resolveContentPadding(const EdgeInsets.all(30)),
        const EdgeInsets.all(10),
      );
      final midway = absent.lerp(configured, 0.5);
      expect(
        midway.resolveContentPadding(const EdgeInsets.all(30)),
        const EdgeInsets.all(20),
      );
      expect(
        configured
            .lerp(absent, 0.5)
            .resolveContentPadding(const EdgeInsets.all(30)),
        const EdgeInsets.all(20),
      );
      expect(
        midway.copyWith().resolveContentPadding(const EdgeInsets.all(30)),
        const EdgeInsets.all(20),
      );
      expect(
        midway
            .lerp(absent, 0.5)
            .resolveContentPadding(const EdgeInsets.all(30)),
        const EdgeInsets.all(25),
      );
      expect(
        midway
            .copyWith(contentPadding: EdgeInsets.zero)
            .resolveContentPadding(const EdgeInsets.all(30)),
        EdgeInsets.zero,
      );
    },
  );
  test(
    'TSearchBarThemeData.clearIconSize uses effective token during nullable and interrupted transitions',
    () {
      const absent = TSearchBarThemeData();
      const configured = TSearchBarThemeData(
        clearIconTheme: IconThemeData(size: 24),
      );
      expect(absent.lerp(absent, 0.5).resolveClearIconSize(48), 48);
      expect(absent.lerp(configured, 0).resolveClearIconSize(48), 48);
      expect(absent.lerp(configured, 1).resolveClearIconSize(48), 24);
      final midway = absent.lerp(configured, 0.5);
      // Replacing IconThemeData replaces its unspecified size with the token default.
      expect(
        midway
            .copyWith(clearIconTheme: const IconThemeData(color: Colors.red))
            .resolveClearIconSize(48),
        48,
      );
      expect(midway.resolveClearIconSize(48), 36);
      expect(configured.lerp(absent, 0.5).resolveClearIconSize(48), 36);
      expect(midway.copyWith().resolveClearIconSize(48), 36);
      expect(midway.lerp(absent, 0.5).resolveClearIconSize(48), 42);
      expect(
        midway
            .copyWith(clearIconTheme: const IconThemeData(size: 24))
            .resolveClearIconSize(48),
        24,
      );
    },
  );
  test(
    'TSearchBarThemeData.searchIconSize uses effective token during nullable and interrupted transitions',
    () {
      const absent = TSearchBarThemeData();
      const configured = TSearchBarThemeData(
        searchIconTheme: IconThemeData(size: 24),
      );
      expect(absent.lerp(absent, 0.5).resolveSearchIconSize(48), 48);
      expect(absent.lerp(configured, 0).resolveSearchIconSize(48), 48);
      expect(absent.lerp(configured, 1).resolveSearchIconSize(48), 24);
      final midway = absent.lerp(configured, 0.5);
      // Replacing IconThemeData replaces its unspecified size with the token default.
      expect(
        midway
            .copyWith(searchIconTheme: const IconThemeData(color: Colors.red))
            .resolveSearchIconSize(48),
        48,
      );
      expect(midway.resolveSearchIconSize(48), 36);
      expect(configured.lerp(absent, 0.5).resolveSearchIconSize(48), 36);
      expect(midway.copyWith().resolveSearchIconSize(48), 36);
      expect(midway.lerp(absent, 0.5).resolveSearchIconSize(48), 42);
      expect(
        midway
            .copyWith(searchIconTheme: const IconThemeData(size: 24))
            .resolveSearchIconSize(48),
        24,
      );
    },
  );
  test(
    'TToastThemeData.padding uses effective token during nullable and interrupted transitions',
    () {
      const absent = TToastThemeData();
      const configured = TToastThemeData(padding: EdgeInsets.all(10));
      expect(
        absent.lerp(absent, 0.5).resolvePadding(const EdgeInsets.all(30)),
        const EdgeInsets.all(30),
      );
      expect(
        absent.lerp(configured, 0).resolvePadding(const EdgeInsets.all(30)),
        const EdgeInsets.all(30),
      );
      expect(
        absent.lerp(configured, 1).resolvePadding(const EdgeInsets.all(30)),
        const EdgeInsets.all(10),
      );
      final midway = absent.lerp(configured, 0.5);
      expect(
        midway.resolvePadding(const EdgeInsets.all(30)),
        const EdgeInsets.all(20),
      );
      expect(
        configured.lerp(absent, 0.5).resolvePadding(const EdgeInsets.all(30)),
        const EdgeInsets.all(20),
      );
      expect(
        midway.copyWith().resolvePadding(const EdgeInsets.all(30)),
        const EdgeInsets.all(20),
      );
      expect(
        midway.lerp(absent, 0.5).resolvePadding(const EdgeInsets.all(30)),
        const EdgeInsets.all(25),
      );
      expect(
        midway
            .copyWith(padding: EdgeInsets.zero)
            .resolvePadding(const EdgeInsets.all(30)),
        EdgeInsets.zero,
      );
    },
  );
  test(
    'Toast merge retains interpolation but explicit padding replaces it',
    () {
      final midway = const TToastThemeData().lerp(
        const TToastThemeData(padding: EdgeInsets.all(10), iconSize: 20),
        0.5,
      );
      expect(
        midway
            .merge(const TToastThemeData(backgroundColor: Colors.red))
            .resolvePadding(const EdgeInsets.all(30)),
        const EdgeInsets.all(20),
      );
      expect(
        midway
            .merge(const TToastThemeData(padding: EdgeInsets.zero))
            .resolvePadding(const EdgeInsets.all(30)),
        EdgeInsets.zero,
      );
      expect(midway.merge(const TToastThemeData()).resolveIconSize(40), 30);
    },
  );
}
