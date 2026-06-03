import 'package:flutter/material.dart';
import 'package:tdesign_icons/tdesign_icons.dart';

import '../../../tdesign_flutter.dart';

enum TAvatarSize { large, medium, small }

enum TAvatarType { icon, normal, customText, display, operation }

enum TAvatarShape { circle, square }

/// 用于头像显示
class TAvatar extends StatelessWidget {
  const TAvatar({
    Key? key,
    this.size = TAvatarSize.medium,
    this.type = TAvatarType.normal,
    this.shape = TAvatarShape.circle,
    this.text,
    this.radius,
    this.icon,
    this.avatarUrl,
    this.avatarSize,
    this.avatarDisplayList,
    this.displayText,
    this.onTap,
    this.defaultUrl = '',
    this.avatarDisplayWidget,
    this.avatarDisplayBorder = 2,
    this.avatarDisplayListAsset,
    this.backgroundColor,
    this.fit,
  }) : super(key: key);

  /// 头像地址
  final String? avatarUrl;

  /// 头像尺寸
  final TAvatarSize size;

  /// 头像类型
  final TAvatarType type;

  /// 头像形状
  final TAvatarShape shape;

  /// 自定义文字
  final String? text;

  /// 自定义圆角
  final double? radius;

  /// 自定义头像大小
  final double? avatarSize;

  /// 自定义图标
  final IconData? icon;

  /// 默认图片（本地）
  final String defaultUrl;

  /// 带操作展示的头像列表
  final List<String>? avatarDisplayList;

  /// 带操作展示的头像列表（本地资源）
  final List<String>? avatarDisplayListAsset;

  /// 带操作展示的头像描边宽度
  final double avatarDisplayBorder;

  /// 带操作头像自定义操作Widget
  final Widget? avatarDisplayWidget;

  /// 纯展示类型末尾文字
  final String? displayText;

  /// 操作点击事件
  final Function()? onTap;

  /// 自定义文案时背景色
  final Color? backgroundColor;

  /// 自定义图片对齐方式
  final BoxFit? fit;

  double _getAvatarWidth() {
    double width;
    switch (size) {
      case TAvatarSize.large:
        width = 64;
        break;
      case TAvatarSize.medium:
        width = 48;
        break;
      case TAvatarSize.small:
        width = 40;
        break;
    }
    return avatarSize ?? width;
  }

  Font? _getTextFont(BuildContext context) {
    Font? font;
    switch (size) {
      case TAvatarSize.large:
        font = TTheme.of(context).fontTitleExtraLarge;
        break;
      case TAvatarSize.medium:
        font = TTheme.of(context).fontTitleMedium;
        break;
      case TAvatarSize.small:
        font = TTheme.of(context).fontTitleSmall;
        break;
    }
    return font;
  }

  double _getIconWidth() {
    double width;
    switch (size) {
      case TAvatarSize.large:
        width = 32;
        break;
      case TAvatarSize.medium:
        width = 24;
        break;
      case TAvatarSize.small:
        width = 20;
        break;
    }
    return width;
  }

