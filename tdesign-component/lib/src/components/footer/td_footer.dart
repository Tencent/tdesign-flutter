import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';


class TDFooter extends StatefulWidget {
  const TDFooter({
    Key? key,
    this.logo,
    this.text = 'Copyright © 2019-2023 TDesign.All Rights Reserved.',
    this.links = const [],
    this.width,
    this.height,
  }) : super(key: key);

  /// 品牌图片
  final String? logo;

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
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.logo != null)
            _renderLogo()
          else if (widget.links.isNotEmpty)
            _renderLinks()
          else
            _renderText(),
        ],
      ),
    );
  }

  Widget _renderLogo() {
    return Container(
        color: TDTheme.of(context).whiteColor1,
        child: Row(
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
        ));
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
