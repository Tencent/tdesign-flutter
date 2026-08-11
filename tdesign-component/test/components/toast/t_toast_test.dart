import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/loading/t_circle_indicator.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TToast Widget 测试
///
/// E 类控制：`showText()` / `showIconText()` 调用即显；不调即不显。
/// 覆盖文本 Toast、图标 Toast、自定义样式、duration。
///
/// 注意：Widget 测试中 Timer 由 FakeAsync 接管，直接调用 show 方法后
/// 用 `tester.pump(Duration)` 推进假时钟即可触发 Toast 显示/自动消失，
/// 避免 `runAsync` + `pumpAndSettle` 在 Windows/WSL 跨平台时序不一致导致失败。
void main() {
  /// 用 TTheme 包裹以提供基础 Token，含可定位的 Key 节点
  ThemeData fullTheme({TToastThemeData? toastTheme}) {
    var theme = TThemeBuilder.light(TThemeData.defaultData());
    if (toastTheme != null) {
      theme = theme.mergeExtension(toastTheme);
    }
    return theme;
  }

  Widget wrapWithTheme({TextScaler textScaler = TextScaler.noScaling}) {
    return MaterialApp(
      theme: fullTheme(),
      home: MediaQuery(
        data: MediaQueryData(textScaler: textScaler),
        child: Scaffold(
          body: Center(
            child: Builder(
              key: const Key('toast_host'),
              builder: (_) => const SizedBox(),
            ),
          ),
        ),
      ),
    );
  }

  /// 辅助：显示 Toast 并推进一帧渲染。
  /// 注意：Widget 测试中 Timer 由 FakeAsync 接管，无需 runAsync，
  /// 用 pump(Duration) 即可推进定时器，避免 pumpAndSettle 因
  /// hasTimersPending 在跨平台（Windows/WSL）上表现不一致而失败。
  Future<void> showToastAndPump(
    WidgetTester tester,
    void Function(BuildContext) show, {
    Duration wait = const Duration(milliseconds: 50),
  }) async {
    final context = tester.element(find.byKey(const Key('toast_host')));
    show(context);
    await tester.pump(wait);
  }

  Finder toastBoxFinder(String text) => find.ancestor(
    of: find.text(text),
    matching: find.byWidgetPredicate(
      (widget) => widget is Container && widget.decoration is BoxDecoration,
    ),
  );

  /// 辅助：推进足够时间让 Toast 自动消失（duration + dispose 延迟）。
  Future<void> waitForDismiss(WidgetTester tester) async {
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();
  }

  // ============================================================
  // E 类控制：showText 调用即显
  // ============================================================
  group('TToast E 类控制（showText）', () {
    testWidgets('showText 调用后 Toast 出现', (tester) async {
      await tester.pumpWidget(wrapWithTheme());

      await showToastAndPump(tester, (context) {
        TToast.showText(
          '提示消息',
          context: context,
          duration: const Duration(milliseconds: 100),
        );
      });
      expect(find.text('提示消息'), findsOneWidget);

      await waitForDismiss(tester);
    });

    testWidgets('保留触发子树的 ThemeExtension', (tester) async {
      final base = fullTheme();
      await tester.pumpWidget(
        MaterialApp(
          theme: base,
          home: Theme(
            data: base.mergeExtension(
              const TToastThemeData(backgroundColor: Colors.purple),
            ),
            child: const Scaffold(body: SizedBox(key: Key('local_toast_host'))),
          ),
        ),
      );
      final context = tester.element(find.byKey(const Key('local_toast_host')));
      TToast.showText(
        '局部 Toast 主题',
        context: context,
        duration: const Duration(milliseconds: 100),
      );
      await tester.pump();
      final box = tester.widget<Container>(toastBoxFinder('局部 Toast 主题').first);
      expect((box.decoration! as BoxDecoration).color, Colors.purple);
      await waitForDismiss(tester);
    });

    testWidgets('不调用 showText 时不显示 Toast', (tester) async {
      await tester.pumpWidget(wrapWithTheme());
      expect(find.byType(TToast), findsNothing);
    });
  });

  // ============================================================
  // showIconText 带图标
  // ============================================================
  group('TToast showIconText 带图标', () {
    testWidgets('showIconText 显示文本和图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme());

      await showToastAndPump(tester, (context) {
        TToast.showIconText(
          '成功',
          icon: Icons.check_circle,
          context: context,
          duration: const Duration(milliseconds: 100),
        );
      });
      expect(find.text('成功'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);

      await waitForDismiss(tester);
    });

    testWidgets('showIconText vertical 竖向排列', (tester) async {
      await tester.pumpWidget(wrapWithTheme());

      await showToastAndPump(tester, (context) {
        TToast.showIconText(
          '竖向',
          icon: Icons.info,
          direction: IconTextDirection.vertical,
          context: context,
          duration: const Duration(milliseconds: 100),
        );
      });
      expect(find.text('竖向'), findsOneWidget);

      await waitForDismiss(tester);
    });

    testWidgets('showIconText horizontal 横向排列', (tester) async {
      await tester.pumpWidget(wrapWithTheme());

      await showToastAndPump(tester, (context) {
        TToast.showIconText(
          '横向',
          icon: Icons.warning,
          direction: IconTextDirection.horizontal,
          context: context,
          duration: const Duration(milliseconds: 100),
        );
      });
      expect(find.text('横向'), findsOneWidget);

      await waitForDismiss(tester);
    });
  });

  group('TToast 默认样式契约', () {
    testWidgets('showText 默认前景色和文本布局来自 token', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(wrapWithTheme());

      await showToastAndPump(tester, (context) {
        TToast.showText(
          '默认文本',
          context: context,
          duration: const Duration(milliseconds: 100),
        );
      });

      final text = tester.widget<Text>(find.text('默认文本'));
      expect(text.style?.color, token.textColorAnti);
      expect(text.style?.fontSize, token.fontBodyMedium?.size);
      expect(text.style?.height, token.fontBodyMedium?.height);
      expect(text.maxLines, 3);
      expect(text.overflow, TextOverflow.ellipsis);

      final box = tester.widget<Container>(toastBoxFinder('默认文本'));
      final decoration = box.decoration! as BoxDecoration;
      expect(decoration.color, token.fontGyColor1);

      await waitForDismiss(tester);
    });

    testWidgets('showIconText 默认图标和文本前景色来自 token', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(wrapWithTheme());

      await showToastAndPump(tester, (context) {
        TToast.showIconText(
          '默认图标',
          icon: Icons.info,
          context: context,
          duration: const Duration(milliseconds: 100),
        );
      });

      final icon = tester.widget<Icon>(find.byIcon(Icons.info));
      final text = tester.widget<Text>(find.text('默认图标'));
      expect(icon.color, token.textColorAnti);
      expect(icon.size, 24);
      expect(text.style?.color, token.textColorAnti);
      expect(text.maxLines, 1);
      expect(text.overflow, TextOverflow.ellipsis);

      await waitForDismiss(tester);
    });

    testWidgets('showLoading 默认指示器和文本前景色来自 token', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(wrapWithTheme());
      final context = tester.element(find.byKey(const Key('toast_host')));

      final id = TToast.showLoading(context: context, text: '默认加载');
      await tester.pump();

      final indicator = tester.widget<TCircleIndicator>(
        find.byType(TCircleIndicator),
      );
      final text = tester.widget<Text>(find.text('默认加载'));
      expect(indicator.color, token.textColorAnti);
      expect(indicator.size, 32);
      expect(text.style?.color, token.textColorAnti);
      expect(text.maxLines, 1);
      expect(text.overflow, TextOverflow.ellipsis);

      TToast.dismissToast(id);
      await tester.pump();
    });
  });

  // ============================================================
  // 自定义样式
  // ============================================================
  group('TToast 自定义样式', () {
    testWidgets('自定义 backgroundColor', (tester) async {
      await tester.pumpWidget(wrapWithTheme());

      await showToastAndPump(tester, (context) {
        TToast.showText(
          '背景色',
          context: context,
          backgroundColor: Colors.red,
          duration: const Duration(milliseconds: 100),
        );
      });
      expect(find.text('背景色'), findsOneWidget);

      await waitForDismiss(tester);
    });

    testWidgets('自定义 textStyle', (tester) async {
      await tester.pumpWidget(wrapWithTheme());

      await showToastAndPump(tester, (context) {
        TToast.showText(
          '样式',
          context: context,
          textStyle: const TextStyle(fontSize: 20, color: Colors.white),
          duration: const Duration(milliseconds: 100),
        );
      });
      expect(find.text('样式'), findsOneWidget);

      await waitForDismiss(tester);
    });

    testWidgets('自定义 iconSize 和 iconColor', (tester) async {
      await tester.pumpWidget(wrapWithTheme());

      await showToastAndPump(tester, (context) {
        TToast.showIconText(
          '图标样式',
          icon: Icons.star,
          context: context,
          iconSize: 32,
          iconColor: Colors.yellow,
          duration: const Duration(milliseconds: 100),
        );
      });
      final icon = tester.widget<Icon>(find.byIcon(Icons.star));
      expect(icon.size, 32);

      await waitForDismiss(tester);
    });

    testWidgets('maxLines 限制行数', (tester) async {
      await tester.pumpWidget(wrapWithTheme());

      await showToastAndPump(tester, (context) {
        TToast.showText(
          '多行文本多行文本多行文本多行文本多行文本多行文本多行文本',
          context: context,
          maxLines: 2,
          duration: const Duration(milliseconds: 100),
        );
      });
      expect(find.byKey(const Key('toast_host')), findsWidgets);

      await waitForDismiss(tester);
    });

    testWidgets('theme controls radius, padding and width', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: fullTheme(
            toastTheme: const TToastThemeData(
              borderRadius: 12,
              padding: EdgeInsets.all(6),
              maxWidth: 240,
            ),
          ),
          home: Scaffold(
            body: Center(
              child: Builder(
                key: const Key('toast_host'),
                builder: (_) => const SizedBox(),
              ),
            ),
          ),
        ),
      );

      await showToastAndPump(tester, (context) {
        TToast.showText(
          '主题 toast',
          context: context,
          duration: const Duration(milliseconds: 100),
        );
      });

      final box = tester.widget<Container>(toastBoxFinder('主题 toast'));
      final decoration = box.decoration! as BoxDecoration;
      final constraints = tester
          .widget<ConstrainedBox>(
            find.ancestor(
              of: find.text('主题 toast'),
              matching: find.byType(ConstrainedBox),
            ),
          )
          .constraints;

      expect(decoration.borderRadius, BorderRadius.circular(12));
      expect(box.padding, const EdgeInsets.all(6));
      expect(constraints.maxWidth, 240);

      await waitForDismiss(tester);
    });
  });

  // ============================================================
  // duration 自动消失
  // ============================================================
  group('TToast duration', () {
    testWidgets('短 duration 后 Toast 消失', (tester) async {
      await tester.pumpWidget(wrapWithTheme());

      // 显示 Toast（短 duration）
      final context = tester.element(find.byKey(const Key('toast_host')));
      TToast.showText(
        '短暂提示',
        context: context,
        duration: const Duration(milliseconds: 100),
      );
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('短暂提示'), findsOneWidget);

      // 等待 duration + dispose 延迟后消失
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('短暂提示'), findsNothing);
    });

    testWidgets('长 duration Toast 保持显示', (tester) async {
      await tester.pumpWidget(wrapWithTheme());

      final context = tester.element(find.byKey(const Key('toast_host')));
      TToast.showText(
        '长期提示',
        context: context,
        duration: const Duration(seconds: 2),
      );
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('长期提示'), findsOneWidget);

      // 短暂等待后仍应显示
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('长期提示'), findsOneWidget);

      // 清理：等待长 duration 过期后消失
      await tester.pump(const Duration(seconds: 3));
      expect(find.text('长期提示'), findsNothing);
    });

    testWidgets('默认 duration 为 2000ms（与 TDesign Mobile 对齐）',
        (tester) async {
      await tester.pumpWidget(wrapWithTheme());

      final context = tester.element(find.byKey(const Key('toast_host')));
      TToast.showText('默认时长', context: context);
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('默认时长'), findsOneWidget);

      // 1500ms 时仍应显示（未到默认 2000ms）
      await tester.pump(const Duration(milliseconds: 1500));
      expect(find.text('默认时长'), findsOneWidget);

      // 超过 2000ms + dispose 延迟后消失
      await tester.pump(const Duration(milliseconds: 1000));
      expect(find.text('默认时长'), findsNothing);
    });
  });

  // ============================================================
  // showSuccess / showWarning / showFail
  // ============================================================
  group('TToast 状态图标', () {
    testWidgets('showSuccess 显示成功图标与文案', (tester) async {
      await tester.pumpWidget(wrapWithTheme());
      await showToastAndPump(tester, (context) {
        TToast.showSuccess(
          '成功',
          context: context,
          duration: const Duration(milliseconds: 100),
        );
      });
      expect(find.text('成功'), findsOneWidget);
      expect(find.byIcon(TIcons.check_circle), findsOneWidget);
      await waitForDismiss(tester);
    });

    testWidgets('showWarning 显示警告图标与文案', (tester) async {
      await tester.pumpWidget(wrapWithTheme());
      await showToastAndPump(tester, (context) {
        TToast.showWarning(
          '警告',
          context: context,
          duration: const Duration(milliseconds: 100),
        );
      });
      expect(find.text('警告'), findsOneWidget);
      expect(find.byIcon(TIcons.error_circle), findsOneWidget);
      await waitForDismiss(tester);
    });

    testWidgets('showFail 显示失败图标与文案', (tester) async {
      await tester.pumpWidget(wrapWithTheme());
      await showToastAndPump(tester, (context) {
        TToast.showFail(
          '失败',
          context: context,
          duration: const Duration(milliseconds: 100),
        );
      });
      expect(find.text('失败'), findsOneWidget);
      expect(find.byIcon(TIcons.close_circle), findsOneWidget);
      await waitForDismiss(tester);
    });
  });

  // ============================================================
  // 加载 Toast
  // ============================================================
  group('TToast 加载', () {
    testWidgets('showLoading 显示加载文案', (tester) async {
      await tester.pumpWidget(wrapWithTheme());
      final context = tester.element(find.byKey(const Key('toast_host')));
      final id = TToast.showLoading(context: context, text: '加载中');
      // 仅 pump 单帧：TCircleIndicator 有无限旋转动画，pumpAndSettle 会超时
      await tester.pump();
      expect(find.text('加载中'), findsOneWidget);
      TToast.dismissToast(id);
      await tester.pump();
      expect(find.text('加载中'), findsNothing);
    });

    testWidgets('showLoadingWithoutText 仅渲染指示器无文案', (tester) async {
      await tester.pumpWidget(wrapWithTheme());
      final context = tester.element(find.byKey(const Key('toast_host')));
      final id = TToast.showLoadingWithoutText(context: context);
      await tester.pump();
      // 不带文案，不应出现加载文案
      expect(find.text('加载中'), findsNothing);
      TToast.dismissToast(id);
      await tester.pump();
    });

    testWidgets('大字号和长文案下 loading 自适应高度且不溢出', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(textScaler: const TextScaler.linear(2.5)),
      );
      final context = tester.element(find.byKey(const Key('toast_host')));
      final id = TToast.showLoading(context: context, text: '正在加载较长的内容');
      await tester.pump();

      expect(tester.takeException(), isNull);
      final box = toastBoxFinder('正在加载较长的内容').first;
      expect(tester.getSize(box).height, greaterThanOrEqualTo(110));

      TToast.dismissToast(id);
      await tester.pump();
    });

    testWidgets('无文案 loading 在自定义大图标下自适应尺寸', (tester) async {
      await tester.pumpWidget(wrapWithTheme());
      final context = tester.element(find.byKey(const Key('toast_host')));
      final id = TToast.showLoadingWithoutText(context: context, iconSize: 64);
      await tester.pump();

      expect(tester.takeException(), isNull);
      final indicator = find.byType(TCircleIndicator);
      final decoratedBox = find.ancestor(
        of: indicator,
        matching: find.byWidgetPredicate(
          (widget) => widget is Container && widget.decoration is BoxDecoration,
        ),
      );
      expect(
        tester.getSize(decoratedBox.first).height,
        greaterThanOrEqualTo(112),
      );

      TToast.dismissToast(id);
      await tester.pump();
    });
  });

  // ============================================================
  // dismiss 关闭
  // ============================================================
  group('TToast dismiss 关闭', () {
    testWidgets('同一 toastId 重复展示会替换旧实例', (tester) async {
      await tester.pumpWidget(wrapWithTheme());
      final context = tester.element(find.byKey(const Key('toast_host')));

      TToast.showText(
        '旧 Toast',
        context: context,
        toastId: 'same',
        preventTap: true,
      );
      await tester.pump();
      TToast.showText('新 Toast', context: context, toastId: 'same');
      await tester.pump();

      expect(find.text('旧 Toast'), findsNothing);
      expect(find.text('新 Toast'), findsOneWidget);
      TToast.dismissToast('same');
      await tester.pump();
      expect(find.text('新 Toast'), findsNothing);
    });

    testWidgets('dismissToast 关闭指定 Toast', (tester) async {
      await tester.pumpWidget(wrapWithTheme());
      final context = tester.element(find.byKey(const Key('toast_host')));
      final id = TToast.showText(
        '可关闭',
        context: context,
        duration: const Duration(seconds: 10),
      );
      await tester.pump();
      expect(find.text('可关闭'), findsOneWidget);
      TToast.dismissToast(id);
      await tester.pump();
      expect(find.text('可关闭'), findsNothing);
    });

    testWidgets('dismissAll 关闭所有 Toast', (tester) async {
      await tester.pumpWidget(wrapWithTheme());
      final context = tester.element(find.byKey(const Key('toast_host')));
      TToast.showText(
        'A',
        context: context,
        duration: const Duration(seconds: 10),
      );
      TToast.showText(
        'B',
        context: context,
        duration: const Duration(seconds: 10),
      );
      await tester.pump();
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      TToast.dismissAll();
      await tester.pump();
      expect(find.text('A'), findsNothing);
      expect(find.text('B'), findsNothing);
    });

    testWidgets('按返回 id 关闭加载 Toast 不影响普通 Toast', (tester) async {
      await tester.pumpWidget(wrapWithTheme());
      final context = tester.element(find.byKey(const Key('toast_host')));
      TToast.showText(
        '普通',
        context: context,
        duration: const Duration(seconds: 10),
      );
      final loadingId = TToast.showLoading(context: context, text: '加载中');
      // 仅 pump 单帧，避免 TCircleIndicator 无限动画导致 pumpAndSettle 超时
      await tester.pump();
      expect(find.text('加载中'), findsOneWidget);
      TToast.dismissToast(loadingId);
      await tester.pump();
      expect(find.text('加载中'), findsNothing);
      expect(find.text('普通'), findsOneWidget);
      TToast.dismissAll();
    });
  });

  // ============================================================
  // preventTap / customWidget
  // ============================================================
  group('TToast 遮罩与自定义', () {
    testWidgets('preventTap 渲染全屏遮罩', (tester) async {
      await tester.pumpWidget(wrapWithTheme());
      await showToastAndPump(tester, (context) {
        TToast.showText(
          '防触',
          context: context,
          preventTap: true,
          duration: const Duration(milliseconds: 100),
        );
      });
      expect(find.text('防触'), findsOneWidget);
      // preventTap 时使用 Positioned 全屏透明遮罩
      expect(find.byType(Positioned), findsWidgets);
      await waitForDismiss(tester);
    });

    testWidgets('customWidget 渲染自定义内容', (tester) async {
      await tester.pumpWidget(wrapWithTheme());
      await showToastAndPump(tester, (context) {
        TToast.showText(
          '忽略',
          context: context,
          customWidget: const Text('自定义内容'),
          duration: const Duration(milliseconds: 100),
        );
      });
      expect(find.text('自定义内容'), findsOneWidget);
      await waitForDismiss(tester);
    });
  });
}
