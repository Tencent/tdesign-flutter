import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tdesign_icons/tdesign_icons.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_theme.dart';
import '../link/t_link.dart';
import '../link/t_link_theme_data.dart';
import '../link/t_link_types.dart';
import 't_message_theme_data.dart';

/// 消息中的链接配置
class TMessageLink {
  /// 创建消息链接
  const TMessageLink({
    required this.name,
    this.uri,
    this.color,
  });

  /// 链接文案
  final String name;

  /// 链接地址
  final Uri? uri;

  /// 链接颜色
  final Color? color;
}

/// 跑马灯配置
class TMessageMarquee {
  /// 创建跑马灯配置
  const TMessageMarquee({
    this.duration = const Duration(seconds: 10),
    this.repeat = false,
    this.delay = Duration.zero,
  });

  /// 单次滚动时长
  final Duration duration;

  /// 是否循环滚动
  final bool repeat;

  /// 开始滚动前的延迟
  final Duration delay;
}

/// 命令式消息句柄
final class TMessageHandle {
  TMessageHandle._();

  OverlayEntry? _entry;

  /// 消息是否仍在 Overlay 中
  bool get isShowing => _entry?.mounted == true;

  /// 立即移除消息
  void dismiss() {
    final entry = _entry;
    if (entry == null) {
      return;
    }
    entry.remove();
    _entry = null;
  }
}

/// 顶部消息组件
class TMessage extends StatefulWidget {
  /// 创建消息组件
  const TMessage({
    super.key,
    this.content = '',
    this.duration = const Duration(seconds: 3),
    this.visible = true,
    this.showIcon = true,
    this.icon,
    this.link,
    this.showCloseButton = false,
    this.closeButton,
    this.marquee,
    this.offset,
    this.variant = TMessageVariant.info,
    this.onCloseButtonPressed,
    this.onDurationEnd,
    this.onLinkPressed,
    this.onDismissed,
  });

  /// 通知内容
  final String content;

  /// 自动关闭时长，null 表示不自动关闭
  final Duration? duration;

  /// 是否显示
  final bool visible;

  /// 是否显示前置图标
  final bool showIcon;

  /// 自定义前置图标
  final Widget? icon;

  /// 链接配置
  final TMessageLink? link;

  /// 是否显示关闭按钮
  final bool showCloseButton;

  /// 自定义关闭按钮
  final Widget? closeButton;

  /// 跑马灯配置
  final TMessageMarquee? marquee;

  /// 相对屏幕左上角的偏移
  final Offset? offset;

  /// 消息语义色
  final TMessageVariant variant;

  /// 点击关闭按钮时触发
  final VoidCallback? onCloseButtonPressed;

  /// 自动展示时长结束且关闭动画完成时触发
  final VoidCallback? onDurationEnd;

  /// 点击链接时触发
  final VoidCallback? onLinkPressed;

  /// 关闭动画完成时触发
  final VoidCallback? onDismissed;

  /// 在 Overlay 中显示消息并返回控制句柄
  static TMessageHandle show({
    /// 用于查找 Overlay 的上下文。
    required BuildContext context,
    String content = '',
    Duration? duration = const Duration(seconds: 3),
    bool showIcon = true,
    Widget? icon,
    TMessageLink? link,
    bool showCloseButton = false,
    Widget? closeButton,
    TMessageMarquee? marquee,
    Offset? offset,
    TMessageVariant variant = TMessageVariant.info,
    VoidCallback? onCloseButtonPressed,
    VoidCallback? onDurationEnd,
    VoidCallback? onLinkPressed,
    VoidCallback? onDismissed,
  }) {
    final handle = TMessageHandle._();
    late OverlayEntry entry;

    void removeEntry() {
      if (handle._entry == null) {
        return;
      }
      handle.dismiss();
      onDismissed?.call();
    }

    entry = OverlayEntry(
      builder: (context) => TMessage(
        content: content,
        duration: duration,
        showIcon: showIcon,
        icon: icon,
        link: link,
        showCloseButton: showCloseButton,
        closeButton: closeButton,
        marquee: marquee,
        offset: offset,
        variant: variant,
        onCloseButtonPressed: onCloseButtonPressed,
        onDurationEnd: onDurationEnd,
        onLinkPressed: onLinkPressed,
        onDismissed: removeEntry,
      ),
    );
    handle._entry = entry;
    Overlay.of(context).insert(entry);
    return handle;
  }

  @override
  State<TMessage> createState() => _TMessageState();
}

