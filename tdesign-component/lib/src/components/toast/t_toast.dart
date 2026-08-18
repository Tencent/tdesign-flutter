import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../../util/t_toolbar_pressable.dart';
import '../icon/t_icon.dart';
import '../loading/t_circle_indicator.dart';
import '../text/t_text.dart';
import 't_toast_theme_data.dart';

/// Toast 文案排列方向
enum IconTextDirection {
  /// 横向
  horizontal,

  /// 竖向
  vertical,
}

/// Toast 展示位置
enum TToastPlacement {
  /// 顶部（距屏幕顶部 25%，水平居中）
  top,

  /// 居中（屏幕正中）
  middle,

  /// 底部（距屏幕底部 25%，水平居中）
  bottom,
}

/// 蒙层行为配置
///
/// 统一收敛 Toast 展示期间遮罩层的各项行为：
/// - [showOverlay]：是否显示可见半透明蒙层（与 [preventTap] 解耦，
///   `true` 时展示半透明黑色蒙层遮住背景）；
/// - [color] / [opacity]：蒙层颜色与透明度，`color` 为 null 时由
///   `Colors.black.withValues(alpha: opacity)` 派生黑色蒙层；
/// - [preventTap]：是否拦截背景点击（与蒙层是否可见解耦，
///   `true` 时展示期间背景不可点击）。
class TOverlayConfig {
  /// 是否显示可见半透明蒙层（默认 false）。
  final bool showOverlay;

  /// 蒙层颜色；为 null 时由 [opacity] 派生黑色蒙层。
  final Color? color;

  /// 蒙层透明度（0~1，默认 0.2）。
  final double opacity;

  /// 是否拦截背景点击（默认 false）。
  final bool preventTap;

  const TOverlayConfig({
    this.showOverlay = false,
    this.color,
    this.opacity = 0.2,
    this.preventTap = false,
  });
}

/// Toast实例管理类
class _ToastInstance {
  final OverlayEntry overlayEntry;
  final Timer? timer;
  Timer? disposeTimer;
  bool showing = true;
  bool removed = false;

  _ToastInstance({required this.overlayEntry, this.timer});

  void _removeEntry() {
    if (removed) {
      return;
    }
    overlayEntry.remove();
    overlayEntry.dispose();
    removed = true;
  }

  void cancel() {
    timer?.cancel();
    disposeTimer?.cancel();
    _removeEntry();
    showing = false;
  }

  void scheduleDispose(String toastId) {
    disposeTimer?.cancel();
    disposeTimer = Timer(const Duration(milliseconds: 200), () {
      _removeEntry();
      TToast._toastInstances.remove(toastId);
    });
  }
}

/// 轻提示组件
///
/// 支持文本、图标、加载中等样式。
///
/// 实例语义：
/// - 未指定 `toastId` 时，所有匿名 Toast 共用同一个内部实例，
///   后一次展示会替换前一次，避免重复点击叠加多个 Toast 导致半透明背景
///   不断加深；
/// - 指定不同 `toastId` 时，可多实例并存；
/// - 指定相同 `toastId` 时，后一次替换前一次。
class TToast {
  static final Map<String, _ToastInstance> _toastInstances = {};

  /// 未指定 toastId 时的固定匿名实例 ID：后一次展示替换前一次，
  /// 避免重复点击叠加多个 Toast（半透明背景叠加会不断变深）。
  static const String _anonymousToastId = 'toast_anonymous';

  /// 无限时长哨兵值：加载类 Toast 使用，表示"永不自动消失"。
  /// 封装为具名常量，避免魔法数字导致用户传入相近的超长 duration
  /// 时被误判为无限。
  static const Duration infiniteDuration = Duration(seconds: 99999999);

  /// 普通文本Toast
  static String showText(
    /// 提示文案；为 null 时只展示自定义内容。
    String? text, {

    /// 用于查找 Overlay 的上下文。
    required BuildContext context,

    /// 自动关闭时长。
    Duration duration = const Duration(milliseconds: 2000),

    /// 文案最大行数。
    int? maxLines,

    /// Toast 内容约束。
    BoxConstraints? constraints,

    /// 蒙层行为配置（可见遮罩、拦截点击等）。
    TOverlayConfig? overlay,

    /// Toast 展示位置。
    TToastPlacement placement = TToastPlacement.middle,

    /// 自定义内容；传入后优先展示。
    Widget? customWidget,

    /// Toast 背景色。
    Color? backgroundColor,

    /// Toast 文案样式。
    TextStyle? textStyle,

    /// 指定实例 ID；不传时自动生成。
    String? toastId,
  }) {
    final id = toastId ?? _anonymousToastId;
    _showOverlay(
      _TTextToast(
        text: text,
        maxLines: maxLines,
        constraints: constraints,
        customWidget: customWidget,
        config: TToastThemeData(
          backgroundColor: backgroundColor,
          textStyle: textStyle,
        ),
      ),
      context: context,
      duration: duration,
      overlay: overlay,
      placement: placement,
      toastId: id,
    );
    return id;
  }

