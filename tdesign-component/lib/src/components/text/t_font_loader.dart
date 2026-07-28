import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 't_text.dart';

/// 线上字体加载工具
class TFontLoader {
  /// 缓存字体 FontLoader，防止重复加载
  static final _record = <String, bool>{}; // coverage:ignore-line

  /// 加载字体资源
  static Future<bool> load({
    // coverage:ignore-line
    required String name,
    required String fontFamilyUrl,
  }) async {
    try {
      if (!(_record[name] ?? false)) {
        // coverage:ignore-line
        var fontLoader = FontLoader(name); // coverage:ignore-line

        fontLoader.addFont(Future(() async {
          // coverage:ignore-line
          var uri = Uri.parse(fontFamilyUrl); // coverage:ignore-line
          var bundle = NetworkAssetBundle(uri); // coverage:ignore-line
          return await bundle.load(''); // coverage:ignore-line
        }));

        await fontLoader.load(); // coverage:ignore-line
        _record[name] = true; // coverage:ignore-line
      }
      return true;
    } catch (_) {
      // 字体加载失败时返回 false，由调用方决定是否降级展示。
    }
    return false;
  }
}

/// 懒加载 FontWidget
class TFontLoaderWidget extends StatefulWidget {
  const TFontLoaderWidget({
    // coverage:ignore-line
    Key? key,
    required this.textWidget,
    required this.fontFamilyUrl,
  }) : super(key: key); // coverage:ignore-line

  /// 需要加载字体的文本组件
  final TText textWidget;

  /// FontFamily 的下载地址
  final String fontFamilyUrl;

  @override // coverage:ignore-line
  State<TFontLoaderWidget> createState() =>
      _TFontLoaderWidgetState(); // coverage:ignore-line
}

class _TFontLoaderWidgetState extends State<TFontLoaderWidget> {
  var _fontFamilyLoaded = false;

  @override // coverage:ignore-line

  void initState() {
    super.initState(); // coverage:ignore-line
    loadFont(); // coverage:ignore-line
  }

  void loadFont() async {
    // coverage:ignore-line
    if ((widget.textWidget.fontFamily?.fontFamily.isNotEmpty ??
            false) && // coverage:ignore-line
        widget.fontFamilyUrl.isNotEmpty) {
      // coverage:ignore-line
      try {
        if (await TFontLoader.load(
            // coverage:ignore-line
            name: widget
                .textWidget.fontFamily!.fontFamily, // coverage:ignore-line
            fontFamilyUrl: widget.fontFamilyUrl)) {
          // coverage:ignore-start
          _fontFamilyLoaded = true;
          if (!mounted) {
            return;
          }
          setState(() {});
          // coverage:ignore-end
        }
      } catch (_) {
        // 字体加载失败时保持原文本渲染。
      }
    }
  }

  @override // coverage:ignore-line
  Widget build(BuildContext context) {
    final textWidget = widget.textWidget; // coverage:ignore-line

    return TText(
      // coverage:ignore-line
      textWidget.data, // coverage:ignore-line
      font: textWidget.font, // coverage:ignore-line
      fontWeight:
          textWidget.fontWeight ?? FontWeight.w400, // coverage:ignore-line
      fontFamily: textWidget.fontFamily, // coverage:ignore-line
      textColor: textWidget.textColor, // coverage:ignore-line
      backgroundColor: textWidget.backgroundColor, // coverage:ignore-line
      isTextThrough: textWidget.isTextThrough, // coverage:ignore-line
      lineThroughColor: textWidget.lineThroughColor, // coverage:ignore-line
      package: textWidget.package, // coverage:ignore-line
      style: textWidget.style, // coverage:ignore-line
      strutStyle: textWidget.strutStyle, // coverage:ignore-line
      textAlign: textWidget.textAlign, // coverage:ignore-line
      textDirection: textWidget.textDirection, // coverage:ignore-line
      locale: textWidget.locale, // coverage:ignore-line
      softWrap: textWidget.softWrap, // coverage:ignore-line
      overflow: textWidget.overflow, // coverage:ignore-line
      textScaleFactor: textWidget.textScaleFactor, // coverage:ignore-line
      maxLines: textWidget.maxLines, // coverage:ignore-line
      semanticsLabel: textWidget.semanticsLabel, // coverage:ignore-line
      textWidthBasis: textWidget.textWidthBasis, // coverage:ignore-line
      textHeightBehavior: textWidget.textHeightBehavior, // coverage:ignore-line
      isInFontLoader: !_fontFamilyLoaded,
    );
  }
}
