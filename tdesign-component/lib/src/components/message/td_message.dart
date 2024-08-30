
import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/binding.dart';

import '../../../tdesign_flutter.dart';

// 定义消息对齐方式枚举
enum MessageAlign {
  /// 左对齐
  left,

  /// 右对齐
  center
}
//链接设置
class LinkObj {
  LinkObj({
    required this.name,
    required this.uri,
    this.color,
  });

  final String name;
  final Uri? uri;
  final Color? color;
}

// 跑马灯配置
class MessageMarquee {
  final int? speed;
  final int? loop;
  final int? delay;

  MessageMarquee({
    this.speed,
    this.loop,
    this.delay
  });
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
  final dynamic closeBtn;
  /// 通知内容
  final String? content;
  /// 消息内置计时器
  final int? duration;
  /// 自定义消息前面的图标
  final dynamic icon;
  /// 链接名称
  final dynamic link;
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

class _TDMessageState extends State<TDMessage> with TickerProviderStateMixin {
  bool _isVisible = true;
  double _topOffset = 0;
  double initTopOffset = 80;
  double totalWidth = 343;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    _topOffset = (widget.offset?[1] ?? initTopOffset) - 30;
    animationController = AnimationController(
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _topOffset = widget.offset?[1] ?? initTopOffset;
      });
    });

    if (widget.duration != null && widget.duration! > 0) {
      Future.delayed(Duration(milliseconds: widget.duration!), _closeMessage);
    }
  }

  @override
  void dispose() {
    animationController.stop();
    animationController.dispose();
    super.dispose();
  }

  void _closeMessage() {
    animationController.stop();
    setState(() {
      _topOffset = (widget.offset?[1] ?? initTopOffset) - 30;
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

    Widget getText(BuildContext context) {
      if (widget.marquee == null) {
        return SizedBox(
          width: calculateTextWidth(),
          child: Text(
            widget.content ?? '',
            style: const TextStyle(color: Colors.black),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      } else {
        final textPainter = TextPainter(
          text: TextSpan(text: widget.content ?? '',
          style: const TextStyle(color: Colors.black)),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout(minWidth: 0, maxWidth: double.infinity);
        final textWidth = textPainter.width;
        print('textWidth is ${textWidth}');

        final containerWidth = calculateTextWidth();

        final animationDuration = Duration(milliseconds: (widget.marquee!.speed ?? 10000));
        animationController.duration = animationDuration;

        final tween = Tween<Offset>(
          begin: Offset.zero,
          end: Offset(-textWidth, 0),
        );

        void startAnimation() {
          if (widget.marquee!.loop == 0) {
            animationController.forward();
          } else if(widget.marquee!.loop == 1){
            animationController.repeat();
          }
        }

        if (widget.marquee!.delay != null && widget.marquee!.delay! > 0) {
          Future.delayed(Duration(milliseconds: widget.marquee!.delay!), startAnimation);
        } else {
          startAnimation();
        }

        return ClipRect(
          child: SizedBox(
            width: containerWidth,
            child: AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                final offset = tween.evaluate(animationController);
                return OverflowBox(
                  minWidth: 0,
                  maxWidth: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: Transform.translate(
                    offset: offset,
                    child: SizedBox(
                      child: Text(
                        widget.content ?? '',
                        style: const TextStyle(color: Colors.black),
                        maxLines: 1,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }
    }

    Widget getIcon(BuildContext context) {
      if (widget.icon is Widget) {
        return widget.icon;
      } else {
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
    void clickCloseButton() {
      _closeMessage();
      widget.onCloseBtnClick?.call();
    }

    Widget getCloseBtn(BuildContext context) {
      if(widget.closeBtn is Widget) {
        return GestureDetector(
          onTap: clickCloseButton,
          child: widget.closeBtn!,
        );
      } else if(widget.closeBtn == true){
        return GestureDetector(
          onTap: clickCloseButton,
          child: Icon(TDIcons.close),
        );
      } else if(widget.closeBtn is String){
        return GestureDetector(
          onTap: clickCloseButton,
          child: Text(widget.closeBtn),
        );
      } else {
        return const SizedBox.shrink();
      }
    }
    void clickLink() {
      widget.onLinkClick?.call();
    }

    Widget getLink(BuildContext context) {
      if (widget.link is LinkObj) {
        return TDLink(
          label: widget.link.name,
          style: TDLinkStyle.primary,
          type: TDLinkType.basic,
          uri: widget.link.uri ?? Uri.parse('https://example.com'),
          size: TDLinkSize.small,
          color: widget.link.color ?? TDTheme.of(context).brandNormalColor,
        );
      } else if (widget.link is String) {
        return GestureDetector(
          onTap: clickLink,
          child: Text(
            widget.link ?? '',
            style: TextStyle(
              color: TDTheme.of(context).brandNormalColor,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    }

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      top: _topOffset,
      left: _leftOffset,
      child: _isVisible
          ? Material(
        color: Colors.transparent,
        child: Container(
          width: totalWidth,
          height: 48,
          padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              if (widget.icon != false)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SizedBox(
                    width: 20,
                    height: 22,
                    child: getIcon(context),
                  ),
                ),
              Expanded(
                child: Row(
                  children: [
                    getText(context),

                    if (widget.link != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: SizedBox(
                          width: 28,
                          height: 60,
                          child: getLink(context),
                        ),
                      ),
                    if (widget.closeBtn != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: getCloseBtn(context),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
          : const SizedBox.shrink(),
    );
  }

  double calculateTextWidth() {
    double width = totalWidth - 32;
    if (widget.icon != null && widget.icon != false) {
      width -= 30;
    }
    if (widget.link != null) {
      width -= 36;
    }
    if (widget.closeBtn != null) {
      width -= 34;
    }
    return width;
  }
}