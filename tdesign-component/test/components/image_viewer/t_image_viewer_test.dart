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
        app(onShow: (context) {
          TImageViewer.show(
            context: context,
            images: images,
            labels: const ['A', 'B', 'C'],
            initialIndex: 1,
          );
        }),
      );

      expect(find.byType(TSwiper), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('2 / 3'), findsOneWidget);
    });

    testWidgets('默认页码样式来自全局 token', (tester) async {
      final token = TThemeData.defaultData();
      await open(
        tester,
        app(onShow: (context) {
          TImageViewer.show(context: context, images: images);
        }),
      );

      final index = tester.widget<Text>(find.text('1 / 3'));
      expect(index.style?.color, token.textColorAnti);
      expect(index.style?.fontSize, token.fontBodyExtraSmall?.size);
    });

    testWidgets('关闭按钮通知并关闭 Dialog', (tester) async {
      var closed = false;
      await open(
        tester,
        app(onShow: (context) {
          TImageViewer.show(
            context: context,
            images: images,
            onClose: () => closed = true,
          );
        }),
      );

      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
      expect(closed, isTrue);
      expect(find.byType(TSwiper), findsNothing);
    });

    testWidgets('showClose=false 隐藏关闭按钮', (tester) async {
      await open(
        tester,
        app(onShow: (context) {
          TImageViewer.show(
            context: context,
            images: images,
            showClose: false,
          );
        }),
      );
      expect(find.byTooltip('Close'), findsNothing);
    });

    testWidgets('删除只通知索引且不修改图片列表', (tester) async {
      int? deleted;
      await open(
        tester,
        app(onShow: (context) {
          TImageViewer.show(
            context: context,
            images: images,
            initialIndex: 1,
            showDelete: true,
            onDelete: (index) => deleted = index,
          );
        }),
      );

      await tester.tap(find.byTooltip('Delete'));
      expect(deleted, 1);
      expect(
          tester.widget<TSwiper>(find.byType(TSwiper)).children, hasLength(3));
    });

    testWidgets('没有 onDelete 时删除按钮禁用', (tester) async {
      await open(
        tester,
        app(onShow: (context) {
          TImageViewer.show(
            context: context,
            images: images,
            showDelete: true,
          );
        }),
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
        app(onShow: (context) {
          TImageViewer.show(
            context: context,
            images: images,
            leadingBuilder: (_, index) => Text('L$index'),
            trailingBuilder: (_, index) => Text('R$index'),
          );
        }),
      );
      expect(find.text('L0'), findsOneWidget);
      expect(find.text('R0'), findsOneWidget);
      expect(find.byTooltip('Close'), findsNothing);
    });

    testWidgets('showIndex=false 且无标签时标题为空', (tester) async {
      await open(
        tester,
        app(onShow: (context) {
          TImageViewer.show(
            context: context,
            images: images,
            showIndex: false,
          );
        }),
      );
      expect(find.text('1 / 3'), findsNothing);
    });

    testWidgets('滑动更新临时索引并通知外部', (tester) async {
      int? changed;
      await open(
        tester,
        app(onShow: (context) {
          TImageViewer.show(
            context: context,
            images: images,
            onIndexChanged: (index) => changed = index,
          );
        }),
      );
      await tester.drag(find.byType(PageView), const Offset(-500, 0));
      await tester.pumpAndSettle();
      expect(changed, 1);
      expect(find.text('2 / 3'), findsOneWidget);
    });

    testWidgets('图片点击和长按通知当前项', (tester) async {
      int? tapped;
      int? longPressed;
      await open(
        tester,
        app(onShow: (context) {
          TImageViewer.show(
            context: context,
            images: images,
            onTap: (index) => tapped = index,
            onLongPress: (index) => longPressed = index,
          );
        }),
      );
      final page = find.byKey(const ValueKey('image-viewer-page-0'));
      await tester.tap(page);
      await tester.longPress(page);
      expect(tapped, 0);
      expect(longPressed, 0);
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
            barrierColor: Colors.black,
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
      expect(tester.widget<Text>(find.text('1 / 3')).style?.fontSize, 14);
      final constrained = tester.widgetList<ConstrainedBox>(
        find.byType(ConstrainedBox),
      );
      expect(constrained.any((box) => box.constraints.maxWidth == 120), isTrue);
    });

    testWidgets('空标签不渲染标签文本', (tester) async {
      await open(
        tester,
        app(onShow: (context) {
          TImageViewer.show(
            context: context,
            images: images,
            labels: const ['', '', ''],
          );
        }),
      );
      expect(find.text('1 / 3'), findsOneWidget);
    });
  });

  group('contracts', () {
    testWidgets('拒绝空图片、越界索引和标签长度不匹配', (tester) async {
      late BuildContext context;
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (value) {
          context = value;
          return const SizedBox.shrink();
        }),
      ));
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
      barrierColor: Colors.black,
      viewerWidth: 100,
      viewerHeight: 200,
    );
    const b = TImageViewerThemeData(
      backgroundColor: Colors.black,
      appBarBackgroundColor: Colors.blue,
      iconColor: Colors.yellow,
      labelStyle: TextStyle(fontSize: 20),
      indexStyle: TextStyle(fontSize: 21),
      barrierColor: Colors.white,
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
      expect(unchanged.barrierColor, a.barrierColor);
      expect(unchanged.viewerWidth, a.viewerWidth);
      expect(unchanged.viewerHeight, a.viewerHeight);
      final value = a.copyWith(
        backgroundColor: Colors.red,
        appBarBackgroundColor: Colors.green,
        iconColor: Colors.blue,
        labelStyle: const TextStyle(fontSize: 12),
        indexStyle: const TextStyle(fontSize: 13),
        barrierColor: Colors.yellow,
        viewerWidth: 120,
        viewerHeight: 220,
      );
      expect(value.backgroundColor, Colors.red);
      expect(value.appBarBackgroundColor, Colors.green);
      expect(value.iconColor, Colors.blue);
      expect(value.labelStyle?.fontSize, 12);
      expect(value.indexStyle?.fontSize, 13);
      expect(value.barrierColor, Colors.yellow);
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
      expect(value.barrierColor, isNotNull);
      expect(value.viewerWidth, 150);
      expect(value.viewerHeight, 300);
      expect(a.lerp(null, 0.5), same(a));
    });
  });
}