  /// 带图标的Toast
  static String showIconText(
    /// 提示文案。
    String? text, {

    /// 左侧或上方图标。
    IconData? icon,

    /// 图标与文案排列方向。
    IconTextDirection direction = IconTextDirection.horizontal,

    /// 用于查找 Overlay 的上下文。
    required BuildContext context,

    /// 自动关闭时长。
    Duration duration = const Duration(milliseconds: 2000),

    /// 蒙层行为配置（可见遮罩、拦截点击等）。
    TOverlayConfig? overlay,

    /// Toast 展示位置。
    TToastPlacement placement = TToastPlacement.middle,

    /// Toast 背景色。
    Color? backgroundColor,

    /// 文案最大行数。
    int? maxLines,

    /// Toast 文案样式。
    TextStyle? textStyle,

    /// 图标尺寸。
    double? iconSize,

    /// 图标颜色。
    Color? iconColor,

    /// 指定实例 ID；不传时自动生成。
    String? toastId,
  }) {
    final id = toastId ?? _anonymousToastId;
    _showOverlay(
      _TIconTextToast(
        text: text,
        iconData: icon,
        iconTextDirection: direction,
        maxLines: maxLines,
        config: TToastThemeData(
          backgroundColor: backgroundColor,
          textStyle: textStyle,
          iconSize: iconSize,
          iconColor: iconColor,
        ),
      ),
      context: context,
      duration: duration,
      overlay: overlay,
      placement: placement,
      toastId: id,
    );
    return id;
  }

  /// 成功提示Toast
  static String showSuccess(
    /// 提示文案。
    String? text, {

    /// 图标与文案排列方向。
    IconTextDirection direction = IconTextDirection.horizontal,

    /// 用于查找 Overlay 的上下文。
    required BuildContext context,

    /// 自动关闭时长。
    Duration duration = const Duration(milliseconds: 2000),

    /// 蒙层行为配置（可见遮罩、拦截点击等）。
    TOverlayConfig? overlay,

    /// Toast 展示位置。
    TToastPlacement placement = TToastPlacement.middle,

    /// Toast 背景色。
    Color? backgroundColor,

    /// 文案最大行数。
    int? maxLines,

    /// Toast 文案样式。
    TextStyle? textStyle,

    /// 图标尺寸。
    double? iconSize,

    /// 图标颜色。
    Color? iconColor,

    /// 指定实例 ID；不传时自动生成。
    String? toastId,
  }) {
    return showIconText(
      text,
      icon: TIcons.check_circle,
      direction: direction,
      context: context,
      duration: duration,
      overlay: overlay,
      placement: placement,
      backgroundColor: backgroundColor,
      maxLines: maxLines,
      textStyle: textStyle,
      iconSize: iconSize,
      iconColor: iconColor,
      toastId: toastId,
    );
  }

  /// 警告Toast
  static String showWarning(
    /// 提示文案。
    String? text, {

    /// 图标与文案排列方向。
    IconTextDirection direction = IconTextDirection.horizontal,

    /// 用于查找 Overlay 的上下文。
    required BuildContext context,

    /// 自动关闭时长。
    Duration duration = const Duration(milliseconds: 2000),

    /// 蒙层行为配置（可见遮罩、拦截点击等）。
    TOverlayConfig? overlay,

    /// Toast 展示位置。
    TToastPlacement placement = TToastPlacement.middle,

    /// Toast 背景色。
    Color? backgroundColor,

    /// 文案最大行数。
    int? maxLines,

    /// Toast 文案样式。
    TextStyle? textStyle,

    /// 图标尺寸。
    double? iconSize,

    /// 图标颜色。
    Color? iconColor,

    /// 指定实例 ID；不传时自动生成。
    String? toastId,
  }) {
    return showIconText(
      text,
      icon: TIcons.error_circle,
      direction: direction,
      context: context,
      duration: duration,
      overlay: overlay,
      placement: placement,
      backgroundColor: backgroundColor,
      maxLines: maxLines,
      textStyle: textStyle,
      iconSize: iconSize,
      iconColor: iconColor,
      toastId: toastId,
    );
  }

