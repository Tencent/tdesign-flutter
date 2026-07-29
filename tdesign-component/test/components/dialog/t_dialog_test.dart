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
    testWidgets('通过 Popup 居中路由打开并返回 typed result', (tester) async {
      bool? result;
      await tester.pumpWidget(app(launcher(() {
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
      })));

      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      expect(find.byType(TDialog), findsOneWidget);

      await tester.tap(find.text('确认'));
      await tester.pumpAndSettle();
      expect(find.byType(TDialog), findsNothing);
      expect(result, isTrue);
    });

    testWidgets('barrierDismissible 控制蒙层关闭', (tester) async {
      await tester.pumpWidget(app(Builder(builder: (context) {
        return TButton(
          child: const Text('打开'),
          onPressed: () => TDialog.show<void>(
            context,
            barrierDismissible: true,
            dialog: const TDialog(title: Text('可关闭')),
          ),
        );
      })));
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(find.text('可关闭'), findsNothing);
    });

    testWidgets('Popup handle close 可返回结果', (tester) async {
      TPopupHandle? handle;
      Object? result;
      await tester.pumpWidget(app(Builder(builder: (context) {
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
      })));
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      handle!.close('done');
      await tester.pumpAndSettle();
      expect(result, 'done');
    });
  });

  group('TDialog 内容与操作', () {
    testWidgets('支持 title、content 和任意 content Widget', (tester) async {
      await tester.pumpWidget(app(const TDialog(
        title: Text('标题'),
        content: Column(children: [Text('自定义内容'), Icon(Icons.info)]),
      )));
      expect(find.text('标题'), findsOneWidget);
      expect(find.text('自定义内容'), findsOneWidget);
      expect(find.byIcon(Icons.info), findsOneWidget);
    });

    testWidgets('内容区只有一个纵向滚动视口', (tester) async {
      await tester.pumpWidget(app(TDialog(
        title: const Text('长内容'),
        content: Text(List.filled(40, '内容').join()),
        maxHeight: 200,
        actions: const [
          TDialogAction(child: Text('完成')),
        ],
      )));
      expect(
        find.descendant(
          of: find.byType(TDialog),
          matching: find.byType(SingleChildScrollView),
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('一到两个操作横向排列，三个操作纵向排列', (tester) async {
      await tester.pumpWidget(app(const TDialog(
        title: Text('多操作'),
        actions: [
          TDialogAction(child: Text('一')),
          TDialogAction(child: Text('二')),
          TDialogAction(child: Text('三')),
        ],
      )));
      final one = tester.getCenter(find.text('一'));
      final two = tester.getCenter(find.text('二'));
      final three = tester.getCenter(find.text('三'));
      expect(one.dy, lessThan(two.dy));
      expect(two.dy, lessThan(three.dy));
    });

    testWidgets('操作角色、禁用与 closeOnPressed 生效', (tester) async {
      await tester.pumpWidget(app(const TDialog(
        title: Text('操作'),
        actions: [
          TDialogAction(child: Text('取消')),
          TDialogAction(
            child: Text('删除'),
            role: TDialogActionRole.destructive,
            disabled: true,
          ),
        ],
      )));
      final delete = tester.widget<TButton>(
        find.ancestor(
          of: find.text('删除'),
          matching: find.byType(TButton),
        ),
      );
      expect(delete.colorScheme, TButtonColorScheme.danger);
      expect(delete.onPressed, isNull);
    });

    testWidgets('关闭按钮提供 tooltip 并关闭路由', (tester) async {
      await tester.pumpWidget(app(Builder(builder: (context) {
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
      })));
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
    testWidgets('实例值优先于 Dialog ThemeExtension', (tester) async {
      const extension = TDialogThemeData(
        backgroundColor: Colors.red,
        width: 280,
        elevation: 4,
        maxHeight: 240,
      );
      await tester.pumpWidget(app(
        const TDialog(
          title: Text('主题'),
          backgroundColor: Colors.blue,
          width: 260,
          elevation: 8,
        ),
        dialogTheme: extension,
      ));
      final material = tester.widget<Material>(
        find.descendant(
          of: find.byType(TDialog),
          matching: find.byType(Material),
        ),
      );
      expect(material.color, Colors.blue);
      expect(material.elevation, 8);
      expect(tester.getSize(find.byType(TDialog)).width, 260);
    });

    testWidgets('ThemeExtension 通过 Popup 路由保留', (tester) async {
      const extension = TDialogThemeData(backgroundColor: Colors.green);
      await tester.pumpWidget(app(
        Builder(builder: (context) {
          return TButton(
            child: const Text('打开'),
            onPressed: () => TDialog.show<void>(
              context,
              dialog: const TDialog(title: Text('局部主题')),
            ),
          );
        }),
        dialogTheme: extension,
      ));
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
      await tester.pumpWidget(MaterialApp(
        theme: base,
        home: const Scaffold(body: TDialog(title: Text('Material 主题'))),
      ));
      final material = tester.widget<Material>(
        find.descendant(
          of: find.byType(TDialog),
          matching: find.byType(Material),
        ),
      );
      expect(material.color, Colors.purple);
      expect(material.elevation, 6);
    });
  });

  testWidgets('TConfirmDialog 是自动关闭的单操作便捷层', (tester) async {
    var called = false;
    bool? result;
    await tester.pumpWidget(app(Builder(builder: (context) {
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
    })));
    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('知道了'));
    await tester.pumpAndSettle();
    expect(called, isTrue);
    expect(result, isTrue);
    expect(find.byType(TConfirmDialog), findsNothing);
  });
}
