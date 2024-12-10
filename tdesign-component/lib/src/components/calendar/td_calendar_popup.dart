import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

typedef CalendarBuilder = Widget Function(BuildContext context);

enum CalendarTrigger { closeBtn, confirmBtn, overlay }

/// 单元格组件popup模式
class TDCalendarPopup {
  TDCalendarPopup(
    this.context, {
    this.top,
    this.autoClose = true,
    this.confirmBtn,
    this.visible,
    this.onClose,
    this.onConfirm,
    this.builder,
    this.child,
  }) {
    if (builder == null && child == null) {
      throw FlutterError('[TDCalendarPopup] builder or child must be not null');
    }
    if (visible == true) {
      show();
    }
  }

  /// 上下文
  final BuildContext context;

  /// 距离顶部的距离
  final double? top;

  /// 自动关闭；在点击关闭按钮、确认按钮、遮罩层时自动关闭
  final bool? autoClose;

  /// 自定义确认按钮
  final Widget? confirmBtn;

  /// 默认是否显示日历
  final bool? visible;

  /// 关闭时触发
  final VoidCallback? onClose;

  /// 控件构建器，优先级高于[child]
  final CalendarBuilder? builder;

  /// 日历控件
  final TDCalendar? child;

  /// 点击确认按钮时触发
  final void Function(List<int> value)? onConfirm;

  static TDSlidePopupRoute? _calendarPopup;

  /// 当前选中值
  final ValueNotifier<List<int>> _selected = ValueNotifier<List<int>>([]);

  bool get _autoClose => autoClose ?? true;

  /// 当前选中值
  List<int> get selected => _selected.value;

  /// 打开日历
  void show() {
    if (_calendarPopup != null) {
      return;
    }
    _calendarPopup = TDSlidePopupRoute(
      isDismissible: false,
      slideTransitionFrom: SlideTransitionFrom.bottom,
      modalTop: top,
      barrierClick: () {
        if (_autoClose) {
          close();
        }
      },
      builder: (context) {
        final childWidget = builder?.call(context) ?? child;
        return TDCalendarInherited(
          selected: _selected,
          usePopup: true,
          confirmBtn: confirmBtn,
          onClose: _onClose,
          onConfirm: _onConfirm,
          child: childWidget!,
        );
      },
    );
    Navigator.of(context).push(_calendarPopup!).then((_) {
      _deleteRouter();
    });
  }

  void _onClose() {
    if (_autoClose) {
      close();
    }
  }

  void _onConfirm() {
    onConfirm?.call(_selected.value);
    if (_autoClose) {
      close();
    }
  }

  /// 关闭日历
  void close() {
    if (_calendarPopup != null) {
      Navigator.of(context).pop();
      // _deleteRouter();
    }
  }

  void _deleteRouter() {
    _calendarPopup = null;
    onClose?.call();
  }
}

class TDCalendarInherited extends InheritedWidget {
  const TDCalendarInherited({
    required Widget child,
    this.onClose,
    required this.selected,
    this.usePopup = true,
    this.onConfirm,
    this.confirmBtn,
    Key? key,
  }) : super(child: child, key: key);

  final VoidCallback? onClose;
  final ValueNotifier<List<int>> selected;
  final bool? usePopup;
  final VoidCallback? onConfirm;
  final Widget? confirmBtn;

  @override
  bool updateShouldNotify(covariant TDCalendarInherited oldWidget) {
    return false;
  }

  static TDCalendarInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TDCalendarInherited>();
  }
}
