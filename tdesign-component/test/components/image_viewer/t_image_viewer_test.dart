import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  const images = <ImageProvider<Object>>[
    AssetImage('missing-1.png'),
    AssetImage('missing-2.png'),
    AssetImage('missing-3.png'),
  ];

  Widget app({
    TImageViewerThemeData? viewerTheme,
    required void Function(BuildContext) onShow,
  }) {
    var theme = TThemeBuilder.light(TThemeData.defaultData());
    if (viewerTheme != null) {
      theme = theme.mergeExtension(viewerTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => onShow(context),
            child: const Text('show'),
          ),
        ),
      ),
    );
  }

  Future<void> open(WidgetTester tester, Widget widget) async {
    await tester.pumpWidget(widget);
    await tester.tap(find.text('show'));
    await tester.pumpAndSettle();
  }

  group('TImageViewer.show', () {
    testWidgets('显示初始页、标签和页码', (tester) async {
      await open(
        tester,
        app(
          onShow: (context) {
            TImageViewer.show(
              context: context,
              images: images,
              labels: const ['A', 'B', 'C'],
              initialIndex: 1,
            );
          },
        ),
      );

      expect(find.byType(TSwiper), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('2/3'), findsOneWidget);
    });

    testWidgets('默认页码样式来自全局 token', (tester) async {
      final token = TThemeData.defaultData();
      await open(
        tester,
        app(
          onShow: (context) {
            TImageViewer.show(context: context, images: images);
          },
        ),
      );

      final index = tester.widget<Text>(find.text('1/3'));
      expect(index.style?.color, token.textColorAnti);
      expect(index.style?.fontSize, token.fontBodyMedium?.size);
    });

    testWidgets('图片加载失败时显示 TDesign 错误占位', (tester) async {
      final token = TThemeData.defaultData();
      await open(
        tester,
        app(
          onShow: (context) {
            TImageViewer.show(context: context, images: images);
          },
        ),
      );

      final placeholder = tester.widget<Icon>(
        find.byKey(const ValueKey('image-viewer-error-placeholder')).first,
      );
      expect(placeholder.icon, TIcons.close);
      expect(placeholder.size, token.spacer24);
      expect(placeholder.color, token.textColorAnti);
    });

    testWidgets('关闭按钮完成展示 Future 并关闭 Dialog', (tester) async {
      var completed = 0;
      await open(
        tester,
        app(
          onShow: (context) {
            TImageViewer.show(
              context: context,
              images: images,
            ).then((_) => completed++);
          },
        ),
      );

      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
      expect(completed, 1);
      expect(find.byType(TSwiper), findsNothing);
    });

    testWidgets('调用方可通过 Navigator 主动关闭并完成展示 Future', (tester) async {
      final navigatorKey = GlobalKey<NavigatorState>();
      var completed = 0;
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () {
                  TImageViewer.show(
                    context: context,
                    images: images,
                  ).then((_) => completed++);
                },
                child: const Text('show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('show'));
      await tester.pumpAndSettle();
      navigatorKey.currentState!.pop();
      await tester.pumpAndSettle();

      expect(completed, 1);
      expect(find.byType(TSwiper), findsNothing);
    });

    testWidgets('showClose=false 隐藏关闭按钮', (tester) async {
      await open(
        tester,
        app(
          onShow: (context) {
            TImageViewer.show(
              context: context,
              images: images,
              showClose: false,
            );
          },
        ),
      );
      expect(find.byTooltip('Close'), findsNothing);
    });

    testWidgets('删除只通知索引且不修改图片列表', (tester) async {
      int? deleted;
      await open(
        tester,
        app(
          onShow: (context) {
            TImageViewer.show(
              context: context,
              images: images,
              initialIndex: 1,
              showDelete: true,
              onDelete: (index) => deleted = index,
            );
          },
        ),
      );

      await tester.tap(find.byTooltip('Delete'));
      expect(deleted, 1);
      expect(
        tester.widget<TSwiper>(find.byType(TSwiper)).children,
        hasLength(3),
      );
    });

    testWidgets('没有 onDelete 时删除按钮禁用', (tester) async {
      await open(
        tester,
        app(
          onShow: (context) {
            TImageViewer.show(
              context: context,
              images: images,
              showDelete: true,
            );
          },
        ),
      );
      final button = find.ancestor(
        of: find.byTooltip('Delete'),
        matching: find.byType(IconButton),
      );
      expect(tester.widget<IconButton>(button).onPressed, isNull);
    });

    testWidgets('自定义导航栏槽位替代默认按钮', (tester) async {
      await open(
        tester,
        app(
          onShow: (context) {
            TImageViewer.show(
              context: context,
              images: images,
              leadingBuilder: (_, index) => Text('L$index'),
              trailingBuilder: (_, index) => Text('R$index'),
            );
          },
        ),
      );
      expect(find.text('L0'), findsOneWidget);
      expect(find.text('R0'), findsOneWidget);
      expect(find.byTooltip('Close'), findsNothing);
    });

    testWidgets('showIndex=false 且无标签时标题为空', (tester) async {
      await open(
        tester,
        app(
          onShow: (context) {
            TImageViewer.show(
              context: context,
              images: images,
              showIndex: false,
            );
          },
        ),
      );
      expect(find.text('1/3'), findsNothing);
    });

    testWidgets('滑动更新临时索引并通知外部', (tester) async {
      int? changed;
      await open(
        tester,
        app(
          onShow: (context) {
            TImageViewer.show(
              context: context,
              images: images,
              onIndexChanged: (index) => changed = index,
            );
          },
        ),
      );
      await tester.drag(find.byType(PageView), const Offset(-500, 0));
      await tester.pumpAndSettle();
      expect(changed, 1);
      expect(find.text('2/3'), findsOneWidget);
    });

    testWidgets('单击全屏预览区通知当前项并统一关闭', (tester) async {
      int? tapped;
      var completed = 0;
      await open(
        tester,
        app(
          onShow: (context) {
            TImageViewer.show(
              context: context,
              images: images,
              onTap: (index) => tapped = index,
            ).then((_) => completed++);
          },
        ),
      );
      final page = find.byKey(const ValueKey('image-viewer-page-0'));
      final previewRect = tester.getRect(page);
      await tester.tapAt(previewRect.bottomRight - const Offset(8, 8));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      expect(tapped, 0);
      expect(completed, 1);
      expect(find.byType(TSwiper), findsNothing);
    });

    testWidgets('onTap 主动关闭时不会继续退出宿主页', (tester) async {
      final navigatorKey = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () {
                  TImageViewer.show(
                    context: context,
                    images: images,
                    onTap: (_) => navigatorKey.currentState?.pop(),
                  );
                },
                child: const Text('show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('show'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('image-viewer-page-0')));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      expect(find.text('show'), findsOneWidget);
      expect(find.byType(TSwiper), findsNothing);
    });

    testWidgets('系统返回只完成一次展示 Future', (tester) async {
      var completed = 0;
      await open(
        tester,
        app(
          onShow: (context) {
            TImageViewer.show(
              context: context,
              images: images,
            ).then((_) => completed++);
          },
        ),
      );

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(completed, 1);
      expect(find.byType(TSwiper), findsNothing);
    });

    testWidgets('长按仅通知当前项且不关闭', (tester) async {
      int? longPressed;
      await open(
        tester,
        app(
          onShow: (context) {
            TImageViewer.show(
              context: context,
              images: images,
              onLongPress: (index) => longPressed = index,
            );
          },
        ),
      );
      final page = find.byKey(const ValueKey('image-viewer-page-0'));
      await tester.longPress(page);
      expect(longPressed, 0);
      expect(find.byType(TSwiper), findsOneWidget);
    });

    testWidgets('双击在 1 倍与 2 倍之间切换且不关闭', (tester) async {
      var tapped = 0;
      await open(
        tester,
        app(
          onShow: (context) {
            TImageViewer.show(
              context: context,
              images: images,
              onTap: (_) => tapped++,
            );
          },
        ),
      );

      final viewer = find.byType(InteractiveViewer);
      final controller = tester
          .widget<InteractiveViewer>(viewer)
          .transformationController!;
      await tester.tap(viewer);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(viewer);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(controller.value.getMaxScaleOnAxis(), inExclusiveRange(1, 2));
      await tester.pumpAndSettle();
      expect(controller.value.getMaxScaleOnAxis(), closeTo(2, 0.001));
      expect(tapped, 0);
      expect(find.byType(TSwiper), findsOneWidget);

      await tester.tap(viewer);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(viewer);
      await tester.pumpAndSettle();
      expect(controller.value.getMaxScaleOnAxis(), closeTo(1, 0.001));
    });

    testWidgets('双指缩放限制在最大 3 倍并锁定分页', (tester) async {
      await open(
        tester,
        app(
          onShow: (context) {
            TImageViewer.show(
              context: context,
              images: images,
              autoplay: true,
              autoplayInterval: const Duration(hours: 1),
            );
          },
        ),
      );

      final viewer = find.byType(InteractiveViewer);
      final center = tester.getCenter(viewer);
      final first = await tester.createGesture(pointer: 1);
      final second = await tester.createGesture(pointer: 2);
      await first.down(center - const Offset(10, 0));
      await second.down(center + const Offset(10, 0));
      await first.moveTo(center - const Offset(200, 0));
      await second.moveTo(center + const Offset(200, 0));
      await first.up();
      await second.up();
      await tester.pumpAndSettle();

      final controller = tester
          .widget<InteractiveViewer>(viewer)
          .transformationController!;
      expect(tester.widget<InteractiveViewer>(viewer).maxScale, 3);
      expect(controller.value.getMaxScaleOnAxis(), inInclusiveRange(1.01, 3));
      expect(
        tester.widget<TSwiper>(find.byType(TSwiper)).physics,
        isA<NeverScrollableScrollPhysics>(),
      );
      expect(tester.widget<TSwiper>(find.byType(TSwiper)).autoplay, isFalse);

      await tester.drag(viewer, const Offset(-300, 0));
      await tester.pumpAndSettle();
      expect(find.text('1/3'), findsOneWidget);
      expect(controller.value.getMaxScaleOnAxis(), greaterThan(1));

      await tester.tap(viewer);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(viewer);
      await tester.pumpAndSettle();
      expect(controller.value.getMaxScaleOnAxis(), closeTo(1, 0.001));
      expect(tester.widget<TSwiper>(find.byType(TSwiper)).autoplay, isTrue);
      expect(
        tester.widget<TSwiper>(find.byType(TSwiper)).physics,
        isA<PageScrollPhysics>(),
      );
    });

    testWidgets('下拉超过阈值关闭，未超过时回弹', (tester) async {
      var completed = 0;
      await open(
        tester,
        app(
          onShow: (context) {
            TImageViewer.show(
              context: context,
              images: images,
            ).then((_) => completed++);
          },
        ),
      );
      final page = find.byKey(const ValueKey('image-viewer-page-0'));

      await tester.drag(page, const Offset(0, 40));
      await tester.pump(const Duration(milliseconds: 100));
      final transform = tester.widget<Transform>(
        find.byKey(const ValueKey('image-viewer-drag-transform')),
      );
      expect(
        transform.transform.getTranslation().y > 0 &&
            transform.transform.getTranslation().y < 40,
        isTrue,
      );
      await tester.pumpAndSettle();
      expect(find.byType(TSwiper), findsOneWidget);
      expect(completed, 0);

      await tester.drag(page, const Offset(0, 140));
      await tester.pumpAndSettle();
      expect(find.byType(TSwiper), findsNothing);
      expect(completed, 1);
    });

    testWidgets('Theme 控制颜色、尺寸和文字样式', (tester) async {
      await open(
        tester,
        app(
          viewerTheme: const TImageViewerThemeData(
            backgroundColor: Colors.red,
            appBarBackgroundColor: Colors.blue,
            iconColor: Colors.green,
            labelStyle: TextStyle(fontSize: 18),
            indexStyle: TextStyle(fontSize: 14),
            viewerWidth: 120,
            viewerHeight: 80,
          ),
          onShow: (context) {
            TImageViewer.show(
              context: context,
              images: images,
              labels: const ['A', 'B', 'C'],
            );
          },
        ),
      );
      expect(tester.widget<Text>(find.text('A')).style?.fontSize, 18);
      expect(tester.widget<Text>(find.text('1/3')).style?.fontSize, 14);
      final constrained = tester.widgetList<ConstrainedBox>(
        find.byType(ConstrainedBox),
      );
      expect(constrained.any((box) => box.constraints.maxWidth == 120), isTrue);
    });

    testWidgets('导航操作样式由 TDesign token 控制且禁用态可辨识', (tester) async {
      final token = TThemeData.defaultData();
      await open(
        tester,
        app(
          onShow: (context) {
            TImageViewer.show(
              context: context,
              images: images,
              showDelete: true,
            );
          },
        ),
      );

      final buttons = tester.widgetList<IconButton>(find.byType(IconButton));
      final close = buttons.singleWhere((button) => button.tooltip == 'Close');
      final delete = buttons.singleWhere(
        (button) => button.tooltip == 'Delete',
      );
      expect(
        close.style?.foregroundColor?.resolve(const {}),
        token.textColorAnti,
      );
      expect(
        delete.style?.foregroundColor?.resolve(const {WidgetState.disabled}),
        token.fontWhColor4,
      );
      expect(
        close.style?.overlayColor?.resolve(const {WidgetState.pressed}),
        token.fontWhColor4,
      );
      expect(
        close.style?.minimumSize?.resolve(const {}),
        Size.square(token.spacer40),
      );
      expect(
        close.style?.padding?.resolve(const {}),
        EdgeInsets.all(token.spacer8),
      );
      expect(close.style?.iconSize?.resolve(const {}), token.spacer24);
      expect(close.style?.shape?.resolve(const {}), isA<CircleBorder>());
    });

    testWidgets('空标签不渲染标签文本', (tester) async {
      await open(
        tester,
        app(
          onShow: (context) {
            TImageViewer.show(
              context: context,
              images: images,
              labels: const ['', '', ''],
            );
          },
        ),
      );
      expect(find.text('1/3'), findsOneWidget);
    });
  });

  group('contracts', () {
    testWidgets('拒绝空图片、越界索引和标签长度不匹配', (tester) async {
      late BuildContext context;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (value) {
              context = value;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(
        () => TImageViewer.show(context: context, images: const []),
        throwsArgumentError,
      );
      expect(
        () => TImageViewer.show(
          context: context,
          images: images,
          initialIndex: 3,
        ),
        throwsRangeError,
      );
      expect(
        () => TImageViewer.show(
          context: context,
          images: images,
          labels: const ['one'],
        ),
        throwsArgumentError,
      );
      expect(
        () => TImageViewer.show(
          context: context,
          images: images,
          autoplayInterval: Duration.zero,
        ),
        throwsArgumentError,
      );
    });
  });

  group('TImageViewerThemeData', () {
    const a = TImageViewerThemeData(
      backgroundColor: Colors.white,
      appBarBackgroundColor: Colors.red,
      iconColor: Colors.green,
      labelStyle: TextStyle(fontSize: 10),
      indexStyle: TextStyle(fontSize: 11),
      viewerWidth: 100,
      viewerHeight: 200,
    );
    const b = TImageViewerThemeData(
      backgroundColor: Colors.black,
      appBarBackgroundColor: Colors.blue,
      iconColor: Colors.yellow,
      labelStyle: TextStyle(fontSize: 20),
      indexStyle: TextStyle(fontSize: 21),
      viewerWidth: 200,
      viewerHeight: 400,
    );

    test('copyWith 覆盖并保留全部字段', () {
      final unchanged = a.copyWith();
      expect(unchanged.backgroundColor, a.backgroundColor);
      expect(unchanged.appBarBackgroundColor, a.appBarBackgroundColor);
      expect(unchanged.iconColor, a.iconColor);
      expect(unchanged.labelStyle, a.labelStyle);
      expect(unchanged.indexStyle, a.indexStyle);
      expect(unchanged.viewerWidth, a.viewerWidth);
      expect(unchanged.viewerHeight, a.viewerHeight);
      final value = a.copyWith(
        backgroundColor: Colors.red,
        appBarBackgroundColor: Colors.green,
        iconColor: Colors.blue,
        labelStyle: const TextStyle(fontSize: 12),
        indexStyle: const TextStyle(fontSize: 13),
        viewerWidth: 120,
        viewerHeight: 220,
      );
      expect(value.backgroundColor, Colors.red);
      expect(value.appBarBackgroundColor, Colors.green);
      expect(value.iconColor, Colors.blue);
      expect(value.labelStyle?.fontSize, 12);
      expect(value.indexStyle?.fontSize, 13);
      expect(value.viewerWidth, 120);
      expect(value.viewerHeight, 220);
    });

    test('lerp 插值全部视觉字段', () {
      final value = a.lerp(b, 0.5);
      expect(value.backgroundColor, isNotNull);
      expect(value.appBarBackgroundColor, isNotNull);
      expect(value.iconColor, isNotNull);
      expect(value.labelStyle?.fontSize, 15);
      expect(value.indexStyle?.fontSize, 16);
      expect(value.viewerWidth, 150);
      expect(value.viewerHeight, 300);
      expect(a.lerp(null, 0.5), same(a));
    });
  });
}
