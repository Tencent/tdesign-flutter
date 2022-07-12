import 'package:flutter/material.dart';
import '../../../td_export.dart';

enum TDAvatarSize { large, medium, small }

enum TDAvatarType {
  normal,
  user,
  circle,
  square,
  customText,
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
      this.size = TDAvatarSize.medium,
      this.type = TDAvatarType.normal,
      this.text,
      this.avatarUrl,
      this.avatarSize,
      this.defaultUrl = ''})
      : super(key: key);

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
        width = 26;
        break;
      case TDAvatarSize.medium:
        width = 19.5;
        break;
      case TDAvatarSize.small:
        width = 13;
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
    }
  }
}
