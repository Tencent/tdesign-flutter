import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../tdesign_flutter.dart';
import '../util/log.dart';
import '../util/string_util.dart';
import 'td_default_theme.dart';

/// 主题控件
class TTheme extends StatelessWidget {
  const TTheme({
    required this.data,
    required this.child,
    this.systemData,
    Key? key,
  }) : super(key: key);

  /// 仅使用Default主题，不需要切换主题功能
  static bool _needMultiTheme = false;

  /// 主题数据
  static TThemeData? _singleData;

  /// 子控件
  final Widget child;

  /// 主题数据
  final TThemeData data;

  /// Flutter系统主题数据
  final ThemeData? systemData;

  @override
  Widget build(BuildContext context) {
    if (!_needMultiTheme) {
      _singleData = data;
    }
    var extensions = [data];
    return Theme(
        data: systemData?.copyWith(extensions: extensions) ??
            ThemeData(extensions: extensions),
        child: child);
  }

  /// 开启多套主题功能
  static void needMultiTheme([bool value = true]) {
    _needMultiTheme = value;
  }

  /// 设置资源代理,
  /// needAlwaysBuild=true:每次都会走build方法;如果全局有多个Delegate,需要区分情况去获取,则可以设置needAlwaysBuild为true,业务自己判断返回哪个delegate
  /// needAlwaysBuild=false:返回delegate为null,则每次都会走build方法,返回了
  static void setResourceBuilder(
    TResourceBuilder delegate, {
    bool needAlwaysBuild = false,
  }) {
    TResourceManager.instance.setResourceBuilder(delegate, needAlwaysBuild);
  }

  /// 获取默认主题数据，全局唯一
  static TThemeData defaultData() {
    return TThemeData.defaultData();
  }

  /// 获取主题数据，如果未传context则获取全局唯一的默认数据,
  /// 传了context，则获取最近的主题，取不到则会获取全局唯一默认数据
  static TThemeData of([BuildContext? context]) {
    if (!_needMultiTheme || context == null) {
      // 如果context为null,则返回全局默认主题
      return _singleData ?? TThemeData.defaultData();
    }
    // 如果传了context，则从其中获取最近主题
    try {
      var data = Theme.of(context).extensions[TThemeData] as TThemeData?;
      return data ?? TThemeData.defaultData();
    } catch (e) {
      Log.w('TTheme', 'TTheme.of() error: $e');
      return TThemeData.defaultData();
    }
  }

  /// 获取主题数据，取不到则可空
  /// 传了context，则获取最近的主题，取不到或未传context则返回null,
  static TThemeData? ofNullable([BuildContext? context]) {
    if (context != null) {
      // 如果传了context，则从其中获取最近主题
      return Theme.of(context).extensions[TThemeData] as TThemeData?;
    } else {
      // 如果context为null,则返回null
      return null;
    }
  }
}

/// 主题数据
class TThemeData extends ThemeExtension<TThemeData> {
  static const String _defaultThemeName = 'default';
  static const String _defaultDartThemeName = 'defaultDark';
  static TThemeData? _defaultThemeData;

  /// 暗色主题
  TThemeData? dark;

  /// 亮色主题
  late TThemeData light;

  /// 名称
  late String name;

  /// 颜色
  late TMap<String, Color> colorMap;

  /// 字体尺寸
  late TMap<String, Font> fontMap;

  /// 圆角
  late TMap<String, double> radiusMap;

  /// 字体样式
  late TMap<String, FontFamily> fontFamilyMap;

  /// 阴影
  late TMap<String, List<BoxShadow>> shadowMap;

  /// 间隔
  late TMap<String, double> spacerMap;

  /// 映射关系
  late TMap<String, String> refMap;

  /// 额外定义的结构
  late TExtraThemeData? extraThemeData;

  TThemeData({
    required this.name,
    required this.colorMap,
    required this.fontMap,
    required this.radiusMap,
    required this.fontFamilyMap,
    required this.shadowMap,
    required this.spacerMap,
    required this.refMap,
    this.extraThemeData,
  });

  /// 获取默认Data，一个App里只有一个，用于没有context的地方
  static TThemeData defaultData({
    TExtraThemeData? extraThemeData
  }) {
    _defaultThemeData ??= fromJson(_defaultThemeName,
          TDefaultTheme.defaultThemeConfig,
          darkName: _defaultDartThemeName,
          extraThemeData: extraThemeData,
        );
    if(_defaultThemeData == null){
      var emptyData = _emptyData(_defaultThemeName, extraThemeData: extraThemeData);
      emptyData.light = emptyData;
      _defaultThemeData = emptyData;
    }

    return _defaultThemeData!;
  }

  /// 从父类拷贝
  TThemeData copyWithTDThemeData(
    String name, {
    Map<String, Color>? colorMap,
    Map<String, Font>? fontMap,
    Map<String, double>? radiusMap,
    Map<String, FontFamily>? fontFamilyMap,
    Map<String, List<BoxShadow>>? shadowMap,
    Map<String, double>? marginMap,
    TExtraThemeData? extraThemeData,
  }) {
    return copyWith(
      name: name,
      colorMap: colorMap,
      fontMap: fontMap,
      radiusMap: radiusMap,
      fontFamilyMap: fontFamilyMap,
      shadowMap: shadowMap,
      marginMap: marginMap,
      extraThemeData: extraThemeData,
    ) as TThemeData;
  }

