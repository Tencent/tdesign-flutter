import 'package:flutter/material.dart';
import 'td_popover_style.dart';

class TDPopoverWidget extends StatelessWidget {
  const TDPopoverWidget({
    super.key,
    required this.context,
    required this.content,
    this.offset,
    this.theme,
  });

  ///
  final BuildContext context;

  /// 偏移
  final double? offset;

  /// 显示内容
  final String content;

  final TDPopoverTheme? theme;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 200,
          left: 20,
          child: Container(
            color: Colors.black,
            width: 200,
            height: 40,
            child: Text(content, style: TextStyle(color: Colors.white),),
          ),
        )
      ],
    );
  }
}