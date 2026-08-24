import 'package:flutter/material.dart';
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
  Widget wrapWithTheme(Widget child) {
    return MaterialApp(
      theme: ThemeData(extensions: [
        TThemeData.defaultData(),
        const TTextThemeData(
          textStyle: TextStyle(fontFamily: 'TCloudNumber'),
        ),
      ]),
      home: Scaffold(backgroundColor: Colors.white, body: Center(child: child)),
    );
  }

  List<TTabBarItemConfig> textTabs() => List.generate(
        3,
        (index) => TTabBarItemConfig(
          tabText: ['1', '2', '3'][index],
          onTap: () {},
        ),
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
    required TTabBarVariant variant,
    required List<TTabBarItemConfig> tabs,
    required String golden,
    int value = 0,
  }) async {
    tester.view.physicalSize = const Size(400, 120);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(wrapWithTheme(
      TTabBar(
        variant: variant,
        value: value,
        navigationTabs: tabs,
        onChanged: (_) {},
      ),
    ));

    await expectLater(find.byType(TTabBar), matchesGoldenFile(golden));
  }

  group('TTabBar visual regression', () {
    testWidgets('text defaults to the first selected item', (tester) async {
      await expectTabBarGolden(
        tester,
        variant: TTabBarVariant.text,
        tabs: textTabs(),
        golden: 'goldens/t_tab_bar_text_default.png',
      );
    });

    testWidgets('text renders a non-first selected item', (tester) async {
      await expectTabBarGolden(
        tester,
        variant: TTabBarVariant.text,
        tabs: textTabs(),
        value: 1,
        golden: 'goldens/t_tab_bar_text_selected_1.png',
      );
    });

    testWidgets('icon text renders selected and unselected icons',
        (tester) async {
      await expectTabBarGolden(
        tester,
        variant: TTabBarVariant.iconText,
        tabs: iconTextTabs(),
        golden: 'goldens/t_tab_bar_icon_text.png',
      );
    });

    testWidgets('icon renders selected and unselected icons', (tester) async {
      await expectTabBarGolden(
        tester,
        variant: TTabBarVariant.icon,
        tabs: iconTabs(),
        golden: 'goldens/t_tab_bar_icon.png',
      );
    });

    testWidgets('weak text has no selected capsule background', (tester) async {
      await expectTabBarGolden(
        tester,
        variant: TTabBarVariant.weakText,
        tabs: textTabs(),
        golden: 'goldens/t_tab_bar_normal_style.png',
      );
    });

    testWidgets('capsule renders icon text within the rounded bar',
        (tester) async {
      await expectTabBarGolden(
        tester,
        variant: TTabBarVariant.capsule,
        tabs: iconTextTabs(),
        golden: 'goldens/t_tab_bar_capsule.png',
      );
    });
  });
}