  /// 系统主题-亮色模式
  ThemeData? get systemThemeDataLight => ThemeData(
    extensions: [light],
    colorScheme: ColorScheme.light(
      primary: light.brandNormalColor,
    ),
    scaffoldBackgroundColor: light.bgColorPage,
    iconTheme: const IconThemeData().copyWith(
      color: light.brandNormalColor,
    ),
  );

  /// 系统主题-暗色模式
  ThemeData? get systemThemeDataDark=> dark != null ? ThemeData(
    extensions: [dark!],
    colorScheme: ColorScheme.dark(
      primary: dark!.brandNormalColor,
      secondary: dark!.brandNormalColor,
    ),
    scaffoldBackgroundColor: dark!.bgColorPage,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData()
        .copyWith(backgroundColor: dark!.grayColor14),
    appBarTheme: const AppBarTheme().copyWith(
      backgroundColor: dark!.grayColor13,
    ),
    iconTheme: const IconThemeData().copyWith(
      color: dark!.brandNormalColor,
    ),
  ) : null;

  @override
  ThemeExtension<TThemeData> copyWith({
    String? name,
    Map<String, Color>? colorMap,
    Map<String, Font>? fontMap,
    Map<String, double>? radiusMap,
    Map<String, FontFamily>? fontFamilyMap,
    Map<String, List<BoxShadow>>? shadowMap,
    Map<String, double>? marginMap,
    TExtraThemeData? extraThemeData,
  }) {
    return TThemeData(
      name: name ?? 'default',
      colorMap: _copyMap<Color>(this.colorMap, colorMap),
      fontMap: _copyMap<Font>(this.fontMap, fontMap),
      radiusMap: _copyMap<double>(this.radiusMap, radiusMap),
      fontFamilyMap: _copyMap<FontFamily>(this.fontFamilyMap, fontFamilyMap),
      shadowMap: _copyMap<List<BoxShadow>>(this.shadowMap, shadowMap),
      spacerMap: _copyMap<double>(spacerMap, marginMap),
      refMap: _copyMap<String>(refMap, refMap),
      extraThemeData: extraThemeData ?? this.extraThemeData,
    );
  }

  /// 拷贝Map,防止内层
  TMap<String, T> _copyMap<T>(TMap<String, T> src, Map<String, T>? add) {
    var map = TMap<String, T>(factory: () => src);

    src.forEach((key, value) {
      map[key] = value;
    });
    if (add != null) {
      map.addAll(add);
    }
    return map;
  }

  /// 创建空对象
  static TThemeData _emptyData(
    String name, {
    TExtraThemeData? extraThemeData,
  }) {
    var refMap = TMap<String, String>();
    return TThemeData(
      name: name,
      colorMap: TMap(factory: () => defaultData().colorMap, refs: refMap),
      fontMap: TMap(factory: () => defaultData().fontMap, refs: refMap),
      radiusMap: TMap(factory: () => defaultData().radiusMap, refs: refMap),
      fontFamilyMap:
          TMap(factory: () => defaultData().fontFamilyMap, refs: refMap),
      shadowMap: TMap(factory: () => defaultData().shadowMap, refs: refMap),
      spacerMap: TMap(factory: () => defaultData().spacerMap, refs: refMap),
      refMap: refMap,
    );
  }

  /// 解析配置的json文件为主题数据
  ///
  /// [name] 主题名称，目前只支持一级键
  ///
  /// [themeJson] 主题json字符串，要求json配置必须正确
  ///
  /// [recoverDefault] 是否恢复为默认主题数据
  ///
  /// [extraThemeData] 额外扩展的主题数据
  static TThemeData? fromJson(
    String name,
    String themeJson, {
    String? darkName,
    var recoverDefault = false,
    TExtraThemeData? extraThemeData,
  }) {
    if (themeJson.isEmpty) {
      Log.e('TTheme', 'parse themeJson is empty');
      return null;
    }
    try {
      /// 要求json配置必须正确
      final themeConfig = json.decode(themeJson);
      if (themeConfig.containsKey(name)) {
        var theme = parseThemeData(name, themeConfig, extraThemeData);
        theme.light = theme;
        darkName ??= '${name}Dark';
        if (themeConfig[darkName] != null) {
          // 解析暗色模式
          var darkTheme = parseThemeData(darkName, themeConfig, extraThemeData);
          darkTheme.light = theme;
          theme.dark = darkTheme;
          // 填充暗色模式缺失数据
          theme.refMap.forEach((key, value) {
            darkTheme.refMap.putIfAbsent(key, ()=> value);
          });
          // theme.fontMap.forEach((key, value) {
          //   darkTheme.fontMap.putIfAbsent(key, ()=> value);
          // });
          // theme.radiusMap.forEach((key, value) {
          //   darkTheme.radiusMap.putIfAbsent(key, ()=> value);
          // });
          // theme.fontFamilyMap.forEach((key, value) {
          //   darkTheme.fontFamilyMap.putIfAbsent(key, ()=> value);
          // });
          // theme.shadowMap.forEach((key, value) {
          //   darkTheme.shadowMap.putIfAbsent(key, ()=> value);
          // });
          // theme.spacerMap.forEach((key, value) {
          //   darkTheme.spacerMap.putIfAbsent(key, ()=> value);
          // });
        }
        if (recoverDefault) {
          _defaultThemeData = theme;
        }
        return theme;
      } else {
        Log.e('TTheme',
            'load theme error ,not found the theme with name:${name}');
        return null;
      }
    } catch (e) {
      Log.e('TTheme', 'parse theme data error:${e}');
      return null;
    }
  }

