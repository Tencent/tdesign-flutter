
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../tdesign_flutter.dart';

/// 懒加载Font
class TDFontLoader extends StatefulWidget {
  const TDFontLoader({Key? key, required this.textWidget, required this.fontFamilyUrl}) : super(key: key);

  final TDText textWidget;

  /// FontFamily的下载地址
  final String fontFamilyUrl;

  @override
  State<TDFontLoader> createState() => _TDFontLoaderState();
}

class _TDFontLoaderState extends State<TDFontLoader> {
  bool fontFamilyLoaded = false;
  @override
  void initState() {
    super.initState();
    loadFont();
  }

  void loadFont() async {
    if ((widget.textWidget.fontFamily?.fontFamily.isNotEmpty ?? false)
        && widget.fontFamilyUrl.isNotEmpty) {
      try {
        Future<ByteData> readFont() async {
          var uri = Uri.parse(widget.fontFamilyUrl);
          var bundle = NetworkAssetBundle(uri);
          return await bundle.load('');
        }
        var fontLoader =  FontLoader(widget.textWidget.fontFamily!.fontFamily);
        fontLoader.addFont(readFont());
        await fontLoader.load();
        setState(() {});
      } catch (e) {
        print('TDFontLoader loadFont error, data: ${widget.textWidget.data}, fontFamily: ${widget.textWidget.fontFamilyUrl}, e: $e');
      }
    }

    fontFamilyLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    return TDText(widget.textWidget.data,
      font:widget.textWidget.font,
      fontWeight:widget.textWidget.fontWeight ?? FontWeight.w400,
      fontFamily:widget.textWidget.fontFamily,
      textColor:widget.textWidget.textColor,
      backgroundColor:widget.textWidget.backgroundColor,
      isTextThrough:widget.textWidget.isTextThrough ,
      lineThroughColor:widget.textWidget.lineThroughColor,
      package : widget.textWidget.package,
      forceVerticalCenter :widget.textWidget.forceVerticalCenter,
      style:widget.textWidget.style,
      strutStyle:widget.textWidget.strutStyle,
      textAlign:widget.textWidget.textAlign,
      textDirection:widget.textWidget.textDirection,
      locale:widget.textWidget.locale,
      softWrap:widget.textWidget.softWrap,
      overflow:widget.textWidget.overflow,
      textScaleFactor:widget.textWidget.textScaleFactor,
      maxLines:widget.textWidget.maxLines,
      semanticsLabel:widget.textWidget.semanticsLabel,
      textWidthBasis:widget.textWidget.textWidthBasis,
      textHeightBehavior:widget.textWidget.textHeightBehavior,
      isInFontLoader: true,
    );
  }
}
