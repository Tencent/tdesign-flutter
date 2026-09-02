import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  ThemeData theme([TDialogThemeData? dialogTheme]) {
    final base = TThemeBuilder.light(TThemeData.defaultData());
    if (dialogTheme == null) {
      return base;
    }
    return base.mergeExtension(dialogTheme);
  }

  Widget app(Widget child, {TDialogThemeData? dialogTheme}) {
    return MaterialApp(
      theme: theme(dialogTheme),
      home: Scaffold(body: child),
    );
  }

  Widget launcher(BuildContext Function()? callback) {
    return Builder(
      builder: (context) => TButton(
        onPressed: callback == null ? null : () => callback(),
        child: const Text('打开'),
      ),
    );
  }

  group('TDialog 路由与结果', () {
    testWidgets('通过居中模态路由打开并返回 typed result', (tester) async {
      bool? result;
      await tester.pumpWidget(
        app(
          launcher(() {
            TDialog.show<bool>(
              tester.element(find.text('打开')),
              dialog: const TDialog(
                title: Text('确认操作'),
                actions: [
                  TDialogAction(
                    child: Text('确认'),
                    role: TDialogActionRole.primary,
                    result: true,
                  ),
                ],
              ),
            ).then((value) => result = value);
            return tester.element(find.text('打开'));
          }),
        ),
      );

      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      expect(find.byType(TDialog), findsOneWidget);
      expect(tester.getSize(find.byType(TDialog)).width, 311);
      expect(tester.getSize(find.byType(TDialog)).height, isNot(240));
      expect(
        find.ancestor(
          of: find.byType(TDialog),
          matching: find.byType(SafeArea),
        ),
        findsOneWidget,
      );
      expect(
        ModalRoute.of(tester.element(find.byType(TDialog)))?.transitionDuration,
        const Duration(milliseconds: 240),
      );

      await tester.tap(find.text('确认'));
      await tester.pumpAndSettle();
      expect(find.byType(TDialog), findsNothing);
      expect(result, isTrue);
    });

    testWidgets('barrierDismissible 控制蒙层关闭', (tester) async {
      await tester.pumpWidget(
        app(
          Builder(
            builder: (context) {
              return TButton(
                child: const Text('打开'),
                onPressed: () => TDialog.show<void>(
                  context,
                  barrierDismissible: true,
                  dialog: const TDialog(title: Text('可关闭')),
                ),
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(find.text('可关闭'), findsNothing);
    });

    testWidgets('Popup handle close 可返回结果', (tester) async {
      TPopupHandle? handle;
      Object? result;
      await tester.pumpWidget(
        app(
          Builder(
            builder: (context) {
              return TButton(
                child: const Text('打开'),
                onPressed: () {
                  handle = TPopup.show(
                    context,
                    options: TPopupOptions.center(
                      child: const Text('Popup 内容'),
                      closeBuilder: null,
                    ),
                  );
                  handle!.result.then((value) => result = value);
                },
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      handle!.close('done');
      await tester.pumpAndSettle();
      expect(result, 'done');
    });

    testWidgets('内容自适应不继承 Popup centerSize 固定尺寸', (tester) async {
      final base = theme();
      await tester.pumpWidget(
        MaterialApp(
          theme: base.mergeExtension(
            const TPopupThemeData(centerSize: Size(100, 100)),
          ),
          home: Scaffold(
            body: Builder(
              builder: (context) => TButton(
                child: const Text('打开'),
                onPressed: () => TDialog.show<void>(
                  context,
                  dialog: const TDialog(title: Text('自适应尺寸')),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();

      expect(tester.getSize(find.byType(TDialog)).width, 311);
      expect(tester.takeException(), isNull);
    });
  });

  group('TDialog 内容与操作', () {
    testWidgets('支持 title、content 和任意 content Widget', (tester) async {
      await tester.pumpWidget(
        app(
          const TDialog(
            title: Text('标题'),
            content: Column(children: [Text('自定义内容'), Icon(Icons.info)]),
          ),
        ),
      );
      expect(find.text('标题'), findsOneWidget);
      expect(find.text('自定义内容'), findsOneWidget);
      expect(find.byIcon(Icons.info), findsOneWidget);
    });

    testWidgets('内容区只有一个纵向滚动视口', (tester) async {
      await tester.pumpWidget(
        app(
          TDialog(
            title: const Text('长内容'),
            content: Text(List.filled(40, '内容').join()),
            maxHeight: 200,
            actions: const [TDialogAction(child: Text('完成'))],
          ),
        ),
      );
      expect(
        find.descendant(
          of: find.byType(TDialog),
          matching: find.byType(SingleChildScrollView),
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('一到两个操作横向排列，三个操作按主操作优先纵向排列', (tester) async {
      await tester.pumpWidget(
        app(
          const TDialog(
            title: Text('多操作'),
            actions: [
              TDialogAction(child: Text('一')),
              TDialogAction(child: Text('二'), role: TDialogActionRole.primary),
              TDialogAction(child: Text('三')),
            ],
          ),
        ),
      );
      final one = tester.getCenter(find.text('一'));
      final two = tester.getCenter(find.text('二'));
      final three = tester.getCenter(find.text('三'));
      expect(two.dy, lessThan(one.dy));
      expect(one.dy, lessThan(three.dy));
    });

    testWidgets('三个普通操作纵向排列时保持声明顺序', (tester) async {
      await tester.pumpWidget(
        app(
          const TDialog(
            title: Text('多操作'),
            actions: [
              TDialogAction(child: Text('一')),
              TDialogAction(child: Text('二')),
              TDialogAction(child: Text('三')),
            ],
          ),
        ),
      );
      final one = tester.getCenter(find.text('一'));
      final two = tester.getCenter(find.text('二'));
      final three = tester.getCenter(find.text('三'));
      expect(one.dy, lessThan(two.dy));
      expect(two.dy, lessThan(three.dy));
    });

    testWidgets('文字操作使用贴边 56dp Footer 和分隔线', (tester) async {
      await tester.pumpWidget(
        app(
          const TDialog(
            title: Text('文字操作'),
            actions: [
              TDialogAction(child: Text('取消'), variant: TButtonVariant.text),
              TDialogAction(
                child: Text('确定'),
                role: TDialogActionRole.primary,
                variant: TButtonVariant.text,
              ),
            ],
          ),
        ),
      );

      final dialog = tester.getRect(find.byType(TDialog));
      final title = tester.getRect(find.text('文字操作'));
      final cancel = tester.getRect(find.widgetWithText(TButton, '取消'));
      final confirm = tester.getRect(find.widgetWithText(TButton, '确定'));
      expect(cancel.left, closeTo(dialog.left, 0.01));
      expect(confirm.right, closeTo(dialog.right, 0.01));
      expect(cancel.height, 56);
      expect(confirm.height, 56);
      expect(cancel.top - title.bottom, closeTo(32, 0.01));
      expect(cancel.right, lessThan(confirm.left));
    });

    testWidgets('操作角色、禁用与 closeOnPressed 生效', (tester) async {
      await tester.pumpWidget(
        app(
          const TDialog(
            title: Text('操作'),
            actions: [
              TDialogAction(child: Text('取消')),
              TDialogAction(
                child: Text('删除'),
                role: TDialogActionRole.destructive,
                disabled: true,
              ),
            ],
          ),
        ),
      );
      final delete = tester.widget<TButton>(
        find.ancestor(of: find.text('删除'), matching: find.byType(TButton)),
      );
      expect(delete.colorScheme, TButtonColorScheme.danger);
      expect(delete.onPressed, isNull);
    });

    testWidgets('关闭按钮提供 tooltip 并关闭路由', (tester) async {
      await tester.pumpWidget(
        app(
          Builder(
            builder: (context) {
              return TButton(
                child: const Text('打开'),
                onPressed: () => TDialog.show<void>(
                  context,
                  dialog: const TDialog(
                    title: Text('带关闭按钮'),
                    showCloseButton: true,
                  ),
                ),
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      final close = tester.widget<IconButton>(find.byType(IconButton));
      expect(close.tooltip, isNotEmpty);
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      expect(find.text('带关闭按钮'), findsNothing);
    });
  });

  group('TDialog 主题', () {
    testWidgets('默认标题与正文样式继承应用字体', (tester) async {
      final base = theme();
      const family = 'Test Primary Font';
      const fallback = 'Test CJK Fallback';
      await tester.pumpWidget(
        MaterialApp(
          theme: base.copyWith(
            textTheme: base.textTheme.apply(
              fontFamily: family,
              fontFamilyFallback: const [fallback],
            ),
          ),
          home: const Scaffold(
            body: TDialog(title: Text('标题'), content: Text('正文')),
          ),
        ),
      );

      final titleStyle = DefaultTextStyle.of(
        tester.element(find.text('标题')),
      ).style;
      final contentStyle = DefaultTextStyle.of(
        tester.element(find.text('正文')),
      ).style;
      expect(titleStyle.fontFamily, family);
      expect(contentStyle.fontFamily, family);
      expect(titleStyle.fontFamilyFallback, contains(fallback));
      expect(contentStyle.fontFamilyFallback, contains(fallback));
    });

    test('ThemeData merge/copyWith/lerp 保留所有公开字段', () {
      const base = TDialogThemeData(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        elevation: 2,
        titleTextStyle: TextStyle(fontSize: 16),
        contentTextStyle: TextStyle(fontSize: 14),
        contentPadding: EdgeInsets.all(16),
        maxHeight: 240,
        actionButtonStyle: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(Colors.red),
        ),
        width: 280,
      );
      const override = TDialogThemeData(
        backgroundColor: Colors.blue,
        elevation: 6,
        titleTextStyle: TextStyle(fontSize: 20),
        contentPadding: EdgeInsets.all(24),
        width: 320,
      );

      expect(identical(base.merge(null), base), isTrue);
      final merged = base.merge(override);
      expect(merged.backgroundColor, Colors.blue);
      expect(merged.shape, base.shape);
      expect(merged.elevation, 6);
      expect(merged.titleTextStyle, override.titleTextStyle);
      expect(merged.contentTextStyle, base.contentTextStyle);
      expect(merged.contentPadding, override.contentPadding);
      expect(merged.maxHeight, base.maxHeight);
      expect(merged.actionButtonStyle, base.actionButtonStyle);
      expect(merged.width, 320);

      final copied = base.copyWith(
        backgroundColor: Colors.green,
        shape: const StadiumBorder(),
        elevation: 4,
        titleTextStyle: const TextStyle(fontSize: 18),
        contentTextStyle: const TextStyle(fontSize: 15),
        contentPadding: const EdgeInsets.all(20),
        maxHeight: 300,
        actionButtonStyle: const ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(Colors.green),
        ),
        width: 300,
      );
      expect(copied.backgroundColor, Colors.green);
      expect(copied.shape, const StadiumBorder());
      expect(copied.elevation, 4);
      expect(copied.titleTextStyle?.fontSize, 18);
      expect(copied.contentTextStyle?.fontSize, 15);
      expect(copied.contentPadding, const EdgeInsets.all(20));
      expect(copied.maxHeight, 300);
      expect(copied.actionButtonStyle, isNotNull);
      expect(copied.width, 300);

      final unchanged = base.copyWith();
      expect(unchanged.backgroundColor, base.backgroundColor);
      expect(unchanged.shape, base.shape);
      expect(unchanged.elevation, base.elevation);
      expect(unchanged.titleTextStyle, base.titleTextStyle);
      expect(unchanged.contentTextStyle, base.contentTextStyle);
      expect(unchanged.contentPadding, base.contentPadding);
      expect(unchanged.maxHeight, base.maxHeight);
      expect(unchanged.actionButtonStyle, base.actionButtonStyle);
      expect(unchanged.width, base.width);

      final interpolated = base.lerp(copied, 0.5);
      expect(
        interpolated.backgroundColor,
        Color.lerp(Colors.red, Colors.green, 0.5),
      );
      expect(interpolated.elevation, 3);
      expect(interpolated.titleTextStyle?.fontSize, 17);
      expect(interpolated.contentTextStyle?.fontSize, 14.5);
      expect(interpolated.contentPadding, const EdgeInsets.all(18));
      expect(interpolated.maxHeight, 270);
      expect(interpolated.actionButtonStyle, isNotNull);
      expect(interpolated.width, 290);
      expect(TDialogThemeData.lerpDouble(null, null, 0.5), isNull);
    });

    testWidgets('实例值优先于 Dialog ThemeExtension', (tester) async {
      const extension = TDialogThemeData(
        backgroundColor: Colors.red,
        width: 280,
        elevation: 4,
        maxHeight: 240,
      );
      await tester.pumpWidget(
        app(
          const TDialog(
            title: Text('主题'),
            backgroundColor: Colors.blue,
            width: 260,
            elevation: 8,
          ),
          dialogTheme: extension,
        ),
      );
      final material = tester
          .widgetList<Material>(
            find.descendant(
              of: find.byType(TDialog),
              matching: find.byType(Material),
            ),
          )
          .firstWhere((widget) => widget.shape is RoundedRectangleBorder);
      expect(material.color, Colors.blue);
      expect(material.elevation, 8);
      expect(tester.getSize(find.byType(TDialog)).width, 260);
    });

    testWidgets('ThemeExtension 通过模态路由保留', (tester) async {
      const extension = TDialogThemeData(backgroundColor: Colors.green);
      await tester.pumpWidget(
        app(
          Builder(
            builder: (context) {
              return TButton(
                child: const Text('打开'),
                onPressed: () => TDialog.show<void>(
                  context,
                  dialog: const TDialog(title: Text('局部主题')),
                ),
              );
            },
          ),
          dialogTheme: extension,
        ),
      );
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      final material = tester.widget<Material>(
        find.descendant(
          of: find.byType(TDialog),
          matching: find.byType(Material),
        ),
      );
      expect(material.color, Colors.green);
    });

    testWidgets('Material DialogTheme 是 Extension 缺失时的兜底', (tester) async {
      final base = theme().copyWith(
        dialogTheme: const DialogThemeData(
          backgroundColor: Colors.purple,
          elevation: 6,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: base,
          home: const Scaffold(body: TDialog(title: Text('Material 主题'))),
        ),
      );
      final material = tester.widget<Material>(
        find.descendant(
          of: find.byType(TDialog),
          matching: find.byType(Material),
        ),
      );
      expect(material.color, Colors.purple);
      expect(material.elevation, 6);
    });

    testWidgets('默认内容顶边距与关闭按钮位置对齐官方基线', (tester) async {
      await tester.pumpWidget(
        app(const TDialog(title: Text('像素对齐'), showCloseButton: true)),
      );

      final scrollView = tester.widget<SingleChildScrollView>(
        find.descendant(
          of: find.byType(TDialog),
          matching: find.byType(SingleChildScrollView),
        ),
      );
      expect(scrollView.padding, const EdgeInsets.fromLTRB(24, 24, 24, 0));

      final positioned = tester.widget<Positioned>(
        find.ancestor(
          of: find.byType(IconButton),
          matching: find.byType(Positioned),
        ),
      );
      expect(positioned.top, 8);
      expect(positioned.right, 8);
    });

    testWidgets('默认间距与圆角跟随 TDesign token', (tester) async {
      final tokens = TThemeData.defaultData().copyWithTThemeData(
        'dialog-token-test',
        radiusMap: {'radiusExtraLarge': 20},
        marginMap: {
          'spacer8': 10,
          'spacer12': 14,
          'spacer24': 30,
          'spacer32': 40,
        },
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(tokens),
          home: const Scaffold(
            body: TDialog(
              title: Text('Token 标题'),
              content: Text('Token 内容'),
              showCloseButton: true,
              actions: [
                TDialogAction(child: Text('取消'), variant: TButtonVariant.text),
                TDialogAction(
                  child: Text('确定'),
                  role: TDialogActionRole.primary,
                  variant: TButtonVariant.text,
                ),
              ],
            ),
          ),
        ),
      );

      final scrollView = tester.widget<SingleChildScrollView>(
        find.descendant(
          of: find.byType(TDialog),
          matching: find.byType(SingleChildScrollView),
        ),
      );
      expect(scrollView.padding, const EdgeInsets.fromLTRB(30, 30, 30, 0));

      final material = tester
          .widgetList<Material>(
            find.descendant(
              of: find.byType(TDialog),
              matching: find.byType(Material),
            ),
          )
          .firstWhere((widget) => widget.shape is RoundedRectangleBorder);
      expect(
        material.shape,
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      );

      final closePosition = tester.widget<Positioned>(
        find.ancestor(
          of: find.byType(IconButton),
          matching: find.byType(Positioned),
        ),
      );
      expect(closePosition.top, 10);
      expect(closePosition.right, 10);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Padding &&
              widget.padding == const EdgeInsets.only(top: 40),
        ),
        findsOneWidget,
      );
    });

    testWidgets('极小视口与自定义间距 token 不会生成负约束', (tester) async {
      final tokens = TThemeData.defaultData().copyWithTThemeData(
        'dialog-small-viewport-test',
        marginMap: {'spacer32': 40},
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(tokens),
          home: const MediaQuery(
            data: MediaQueryData(size: Size(20, 20)),
            child: Scaffold(body: TDialog(title: SizedBox.shrink())),
          ),
        ),
      );

      final constrainedBox = tester
          .widgetList<ConstrainedBox>(
            find.descendant(
              of: find.byType(TDialog),
              matching: find.byType(ConstrainedBox),
            ),
          )
          .firstWhere((widget) => widget.constraints.maxWidth == 0);
      expect(constrainedBox.constraints.maxHeight, 0);
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('TConfirmDialog 是自动关闭的单操作便捷层', (tester) async {
    var called = false;
    bool? result;
    await tester.pumpWidget(
      app(
        Builder(
          builder: (context) {
            return TButton(
              child: const Text('打开'),
              onPressed: () {
                TDialog.show<bool>(
                  context,
                  dialog: TConfirmDialog(
                    title: '确认',
                    onPressed: () => called = true,
                  ),
                ).then((value) => result = value);
              },
            );
          },
        ),
      ),
    );
    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('知道了'));
    await tester.pumpAndSettle();
    expect(called, isTrue);
    expect(result, isTrue);
    expect(find.byType(TConfirmDialog), findsNothing);
  });
}