  static TThemeData parseThemeData(String name, themeConfig, TExtraThemeData? extraThemeData) {
    var theme = _emptyData(name);
    Map<String, dynamic>? curThemeMap = themeConfig['$name'];
    if (curThemeMap?.isEmpty ?? true) {
      return theme;
    }

    /// 设置颜色
    Map<String, dynamic>? colorsMap = curThemeMap?['color'];
    colorsMap?.forEach((key, value) {
      var color = toColor(value);
      if (color != null) {
        theme.colorMap[key] = color;
      }
    });

    /// 设置颜色
    Map<String, dynamic>? refMap = curThemeMap?['ref'];
    refMap?.forEach((key, value) {
      theme.refMap[key] = value;
    });

    /// 设置字体尺寸
    Map<String, dynamic>? fontsMap = curThemeMap?['font'];
    fontsMap?.forEach((key, value) {
      theme.fontMap[key] = Font.fromJson(value);
    });

    /// 设置圆角
    Map<String, dynamic>? cornersMap = curThemeMap?['radius'];
    cornersMap?.forEach((key, value) {
      theme.radiusMap[key] = value.toDouble();
    });

    /// 设置字体
    Map<String, dynamic>? fontFamilyMap = curThemeMap?['fontFamily'];
    fontFamilyMap?.forEach((key, value) {
      theme.fontFamilyMap[key] = FontFamily.fromJson(value);
    });

    /// 设置阴影
    Map<String, dynamic>? shadowMap = curThemeMap?['shadow'];
    shadowMap?.forEach((key, value) {
      var list = <BoxShadow>[];
      (value as List).forEach((element) {
        list.add(BoxShadow(
          color: toColor(element['color']) ?? Colors.black,
          blurRadius: element['blurRadius'].toDouble(),
          spreadRadius: element['spreadRadius'].toDouble(),
          offset: Offset(element['offset']?['x'].toDouble() ?? 0,
              element['offset']?['y'].toDouble() ?? 0),
        ));
      });

      theme.shadowMap[key] = list;
    });

    /// 设置Margin
    Map<String, dynamic>? marginsMap = curThemeMap?['margin'];
    marginsMap?.forEach((key, value) {
      theme.spacerMap[key] = value.toDouble();
    });

    if (extraThemeData != null && curThemeMap != null) {
      extraThemeData.parse(name, curThemeMap);
      theme.extraThemeData = extraThemeData;
    }
    return theme;
  }

  Color? ofColor(String? key) {
    return colorMap[key];
  }

  Font? ofFont(String? key) {
    return fontMap[key];
  }

  double? ofCorner(
    String? key,
  ) {
    return radiusMap[key];
  }

  FontFamily? ofFontFamily(String? key) {
    return fontFamilyMap[key];
  }

  List<BoxShadow>? ofShadow(String? key) {
    return shadowMap[key];
  }

  T? ofExtra<T extends TExtraThemeData>() {
    try {
      return extraThemeData as T;
    } catch (e) {
      Log.e('TThemeData ofExtra error: $e');
    }
    return null;
  }

  @override
  ThemeExtension<TThemeData> lerp(
    ThemeExtension<TThemeData>? other,
    double t,
  ) {
    if (other is! TThemeData) {
      return this;
    }
    return TThemeData(
      name: other.name,
      colorMap: other.colorMap,
      fontMap: other.fontMap,
      radiusMap: other.radiusMap,
      fontFamilyMap: other.fontFamilyMap,
      shadowMap: other.shadowMap,
      spacerMap: other.spacerMap,
      refMap: other.refMap,
    );
  }
}

/// 扩展主题数据
abstract class TExtraThemeData {
  /// 解析json
  void parse(String name, Map<String, dynamic> curThemeMap);
}

typedef DefaultMapFactory = TMap? Function();

/// 自定义Map
class TMap<K, V> extends DelegatingMap<K, V> {
  TMap({
    this.factory,
    this.refs,
  }) : super({});
  DefaultMapFactory? factory;
  TMap? refs;

  @override
  V? operator [](Object? key) {
    // return super[key];
    key = refs?[key] ?? key;
    var value = super[key];
    if (value != null) {
      return value;
    }
    var defaultValue = factory?.call()?.get(key);
    if (defaultValue is V) {
      return defaultValue;
    }
    return null;
  }

  V? get(Object? key) {
    return super[key];
  }
}
