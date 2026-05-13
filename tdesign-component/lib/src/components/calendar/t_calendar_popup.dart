import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

typedef CalendarBuilder = Widget Function(BuildContext context);

/// 日历的弹窗模式控制器。
///
/// 通过底部滑出弹窗承载 [TCalendar]，提供选中态托管、确认/关闭回调与
/// 全局单例约束。
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

  /// 触发 popup 时的根 context，用于 [Navigator.of] 查找并 push 弹窗路由
  final BuildContext context;

  /// 弹窗顶部距离屏幕顶部的偏移量
  final double? top;

  /// 是否在点击关闭按钮、确认按钮或遮罩层时自动关闭弹窗（默认 true）
  final bool? autoClose;

  /// 自定义确认按钮；为 null 时使用默认主色 [TButton]
  final Widget? confirmBtn;

  /// 是否在构造时立即调用 [show] 打开弹窗（默认 false）
  final bool? visible;

  /// 弹窗关闭后回调
  final VoidCallback? onClose;

  /// 日历构建器，优先级高于 [child]
  final CalendarBuilder? builder;

  /// 日历控件，当 [builder] 为 null 时使用
  final TCalendar? child;

  /// 点击确认按钮时回调，参数为当前选中的日期时间戳列表（毫秒）
  final void Function(List<int> value)? onConfirm;

  static TSlidePopupRoute? _calendarPopup;

  // 校验 close() 调用方与 show() 是同一实例。
  static TCalendarPopup? _owner;

  // 选中态存储，通过 [TCalendarInherited] 暴露给子树。
  final ValueNotifier<List<int>> _selected = ValueNotifier<List<int>>([]);

  bool _closing = false;

  bool get _autoClose => autoClose ?? true;

  /// 当前选中的日期时间戳列表（毫秒）
  List<int> get selected => _selected.value;

  /// 打开日历弹窗。
  ///
  /// 全局同时只允许一个 [TCalendarPopup] 处于显示状态，重复调用将被忽略
  /// （debug 触发 assert，release 通过 [FlutterError.reportError] 上报）。
  void show() {
    assert(_calendarPopup == null,
        '[TCalendarPopup] 已有日历弹窗正在显示，请先调用 close() 关闭后再 show()。');
    if (_calendarPopup != null) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: StateError(
          '[TCalendarPopup] show() 被忽略：已有日历弹窗正在显示，'
          '请先调用 close() 关闭后再 show()。',
        ),
        library: 'tdesign_flutter',
        context: ErrorDescription('TCalendarPopup.show'),
      ));
      return;
    }
    _owner = this;
    _calendarPopup = TSlidePopupRoute(
      isDismissible: false,
      slideTransitionFrom: SlideTransitionFrom.bottom,
      modalTop: top,
      barrierClick: () {
        if (_autoClose) {
          close();
        }
      },
      builder: (context) {
        final built = builder?.call(context);
        final childWidget = built ?? child;
        if (childWidget == null) {
          throw FlutterError(
            '[TCalendarPopup] builder 返回 null 且未提供 child，'
            '请检查 builder 实现或传入非空 child。',
          );
        }
        return TCalendarInherited(
          selected: _selected,
          usePopup: true,
          confirmBtn: confirmBtn,
          onClose: _onClose,
          onConfirm: _onConfirm,
          child: childWidget,
        );
      },
    );
    Navigator.of(context).push(_calendarPopup!).then((_) {
      _deleteRouter();
    });
  }

  void _onClose() {
    if (_closing) {
      return;
    }
    if (_autoClose) {
      close();
    }
  }

  void _onConfirm() {
    if (_closing) {
      return;
    }
    onConfirm?.call(List<int>.from(_selected.value));
    if (_autoClose) {
      close();
    }
  }

  /// 关闭日历弹窗。
  ///
  /// 仅当本实例为当前 popup 的 owner 时才会真正 pop；重复调用会被忽略。
  void close() {
    final route = _calendarPopup;
    if (route == null || _closing) {
      return;
    }
    assert(
      _owner == this,
      '[TCalendarPopup] close() 被非 owner 实例调用，已忽略。'
      '请确保 show() 与 close() 在同一实例上成对调用。',
    );
    if (_owner != this) {
      return;
    }

    _closing = true;
    final navigator = route.navigator;
    if (navigator != null) {
      navigator.pop();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _deleteRouter() {
    _calendarPopup = null;
    _owner = null;
    _closing = false;
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

  /// 选中态的可写引用（仅供 [TCalendar] 内部更新使用）。
  ///
  /// 对外消费方（如自定义 [confirmBtn] 或 [TCalendar.bottom]）请使用
  /// [selectedListenable] 这一只读视图。
  final ValueNotifier<List<int>> selected;

  /// 选中态的只读视图，供下游 widget 监听变化。
  ///
  /// ```dart
  /// final inherited = TCalendarInherited.of(context);
  /// return ValueListenableBuilder<List<int>>(
  ///   valueListenable: inherited!.selectedListenable,
  ///   builder: (ctx, dates, _) => Text('已选 ${dates.length} 天'),
  /// );
  /// ```
  ValueListenable<List<int>> get selectedListenable => selected;

  final bool? usePopup;
  final VoidCallback? onConfirm;
  final Widget? confirmBtn;

  @override
  bool updateShouldNotify(covariant TCalendarInherited oldWidget) {
    // 选中态变化由 [selectedListenable] 通知，本 InheritedWidget 自身无需触发重建。
    return false;
  }

  static TCalendarInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TCalendarInherited>();
  }
}
