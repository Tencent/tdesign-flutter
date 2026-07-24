import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/dialog/t_dialog_widget.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TDialog V1.0 Widget 测试
///
/// E 类控制：`showDialog()` 调用即显；不调即不显。
/// 覆盖 TConfirmDialog 标题/内容/按钮/关闭、TDialogButtonOptions。
void main() {
  ThemeData fullTheme() => TThemeBuilder.light(TThemeData.defaultData());

  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child) {
    return MaterialApp(
      theme: fullTheme(),
      home: Scaffold(body: child),
    );
  }

  /// 辅助：构建一个带按钮的页面，点击按钮显示 Dialog
  Widget wrapWithButton(VoidCallback onButtonTap, {String btnText = '显示弹窗'}) {
    return MaterialApp(
      theme: fullTheme(),
      home: Scaffold(
        body: Center(
          child: TButton(child: Text(btnText), onPressed: onButtonTap),
        ),
      ),
    );
  }

  // ============================================================
  // E 类控制：showDialog 调用即显
  // ============================================================
  group('TConfirmDialog E 类控制（showDialog）', () {
    testWidgets('点击按钮调用 showDialog 后弹窗出现', (tester) async {
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => const TConfirmDialog(
            title: '弹窗标题',
            content: '弹窗内容',
            buttonText: '确认',
          ),
        );
      }));

      // 初始无弹窗
      expect(find.text('弹窗标题'), findsNothing);

      // 点击按钮显示弹窗
      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();
      expect(find.text('弹窗标题'), findsOneWidget);
      expect(find.text('弹窗内容'), findsOneWidget);
    });

    testWidgets('不调用 showDialog 时不显示弹窗', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const Center(child: Text('页面内容')),
      ));
      expect(find.byType(TConfirmDialog), findsNothing);
    });

    testWidgets('点击确认按钮关闭弹窗', (tester) async {
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => const TConfirmDialog(
            title: '确认弹窗',
            buttonText: '确认',
          ),
        );
      }));

      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();
      expect(find.text('确认弹窗'), findsOneWidget);

      // 点击确认按钮
      await tester.tap(find.text('确认'));
      await tester.pumpAndSettle();
      expect(find.text('确认弹窗'), findsNothing);
    });

    testWidgets('onPressed 回调触发', (tester) async {
      var confirmed = false;
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => TConfirmDialog(
            title: '回调弹窗',
            buttonText: '确认',
            onPressed: () => confirmed = true,
          ),
        );
      }));

      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();

      await tester.tap(find.text('确认'));
      await tester.pumpAndSettle();
      expect(confirmed, isTrue);
    });
  });

  // ============================================================
  // TConfirmDialog 内容
  // ============================================================
  group('TConfirmDialog 内容', () {
    testWidgets('title 显示标题', (tester) async {
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => const TConfirmDialog(title: '标题测试'),
        );
      }));

      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();
      expect(find.text('标题测试'), findsOneWidget);
    });

    testWidgets('content 显示内容文字', (tester) async {
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => const TConfirmDialog(
            title: '标题',
            content: '这是内容文字',
          ),
        );
      }));

      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();
      expect(find.text('这是内容文字'), findsOneWidget);
    });

    testWidgets('contentWidget 自定义内容组件', (tester) async {
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => const TConfirmDialog(
            title: '标题',
            contentWidget: Text('自定义内容'),
          ),
        );
      }));

      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();
      expect(find.text('自定义内容'), findsOneWidget);
    });

    testWidgets('buttonText 显示按钮文字', (tester) async {
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => const TConfirmDialog(
            title: '标题',
            buttonText: '好的',
          ),
        );
      }));

      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();
      expect(find.text('好的'), findsOneWidget);
    });

    testWidgets('showCloseButton=true 显示关闭按钮', (tester) async {
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => const TConfirmDialog(
            title: '标题',
            showCloseButton: true,
          ),
        );
      }));

      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();
      // 关闭按钮图标
      expect(find.byIcon(TIcons.close), findsOneWidget);
    });

    testWidgets('点击关闭按钮关闭弹窗', (tester) async {
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => const TConfirmDialog(
            title: '关闭测试',
            showCloseButton: true,
          ),
        );
      }));

      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(TIcons.close));
      await tester.pumpAndSettle();
      expect(find.text('关闭测试'), findsNothing);
    });
  });

  // ============================================================
  // TConfirmDialog 样式
  // ============================================================
  group('TConfirmDialog 样式', () {
    testWidgets('default scaffold and text styles use token visual defaults',
        (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => const TConfirmDialog(
            title: '默认标题',
            content: '默认内容',
            showCloseButton: true,
          ),
        );
      }));

      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();

      final scaffold = tester.widget<Container>(_dialogScaffoldFinder());
      expect(scaffold.constraints?.minWidth, 311);
      expect(scaffold.constraints?.maxWidth, 311);
      final decoration = scaffold.decoration! as BoxDecoration;
      expect(decoration.color, token.bgColorContainer);
      expect(decoration.borderRadius, BorderRadius.circular(12));

      final title = tester.widget<TText>(_tTextFinder('默认标题'));
      expect(title.textColor, token.textColorPrimary);
      expect(title.style?.fontWeight, token.fontTitleLarge?.fontWeight);
      expect(title.style?.fontSize, token.fontTitleLarge?.size);
      expect(title.style?.height, token.fontTitleLarge?.height);
      expect(title.textAlign, TextAlign.center);

      final content = tester.widget<TText>(_tTextFinder('默认内容'));
      expect(content.textColor, token.textColorSecondary);
      expect(content.style?.fontWeight, token.fontBodyLarge?.fontWeight);
      expect(content.style?.fontSize, token.fontBodyLarge?.size);
      expect(content.style?.height, token.fontBodyLarge?.height);
      expect(content.textAlign, TextAlign.center);

      final closeIcon = tester.widget<Icon>(find.byIcon(TIcons.close));
      expect(closeIcon.size, 22);
      expect(closeIcon.color, token.textColorPlaceholder);
    });

    testWidgets(
        'dialog theme extension applies title content and button styles',
        (tester) async {
      final dialogTheme = TDialogThemeData(
        titleTextStyle: const TextStyle(
          fontSize: 20,
          height: 30 / 20,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: const TextStyle(
          fontSize: 15,
          height: 22 / 15,
          fontWeight: FontWeight.w400,
        ),
        contentPadding: const EdgeInsets.fromLTRB(10, 20, 30, 40),
        actionButtonStyle: TextButton.styleFrom(
          minimumSize: const Size(88, 44),
        ),
      );

      await tester.pumpWidget(MaterialApp(
        theme: fullTheme().copyWith(
          extensions: <ThemeExtension<dynamic>>[dialogTheme],
        ),
        home: const Scaffold(
          body: TConfirmDialog(
            title: '主题标题',
            content: '主题内容',
            buttonText: '确认',
          ),
        ),
      ));

      final title = tester.widget<TText>(_tTextFinder('主题标题'));
      expect(title.style, dialogTheme.titleTextStyle);

      final content = tester.widget<TText>(_tTextFinder('主题内容'));
      expect(content.style, dialogTheme.contentTextStyle);

      final paddingContainer = tester.widget<Container>(
        find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.padding == dialogTheme.contentPadding,
        ),
      );
      expect(paddingContainer.padding, dialogTheme.contentPadding);

      final dialogButton = tester.widget<TDialogButton>(
        find.byWidgetPredicate(
          (widget) => widget is TDialogButton && widget.buttonText == '确认',
        ),
      );
      expect(dialogButton.buttonStyle, dialogTheme.actionButtonStyle);
    });

    testWidgets('backgroundColor 自定义背景色', (tester) async {
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => const TConfirmDialog(
            title: '背景色',
            backgroundColor: Colors.yellow,
          ),
        );
      }));

      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();
      expect(find.text('背景色'), findsOneWidget);
      final scaffold = tester.widget<Container>(_dialogScaffoldFinder());
      final decoration = scaffold.decoration! as BoxDecoration;
      expect(decoration.color, Colors.yellow);
    });

    testWidgets('buttonStyle: text 文字按钮样式', (tester) async {
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => const TConfirmDialog(
            title: '文字按钮',
            buttonText: '确认',
            buttonStyle: TDialogButtonStyle.text,
          ),
        );
      }));

      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();
      expect(find.text('确认'), findsOneWidget);
      final dialogButton = tester.widget<TDialogButton>(
        find.byWidgetPredicate(
          (widget) => widget is TDialogButton && widget.buttonText == '确认',
        ),
      );
      expect(dialogButton.buttonVariant, TButtonVariant.text);
      expect(dialogButton.buttonColorScheme, TButtonColorScheme.primary);
      expect(dialogButton.height, 56);
    });

    testWidgets('radius 自定义圆角', (tester) async {
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => const TConfirmDialog(
            title: '圆角',
            radius: 20,
          ),
        );
      }));

      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();
      expect(find.text('圆角'), findsOneWidget);
      final scaffold = tester.widget<Container>(_dialogScaffoldFinder());
      final decoration = scaffold.decoration! as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(20));
    });

    testWidgets('width 自定义宽度', (tester) async {
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => const TConfirmDialog(
            title: '宽度',
            width: 280,
          ),
        );
      }));

      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();
      expect(find.text('宽度'), findsOneWidget);
      final scaffold = tester.widget<Container>(_dialogScaffoldFinder());
      expect(scaffold.constraints?.minWidth, 280);
      expect(scaffold.constraints?.maxWidth, 280);
    });
  });

  group('TDialogButtonOptions', () {
    test('构造并读取字段', () {
      final opt = TDialogButtonOptions(
        title: '确定',
        onPressed: () {},
        titleColor: Colors.red,
      );
      expect(opt.title, '确定');
      expect(opt.titleColor, Colors.red);
    });
  });

  group('TConfirmDialog 扩展', () {
    testWidgets('buttonWidget 自定义按钮渲染', (tester) async {
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => const TConfirmDialog(
            title: '标题',
            buttonWidget: Text('自定义按钮'),
          ),
        );
      }));
      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();
      expect(find.text('自定义按钮'), findsOneWidget);
    });

    testWidgets('contentMaxHeight>0 生效', (tester) async {
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => const TConfirmDialog(
            title: '标题',
            content: '内容',
            contentMaxHeight: 100,
          ),
        );
      }));
      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();
      expect(find.text('内容'), findsOneWidget);
    });

    testWidgets('无 onPressed 点击按钮关闭弹窗', (tester) async {
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => const TConfirmDialog(
            title: '关闭标题',
            buttonText: '确认关闭',
          ),
        );
      }));
      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();
      expect(find.text('确认关闭'), findsOneWidget);
      await tester.tap(find.text('确认关闭'));
      await tester.pumpAndSettle();
      expect(find.text('确认关闭'), findsNothing);
    });

    testWidgets('buttonStyle=text + onPressed 触发回调', (tester) async {
      var pressed = false;
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => TConfirmDialog(
            title: '标题',
            content: '内容',
            buttonStyle: TDialogButtonStyle.text,
            onPressed: () => pressed = true,
          ),
        );
      }));
      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();
      // 点击按钮触发 onPressed
      await tester.tap(find.text('知道了'));
      await tester.pumpAndSettle();
      expect(pressed, isTrue);
    });

    testWidgets('buttonStyle=text 无 onPressed 走 Navigator.pop', (tester) async {
      await tester.pumpWidget(wrapWithButton(() {
        showDialog(
          context: tester.element(find.byType(TButton)),
          builder: (context) => const TConfirmDialog(
            title: '标题',
            content: '内容',
            buttonStyle: TDialogButtonStyle.text,
          ),
        );
      }));
      await tester.tap(find.byType(TButton));
      await tester.pumpAndSettle();
      // 点击按钮触发 Navigator.pop
      await tester.tap(find.text('知道了'));
      await tester.pumpAndSettle();
      expect(find.text('标题'), findsNothing);
    });
  });

  group('TDialog 多按钮', () {
    testWidgets('HorizontalNormalButtons 左右按钮点击', (tester) async {
      var left = false;
      var right = false;
      await tester.pumpWidget(MaterialApp(
        theme: fullTheme(),
        home: Scaffold(
          body: HorizontalNormalButtons(
            leftBtn:
                TDialogButtonOptions(title: '左', onPressed: () => left = true),
            rightBtn:
                TDialogButtonOptions(title: '右', onPressed: () => right = true),
          ),
        ),
      ));
      await tester.tap(find.text('左'));
      await tester.pump();
      await tester.tap(find.text('右'));
      await tester.pump();
      expect(left, isTrue);
      expect(right, isTrue);
    });

    testWidgets('HorizontalTextButtons 左右文字按钮点击', (tester) async {
      var left = false;
      var right = false;
      await tester.pumpWidget(MaterialApp(
        theme: fullTheme(),
        home: Scaffold(
          body: HorizontalTextButtons(
            leftBtn:
                TDialogButtonOptions(title: '左', onPressed: () => left = true),
            rightBtn:
                TDialogButtonOptions(title: '右', onPressed: () => right = true),
          ),
        ),
      ));
      await tester.tap(find.text('左'));
      await tester.pump();
      await tester.tap(find.text('右'));
      await tester.pump();
      expect(left, isTrue);
      expect(right, isTrue);
    });
  });
}

Finder _dialogScaffoldFinder() {
  return find.byWidgetPredicate(
    (widget) =>
        widget is Container &&
        widget.decoration is BoxDecoration &&
        widget.constraints?.maxWidth != null,
  );
}

Finder _tTextFinder(String data) {
  return find.byWidgetPredicate(
    (widget) => widget is TText && widget.data == data,
  );
}
