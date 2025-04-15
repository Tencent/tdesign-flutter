import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';


enum TDBackTopTheme {
  light, // 明亮主题
  dark // 暗黑主题
}

enum TDBackTopStyle {
  circle, // 圆形
  halfCircle, // 半圆形
}

class TDBackTop extends StatefulWidget {
  const TDBackTop({
    Key? key,
    this.controller,
    this.theme = TDBackTopTheme.light,
    this.style = TDBackTopStyle.circle,
    this.showText = false,
    this.onClick,
  }) : super(key: key);

  /// 页面滚动的控制器
  final ScrollController? controller;

  /// 主题
  final TDBackTopTheme theme;

  /// 样式，圆形和半圆
  final TDBackTopStyle style;

  /// 是否展示文字
  final bool showText;

  /// 按钮点击事件
  final VoidCallback? onClick;

  @override
  State<TDBackTop> createState() => _TDBackTopState();
}

class _TDBackTopState extends State<TDBackTop> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.controller != null && widget.controller!.hasClients) {
          widget.controller!.animateTo(0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn);
        }

        if (widget.onClick != null) {
          widget.onClick!();
        }
      },
      child: widget.style == TDBackTopStyle.circle
          ? _buildCircleWidget(context)
          : _buildHalfCircleWidget(context),
    );
  }

  Widget _buildCircleWidget(BuildContext context) {
    var color = widget.theme == TDBackTopTheme.dark
        ? Colors.white
        : const Color.fromRGBO(0, 0, 0, 0.9);

    return Container(
      width: 48,
      height: 48,
      padding: EdgeInsets.symmetric(
          vertical: widget.showText ? 6 : 13),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border:Border.all(color: widget.theme== TDBackTopTheme.dark? TDTheme.of(context).grayColor14 :TDTheme.of(context).grayColor4,width: 0.5),
          color: widget.theme == TDBackTopTheme.light
              ? Colors.white
              : TDTheme.of(context).grayColor14),

      child: Center(
          child: Column(
        children: [
          Icon(
            TDIcons.backtop,
            size: 20,
            color: color,
          ),
          Visibility(
            visible: widget.showText,
            child: TDText(
              context.resource.top,
              maxLines: 1,
              overflow: TextOverflow.visible,
              style: TextStyle(
                  fontSize: 10, color: color, fontWeight: FontWeight.w600),
            ),
          )
        ],
      )),
    );
  }

  Widget _buildHalfCircleWidget(BuildContext context) {
    var color = widget.theme == TDBackTopTheme.dark
        ? Colors.white
        : const Color.fromRGBO(0, 0, 0, 0.9);

    return ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 38),
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
              color: widget.theme == TDBackTopTheme.light
                  ? Colors.white
                  : TDTheme.of(context).grayColor14,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(999),
                  bottomLeft: Radius.circular(999)
              ),
              border:Border.all(color: widget.theme== TDBackTopTheme.dark?Color.fromRGBO(94, 94, 94, 1):Color.fromRGBO(220, 220, 220, 1),width: 0.5)
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                TDIcons.backtop,
                size: 22,
                color: color,
              ),
              const SizedBox(
                width: 2,
              ),
              Visibility(
                visible: widget.showText,
                child: SizedBox(
                    height: 32,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TDText(
                          context.resource.back,
                          style: TextStyle(
                              height: 1.2,
                              fontSize: 10,
                              color: color,
                              fontWeight: FontWeight.w600),
                        ),
                        TDText(
                          context.resource.top,
                          style: TextStyle(
                              height: 1.2,
                              fontSize: 10,
                              color: color,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
              )
            ],
          ),
        ));
  }
}
