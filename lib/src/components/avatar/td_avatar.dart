import 'package:flutter/material.dart';
import '../../../td_export.dart';

enum TDAvatarSize { large, medium, small }

enum TDAvatarType {
  normal,
  user,
  circle,
  square,
  customText,
  display,
  operation
}

/// 用于头像显示
class TDAvatar extends StatelessWidget {
  const TDAvatar(
      {Key? key,
        this.size = TDAvatarSize.medium,
        this.type = TDAvatarType.normal,
        this.text,
        this.avatarUrl,
        this.avatarSize,
        this.avatarDisplayList,
        this.displayText,
        this.onTap,
        this.defaultUrl = ''})
      : super(key: key);

  /// 头像地址
  final String? avatarUrl;

  /// 头像尺寸
  final TDAvatarSize size;

  /// 头像类型
  final TDAvatarType type;

  /// 自定义文字
  final String? text;

  /// 自定义头像大小
  final double? avatarSize;

  /// 默认图片
  final String defaultUrl;

  /// 带操作\展示的头像列表
  final List<String>? avatarDisplayList;

  /// 纯展示类型末尾文字
  final String? displayText;

  /// 操作点击事件
  final Function()? onTap;


  double _getAvatarWidth() {
    double width;
    switch (size) {
      case TDAvatarSize.large:
        width = 64;
        break;
      case TDAvatarSize.medium:
        width = 48;
        break;
      case TDAvatarSize.small:
        width = 32;
        break;
    }
    return avatarSize ?? width;
  }

  Font _getTextFont() {
    Font font;
    switch (size) {
      case TDAvatarSize.large:
        font = Font(size: 16, lineHeight: 24);
        break;
      case TDAvatarSize.medium:
        font = Font(size: 14, lineHeight: 22);
        break;
      case TDAvatarSize.small:
        font = Font(size: 12, lineHeight: 20);
        break;
    }
    return font;
  }

