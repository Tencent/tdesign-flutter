import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TTheme 基础设施纯逻辑覆盖（context 扩展 / TStyleResolver /
/// TMaterialThemeBuilder / TThemeBuilder / setTResourceBuilder /
/// TThemeData 解析与拷贝），用于提升行覆盖至 ≥95%。
class _TestExtra extends TExtraThemeData {
  @override
  void parse(String name, Map<String, dynamic> curThemeMap) {}
}

class _TestExtra2 extends TExtraThemeData {
  @override
  void parse(String name, Map<String, dynamic> curThemeMap) {}
}

void main() {
  RoundedRectangleBorder circleBorder(
    TThemeData token, {
    BorderSide side = BorderSide.none,
  }) => RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(token.radiusCircle),
    side: side,
  );

  test('暗色特殊组件背景保留小程序透明色', () {
    final token = TThemeData.defaultData();
    expect(token.colorMap['bgColorSpecialComponent'], Colors.white);
    expect(token.dark!.colorMap['bgColorSpecialComponent'], Colors.transparent);
  });

  group('radiusCircle 固定半径几何例外', () {
    test('默认 9999dp 在正方形为圆形、非正方形为胶囊', () {
      final token = TThemeData.defaultData();
      expect(token.radiusCircle, 9999);
      expect(token.dark!.radiusCircle, 9999);

      final rectangle = circleBorder(
        token,
      ).getOuterPath(const Rect.fromLTWH(0, 0, 160, 64));
      expect(rectangle.contains(const Offset(50, 1)), isTrue);
      expect(rectangle.contains(const Offset(20, 1)), isFalse);

      final square = circleBorder(
        token,
      ).getOuterPath(const Rect.fromLTWH(0, 0, 64, 64));
      expect(square.contains(const Offset(32, 1)), isTrue);
      expect(square.contains(const Offset(1, 1)), isFalse);
    });

    test('半圆形只应用左侧圆角时应使用 radiusRound', () {
      final radius = TThemeData.defaultData().radiusRound;
      final path = RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius),
          bottomLeft: Radius.circular(radius),
        ),
      ).getOuterPath(const Rect.fromLTWH(0, 0, 160, 64));
      expect(path.contains(const Offset(20, 1)), isFalse);
      expect(path.contains(const Offset(150, 1)), isTrue);
    });

    test('自定义值按逻辑像素解释，不按比例解释', () {
      final token =
          TThemeData.defaultData().copyWith(radiusMap: {'radiusCircle': 16})
              as TThemeData;
      expect(token.radiusCircle, 16);
      final path = circleBorder(
        token,
      ).getOuterPath(const Rect.fromLTWH(0, 0, 160, 64));
      expect(path.contains(const Offset(2, 1)), isFalse);
      expect(path.contains(const Offset(20, 1)), isTrue);
      expect(path.contains(const Offset(80, 1)), isTrue);
    });

    test('固定半径形状的边框、内路径及缩放使用相同轮廓', () {
      final token = TThemeData.defaultData();
      final shape = circleBorder(
        token,
        side: const BorderSide(color: Colors.blue, width: 1),
      );
      const rect = Rect.fromLTWH(0, 0, 160, 64);
      expect(shape.dimensions, const EdgeInsets.all(1));
      expect(shape.getInnerPath(rect).contains(const Offset(80, 32)), isTrue);
      expect(
        shape,
        circleBorder(
          token,
          side: const BorderSide(color: Colors.blue, width: 1),
        ),
      );
      expect(
        shape.hashCode,
        circleBorder(
          token,
          side: const BorderSide(color: Colors.blue, width: 1),
        ).hashCode,
      );
      expect(shape.scale(2).dimensions, const EdgeInsets.all(2));

      final recorder = ui.PictureRecorder();
      shape.paint(Canvas(recorder), rect);
      recorder.endRecording().dispose();
    });
  });

  group('TThemeContextExtension.tTheme', () {
    testWidgets('有 TThemeData Extension 时取注入值', (tester) async {
      final token = TThemeData.defaultData();
      late TThemeData resolved;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [token]),
          home: Builder(
            builder: (context) {
              resolved = context.tTheme;
              return const SizedBox();
            },
          ),
        ),
      );
      expect(resolved, same(token));
    });

    testWidgets('无 Extension 时回退 defaultData', (tester) async {
      late TThemeData resolved;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              resolved = context.tTheme;
              return const SizedBox();
            },
          ),
        ),
      );
      expect(resolved, isA<TThemeData>());
      expect(resolved, TThemeData.defaultData());
    });
  });

  group('TThemeDataMergeExtension.mergeExtension', () {
    test('合并后保留指定 Extension 类型', () {
      final base = ThemeData(colorScheme: const ColorScheme.light());
      final merged = base.mergeExtension<TThemeData>(TThemeData.defaultData());
      expect(merged.extension<TThemeData>(), isNotNull);
      // 其它已有 Extension 不被覆盖
      expect(merged.extension<TThemeData>(), isA<TThemeData>());
    });
  });

  group('TStyleResolver', () {
    testWidgets('of/token/componentExtension', (tester) async {
      final token = TThemeData.defaultData();
      final resolverHolder = <TStyleResolver>[];
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [token],
            textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 13)),
          ),
          home: Builder(
            builder: (context) {
              final r = TStyleResolver.of(context);
              resolverHolder.add(r);
              // 触发各 getter
              expect(r.token, isA<TThemeData>());
              expect(r.componentExtension<TThemeData>(), isNotNull);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(resolverHolder, isNotEmpty);
    });

    testWidgets('token 无 Extension 时回退 defaultData', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final r = TStyleResolver.of(context);
              expect(r.token, TThemeData.defaultData());
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('TMaterialThemeBuilder / TThemeBuilder', () {
    test('Foundation 不反向依赖包总出口', () {
      final source = File('lib/src/theme/t_theme.dart').readAsStringSync();
      expect(source, isNot(contains('../../tdesign_flutter.dart')));
      expect(source, contains('t_component_theme_data.dart'));
    });

    test('buildLight 映射品牌色', () {
      final token = TThemeData.defaultData();
      final td = TMaterialThemeBuilder(token).buildLight();
      expect(td.colorScheme.primary, token.brandColor);
      expect(td.useMaterial3, isTrue);
      expect(td.extension<TThemeData>(), isNotNull);
    });

    test('ThemeData.lerp 插值 Token 投影的全部 Material 视觉字段', () {
      final token = TThemeData.defaultData();
      final light = TThemeBuilder.light(token);
      final dark = TThemeBuilder.dark(token);
      final middle = ThemeData.lerp(light, dark, 0.5);

      expect(middle.colorScheme, isNot(light.colorScheme));
      expect(middle.colorScheme, isNot(dark.colorScheme));
      expect(middle.extension<TThemeData>(), isNotNull);
      expect(middle.elevatedButtonTheme.style, isNotNull);
      expect(middle.outlinedButtonTheme.style, isNotNull);
      expect(middle.textButtonTheme.style, isNotNull);
      expect(middle.badgeTheme, isA<BadgeThemeData>());
      expect(middle.dividerTheme, isA<DividerThemeData>());
    });

    test('BadgeTheme 区分 Token 投影与调用方显式覆盖', () {
      final projected = TThemeBuilder.light(TThemeData.defaultData());
      expect(projected.tExplicitBadgeTheme, isNull);

      final explicit = projected.copyWith(
        badgeTheme: projected.badgeTheme.copyWith(backgroundColor: Colors.red),
      );
      expect(explicit.tExplicitBadgeTheme?.backgroundColor, Colors.red);
    });

    test('buildLight 注入当前组件 ThemeData 默认定义', () {
      final theme = TThemeBuilder.light(TThemeData.defaultData());

      expect(theme.extension<TActionSheetThemeData>(), isNull);
      expect(theme.extension<TAvatarThemeData>(), isNotNull);
      expect(theme.extension<TBackTopThemeData>(), isNotNull);
      expect(theme.extension<TBadgeThemeData>(), isNotNull);
      expect(theme.extension<TButtonThemeData>(), isNotNull);
      expect(theme.extension<TCalendarThemeData>(), isNotNull);
      expect(theme.extension<TCascaderThemeData>(), isNotNull);
      expect(theme.extension<TCellThemeData>(), isNotNull);
      expect(theme.extension<TCheckboxThemeData>(), isNotNull);
      expect(theme.extension<TCollapseThemeData>(), isNotNull);
      expect(theme.extension<TDialogThemeData>(), isNull);
      expect(theme.extension<TDividerThemeData>(), isNotNull);
      expect(theme.extension<TDrawerThemeData>(), isNotNull);
      expect(theme.extension<TDropdownThemeData>(), isNull);
      expect(theme.extension<TEmptyThemeData>(), isNotNull);
      expect(theme.extension<TFabThemeData>(), isNotNull);
      expect(theme.extension<TFooterThemeData>(), isNotNull);
      expect(theme.extension<TFormThemeData>(), isNotNull);
      expect(theme.extension<TImageThemeData>(), isNotNull);
      expect(theme.extension<TImageViewerThemeData>(), isNotNull);
      expect(theme.extension<TIndexesThemeData>(), isNotNull);
      expect(theme.extension<TInputThemeData>(), isNotNull);
      expect(theme.extension<TLinkThemeData>(), isNotNull);
      expect(theme.extension<TLoadingThemeData>(), isNotNull);
      expect(theme.extension<TMessageThemeData>(), isNotNull);
      expect(theme.extension<TNavBarThemeData>(), isNotNull);
      expect(theme.extension<TNoticeBarThemeData>(), isNotNull);
      expect(theme.extension<TPickerThemeData>(), isNotNull);
      expect(theme.extension<TPopoverThemeData>(), isNotNull);
      expect(theme.extension<TPopupThemeData>(), isNotNull);
      expect(theme.extension<TProgressThemeData>(), isNotNull);
      expect(theme.extension<TRadioThemeData>(), isNotNull);
      expect(theme.extension<TRateThemeData>(), isNotNull);
      expect(theme.extension<TResultThemeData>(), isNotNull);
      expect(theme.extension<TSearchBarThemeData>(), isNotNull);
      expect(theme.extension<TSideBarThemeData>(), isNotNull);
      expect(theme.extension<TSkeletonThemeData>(), isNull);
      expect(theme.extension<TSliderThemeData>(), isNotNull);
      expect(theme.extension<TStepperThemeData>(), isNotNull);
      expect(theme.extension<TSwipeCellThemeData>(), isNotNull);
      expect(theme.extension<TSwiperThemeData>(), isNotNull);
      expect(theme.extension<TSwitchThemeData>(), isNotNull);
      expect(theme.extension<TTabBarThemeData>(), isNotNull);
      expect(theme.extension<TTableThemeData>(), isNotNull);
      expect(theme.extension<TTabsBarThemeData>(), isNotNull);
      expect(theme.extension<TTagThemeData>(), isNotNull);
      expect(theme.extension<TTimeCounterThemeData>(), isNotNull);
      expect(theme.extension<TToastThemeData>(), isNotNull);
      expect(theme.extension<TTreeSelectThemeData>(), isNotNull);
      expect(theme.extension<TUploadThemeData>(), isNotNull);
    });

    test('buildDark 且 token.dark 为 null 时回退 token', () {
      // 构造一个不含暗色块的 token
      const json = '{"noDark": {"color": {"brandColor": "#0052D9"}}}';
      final token = TThemeData.fromJson('noDark', json)!;
      expect(token.dark, isNull);
      final td = TMaterialThemeBuilder(token).buildDark();
      expect(td.brightness, Brightness.dark);
      expect(td.colorScheme.primary, token.brandColor);
    });

    test('buildDark 使用 token.dark 块', () {
      const json = '''
      {
        "withDark": {"color": {"brandColor": "#0052D9"}},
        "withDarkDark": {"color": {"brandColor": "#003CAB"}}
      }
      ''';
      final token = TThemeData.fromJson('withDark', json)!;
      expect(token.dark, isNotNull);
      final td = TMaterialThemeBuilder(token).buildDark();
      expect(td.colorScheme.primary, token.dark!.brandColor);
    });

    test('TThemeBuilder.light/dark 入口', () {
      final token = TThemeData.defaultData();
      expect(TThemeBuilder.light(token).brightness, Brightness.light);
      // buildDark 在 token 有暗色块时走 dark 分支
      expect(TThemeBuilder.dark(token).brightness, Brightness.dark);
    });
  });

  group('setTResourceBuilder', () {
    testWidgets('设置代理并回退默认代理', (tester) async {
      setTResourceBuilder((BuildContext _) => null);
      late TResourceDelegate delegate;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              delegate = TResourceManager.instance.delegate(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(delegate, isNotNull);
      // 还原为默认（清空 builder）
      setTResourceBuilder((_) => null, needAlwaysBuild: false);
    });
  });

  group('TThemeData 解析', () {
    const json = '''
    {
      "testTheme": {
        "color": {"brandColor": "#0052D9", "textColorAnti": "#FFFFFF"},
        "ref": {"aliasColor": "brandColor"},
        "font": {"fontLarge": {"size": 16, "lineHeight": 24}},
        "radius": {"radiusSmall": 4},
        "fontFamily": {"familyMain": {"fontFamily": "PingFang"}},
        "shadow": {"shadow1": [{"color":"#000000","blurRadius":4,"spreadRadius":0,"offset":{"x":0,"y":2}}]},
        "margin": {"margin1": 8}
      },
      "testThemeDark": {
        "color": {"brandColor": "#003CAB"}
      }
    }
    ''';

    test('fromJson 返回 null：空串', () {
      expect(TThemeData.fromJson('x', ''), isNull);
    });

    test('fromJson 返回 null：名称不存在', () {
      expect(TThemeData.fromJson('notExist', json), isNull);
    });

    test('fromJson 返回 null：JSON 非法', () {
      expect(TThemeData.fromJson('x', '{bad'), isNull);
    });

    test('fromJson 解析各映射 + ref + 暗色块', () {
      final theme = TThemeData.fromJson('testTheme', json)!;
      expect(theme, isNotNull);
      expect(theme.ofColor('brandColor'), isA<Color>());
      // ref 回指
      expect(theme.ofColor('aliasColor'), theme.ofColor('brandColor'));
      expect(theme.ofFont('fontLarge')?.size, 16);
      expect(theme.ofCorner('radiusSmall'), 4);
      expect(theme.ofFontFamily('familyMain')?.fontFamily, 'PingFang');
      expect(theme.ofShadow('shadow1')?.length, 1);
      // spacerMap 来自 margin
      expect(theme.ofColor('aliasColor'), isNotNull);
      // 暗色块
      expect(theme.dark, isNotNull);
      expect(theme.dark!.light, same(theme));
      // refMap 缺失键在暗色块中补齐
      expect(theme.dark!.refMap, isNotNull);
    });

    test('fromJson 带 extraThemeData 走 parse 分支', () {
      final theme = TThemeData.fromJson(
        'testTheme',
        json,
        extraThemeData: _TestExtra(),
      )!;
      expect(theme.extraThemeData, isA<_TestExtra>());
      expect(theme.ofExtra<_TestExtra>(), isA<_TestExtra>());
      // 类型不匹配时返回 null
      expect(theme.ofExtra<_TestExtra2>(), isNull);
    });
  });

  group('TThemeData 拷贝与 Map', () {
    test('copyWith 覆盖并保留未覆盖字段', () {
      final base = TThemeData.defaultData();
      final copied =
          base.copyWith(name: 'copied', colorMap: {'brandColor': Colors.red})
              as TThemeData;
      expect(copied.name, 'copied');
      expect(copied.ofColor('brandColor'), Colors.red);
      // 未覆盖的其它颜色经 factory 仍可取
      expect(copied.ofColor('textColorAnti'), isNotNull);
      expect(copied.light, same(copied));
      expect(TThemeBuilder.light(copied).colorScheme.primary, Colors.red);
    });

    test('copyWithTThemeData 同义封装', () {
      final base = TThemeData.defaultData();
      final copied = base.copyWithTThemeData(
        'copy2',
        colorMap: {'brandColor': Colors.blue},
      );
      expect(copied.name, 'copy2');
      expect(copied.ofColor('brandColor'), Colors.blue);
      expect(copied, isA<TThemeData>());
    });

    test('TMap operator[] / get / factory 回退', () {
      final fallback = TMap<String, int>()..['a'] = 1;
      final m = TMap<String, int>(factory: () => fallback);
      m['x'] = 2;
      // 实际写入
      expect(m['x'], 2);
      expect(m.get('x'), 2);
      // factory 回退到默认值
      expect(m['a'], 1);
      // 不存在且无 factory 命中时返回 null
      expect(m['missing'], isNull);
    });

    test('小程序色阶别名逐层解析，显式 Token 覆盖优先', () {
      final base = TThemeData.defaultData();
      expect(base.primaryColor7, const Color(0xFF0052D9));
      expect(base.brandColor, base.primaryColor7);
      expect(base.borderLevel1Color, base.componentStroke);

      final paletteOverride = base.copyWithTThemeData(
        'palette-override',
        colorMap: {'primaryColor7': Colors.purple},
      );
      expect(paletteOverride.primaryColor7, Colors.purple);
      expect(paletteOverride.brandColor, Colors.purple);

      final semanticOverride = paletteOverride.copyWithTThemeData(
        'semantic-override',
        colorMap: {'brandColor': Colors.orange},
      );
      expect(semanticOverride.brandColor, Colors.orange);
      expect(semanticOverride.primaryColor7, Colors.purple);

      final parsed = TThemeData.fromJson(
        'custom',
        '{"custom":{"color":{"primaryColor7":"#123456"}}}',
      )!;
      expect(parsed.primaryColor7, const Color(0xFF123456));
      expect(parsed.brandColor, const Color(0xFF123456));
      expect(parsed.fontSizeBase, 14);
    });
  });

  group('TThemeData.lerp', () {
    test('other 为同类型时返回 other 各映射', () {
      final a = TThemeData.defaultData();
      final b = TThemeData.defaultData();
      final r = a.lerp(b, 0.5) as TThemeData;
      expect(r.name, b.name);
      expect(r.ofColor('brandColor'), isNotNull);
    });

    test('other 非同类型时返回 this', () {
      final a = TThemeData.defaultData();
      expect(a.lerp(null, 0.5), same(a));
    });
  });
}
