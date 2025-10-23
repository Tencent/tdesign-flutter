import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../tdesign_flutter.dart';

/// 线上字体加载工具
class TDFontLoader {
  /// 缓存字体 FontLoader，防止重复加载
  static final _record = <String, bool>{};

  /// 加载字体资源
  static Future<bool> load({
    required String name,
    required String fontFamilyUrl,
  }) async {
    try {
      if (!(_record[name] ?? false)) {
        var fontLoader = FontLoader(name);

        fontLoader.addFont(Future(() async {
          var uri = Uri.parse(fontFamilyUrl);
          var bundle = NetworkAssetBundle(uri);
          return await bundle.load('');
        }));

        await fontLoader.load();
        _record[name] = true;
      }
      return true;
    } catch (e) {
      print(
          'TDFontLoader load error, name: ${name}, fontFamilyUrl: $fontFamilyUrl}, e: $e');
    }
    return false;
  }
}

/// 懒加载 FontWidget
class TDFontLoaderWidget extends StatefulWidget {
  const TDFontLoaderWidget({
    Key? key,
    required this.textWidget,
    required this.fontFamilyUrl,
  }) : super(key: key);

  final TDText textWidget;

  /// FontFamily 的下载地址
  final String fontFamilyUrl;

  @override
  State<TDFontLoaderWidget> createState() => _TDFontLoaderWidgetState();
}

class _TDFontLoaderWidgetState extends State<TDFontLoaderWidget> {
  bool fontFamilyLoaded = false;

  @override
  void initState() {
    super.initState();
    loadFont();
  }

  void loadFont() async {
    if ((widget.textWidget.fontFamily?.fontFamily.isNotEmpty ?? false) &&
        widget.fontFamilyUrl.isNotEmpty) {
      try {
        if (await TDFontLoader.load(
            name: widget.textWidget.fontFamily!.fontFamily,
            fontFamilyUrl: widget.fontFamilyUrl)) {
          setState(() {});
        }
      } catch (e) {
        print(
            'TDFontLoader loadFont error, data: ${widget.textWidget.data}, fontFamily: ${widget.textWidget.fontFamilyUrl}, e: $e');
      }
    }

    fontFamilyLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    final textWidget = widget.textWidget;

    return TDText(
      textWidget.data,
      font: textWidget.font,
      fontWeight: textWidget.fontWeight ?? FontWeight.w400,
      fontFamily: textWidget.fontFamily,
      textColor: textWidget.textColor,
      backgroundColor: textWidget.backgroundColor,
      isTextThrough: textWidget.isTextThrough,
      lineThroughColor: textWidget.lineThroughColor,
      package: textWidget.package,
      forceVerticalCenter: textWidget.forceVerticalCenter,
      style: textWidget.style,
      strutStyle: textWidget.strutStyle,
      textAlign: textWidget.textAlign,
      textDirection: textWidget.textDirection,
      locale: textWidget.locale,
      softWrap: textWidget.softWrap,
      overflow: textWidget.overflow,
      textScaleFactor: textWidget.textScaleFactor,
      maxLines: textWidget.maxLines,
      semanticsLabel: textWidget.semanticsLabel,
      textWidthBasis: textWidget.textWidthBasis,
      textHeightBehavior: textWidget.textHeightBehavior,
      isInFontLoader: true,
    );
  }
}
