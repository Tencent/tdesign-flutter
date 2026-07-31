import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  ThemeData fullTheme({TDrawerThemeData? drawerTheme}) {
    var theme = TThemeBuilder.light(TThemeData.defaultData());
    if (drawerTheme != null) {
      theme = theme.mergeExtension(drawerTheme);
    }
    return theme;
  }

  Widget wrapWithTheme(Widget child, {TDrawerThemeData? drawerTheme}) {
    return MaterialApp(
      theme: fullTheme(drawerTheme: drawerTheme),
      home: Scaffold(body: child),
    );
  }

  Container drawerContainer(WidgetTester tester, {Color? color}) {
    return tester.widget<Container>(
      find.byWidgetPredicate((widget) {
        if (widget is! Container) {
          return false;
        }
        if (widget.constraints?.hasBoundedHeight != true ||
            widget.constraints?.hasBoundedWidth != true) {
          return false;
        }
        if (color != null && widget.color != color) {
          return false;
        }
        return true;
      }),
    );
  }

  group('TDrawerItem', () {
    test('默认构造', () {
      final item = TDrawerItem();
      expect(item.title, null);
      expect(item.icon, null);
      expect(item.content, null);
    });

    test('带参数构造', () {
      const icon = Icon(Icons.add);
      const content = Text('自定义');
      final item = TDrawerItem(title: '标题', icon: icon, content: content);
      expect(item.title, '标题');
      expect(item.icon, icon);
      expect(item.content, content);
    });
  });

  group('TDrawerThemeData', () {
    test('默认构造', () {
      const data = TDrawerThemeData();
      expect(data.width, null);
      expect(data.backgroundColor, null);
      expect(data.bordered, null);
      expect(data.isShowLastBordered, null);
      expect(data.hover, null);
      expect(data.titleStyle, null);
      expect(data.itemTextStyle, null);
      expect(data.itemBackgroundColor, null);
      expect(data.itemPressedColor, null);
      expect(data.itemPadding, null);
      expect(data.dividerColor, null);
    });

    test('带参数构造', () {
      const data = TDrawerThemeData(
        width: 300,
        backgroundColor: Colors.red,
        bordered: false,
        isShowLastBordered: false,
        hover: false,
      );
      expect(data.width, 300);
      expect(data.backgroundColor, Colors.red);
      expect(data.bordered, false);
      expect(data.isShowLastBordered, false);
      expect(data.hover, false);
    });

    test('copyWith', () {
      const data = TDrawerThemeData(width: 280);
      final copied = data.copyWith(width: 320, backgroundColor: Colors.blue);
      expect(copied.width, 320);
      expect(copied.backgroundColor, Colors.blue);
      expect(copied.bordered, null);
    });

    test('copyWith and lerp cover remaining fields', () {
      const base = TDrawerThemeData(
        width: 280,
        drawerTop: 12,
        backgroundColor: Colors.red,
        bordered: true,
        isShowLastBordered: true,
        hover: true,
        titleStyle: TextStyle(fontWeight: FontWeight.w500),
        itemTextStyle: TextStyle(fontWeight: FontWeight.w400),
        itemBackgroundColor: Colors.black,
        itemPressedColor: Colors.grey,
        itemPadding: EdgeInsets.all(8),
        dividerColor: Colors.white,
      );
      final copied = base.copyWith(
        drawerTop: 24,
        bordered: false,
        hover: false,
        titleStyle: const TextStyle(fontWeight: FontWeight.w600),
        itemTextStyle: const TextStyle(fontWeight: FontWeight.w500),
        itemBackgroundColor: Colors.green,
        itemPressedColor: Colors.blue,
        itemPadding: const EdgeInsets.all(12),
        dividerColor: Colors.yellow,
      );
      expect(copied.drawerTop, 24);
      expect(copied.bordered, false);
      expect(copied.hover, false);
      expect(copied.titleStyle?.fontWeight, FontWeight.w600);
      expect(copied.itemTextStyle?.fontWeight, FontWeight.w500);
      expect(copied.itemBackgroundColor, Colors.green);
      expect(copied.itemPressedColor, Colors.blue);
      expect(copied.itemPadding, const EdgeInsets.all(12));
      expect(copied.dividerColor, Colors.yellow);

      const other = TDrawerThemeData(
        width: 320,
        drawerTop: 20,
        backgroundColor: Colors.blue,
        bordered: false,
        isShowLastBordered: false,
        hover: false,
        titleStyle: TextStyle(fontWeight: FontWeight.w700),
        itemTextStyle: TextStyle(fontWeight: FontWeight.w600),
        itemBackgroundColor: Colors.white,
        itemPressedColor: Colors.black,
        itemPadding: EdgeInsets.all(16),
        dividerColor: Colors.black,
      );
      final lerped = base.lerp(other, 0.5);
      expect(lerped.width, 300);
      expect(lerped.drawerTop, 16);
      expect(lerped.bordered, false);
      expect(lerped.hover, false);
      expect(lerped.titleStyle?.fontWeight, FontWeight.w600);
      expect(lerped.itemTextStyle?.fontWeight, FontWeight.w500);
      expect(lerped.itemBackgroundColor, isNotNull);
      expect(lerped.itemPressedColor, isNotNull);
      expect(lerped.itemPadding, const EdgeInsets.all(12));
      expect(lerped.dividerColor, isNotNull);
    });

    test('lerp', () {
      const data1 = TDrawerThemeData(width: 280, backgroundColor: Colors.red);
      const data2 = TDrawerThemeData(width: 320, backgroundColor: Colors.blue);
      final lerped = data1.lerp(data2, 0.5);
      expect(lerped.width, 300);
    });

    test('lerp 非 TDrawerThemeData 返回自身', () {
      const data = TDrawerThemeData(width: 280);
      final lerped = data.lerp(null, 0.5);
      expect(lerped, same(data));
    });
  });

  group('TDrawerWidget', () {
    testWidgets('使用 child 渲染自定义内容', (tester) async {
      const testKey = Key('custom-child');
      await tester.pumpWidget(
        wrapWithTheme(const TDrawerWidget(child: Text('自定义内容', key: testKey))),
      );
      expect(find.byKey(testKey), findsOneWidget);
    });

    testWidgets('纵向无界时使用页面视口高度', (tester) async {
      tester.view.physicalSize = const Size(400, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        wrapWithTheme(
          const SingleChildScrollView(
            child: TDrawerWidget(child: SizedBox.expand()),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(TDrawerWidget)).height, 640);
    });

    testWidgets('有界时填满父级高度', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(
            height: 240,
            child: TDrawerWidget(child: SizedBox.expand()),
          ),
        ),
      );

      expect(tester.getSize(find.byType(TDrawerWidget)).height, 240);
    });

    testWidgets('使用 items 渲染列表项', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TDrawerWidget(
            items: [
              TDrawerItem(title: '菜单1'),
              TDrawerItem(title: '菜单2'),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('菜单1'), findsOneWidget);
      expect(find.text('菜单2'), findsOneWidget);
      expect(find.byType(TText), findsNWidgets(2));
      expect(find.byType(TCell), findsNothing);
      expect(find.byType(TCellGroup), findsNothing);

      final title = tester.widget<Text>(find.text('菜单1'));
      expect(title.style?.fontSize, 14);
      expect(title.style?.fontWeight, FontWeight.w400);
    });

    testWidgets('默认 item title 长文案保持单行省略', (tester) async {
      const longTitle = '这是一个非常非常长的抽屉菜单标题用于验证不溢出';
      await tester.pumpWidget(
        wrapWithTheme(
          TDrawerWidget(width: 120, items: [TDrawerItem(title: longTitle)]),
        ),
      );
      await tester.pumpAndSettle();

      final title = tester.widget<Text>(find.text(longTitle));
      expect(title.maxLines, 1);
      expect(title.overflow, TextOverflow.ellipsis);
    });

    testWidgets('菜单正文继承全局 TextTheme，并由 Drawer Theme 覆盖', (tester) async {
      const globalStyle = TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.w500,
      );
      final baseTheme = fullTheme();
      final globalTheme = baseTheme.copyWith(
        textTheme: baseTheme.textTheme.copyWith(bodyMedium: globalStyle),
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: globalTheme,
          home: Scaffold(
            body: TDrawerWidget(items: [TDrawerItem(title: '菜单1')]),
          ),
        ),
      );
      await tester.pumpAndSettle();

      var title = tester.widget<Text>(find.text('菜单1'));
      expect(title.style?.color, globalStyle.color);
      expect(title.style?.fontWeight, globalStyle.fontWeight);

      const drawerStyle = TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.w600,
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: globalTheme.mergeExtension(
            const TDrawerThemeData(itemTextStyle: drawerStyle),
          ),
          home: Scaffold(
            body: TDrawerWidget(items: [TDrawerItem(title: '菜单1')]),
          ),
        ),
      );
      await tester.pumpAndSettle();

      title = tester.widget<Text>(find.text('菜单1'));
      expect(title.style?.color, drawerStyle.color);
      expect(title.style?.fontWeight, drawerStyle.fontWeight);
    });

    testWidgets('使用 title 渲染标题', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TDrawerWidget(
            title: const Text('标题'),
            items: [TDrawerItem(title: '菜单1')],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('标题'), findsOneWidget);
    });

    testWidgets('标题使用 Drawer ThemeData 且不继承外层调试前景色', (tester) async {
      const titleStyle = TextStyle(
        color: Colors.blue,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: fullTheme(
            drawerTheme: const TDrawerThemeData(titleStyle: titleStyle),
          ),
          home: Scaffold(
            body: DefaultTextStyle(
              style: TextStyle(foreground: Paint()..color = Colors.red),
              child: const TDrawerWidget(title: TText('标题'), items: []),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final title = tester.widget<Text>(find.text('标题'));
      expect(title.style?.color, Colors.blue);
      expect(title.style?.foreground, isNull);
      expect(title.style?.fontWeight, FontWeight.w600);
    });

    testWidgets('使用 footer 渲染底部', (tester) async {
      const footerKey = Key('footer');
      await tester.pumpWidget(
        wrapWithTheme(
          TDrawerWidget(
            footer: const Text('底部', key: footerKey),
            items: [TDrawerItem(title: '菜单1')],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(footerKey), findsOneWidget);
    });

    testWidgets('child 优先级高于 items', (tester) async {
      const childKey = Key('child');
      await tester.pumpWidget(
        wrapWithTheme(
          TDrawerWidget(
            child: const Text('自定义', key: childKey),
            items: [TDrawerItem(title: '菜单1')],
          ),
        ),
      );
      expect(find.byKey(childKey), findsOneWidget);
      expect(find.text('菜单1'), findsNothing);
    });

    testWidgets('默认容器使用完整主题背景色和默认宽度', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(
        wrapWithTheme(const TDrawerWidget(child: SizedBox.expand())),
      );

      final container = drawerContainer(tester, color: token.bgColorContainer);
      expect(container.constraints?.maxWidth, 280);
      expect(container.color, token.bgColorContainer);
    });

    testWidgets('自定义宽度', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TDrawerWidget(width: 300, child: SizedBox.expand()),
        ),
      );
      final container = tester.widget<Container>(
        find
            .ancestor(
              of: find.byType(SizedBox),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(container.constraints?.maxWidth, 300);
    });

    testWidgets('构造器背景色覆盖默认主题背景色', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TDrawerWidget(
            backgroundColor: Colors.yellow,
            child: SizedBox.expand(),
          ),
        ),
      );

      final container = drawerContainer(tester, color: Colors.yellow);
      expect(container.color, Colors.yellow);
    });

    testWidgets('直接使用组件时读取 Drawer ThemeData', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TDrawerWidget(child: SizedBox.expand()),
          drawerTheme: const TDrawerThemeData(
            width: 320,
            backgroundColor: Colors.green,
          ),
        ),
      );
      final container = drawerContainer(tester, color: Colors.green);
      expect(container.constraints?.maxWidth, 320);
    });

    testWidgets('点击列表项触发 onItemClick', (tester) async {
      int? clickedIndex;
      TDrawerItem? clickedItem;
      await tester.pumpWidget(
        wrapWithTheme(
          TDrawerWidget(
            items: [TDrawerItem(title: '菜单1')],
            onItemClick: (index, item) {
              clickedIndex = index;
              clickedItem = item;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('菜单1'));
      await tester.pumpAndSettle();
      expect(clickedIndex, 0);
      expect(clickedItem?.title, '菜单1');
    });
  });

  group('TDrawer', () {
    testWidgets('show 方法打开抽屉', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: fullTheme(),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return TButton(
                  child: const Text('打开'),
                  onPressed: () {
                    TDrawer(
                      context,
                      title: const TText('标题'),
                      items: [TDrawerItem(title: '菜单1')],
                    ).show();
                  },
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      expect(find.text('菜单1'), findsOneWidget);
      final title = tester.widget<Text>(find.text('标题'));
      expect(title.style?.color, fullTheme().textTheme.titleLarge?.color);
      expect(title.style?.foreground, isNull);
    });

    testWidgets('默认避让系统安全区', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(padding: EdgeInsets.only(top: 24)),
          child: MaterialApp(
            theme: fullTheme(),
            home: Scaffold(
              body: Builder(
                builder: (context) => TButton(
                  child: const Text('打开'),
                  onPressed: () {
                    TDrawer(context, child: const SizedBox.expand()).show();
                  },
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();

      expect(tester.getTopLeft(find.byType(TDrawerWidget)).dy, 24);
    });

    testWidgets('useSafeArea false 时不避让系统安全区', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(padding: EdgeInsets.only(top: 24)),
          child: MaterialApp(
            theme: fullTheme(),
            home: Scaffold(
              body: Builder(
                builder: (context) => TButton(
                  child: const Text('打开'),
                  onPressed: () {
                    TDrawer(
                      context,
                      useSafeArea: false,
                      child: const SizedBox.expand(),
                    ).show();
                  },
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();

      expect(tester.getTopLeft(find.byType(TDrawerWidget)).dy, 0);
    });

    testWidgets('show 返回 handle 并可关闭抽屉', (tester) async {
      TDrawerHandle? drawerHandle;
      await tester.pumpWidget(
        MaterialApp(
          theme: fullTheme(),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return TButton(
                  child: const Text('打开'),
                  onPressed: () {
                    final drawer = TDrawer(
                      context,
                      items: [TDrawerItem(title: '菜单1')],
                    );
                    drawerHandle = drawer.show();
                  },
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      expect(find.text('菜单1'), findsOneWidget);
      // 关闭
      drawerHandle?.close();
      await tester.pumpAndSettle();
      expect(find.text('菜单1'), findsNothing);
    });

    testWidgets('show 二次调用复用 handle 且 isShowing 可读', (tester) async {
      TDrawerHandle? first;
      TDrawerHandle? second;
      await tester.pumpWidget(
        MaterialApp(
          theme: fullTheme(),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return TButton(
                  child: const Text('打开'),
                  onPressed: () {
                    final drawer = TDrawer(
                      context,
                      items: [TDrawerItem(title: '菜单1')],
                    );
                    first ??= drawer.show();
                    second = drawer.show();
                  },
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      expect(first?.isShowing, isTrue);
      expect(second?.isShowing, isTrue);
    });

    testWidgets('使用 child 自定义内容', (tester) async {
      const childKey = Key('drawer-child');
      await tester.pumpWidget(
        MaterialApp(
          theme: fullTheme(),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return TButton(
                  child: const Text('打开'),
                  onPressed: () {
                    TDrawer(
                      context,
                      child: const Text('自定义内容', key: childKey),
                    ).show();
                  },
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      expect(find.byKey(childKey), findsOneWidget);
    });

    testWidgets('使用 mergeExtension 子树覆盖', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: fullTheme(
            drawerTheme: const TDrawerThemeData(
              width: 320,
              backgroundColor: Colors.yellow,
            ),
          ),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return TButton(
                  child: const Text('打开'),
                  onPressed: () {
                    TDrawer(context, items: [TDrawerItem(title: '菜单1')]).show();
                  },
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      expect(find.text('菜单1'), findsOneWidget);
      final container = drawerContainer(tester, color: Colors.yellow);
      expect(container.constraints?.maxWidth, 320);
      expect(container.color, Colors.yellow);
    });

    testWidgets('构造器参数优先级高于 Theme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: fullTheme(drawerTheme: const TDrawerThemeData(width: 320)),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return TButton(
                  child: const Text('打开'),
                  onPressed: () {
                    TDrawer(
                      context,
                      width: 250,
                      items: [TDrawerItem(title: '菜单1')],
                    ).show();
                  },
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      expect(find.text('菜单1'), findsOneWidget);
      final container = drawerContainer(tester);
      expect(container.constraints?.maxWidth, 250);
    });

    testWidgets('placement: left 从左侧打开', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: fullTheme(),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return TButton(
                  child: const Text('打开'),
                  onPressed: () {
                    TDrawer(
                      context,
                      placement: TDrawerPlacement.left,
                      items: [TDrawerItem(title: '左抽屉')],
                    ).show();
                  },
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      expect(find.text('左抽屉'), findsOneWidget);
    });

    testWidgets('showOverlay: false 不显示遮罩', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: fullTheme(),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return TButton(
                  child: const Text('打开'),
                  onPressed: () {
                    TDrawer(
                      context,
                      showOverlay: false,
                      items: [TDrawerItem(title: '无遮罩')],
                    ).show();
                  },
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      expect(find.text('无遮罩'), findsOneWidget);
    });

    testWidgets('onClose 回调触发', (tester) async {
      var closed = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: fullTheme(),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return TButton(
                  child: const Text('打开'),
                  onPressed: () {
                    TDrawer(
                      context,
                      onClose: () {
                        closed = true;
                      },
                      items: [TDrawerItem(title: '菜单1')],
                    ).show();
                  },
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      // 点击遮罩关闭
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(closed, true);
    });
  });

  group('TDrawerPlacement', () {
    test('枚举值', () {
      expect(TDrawerPlacement.values.length, 2);
      expect(TDrawerPlacement.values, contains(TDrawerPlacement.left));
      expect(TDrawerPlacement.values, contains(TDrawerPlacement.right));
    });
  });
}
