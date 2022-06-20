import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

class TDToast {
  static showText(BuildContext context, String text,
      {Duration duration = TDToast._defaultDisPlayDuration}) {
    _cancel();
    _showing = true;
    OverlayState? overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
        builder: (BuildContext context) => Center(
              child: AnimatedOpacity(
                opacity: _showing ? 1.0 : 0.0,
                duration: _showing
                    ? const Duration(milliseconds: 100)
                    : const Duration(milliseconds: 200),
                child: _TDTextToast(
                  text: text,
                ),
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
}

class _TDTextToast extends StatefulWidget {
  final String? text;

  const _TDTextToast({Key? key, this.text}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDTextToastState();
}

class _TDTextToastState extends State<_TDTextToast> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TDTheme.of(context).fontGyColor2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        widget.text ?? '',
        maxLines: 3,
        style: const TextStyle(
            fontSize: 14,
            decoration: TextDecoration.none,
            fontWeight: FontWeight.w400,
            color: Colors.white),
      ),
      padding: const EdgeInsets.fromLTRB(11, 16, 11, 16),
    );
  }
}
