import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

enum TFooterType {
  /// 文字样式
  text,

  /// 链接样式
  link,

  /// 品牌样式
  brand,
}

class TFooter extends StatefulWidget {
  const TFooter(
    this.type, {
    Key? key,
    this.logo,
    this.text = '',
    this.links = const [],
    this.width,
    this.height,
  }) : super(key: key);

  /// 品牌图片
  final String? logo;

  /// 样式
  final TFooterType type;

  /// 文字
  final String text;

  /// 自定义图片宽
  final double? width;

  /// 自定义图片高
  final double? height;

  /// 链接
  final List<TLink> links;

  @override
  State<TFooter> createState() => _TFooterState();
}

class _TFooterState extends State<TFooter> {
  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];

    switch (widget.type) {
      case TFooterType.text:
        children = [_renderText()];
        break;
      case TFooterType.link:
        children = [
          if (widget.links.isNotEmpty) _renderLinks() else _renderText()
        ];
        break;
      case TFooterType.brand:
        children = [if (widget.logo != null) _renderLogo() else _renderText()];
        break;
    }

    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }

  Widget _renderLogo() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: TImage(
          assetUrl: widget.logo,
          type: TImageType.fitWidth,
          width: widget.width,
          height: widget.height,
        ),
      )
    ]);
  }

  Widget _renderLinks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: List.generate(widget.links.length, (index) {
              var link = widget.links[index];
              return Container(
                decoration: index < (widget.links.length - 1)
                    ? BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                color:
                                    TTheme.of(context).textColorPlaceholder)))
                    : null,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: link,
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Flexible(child: _renderText())]),
        ),
      ],
    );
  }

  Widget _renderText() {
    return Text(
      widget.text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12,
        color: TTheme.of(context).textColorPlaceholder,
      ),
    );
  }
}
