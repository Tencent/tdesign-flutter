import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  // ============================================================
  // T01 – 基础渲染：纯文本链接
  // ============================================================
  testWidgets('T01 - 基础渲染：纯文本链接', (tester) async {
    await tester.pumpWidget(_wrap(
      const TLink(
        child: Text('跳转链接'),
        variant: TLinkVariant.basic,
      ),
    ));

    // 应该渲染出文本
    expect(find.text('跳转链接'), findsOneWidget);
    // 不应有下划线
    final text = tester.widget<Text>(find.text('跳转链接'));
    expect(text.style?.decoration, isNull);
  });

  // ============================================================
  // T02 – 下划线链接
  // ============================================================
  testWidgets('T02 - 下划线链接', (tester) async {
    await tester.pumpWidget(_wrap(
      const TLink(
        child: Text('带下划线'),
        variant: TLinkVariant.underline,
      ),
    ));

    expect(find.text('带下划线'), findsOneWidget);
    final text = tester.widget<Text>(find.text('带下划线'));
    expect(text.style?.decoration, TextDecoration.underline);
  });

  // ============================================================
  // T03 – 带图标链接（默认图标）
  // ============================================================
  testWidgets('T03 - 带图标链接（默认图标）', (tester) async {
    await tester.pumpWidget(_wrap(
      const TLink(
        child: Text('图标链接'),
        variant: TLinkVariant.icon,
      ),
    ));

    expect(find.text('图标链接'), findsOneWidget);
    // 默认图标模式下有 Icon widget
    expect(find.byType(Icon), findsWidgets);
  });

  // ============================================================
  // T03b – 带图标链接布局间距
  // ============================================================
  testWidgets('T03b - 带图标链接布局间距', (tester) async {
    await tester.pumpWidget(_wrap(
      const TLink(
        child: Text('图标链接'),
        variant: TLinkVariant.icon,
      ),
    ));

    final prefix = find.byIcon(TIcons.link);
    final suffix = find.byIcon(TIcons.jump);
    final text = find.text('图标链接');

    expect(tester.widget<Icon>(prefix).size, 16);
    expect(tester.widget<Icon>(suffix).size, 16);
    expect(
      tester.getTopLeft(text).dx - tester.getTopRight(prefix).dx,
      moreOrLessEquals(6.34, epsilon: 0.01),
    );
    expect(
      tester.getTopLeft(suffix).dx - tester.getTopRight(text).dx,
      moreOrLessEquals(7.0, epsilon: 0.01),
    );
  });

  // ============================================================
  // T04 – 带前缀图标链接
  // ============================================================
  testWidgets('T04 - 带前缀图标链接', (tester) async {
    await tester.pumpWidget(_wrap(
      const TLink(
        child: Text('前置图标'),
        variant: TLinkVariant.icon,
        prefixIcon: Icon(Icons.home),
      ),
    ));

    expect(find.text('前置图标'), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);
  });

  // ============================================================
  // T05 – 带后缀图标链接
  // ============================================================
  testWidgets('T05 - 带后缀图标链接', (tester) async {
    await tester.pumpWidget(_wrap(
      const TLink(
        child: Text('后置图标'),
        variant: TLinkVariant.icon,
        suffixIcon: Icon(Icons.arrow_forward),
      ),
    ));

    expect(find.text('后置图标'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    // 只传 suffix 时不自动补充默认前缀链接图标（对齐 h5 设计）
    expect(find.byIcon(TIcons.link), findsNothing);
  });

  // ============================================================
  // T05b – suffixIconData 图标颜色跟随 colorScheme
  // ============================================================
  testWidgets('T05b - suffixIconData 图标颜色跟随主题色', (tester) async {
    final token = TThemeData.defaultData();
    await tester.pumpWidget(MaterialApp(
      theme: TThemeBuilder.light(token),
      home: const Scaffold(
        body: Center(
          child: TLink(
            child: Text('主题色'),
            variant: TLinkVariant.icon,
            colorScheme: TLinkColorScheme.primary,
            suffixIconData: TIcons.jump,
            onPressed: _noop,
          ),
        ),
      ),
    ));

    final icon = tester.widget<Icon>(find.byIcon(TIcons.jump));
    expect(icon.color, token.brandNormalColor);
  });

  // ============================================================
  // T05c – suffixIconData 图标颜色跟随禁用态
  // ============================================================
  testWidgets('T05c - suffixIconData 图标禁用态颜色跟随', (tester) async {
    final token = TThemeData.defaultData();
    await tester.pumpWidget(MaterialApp(
      theme: TThemeBuilder.light(token),
      home: const Scaffold(
        body: Center(
          child: TLink(
            child: Text('禁用'),
            variant: TLinkVariant.icon,
            colorScheme: TLinkColorScheme.primary,
            suffixIconData: TIcons.jump,
            onPressed: null,
          ),
        ),
      ),
    ));

    final icon = tester.widget<Icon>(find.byIcon(TIcons.jump));
    expect(icon.color, token.brandDisabledColor);
  });

  // ============================================================
  // T05d – suffixIconData 图标尺寸跟随 TLinkSize
  // ============================================================
  testWidgets('T05d - suffixIconData 图标尺寸跟随 size', (tester) async {
    final token = TThemeData.defaultData();
    await tester.pumpWidget(MaterialApp(
      theme: TThemeBuilder.light(token),
      home: const Scaffold(
        body: Center(
          child: TLink(
            child: Text('大号'),
            variant: TLinkVariant.icon,
            colorScheme: TLinkColorScheme.primary,
            size: TLinkSize.large,
            suffixIconData: TIcons.jump,
            onPressed: _noop,
          ),
        ),
      ),
    ));

    final icon = tester.widget<Icon>(find.byIcon(TIcons.jump));
    expect(icon.size, 18);
  });

  // ============================================================
  // T05e – prefixIconData 图标正常工作
  // ============================================================
  testWidgets('T05e - prefixIconData 图标渲染', (tester) async {
    await tester.pumpWidget(_wrap(
      const TLink(
        child: Text('前置图标数据'),
        variant: TLinkVariant.icon,
        prefixIconData: TIcons.link,
      ),
    ));

    expect(find.text('前置图标数据'), findsOneWidget);
    expect(find.byIcon(TIcons.link), findsOneWidget);
  });

  // ============================================================
  // T06 – 禁用态（onPressed: null）
  // ============================================================
  testWidgets('T06 - 禁用态（onPressed: null）', (tester) async {
    var tapped = false;
    await tester.pumpWidget(_wrap(
      const TLink(
        child: Text('禁用链接'),
        onPressed: null,
      ),
    ));

    await tester.tap(find.text('禁用链接'), warnIfMissed: false);
    expect(tapped, false);
  });

  // ============================================================
  // T07 – 点击回调
  // ============================================================
  testWidgets('T07 - 点击回调', (tester) async {
    var tapped = false;
    await tester.pumpWidget(_wrap(
      TLink(
        child: const Text('可点击链接'),
        onPressed: () => tapped = true,
      ),
    ));

    await tester.tap(find.text('可点击链接'));
    expect(tapped, true);
  });

  // ============================================================
  // T07b – hover: true（默认）使用 InkWell 提供点击反馈
  // ============================================================
  testWidgets('T07b - hover 默认开启 InkWell 反馈', (tester) async {
    await tester.pumpWidget(_wrap(
      const TLink(
        child: Text('hover 反馈'),
        onPressed: _noop,
      ),
    ));

    // 默认 hover 开启时使用 InkWell 提供点击反馈
    expect(find.byType(InkWell), findsWidgets);
  });

  // ============================================================
  // T07c – hover: false 不使用 InkWell，但仍可点击
  // ============================================================
  testWidgets('T07c - hover 关闭时无 InkWell 反馈且仍可点击', (tester) async {
    var tapped = false;
    await tester.pumpWidget(_wrap(
      TLink(
        child: const Text('无反馈链接'),
        hover: false,
        onPressed: () => tapped = true,
      ),
    ));

    // 关闭 hover 后不再使用 InkWell，改用 GestureDetector（无水波纹）
    expect(find.byType(InkWell), findsNothing);
    expect(find.byType(GestureDetector), findsWidgets);

    await tester.tap(find.text('无反馈链接'));
    expect(tapped, true);
  });

  // ============================================================
  // T07d – hover: false 对 icon 形态同样生效
  // ============================================================
  testWidgets('T07d - icon 形态 hover 关闭时无 InkWell', (tester) async {
    await tester.pumpWidget(_wrap(
      const TLink(
        child: Text('图标无反馈'),
        variant: TLinkVariant.icon,
        hover: false,
        onPressed: _noop,
      ),
    ));

    expect(find.byType(InkWell), findsNothing);
    expect(find.byType(GestureDetector), findsWidgets);
  });

  // ============================================================
  // T08 – colorScheme × variant 颜色映射（通过 resolve）
  // ============================================================
  testWidgets('T08 - colorScheme 颜色映射', (tester) async {
    await tester.pumpWidget(_wrap(
      const TLink(
        child: Text('主题色'),
        colorScheme: TLinkColorScheme.danger,
        variant: TLinkVariant.basic,
      ),
    ));

    final text = tester.widget<Text>(find.text('主题色'));
    expect(text.style?.color, isNotNull);
  });

  // ============================================================
  // T09 – size 三档字号验证
  // ============================================================
  testWidgets('T09 - size 三档字号', (tester) async {
    // Small
    await tester.pumpWidget(_wrap(
      const TLink(child: Text('S'), size: TLinkSize.small),
    ));
    final textS = tester.widget<Text>(find.text('S'));
    expect(textS.style?.fontSize, 12);

    // Medium
    await tester.pumpWidget(_wrap(
      const TLink(child: Text('M'), size: TLinkSize.medium),
    ));
    final textM = tester.widget<Text>(find.text('M'));
    expect(textM.style?.fontSize, 14);

    // Large
    await tester.pumpWidget(_wrap(
      const TLink(child: Text('L'), size: TLinkSize.large),
    ));
    final textL = tester.widget<Text>(find.text('L'));
    expect(textL.style?.fontSize, 16);
  });

  // ============================================================
  // T10 – 自定义颜色覆盖 colorScheme
  // ============================================================
  testWidgets('T10 - 自定义颜色覆盖 colorScheme', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Theme(
              data: ThemeData().copyWith(extensions: [
                const TLinkThemeData(color: Colors.purple),
              ]),
              child: const TLink(
                child: Text('自定义色'),
                colorScheme: TLinkColorScheme.primary,
              ),
            ),
          ),
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('自定义色'));
    expect(text.style?.color, Colors.purple);
  });

  // ============================================================
  // T11 – 自定义字号覆盖 size 默认
  // ============================================================
  testWidgets('T11 - 自定义字号覆盖', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Theme(
              data: ThemeData().copyWith(extensions: [
                const TLinkThemeData(fontSize: 20),
              ]),
              child: const TLink(
                child: Text('自定义字号'),
                size: TLinkSize.medium,
              ),
            ),
          ),
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('自定义字号'));
    expect(text.style?.fontSize, 20);
  });

  // ============================================================
  // T12 – TLinkThemeData 子树注入
  // ============================================================
  testWidgets('T12 - TLinkThemeData 子树注入', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Theme(
            data: ThemeData().copyWith(
              extensions: [
                const TLinkThemeData(
                  defaultVariant: TLinkVariant.underline,
                  fontSize: 18,
                ),
              ],
            ),
            child: Builder(
              builder: (context) {
                return const TLink(
                  child: Text('Theme注入'),
                );
              },
            ),
          ),
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('Theme注入'));
    // Theme 注入的字号应生效（18 覆盖 size 默认 14）
    expect(text.style?.fontSize, 18);
    expect(text.style?.decoration, TextDecoration.underline);
  });

  // ============================================================
  // T13 – TLinkThemeData copyWith
  // ============================================================
  test('T13 - TLinkThemeData copyWith', () {
    const original = TLinkThemeData(fontSize: 14, iconSize: 16);
    final copied = original.copyWith(fontSize: 20);

    expect(copied.fontSize, 20);
    expect(copied.iconSize, 16); // 未覆盖的保持原值
  });

  // ============================================================
  // T14 – TLinkThemeData lerp
  // ============================================================
  test('T14 - TLinkThemeData lerp', () {
    const a = TLinkThemeData(fontSize: 12, iconSize: 14);
    const b = TLinkThemeData(fontSize: 20, iconSize: 24);

    // t=0 时取 a
    final lerpA = a.lerp(b, 0.0);
    expect(lerpA.fontSize, 12);
    expect(lerpA.iconSize, 14);

    // t=1 时取 b
    final lerpB = a.lerp(b, 1.0);
    expect(lerpB.fontSize, 20);
    expect(lerpB.iconSize, 24);
  });

  // ============================================================
  // T15 – Resolve 优先级：Theme > size 默认
  // ============================================================
  testWidgets('T15 - Resolve 优先级', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Theme(
            data: ThemeData().copyWith(
              extensions: [
                const TLinkThemeData(fontSize: 22),
              ],
            ),
            child: Builder(
              builder: (context) {
                return const TLink(
                  child: Text('优先级'),
                  size: TLinkSize.medium, // 默认 14
                );
              },
            ),
          ),
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('优先级'));
    expect(text.style?.fontSize, 22); // Theme(22) 覆盖 size 默认(14)
  });

  // ============================================================
  // T16 – Theme fontSize 覆盖 size 默认
  // ============================================================
  testWidgets('T16 - Theme fontSize 覆盖', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Theme(
              data: ThemeData().copyWith(extensions: [
                const TLinkThemeData(fontSize: 24),
              ]),
              child: const TLink(
                child: Text('覆盖测试'),
                size: TLinkSize.small, // 默认 12
              ),
            ),
          ),
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('覆盖测试'));
    expect(text.style?.fontSize, 24);
  });

  // ============================================================
  // T17b – 长文本单行省略
  // ============================================================
  testWidgets('T17b - 长文本单行省略', (tester) async {
    const longText = '这是一个非常非常非常长的链接文案用于验证不会换行和撑坏布局';
    await tester.pumpWidget(_wrap(
      const TLink(
        child: Text(longText),
      ),
    ));

    final text = tester.widget<Text>(find.text(longText));
    expect(text.maxLines, 1);
    expect(text.softWrap, isFalse);
    expect(text.overflow, TextOverflow.ellipsis);
  });

  testWidgets('T17c - 图标链接在窄容器中保留图标并省略长文本', (tester) async {
    const longText = '这是一个非常非常非常长的图标链接文案用于验证不会撑坏布局';
    await tester.pumpWidget(_wrap(
      const SizedBox(
        width: 120,
        child: TLink(
          child: Text(longText),
          variant: TLinkVariant.icon,
        ),
      ),
    ));

    expect(tester.takeException(), isNull);
    expect(find.byIcon(TIcons.link), findsOneWidget);
    expect(find.byIcon(TIcons.jump), findsOneWidget);
    final text = tester.widget<Text>(find.text(longText));
    expect(text.maxLines, 1);
    expect(text.softWrap, isFalse);
    expect(text.overflow, TextOverflow.ellipsis);
    expect(tester.getSize(find.byType(TLink)).width, lessThanOrEqualTo(120));
  });

  // ============================================================
  // T17 – 非 Text child（DefaultTextStyle 包裹）
  // ============================================================
  testWidgets('T17 - 非 Text child', (tester) async {
    await tester.pumpWidget(_wrap(
      const TLink(
        child: Text.rich(
          TextSpan(
            text: '富文本',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        variant: TLinkVariant.underline,
      ),
    ));

    expect(find.text('富文本'), findsOneWidget);
  });

  testWidgets('T18 - full theme does not override colorScheme', (tester) async {
    final token = TThemeData.defaultData();
    await tester.pumpWidget(MaterialApp(
      theme: TThemeBuilder.light(token),
      home: const Scaffold(
        body: Column(
          children: [
            TLink(
              child: Text('主色'),
              colorScheme: TLinkColorScheme.primary,
              onPressed: _noop,
            ),
            TLink(
              child: Text('默认色'),
              colorScheme: TLinkColorScheme.defaultTheme,
              onPressed: _noop,
            ),
            TLink(
              child: Text('危险色'),
              colorScheme: TLinkColorScheme.danger,
              onPressed: _noop,
            ),
          ],
        ),
      ),
    ));

    expect(tester.widget<Text>(find.text('主色')).style?.color,
        token.brandNormalColor);
    expect(tester.widget<Text>(find.text('默认色')).style?.color,
        token.textColorPrimary);
    expect(tester.widget<Text>(find.text('危险色')).style?.color,
        token.errorNormalColor);
  });

  testWidgets('T19 - theme defaults apply without strong global overrides',
      (tester) async {
    final token = TThemeData.defaultData();
    await tester.pumpWidget(MaterialApp(
      theme: TThemeBuilder.light(token).mergeExtension(
        const TLinkThemeData(
          defaultColorScheme: TLinkColorScheme.success,
          defaultSize: TLinkSize.large,
          defaultVariant: TLinkVariant.underline,
        ),
      ),
      home: const Scaffold(
        body: TLink(
          child: Text('默认主题'),
          onPressed: _noop,
        ),
      ),
    ));

    final text = tester.widget<Text>(find.text('默认主题'));
    expect(text.style?.color, token.successNormalColor);
    expect(text.style?.fontSize, 16);
    expect(text.style?.decoration, TextDecoration.underline);
  });
}

/// 最小化包装
Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Center(child: child),
    ),
  );
}

void _noop() {}
