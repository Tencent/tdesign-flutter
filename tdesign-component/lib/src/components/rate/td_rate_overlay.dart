import 'package:flutter/widgets.dart';

class TDRateOverlay {
  TDRateOverlay({
    required this.context,
    required this.builder,

  });
  final BuildContext context;
  final WidgetBuilder builder;

  OverlayEntry? _overlayEntry;

  void show() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _overlayEntry = OverlayEntry(
        builder: builder,
      );

      Overlay.of(context).insert(_overlayEntry!);
    });
  }

  void update() {
    _overlayEntry?.markNeedsBuild();
  }

  void hide() {
    _overlayEntry?.remove();
  }
}