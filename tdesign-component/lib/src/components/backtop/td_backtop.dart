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
  bool _isAnimating = false;

  late final Color _bgColor;
  late final Color _borderColor;
  late final Color _fontColor;

  @override
  void initState() {
    super.initState();
    _initColors();
  }

  void _initColors() {
    final theme = TDTheme.of(context);
    _bgColor = _getColorByTheme(
      lightColor: theme.grayColor1,
      darkColor: theme.grayColor13,
    );
    _borderColor = _getColorByTheme(
      lightColor: theme.grayColor4,
      darkColor: theme.grayColor9,
    );
    _fontColor = _getColorByTheme(
      lightColor: theme.textColorPrimary,
      darkColor: theme.textColorAnti,
    );
  }

  Color _getColorByTheme({
    required Color lightColor,
    required Color darkColor,
  }) {
    return widget.theme == TDBackTopTheme.light ? lightColor : darkColor;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: widget.style == TDBackTopStyle.circle
          ? _buildCircleWidget(context)
          : _buildHalfCircleWidget(context),
    );
  }

  Future<void> _handleTap() async {
    /// 防抖处理，防止短时间内重复触发
    if (_isAnimating) {
      return;
    }

    if (widget.controller != null && widget.controller!.hasClients) {
      _isAnimating = true;
      await widget.controller!.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
      _isAnimating = false;
    }

    widget.onClick?.call();
  }

  Widget _buildCircleWidget(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      padding: EdgeInsets.symmetric(vertical: widget.showText ? 6 : 13),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TDTheme.of(context).radiusCircle),
          border: Border.all(color: _borderColor, width: 0.5),
          color: _bgColor),
      child: Center(
          child: Column(
        children: [
          Icon(
            TDIcons.backtop,
            size: 20,
            color: _fontColor,
          ),
          Visibility(
            visible: widget.showText,
            child: TDText(
              context.resource.top,
              maxLines: 1,
              overflow: TextOverflow.visible,
              style: TextStyle(
                  fontSize: 10, color: _fontColor, fontWeight: FontWeight.w600),
            ),
          )
        ],
      )),
    );
  }

  Widget _buildHalfCircleWidget(BuildContext context) {
    return ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 38),
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
              color: _bgColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(TDTheme.of(context).radiusCircle),
                  bottomLeft:
                      Radius.circular(TDTheme.of(context).radiusCircle)),
              border: Border.all(color: _borderColor, width: 0.5)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                TDIcons.backtop,
                size: 22,
                color: _fontColor,
              ),
              const SizedBox(
                width: 2,
              ),
              Visibility(
                visible: widget.showText,
                child: SizedBox(
                    height: 32,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// todo 将 “返回”、“顶部” 两个文本拆分开组合，中文语境下可以，但对于其他语言未必可行
                        TDText(
                          context.resource.back,
                          style: TextStyle(
                              height: 1.2,
                              fontSize: 10,
                              color: _fontColor,
                              fontWeight: FontWeight.w600),
                        ),
                        TDText(
                          context.resource.top,
                          style: TextStyle(
                              height: 1.2,
                              fontSize: 10,
                              color: _fontColor,
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
