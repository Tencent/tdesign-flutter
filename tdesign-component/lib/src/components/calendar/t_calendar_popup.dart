import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

typedef CalendarBuilder = Widget Function(BuildContext context);

enum CalendarTrigger { closeBtn, confirmBtn, overlay }

/// 单元格组件popup模式
class TCalendarPopup {
  TCalendarPopup(
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
      throw FlutterError('[TCalendarPopup] builder or child must be not null');
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
  final TCalendar? child;

  /// 点击确认按钮时触发
  final void Function(List<int> value)? onConfirm;

  static TPopupHandle? _calendarHandle;

  /// 当前选中值
  final ValueNotifier<List<int>> _selected = ValueNotifier<List<int>>([]);

  bool get _autoClose => autoClose ?? true;

  /// 当前选中值
  List<int> get selected => _selected.value;

  /// 打开日历
  void show() {
    if (_calendarHandle?.isShowing == true) {
      return;
    }
    final childWidget = builder?.call(context) ?? child;
    final topInset = top?.clamp(0.0, double.infinity).toDouble();
    final maxHeight = topInset == null
        ? null
        : (MediaQuery.sizeOf(context).height - topInset)
            .clamp(0.0, double.infinity)
            .toDouble();
    _calendarHandle = TPopup.show(
      context,
      options: TPopupOptions.bottom(
        cancelBuilder: null,
        confirmBuilder: null,
        closeOnOverlayClick: false,
        onOverlayClick: () {
          if (_autoClose) {
            close();
          }
        },
        onClosed: _deleteRouter,
        child: TCalendarInherited(
          selected: _selected,
          usePopup: true,
          confirmBtn: confirmBtn,
          onClose: _onClose,
          onConfirm: _onConfirm,
          child: maxHeight == null
              ? childWidget!
              : ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxHeight),
                  child: childWidget!,
                ),
        ),
      ),
    );
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
    _calendarHandle?.close();
  }

  void _deleteRouter() {
    _calendarHandle = null;
    onClose?.call();
  }
}

class TCalendarInherited extends InheritedWidget {
  const TCalendarInherited({
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
  bool updateShouldNotify(covariant TCalendarInherited oldWidget) {
    return false;
  }

  static TCalendarInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TCalendarInherited>();
  }
}
