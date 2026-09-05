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
      const item = TDrawerItem();
      expect(item.title, null);
      expect(item.icon, null);
      expect(item.content, null);
    });

    test('带参数构造', () {
      const icon = Icon(Icons.add);
      const content = Text('自定义');
      const item = TDrawerItem(title: '标题', icon: icon, content: content);
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
      expect(data.titleStyle, null);
      expect(data.titlePadding, null);
      expect(data.itemTextStyle, null);
      expect(data.itemBackgroundColor, null);
      expect(data.itemPressedColor, null);
      expect(data.itemPadding, null);
      expect(data.itemIconColor, null);
      expect(data.itemIconSize, null);
      expect(data.itemIconGap, null);
      expect(data.dividerColor, null);
      expect(data.dividerIndent, null);
      expect(data.dividerThickness, null);
      expect(data.footerPadding, null);
    });

    test('带参数构造', () {
      const data = TDrawerThemeData(
        width: 300,
        backgroundColor: Colors.red,
        itemIconSize: 20,
        itemIconGap: 4,
      );
      expect(data.width, 300);
      expect(data.backgroundColor, Colors.red);
      expect(data.itemIconSize, 20);
      expect(data.itemIconGap, 4);
    });

    test('copyWith', () {
      const data = TDrawerThemeData(width: 280);
      final copied = data.copyWith(width: 320, backgroundColor: Colors.blue);
      expect(copied.width, 320);
      expect(copied.backgroundColor, Colors.blue);
      expect(copied.itemIconSize, null);
    });

    test('copyWith and lerp cover remaining fields', () {
      const base = TDrawerThemeData(
        width: 280,
        backgroundColor: Colors.red,
        titleStyle: TextStyle(fontWeight: FontWeight.w500),
        titlePadding: EdgeInsets.all(4),
        itemTextStyle: TextStyle(fontWeight: FontWeight.w400),
        itemBackgroundColor: Colors.black,
        itemPressedColor: Colors.grey,
        itemPadding: EdgeInsets.all(8),
        itemIconColor: Colors.orange,
        itemIconSize: 20,
        itemIconGap: 4,
        dividerColor: Colors.white,
        dividerIndent: 8,
        dividerThickness: 1,
        footerPadding: EdgeInsets.only(bottom: 12),
      );
      final copied = base.copyWith(
        titleStyle: const TextStyle(fontWeight: FontWeight.w600),
        titlePadding: const EdgeInsets.all(8),
        itemTextStyle: const TextStyle(fontWeight: FontWeight.w500),
        itemBackgroundColor: Colors.green,
        itemPressedColor: Colors.blue,
        itemPadding: const EdgeInsets.all(12),
        itemIconColor: Colors.purple,
        itemIconSize: 24,
        itemIconGap: 8,
        dividerColor: Colors.yellow,
        dividerIndent: 16,
        dividerThickness: 2,
        footerPadding: const EdgeInsets.only(bottom: 20),
      );
      expect(copied.titleStyle?.fontWeight, FontWeight.w600);
      expect(copied.titlePadding, const EdgeInsets.all(8));
      expect(copied.itemTextStyle?.fontWeight, FontWeight.w500);
      expect(copied.itemBackgroundColor, Colors.green);
      expect(copied.itemPressedColor, Colors.blue);
      expect(copied.itemPadding, const EdgeInsets.all(12));
      expect(copied.itemIconColor, Colors.purple);
      expect(copied.itemIconSize, 24);
      expect(copied.itemIconGap, 8);
      expect(copied.dividerColor, Colors.yellow);
      expect(copied.dividerIndent, 16);
      expect(copied.dividerThickness, 2);
      expect(copied.footerPadding, const EdgeInsets.only(bottom: 20));

      const other = TDrawerThemeData(
        width: 320,
        backgroundColor: Colors.blue,
        titleStyle: TextStyle(fontWeight: FontWeight.w700),
        titlePadding: EdgeInsets.all(12),
        itemTextStyle: TextStyle(fontWeight: FontWeight.w600),
        itemBackgroundColor: Colors.white,
        itemPressedColor: Colors.black,
        itemPadding: EdgeInsets.all(16),
        itemIconColor: Colors.blue,
        itemIconSize: 28,
        itemIconGap: 12,
        dividerColor: Colors.black,
        dividerIndent: 24,
        dividerThickness: 3,
        footerPadding: EdgeInsets.only(bottom: 28),
      );
      final lerped = base.lerp(other, 0.5);
      expect(lerped.width, 300);
      expect(lerped.titleStyle?.fontWeight, FontWeight.w600);
      expect(lerped.titlePadding, const EdgeInsets.all(8));
      expect(lerped.itemTextStyle?.fontWeight, FontWeight.w500);
      expect(lerped.itemBackgroundColor, isNotNull);
      expect(lerped.itemPressedColor, isNotNull);
      expect(lerped.itemPadding, const EdgeInsets.all(12));
      expect(lerped.itemIconColor, isNotNull);
      expect(lerped.itemIconSize, 24);
      expect(lerped.itemIconGap, 8);
      expect(lerped.dividerColor, isNotNull);
      expect(lerped.dividerIndent, 16);
      expect(lerped.dividerThickness, 2);
      expect(lerped.footerPadding, const EdgeInsets.only(bottom: 20));
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
          const TDrawerWidget(
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
      expect(title.style?.fontSize, 16);
      expect(title.style?.fontWeight, FontWeight.w400);
    });

    testWidgets('默认 item title 长文案保持单行省略', (tester) async {
      const longTitle = '这是一个非常非常长的抽屉菜单标题用于验证不溢出';
      await tester.pumpWidget(
        wrapWithTheme(
          const TDrawerWidget(
            width: 120,
            items: [TDrawerItem(title: longTitle)],
          ),
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
        textTheme: baseTheme.textTheme.copyWith(bodyLarge: globalStyle),
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: globalTheme,
          home: const Scaffold(
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
          home: const Scaffold(
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
          const TDrawerWidget(
            title: Text('标题'),
            items: [TDrawerItem(title: '菜单1')],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('标题'), findsOneWidget);
    });

    testWidgets('默认标题、菜单、图标、分隔线和底部尺寸对齐设计', (tester) async {
      const footerKey = Key('metrics-footer');
      await tester.pumpWidget(
        wrapWithTheme(
          const TDrawerWidget(
            title: Text('标题'),
            items: [
              TDrawerItem(title: '菜单1', icon: Icon(Icons.apps)),
              TDrawerItem(title: '菜单2'),
            ],
            footer: Text('底部', key: footerKey),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final titlePadding = tester.widget<Padding>(
        find
            .ancestor(of: find.text('标题'), matching: find.byType(Padding))
            .first,
      );
      expect(titlePadding.padding, const EdgeInsets.fromLTRB(16, 24, 16, 8));

      final itemContainer = tester.widget<Container>(
        find
            .ancestor(of: find.text('菜单1'), matching: find.byType(Container))
            .first,
      );
      expect(itemContainer.padding, const EdgeInsets.fromLTRB(16, 16, 0, 16));
      final iconTheme = tester.widget<IconTheme>(
        find
            .ancestor(
              of: find.byIcon(Icons.apps),
              matching: find.byType(IconTheme),
            )
            .first,
      );
      expect(iconTheme.data.size, 24);
      expect(iconTheme.data.color, TThemeData.defaultData().textColorPrimary);
      expect(
        find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.width == 8,
        ),
        findsOneWidget,
      );

      expect(find.byType(Divider), findsNWidgets(2));
      final divider = tester.widget<Divider>(find.byType(Divider).first);
      expect(divider.indent, 16);
      expect(divider.thickness, 0.5);

      final footerContainer = tester.widget<Container>(
        find
            .ancestor(
              of: find.byKey(footerKey),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(footerContainer.padding, const EdgeInsets.only(bottom: 20));
    });

    testWidgets('bordered 和 isShowLastBordered 由组件实例控制', (tester) async {
      const items = [TDrawerItem(title: '菜单1'), TDrawerItem(title: '菜单2')];
      await tester.pumpWidget(
        wrapWithTheme(const TDrawerWidget(items: items, bordered: false)),
      );
      expect(find.byType(Divider), findsNothing);

      await tester.pumpWidget(
        wrapWithTheme(
          const TDrawerWidget(items: items, isShowLastBordered: false),
        ),
      );
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('按压反馈可关闭且使用 Drawer Theme 色', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TDrawerWidget(
            items: const [TDrawerItem(title: '菜单1')],
            onItemClick: (_, __) {},
          ),
          drawerTheme: const TDrawerThemeData(
            itemBackgroundColor: Colors.white,
            itemPressedColor: Colors.purple,
          ),
        ),
      );
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('菜单1')),
      );
      await tester.pump(const Duration(milliseconds: 100));
      var itemContainer = tester.widget<Container>(
        find
            .ancestor(of: find.text('菜单1'), matching: find.byType(Container))
            .first,
      );
      expect(itemContainer.color, Colors.purple);
      await gesture.up();
      await tester.pump();

      await tester.pumpWidget(
        wrapWithTheme(
          TDrawerWidget(
            enableFeedback: false,
            items: const [TDrawerItem(title: '菜单1')],
            onItemClick: (_, __) {},
          ),
          drawerTheme: const TDrawerThemeData(
            itemBackgroundColor: Colors.white,
            itemPressedColor: Colors.purple,
          ),
        ),
      );
      final noFeedbackGesture = await tester.startGesture(
        tester.getCenter(find.text('菜单1')),
      );
      await tester.pump(const Duration(milliseconds: 100));
      itemContainer = tester.widget<Container>(
        find
            .ancestor(of: find.text('菜单1'), matching: find.byType(Container))
            .first,
      );
      expect(itemContainer.color, Colors.white);
      await noFeedbackGesture.up();
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
          const TDrawerWidget(
            footer: Text('底部', key: footerKey),
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
          const TDrawerWidget(
            child: Text('自定义', key: childKey),
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
            items: const [TDrawerItem(title: '菜单1')],
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
    testWidgets('公开参数默认值稳定', (tester) async {
      late BuildContext drawerContext;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              drawerContext = context;
              return const SizedBox();
            },
          ),
        ),
      );

      final drawer = TDrawer(drawerContext);
      expect(drawer.closeOnOverlayClick, isTrue);
      expect(drawer.placement, TDrawerPlacement.right);
      expect(drawer.showOverlay, isTrue);
      expect(drawer.useSafeArea, isTrue);
      expect(drawer.destroyOnClose, isFalse);
    });

    testWidgets('非法宽度和顶部距离会失败', (tester) async {
      late BuildContext drawerContext;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              drawerContext = context;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(() => TDrawer(drawerContext, width: 0), throwsAssertionError);
      expect(() => TDrawer(drawerContext, drawerTop: -1), throwsAssertionError);
    });

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
                      items: [const TDrawerItem(title: '菜单1')],
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
                      items: [const TDrawerItem(title: '菜单1')],
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
                      items: [const TDrawerItem(title: '菜单1')],
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
                    TDrawer(
                      context,
                      items: [const TDrawerItem(title: '菜单1')],
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
                      items: [const TDrawerItem(title: '菜单1')],
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
                      items: [const TDrawerItem(title: '左抽屉')],
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
      expect(tester.getTopLeft(find.byType(TDrawerWidget)).dx, 0);
    });

    testWidgets('默认 placement 从右侧打开', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          theme: fullTheme(),
          home: Scaffold(
            body: Builder(
              builder: (context) => TButton(
                child: const Text('打开'),
                onPressed: () => TDrawer(
                  context,
                  items: const [TDrawerItem(title: '右抽屉')],
                ).show(),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(find.byType(TDrawerWidget)).dx, 95);
      expect(tester.getSize(find.byType(TDrawerWidget)).width, 280);
    });

    testWidgets('点击蒙层会回调，但可配置为不关闭', (tester) async {
      var overlayClicks = 0;
      var closed = false;
      TDrawerHandle? handle;
      await tester.pumpWidget(
        MaterialApp(
          theme: fullTheme(),
          home: Scaffold(
            body: Builder(
              builder: (context) => TButton(
                child: const Text('打开'),
                onPressed: () {
                  handle = TDrawer(
                    context,
                    closeOnOverlayClick: false,
                    onOverlayClick: () => overlayClicks++,
                    onClose: () => closed = true,
                    items: const [TDrawerItem(title: '菜单1')],
                  ).show();
                },
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(overlayClicks, 1);
      expect(closed, isFalse);
      expect(handle?.isShowing, isTrue);
      expect(find.text('菜单1'), findsOneWidget);

      handle?.close();
      await tester.pumpAndSettle();
      expect(closed, isTrue);
    });

    testWidgets('destroyOnClose 关闭路由状态保留', (tester) async {
      bool? maintainState;
      await tester.pumpWidget(
        MaterialApp(
          theme: fullTheme(),
          home: Scaffold(
            body: Builder(
              builder: (context) => TButton(
                child: const Text('打开'),
                onPressed: () => TDrawer(
                  context,
                  destroyOnClose: true,
                  child: Builder(
                    builder: (context) {
                      maintainState = ModalRoute.of(context)?.maintainState;
                      return const Text('内容');
                    },
                  ),
                ).show(),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      expect(maintainState, isFalse);
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
                      items: [const TDrawerItem(title: '无遮罩')],
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
                      items: [const TDrawerItem(title: '菜单1')],
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
