import 'package:flutter/material.dart';
import 'package:tdesign_flutter/src/components/text/td_text.dart';
import 'package:tdesign_flutter/td_export.dart';

///封装图片加载控件，增加图片加载失败时加载默认图片
class ImageWidget extends StatefulWidget {
  final String url;
  final double w;
  final double h;
  final String? failedText;
  final String? loadingText;
  final BoxFit fit;

  const ImageWidget(
      {required this.url,
      required this.w,
      required this.h,
      this.failedText = '加载失败',
      this.fit = BoxFit.none,
      this.loadingText = '加载中',
      Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StateImageWidget();
  }
}

class _StateImageWidget extends State<ImageWidget> {
  late Image _image;
  bool error = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _image = Image.network(
      widget.url,
      width: widget.w,
      height: widget.h,
      fit: widget.fit,
    );
    var resolve = _image.image.resolve(ImageConfiguration.empty);
    resolve.addListener(ImageStreamListener((_, __) {
      /// 加载成功
      setState(() {
        loading = false;
        error = false;
      });
    }, onChunk: (ImageChunkEvent event) {
      /// 加载中
      if (loading == false) {
        setState(() {
          loading = true;
          error = false;
        });
      }
    }, onError: (dynamic exception, StackTrace? stackTrace) {
      /// 加载失败
      if (error == false) {
        setState(() {
          error = true;
          loading = false;
        });
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    if (error == false && loading == true)
      return Container(
        alignment: Alignment.center,
        color: TDTheme.of(context).grayColor2,
        child: TDText(
          widget.loadingText,
          showHeight: false,
          font: Font(size: 10, lineHeight: 16),
          textColor: TDTheme.of(context).fontGyColor3,
        ),
      );
    if (error == true && loading == false)
      return Container(
        alignment: Alignment.center,
        color: TDTheme.of(context).grayColor2,
        child: TDText(
          widget.failedText,
          showHeight: false,
          font: Font(size: 10, lineHeight: 16),
          textColor: TDTheme.of(context).fontGyColor3,
        ),
      );
    if (loading == false && error == false) return _image;
    return Container();
  }
}
