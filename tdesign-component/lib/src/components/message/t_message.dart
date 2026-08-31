import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_shadows.dart';
import '../../theme/t_theme.dart';
import 't_message_theme_data.dart';
import 't_message_types.dart';

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

  bool _isShowing = false;
  void Function(_TMessageDismissCause cause)? _dismiss;

  /// 消息是否仍在 Overlay 中
  bool get isShowing => _isShowing;

  /// 立即移除消息；重复调用不会重复触发 `onDismissed`。
  void dismiss() {
    _dismiss?.call(_TMessageDismissCause.programmatic);
  }
}

final class _TMessageSlot {
  TMessageHandle? handle;
}

enum _TMessageDismissCause { programmatic, replaced, widget, unmounted }

/// 顶部消息组件。
///
/// 直接构造即渲染消息，并应作为 [Stack] 的子组件使用。页面内的展示与隐藏由父级
/// Widget 树插入或移除组件；使用自动关闭或关闭按钮时，可在 [onDismissed] 中同步
/// 移除父级状态。全局 Overlay 消息使用 [TMessage.show]，并通过返回的
/// [TMessageHandle] 关闭。
class TMessage extends StatefulWidget {
  static final Expando<_TMessageSlot> _defaultSlots = Expando<_TMessageSlot>(
    'TMessage.defaultSlots',
  );

  /// 创建消息组件
  const TMessage({
    super.key,
    this.content = '',
    this.duration = const Duration(seconds: 3),
    this.showIcon = true,
    this.icon,
    this.action,
    this.showCloseButton = false,
    this.closeButton,
    this.marquee,
    this.offset,
    this.status = TMessageStatus.info,
    this.onCloseButtonPressed,
    this.onDurationEnd,
    this.onDismissed,
    this.useSafeArea = true,
  });

  /// 通知内容
  final String content;

  /// 自动关闭时长；必须为正数，null 表示不自动关闭。
  final Duration? duration;

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

  /// 消息语义状态
  final TMessageStatus status;

  /// 点击关闭按钮时触发
  final VoidCallback? onCloseButtonPressed;

  /// 自动展示时长结束且关闭动画完成时触发
  final VoidCallback? onDurationEnd;

  /// 消息完成关闭、被句柄移除、被新消息替换或 Overlay 卸载时触发。
  ///
  /// 每次展示最多触发一次。
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
    TMessageStatus status = TMessageStatus.info,
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
    final messageKey = GlobalKey<_TMessageState>();
    late OverlayEntry entry;
    final overlay = Overlay.of(context);
    final captured = InheritedTheme.capture(from: context, to: overlay.context);
    final slot = offset == null
        ? (_defaultSlots[overlay] ??= _TMessageSlot())
        : null;
    final previousHandle = slot?.handle;

    var dismissed = false;
    late VoidCallback entryListener;

    void dismissEntry(_TMessageDismissCause cause) {
      if (dismissed) {
        return;
      }
      dismissed = true;
      if (cause == _TMessageDismissCause.programmatic ||
          cause == _TMessageDismissCause.replaced) {
        messageKey.currentState?._cancelTasksForExternalDismiss();
      }
      entry.removeListener(entryListener);
      handle
        .._isShowing = false
        .._dismiss = null;
      if (slot?.handle == handle) {
        slot?.handle = null;
        _defaultSlots[overlay] = null;
      }
      if (cause != _TMessageDismissCause.unmounted) {
        entry.remove();
      }
      onDismissed?.call();
    }

    entry = OverlayEntry(
      builder: (context) => captured.wrap(
        TMessage(
          key: messageKey,
          content: content,
          duration: duration,
          showIcon: showIcon,
          icon: icon,
          action: action,
          showCloseButton: showCloseButton,
          closeButton: closeButton,
          marquee: marquee,
          offset: offset,
          status: status,
          onCloseButtonPressed: onCloseButtonPressed,
          onDurationEnd: onDurationEnd,
          onDismissed: () => dismissEntry(_TMessageDismissCause.widget),
          useSafeArea: useSafeArea,
        ),
      ),
    );
    entryListener = () {
      if (!entry.mounted) {
        dismissEntry(_TMessageDismissCause.unmounted);
      }
    };
    handle
      .._isShowing = true
      .._dismiss = dismissEntry;
    if (slot case final currentSlot?) {
      currentSlot.handle = handle;
    }
    entry.addListener(entryListener);
    overlay.insert(entry);
    previousHandle?._dismiss?.call(_TMessageDismissCause.replaced);
    return handle;
  }

  @override
  State<TMessage> createState() => _TMessageState();
}

class _TMessageState extends State<TMessage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  bool _isPresented = true;
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
    final desired =
        widget.offset ??
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
    _scheduleDurationClose();
    _scheduleMarqueeStart();
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

  void _cancelTasksForExternalDismiss() {
    _closing = true;
    _durationTimer?.cancel();
    _closeTimer?.cancel();
    _marqueeDelayTimer?.cancel();
    _animationController.stop();
    _isAnimationRunning = false;
  }

  void _scheduleDurationClose() {
    _durationTimer?.cancel();
    if (!_isPresented || _closing) {
      return;
    }
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
    if (!_isPresented || _closing) {
      return;
    }
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
    if (!mounted ||
        !_isPresented ||
        marquee == null ||
        _isAnimationRunning ||
        _closing) {
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
      setState(() => _isPresented = false);
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
    );
  }

  Widget _buildIcon(BuildContext context) {
    if (widget.icon != null) {
      return widget.icon!;
    }
    final (icon, color) = switch (widget.status) {
      TMessageStatus.info => (
        TIcons.error_circle_filled,
        context.tTheme.brandNormalColor,
      ),
      TMessageStatus.success => (
        TIcons.check_circle_filled,
        context.tTheme.successNormalColor,
      ),
      TMessageStatus.warning => (
        TIcons.error_circle_filled,
        context.tTheme.warningNormalColor,
      ),
      TMessageStatus.error => (
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
      child: _isPresented ? message : const SizedBox.shrink(),
    );
  }
}