class _TMessageState extends State<TMessage>
    with SingleTickerProviderStateMixin {
  static const double _defaultTop = 80;
  static const double _width = 343;
  static const double _horizontalMargin = 16;

  late final AnimationController _animationController;
  bool _isVisible = true;
  bool _isAnimationRunning = false;
  bool _closing = false;
  double _top = _defaultTop - 30;
  Timer? _durationTimer;
  Timer? _closeTimer;
  Timer? _marqueeDelayTimer;

  TMessageThemeData get _theme =>
      Theme.of(context).extension<TMessageThemeData>() ??
      const TMessageThemeData();

  double get _effectiveWidth {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return _width.clamp(0, screenWidth - _horizontalMargin * 2).toDouble();
  }

  Offset get _effectiveOffset {
    final configured = widget.offset ?? _theme.defaultOffset;
    return configured ??
        Offset((MediaQuery.sizeOf(context).width - _effectiveWidth) / 2,
            _defaultTop);
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.marquee?.duration ?? const Duration(seconds: 10),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _top = _effectiveOffset.dy);
      }
    });
    _scheduleDurationClose();
    _scheduleMarqueeStart();
  }

  @override
  void didUpdateWidget(covariant TMessage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.marquee?.duration != widget.marquee?.duration) {
      _animationController.duration =
          widget.marquee?.duration ?? const Duration(seconds: 10);
    }
    if (oldWidget.duration != widget.duration) {
      _scheduleDurationClose();
    }
    if (oldWidget.marquee != widget.marquee) {
      _animationController.reset();
      _isAnimationRunning = false;
      _scheduleMarqueeStart();
    }
    if (!oldWidget.visible && widget.visible) {
      _closing = false;
      _isVisible = true;
      _scheduleDurationClose();
    }
  }

  @override
  void dispose() {
    _durationTimer?.cancel();
    _closeTimer?.cancel();
    _marqueeDelayTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _scheduleDurationClose() {
    _durationTimer?.cancel();
    final duration = widget.duration;
    if (duration != null && duration > Duration.zero) {
      _durationTimer = Timer(duration, () => _close(durationEnded: true));
    }
  }

  void _scheduleMarqueeStart() {
    _marqueeDelayTimer?.cancel();
    final marquee = widget.marquee;
    if (marquee == null) {
      return;
    }
    if (marquee.delay > Duration.zero) {
      _marqueeDelayTimer = Timer(marquee.delay, _startAnimation);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _startAnimation());
    }
  }

  void _startAnimation() {
    final marquee = widget.marquee;
    if (!mounted || marquee == null || _isAnimationRunning || _closing) {
      return;
    }
    setState(() => _isAnimationRunning = true);
    if (marquee.repeat) {
      _animationController.repeat();
    } else {
      _animationController.forward();
    }
  }

  void _close({bool durationEnded = false}) {
    if (_closing || !mounted) {
      return;
    }
    _closing = true;
    _durationTimer?.cancel();
    _marqueeDelayTimer?.cancel();
    _animationController.stop();
    setState(() {
      _top = _effectiveOffset.dy - 30;
      _isAnimationRunning = false;
    });
    _closeTimer = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) {
        return;
      }
      setState(() => _isVisible = false);
      if (durationEnded) {
        widget.onDurationEnd?.call();
      }
      widget.onDismissed?.call();
    });
  }

  Widget _buildText(BuildContext context) {
    final style = TextStyle(color: context.tTheme.textColorPrimary);
    if (widget.marquee == null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          widget.content,
          style: style,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    final textPainter = TextPainter(
      text: TextSpan(text: widget.content, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    final tween = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-textPainter.width, 0),
    );
    return ClipRect(
      child: SizedBox(
        width: _calculateTextWidth(),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) => Transform.translate(
            offset: tween.evaluate(_animationController),
            child: OverflowBox(
              minWidth: 0,
              maxWidth: double.infinity,
              alignment: Alignment.centerLeft,
              child: child,
            ),
          ),
          child: Text(widget.content, style: style, maxLines: 1),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    if (widget.icon != null) {
      return widget.icon!;
    }
    final (icon, color) = switch (widget.variant) {
      TMessageVariant.info => (
          TIcons.error_circle_filled,
          context.tTheme.brandNormalColor
        ),
      TMessageVariant.success => (
          TIcons.check_circle_filled,
          context.tTheme.successNormalColor
        ),
      TMessageVariant.warning => (
          TIcons.error_circle_filled,
          context.tTheme.warningNormalColor
        ),
      TMessageVariant.error => (
          TIcons.error_circle_filled,
          context.tTheme.errorNormalColor
        ),
    };
    return Icon(icon, color: color);
  }

  Widget _buildLink(BuildContext context) {
    final link = widget.link!;
    final linkWidget = TLink(
      child: Text(
        link.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      colorScheme: TLinkColorScheme.primary,
      variant: TLinkVariant.basic,
      uri: link.uri,
      size: TLinkSize.medium,
      onPressed: widget.onLinkPressed,
    );
    if (link.color == null) {
      return linkWidget;
    }
    return Theme(
      data: Theme.of(context).mergeExtension(
        TLinkThemeData(color: link.color),
      ),
      child: linkWidget,
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onCloseButtonPressed?.call();
        _close();
      },
      child: widget.closeButton ??
          Icon(
            TIcons.close,
            color: context.tTheme.textColorPlaceholder,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.visible) {
      return const SizedBox.shrink();
    }
    final offset = _effectiveOffset;
    final theme = _theme;
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      top: _top,
      left: offset.dx,
      child: _isVisible
          ? Material(
              color: theme.backgroundColor ?? context.tTheme.bgColorContainer,
              shape: theme.shape ??
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(context.tTheme.radiusDefault),
                  ),
              elevation: theme.elevation ?? 6,
              child: SizedBox(
                width: _effectiveWidth,
                height: 48,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      if (widget.showIcon) ...[
                        SizedBox(
                            width: 20, height: 22, child: _buildIcon(context)),
                        const SizedBox(width: 10),
                      ],
                      Expanded(child: _buildText(context)),
                      if (widget.link != null) ...[
                        const SizedBox(width: 8),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 96),
                          child: _buildLink(context),
                        ),
                      ],
                      if (widget.showCloseButton ||
                          widget.closeButton != null) ...[
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 22,
                          height: 22,
                          child: _buildCloseButton(context),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  double _calculateTextWidth() {
    var width = _effectiveWidth - 32;
    if (widget.showIcon) {
      width -= 30;
    }
    if (widget.link != null) {
      width -= 104;
    }
    if (widget.showCloseButton || widget.closeButton != null) {
      width -= 30;
    }
    return width;
  }
}
