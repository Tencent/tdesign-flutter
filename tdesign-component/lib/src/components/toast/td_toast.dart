import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';
import '../../util/auto_size.dart';
import '../../util/context_extension.dart';

enum IconTextDirection {
  /// 横向
  horizontal,

  /// 竖向
  vertical
}

/// Toast配置类，支持独立样式定制
class TDToastConfig {
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final double? iconSize;
  final Color? iconColor;
  final Duration duration;
  final bool preventTap;

  const TDToastConfig({
    this.backgroundColor,
    this.textStyle,
    this.iconSize,
    this.iconColor,
    this.duration = const Duration(milliseconds: 3000),
    this.preventTap = false,
  });
}

/// Toast实例管理类
class _ToastInstance {
  final OverlayEntry overlayEntry;
  final Timer? timer;
  final Timer? disposeTimer;
  bool showing = true;

  _ToastInstance({
    required this.overlayEntry,
    this.timer,
    this.disposeTimer,
  });

  void cancel() {
    timer?.cancel();
    disposeTimer?.cancel();
    overlayEntry.remove();
    showing = false;
  }
}

/// 改进的Toast组件，支持多个实例和独立样式
class TDToast {
  static final Map<String, _ToastInstance> _toastInstances = {};
  static int _instanceCounter = 0;

  /// 生成唯一的Toast ID
  static String _generateToastId() {
    return 'toast_${_instanceCounter++}';
  }

