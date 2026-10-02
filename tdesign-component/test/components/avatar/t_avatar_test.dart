// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget app(
    Widget child, {
    TAvatarThemeData? avatarTheme,
    TThemeData? tokens,
  }) {
    var theme = TThemeBuilder.light(tokens ?? TThemeData.defaultData());
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
      expect(clip.borderRadius, BorderRadius.circular(9999));
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

    testWidgets('方形头像默认读取 radiusDefault 和 brandColorLightActive', (
      tester,
    ) async {
      final tokens = TThemeData.defaultData().copyWithTThemeData(
        'avatar-design-defaults',
        radiusMap: {'radiusSmall': 3, 'radiusDefault': 9},
        colorMap: {
          'brandColorFocus': Colors.red,
          'brandColorLightActive': Colors.green,
        },
      );
      await tester.pumpWidget(
        app(const TAvatar(shape: TAvatarShape.square), tokens: tokens),
      );

      expect(
        tester.widget<ClipRRect>(find.byType(ClipRRect)).borderRadius,
        BorderRadius.circular(9),
      );
      final background = tester.widget<ColoredBox>(
        find.descendant(
          of: find.byType(TAvatar),
          matching: find.byType(ColoredBox),
        ),
      );
      expect(background.color, Colors.green);
    });

    testWidgets('圆形头像使用组件 Theme 的圆角', (tester) async {
      await tester.pumpWidget(
        app(
          const TAvatar(),
          avatarTheme: const TAvatarThemeData(circleBorderRadius: 10),
        ),
      );

      final clip = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clip.borderRadius, BorderRadius.circular(10));
    });

    testWidgets('未指定组件圆角时读取自定义全局 radiusCircle', (tester) async {
      final tokens =
          TThemeData.defaultData().copyWith(radiusMap: {'radiusCircle': 7})
              as TThemeData;
      await tester.pumpWidget(app(const TAvatar(), tokens: tokens));

      final clip = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clip.borderRadius, BorderRadius.circular(7));
    });

    testWidgets('实例尺寸和形状选择预设，Theme 保留具体视觉值', (tester) async {
      await tester.pumpWidget(
        app(
          const TAvatar(size: TAvatarSize.small, shape: TAvatarShape.circle),
          avatarTheme: const TAvatarThemeData(squareBorderRadius: 6),
        ),
      );

      expect(tester.getSize(find.byType(ClipRRect)), const Size.square(40));
      final clip = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clip.borderRadius, BorderRadius.circular(9999));
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

    testWidgets('字符内容按尺寸应用 Semibold 样式和 Theme 颜色', (tester) async {
      await tester.pumpWidget(
        app(
          const TAvatar(size: TAvatarSize.large, child: Text('A')),
          avatarTheme: const TAvatarThemeData(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
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

    testWidgets('Theme 前景色控制默认文字，child 可单独指定排版', (tester) async {
      await tester.pumpWidget(
        app(
          const TAvatar(child: Text('A', style: TextStyle(letterSpacing: 2))),
          avatarTheme: const TAvatarThemeData(foregroundColor: Colors.white),
        ),
      );

      final style = DefaultTextStyle.of(tester.element(find.text('A'))).style;
      expect(style.color, Colors.white);
      expect(tester.widget<Text>(find.text('A')).style?.letterSpacing, 2);
    });

    testWidgets('shape 指定方形并保持既有圆角', (tester) async {
      await tester.pumpWidget(app(const TAvatar(shape: TAvatarShape.square)));
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

    testWidgets('隐藏成员的尺寸不会改变可见组与折叠头像', (tester) async {
      await tester.pumpWidget(
        app(
          const TAvatarGroup(
            maxCount: 1,
            overflow: TAvatar(child: Text('+1')),
            children: [
              TAvatar(child: Text('A')),
              TAvatar(size: TAvatarSize.large, child: Text('B')),
            ],
          ),
        ),
      );

      expect(find.text('B'), findsNothing);
      expect(tester.getSize(find.byType(TAvatarGroup)), const Size(88, 48));
      expect(
        [
          for (var index = 0; index < 2; index++)
            tester.getSize(find.byType(TAvatar).at(index)),
        ],
        [const Size.square(48), const Size.square(48)],
      );
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

    testWidgets('Theme dimension 控制 44px 外框', (tester) async {
      await tester.pumpWidget(
        app(
          const TAvatarGroup(children: [TAvatar(), TAvatar()]),
          avatarTheme: const TAvatarThemeData(dimension: 44),
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
            .map((decorated) => (decorated as DecoratedBox).child)
            .map((clip) => (clip as ClipRRect).child)
            .map((box) => (box as SizedBox).child)
            .map((scope) => (scope as InheritedWidget).child.key)
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
      expect(memberClips[0].borderRadius, BorderRadius.circular(9999));
      expect(memberClips[1].borderRadius, BorderRadius.circular(6));
    });

    testWidgets('三档组尺寸继承成员尺寸并使用设计稿描边', (tester) async {
      for (final (size, dimension, borderWidth, fontSize) in [
        (TAvatarSize.small, 40.0, 1.0, 14.0),
        (TAvatarSize.medium, 48.0, 2.0, 16.0),
        (TAvatarSize.large, 64.0, 3.0, 20.0),
      ]) {
        await tester.pumpWidget(
          app(
            TAvatarGroup(
              children: [
                TAvatar(size: size, child: const Text('A')),
                const TAvatar(child: Text('B')),
              ],
            ),
          ),
        );
        expect(
          tester.getSize(find.byType(TAvatarGroup)),
          Size(dimension * 2 - 8, dimension),
        );
        final borders = tester
            .widgetList<DecoratedBox>(find.byType(DecoratedBox))
            .map((widget) => widget.decoration)
            .whereType<BoxDecoration>()
            .where((decoration) => decoration.border != null)
            .toList();
        expect(borders.map((decoration) => decoration.border!.top.width), [
          borderWidth,
          borderWidth,
        ]);
        final shadows = tester
            .widgetList<DecoratedBox>(find.byType(DecoratedBox))
            .map((widget) => widget.decoration)
            .whereType<BoxDecoration>()
            .where((decoration) => decoration.boxShadow?.isNotEmpty ?? false)
            .toList();
        expect(shadows, hasLength(2));
        expect(shadows.first.boxShadow!.single.offset, const Offset(1, 0));
        expect(shadows.first.boxShadow!.single.blurRadius, 2);
        expect(
          DefaultTextStyle.of(tester.element(find.text('B'))).style.fontSize,
          fontSize,
        );
      }
    });

    testWidgets('组描边和阴影可由组件 Theme 独立覆盖', (tester) async {
      const shadow = BoxShadow(
        color: Colors.red,
        offset: Offset(2, 1),
        blurRadius: 4,
      );
      await tester.pumpWidget(
        app(
          const TAvatarGroup(
            children: [
              TAvatar(size: TAvatarSize.small),
              TAvatar(),
            ],
          ),
          avatarTheme: const TAvatarThemeData(
            groupBorderWidth: 4,
            groupBorderColor: Colors.green,
            groupShadow: shadow,
          ),
        ),
      );
      final decorations = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .map((widget) => widget.decoration)
          .whereType<BoxDecoration>()
          .toList();
      expect(
        decorations
            .where((value) => value.border != null)
            .every(
              (value) =>
                  value.border!.top.width == 4 &&
                  value.border!.top.color == Colors.green,
            ),
        isTrue,
      );
      expect(
        decorations
            .where((value) => value.boxShadow != null)
            .every((value) => value.boxShadow!.single == shadow),
        isTrue,
      );
    });

    testWidgets('头像组自定义圆角时内容、描边和阴影共用同一形状', (tester) async {
      await tester.pumpWidget(
        app(
          const TAvatarGroup(children: [TAvatar(), TAvatar()]),
          avatarTheme: const TAvatarThemeData(circleBorderRadius: 7),
        ),
      );

      final group = find.byType(TAvatarGroup);
      final decorations = tester
          .widgetList<DecoratedBox>(
            find.descendant(of: group, matching: find.byType(DecoratedBox)),
          )
          .map((widget) => widget.decoration)
          .whereType<BoxDecoration>()
          .where(
            (decoration) =>
                decoration.border != null || decoration.boxShadow != null,
          );
      expect(decorations, hasLength(4));
      for (final decoration in decorations) {
        expect(decoration.shape, BoxShape.rectangle);
        expect(decoration.borderRadius, BorderRadius.circular(7));
      }
      final clips = tester.widgetList<ClipRRect>(
        find.descendant(of: group, matching: find.byType(ClipRRect)),
      );
      expect(clips, hasLength(4));
      for (final clip in clips) {
        expect(clip.borderRadius, BorderRadius.circular(7));
      }
    });

    testWidgets('极小尺寸会收敛到安全约束', (tester) async {
      await tester.pumpWidget(
        app(
          const TAvatarGroup(children: [TAvatar(), TAvatar()]),
          avatarTheme: const TAvatarThemeData(dimension: 1),
        ),
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
      final copied = first.copyWith(dimension: 44);
      expect(copied.dimension, 44);
      expect(copied.iconSize, 20);
      expect(copied.squareBorderRadius, 4);
      expect(copied.backgroundColor, Colors.red);
      expect(copied.foregroundColor, Colors.white);
      expect(copied.groupSpacing, 8);
      expect(copied.groupBorderWidth, 2);
      expect(copied.groupBorderColor, Colors.black);

      final overridden = first.copyWith(
        iconSize: 30,
        squareBorderRadius: 8,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.black,
        groupSpacing: 12,
        groupBorderWidth: 4,
        groupBorderColor: Colors.white,
      );
      expect(overridden.iconSize, 30);
      expect(overridden.squareBorderRadius, 8);
      expect(overridden.backgroundColor, Colors.blue);
      expect(overridden.foregroundColor, Colors.black);
      expect(overridden.groupSpacing, 12);
      expect(overridden.groupBorderWidth, 4);
      expect(overridden.groupBorderColor, Colors.white);
    });

    test('groupShadow 的 copyWith 与 lerp 使用同一默认阴影', () {
      const defaultShadow = BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.15),
        offset: Offset(1, 0),
        blurRadius: 2,
      );
      const customShadow = BoxShadow(
        color: Color(0xFFFF0000),
        offset: Offset(3, 2),
        blurRadius: 6,
      );
      const empty = TAvatarThemeData();
      const custom = TAvatarThemeData(groupShadow: customShadow);

      expect(
        empty.copyWith(groupShadow: customShadow).groupShadow,
        customShadow,
      );
      expect(custom.copyWith(dimension: 64).groupShadow, customShadow);
      expect(empty.lerp(empty, 0.5).groupShadow, isNull);

      final forward = empty.lerp(custom, 0.5).groupShadow;
      final backward = custom.lerp(empty, 0.5).groupShadow;
      expect(forward, BoxShadow.lerp(defaultShadow, customShadow, 0.5));
      expect(backward, BoxShadow.lerp(customShadow, defaultShadow, 0.5));
      expect(empty.lerp(custom, 1).groupShadow, customShadow);
      expect(custom.lerp(empty, 1).groupShadow, defaultShadow);
    });

    test('lerp 插值数值和颜色', () {
      final early = first.lerp(second, 0.25);
      final late = first.lerp(second, 0.75);
      expect(early.dimension, 50);
      expect(late.dimension, 70);
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

    test('Theme 圆角不接受负数', () {
      expect(
        () => TAvatarThemeData(circleBorderRadius: -1),
        throwsAssertionError,
      );
      expect(
        () => TAvatarThemeData(squareBorderRadius: -1),
        throwsAssertionError,
      );
    });

    test('lerp 延迟解析随尺寸和全局 Token 变化的默认值', () {
      const empty = TAvatarThemeData();
      const explicit = TAvatarThemeData(
        dimension: 80,
        iconSize: 40,
        circleBorderRadius: 20,
        squareBorderRadius: 10,
        backgroundColor: Colors.red,
        groupSpacing: 16,
        groupBorderWidth: 4,
      );

      final middle = empty.lerp(explicit, 0.5);
      expect(middle.dimension, isNull);
      expect(middle.iconSize, isNull);
      expect(middle.circleBorderRadius, isNull);
      expect(middle.squareBorderRadius, isNull);
      expect(middle.groupBorderWidth, isNull);
      expect(middle.resolveDimension(TAvatarSize.small), 60);
      expect(middle.resolveDimension(TAvatarSize.medium), 64);
      expect(middle.resolveDimension(TAvatarSize.large), 72);
      expect(middle.resolveIconSize(TAvatarSize.small), 30);
      expect(middle.resolveIconSize(TAvatarSize.medium), 32);
      expect(middle.resolveIconSize(TAvatarSize.large), 36);
      expect(middle.resolveGroupBorderWidth(TAvatarSize.small), 2.5);
      expect(middle.resolveGroupBorderWidth(TAvatarSize.medium), 3);
      expect(middle.resolveGroupBorderWidth(TAvatarSize.large), 3.5);
      expect(middle.resolveCircleBorderRadius(7), 13.5);
      expect(middle.resolveSquareBorderRadius(3), 6.5);
      expect(middle.groupSpacing, 12);
      expect(empty.lerp(explicit, 0.25).backgroundColor, isNull);
      expect(middle.backgroundColor, Colors.red);
      expect(explicit.lerp(empty, 0.25).backgroundColor, Colors.red);
      expect(explicit.lerp(empty, 0.5).backgroundColor, isNull);
      expect(
        middle.copyWith(groupSpacing: 10).resolveDimension(TAvatarSize.small),
        60,
      );
      expect(
        middle.copyWith(dimension: 64).resolveDimension(TAvatarSize.small),
        64,
      );
      final interrupted = middle.lerp(
        const TAvatarThemeData(dimension: 100, circleBorderRadius: 30),
        0.5,
      );
      expect(interrupted.resolveDimension(TAvatarSize.small), 80);
      expect(interrupted.resolveDimension(TAvatarSize.large), 86);
      expect(interrupted.resolveCircleBorderRadius(7), 21.75);
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
          home: const Scaffold(
            body: Column(
              children: [
                TAvatar(size: TAvatarSize.small),
                TAvatar(size: TAvatarSize.medium),
                TAvatar(size: TAvatarSize.large),
              ],
            ),
          ),
        ),
      );

      final avatars = find.byType(TAvatar);
      expect(tester.getSize(avatars.at(0)), const Size.square(60));
      expect(tester.getSize(avatars.at(1)), const Size.square(64));
      expect(tester.getSize(avatars.at(2)), const Size.square(72));
    });

    testWidgets('ThemeData 动画读取小号成员和自定义全局圆角的有效回退', (tester) async {
      final tokens = TThemeData.defaultData().copyWithTThemeData(
        'avatar-interpolation-tokens',
        radiusMap: {'radiusCircle': 7, 'radiusDefault': 3},
      );
      final baseTheme = TThemeBuilder.light(tokens);
      final beginTheme = baseTheme.mergeExtension(const TAvatarThemeData());
      final endTheme = baseTheme.mergeExtension(
        const TAvatarThemeData(
          dimension: 80,
          iconSize: 40,
          circleBorderRadius: 20,
          squareBorderRadius: 10,
          groupBorderWidth: 4,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.lerp(beginTheme, endTheme, 0.5),
          home: const Scaffold(
            body: Column(
              children: [
                TAvatarGroup(
                  children: [
                    TAvatar(size: TAvatarSize.small),
                    TAvatar(size: TAvatarSize.small),
                  ],
                ),
                TAvatar(shape: TAvatarShape.square),
              ],
            ),
          ),
        ),
      );

      final group = find.byType(TAvatarGroup);
      expect(tester.getSize(group), const Size(112, 60));
      final groupBorders = tester
          .widgetList<DecoratedBox>(
            find.descendant(of: group, matching: find.byType(DecoratedBox)),
          )
          .map((widget) => widget.decoration)
          .whereType<BoxDecoration>()
          .where((decoration) => decoration.border != null);
      expect(groupBorders, hasLength(2));
      for (final border in groupBorders) {
        expect(border.border!.top.width, 2.5);
        expect(border.borderRadius, BorderRadius.circular(13.5));
      }
      final square = find.byWidgetPredicate(
        (widget) => widget is TAvatar && widget.shape == TAvatarShape.square,
      );
      expect(tester.getSize(square), const Size.square(64));
      final squareClip = tester.widget<ClipRRect>(
        find.descendant(of: square, matching: find.byType(ClipRRect)),
      );
      expect(squareClip.borderRadius, BorderRadius.circular(6.5));
    });

    test('TAvatarGroup 拒绝非正 maxCount', () {
      expect(
        () => TAvatarGroup(children: const [], maxCount: 0),
        throwsAssertionError,
      );
      expect(() => TAvatarThemeData(dimension: 0), throwsAssertionError);
      expect(
        () => TAvatarGroup(children: const [], spacing: -1),
        throwsAssertionError,
      );
      expect(
        () => TAvatarThemeData(dimension: 44, groupSpacing: 100),
        throwsAssertionError,
      );
      expect(
        () => TAvatarThemeData(dimension: double.infinity),
        throwsAssertionError,
      );
      expect(
        () => TAvatarThemeData(dimension: 44, groupBorderWidth: 23),
        throwsAssertionError,
      );
    });
  });
}
