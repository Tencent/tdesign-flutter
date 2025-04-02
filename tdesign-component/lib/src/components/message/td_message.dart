import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/binding.dart';

import '../../../tdesign_flutter.dart';

//链接设置
class MessageLink {
  MessageLink({
    required this.name,
    required this.uri,
    this.color,
  });

  /// 名称
  final String name;
  /// 资源链接
  final Uri? uri;
  /// 颜色
  final Color? color;
}

// 跑马灯配置
class MessageMarquee {

  MessageMarquee({this.speed, this.loop, this.delay});

  /// 速度
  final int? speed;
  /// 循环次数
  final int? loop;
  /// 延迟时间(毫秒)
  final int? delay;
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
  const TDMessage({
    Key? key,
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

  /// 通知内容
  final String? content;

  /// 消息内置计时器
  final int? duration;

  /// 是否显示
  final bool? visible;

  /// 自定义消息前面的图标
  final dynamic icon;

  /// 链接名称
  final dynamic link;

  /// 关闭按钮
  final dynamic closeBtn;

  /// 跑马灯效果
  final MessageMarquee? marquee;

  /// 相对于 placement 的偏移量
  final List<double>? offset;

  /// 消息组件风格 info/success/warning/error
  final MessageTheme? theme;

  /// 点击关闭按钮触发
  final VoidCallback? onCloseBtnClick;

  /// 计时结束后触发
  final VoidCallback? onDurationEnd;

  /// 点击链接文本时触发
  final VoidCallback? onLinkClick;

  @override
  _TDMessageState createState() => _TDMessageState();

  static void showMessage({
    required BuildContext context,
    String? content,
    bool? visible,
    int? duration,
    dynamic closeBtn,
    dynamic icon,
    dynamic link,
    MessageMarquee? marquee,
    List<double>? offset,
    MessageTheme? theme,
    VoidCallback? onCloseBtnClick,
    VoidCallback? onDurationEnd,
    VoidCallback? onLinkClick,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => TDMessage(
        content: content,
        visible: visible,
        duration: duration,
        closeBtn: closeBtn,
        icon: icon,
        link: link,
        marquee: marquee,
        offset: offset,
        theme: theme,
        onDurationEnd: () {
          onDurationEnd?.call();
          overlayEntry.remove();
        },
        onCloseBtnClick: onCloseBtnClick,
        onLinkClick: onLinkClick,
      ),
    );
    overlay.insert(overlayEntry);
  }
}

class _TDMessageState extends State<TDMessage> with TickerProviderStateMixin {
  bool _isVisible = true;
  double _topOffset = 0;
  double initTopOffset = 80;
  double totalWidth = 343;
  AnimationController? animationController;
  bool _isAnimationRunning = false;

  @override
  void initState() {
    super.initState();
    _topOffset = (widget.offset?[1] ?? initTopOffset) - 30;
    animationController = AnimationController(
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _topOffset = widget.offset?[1] ?? initTopOffset;
        });
      }
    });

    if (widget.duration != null && widget.duration! > 0) {
      Future.delayed(Duration(milliseconds: widget.duration!), _closeMessage);
    }

    if (widget.marquee != null) {
      animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.marquee!.speed ?? 10000),
      );
    }
  }

  @override
  void dispose() {
    animationController?.stop();
    animationController?.dispose();
    animationController = null;
    super.dispose();
  }

  void _closeMessage() {
    if (mounted) {
      animationController?.stop();
      setState(() {
        _topOffset = (widget.offset?[1] ?? initTopOffset) - 30;
        _isAnimationRunning = false;
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
  }

  void startAnimation() {
    if (mounted && animationController != null && !_isAnimationRunning) {
      setState(() {
        _isAnimationRunning = true;
      });
      if (widget.marquee!.loop == 0) {
        animationController!.forward();
      } else if (widget.marquee!.loop == 1) {
        animationController!.repeat();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.visible == false) {
      return const SizedBox.shrink();
    }
    var _leftOffset = widget.offset?[0] ?? (MediaQuery.of(context).size.width - totalWidth) / 2;

    Widget getText(BuildContext context) {
      if (widget.marquee == null) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.content ?? '',
            style: const TextStyle(color: Colors.black),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      } else {
        final textPainter = TextPainter(
          text: TextSpan(text: widget.content ?? '', style: const TextStyle(color: Colors.black)),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout(minWidth: 0, maxWidth: double.infinity);
        final textWidth = textPainter.width;

        final containerWidth = calculateTextWidth();

        final animationDuration = Duration(milliseconds: (widget.marquee!.speed ?? 10000));
        animationController!.duration = animationDuration;

        final tween = Tween<Offset>(
          begin: Offset.zero,
          end: Offset(-textWidth, 0),
        );

        if (widget.marquee!.delay != null && widget.marquee!.delay! > 0) {
          Future.delayed(Duration(milliseconds: widget.marquee!.delay!), startAnimation);
        } else {
          startAnimation();
        }

        return Align(
            alignment: Alignment.center,
            child: ClipRect(
              child: SizedBox(
                width: containerWidth,
                child: AnimatedBuilder(
                  animation: animationController ?? const AlwaysStoppedAnimation(0),
                  builder: (context, child) {
                    final offset = tween.evaluate(animationController ?? const AlwaysStoppedAnimation(0));
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
            ));
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
            return Icon(TDIcons.check_circle_filled, color: TDTheme.of(context).successColor5);
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
      if (widget.closeBtn is Widget) {
        return GestureDetector(
          onTap: clickCloseButton,
          child: widget.closeBtn!,
        );
      } else if (widget.closeBtn == true) {
        return GestureDetector(
          onTap: clickCloseButton,
          child: Icon(TDIcons.close,color:Color.fromRGBO(0, 0, 0, 0.4),),
        );
      } else if (widget.closeBtn is String) {
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
        return Align(
            alignment: Alignment.center,
            child: TDLink(
              label: widget.link.name,
              style: TDLinkStyle.primary,
              type: TDLinkType.basic,
              uri: widget.link.uri ?? Uri.parse('https://example.com'),
              size: TDLinkSize.small,
              color:TDTheme.of(context).brandColor7,
            ));
      } else if (widget.link is String) {
        return Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: clickLink,
              child: Text(
                widget.link ?? '',
                style: TextStyle(
                  color: TDTheme.of(context).brandColor7,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ));
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
                    boxShadow: TDTheme.of(context).shadowsMiddle),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.icon != false)
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 20,
                            height: 22,
                            child: getIcon(context),
                          ),
                        ),
                      ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: getText(context),
                            flex: 3,
                          ),
                          if (widget.link != null)
                            Container(
                                margin: const EdgeInsets.only(left: 8),
                                width: 40,
                                height: 22,
                                child:getLink(context)
                                    //
                            ),
                          if (widget.closeBtn != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: getCloseBtn(context),
                                ),
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
