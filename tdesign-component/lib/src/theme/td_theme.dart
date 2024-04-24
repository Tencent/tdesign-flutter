import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../../tdesign_flutter.dart';
import '../util/log.dart';
import '../util/string_util.dart';
import 'basic.dart';
import 'td_default_theme.dart';

/// 主题控件
class TDTheme extends StatelessWidget {

  const TDTheme(
      {required this.data, required this.child, this.systemData, Key? key})
      : super(key: key);

  /// 仅使用Default主题，不需要切换主题功能
  static bool _needMultiTheme = false;

  /// 主题数据
  static TDThemeData? _singleData;

  /// 子控件
  final Widget child;

  /// 主题数据
  final TDThemeData data;

  /// Flutter系统主题数据
  final ThemeData? systemData;

  @override
  Widget build(BuildContext context) {

    if(!_needMultiTheme){
      _singleData = data;
    }
    var extensions = [data];
    return Theme(data: systemData?.copyWith(
      extensions: extensions
    ) ?? ThemeData(extensions: extensions), child: child);
  }

  /// 开启多套主题功能
  static void needMultiTheme([bool value = true]) {
    _needMultiTheme = value;
  }

  /// 获取默认主题数据，全局唯一
  static TDThemeData defaultData() {
    return TDThemeData.defaultData();
  }

  /// 获取主题数据，如果未传context则获取全局唯一的默认数据,
  /// 传了context，则获取最近的主题，取不到则会获取全局唯一默认数据
  static TDThemeData of([BuildContext? context]) {
    if(!_needMultiTheme || context == null){
      // 如果context为null,则返回全局默认主题
      return _singleData ?? TDThemeData.defaultData();
    }
      // 如果传了context，则从其中获取最近主题
      try {
        var data = Theme.of(context).extensions[TDThemeData] as TDThemeData?;
        return data ?? TDThemeData.defaultData();
      } catch (e) {
      Log.w('TDTheme', 'TDTheme.of() error: $e');
        return TDThemeData.defaultData();
      }
  }

  /// 获取主题数据，取不到则可空
  /// 传了context，则获取最近的主题，取不到或未传context则返回null,
  static TDThemeData? ofNullable([BuildContext? context]) {
    if (context != null) {
      // 如果传了context，则从其中获取最近主题
      return Theme.of(context).extensions[TDThemeData] as TDThemeData?;
    } else {
      // 如果context为null,则返回null
      return null;
    }
  }
}

/// 主题数据
class TDThemeData extends ThemeExtension<TDThemeData> {
  static const String _defaultThemeName = 'default';
  static TDThemeData? _defaultThemeData;

  /// 名称
  late String name;
  /// 颜色
  late TDMap<String, Color> colorMap;
  /// 字体尺寸
  late TDMap<String, Font> fontMap;
  /// 圆角
  late TDMap<String, double> radiusMap;
  /// 字体样式
  late TDMap<String, FontFamily> fontFamilyMap;
  /// 阴影
  late TDMap<String, List<BoxShadow>> shadowMap;
  /// 间隔
  late TDMap<String, double> spacerMap;
  /// 映射关系
  late TDMap<String, String> refMap;
  /// 额外定义的结构
  late TDExtraThemeData? extraThemeData;

  TDThemeData(
      {required this.name,
      required this.colorMap,
      required this.fontMap,
      required this.radiusMap,
      required this.fontFamilyMap,
      required this.shadowMap,
      required this.spacerMap,
      required this.refMap,
      this.extraThemeData,});

  /// 获取默认Data，一个App里只有一个，用于没有context的地方
  static TDThemeData defaultData({TDExtraThemeData? extraThemeData}) {
    _defaultThemeData ??= fromJson(
            _defaultThemeName, TDDefaultTheme.defaultThemeConfig,
            extraThemeData: extraThemeData) ??
        _emptyData(_defaultThemeName, extraThemeData: extraThemeData);

    return _defaultThemeData!;
  }

  /// 从父类拷贝
  TDThemeData copyWithTDThemeData(
    String name, {
    Map<String, Color>? colorMap,
    Map<String, Font>? fontMap,
    Map<String, double>? radiusMap,
    Map<String, FontFamily>? fontFamilyMap,
    Map<String, List<BoxShadow>>? shadowMap,
    Map<String, double>? marginMap,
    TDExtraThemeData? extraThemeData,
  }) {

    return copyWith(name: name,colorMap: colorMap,fontMap: fontMap,radiusMap: radiusMap,fontFamilyMap: fontFamilyMap,shadowMap: shadowMap,marginMap: marginMap,extraThemeData: extraThemeData) as TDThemeData;
  }

  @override
  ThemeExtension<TDThemeData> copyWith({
    String? name,
    Map<String, Color>? colorMap,
    Map<String, Font>? fontMap,
    Map<String, double>? radiusMap,
    Map<String, FontFamily>? fontFamilyMap,
    Map<String, List<BoxShadow>>? shadowMap,
    Map<String, double>? marginMap,
    TDExtraThemeData? extraThemeData,
  }) {
    var result = TDThemeData(
        name: name ?? 'default',
        colorMap: _copyMap<Color>(this.colorMap, colorMap),
        fontMap: _copyMap<Font>(this.fontMap, fontMap),
        radiusMap: _copyMap<double>(this.radiusMap, radiusMap),
        fontFamilyMap: _copyMap<FontFamily>(this.fontFamilyMap, fontFamilyMap),
        shadowMap: _copyMap<List<BoxShadow>>(this.shadowMap, shadowMap),
        spacerMap: _copyMap<double>(spacerMap, marginMap),
        refMap: _copyMap<String>(refMap, refMap),
        extraThemeData: extraThemeData ?? this.extraThemeData);
    return result;
  }

