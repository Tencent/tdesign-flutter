import 'package:flutter/material.dart';

/// 框架定义TIcon
class TDIcon extends StatelessWidget {
  final IconData? data;

  final double? size;

  final Color? color;

  const TDIcon(this.data, {this.size, this.color, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data is CustomIconData) {
      return (data as CustomIconData).build(context);
    } else {
      return Icon(data, size: size, color: color);
    }
  }
}

/// 业务自定义数据映射关系
abstract class CustomIconData extends IconData {
  /// 默认codePoint， 统一为0 会影响 == 操作符
  static const DEFAULT_CONE_POINT = 0;

  const CustomIconData({int codePoint = DEFAULT_CONE_POINT})
      : super(
          codePoint,
        );

  /// 自定义返回操作
  Widget build(BuildContext context);
}