  /// 普通文本Toast
  static String showText(
    String? text, {
    required BuildContext context,
    Duration duration = const Duration(milliseconds: 3000),
    int? maxLines,
    BoxConstraints? constraints,
    bool? preventTap,
    Widget? customWidget,
    Color? backgroundColor,
    TextStyle? textStyle,
    String? toastId,
  }) {
    final id = toastId ?? _generateToastId();
    _showOverlay(
      _TDTextToast(
        text: text,
        maxLines: maxLines,
        constraints: constraints,
        customWidget: customWidget,
        config: TDToastConfig(
          backgroundColor: backgroundColor,
          textStyle: textStyle,
          duration: duration,
          preventTap: preventTap ?? false,
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
    String? text, {
    IconData? icon,
    IconTextDirection direction = IconTextDirection.horizontal,
    required BuildContext context,
    Duration duration = const Duration(milliseconds: 3000),
    bool? preventTap,
    Color? backgroundColor,
    int? maxLines,
    TextStyle? textStyle,
    double? iconSize,
    Color? iconColor,
    String? toastId,
  }) {
    final id = toastId ?? _generateToastId();
    _showOverlay(
      _TDIconTextToast(
        text: text,
        iconData: icon,
        iconTextDirection: direction,
        maxLines: maxLines,
        config: TDToastConfig(
          backgroundColor: backgroundColor,
          textStyle: textStyle,
          iconSize: iconSize,
          iconColor: iconColor,
          duration: duration,
          preventTap: preventTap ?? false,
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
    String? text, {
    IconTextDirection direction = IconTextDirection.horizontal,
    required BuildContext context,
    Duration duration = const Duration(milliseconds: 3000),
    bool? preventTap,
    Color? backgroundColor,
    int? maxLines,
    TextStyle? textStyle,
    double? iconSize,
    Color? iconColor,
    String? toastId,
  }) {
    return showIconText(
      text,
      icon: TDIcons.check_circle,
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
    String? text, {
    IconTextDirection direction = IconTextDirection.horizontal,
    required BuildContext context,
    Duration duration = const Duration(milliseconds: 3000),
    bool? preventTap,
    Color? backgroundColor,
    int? maxLines,
    TextStyle? textStyle,
    double? iconSize,
    Color? iconColor,
    String? toastId,
  }) {
    return showIconText(
      text,
      icon: TDIcons.error_circle,
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
    String? text, {
    IconTextDirection direction = IconTextDirection.horizontal,
    required BuildContext context,
    Duration duration = const Duration(milliseconds: 3000),
    bool? preventTap,
    Color? backgroundColor,
    int? maxLines,
    TextStyle? textStyle,
    double? iconSize,
    Color? iconColor,
    String? toastId,
  }) {
    return showIconText(
      text,
      icon: TDIcons.close_circle,
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
    required BuildContext context,
    String? text,
    Duration duration = const Duration(seconds: 99999999),
    bool? preventTap,
    Widget? customWidget,
    Color? backgroundColor,
    TextStyle? textStyle,
    double? iconSize,
    Color? iconColor,
    String? toastId,
  }) {
    final id = toastId ?? _generateToastId();
    _showOverlay(
      _TDToastLoading(
        text: text,
        customWidget: customWidget,
        config: TDToastConfig(
          backgroundColor: backgroundColor,
          textStyle: textStyle,
          iconSize: iconSize,
          iconColor: iconColor,
          duration: duration,
          preventTap: preventTap ?? false,
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
    required BuildContext context,
    Duration duration = const Duration(seconds: 99999999),
    bool? preventTap,
    Color? backgroundColor,
    double? iconSize,
    Color? iconColor,
    String? toastId,
  }) {
    final id = toastId ?? _generateToastId();
    _showOverlay(
      _TDToastLoadingWithoutText(
        config: TDToastConfig(
          backgroundColor: backgroundColor,
          iconSize: iconSize,
          iconColor: iconColor,
          duration: duration,
          preventTap: preventTap ?? false,
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
  static void dismissToast(String toastId) {
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

  /// 关闭加载Toast（向后兼容）
  static void dismissLoading() {
    // 关闭所有类型为loading的Toast
    final loadingIds = _toastInstances.entries
        .where((entry) => entry.key.startsWith('toast_'))
        .map((entry) => entry.key)
        .toList();
    
    for (final id in loadingIds) {
      dismissToast(id);
    }
  }

  static void _showOverlay(
    Widget? widget, {
    required BuildContext context,
    Duration duration = const Duration(milliseconds: 3000),
    bool? preventTap,
    required String toastId,
  }) {
    // 不自动关闭之前的Toast，支持多个Toast同时显示
    final overlayState = Overlay.of(context);
    
    OverlayEntry overlayEntry;
    if (preventTap ?? false) {
      overlayEntry = OverlayEntry(
        builder: (BuildContext context) => Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          left: 0,
          child: Container(
            color: Colors.transparent,
            child: Align(
              alignment: Alignment.center,
              child: widget,
            ),
          ),
        ),
      );
    } else {
      overlayEntry = OverlayEntry(
        builder: (BuildContext context) => Center(
          child: widget,
        ),
      );
    }

    overlayState?.insert(overlayEntry);

    Timer? timer;
    Timer? disposeTimer;

    if (duration != const Duration(seconds: 99999999)) {
      timer = Timer(duration, () {
        final instance = _toastInstances[toastId];
        if (instance != null && instance.showing) {
          instance.showing = false;
          overlayEntry.markNeedsBuild();
          
          disposeTimer = Timer(const Duration(milliseconds: 200), () {
            overlayEntry.remove();
            _toastInstances.remove(toastId);
          });
        }
      });
    }

    _toastInstances[toastId] = _ToastInstance(
      overlayEntry: overlayEntry,
      timer: timer,
      disposeTimer: disposeTimer,
    );
  }
}

class _TDIconTextToast extends StatelessWidget {
  final String? text;
  final IconData? iconData;
  final IconTextDirection iconTextDirection;
  final int? maxLines;
  final TDToastConfig config;

  const _TDIconTextToast({
    this.text,
    this.iconData,
    this.iconTextDirection = IconTextDirection.horizontal,
    this.maxLines,
    required this.config,
  });

  Widget buildHorizontalWidgets(BuildContext context) {
    final theme = TDTheme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 191, maxHeight: 94),
      child: Container(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
          decoration: BoxDecoration(
            color: config.backgroundColor ?? theme.fontGyColor1,
            borderRadius: BorderRadius.circular(theme.radiusDefault),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: config.iconSize ?? 24,
                color: config.iconColor ?? theme.whiteColor1,
              ),
              const SizedBox(width: 8),
              TDText(
                text ?? '',
                font: config.textStyle != null ? null : theme.fontBodyMedium,
                style: config.textStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textColor: config.textStyle?.color ?? theme.whiteColor1,
              )
            ],
          )),
    );
  }

  Widget buildVerticalWidgets(BuildContext context) {
    final theme = TDTheme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 136),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: config.backgroundColor ?? theme.fontGyColor1,
          borderRadius: BorderRadius.circular(theme.radiusDefault),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              size: config.iconSize ?? 32,
              color: config.iconColor ?? theme.whiteColor1,
            ),
            const SizedBox(height: 8),
            TDText(
              text ?? '',
              font: config.textStyle != null ? null : theme.fontBodyMedium,
              style: config.textStyle,
              maxLines: maxLines ?? 1,
              overflow: TextOverflow.ellipsis,
              textColor: config.textStyle?.color ?? theme.whiteColor1,
            )
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

class _TDToastLoading extends StatelessWidget {
  final String? text;
  final Widget? customWidget;
  final TDToastConfig config;

  const _TDToastLoading({
    this.text,
    this.customWidget,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final theme = TDTheme.of(context);
    return Container(
        height: 110,
        width: 110,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: config.backgroundColor ?? theme.fontGyColor1,
          borderRadius: BorderRadius.circular(theme.radiusDefault),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            TDCircleIndicator(
              color: config.iconColor ?? theme.whiteColor1,
              size: config.iconSize ?? 32,
              lineWidth: 4,
            ),
            const SizedBox(height: 8),
            customWidget ??
                TDText(
                  text ?? context.resource.loadingWithPoint,
                  font: config.textStyle != null ? null : theme.fontBodyMedium,
                  style: config.textStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textColor: config.textStyle?.color ?? theme.whiteColor1,
                )
          ],
        ));
  }
}

class _TDToastLoadingWithoutText extends StatelessWidget {
  final TDToastConfig config;

  const _TDToastLoadingWithoutText({
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final theme = TDTheme.of(context);
    return Container(
      width: 80,
      height: 80,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: config.backgroundColor ?? theme.fontGyColor1,
        borderRadius: BorderRadius.circular(theme.radiusDefault),
      ),
      child: TDCircleIndicator(
        color: config.iconColor ?? theme.whiteColor1,
        size: config.iconSize ?? 32,
        lineWidth: 4,
      ),
    );
  }
}

class _TDTextToast extends StatelessWidget {
  final String? text;
  final int? maxLines;
  final BoxConstraints? constraints;
  final Widget? customWidget;
  final TDToastConfig config;

  const _TDTextToast({
    this.text,
    this.maxLines,
    this.constraints,
    this.customWidget,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final theme = TDTheme.of(context);
    return ConstrainedBox(
      constraints: constraints ?? BoxConstraints(maxWidth: 191.scale),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        decoration: BoxDecoration(
          color: config.backgroundColor ?? theme.fontGyColor1,
          borderRadius: BorderRadius.circular(theme.radiusDefault),
        ),
        child: customWidget ??
            TDText(
              text ?? '',
              font: config.textStyle != null ? null : theme.fontBodyMedium,
              style: config.textStyle,
              maxLines: maxLines ?? 3,
              overflow: TextOverflow.ellipsis,
              textColor: config.textStyle?.color ?? theme.whiteColor1,
            ),
      ),
    );
  }
}