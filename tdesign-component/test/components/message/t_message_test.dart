import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(
    Widget child, {
    TMessageThemeData? messageTheme,
    Size mediaSize = const Size(375, 812),
    EdgeInsets mediaPadding = EdgeInsets.zero,
  }) {
    return MaterialApp(
      theme: messageTheme == null
          ? TThemeBuilder.light(TThemeData.defaultData())
          : TThemeBuilder.light(
              TThemeData.defaultData(),
            ).mergeExtension(messageTheme),
      home: MediaQuery(
        data: MediaQueryData(size: mediaSize, padding: mediaPadding),
        child: Scaffold(body: Stack(children: [child])),
      ),
    );
  }

  group('TMessage 渲染', () {
    testWidgets('基础内容与默认图标', (tester) async {
      await tester.pumpWidget(wrap(const TMessage(content: '消息')));
      await tester.pump();
      expect(find.text('消息'), findsOneWidget);
      expect(find.byIcon(TIcons.error_circle_filled), findsOneWidget);
    });

    testWidgets('visible=false 不渲染内容', (tester) async {
      await tester.pumpWidget(
        wrap(const TMessage(content: '隐藏', visible: false)),
      );
      expect(find.text('隐藏'), findsNothing);
    });

    testWidgets('四种语义色图标均可渲染', (tester) async {
      for (final variant in TMessageVariant.values) {
        await tester.pumpWidget(
          wrap(TMessage(content: variant.name, variant: variant)),
        );
        await tester.pump();
        expect(find.text(variant.name), findsOneWidget);
      }
    });

    testWidgets('可隐藏或自定义图标', (tester) async {
      await tester.pumpWidget(
        wrap(const TMessage(content: '无图标', showIcon: false, duration: null)),
      );
      expect(find.byType(Icon), findsNothing);

      await tester.pumpWidget(
        wrap(
          const TMessage(
            content: '自定义图标',
            icon: Icon(Icons.star),
            duration: null,
          ),
        ),
      );
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('链接配置与颜色覆盖生效', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        wrap(
          TMessage(
            content: '带链接',
            duration: null,
            link: TMessageLink(
              name: '详情',
              uri: Uri(path: '/detail'),
              color: Colors.red,
            ),
            onLinkPressed: () => pressed = true,
          ),
        ),
      );
      await tester.tap(find.text('详情'));
      expect(pressed, isTrue);
    });

    testWidgets('长内容配合链接和关闭按钮不应溢出', (tester) async {
      const longLink = '这是一个非常非常非常长的链接文案用于验证不会换行';
      await tester.pumpWidget(
        wrap(
          TMessage(
            content: '这是一段非常非常非常长的消息内容用于验证布局不会被撑坏',
            duration: null,
            showCloseButton: true,
            link: TMessageLink(
              name: longLink,
              uri: Uri(path: '/detail'),
            ),
          ),
        ),
      );

      final contentText = tester.widget<Text>(
        find.text('这是一段非常非常非常长的消息内容用于验证布局不会被撑坏'),
      );
      final linkText = tester.widget<Text>(find.text(longLink));
      expect(contentText.maxLines, 1);
      expect(contentText.overflow, TextOverflow.ellipsis);
      expect(linkText.maxLines, 1);
      expect(linkText.overflow, TextOverflow.ellipsis);
      expect(find.byIcon(TIcons.close), findsOneWidget);
    });

    testWidgets('窄屏时消息宽度收口到可用区域', (tester) async {
      await tester.pumpWidget(
        wrap(
          const TMessage(content: '窄屏消息', duration: null),
          mediaSize: const Size(320, 640),
        ),
      );

      final box = tester.widget<SizedBox>(
        find.byWidgetPredicate(
          (widget) =>
              widget is SizedBox && widget.height == 48 && widget.width == 288,
        ),
      );
      expect(box.width, 288);
      final positioned = tester.widget<AnimatedPositioned>(
        find.byType(AnimatedPositioned),
      );
      expect(positioned.left, 16);
    });

    testWidgets('关闭按钮完成关闭生命周期', (tester) async {
      var pressed = false;
      var dismissed = false;
      await tester.pumpWidget(
        wrap(
          TMessage(
            content: '可关闭',
            duration: null,
            showCloseButton: true,
            onCloseButtonPressed: () => pressed = true,
            onDismissed: () => dismissed = true,
          ),
        ),
      );
      await tester.tap(find.byIcon(TIcons.close));
      await tester.pump(const Duration(milliseconds: 300));
      expect(pressed, isTrue);
      expect(dismissed, isTrue);
      expect(find.text('可关闭'), findsNothing);
    });

    testWidgets('自定义关闭按钮生效', (tester) async {
      await tester.pumpWidget(
        wrap(
          const TMessage(
            content: '自定义关闭',
            duration: null,
            closeButton: Text('关闭'),
          ),
        ),
      );
      expect(find.text('关闭'), findsOneWidget);
      await tester.tap(find.text('关闭'));
      await tester.pump(const Duration(milliseconds: 300));
    });

    testWidgets('到时自动关闭并回调', (tester) async {
      var ended = false;
      await tester.pumpWidget(
        wrap(
          TMessage(
            content: '自动关闭',
            duration: const Duration(milliseconds: 100),
            onDurationEnd: () => ended = true,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 300));
      expect(ended, isTrue);
    });

    testWidgets('Theme 控制背景、形状、阴影与默认偏移', (tester) async {
      await tester.pumpWidget(
        wrap(
          const TMessage(content: '主题', duration: null),
          messageTheme: const TMessageThemeData(
            backgroundColor: Colors.yellow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            elevation: 2,
            defaultOffset: Offset(20, 40),
          ),
        ),
      );
      await tester.pump();
      final material = tester.widget<Material>(find.byType(Material).last);
      expect(material.color, Colors.yellow);
      expect(material.elevation, 2);
      final positioned = tester.widget<AnimatedPositioned>(
        find.byType(AnimatedPositioned),
      );
      // 343 宽消息在 375 宽屏幕中最多只能位于 left=16，安全区会收口
      // Theme 提供的期望坐标，避免右侧越出可视区域。
      expect(positioned.left, 16);
      expect(positioned.top, 40);
    });

    testWidgets('默认位置仅在与顶部安全区冲突时调整', (tester) async {
      await tester.pumpWidget(
        wrap(
          const TMessage(content: '默认安全位置', duration: null),
          mediaPadding: const EdgeInsets.only(top: 44),
        ),
      );
      await tester.pump();
      var positioned = tester.widget<AnimatedPositioned>(
        find.byType(AnimatedPositioned),
      );
      expect(positioned.top, 80);

      await tester.pumpWidget(
        wrap(
          const TMessage(content: '更高安全区', duration: null),
          mediaPadding: const EdgeInsets.only(top: 100),
        ),
      );
      positioned = tester.widget<AnimatedPositioned>(
        find.byType(AnimatedPositioned),
      );
      expect(positioned.top, 100);
    });

    testWidgets('显式 offset 被钳制在四侧安全可视区域内', (tester) async {
      await tester.pumpWidget(
        wrap(
          const TMessage(
            content: '安全偏移',
            duration: null,
            offset: Offset(999, 999),
          ),
          mediaSize: const Size(375, 200),
          mediaPadding: const EdgeInsets.fromLTRB(24, 44, 30, 20),
        ),
      );
      await tester.pump();

      final positioned = tester.widget<AnimatedPositioned>(
        find.byType(AnimatedPositioned),
      );
      final messageBox = tester.widget<SizedBox>(
        find.byWidgetPredicate(
          (widget) =>
              widget is SizedBox && widget.height == 48 && widget.width == 321,
        ),
      );
      expect(messageBox.width, 321);
      expect(positioned.left, 24);
      expect(positioned.top, 132);
    });

    testWidgets('useSafeArea=false 保留绝对 offset 与原始宽度', (tester) async {
      await tester.pumpWidget(
        wrap(
          const TMessage(
            content: '关闭安全区',
            duration: null,
            offset: Offset.zero,
            useSafeArea: false,
          ),
          mediaSize: const Size(375, 200),
          mediaPadding: const EdgeInsets.fromLTRB(24, 44, 30, 20),
        ),
      );
      await tester.pump();

      final positioned = tester.widget<AnimatedPositioned>(
        find.byType(AnimatedPositioned),
      );
      expect(positioned.left, 0);
      expect(positioned.top, 0);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is SizedBox && widget.height == 48 && widget.width == 343,
        ),
        findsOneWidget,
      );
    });
  });

  group('TMessage 跑马灯', () {
    testWidgets('单次、循环和延迟配置均可启动', (tester) async {
      await tester.pumpWidget(
        wrap(
          const TMessage(
            content: '单次跑马灯内容',
            duration: null,
            marquee: TMessageMarquee(duration: Duration(milliseconds: 200)),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byType(AnimatedBuilder), findsWidgets);

      await tester.pumpWidget(
        wrap(
          const TMessage(
            content: '循环跑马灯内容',
            duration: null,
            marquee: TMessageMarquee(
              duration: Duration(milliseconds: 200),
              repeat: true,
              delay: Duration(milliseconds: 50),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is AnimatedBuilder &&
              widget.listenable is AnimationController,
        ),
        findsWidgets,
      );
      await tester.pumpWidget(wrap(const SizedBox.shrink()));
    });

    testWidgets('运行期更新 marquee、duration 与 visible', (tester) async {
      var marquee = const TMessageMarquee();
      Duration? duration;
      var visible = false;
      late StateSetter setState;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setter) {
              setState = setter;
              return TMessage(
                content: '更新',
                marquee: marquee,
                duration: duration,
                visible: visible,
              );
            },
          ),
        ),
      );
      setState(() {
        marquee = const TMessageMarquee(
          duration: Duration(milliseconds: 300),
          delay: Duration(milliseconds: 10),
        );
        duration = const Duration(seconds: 1);
        visible = true;
      });
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 10));
      expect(find.text('更新'), findsOneWidget);
      await tester.pumpWidget(wrap(const SizedBox.shrink()));
    });
  });

  group('TMessage.show', () {
    testWidgets('返回句柄并支持立即关闭', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: Scaffold(body: SizedBox(key: key)),
        ),
      );
      final handle = TMessage.show(
        context: key.currentContext!,
        content: 'Overlay 消息',
        duration: null,
      );
      await tester.pump();
      expect(handle.isShowing, isTrue);
      expect(find.text('Overlay 消息'), findsOneWidget);
      handle.dismiss();
      await tester.pump();
      expect(handle.isShowing, isFalse);
    });

    testWidgets('保留触发子树的 ThemeExtension', (tester) async {
      final key = GlobalKey();
      final base = TThemeBuilder.light(TThemeData.defaultData());
      await tester.pumpWidget(
        MaterialApp(
          theme: base,
          home: Theme(
            data: base.mergeExtension(
              const TMessageThemeData(backgroundColor: Colors.purple),
            ),
            child: Scaffold(body: SizedBox(key: key)),
          ),
        ),
      );
      final handle = TMessage.show(
        context: key.currentContext!,
        content: '局部消息主题',
        duration: null,
      );
      await tester.pump();
      final material = tester.widget<Material>(
        find
            .ancestor(of: find.text('局部消息主题'), matching: find.byType(Material))
            .first,
      );
      expect(material.color, Colors.purple);
      handle.dismiss();
      await tester.pump();
    });

    testWidgets('自动关闭移除 Overlay 并透传回调', (tester) async {
      final key = GlobalKey();
      var ended = false;
      var dismissed = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: Scaffold(body: SizedBox(key: key)),
        ),
      );
      final handle = TMessage.show(
        context: key.currentContext!,
        content: '自动 Overlay',
        duration: const Duration(milliseconds: 50),
        onDurationEnd: () => ended = true,
        onDismissed: () => dismissed = true,
      );
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 400));
      expect(handle.isShowing, isFalse);
      expect(ended, isTrue);
      expect(dismissed, isTrue);
    });

    testWidgets('透传 useSafeArea=false', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(
            size: Size(375, 812),
            padding: EdgeInsets.only(top: 44),
          ),
          child: MaterialApp(
            theme: TThemeBuilder.light(TThemeData.defaultData()),
            home: Scaffold(body: SizedBox(key: key)),
          ),
        ),
      );
      final handle = TMessage.show(
        context: key.currentContext!,
        content: 'Overlay 关闭安全区',
        duration: null,
        offset: Offset.zero,
        useSafeArea: false,
      );
      await tester.pumpAndSettle();

      final message = tester.widget<TMessage>(find.byType(TMessage));
      final positioned = tester.widget<AnimatedPositioned>(
        find.byType(AnimatedPositioned),
      );
      expect(message.useSafeArea, isFalse);
      expect(positioned.top, 0);

      handle.dismiss();
      await tester.pump();
    });
  });

  test('ThemeData 纯函数', () {
    const base = TMessageThemeData(backgroundColor: Colors.white, elevation: 1);
    const other = TMessageThemeData(
      backgroundColor: Colors.black,
      elevation: 3,
    );
    expect(base.merge(null), same(base));
    expect(base.merge(other).elevation, 3);
    expect(base.copyWith(elevation: 2).elevation, 2);
    expect(base.lerp(other, 0.5), isA<TMessageThemeData>());
    expect(base.lerp(null, 0.5), same(base));
    expect(TMessageThemeData.lerpDouble(null, null, 0.5), isNull);
  });

  group('对齐官方 @spacer 的图标文本间距', () {
    testWidgets('带图标时图标与文本间距为 8px', (tester) async {
      await tester.pumpWidget(
        wrap(const TMessage(content: '间距', duration: null)),
      );
      await tester.pump();
      // 图标与文本之间的 SizedBox 宽度应对齐官方 @spacer = 8px。
      final messageRow = find.ancestor(
        of: find.text('间距'),
        matching: find.byType(Row),
      ).first;
      final gap = tester.widget<SizedBox>(
        find.descendant(
          of: messageRow,
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is SizedBox && widget.width == 8 && widget.height == null,
          ),
        ),
      );
      expect(gap.width, 8);
    });

    testWidgets('纯文字（无图标）不渲染图标且仅保留文本', (tester) async {
      await tester.pumpWidget(
        wrap(const TMessage(content: '纯文字', showIcon: false, duration: null)),
      );
      await tester.pump();
      expect(find.text('纯文字'), findsOneWidget);
      expect(find.byIcon(TIcons.error_circle_filled), findsNothing);
    });
  });

  group('多消息叠加与句柄关闭', () {
    testWidgets('多个句柄各自 dismiss 后可移除全部消息', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: Scaffold(body: SizedBox(key: key)),
        ),
      );
      final handles = <TMessageHandle>[
        TMessage.show(
          context: key.currentContext!,
          content: '消息一',
          duration: null,
        ),
        TMessage.show(
          context: key.currentContext!,
          content: '消息二',
          duration: null,
        ),
      ];
      await tester.pump();
      expect(find.text('消息一'), findsOneWidget);
      expect(find.text('消息二'), findsOneWidget);
      for (final handle in handles) {
        handle.dismiss();
      }
      await tester.pump();
      expect(handles.every((handle) => !handle.isShowing), isTrue);
      expect(find.text('消息一'), findsNothing);
      expect(find.text('消息二'), findsNothing);
    });
  });

  group('TMessage 声明式 visible 切换', () {
    testWidgets('visible 从 false 切到 true 后内容出现', (tester) async {
      var visible = false;
      late StateSetter setState;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setter) {
              setState = setter;
              return TMessage(
                content: '组件调用',
                visible: visible,
                duration: null,
              );
            },
          ),
        ),
      );
      expect(find.text('组件调用'), findsNothing);
      setState(() => visible = true);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('组件调用'), findsOneWidget);
      await tester.pumpWidget(wrap(const SizedBox.shrink()));
    });
  });
}
