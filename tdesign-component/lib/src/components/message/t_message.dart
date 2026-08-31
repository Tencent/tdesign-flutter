import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_shadows.dart';
import '../../theme/t_theme.dart';
import 't_message_theme_data.dart';

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

final class _TMessageSlot {
  TMessageHandle? handle;
  VoidCallback? onDismissed;
}

/// 顶部消息组件
class TMessage extends StatefulWidget {
  static final Expando<_TMessageSlot> _defaultSlots = Expando<_TMessageSlot>(
    'TMessage.defaultSlots',
  );

  /// 创建消息组件
  const TMessage({
    super.key,
    this.content = '',
    this.duration = const Duration(seconds: 3),
    this.visible = false,
    this.showIcon = true,
    this.icon,
    this.action,
    this.showCloseButton = false,
    this.closeButton,
    this.marquee,
    this.offset,
    this.variant = TMessageVariant.info,
    this.onCloseButtonPressed,
    this.onDurationEnd,
    this.onDismissed,
    this.useSafeArea = true,
  });

  /// 通知内容
  final String content;

  /// 自动关闭时长；必须为正数，null 表示不自动关闭。
  final Duration? duration;

  /// 是否显示，默认为 false
  final bool visible;

  /// 是否显示前置图标
  final bool showIcon;

  /// 自定义前置图标
  final Widget? icon;

  /// 消息尾部操作组件。
  ///
  /// 操作的外观与行为由组件自身负责，例如传入带 [VoidCallback] 的按钮或链接。
  final Widget? action;

  /// 是否显示关闭按钮
  final bool showCloseButton;

  /// 自定义关闭按钮
  final Widget? closeButton;

  /// 跑马灯配置
  final TMessageMarquee? marquee;

  /// 期望的屏幕绝对坐标。
  ///
  /// [useSafeArea] 为 true 时，最终消息矩形会被约束在安全可视区域内。
  final Offset? offset;

  /// 是否避让系统安全区，默认为 true。
  final bool useSafeArea;

  /// 消息语义色
  final TMessageVariant variant;

  /// 点击关闭按钮时触发
  final VoidCallback? onCloseButtonPressed;

  /// 自动展示时长结束且关闭动画完成时触发
  final VoidCallback? onDurationEnd;

  /// 关闭动画完成时触发
  final VoidCallback? onDismissed;

  /// 在 Overlay 中显示消息并返回控制句柄。
  ///
  /// 未显式传入 [offset] 时，新消息会替换同一 Overlay 中上一条默认位置的消息；
  /// 显式传入不同 [offset] 的消息可以同时展示。
  static TMessageHandle show({
    /// 用于查找 Overlay 的上下文。
    required BuildContext context,
    String content = '',

    /// 自动关闭时长；必须为正数，null 表示不自动关闭。
    Duration? duration = const Duration(seconds: 3),
    bool showIcon = true,
    Widget? icon,
    Widget? action,
    bool showCloseButton = false,
    Widget? closeButton,
    TMessageMarquee? marquee,
    Offset? offset,
    TMessageVariant variant = TMessageVariant.info,
    VoidCallback? onCloseButtonPressed,
    VoidCallback? onDurationEnd,
    VoidCallback? onDismissed,
    bool useSafeArea = true,
  }) {
    assert(
      duration == null || duration > Duration.zero,
      'duration 必须为正数；使用 null 表示不自动关闭。',
    );
    final handle = TMessageHandle._();
    late OverlayEntry entry;
    final overlay = Overlay.of(context);
    final captured = InheritedTheme.capture(from: context, to: overlay.context);
    final slot = offset == null
        ? (_defaultSlots[overlay] ??= _TMessageSlot())
        : null;
    final previousHandle = slot?.handle;
    final previousOnDismissed = slot?.onDismissed;
    previousOnDismissed?.call();
    previousHandle?.dismiss();

    void removeEntry() {
      if (handle._entry == null) {
        return;
      }
      handle.dismiss();
      if (slot?.handle == handle) {
        slot?.handle = null;
        slot?.onDismissed = null;
      }
      onDismissed?.call();
    }

    entry = OverlayEntry(
      builder: (context) => captured.wrap(
        TMessage(
          content: content,
          duration: duration,
          visible: true,
          showIcon: showIcon,
          icon: icon,
          action: action,
          showCloseButton: showCloseButton,
          closeButton: closeButton,
          marquee: marquee,
          offset: offset,
          variant: variant,
          onCloseButtonPressed: onCloseButtonPressed,
          onDurationEnd: onDurationEnd,
          onDismissed: removeEntry,
          useSafeArea: useSafeArea,
        ),
      ),
    );
    handle._entry = entry;
    if (slot case final currentSlot?) {
      currentSlot
        ..handle = handle
        ..onDismissed = onDismissed;
    }
    overlay.insert(entry);
    return handle;
  }

  @override
  State<TMessage> createState() => _TMessageState();
}

