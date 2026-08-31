import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  // 复制交互依赖系统剪贴板，默认 fake-async 环境下平台通道不会主动返回，
  // 这里 mock 掉 flutter/platform 通道，让 Clipboard.setData 同步完成。
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (_) async => null);
  });
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  Widget wrap(Widget child, {Locale? locale}) {
    final theme = TThemeBuilder.light(TThemeData.defaultData());
    return MaterialApp(
      locale: locale ?? const Locale('zh'),
      supportedLocales: const [Locale('zh'), Locale('en')],
      theme: theme,
      home: Scaffold(body: child),
    );
  }

  // 断言 TTitle 指定 level 的样式映射到对应 font token。
  void expectTitleFont(WidgetTester tester, Font? token) {
    final text = tester.widget<Text>(find.text('标题'));
    expect(text.style?.fontSize, token?.size);
    expect(text.style?.height, token?.height);
  }

  group('TTitle', () {
    testWidgets('h1 映射 fontHeadlineLarge', (tester) async {
      await tester.pumpWidget(wrap(const TTitle('标题', level: TTitleLevel.h1)));
      final token = tester.element(find.text('标题')).tTheme.fontHeadlineLarge;
      expectTitleFont(tester, token);
    });

    testWidgets('h2 映射 fontHeadlineMedium', (tester) async {
      await tester.pumpWidget(wrap(const TTitle('标题', level: TTitleLevel.h2)));
      final token = tester.element(find.text('标题')).tTheme.fontHeadlineMedium;
      expectTitleFont(tester, token);
    });

    testWidgets('h3 映射 fontHeadlineSmall', (tester) async {
      await tester.pumpWidget(wrap(const TTitle('标题', level: TTitleLevel.h3)));
      final token = tester.element(find.text('标题')).tTheme.fontHeadlineSmall;
      expectTitleFont(tester, token);
    });

    testWidgets('h4 映射 fontTitleLarge', (tester) async {
      await tester.pumpWidget(wrap(const TTitle('标题', level: TTitleLevel.h4)));
      final token = tester.element(find.text('标题')).tTheme.fontTitleLarge;
      expectTitleFont(tester, token);
    });

    testWidgets('h5 映射 fontTitleMedium', (tester) async {
      await tester.pumpWidget(wrap(const TTitle('标题', level: TTitleLevel.h5)));
      final token = tester.element(find.text('标题')).tTheme.fontTitleMedium;
      expectTitleFont(tester, token);
    });

    testWidgets('h6 映射 fontTitleSmall', (tester) async {
      await tester.pumpWidget(wrap(const TTitle('标题', level: TTitleLevel.h6)));
      final token = tester.element(find.text('标题')).tTheme.fontTitleSmall;
      expectTitleFont(tester, token);
    });

    testWidgets('默认 level 为 h1', (tester) async {
      await tester.pumpWidget(wrap(const TTitle('标题')));
      final token = tester.element(find.text('标题')).tTheme.fontHeadlineLarge;
      expectTitleFont(tester, token);
    });

    testWidgets('textColor 与展开收起透传', (tester) async {
      bool? lastState;
      await tester.pumpWidget(
        wrap(
          TTitle(
            '可展开的标题内容用于验证展开收起与颜色透传',
            textColor: Colors.red,
            maxLines: 1,
            expandable: true,
            onExpandedChange: (v) => lastState = v,
          ),
        ),
      );
      expect(
        tester.widget<Text>(find.text('可展开的标题内容用于验证展开收起与颜色透传')),
        isNotNull,
      );
      expect(find.text('展开'), findsOneWidget);
      await tester.tap(find.text('展开'));
      await tester.pump();
      expect(lastState, isTrue);
      expect(find.text('收起'), findsOneWidget);
    });
  });

  group('TParagraph', () {
    testWidgets('默认字号为 fontBodyMedium', (tester) async {
      await tester.pumpWidget(wrap(const TParagraph('段落')));
      final text = tester.widget<Text>(find.text('段落'));
      final token = tester.element(find.text('段落')).tTheme.fontBodyMedium;
      expect(text.style?.fontSize, token?.size);
      expect(text.style?.height, token?.height);
    });

    testWidgets('textColor 与 textAlign 透传', (tester) async {
      await tester.pumpWidget(
        wrap(
          const TParagraph(
            '对齐段落',
            textColor: Colors.teal,
            textAlign: TextAlign.center,
          ),
        ),
      );
      final text = tester.widget<Text>(find.text('对齐段落'));
      expect(text.style?.color, Colors.teal);
      expect(text.textAlign, TextAlign.center);
    });

    testWidgets('expandable 展开收起回调', (tester) async {
      bool? lastState;
      await tester.pumpWidget(
        wrap(
          TParagraph(
            '这是一段用于测试段落展开收起能力的较长正文内容，'
            '默认显示两行，展开后可查看完整内容。',
            maxLines: 2,
            expandable: true,
            onExpandedChange: (v) => lastState = v,
          ),
        ),
      );
      expect(find.text('展开'), findsOneWidget);
      await tester.tap(find.text('展开'));
      await tester.pump();
      expect(lastState, isTrue);
      expect(find.text('收起'), findsOneWidget);
    });

    testWidgets('受控 expanded 由外部驱动', (tester) async {
      var lastState = false;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) {
              return TParagraph(
                '受控展开的段落内容用于测试外部驱动状态',
                maxLines: 2,
                expandable: true,
                expanded: lastState,
                onExpandedChange: (v) => setState(() => lastState = v),
              );
            },
          ),
        ),
      );
      expect(find.text('展开'), findsOneWidget);
      await tester.tap(find.text('展开'));
      await tester.pump();
      expect(lastState, isTrue);
      expect(find.text('收起'), findsOneWidget);
    });
  });

  group('TTypography', () {
    testWidgets('text 子组件构造 TText', (tester) async {
      await tester.pumpWidget(wrap(TTypography.text('基础文本')));
      expect(find.text('基础文本'), findsOneWidget);
      expect(find.byType(TText), findsOneWidget);
    });

    testWidgets('text 子组件透传 copyable 与 expandable', (tester) async {
      await tester.pumpWidget(
        wrap(TTypography.text('可复制文本', copyable: true)),
      );
      expect(find.byType(TIcon), findsOneWidget);
    });

    testWidgets('title 子组件构造 TTitle 并映射 token', (tester) async {
      await tester.pumpWidget(
        wrap(TTypography.title('标题', level: TTitleLevel.h3)),
      );
      final text = tester.widget<Text>(find.text('标题'));
      final token = tester.element(find.text('标题')).tTheme.fontHeadlineSmall;
      expect(text.style?.fontSize, token?.size);
    });

    testWidgets('title 子组件透传展开收起', (tester) async {
      bool? lastState;
      await tester.pumpWidget(
        wrap(
          TTypography.title(
            '通过命名空间创建的标题支持展开收起能力',
            maxLines: 1,
            expandable: true,
            onExpandedChange: (v) => lastState = v,
          ),
        ),
      );
      expect(find.text('展开'), findsOneWidget);
      await tester.tap(find.text('展开'));
      await tester.pump();
      expect(lastState, isTrue);
    });

    testWidgets('paragraph 子组件构造 TParagraph', (tester) async {
      await tester.pumpWidget(wrap(TTypography.paragraph('段落')));
      final text = tester.widget<Text>(find.text('段落'));
      final token = tester.element(find.text('段落')).tTheme.fontBodyMedium;
      expect(text.style?.fontSize, token?.size);
    });

    testWidgets('paragraph 子组件透传展开收起', (tester) async {
      bool? lastState;
      await tester.pumpWidget(
        wrap(
          TTypography.paragraph(
            '通过命名空间创建的段落支持展开收起能力',
            maxLines: 2,
            expandable: true,
            onExpandedChange: (v) => lastState = v,
          ),
        ),
      );
      expect(find.text('展开'), findsOneWidget);
      await tester.tap(find.text('展开'));
      await tester.pump();
      expect(lastState, isTrue);
    });
  });

  group('TText interactive', () {
    testWidgets('copyable 显示复制图标并回调 onCopied', (tester) async {
      var copied = false;
      await tester.pumpWidget(
        wrap(
          TText(
            '可复制文本',
            copyable: true,
            onCopied: () => copied = true,
          ),
        ),
      );
      expect(find.text('可复制文本'), findsOneWidget);
      expect(find.byType(TIcon), findsOneWidget);

      await tester.tap(find.byType(TIcon));
      await tester.pump();
      expect(copied, isTrue);
      // 复制成功后切换到 check 图标
      expect(
        tester.widget<TIcon>(find.byType(TIcon)).icon,
        TIcons.check,
      );
    });

    testWidgets('copyable 连续复制重置计时器后仍可再次复制', (tester) async {
      var copiedCount = 0;
      await tester.pumpWidget(
        wrap(
          TText(
            '连续复制',
            copyable: true,
            onCopied: () => copiedCount++,
          ),
        ),
      );
      // 第一次复制
      await tester.tap(find.byType(TIcon));
      await tester.pump();
      expect(copiedCount, 1);
      // 等待计时器结束后图标恢复
      await tester.pump(const Duration(milliseconds: 1600));
      expect(
        tester.widget<TIcon>(find.byType(TIcon)).icon,
        TIcons.file_copy,
      );
      // 第二次复制，验证计时器重置后仍能切回 check
      await tester.tap(find.byType(TIcon));
      await tester.pump();
      expect(copiedCount, 2);
      expect(
        tester.widget<TIcon>(find.byType(TIcon)).icon,
        TIcons.check,
      );
    });

    testWidgets('copyable 空数据时不回调 onCopied', (tester) async {
      var copied = false;
      // 纯空内容（无 data 且无 span 文本）时 copyText 为空，_copy 提前返回不触发 onCopied。
      await tester.pumpWidget(
        wrap(
          TText.rich(
            const TextSpan(),
            copyable: true,
            onCopied: () => copied = true,
          ),
        ),
      );
      await tester.tap(find.byType(TIcon));
      await tester.pump();
      expect(copied, isFalse);
    });

    testWidgets('copyable 复制后组件卸载时清理计时器不崩溃', (tester) async {
      await tester.pumpWidget(wrap(const TText('卸载复制', copyable: true)));
      await tester.tap(find.byType(TIcon));
      await tester.pump();
      // 卸载组件触发 dispose，校验不抛异常
      await tester.pumpWidget(wrap(const SizedBox()));
      await tester.pump(const Duration(milliseconds: 1600));
      expect(tester.takeException(), isNull);
    });

    testWidgets('expandable 展开收起回调', (tester) async {
      bool? lastState;
      await tester.pumpWidget(
        wrap(
          TText(
            '这是一段用于测试展开收起能力的较长文本内容，'
            '默认显示两行，展开后可查看完整内容。',
            maxLines: 2,
            expandable: true,
            onExpandedChange: (v) => lastState = v,
          ),
        ),
      );
      expect(find.text('展开'), findsOneWidget);
      await tester.tap(find.text('展开'));
      await tester.pump();
      expect(lastState, isTrue);
      expect(find.text('收起'), findsOneWidget);
    });

    testWidgets('受控 expanded 由外部驱动', (tester) async {
      var lastState = false;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) {
              return TText(
                '受控展开的文本内容用于测试外部驱动状态',
                maxLines: 2,
                expandable: true,
                expanded: lastState,
                onExpandedChange: (v) {
                  setState(() => lastState = v);
                },
              );
            },
          ),
        ),
      );
      expect(find.text('展开'), findsOneWidget);
      await tester.tap(find.text('展开'));
      await tester.pump();
      expect(lastState, isTrue);
      expect(find.text('收起'), findsOneWidget);
    });

    testWidgets('受控 expanded 为 true 时直接显示收起', (tester) async {
      await tester.pumpWidget(
        wrap(
          const TText(
            '初始即展开的文本内容',
            maxLines: 2,
            expandable: true,
            expanded: true,
          ),
        ),
      );
      expect(find.text('收起'), findsOneWidget);
      // 受控下再次点击仍回调且状态保持 true
      await tester.tap(find.text('收起'));
      await tester.pump();
      expect(find.text('收起'), findsOneWidget);
    });

    testWidgets('英文环境下展开收起文案本地化', (tester) async {
      bool? lastState;
      await tester.pumpWidget(
        wrap(
          TText(
            'An expandable English text used to verify localization.',
            maxLines: 2,
            expandable: true,
            onExpandedChange: (v) => lastState = v,
          ),
          locale: const Locale('en', 'US'),
        ),
      );
      expect(find.text('Expand'), findsOneWidget);
      await tester.tap(find.text('Expand'));
      await tester.pump();
      expect(lastState, isTrue);
      expect(find.text('Collapse'), findsOneWidget);
    });

    testWidgets('TText.rich 交互路径支持 copyable', (tester) async {
      var copied = false;
      await tester.pumpWidget(
        wrap(
          TText.rich(
            const TextSpan(text: '富文本可复制'),
            copyable: true,
            onCopied: () => copied = true,
          ),
        ),
      );
      expect(find.byType(TIcon), findsOneWidget);
      await tester.tap(find.byType(TIcon));
      await tester.pump();
      expect(copied, isTrue);
    });
  });
}
