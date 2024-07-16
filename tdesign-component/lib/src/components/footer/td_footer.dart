import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

enum TDFooterType {
  /// 文字样式
  text,

  /// 链接样式
  link,

  /// 品牌样式
  brand,

}

class TDFooter extends StatefulWidget {
  const TDFooter( this.type,
    {Key? key,
    this.logo,
    this.text = '',
    this.links = const [],
    this.width,
    this.height,
  }) : super(key: key);

  /// 品牌图片
  final String? logo;

  /// 样式
  final TDFooterType type;

  /// 文字
  final String text;

  /// 自定义图片宽
  final double? width;

  /// 自定义图片高
  final double? height;

  /// 链接
  final List<LinkObj> links;

  @override
  State<TDFooter> createState() => _TDFooterState();
}

class _TDFooterState extends State<TDFooter> {
  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case TDFooterType.text:
        return Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _renderText(),
            ],
          ),
        );
    case TDFooterType.link:
      return Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.links.isNotEmpty)
              _renderLinks()
            else
              _renderText(),
          ],
        ),
      );
    case TDFooterType.brand:
      return Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.logo != null)
              _renderLogo()
            else
              _renderText(),
          ],
        ),
      );
    }
  }

  Widget _renderLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TDImage(
                  assetUrl: widget.logo,
                  type: TDImageType.clip,
                  width: widget.width,
                  height: widget.height,
                ),
              ]
          ),
        )
      ]
    );
  }

  Widget _renderLinks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.links.map((link) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: TDLink(
                    type: TDLinkType.basic,
                    style: TDLinkStyle.primary,
                    label: link.name,
                    uri: link.uri)
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _renderText()
            ]
          ),
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
        color: TDTheme.of(context).fontGyColor3,
      ),
    );
  }
}

class LinkObj {
  LinkObj({
    required this.name,
    this.uri,
  });

  final String name;
  final Uri? uri;
}