  /// 失败提示Toast
  static String showFail(
    /// 提示文案。
    String? text, {

    /// 图标与文案排列方向。
    IconTextDirection direction = IconTextDirection.horizontal,

    /// 用于查找 Overlay 的上下文。
    required BuildContext context,

    /// 自动关闭时长。
    Duration duration = const Duration(milliseconds: 2000),

    /// 蒙层行为配置（可见遮罩、拦截点击等）。
    TOverlayConfig? overlay,

    /// Toast 展示位置。
    TToastPlacement placement = TToastPlacement.middle,

    /// Toast 背景色。
    Color? backgroundColor,

    /// 文案最大行数。
    int? maxLines,

    /// Toast 文案样式。
    TextStyle? textStyle,

    /// 图标尺寸。
    double? iconSize,

    /// 图标颜色。
    Color? iconColor,

    /// 指定实例 ID；不传时自动生成。
    String? toastId,
  }) {
    return showIconText(
      text,
      icon: TIcons.close_circle,
      direction: direction,
      context: context,
      duration: duration,
      overlay: overlay,
      placement: placement,
      backgroundColor: backgroundColor,
      maxLines: maxLines,
      textStyle: textStyle,
      iconSize: iconSize,
      iconColor: iconColor,
      toastId: toastId,
    );
  }

  /// 带文案的加载Toast
  static String showLoading({
    /// 用于查找 Overlay 的上下文。
    required BuildContext context,

    /// 加载提示文案。
    String? text,

    /// 自动关闭时长。
    Duration duration = TToast.infiniteDuration,

    /// 蒙层行为配置（可见遮罩、拦截点击等）。
    TOverlayConfig? overlay,

    /// Toast 展示位置。
    TToastPlacement placement = TToastPlacement.middle,

    /// 自定义加载内容；传入后优先展示。
    Widget? customWidget,

    /// Toast 背景色。
    Color? backgroundColor,

    /// Toast 文案样式。
    TextStyle? textStyle,

    /// 加载图标尺寸。
    double? iconSize,

    /// 加载图标颜色。
    Color? iconColor,

    /// 指定实例 ID；不传时自动生成。
    String? toastId,
  }) {
    final id = toastId ?? _anonymousToastId;
    _showOverlay(
      _TToastLoading(
        text: text,
        customWidget: customWidget,
        config: TToastThemeData(
          backgroundColor: backgroundColor,
          textStyle: textStyle,
          iconSize: iconSize,
          iconColor: iconColor,
        ),
      ),
      context: context,
      duration: duration,
      overlay: overlay,
      placement: placement,
      toastId: id,
    );
    return id;
  }

  /// 不带文案的加载Toast
  static String showLoadingWithoutText({
    /// 用于查找 Overlay 的上下文。
    required BuildContext context,

    /// 自动关闭时长。
    Duration duration = TToast.infiniteDuration,

    /// 蒙层行为配置（可见遮罩、拦截点击等）。
    TOverlayConfig? overlay,

    /// Toast 展示位置。
    TToastPlacement placement = TToastPlacement.middle,

    /// Toast 背景色。
    Color? backgroundColor,

    /// 加载图标尺寸。
    double? iconSize,

    /// 加载图标颜色。
    Color? iconColor,

    /// 指定实例 ID；不传时自动生成。
    String? toastId,
  }) {
    final id = toastId ?? _anonymousToastId;
    _showOverlay(
      _TToastLoadingWithoutText(
        config: TToastThemeData(
          backgroundColor: backgroundColor,
          iconSize: iconSize,
          iconColor: iconColor,
        ),
      ),
      context: context,
      duration: duration,
      overlay: overlay,
      placement: placement,
      toastId: id,
    );
    return id;
  }

  /// 关闭指定的Toast
  static void dismissToast(
    /// 要关闭的 Toast 实例 ID。
    String toastId,
  ) {
    final instance = _toastInstances[toastId];
    if (instance != null) {
      instance.cancel();
      _toastInstances.remove(toastId);
    }
  }

  /// 关闭所有Toast
  static void dismissAll() {
    for (final instance in _toastInstances.values) {
      instance.cancel();
    }
    _toastInstances.clear();
  }