  double _getAvatarRadius(BuildContext context) {
    double _radius;
    switch (shape) {
      case TAvatarShape.circle:
        _radius = _getAvatarWidth() / 2;
        break;
      case TAvatarShape.square:
        _radius = TTheme.of(context).radiusDefault;
        break;
    }
    return radius ?? _radius;
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TAvatarType.icon:
        return GestureDetector(
          child: Container(
            width: _getAvatarWidth(),
            height: _getAvatarWidth(),
            decoration: BoxDecoration(
              color: backgroundColor ?? TTheme.of(context).brandFocusColor,
              borderRadius: BorderRadius.circular(_getAvatarRadius(context)),
            ),
            child: Center(
                child: Icon(
              icon ?? TIcons.user,
              size: _getIconWidth(),
              color: TTheme.of(context).brandNormalColor,
            )),
          ),
          onTap: onTap,
        );
      case TAvatarType.normal:
        return GestureDetector(
          child: Container(
            width: _getAvatarWidth(),
            height: _getAvatarWidth(),
            decoration: BoxDecoration(
                color: backgroundColor ?? TTheme.of(context).brandFocusColor,
                borderRadius: BorderRadius.circular(_getAvatarRadius(context)),
                image: avatarUrl != null
                    ? DecorationImage(image: NetworkImage(avatarUrl!))
                    : defaultUrl != ''
                        ? DecorationImage(image: AssetImage(defaultUrl))
                        : null),
          ),
          onTap: onTap,
        );
      case TAvatarType.customText:
        return GestureDetector(
          child: Container(
            width: _getAvatarWidth(),
            height: _getAvatarWidth(),
            decoration: BoxDecoration(
              color: backgroundColor ?? TTheme.of(context).brandNormalColor,
              borderRadius: BorderRadius.circular(_getAvatarRadius(context)),
            ),
            child: Center(
              child: TText(
                text,
                forceVerticalCenter: true,
                textAlign: TextAlign.center,
                font: _getTextFont(context),
                textColor: TTheme.of(context).whiteColor1,
              ),
            ),
          ),
          onTap: onTap,
        );
      case TAvatarType.display:
        return buildDisplayAvatar(context);
      case TAvatarType.operation:
        return buildOperationAvatar(context);
    }
  }

  double _getDisplayPadding() {
    double padding;
    switch (size) {
      case TAvatarSize.large:
        padding = 10;
        break;
      case TAvatarSize.medium:
        padding = 8;
        break;
      case TAvatarSize.small:
        padding = 6;
        break;
    }
    return padding;
  }

  Widget buildOperationAvatar(BuildContext context) {
    var list = <Widget>[];
    if ((avatarDisplayList == null || avatarDisplayList!.isEmpty) &&
        (avatarDisplayListAsset == null || avatarDisplayListAsset!.isEmpty)) {
      return Container();
    }

    var length = 0;

    if (avatarDisplayList != null) {
      length = avatarDisplayList!.length;
      for (var i = 0; i < avatarDisplayList!.length + 1; i++) {
        var left = (_getAvatarWidth() - _getDisplayPadding()) * i;
        if (i == avatarDisplayList!.length) {
          list.add(Positioned(
              left: left,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                    child: Center(
                      child: Icon(TIcons.user_add,
                          size: _getIconWidth(),
                          color: TTheme.of(context).brandNormalColor),
                    ),
                    width: _getAvatarWidth(),
                    height: _getAvatarWidth(),
                    clipBehavior: Clip.hardEdge,
                    decoration: ShapeDecoration(
                      color: TTheme.of(context).brandFocusColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              _getAvatarWidth() - _getDisplayPadding()),
                          side: BorderSide(
                              color: Colors.transparent,
                              width: avatarDisplayBorder)),
                    )),
              )));
        } else {
          list.add(Positioned(
              left: left,
              child: Container(
                  width: _getAvatarWidth(),
                  height: _getAvatarWidth(),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              _getAvatarWidth() - _getDisplayPadding()),
                          side: BorderSide(
                              color: TTheme.of(context).bgColorContainer,
                              width: avatarDisplayBorder)),
                      image: DecorationImage(
                          image: NetworkImage(avatarDisplayList![i]),
                          fit: fit ?? BoxFit.cover)))));
        }
      }
    } else if (avatarDisplayListAsset != null) {
      length = avatarDisplayListAsset!.length;
      for (var i = 0; i < avatarDisplayListAsset!.length + 1; i++) {
        var left = (_getAvatarWidth() - _getDisplayPadding()) * i;
        if (i == avatarDisplayListAsset!.length) {
          list.add(Positioned(
              left: left,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                    child: Center(
                      child: avatarDisplayWidget ??
                          Icon(TIcons.user_add,
                              size: _getIconWidth(),
                              color: TTheme.of(context).brandNormalColor),
                    ),
                    width: _getAvatarWidth(),
                    height: _getAvatarWidth(),
                    clipBehavior: Clip.hardEdge,
                    decoration: ShapeDecoration(
                      color: TTheme.of(context).brandFocusColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              _getAvatarWidth() - _getDisplayPadding()),
                          side: BorderSide(
                              color: TTheme.of(context).bgColorContainer,
                              width: avatarDisplayBorder)),
                    )),
              )));
        } else {
          list.add(Positioned(
              left: left,
              child: Container(
                  width: _getAvatarWidth(),
                  height: _getAvatarWidth(),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              _getAvatarWidth() - _getDisplayPadding()),
                          side: BorderSide(
                              color: TTheme.of(context).bgColorContainer,
                              width: avatarDisplayBorder)),
                      image: DecorationImage(
                          image: AssetImage(avatarDisplayListAsset![i]),
                          fit: fit ?? BoxFit.fill)))));
        }
      }
    }

    return SizedBox(
      height: _getAvatarWidth(),
      width: _getAvatarWidth() * (length + 1) - length * _getDisplayPadding(),
      child: Stack(children: list),
    );
  }

  Widget buildDisplayAvatar(BuildContext context) {
    var list = <Widget>[];
    if ((avatarDisplayList == null || avatarDisplayList!.isEmpty) &&
        (avatarDisplayListAsset == null || avatarDisplayListAsset!.isEmpty)) {
      return Container();
    }

    var length = 0;

    if (avatarDisplayList != null) {
      length = avatarDisplayList!.length;
      for (var i = avatarDisplayList!.length; i >= 0; i--) {
        var left = (_getAvatarWidth() - _getDisplayPadding()) * i;
        if (i == avatarDisplayList!.length) {
          list.add(Positioned(
              left: left,
              child: Container(
                  child: Center(
                    child: TText(
                      displayText,
                      fontWeight: FontWeight.w600,
                      forceVerticalCenter: true,
                      textAlign: TextAlign.center,
                      font: _getTextFont(context),
                      textColor: TTheme.of(context).brandNormalColor,
                    ),
                  ),
                  width: _getAvatarWidth(),
                  height: _getAvatarWidth(),
                  clipBehavior: Clip.hardEdge,
                  decoration: ShapeDecoration(
                    color: TTheme.of(context).brandFocusColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            _getAvatarWidth() - _getDisplayPadding()),
                        side: BorderSide(
                            color: TTheme.of(context).bgColorContainer,
                            width: avatarDisplayBorder)),
                  ))));
        } else {
          list.add(Positioned(
              left: left,
              child: Container(
                  width: _getAvatarWidth(),
                  height: _getAvatarWidth(),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              _getAvatarWidth() - _getDisplayPadding()),
                          side: BorderSide(
                              color: TTheme.of(context).bgColorContainer,
                              width: avatarDisplayBorder)),
                      image: DecorationImage(
                          image: NetworkImage(avatarDisplayList![i]),
                          fit: fit ?? BoxFit.cover)))));
        }
      }
    } else if (avatarDisplayListAsset != null) {
      length = avatarDisplayListAsset!.length;
      for (var i = avatarDisplayListAsset!.length; i >= 0; i--) {
        var left = (_getAvatarWidth() - _getDisplayPadding()) * i;
        if (i == avatarDisplayListAsset!.length) {
          list.add(Positioned(
              left: left,
              child: Container(
                  child: Center(
                    child: TText(
                      displayText,
                      fontWeight: FontWeight.w600,
                      forceVerticalCenter: true,
                      textAlign: TextAlign.center,
                      font: _getTextFont(context),
                      textColor: TTheme.of(context).brandNormalColor,
                    ),
                  ),
                  width: _getAvatarWidth(),
                  height: _getAvatarWidth(),
                  clipBehavior: Clip.hardEdge,
                  decoration: ShapeDecoration(
                    color: TTheme.of(context).brandFocusColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            _getAvatarWidth() - _getDisplayPadding()),
                        side: BorderSide(
                            color: TTheme.of(context).bgColorContainer,
                            width: avatarDisplayBorder)),
                  ))));
        } else {
          list.add(Positioned(
              left: left,
              child: Container(
                  width: _getAvatarWidth(),
                  height: _getAvatarWidth(),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              _getAvatarWidth() - _getDisplayPadding()),
                          side: BorderSide(
                              color: TTheme.of(context).bgColorContainer,
                              width: avatarDisplayBorder)),
                      image: DecorationImage(
                          image: AssetImage(avatarDisplayListAsset![i]),
                          fit: fit ?? BoxFit.cover)))));
        }
      }
    }

    return SizedBox(
      height: _getAvatarWidth(),
      width: _getAvatarWidth() * (length + 1) - length * _getDisplayPadding(),
      child: Stack(children: list),
    );
  }
}
