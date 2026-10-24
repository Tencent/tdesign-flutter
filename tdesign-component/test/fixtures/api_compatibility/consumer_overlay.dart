import 'package:tdesign_flutter/tdesign_flutter.dart';

// A business implementation imports the public package, not library internals.
class ConsumerOverlay implements TPopupOverlayConfig {
  const ConsumerOverlay({this.color, this.closeOnClick, this.onClick});

  @override
  bool get showOverlay => true;

  @override
  final Color? color;

  @override
  bool get preventTap => true;

  @override
  final bool? closeOnClick;

  @override
  final VoidCallback? onClick;

  @override
  VoidCallback? get onTap => onClick;

  @override
  bool get effectiveCloseOnClick => closeOnClick ?? true;
}