  double _getIconWidth() {
    double width;
    switch (size) {
      case TDAvatarSize.large:
        width = 32;
        break;
      case TDAvatarSize.medium:
        width = 24;
        break;
      case TDAvatarSize.small:
        width = 16;
        break;
    }
    return width;
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TDAvatarType.normal:
        return CircleAvatar(
          radius: _getAvatarWidth() / 2,
          backgroundColor: TDTheme.of(context).brandColor2,
          child: Icon(TDIcons.user,
              size: _getIconWidth(), color: TDTheme.of(context).brandColor8),
        );
      case TDAvatarType.user:
        return CircleAvatar(
            radius: _getAvatarWidth() / 2,
            backgroundColor: TDTheme.of(context).brandColor2,
            backgroundImage: avatarUrl != null
                ? NetworkImage(avatarUrl!)
                : NetworkImage(defaultUrl));
      case TDAvatarType.circle:
        return CircleAvatar(
            radius: _getAvatarWidth() / 2,
            backgroundColor: TDTheme.of(context).brandColor2,
            backgroundImage: avatarUrl != null
                ? NetworkImage(avatarUrl!)
                : NetworkImage(defaultUrl));
      case TDAvatarType.square:
        return Container(
          width: _getAvatarWidth(),
          height: _getAvatarWidth(),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              image: DecorationImage(
                  image: avatarUrl != null
                      ? NetworkImage(avatarUrl!)
                      : NetworkImage(defaultUrl))),
        );
      case TDAvatarType.customText:
        return CircleAvatar(
          radius: _getAvatarWidth() / 2,
          backgroundColor: TDTheme.of(context).brandColor8,
          child: TDText(
            text,
            forceVerticalCenter: true,
            textAlign: TextAlign.center,
            font: _getTextFont(),
            textColor: TDTheme.of(context).whiteColor1,
          ),
        );
      case TDAvatarType.display:
        return buildDisplayAvatar(context);
      case TDAvatarType.operation:
        return buildOperationAvatar(context);
    }
  }

  double _getDisplayPadding() {
    double padding;
    switch (size) {
      case TDAvatarSize.large:
        padding = 10;
        break;
      case TDAvatarSize.medium:
        padding = 8;
        break;
      case TDAvatarSize.small:
        padding = 6;
        break;
    }
    return padding;
  }

  Widget buildOperationAvatar(BuildContext context) {
    var list = <Widget>[];
    if(avatarDisplayList == null || avatarDisplayList!.isEmpty) {
      return Container();
    }

    for(var i = 0; i < avatarDisplayList!.length + 1; i ++) {
      var left = (_getAvatarWidth() - _getDisplayPadding()) * i;
      if(i == avatarDisplayList!.length) {
        list.add(
            Positioned(
                left: left,
                child:
                GestureDetector(
                  onTap: () {
                    if(onTap != null) {
                      onTap!();
                    }
                  },
                  child: Container(
                      child: Center(
                        child: Icon(TDIcons.user_add,
                            size: _getIconWidth(), color: TDTheme.of(context).brandColor8),
                      ),
                      width: _getAvatarWidth(),
                      height: _getAvatarWidth(),
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          color: TDTheme.of(context).brandColor2,
                          borderRadius: BorderRadius.circular(_getAvatarWidth() - _getDisplayPadding()),
                          border: Border.all(color: Colors.white, width: _getDisplayPadding() / 2)
                      )
                  ),
                )
            )
        );
      } else {
        list.add(
            Positioned(
                left: left,
                child: Container(
                    width: _getAvatarWidth(),
                    height: _getAvatarWidth(),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_getAvatarWidth() - _getDisplayPadding()),
                        side: BorderSide(color: Colors.white, width: _getDisplayPadding() / 2)
                      ),
                      image: DecorationImage(image: NetworkImage(avatarDisplayList![i]), fit: BoxFit.cover)
                    )
                )
            )
        );
      }
    }
    return SizedBox(
      height: _getAvatarWidth(),
      width: _getAvatarWidth() * ((avatarDisplayList?.length ?? 0) + 1)
          - (avatarDisplayList?.length ?? 0) * _getDisplayPadding(),
      child: Stack(
        children: list
      ),
    );
  }

  Widget buildDisplayAvatar(BuildContext context) {
    var list = <Widget>[];
    if(avatarDisplayList == null || avatarDisplayList!.isEmpty) {
      return Container();
    }

    for(var i = avatarDisplayList!.length; i >= 0; i --) {
      var left = (_getAvatarWidth() - _getDisplayPadding()) * i;
      if(i == avatarDisplayList!.length) {
        list.add(
            Positioned(
                left: left,
                child:
                Container(
                    child: Center(
                      child: TDText(
                        displayText,
                        forceVerticalCenter: true,
                        textAlign: TextAlign.center,
                        font: _getTextFont(),
                        textColor: TDTheme.of(context).brandColor8,
                      ),
                    ),
                    width: _getAvatarWidth(),
                    height: _getAvatarWidth(),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        color: TDTheme.of(context).brandColor2,
                        borderRadius: BorderRadius.circular(_getAvatarWidth() - _getDisplayPadding()),
                        border: Border.all(color: Colors.white, width: _getDisplayPadding() / 2)
                    )
                )
            )
        );
      } else {
        list.add(
            Positioned(
                left: left,
                child: Container(
                    width: _getAvatarWidth(),
                    height: _getAvatarWidth(),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(_getAvatarWidth() - _getDisplayPadding()),
                            side: BorderSide(color: Colors.white, width: _getDisplayPadding() / 2)
                        ),
                        image: DecorationImage(image: NetworkImage(avatarDisplayList![i]), fit: BoxFit.cover)
                    )
                )
            )
        );
      }
    }
    return SizedBox(
      height: _getAvatarWidth(),
      width: _getAvatarWidth() * ((avatarDisplayList?.length ?? 0) + 1)
          - (avatarDisplayList?.length ?? 0) * _getDisplayPadding(),
      child: Stack(
          children: list
      ),
    );
  }
}
