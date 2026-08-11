import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_theme.dart';
import '../../util/auto_size.dart';
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
/// 支持文本、图标、加载中等样式，支持多实例同时显示。
class TToast {
  static final Map<String, _ToastInstance> _toastInstances = {};
  static int _instanceCounter = 0;

  /// 无限时长哨兵值：加载类 Toast 使用，表示"永不自动消失"。
  /// 封装为具名常量，避免魔法数字导致用户传入相近的超长 duration
  /// 时被误判为无限。
  static const Duration infiniteDuration = Duration(seconds: 99999999);

  /// 生成唯一的Toast ID
  static String _generateToastId() {
    return 'toast_${_instanceCounter++}';
  }

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

    /// 是否阻止 Toast 展示期间的背景点击。
    bool? preventTap,

    /// 自定义内容；传入后优先展示。
    Widget? customWidget,

    /// Toast 背景色。
    Color? backgroundColor,

    /// Toast 文案样式。
    TextStyle? textStyle,

    /// 指定实例 ID；不传时自动生成。
    String? toastId,
  }) {
    final id = toastId ?? _generateToastId();
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
      preventTap: preventTap,
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

    /// 是否阻止 Toast 展示期间的背景点击。
    bool? preventTap,

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
    final id = toastId ?? _generateToastId();
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
      preventTap: preventTap,
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

    /// 是否阻止 Toast 展示期间的背景点击。
    bool? preventTap,

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
      preventTap: preventTap,
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

    /// 是否阻止 Toast 展示期间的背景点击。
    bool? preventTap,

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
      preventTap: preventTap,
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

    /// 是否阻止 Toast 展示期间的背景点击。
    bool? preventTap,

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
      preventTap: preventTap,
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

    /// 是否阻止 Toast 展示期间的背景点击。
    bool? preventTap,

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
    final id = toastId ?? _generateToastId();
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
      preventTap: preventTap,
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

    /// 是否阻止 Toast 展示期间的背景点击。
    bool? preventTap,

    /// Toast 背景色。
    Color? backgroundColor,

    /// 加载图标尺寸。
    double? iconSize,

    /// 加载图标颜色。
    Color? iconColor,

    /// 指定实例 ID；不传时自动生成。
    String? toastId,
  }) {
    final id = toastId ?? _generateToastId();
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
      preventTap: preventTap,
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
    Widget? widget, {
    required BuildContext context,
    Duration duration = const Duration(milliseconds: 2000),
    bool? preventTap,
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

    OverlayEntry overlayEntry;
    if (preventTap ?? false) {
      overlayEntry = OverlayEntry(
        builder: (BuildContext context) => captured.wrap(
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            left: 0,
            child: Container(
              color: Colors.transparent,
              child: Align(alignment: Alignment.center, child: widget),
            ),
          ),
        ),
      );
    } else {
      overlayEntry = OverlayEntry(
        builder: (BuildContext context) => captured.wrap(Center(child: widget)),
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
        maxWidth: toastTheme.maxWidth ?? 191,
        maxHeight: 94,
      ),
      child: Container(
        padding:
            toastTheme.padding ?? const EdgeInsets.fromLTRB(24, 14, 24, 14),
        decoration: BoxDecoration(
          color: toastTheme.backgroundColor ?? theme.fontGyColor1,
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
          color: toastTheme.backgroundColor ?? theme.fontGyColor1,
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
    final maxWidth = math.max(110.0, toastTheme.maxWidth ?? 191.0);
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 110,
        minHeight: 110,
        maxWidth: maxWidth,
      ),
      child: Container(
        padding: toastTheme.padding ?? const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: toastTheme.backgroundColor ?? theme.fontGyColor1,
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
          color: toastTheme.backgroundColor ?? theme.fontGyColor1,
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
          BoxConstraints(maxWidth: toastTheme.maxWidth ?? 191.scale),
      child: Container(
        padding:
            toastTheme.padding ?? const EdgeInsets.fromLTRB(24, 16, 24, 16),
        decoration: BoxDecoration(
          color: toastTheme.backgroundColor ?? theme.fontGyColor1,
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
