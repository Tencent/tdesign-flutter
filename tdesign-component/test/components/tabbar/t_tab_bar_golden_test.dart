import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

enum _GoldenTabIconShape { circle, roundedRect, diamond }

class _GoldenTabIcon extends StatelessWidget {
  const _GoldenTabIcon(this.shape);

  final _GoldenTabIconShape shape;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size.square(24),
      painter: _GoldenTabIconPainter(
        color: IconTheme.of(context).color ?? Colors.black,
        shape: shape,
      ),
    );
  }
}

class _GoldenTabIconPainter extends CustomPainter {
  const _GoldenTabIconPainter({required this.color, required this.shape});

  final Color color;
  final _GoldenTabIconShape shape;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    switch (shape) {
      case _GoldenTabIconShape.circle:
        canvas.drawCircle(size.center(Offset.zero), size.width / 3, paint);
      case _GoldenTabIconShape.roundedRect:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(5, 5, size.width - 10, size.height - 10),
            const Radius.circular(3),
          ),
          paint,
        );
      case _GoldenTabIconShape.diamond:
        final path = Path()
          ..moveTo(size.width / 2, 4)
          ..lineTo(size.width - 4, size.height / 2)
          ..lineTo(size.width / 2, size.height - 4)
          ..lineTo(4, size.height / 2)
          ..close();
        canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GoldenTabIconPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.shape != shape;
  }
}

/// Visual regression coverage for the current v1 TTabBar API.
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

  Widget wrapWithTheme(Widget child, Brightness brightness) {
    final token = TThemeData.defaultData();
    final baseTheme = brightness == Brightness.light
        ? TThemeBuilder.light(token)
        : TThemeBuilder.dark(token);
    final theme = baseTheme.copyWith(
      textTheme: baseTheme.textTheme.apply(fontFamily: 'Roboto'),
      primaryTextTheme: baseTheme.primaryTextTheme.apply(fontFamily: 'Roboto'),
    );
    return MaterialApp(
      theme: theme,
      home: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Center(child: child),
      ),
    );
  }

  List<TTabBarItemConfig> textTabs() => List.generate(
    3,
    (index) => TTabBarItemConfig(tabText: ['1', '2', '3'][index], onTap: () {}),
  );

  List<TTabBarItemConfig> iconTextTabs() => [
    TTabBarItemConfig(
      tabText: '1',
      selectedIcon: const _GoldenTabIcon(_GoldenTabIconShape.circle),
      unselectedIcon: const _GoldenTabIcon(_GoldenTabIconShape.circle),
      onTap: () {},
    ),
    TTabBarItemConfig(
      tabText: '2',
      selectedIcon: const _GoldenTabIcon(_GoldenTabIconShape.roundedRect),
      unselectedIcon: const _GoldenTabIcon(_GoldenTabIconShape.roundedRect),
      onTap: () {},
    ),
    TTabBarItemConfig(
      tabText: '3',
      selectedIcon: const _GoldenTabIcon(_GoldenTabIconShape.diamond),
      unselectedIcon: const _GoldenTabIcon(_GoldenTabIconShape.diamond),
      onTap: () {},
    ),
  ];

  List<TTabBarItemConfig> iconTabs() => [
    TTabBarItemConfig(
      selectedIcon: const _GoldenTabIcon(_GoldenTabIconShape.circle),
      unselectedIcon: const _GoldenTabIcon(_GoldenTabIconShape.circle),
      onTap: () {},
    ),
    TTabBarItemConfig(
      selectedIcon: const _GoldenTabIcon(_GoldenTabIconShape.roundedRect),
      unselectedIcon: const _GoldenTabIcon(_GoldenTabIconShape.roundedRect),
      onTap: () {},
    ),
  ];

  Future<void> expectTabBarGolden(
    WidgetTester tester, {
    required TTabBarType type,
    required List<TTabBarItemConfig> tabs,
    required String golden,
    required Brightness brightness,
    int value = 0,
    TTabBarItemStyle itemStyle = TTabBarItemStyle.label,
    TTabBarStyle style = TTabBarStyle.filled,
    TTabBarLayout layout = TTabBarLayout.vertical,
  }) async {
    tester.view.physicalSize = const Size(400, 120);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      wrapWithTheme(
        TTabBar(
          type: type,
          itemStyle: itemStyle,
          style: style,
          layout: layout,
          value: value,
          navigationTabs: tabs,
          onChanged: (_) {},
        ),
        brightness,
      ),
    );

    await expectLater(find.byType(TTabBar), matchesGoldenFile(golden));
  }

  group('TTabBar visual regression', () {
    for (final brightness in Brightness.values) {
      final suffix = brightness.name;

      testWidgets('text defaults to the first selected item $suffix', (
        tester,
      ) async {
        await expectTabBarGolden(
          tester,
          type: TTabBarType.text,
          tabs: textTabs(),
          brightness: brightness,
          golden: 'goldens/t_tab_bar_text_default_$suffix.png',
        );
      });

      testWidgets('text renders a non-first selected item $suffix', (
        tester,
      ) async {
        await expectTabBarGolden(
          tester,
          type: TTabBarType.text,
          tabs: textTabs(),
          value: 1,
          brightness: brightness,
          golden: 'goldens/t_tab_bar_text_selected_1_$suffix.png',
        );
      });

      testWidgets('icon text renders selected and unselected icons $suffix', (
        tester,
      ) async {
        await expectTabBarGolden(
          tester,
          type: TTabBarType.iconText,
          tabs: iconTextTabs(),
          brightness: brightness,
          golden: 'goldens/t_tab_bar_icon_text_$suffix.png',
        );
      });

      testWidgets('horizontal icon text follows the Figma layout $suffix', (
        tester,
      ) async {
        await expectTabBarGolden(
          tester,
          type: TTabBarType.iconText,
          layout: TTabBarLayout.horizontal,
          tabs: iconTextTabs(),
          brightness: brightness,
          golden: 'goldens/t_tab_bar_icon_text_horizontal_$suffix.png',
        );
      });

      testWidgets('icon renders selected and unselected icons $suffix', (
        tester,
      ) async {
        await expectTabBarGolden(
          tester,
          type: TTabBarType.icon,
          tabs: iconTabs(),
          brightness: brightness,
          golden: 'goldens/t_tab_bar_icon_$suffix.png',
        );
      });

      testWidgets('normal text has no selected label background $suffix', (
        tester,
      ) async {
        await expectTabBarGolden(
          tester,
          type: TTabBarType.text,
          itemStyle: TTabBarItemStyle.normal,
          tabs: textTabs(),
          brightness: brightness,
          golden: 'goldens/t_tab_bar_normal_style_$suffix.png',
        );
      });

      testWidgets('capsule renders icon text within the rounded bar $suffix', (
        tester,
      ) async {
        await expectTabBarGolden(
          tester,
          type: TTabBarType.iconText,
          style: TTabBarStyle.capsule,
          tabs: iconTextTabs(),
          brightness: brightness,
          golden: 'goldens/t_tab_bar_capsule_$suffix.png',
        );
      });
    }
  });
}