  /// 拷贝Map,防止内层
  TDMap<String, T> _copyMap<T>(TDMap<String, T> src, Map<String, T>? add) {
    var map = TDMap<String, T>(factory: ()=>src);

    src.forEach((key, value) {
      map[key] = value;
    });
    if (add != null) {
      map.addAll(add);
    }
    return map;
  }

  /// 创建空对象
  static TDThemeData _emptyData(String name,
      {TDExtraThemeData? extraThemeData}) {
    var refMap = TDMap<String, String>();
    return TDThemeData(
        name: name,
        colorMap: TDMap(factory: () => _defaultThemeData?.colorMap, refs: refMap),
        fontMap: TDMap(factory: () => _defaultThemeData?.fontMap, refs:refMap),
        radiusMap: TDMap(factory: () => _defaultThemeData?.radiusMap, refs: refMap),
        fontFamilyMap: TDMap(factory: () => _defaultThemeData?.fontFamilyMap, refs:refMap),
        shadowMap: TDMap(factory: () => _defaultThemeData?.shadowMap, refs: refMap),
        spacerMap: TDMap(factory: () => _defaultThemeData?.spacerMap, refs: refMap),
        refMap: refMap);
  }

  /// 解析配置的json文件为主题数据
  static TDThemeData? fromJson(String name, String themeJson,
      {var recoverDefault = false, TDExtraThemeData? extraThemeData}) {
    if (themeJson.isEmpty) {
      Log.e('TTheme', 'parse themeJson is empty');
      return null;
    }
    try {
      /// 要求json配置必须正确
      final themeConfig = json.decode(themeJson);
      if (themeConfig.containsKey(name)) {
        var theme = _emptyData(name);
        Map<String, dynamic> curThemeMap = themeConfig['$name'];

        /// 设置颜色
        Map<String, dynamic>? colorsMap = curThemeMap['color'];
        colorsMap?.forEach((key, value) {
          var color = toColor(value);
          if (color != null) {
            theme.colorMap[key] = color;
          }
        });

        /// 设置颜色
        Map<String, dynamic>? refMap = curThemeMap['ref'];
        refMap?.forEach((key, value) {
          theme.refMap[key] = value;
        });

        /// 设置字体尺寸
        Map<String, dynamic>? fontsMap = curThemeMap['font'];
        fontsMap?.forEach((key, value) {
          theme.fontMap[key] =
              Font.fromJson(value);
        });

        /// 设置圆角
        Map<String, dynamic>? cornersMap = curThemeMap['radius'];
        cornersMap?.forEach((key, value) {
          theme.radiusMap[key] = value.toDouble();
        });

        /// 设置字体
        Map<String, dynamic>? fontFamilyMap = curThemeMap['fontFamily'];
        fontFamilyMap?.forEach((key, value) {
          theme.fontFamilyMap[key] = FontFamily.fromJson(value);
        });

        /// 设置阴影
        Map<String, dynamic>? shadowMap = curThemeMap['shadow'];
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
        Map<String, dynamic>? marginsMap = curThemeMap['margin'];
        marginsMap?.forEach((key, value) {
          theme.spacerMap[key] = value.toDouble();
        });

        if (extraThemeData != null) {
          extraThemeData.parse(name, curThemeMap);
          theme.extraThemeData = extraThemeData;
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

  Color? ofColor(
    String? key,
  ) {
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

  FontFamily? ofFontFamily(
    String? key,
  ) {
    return fontFamilyMap[key];
  }

  List<BoxShadow>? ofShadow(
    String? key,
  ) {
    return shadowMap[key];
  }

  T? ofExtra<T extends TDExtraThemeData>() {
    try {
      return extraThemeData as T;
    } catch (e) {
      Log.e('TDThemeData ofExtra error: $e');
    }
    return null;
  }

  @override
  ThemeExtension<TDThemeData> lerp(ThemeExtension<TDThemeData>? other, double t) {
    if (other is! TDThemeData) {
      return this;
    }
    return TDThemeData(
        name: other.name,
        colorMap: other.colorMap,
        fontMap: other.fontMap,
        radiusMap: other.radiusMap,
        fontFamilyMap: other.fontFamilyMap,
        shadowMap: other.shadowMap,
        spacerMap: other.spacerMap,
        refMap: other.refMap);
  }
}

/// 扩展主题数据
abstract class TDExtraThemeData {
  /// 解析json
  void parse(String name, Map<String, dynamic> curThemeMap);
}

typedef DefaultMapFactory = TDMap? Function();

/// 自定义Map
class TDMap<K,V> extends SplayTreeMap<K, V>{

  TDMap({this.factory, this.refs});
DefaultMapFactory? factory;
TDMap? refs;

  @override
  V? operator [](Object? key) {
    // return super[key];
     key = refs?[key] ?? key;
    var value = super[key];
    if(value != null){
      return value;
    }
    var defaultValue = factory?.call()?.get(key);
    if(defaultValue is V){
      return defaultValue;
    }
    return null;
  }

  V? get(Object? key){
    return super[key];
  }
}