  static void _showOverlay(
    Widget widget, {
    required BuildContext context,
    Duration duration = const Duration(milliseconds: 2000),
    TOverlayConfig? overlay,
    TToastPlacement placement = TToastPlacement.middle,
    required String toastId,
  }) {
    // 不同 ID 的 Toast 可以并存；同 ID 采用替换语义。
    _toastInstances.remove(toastId)?.cancel();
    final overlayState = Overlay.maybeOf(context);
    if (overlayState == null) {
      debugPrint('warn: TToast requires an Overlay ancestor.');
      return;
    }
    final captured = InheritedTheme.capture(
      from: context,
      to: overlayState.context,
    );

    final cfg = overlay ?? const TOverlayConfig();
    // 拦截点击统一由 TOverlayConfig.preventTap 决定（不兼容收敛版）。
    final finalPreventTap = cfg.preventTap;
    final showMask = cfg.showOverlay;
    final maskColor = showMask
        ? (cfg.color ?? Colors.black.withValues(alpha: cfg.opacity))
        : Colors.transparent;
    // 采用与小程序 / mobile-vue 一致的垂直百分比偏移（水平恒居中）：
    // top 距顶 25%、middle 正中 50%、bottom 距底 25%。
    // 百分比定位天然避让安全区，无需再叠加 SafeArea。
    final alignment = switch (placement) {
      TToastPlacement.top => const FractionalOffset(0.5, 0.25),
      TToastPlacement.middle => const FractionalOffset(0.5, 0.5),
      TToastPlacement.bottom => const FractionalOffset(0.5, 0.75),
    };

    OverlayEntry overlayEntry;
    if (finalPreventTap || showMask) {
      overlayEntry = OverlayEntry(
        builder: (BuildContext context) => captured.wrap(
          Stack(
            children: [
              Positioned.fill(child: Container(color: maskColor)),
              Align(
                alignment: alignment,
                child: widget,
              ),
            ],
          ),
        ),
      );
    } else {
      overlayEntry = OverlayEntry(
        builder: (BuildContext context) => captured.wrap(
          Align(
            alignment: alignment,
            child: widget,
          ),
        ),
      );
    }

    overlayState.insert(overlayEntry);

    Timer? timer;

    if (duration != TToast.infiniteDuration) {
      timer = Timer(duration, () {
        final instance = _toastInstances[toastId];
        if (instance != null && instance.showing) {
          instance.showing = false;
          overlayEntry.markNeedsBuild();
          instance.scheduleDispose(toastId);
        }
      });
    }

    _toastInstances[toastId] = _ToastInstance(
      overlayEntry: overlayEntry,
      timer: timer,
    );
  }
}

class _TIconTextToast extends StatelessWidget {
  final String? text;
  final IconData? iconData;
  final IconTextDirection iconTextDirection;
  final int? maxLines;
  final TToastThemeData config;

  const _TIconTextToast({
    this.text,
    this.iconData,
    this.iconTextDirection = IconTextDirection.horizontal,
    this.maxLines,
    required this.config,
  });

