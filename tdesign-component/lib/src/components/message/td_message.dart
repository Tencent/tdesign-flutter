
import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/binding.dart';

import '../../../tdesign_flutter.dart';
import '../link/td_link.dart';

// 定义消息对齐方式枚举
enum MessageAlign {
  /// 左对齐
  left,

  /// 右对齐
  center
}

// 跑马灯配置
class MessageMarquee {
  final double? speed;
  final int? loop;
  final int? delay;

  MessageMarquee({this.speed, this.loop, this.delay});
}

// 定义消息主题枚举
enum MessageTheme {
  /// 普通通知
  info,

  /// 成功通知
  success,

  /// 警示通知
  warning,

  /// 错误通知
  error
}

// TDMessage 组件
class TDMessage extends StatefulWidget {
  /// 对齐方式
  final MessageAlign? align;
  /// 关闭按钮
  final Widget? closeBtn;
  /// 通知内容
  final String? content;
  /// 消息内置计时器
  final int? duration;
  /// 自定义消息前面的图标
  final bool? icon;
  /// 链接名称
  final Widget? link;
  /// 跑马灯效果
  final MessageMarquee? marquee;
  /// 相对于 placement 的偏移量
  final List<double>? offset;
  /// 消息组件风格 info/success/warning/error
  final MessageTheme? theme;
  /// 是否显示
  final bool? visible;
  /// 点击关闭按钮触发
  final VoidCallback? onCloseBtnClick;
  /// 计时结束后触发
  final VoidCallback? onDurationEnd;
  /// 点击链接文本时触发
  final VoidCallback? onLinkClick;

  const TDMessage({
    Key? key,
    this.align,
    this.closeBtn,
    this.content,
    this.duration = 3000,
    this.icon = true,
    this.link,
    this.marquee,
    this.offset,
    this.theme = MessageTheme.info,
    this.visible = true,
    this.onCloseBtnClick,
    this.onDurationEnd,
    this.onLinkClick,
  }) : super(key: key);

  @override
  _TDMessageState createState() => _TDMessageState();
}

class _TDMessageState extends State<TDMessage> {
  bool _isVisible = true;
  double _topOffset = 0;

  @override
  void initState() {
    super.initState();
    _topOffset = (widget.offset?[1] ?? 110) - 30;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _topOffset = widget.offset?[1] ?? 110;
      });
    });

    if (widget.duration != null && widget.duration! > 0) {
      Future.delayed(Duration(milliseconds: widget.duration!), _closeMessage);
    }
  }

  void _closeMessage() {
    setState(() {
      _topOffset = (widget.offset?[1] ?? 110) - 30;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isVisible = false;
        });
        widget.onDurationEnd?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _leftOffset = widget.offset?[0] ?? (MediaQuery.of(context).size.width - 343) / 2;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      top: _topOffset,
      left: _leftOffset,
      child: _isVisible
          ? Material(
              color: Colors.transparent,
              child: Container(
                width: 343,
                height: 48,
                padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    if (widget.icon ?? true)
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: getIcon(context),
                        ),
                      ),
                    Expanded(
                      child: Text(
                        widget.content ?? '',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget getIcon(BuildContext context) {
    switch (widget.theme) {
      case MessageTheme.info:
        return Icon(TDIcons.error_circle_filled, color: TDTheme.of(context).brandColor7);
      case MessageTheme.success:
        return Icon(TDIcons.error_circle_filled, color: TDTheme.of(context).successColor5);
      case MessageTheme.warning:
        return Icon(TDIcons.error_circle_filled, color: TDTheme.of(context).warningColor5);
      case MessageTheme.error:
        return Icon(TDIcons.error_circle_filled, color: TDTheme.of(context).errorColor6);
      case null:
        return const SizedBox.shrink();
    }
  }
}