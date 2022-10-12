import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../td_export.dart';
import '../loading/td_circle_indicator.dart';

enum IconTextDirection {
  horizontal,       //横向
  vertical          //竖向
}
class TDToast {
  static void showText(String? text, {required BuildContext context,
      Duration duration = TDToast._defaultDisPlayDuration}) {
    _showOverlay(_TDTextToast(text: text,), context: context);
  }

  static void showIconText(String? text, {
                            IconData? icon,
                            IconTextDirection direction = IconTextDirection.horizontal,
                            required BuildContext context,
                            Duration duration = TDToast._defaultDisPlayDuration}) {
    _showOverlay(_TDIconTextToast(text: text, iconData: icon, iconTextDirection: direction,), context: context);
  }

  static void showSuccess(String? text, {
                          IconTextDirection direction = IconTextDirection.horizontal,
                          required BuildContext context,
                          Duration duration = TDToast._defaultDisPlayDuration}) {
    _showOverlay(_TDIconTextToast(text: text, iconData: TDIcons.check_circle, iconTextDirection: direction,), context: context);
  }

  static void showWarning(String? text, {
                          IconTextDirection direction = IconTextDirection.horizontal,
                          required BuildContext context,
                          Duration duration = TDToast._defaultDisPlayDuration}) {
    _showOverlay(_TDIconTextToast(text: text, iconData: TDIcons.error_circle, iconTextDirection: direction,), context: context);
  }

  static void showLoading({required BuildContext context,
                           String? text,
                           Duration duration = TDToast._defaultDisPlayDuration}) {
    _showOverlay(_TDToastLoading(text: text,), context: context, duration: TDToast._infinteDuration);
  }

  static void dismissLoading() {
    _cancel();
  }

  static void _showOverlay(Widget? widget, {required BuildContext context,
    Duration duration = TDToast._defaultDisPlayDuration}) {
    _cancel();
    _showing = true;
    var overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
        builder: (BuildContext context) => Center(
          child: AnimatedOpacity(
            opacity: _showing ? 1.0 : 0.0,
            duration: _showing
                ? const Duration(milliseconds: 100)
                : const Duration(milliseconds: 200),
            child: widget,
          ),
        ));
    if (_overlayEntry != null) {
      overlayState?.insert(_overlayEntry!);
    }
    _startTimer(duration);
  }

  static void _cancel() {
    _timer?.cancel();
    _timer = null;
    _disposeTimer?.cancel();
    _disposeTimer = null;
    _overlayEntry?.remove();
    _overlayEntry = null;
    _showing = false;
  }

  static void _startTimer(Duration duration) {
    _timer?.cancel();
    _disposeTimer?.cancel();
    _timer = Timer(duration, () {
      _showing = false;
      _overlayEntry?.markNeedsBuild();
      _timer = null;
      _disposeTimer = Timer(const Duration(milliseconds: 200), () {
        _overlayEntry?.remove();
        _overlayEntry = null;
        _disposeTimer = null;
      });
    });
  }

  static OverlayEntry? _overlayEntry;
  static bool _showing = false;
  static Timer? _timer;
  static Timer? _disposeTimer;
  static const Duration _defaultDisPlayDuration = Duration(milliseconds: 3000);
  static const Duration _infinteDuration = Duration(seconds: 99999999);
}

class _TDIconTextToast extends StatelessWidget {
  final String? text;
  final IconData? iconData;
  final IconTextDirection iconTextDirection;
  const _TDIconTextToast({this.text, this.iconData, this.iconTextDirection = IconTextDirection.horizontal});

  Widget buildHorizontalWidgets(BuildContext context) {
    return ConstrainedBox(constraints: const BoxConstraints(maxWidth: 191, maxHeight: 94), child: Container(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
        decoration: BoxDecoration(
          color: TDTheme.of(context).fontGyColor2,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Icon(iconData, size: 21, color: TDTheme.of(context).whiteColor1,),
          const SizedBox(width: 10,),
          TDText(text ?? '',
            font: TDTheme.of(context).fontS,
            fontWeight: FontWeight.w400,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textColor: TDTheme.of(context).whiteColor1,)
        ],)
    ),);
  }

  Widget buildVerticalWidgets(BuildContext context) {
    return ConstrainedBox(constraints: const BoxConstraints(maxWidth: 136, maxHeight: 130), child: Container(
        width: 136,
        height: 130,
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        decoration: BoxDecoration(
          color: TDTheme.of(context).fontGyColor2,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
          Icon(iconData, size: 42, color: TDTheme.of(context).whiteColor1,),
          const SizedBox(height: 15,),
          TDText(text ?? '',
            font: TDTheme.of(context).fontS,
            fontWeight: FontWeight.w400,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textColor: TDTheme.of(context).whiteColor1,)
        ],)
    ));
  }

  @override
  Widget build(BuildContext context) {
    return iconTextDirection == IconTextDirection.horizontal ? buildHorizontalWidgets(context) : buildVerticalWidgets(context);
  }
}

class _TDToastLoading extends StatelessWidget {
  final String? text;
  const _TDToastLoading({this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 136,
        height: 130,
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        decoration: BoxDecoration(
          color: TDTheme.of(context).fontGyColor2,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          TDCircleIndicator(color: TDTheme.of(context).whiteColor1, size: 36, lineWidth: 6,),
          const SizedBox(height: 15,),
          TDText(text ?? '加载中...',
            font: TDTheme.of(context).fontS,
            fontWeight: FontWeight.w400,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textColor: TDTheme.of(context).whiteColor1,)
        ],)
    );
  }
}

class _TDTextToast extends StatelessWidget {
  final String? text;
  const _TDTextToast({this.text});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(constraints: const BoxConstraints(maxWidth: 191, maxHeight: 94), child: Container(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
        decoration: BoxDecoration(
          color: TDTheme.of(context).fontGyColor2,
          borderRadius: BorderRadius.circular(4),
        ),
        child: TDText(text ?? '',
          font: TDTheme.of(context).fontS,
          fontWeight: FontWeight.w400,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textColor: TDTheme.of(context).whiteColor1,)
    ),);
  }
}