  Widget buildHorizontalWidgets(BuildContext context) {
    final theme = context.tTheme;
    final toastTheme =
        (Theme.of(context).extension<TToastThemeData>() ??
                const TToastThemeData())
            .merge(config);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: toastTheme.maxWidth ?? 185,
        maxHeight: 94,
      ),
      child: Container(
        padding:
            toastTheme.padding ?? const EdgeInsets.fromLTRB(22, 14, 22, 14),
        decoration: BoxDecoration(
          color: toastTheme.backgroundColor ?? theme.fontGyColor2,
          borderRadius: BorderRadius.circular(
            toastTheme.borderRadius ?? theme.radiusDefault,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: toastTheme.iconSize ?? 24,
              color: toastTheme.iconColor ?? theme.textColorAnti,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: TText(
                text ?? '',
                font: toastTheme.textStyle != null
                    ? null
                    : theme.fontBodyMedium,
                style: toastTheme.textStyle,
                maxLines: maxLines ?? 1,
                overflow: TextOverflow.ellipsis,
                textColor: toastTheme.textStyle?.color ?? theme.textColorAnti,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildVerticalWidgets(BuildContext context) {
    final theme = context.tTheme;
    final toastTheme =
        (Theme.of(context).extension<TToastThemeData>() ??
                const TToastThemeData())
            .merge(config);
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: toastTheme.maxWidth ?? 136),
      child: Container(
        padding: toastTheme.padding ?? const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: toastTheme.backgroundColor ?? theme.fontGyColor2,
          borderRadius: BorderRadius.circular(
            toastTheme.borderRadius ?? theme.radiusDefault,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              size: toastTheme.iconSize ?? 32,
              color: toastTheme.iconColor ?? theme.textColorAnti,
            ),
            const SizedBox(height: 8),
            TText(
              text ?? '',
              font: toastTheme.textStyle != null ? null : theme.fontBodyMedium,
              style: toastTheme.textStyle,
              maxLines: maxLines ?? 1,
              overflow: TextOverflow.ellipsis,
              textColor: toastTheme.textStyle?.color ?? theme.textColorAnti,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return iconTextDirection == IconTextDirection.horizontal
        ? buildHorizontalWidgets(context)
        : buildVerticalWidgets(context);
  }
}

class _TToastLoading extends StatelessWidget {
  final String? text;
  final Widget? customWidget;
  final TToastThemeData config;

  const _TToastLoading({this.text, this.customWidget, required this.config});

  @override
  Widget build(BuildContext context) {
    final theme = context.tTheme;
    final toastTheme =
        (Theme.of(context).extension<TToastThemeData>() ??
                const TToastThemeData())
            .merge(config);
    final maxWidth = math.max(102.0, toastTheme.maxWidth ?? 185.0);
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 102,
        minHeight: 102,
        maxWidth: maxWidth,
      ),
      child: Container(
        padding:
            toastTheme.padding ?? const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: toastTheme.backgroundColor ?? theme.fontGyColor2,
          borderRadius: BorderRadius.circular(
            toastTheme.borderRadius ?? theme.radiusDefault,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TCircleIndicator(
              color: toastTheme.iconColor ?? theme.textColorAnti,
              size: toastTheme.iconSize ?? 32,
              lineWidth: 4,
            ),
            const SizedBox(height: 8),
            customWidget ??
                TText(
                  text ?? context.resource.loadingWithPoint,
                  font: toastTheme.textStyle != null
                      ? null
                      : theme.fontBodyMedium,
                  style: toastTheme.textStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textColor: toastTheme.textStyle?.color ?? theme.textColorAnti,
                ),
          ],
        ),
      ),
    );
  }
}

class _TToastLoadingWithoutText extends StatelessWidget {
  final TToastThemeData config;

  const _TToastLoadingWithoutText({required this.config});

  @override
  Widget build(BuildContext context) {
    final theme = context.tTheme;
    final toastTheme =
        (Theme.of(context).extension<TToastThemeData>() ??
                const TToastThemeData())
            .merge(config);
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 80, minHeight: 80),
      child: Container(
        padding: toastTheme.padding ?? const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: toastTheme.backgroundColor ?? theme.fontGyColor2,
          borderRadius: BorderRadius.circular(
            toastTheme.borderRadius ?? theme.radiusDefault,
          ),
        ),
        child: TCircleIndicator(
          color: toastTheme.iconColor ?? theme.textColorAnti,
          size: toastTheme.iconSize ?? 32,
          lineWidth: 4,
        ),
      ),
    );
  }
}

class _TTextToast extends StatelessWidget {
  final String? text;
  final int? maxLines;
  final BoxConstraints? constraints;
  final Widget? customWidget;
  final TToastThemeData config;

  const _TTextToast({
    this.text,
    this.maxLines,
    this.constraints,
    this.customWidget,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.tTheme;
    final toastTheme =
        (Theme.of(context).extension<TToastThemeData>() ??
                const TToastThemeData())
            .merge(config);
    return ConstrainedBox(
      constraints:
          constraints ??
          BoxConstraints(maxWidth: toastTheme.maxWidth ?? 185),
      child: Container(
        padding:
            toastTheme.padding ?? const EdgeInsets.fromLTRB(22, 14, 22, 14),
        decoration: BoxDecoration(
          color: toastTheme.backgroundColor ?? theme.fontGyColor2,
          borderRadius: BorderRadius.circular(
            toastTheme.borderRadius ?? theme.radiusDefault,
          ),
        ),
        child:
            customWidget ??
            TText(
              text ?? '',
              font: toastTheme.textStyle != null ? null : theme.fontBodyMedium,
              style: toastTheme.textStyle,
              maxLines: maxLines ?? 3,
              overflow: TextOverflow.ellipsis,
              textColor: toastTheme.textStyle?.color ?? theme.textColorAnti,
            ),
      ),
    );
  }
}