class _TMessageState extends State<TMessage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  bool _isVisible = true;
  bool _isAnimationRunning = false;
  bool _closing = false;
  bool _didAnimateIn = false;
  double _top = 0;
  Timer? _durationTimer;
  Timer? _closeTimer;
  Timer? _marqueeDelayTimer;

  TMessageThemeData get _theme =>
      Theme.of(context).extension<TMessageThemeData>() ??
      const TMessageThemeData();

  EdgeInsets get _safePadding =>
      widget.useSafeArea ? MediaQuery.paddingOf(context) : EdgeInsets.zero;

  double get _defaultTop => _safePadding.top + kToolbarHeight;

  double get _minimumLeft => _safePadding.left;

  double get _maximumRight =>
      MediaQuery.sizeOf(context).width - _safePadding.right;

  double get _effectiveWidth {
    final availableWidth = math.max(0.0, _maximumRight - _minimumLeft);
    return availableWidth;
  }

  double _safeTop(double desiredTop) {
    if (!widget.useSafeArea) {
      return desiredTop;
    }
    final minimumTop = _safePadding.top;
    final maximumTop = math.max(
      minimumTop,
      MediaQuery.sizeOf(context).height - _safePadding.bottom - 48,
    );
    return desiredTop.clamp(minimumTop, maximumTop).toDouble();
  }

  Offset get _effectiveOffset {
    final configured = widget.offset ?? _theme.defaultOffset;
    final desired =
        configured ??
        Offset(
          _minimumLeft + (_maximumRight - _minimumLeft - _effectiveWidth) / 2,
          _defaultTop,
        );
    if (!widget.useSafeArea) {
      return desired;
    }
    final maximumLeft = math.max(_minimumLeft, _maximumRight - _effectiveWidth);
    return Offset(
      desired.dx.clamp(_minimumLeft, maximumLeft).toDouble(),
      _safeTop(desired.dy),
    );
  }

  @override
  void initState() {
    super.initState();
    assert(
      widget.duration == null || widget.duration! > Duration.zero,
      'duration 必须为正数；使用 null 表示不自动关闭。',
    );
    _animationController = AnimationController(
      vsync: this,
      duration: widget.marquee?.duration ?? const Duration(seconds: 10),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _top = _effectiveOffset.dy;
          _didAnimateIn = true;
        });
      }
    });
    if (widget.visible) {
      _scheduleDurationClose();
      _scheduleMarqueeStart();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didAnimateIn) {
      _top = _effectiveOffset.dy;
    }
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
      _scheduleMarqueeStart();
    } else if (oldWidget.visible && !widget.visible) {
      _durationTimer?.cancel();
      _closeTimer?.cancel();
      _marqueeDelayTimer?.cancel();
      _animationController.stop();
      _isAnimationRunning = false;
      _closing = false;
      _isVisible = false;
      _top = _effectiveOffset.dy;
    }
    if (oldWidget.offset != widget.offset ||
        oldWidget.useSafeArea != widget.useSafeArea) {
      _top = _effectiveOffset.dy;
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
    assert(
      duration == null || duration > Duration.zero,
      'duration 必须为正数；使用 null 表示不自动关闭。',
    );
    if (duration == null) {
      return;
    }
    if (duration <= Duration.zero) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _close(durationEnded: true);
      });
      return;
    }
    _durationTimer = Timer(duration, () => _close(durationEnded: true));
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
    final style = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(color: context.tTheme.textColorPrimary);
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
        context.tTheme.brandNormalColor,
      ),
      TMessageVariant.success => (
        TIcons.check_circle_filled,
        context.tTheme.successNormalColor,
      ),
      TMessageVariant.warning => (
        TIcons.error_circle_filled,
        context.tTheme.warningNormalColor,
      ),
      TMessageVariant.error => (
        TIcons.error_circle_filled,
        context.tTheme.errorNormalColor,
      ),
    };
    return Icon(icon, color: color, size: 22);
  }

  Widget _buildCloseButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onCloseButtonPressed?.call();
        _close();
      },
      child:
          widget.closeButton ??
          Icon(TIcons.close, color: context.tTheme.textColorPlaceholder),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.visible) {
      return const SizedBox.shrink();
    }
    final offset = _effectiveOffset;
    final theme = _theme;
    final backgroundColor =
        theme.backgroundColor ?? context.tTheme.bgColorContainer;
    final shape =
        theme.shape ??
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.tTheme.radiusDefault),
        );
    final content = SizedBox(
      width: _effectiveWidth,
      height: 48,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            if (widget.showIcon) ...[
              SizedBox(width: 22, height: 22, child: _buildIcon(context)),
              const SizedBox(width: 8),
            ],
            Expanded(child: _buildText(context)),
            if (widget.action != null) ...[
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 96),
                child: widget.action,
              ),
            ],
            if (widget.showCloseButton || widget.closeButton != null) ...[
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
    );
    final message = theme.elevation == null
        ? DecoratedBox(
            decoration: ShapeDecoration(
              color: backgroundColor,
              shape: shape,
              shadows: context.tTheme.shadowsBase ?? const [],
            ),
            child: Material(type: MaterialType.transparency, child: content),
          )
        : Material(
            color: backgroundColor,
            shape: shape,
            elevation: theme.elevation!,
            child: content,
          );
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      top: _safeTop(_top),
      left: offset.dx,
      child: _isVisible ? message : const SizedBox.shrink(),
    );
  }

  double _calculateTextWidth() {
    var width = _effectiveWidth - 32;
    if (widget.showIcon) {
      width -= 30;
    }
    if (widget.action != null) {
      width -= 104;
    }
    if (widget.showCloseButton || widget.closeButton != null) {
      width -= 30;
    }
    return width;
  }
}
