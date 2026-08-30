import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  group('TPopup widget 级用例', () {
    testWidgets('TPopupOptions 各方向工厂可构造', (tester) async {
      final bottom = TPopupOptions.bottom(
        child: const Text('body'),
        headerBuilder: (_, __) => const TPopupHeader(title: Text('标题')),
      );
      final top = TPopupOptions.top(child: const Text('top'));
      final left = TPopupOptions.left(child: const Text('left'));
      final right = TPopupOptions.right(child: const Text('right'));
      final center = TPopupOptions.center(child: const Text('center'));
      expect(bottom.placement, TPopupPlacement.bottom);
      expect(top.placement, TPopupPlacement.top);
      expect(left.placement, TPopupPlacement.left);
      expect(right.placement, TPopupPlacement.right);
      expect(center.placement, TPopupPlacement.center);
    });

    testWidgets('TPopup.show 打开浮层并渲染内容', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => TPopup.show(
                  context,
                  options: TPopupOptions.bottom(child: const Text('浮层内容')),
                ),
                child: const Text('打开'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      expect(find.text('浮层内容'), findsWidgets);
    });

    testWidgets('center 浮层可打开', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => TPopup.show(
                  context,
                  options: TPopupOptions.center(child: const Text('居中浮层')),
                ),
                child: const Text('打开居中'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('打开居中'));
      await tester.pumpAndSettle();
      expect(find.text('居中浮层'), findsWidgets);
    });

    testWidgets('Theme 控制 edge 高度且实例 height 优先', (tester) async {
      const contentKey = ValueKey('themed-edge-content');
      var explicitHeight = false;
      final theme = TThemeBuilder.light(
        TThemeData.defaultData(),
      ).mergeExtension(const TPopupThemeData(edgeHeight: 180));
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => TPopup.show(
                  context,
                  options: TPopupOptions.top(
                    height: explicitHeight ? 120 : null,
                    child: const SizedBox.expand(key: contentKey),
                  ),
                ),
                child: const Text('打开主题 edge'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('打开主题 edge'));
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byKey(contentKey)).height, 180);

      Navigator.of(tester.element(find.byKey(contentKey))).pop();
      await tester.pumpAndSettle();
      explicitHeight = true;
      await tester.tap(find.text('打开主题 edge'));
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byKey(contentKey)).height, 120);
    });

    testWidgets('Theme 控制 drawer 宽度和 center 尺寸', (tester) async {
      const drawerKey = ValueKey('themed-drawer-content');
      const centerKey = ValueKey('themed-center-content');
      final theme = TThemeBuilder.light(TThemeData.defaultData())
          .mergeExtension(
            const TPopupThemeData(drawerWidth: 160, centerSize: Size(200, 140)),
          );
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: Builder(
              builder: (context) => Column(
                children: [
                  ElevatedButton(
                    onPressed: () => TPopup.show(
                      context,
                      options: TPopupOptions.left(
                        child: const SizedBox.expand(key: drawerKey),
                      ),
                    ),
                    child: const Text('打开主题 drawer'),
                  ),
                  ElevatedButton(
                    onPressed: () => TPopup.show(
                      context,
                      options: TPopupOptions.center(
                        child: const SizedBox.expand(key: centerKey),
                      ),
                    ),
                    child: const Text('打开主题 center'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('打开主题 drawer'));
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byKey(drawerKey)).width, 160);
      Navigator.of(tester.element(find.byKey(drawerKey))).pop();
      await tester.pumpAndSettle();

      await tester.tap(find.text('打开主题 center'));
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byKey(centerKey)), const Size(200, 140));
    });

    testWidgets('edge 和 drawer 默认尺寸不会超过可用视口', (tester) async {
      tester.view.physicalSize = const Size(200, 120);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      const edgeKey = ValueKey('viewport-edge-content');
      const drawerKey = ValueKey('viewport-drawer-content');
      final theme = TThemeBuilder.light(TThemeData.defaultData())
          .mergeExtension(
            const TPopupThemeData(edgeHeight: 300, drawerWidth: 300),
          );
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: Builder(
              builder: (context) => Column(
                children: [
                  ElevatedButton(
                    onPressed: () => TPopup.show(
                      context,
                      options: TPopupOptions.top(
                        child: const SizedBox.expand(key: edgeKey),
                      ),
                    ),
                    child: const Text('打开小视口 edge'),
                  ),
                  ElevatedButton(
                    onPressed: () => TPopup.show(
                      context,
                      options: TPopupOptions.left(
                        child: const SizedBox.expand(key: drawerKey),
                      ),
                    ),
                    child: const Text('打开小视口 drawer'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('打开小视口 edge'));
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byKey(edgeKey)).height, 120);
      Navigator.of(tester.element(find.byKey(edgeKey))).pop();
      await tester.pumpAndSettle();

      await tester.tap(find.text('打开小视口 drawer'));
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byKey(drawerKey)).width, 200);
    });

    testWidgets('center 面板和关闭区在小视口中不会溢出', (tester) async {
      tester.view.physicalSize = const Size(200, 120);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      const centerKey = ValueKey('viewport-center-content');
      final theme = TThemeBuilder.light(
        TThemeData.defaultData(),
      ).mergeExtension(const TPopupThemeData(centerSize: Size(300, 300)));
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => TPopup.show(
                  context,
                  options: TPopupOptions.center(
                    child: const SizedBox.expand(key: centerKey),
                  ),
                ),
                child: const Text('打开小视口 center'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('打开小视口 center'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byKey(centerKey)).height,
        lessThanOrEqualTo(120),
      );
    });
  });
}
