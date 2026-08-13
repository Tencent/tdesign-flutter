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

/// 单实例 Toast 实例管理类
class _ToastInstance {
  final OverlayEntry overlayEntry;
  Timer? timer;
  bool removed = false;

  _ToastInstance({required this.overlayEntry});

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
    _removeEntry();
  }
}

/// 轻提示组件
///
/// 支持文本、图标、加载中等样式。采用单实例替换语义：
/// 每次展示新 Toast 时，旧的 Toast 会被移除。
class TToast {
  /// 当前展示中的 Toast 实例；单实例语义下同一时刻至多存在一个。
  static _ToastInstance? _currentInstance;

  /// 普通文本Toast
  static void showText(
    /// 提示文案；为 null 时只展示自定义内容。
    String? text, {

    /// 用于查找 Overlay 的上下文。
    required BuildContext context,

    /// 自动关闭时长。
    Duration duration = const Duration(milliseconds: 3000),

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
  }) {
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
    );
  }

  /// 带图标的Toast
  static void showIconText(
    /// 提示文案。
    String? text, {

    /// 左侧或上方图标。
    IconData? icon,

    /// 图标与文案排列方向。
    IconTextDirection direction = IconTextDirection.horizontal,

    /// 用于查找 Overlay 的上下文。
    required BuildContext context,

    /// 自动关闭时长。
    Duration duration = const Duration(milliseconds: 3000),

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
  }) {
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
    );
  }

  /// 成功提示Toast
  static void showSuccess(
    /// 提示文案。
    String? text, {

    /// 图标与文案排列方向。
    IconTextDirection direction = IconTextDirection.horizontal,

    /// 用于查找 Overlay 的上下文。
    required BuildContext context,

    /// 自动关闭时长。
    Duration duration = const Duration(milliseconds: 3000),

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
  }) {
    showIconText(
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
    );
  }

  /// 警告Toast
  static void showWarning(
    /// 提示文案。
    String? text, {

    /// 图标与文案排列方向。
    IconTextDirection direction = IconTextDirection.horizontal,

    /// 用于查找 Overlay 的上下文。
    required BuildContext context,

    /// 自动关闭时长。
    Duration duration = const Duration(milliseconds: 3000),

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
  }) {
    showIconText(
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
    );
  }

  /// 失败提示Toast
  static void showFail(
    /// 提示文案。
    String? text, {

    /// 图标与文案排列方向。
    IconTextDirection direction = IconTextDirection.horizontal,

    /// 用于查找 Overlay 的上下文。
    required BuildContext context,

    /// 自动关闭时长。
    Duration duration = const Duration(milliseconds: 3000),

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
  }) {
    showIconText(
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
    );
  }

  /// 带文案的加载Toast
  static void showLoading({
    /// 用于查找 Overlay 的上下文。
    required BuildContext context,

    /// 加载提示文案。
    String? text,

    /// 自动关闭时长。
    Duration duration = const Duration(seconds: 99999999),

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
  }) {
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
    );
  }

  /// 不带文案的加载Toast
  static void showLoadingWithoutText({
    /// 用于查找 Overlay 的上下文。
    required BuildContext context,

    /// 自动关闭时长。
    Duration duration = const Duration(seconds: 99999999),

    /// 是否阻止 Toast 展示期间的背景点击。
    bool? preventTap,

    /// Toast 背景色。
    Color? backgroundColor,

    /// 加载图标尺寸。
    double? iconSize,

    /// 加载图标颜色。
    Color? iconColor,
  }) {
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
    );
  }

  /// 关闭当前展示中的 Toast。
  static void dismiss() {
    _currentInstance?.cancel();
    _currentInstance = null;
  }

  /// 关闭所有 Toast。单实例语义下与 [dismiss] 等价，保留以兼容旧用法。
  static void dismissAll() {
    dismiss();
  }

  static void _showOverlay(
    Widget? widget, {
    required BuildContext context,
    Duration duration = const Duration(milliseconds: 3000),
    bool? preventTap,
  }) {
    final overlayState = Overlay.maybeOf(context);
    if (overlayState == null) {
      debugPrint('warn: TToast requires an Overlay ancestor.');
      return;
    }
    // 单实例替换语义：展示新 Toast 前移除旧的 Toast。
    dismiss();
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

    final instance = _ToastInstance(overlayEntry: overlayEntry);
    _currentInstance = instance;

    // 非"无限"时长时，到期后自动关闭当前 Toast。
    if (duration != const Duration(seconds: 99999999)) {
      instance.timer = Timer(duration, dismiss);
    }
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
