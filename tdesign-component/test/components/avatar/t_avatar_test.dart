// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget app(Widget child, {TAvatarThemeData? avatarTheme}) {
    var theme = TThemeBuilder.light(TThemeData.defaultData());
    if (avatarTheme != null) {
      theme = theme.mergeExtension(avatarTheme);
    }
    return MaterialApp(
      home: Scaffold(body: child),
      theme: theme,
    );
  }

  group('TAvatar', () {
    testWidgets('默认渲染用户图标和中尺寸圆形头像', (tester) async {
      await tester.pumpWidget(app(const TAvatar()));

      expect(find.byType(Icon), findsOneWidget);
      expect(tester.getSize(find.byType(ClipRRect)), const Size.square(48));
      final clip = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clip.borderRadius, BorderRadius.circular(24));
    });

    for (final entry in const {
      TAvatarSize.large: 64.0,
      TAvatarSize.medium: 48.0,
      TAvatarSize.small: 40.0,
    }.entries) {
      testWidgets('${entry.key.name} 解析尺寸', (tester) async {
        await tester.pumpWidget(app(TAvatar(size: entry.key)));
        expect(
          tester.getSize(find.byType(ClipRRect)),
          Size.square(entry.value),
        );
      });
    }

    testWidgets('方形头像使用 Theme 圆角', (tester) async {
      await tester.pumpWidget(
        app(
          const TAvatar(shape: TAvatarShape.square),
          avatarTheme: const TAvatarThemeData(squareBorderRadius: 6),
        ),
      );

      final clip = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clip.borderRadius, BorderRadius.circular(6));
    });

    testWidgets('实例尺寸和形状覆盖 Theme', (tester) async {
      await tester.pumpWidget(
        app(
          const TAvatar(size: TAvatarSize.small, shape: TAvatarShape.circle),
          avatarTheme: const TAvatarThemeData(
            size: TAvatarSize.large,
            shape: TAvatarShape.square,
          ),
        ),
      );

      expect(tester.getSize(find.byType(ClipRRect)), const Size.square(40));
      final clip = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clip.borderRadius, BorderRadius.circular(20));
    });

    testWidgets('Theme 可控制尺寸、图标和颜色', (tester) async {
      await tester.pumpWidget(
        app(
          const TAvatar(),
          avatarTheme: const TAvatarThemeData(
            dimension: 72,
            iconSize: 30,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
      );

      expect(tester.getSize(find.byType(ClipRRect)), const Size.square(72));
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, 30);
      expect(icon.color, Colors.white);
      final coloredBox = tester.widget<ColoredBox>(
        find
            .descendant(
              of: find.byType(TAvatar),
              matching: find.byType(ColoredBox),
            )
            .first,
      );
      expect(coloredBox.color, Colors.red);
    });

    testWidgets('自定义 child 替代默认图标', (tester) async {
      await tester.pumpWidget(app(const TAvatar(child: Text('RS'))));

      expect(find.text('RS'), findsOneWidget);
      expect(find.byType(Icon), findsNothing);
    });

    testWidgets('字符内容按尺寸应用 Semibold 样式和实例颜色', (tester) async {
      await tester.pumpWidget(
        app(
          const TAvatar(
            size: TAvatarSize.large,
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            child: Text('A'),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('A'));
      final style = DefaultTextStyle.of(tester.element(find.text('A'))).style;
      expect(text.style, isNull);
      expect(style.fontSize, 20);
      expect(style.fontWeight, FontWeight.w600);
      expect(style.color, Colors.white);
      expect(
        tester
            .widget<ColoredBox>(
              find
                  .descendant(
                    of: find.byType(TAvatar),
                    matching: find.byType(ColoredBox),
                  )
                  .first,
            )
            .color,
        Colors.blue,
      );
    });

    testWidgets('实例 foregroundColor 覆盖 Theme 文字颜色', (tester) async {
      await tester.pumpWidget(
        app(
          const TAvatar(foregroundColor: Colors.white, child: Text('A')),
          avatarTheme: const TAvatarThemeData(
            textStyle: TextStyle(color: Colors.red, letterSpacing: 2),
          ),
        ),
      );

      final style = DefaultTextStyle.of(tester.element(find.text('A'))).style;
      expect(style.color, Colors.white);
      expect(style.letterSpacing, 2);
    });

    testWidgets('shape 优先且不能和旧 variant 同时传入', (tester) async {
      expect(
        () =>
            TAvatar(shape: TAvatarShape.circle, variant: TAvatarVariant.square),
        throwsAssertionError,
      );
      await tester.pumpWidget(
        app(const TAvatar(variant: TAvatarVariant.square)),
      );
      expect(
        tester.widget<ClipRRect>(find.byType(ClipRRect)).borderRadius,
        BorderRadius.circular(6),
      );
    });

    testWidgets('图片使用指定 fit 并保留 fallback child', (tester) async {
      final bytes = Uint8List.fromList(
        base64Decode(
          'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQIHWP4z8DwHwAFgAI/ScL7WQAAAABJRU5ErkJggg==',
        ),
      );
      await tester.pumpWidget(
        app(
          TAvatar(
            image: MemoryImage(bytes),
            fit: BoxFit.contain,
            child: const Text('fallback'),
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.fit, BoxFit.contain);
      expect(find.text('fallback'), findsOneWidget);
    });

    testWidgets('图片加载失败使用空错误占位且不抛异常', (tester) async {
      await tester.pumpWidget(
        app(const TAvatar(image: AssetImage('missing-avatar.png'))),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byType(TAvatar), findsOneWidget);
    });

    testWidgets('onTap 为空时无 GestureDetector', (tester) async {
      await tester.pumpWidget(app(const TAvatar()));
      expect(find.byType(GestureDetector), findsNothing);
    });

    testWidgets('onTap 存在时触发回调', (tester) async {
      var taps = 0;
      await tester.pumpWidget(app(TAvatar(onTap: () => taps++)));

      await tester.tap(find.byType(TAvatar));
      expect(taps, 1);
    });
  });

  group('TAvatarGroup', () {
    testWidgets('空列表不占空间', (tester) async {
      await tester.pumpWidget(app(const TAvatarGroup(children: [])));
      expect(find.byType(SizedBox), findsWidgets);
      expect(tester.getSize(find.byType(TAvatarGroup)), Size.zero);
    });

    testWidgets('叠放全部头像并按 spacing 计算宽度', (tester) async {
      await tester.pumpWidget(
        app(
          const TAvatarGroup(
            spacing: 10,
            children: [TAvatar(), TAvatar(), TAvatar()],
          ),
        ),
      );

      expect(find.byType(TAvatar), findsNWidgets(3));
      expect(tester.getSize(find.byType(TAvatarGroup)), const Size(124, 48));
    });

    testWidgets('maxCount 截断并添加 overflow', (tester) async {
      await tester.pumpWidget(
        app(
          const TAvatarGroup(
            maxCount: 2,
            overflow: TAvatar(child: Text('+1')),
            children: [TAvatar(), TAvatar(), TAvatar()],
          ),
        ),
      );

      expect(find.byType(TAvatar), findsNWidgets(3));
      expect(find.text('+1'), findsOneWidget);
    });

    testWidgets('无 overflow 时只显示 maxCount 个', (tester) async {
      await tester.pumpWidget(
        app(const TAvatarGroup(maxCount: 1, children: [TAvatar(), TAvatar()])),
      );
      expect(find.byType(TAvatar), findsOneWidget);
    });

    testWidgets('Theme 控制组布局和描边', (tester) async {
      await tester.pumpWidget(
        app(
          const TAvatarGroup(children: [TAvatar(), TAvatar()]),
          avatarTheme: const TAvatarThemeData(
            dimension: 60,
            groupSpacing: 12,
            groupBorderWidth: 3,
            groupBorderColor: Colors.green,
          ),
        ),
      );

      expect(tester.getSize(find.byType(TAvatarGroup)), const Size(108, 60));
      final decoration = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .map((widget) => widget.decoration)
          .whereType<BoxDecoration>()
          .firstWhere((value) => value.border != null);
      expect(decoration.border!.top.width, 3);
      expect(decoration.border!.top.color, Colors.green);
    });

    testWidgets('实例 dimension 控制 44px 外框且覆盖 Theme', (tester) async {
      await tester.pumpWidget(
        app(
          const TAvatarGroup(dimension: 44, children: [TAvatar(), TAvatar()]),
          avatarTheme: const TAvatarThemeData(dimension: 60),
        ),
      );

      expect(tester.getSize(find.byType(TAvatarGroup)), const Size(80, 44));
    });

    testWidgets('cascading 以 start/end 控制成员绘制层级', (tester) async {
      expect(
        const TAvatarGroup(children: []).cascading,
        TAvatarGroupCascading.endUp,
      );
      const firstKey = ValueKey('first');
      const secondKey = ValueKey('second');
      Future<List<Key?>> stackKeys(TAvatarGroupCascading cascading) async {
        await tester.pumpWidget(
          app(
            TAvatarGroup(
              cascading: cascading,
              children: const [
                TAvatar(key: firstKey),
                TAvatar(key: secondKey),
              ],
            ),
          ),
        );
        final stack = tester
            .widgetList<Stack>(find.byType(Stack))
            .singleWhere(
              (widget) => widget.children.every(
                (child) => child is PositionedDirectional,
              ),
            );
        return stack.children
            .map((positioned) => (positioned as PositionedDirectional).child)
            .map((decorated) => (decorated as DecoratedBox).child)
            .map((padding) => (padding as Padding).child)
            .map((clip) => (clip as ClipRRect).child)
            .map((box) => (box as SizedBox).child)
            .map((fitted) => (fitted as FittedBox).child?.key)
            .toList();
      }

      expect(await stackKeys(TAvatarGroupCascading.startUp), [
        secondKey,
        firstKey,
      ]);
      expect(await stackKeys(TAvatarGroupCascading.endUp), [
        firstKey,
        secondKey,
      ]);
    });

    testWidgets('成员 shape 同时控制组外框和最终裁剪', (tester) async {
      await tester.pumpWidget(
        app(
          const TAvatarGroup(
            children: [
              TAvatar(shape: TAvatarShape.circle),
              TAvatar(shape: TAvatarShape.square),
            ],
          ),
        ),
      );

      final decorations = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .map((widget) => widget.decoration)
          .whereType<BoxDecoration>()
          .where((decoration) => decoration.border != null)
          .toList();
      expect(decorations.map((decoration) => decoration.shape), [
        BoxShape.circle,
        BoxShape.rectangle,
      ]);
      expect(decorations.last.borderRadius, BorderRadius.circular(6));

      final memberClips = tester
          .widgetList<ClipRRect>(
            find.descendant(
              of: find.byType(TAvatarGroup),
              matching: find.byType(ClipRRect),
            ),
          )
          .where((clip) => clip.child is SizedBox)
          .toList();
      expect(memberClips, hasLength(2));
      expect(memberClips[0].borderRadius, BorderRadius.circular(22));
      expect(memberClips[1].borderRadius, BorderRadius.circular(4));
    });

    testWidgets('极小尺寸会收敛到安全约束', (tester) async {
      await tester.pumpWidget(
        app(const TAvatarGroup(dimension: 1, children: [TAvatar(), TAvatar()])),
      );
      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(TAvatarGroup)), const Size(1, 1));
    });

    testWidgets('Theme 超范围值会收敛到安全约束', (tester) async {
      await tester.pumpWidget(
        app(
          const TAvatarGroup(
            key: ValueKey('invalid-theme'),
            children: [TAvatar(), TAvatar()],
          ),
          avatarTheme: const TAvatarThemeData(
            groupSpacing: 100,
            groupBorderWidth: 100,
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(TAvatarGroup)), const Size(48, 48));
    });
  });

  group('TAvatarThemeData', () {
    const first = TAvatarThemeData(
      size: TAvatarSize.small,
      shape: TAvatarShape.circle,
      dimension: 40,
      iconSize: 20,
      squareBorderRadius: 4,
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      groupSpacing: 8,
      groupBorderWidth: 2,
      groupBorderColor: Colors.black,
    );
    const second = TAvatarThemeData(
      size: TAvatarSize.large,
      shape: TAvatarShape.square,
      dimension: 80,
      iconSize: 40,
      squareBorderRadius: 12,
      backgroundColor: Colors.blue,
      foregroundColor: Colors.black,
      groupSpacing: 16,
      groupBorderWidth: 4,
      groupBorderColor: Colors.white,
    );

    test('copyWith 保留原值并覆盖指定值', () {
      final copied = first.copyWith(dimension: 44, shape: TAvatarShape.square);
      expect(copied.size, TAvatarSize.small);
      expect(copied.shape, TAvatarShape.square);
      expect(copied.dimension, 44);
      expect(copied.iconSize, 20);
      expect(copied.squareBorderRadius, 4);
      expect(copied.backgroundColor, Colors.red);
      expect(copied.foregroundColor, Colors.white);
      expect(copied.groupSpacing, 8);
      expect(copied.groupBorderWidth, 2);
      expect(copied.groupBorderColor, Colors.black);

      final overridden = first.copyWith(
        size: TAvatarSize.large,
        iconSize: 30,
        squareBorderRadius: 8,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.black,
        groupSpacing: 12,
        groupBorderWidth: 4,
        groupBorderColor: Colors.white,
      );
      expect(overridden.size, TAvatarSize.large);
      expect(overridden.iconSize, 30);
      expect(overridden.squareBorderRadius, 8);
      expect(overridden.backgroundColor, Colors.blue);
      expect(overridden.foregroundColor, Colors.black);
      expect(overridden.groupSpacing, 12);
      expect(overridden.groupBorderWidth, 4);
      expect(overridden.groupBorderColor, Colors.white);
    });

    test('lerp 插值数值和颜色并切换枚举', () {
      final early = first.lerp(second, 0.25);
      final late = first.lerp(second, 0.75);
      expect(early.size, TAvatarSize.small);
      expect(late.size, TAvatarSize.large);
      expect(early.shape, TAvatarShape.circle);
      expect(late.shape, TAvatarShape.square);
      expect(first.lerp(second, 0.5).dimension, 60);
      expect(first.lerp(second, 0.5).iconSize, 30);
      expect(first.lerp(second, 0.5).squareBorderRadius, 8);
      expect(first.lerp(second, 0.5).groupSpacing, 12);
      expect(first.lerp(second, 0.5).groupBorderWidth, 3);
      expect(first.lerp(second, 0.5).backgroundColor, isNotNull);
      expect(first.lerp(second, 0.5).foregroundColor, isNotNull);
      expect(first.lerp(second, 0.5).groupBorderColor, isNotNull);
    });

    test('lerp null 返回自身', () {
      expect(first.lerp(null, 0.5), same(first));
    });

    test('lerp 从空配置按有效默认值插值且不从透明色渐变', () {
      const empty = TAvatarThemeData();
      const explicit = TAvatarThemeData(
        dimension: 80,
        iconSize: 40,
        squareBorderRadius: 10,
        backgroundColor: Colors.red,
        textStyle: TextStyle(fontSize: 20),
        groupSpacing: 16,
        groupBorderWidth: 4,
      );

      final middle = empty.lerp(explicit, 0.5);
      expect(middle.dimension, 64);
      expect(middle.iconSize, 32);
      expect(middle.squareBorderRadius, 8);
      expect(middle.textStyle?.fontSize, 18);
      expect(middle.groupSpacing, 12);
      expect(middle.groupBorderWidth, 3);
      expect(empty.lerp(explicit, 0.25).backgroundColor, isNull);
      expect(middle.backgroundColor, Colors.red);
      expect(explicit.lerp(empty, 0.25).backgroundColor, Colors.red);
      expect(explicit.lerp(empty, 0.5).backgroundColor, isNull);
    });

    test('lerp 双方均为空时继续交给组件默认值解析', () {
      final middle = const TAvatarThemeData().lerp(
        const TAvatarThemeData(),
        0.5,
      );
      expect(middle.dimension, isNull);
      expect(middle.iconSize, isNull);
      expect(middle.squareBorderRadius, isNull);
      expect(middle.backgroundColor, isNull);
      expect(middle.foregroundColor, isNull);
      expect(middle.textStyle, isNull);
      expect(middle.groupSpacing, isNull);
      expect(middle.groupBorderWidth, isNull);
      expect(middle.groupBorderColor, isNull);
    });

    testWidgets('ThemeData 动画中点使用有效默认尺寸', (tester) async {
      final baseTheme = TThemeBuilder.light(TThemeData.defaultData());
      final beginTheme = baseTheme.mergeExtension(const TAvatarThemeData());
      final endTheme = baseTheme.mergeExtension(
        const TAvatarThemeData(dimension: 80),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.lerp(beginTheme, endTheme, 0.5),
          home: const Scaffold(body: TAvatar()),
        ),
      );

      expect(tester.getSize(find.byType(TAvatar)), const Size.square(64));
    });

    test('TAvatarGroup 拒绝非正 maxCount', () {
      expect(
        () => TAvatarGroup(children: const [], maxCount: 0),
        throwsAssertionError,
      );
      expect(
        () => TAvatarGroup(children: const [], dimension: 0),
        throwsAssertionError,
      );
      expect(
        () => TAvatarGroup(children: const [], spacing: -1),
        throwsAssertionError,
      );
      expect(
        () => TAvatarGroup(children: const [], dimension: 44, spacing: 100),
        throwsAssertionError,
      );
      expect(
        () => TAvatarGroup(children: const [], dimension: double.infinity),
        throwsAssertionError,
      );
      expect(
        () => TAvatarThemeData(dimension: 44, groupBorderWidth: 23),
        throwsAssertionError,
      );
    });
  });
}
