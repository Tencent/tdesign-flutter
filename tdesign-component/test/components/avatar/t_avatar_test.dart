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
    return MaterialApp(home: Scaffold(body: child), theme: theme);
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
            tester.getSize(find.byType(ClipRRect)), Size.square(entry.value));
      });
    }

    testWidgets('方形头像使用 Theme 圆角', (tester) async {
      await tester.pumpWidget(app(
        const TAvatar(variant: TAvatarVariant.square),
        avatarTheme: const TAvatarThemeData(squareBorderRadius: 6),
      ));

      final clip = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clip.borderRadius, BorderRadius.circular(6));
    });

    testWidgets('实例尺寸和形状覆盖 Theme', (tester) async {
      await tester.pumpWidget(app(
        const TAvatar(
          size: TAvatarSize.small,
          variant: TAvatarVariant.circle,
        ),
        avatarTheme: const TAvatarThemeData(
          size: TAvatarSize.large,
          variant: TAvatarVariant.square,
        ),
      ));

      expect(tester.getSize(find.byType(ClipRRect)), const Size.square(40));
      final clip = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clip.borderRadius, BorderRadius.circular(20));
    });

    testWidgets('Theme 可控制尺寸、图标和颜色', (tester) async {
      await tester.pumpWidget(app(
        const TAvatar(),
        avatarTheme: const TAvatarThemeData(
          dimension: 72,
          iconSize: 30,
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
      ));

      expect(tester.getSize(find.byType(ClipRRect)), const Size.square(72));
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, 30);
      expect(icon.color, Colors.white);
      final coloredBox = tester.widget<ColoredBox>(find.byType(ColoredBox));
      expect(coloredBox.color, Colors.red);
    });

    testWidgets('自定义 child 替代默认图标', (tester) async {
      await tester.pumpWidget(app(const TAvatar(child: Text('RS'))));

      expect(find.text('RS'), findsOneWidget);
      expect(find.byType(Icon), findsNothing);
    });

    testWidgets('图片使用指定 fit 并保留 fallback child', (tester) async {
      final bytes = Uint8List.fromList(base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQIHWP4z8DwHwAFgAI/ScL7WQAAAABJRU5ErkJggg==',
      ));
      await tester.pumpWidget(app(TAvatar(
        image: MemoryImage(bytes),
        fit: BoxFit.contain,
        child: const Text('fallback'),
      )));

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.fit, BoxFit.contain);
      expect(find.text('fallback'), findsOneWidget);
    });

    testWidgets('图片加载失败使用空错误占位且不抛异常', (tester) async {
      await tester.pumpWidget(app(const TAvatar(
        image: AssetImage('missing-avatar.png'),
      )));
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
      await tester.pumpWidget(app(const TAvatarGroup(
        spacing: 10,
        children: [TAvatar(), TAvatar(), TAvatar()],
      )));

      expect(find.byType(TAvatar), findsNWidgets(3));
      expect(tester.getSize(find.byType(TAvatarGroup)), const Size(124, 48));
    });

    testWidgets('maxCount 截断并添加 overflow', (tester) async {
      await tester.pumpWidget(app(const TAvatarGroup(
        maxCount: 2,
        overflow: TAvatar(child: Text('+1')),
        children: [TAvatar(), TAvatar(), TAvatar()],
      )));

      expect(find.byType(TAvatar), findsNWidgets(3));
      expect(find.text('+1'), findsOneWidget);
    });

    testWidgets('无 overflow 时只显示 maxCount 个', (tester) async {
      await tester.pumpWidget(app(const TAvatarGroup(
        maxCount: 1,
        children: [TAvatar(), TAvatar()],
      )));
      expect(find.byType(TAvatar), findsOneWidget);
    });

    testWidgets('Theme 控制组布局和描边', (tester) async {
      await tester.pumpWidget(app(
        const TAvatarGroup(children: [TAvatar(), TAvatar()]),
        avatarTheme: const TAvatarThemeData(
          dimension: 60,
          groupSpacing: 12,
          groupBorderWidth: 3,
          groupBorderColor: Colors.green,
        ),
      ));

      expect(tester.getSize(find.byType(TAvatarGroup)), const Size(108, 60));
      final decoration = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .map((widget) => widget.decoration)
          .whereType<BoxDecoration>()
          .firstWhere((value) => value.border != null);
      expect(decoration.border!.top.width, 3);
      expect(decoration.border!.top.color, Colors.green);
    });
  });

  group('TAvatarThemeData', () {
    const first = TAvatarThemeData(
      size: TAvatarSize.small,
      variant: TAvatarVariant.circle,
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
      variant: TAvatarVariant.square,
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
      final copied =
          first.copyWith(dimension: 44, variant: TAvatarVariant.square);
      expect(copied.size, TAvatarSize.small);
      expect(copied.variant, TAvatarVariant.square);
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
      expect(early.variant, TAvatarVariant.circle);
      expect(late.variant, TAvatarVariant.square);
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

    test('TAvatarGroup 拒绝非正 maxCount', () {
      expect(
        () => TAvatarGroup(children: const [], maxCount: 0),
        throwsAssertionError,
      );
    });
  });
}
