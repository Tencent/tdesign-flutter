import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';
import 'package:tdesign_flutter/src/util/string_util.dart';
import 'package:tdesign_flutter/src/components/image/image_widget.dart';

enum TDImageSize {
  /// 120*120px
  XL,

  /// 72*72
  L,

  /// 56*56
  M,

  /// 48*48
  SM,

  /// 32*32
  S,

  /// 24*24
  XS
}

enum TDImageType {
  /// 裁剪
  clip,

  /// 适应高
  fitHeight,

  /// 拉伸
  stretch,

  /// 方形,
  square,

  /// 圆角方形
  roundedSquare,

  /// 圆形
  circle,
}

enum TDImageStatus {
  /// 加载中
  loading,

  /// 加载失败
  failed,
}

class TDImage extends StatefulWidget {
  /// 图片地址
  final String imgUrl;

  /// 图片类型
  final TDImageType type;

  /// 图片大小
  final TDImageSize size;

  /// 加载自定义提示
  final String? loadingText;

  /// 失败自定义提示
  final String? errorText;

  /// 自定义宽
  final double? width;

  /// 自定义高
  final double? height;

  @override
  const TDImage(
      {Key? key,
      required this.imgUrl,
      this.size = TDImageSize.L,
      this.type = TDImageType.roundedSquare,
      this.errorText,
      this.loadingText,
      this.width,
      this.height})
      : super(key: key);

  State<StatefulWidget> createState() => _TDImageState();
}

class _TDImageState extends State<TDImage> {
  double _getImageWidth() {
    double width;
    switch (widget.size) {
      case TDImageSize.XL:
        width = 120;
        break;
      case TDImageSize.L:
        width = 72;
        break;
      case TDImageSize.M:
        width = 56;
        break;
      case TDImageSize.SM:
        width = 48;
        break;
      case TDImageSize.S:
        width = 32;
        break;
      case TDImageSize.XS:
        width = 24;
        break;
      default:
        width = 72;
        break;
    }
    return widget.width ?? width;
  }

  double _getImageHeight() {
    double height;
    height = _getImageWidth();
    return widget.height ?? height;
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case TDImageType.clip:
        return SizedBox(
          width: _getImageWidth(),
          height: _getImageHeight(),
          child: ImageWidget(
            url: widget.imgUrl,
            h: _getImageHeight(),
            w: _getImageWidth(),
            failedText: widget.errorText,
            loadingText: widget.loadingText,
            fit: BoxFit.cover,
          ),
        );
      case TDImageType.fitHeight:
        return SizedBox(
          width: _getImageWidth(),
          height: _getImageHeight(),
          child: ImageWidget(
            url: widget.imgUrl,
            h: _getImageHeight(),
            w: _getImageWidth(),
            failedText: widget.errorText,
            loadingText: widget.loadingText,
            fit: BoxFit.fitHeight,
          ),
        );
      case TDImageType.stretch:
        return SizedBox(
          width: _getImageWidth(),
          height: _getImageHeight(),
          child: ImageWidget(
            url: widget.imgUrl,
            h: _getImageHeight(),
            w: _getImageWidth(),
            failedText: widget.errorText,
            loadingText: widget.loadingText,
            fit: BoxFit.fill,
          ),
        );
      case TDImageType.square:
        return SizedBox(
          width: _getImageWidth(),
          height: _getImageHeight(),
          child: ImageWidget(
            url: widget.imgUrl,
            h: _getImageHeight(),
            w: _getImageWidth(),
            failedText: widget.errorText,
            loadingText: widget.loadingText,
            fit: BoxFit.cover,
          ),
        );
      case TDImageType.roundedSquare:
        return Container(
            width: _getImageWidth(),
            height: _getImageHeight(),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
            child: ImageWidget(
              url: widget.imgUrl,
              h: _getImageHeight(),
              w: _getImageWidth(),
              failedText: widget.errorText,
              loadingText: widget.loadingText,
              fit: BoxFit.cover,
            ));
      case TDImageType.circle:
        return Container(
            width: _getImageWidth(),
            height: _getImageHeight(),
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: ImageWidget(
              url: widget.imgUrl,
              h: _getImageHeight(),
              w: _getImageWidth(),
              failedText: widget.errorText,
              loadingText: widget.loadingText,
              fit: BoxFit.cover,
            ));
    }
  }
}
