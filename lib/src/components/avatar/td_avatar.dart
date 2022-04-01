import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

enum TDAvatarSize { Large, Medium, Small }

enum TDAvatarType {
  Default,
  User,
  Circle,
  Square,
  CustomText,
}

/// 用于头像显示
class TDAvatar extends StatelessWidget {
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

  const TDAvatar(
      {Key? key,
      this.size = TDAvatarSize.Medium,
      this.type = TDAvatarType.Default,
      this.text,
      this.avatarUrl,
      this.avatarSize,
      this.defaultUrl = ''})
      : super(key: key);

  double _getAvatarWidth() {
    double width;
    switch (size) {
      case TDAvatarSize.Large:
        width = 64;
        break;
      case TDAvatarSize.Medium:
        width = 48;
        break;
      case TDAvatarSize.Small:
        width = 32;
        break;
    }
    return avatarSize ?? width;
  }

  Font _getTextFont() {
    Font font;
    switch (size) {
      case TDAvatarSize.Large:
        font = Font(size: 16, lineHeight: 24);
        break;
      case TDAvatarSize.Medium:
        font = Font(size: 14, lineHeight: 22);
        break;
      case TDAvatarSize.Small:
        font = Font(size: 12, lineHeight: 20);
        break;
    }
    return font;
  }

  double _getIconWidth() {
    double width;
    switch (size) {
      case TDAvatarSize.Large:
        width = 26;
        break;
      case TDAvatarSize.Medium:
        width = 19.5;
        break;
      case TDAvatarSize.Small:
        width = 13;
        break;
    }
    return width;
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TDAvatarType.Default:
        return CircleAvatar(
          radius: _getAvatarWidth() / 2,
          backgroundColor: TDTheme.of(context).brandColor2,
          child: TDIcon(TDIcons.user,
              size: _getIconWidth(), color: TDTheme.of(context).brandColor8),
        );
      case TDAvatarType.User:
        return CircleAvatar(
            radius: _getAvatarWidth() / 2,
            backgroundColor: TDTheme.of(context).brandColor2,
            backgroundImage: avatarUrl != null
                ? NetworkImage(avatarUrl!)
                : NetworkImage(defaultUrl));
      case TDAvatarType.Circle:
        return CircleAvatar(
            radius: _getAvatarWidth() / 2,
            backgroundColor: TDTheme.of(context).brandColor2,
            backgroundImage: avatarUrl != null
                ? NetworkImage(avatarUrl!)
                : NetworkImage(defaultUrl));
      case TDAvatarType.Square:
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
      case TDAvatarType.CustomText:
        return CircleAvatar(
          radius: _getAvatarWidth() / 2,
          backgroundColor: TDTheme.of(context).brandColor8,
          child: TDText(
            text,
            showHeight: false,
            textAlign: TextAlign.center,
            font: _getTextFont(),
            textColor: TDTheme.of(context).whiteColor1,
          ),
        );
    }
  }
}
