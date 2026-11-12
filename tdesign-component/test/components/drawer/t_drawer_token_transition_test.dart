import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/drawer/t_drawer_theme_data.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
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
}
