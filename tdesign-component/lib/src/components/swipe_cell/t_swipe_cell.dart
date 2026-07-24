import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../util/list_ext.dart';
import '../cell/t_cell.dart';
import 't_swipe_cell_action.dart';
import 't_swipe_cell_inherited.dart';
import 't_swipe_cell_panel.dart';
import 't_swipe_cell_theme_data.dart';

export 'package:flutter_slidable/flutter_slidable.dart';

/// 滑动方向
enum TSwipeDirection { right, left }

/// 滑动展开状态变化回调
typedef TSwipeCellChanged = void Function(
  TSwipeDirection direction,
  bool open,
);

/// 滑动单元格组件
class TSwipeCell extends StatefulWidget {
  const TSwipeCell({
    Key? key,
    required this.cell,
    this.enabled = true,
    this.right,
    this.left,
    this.onChanged,
    this.controller,
    this.direction = Axis.horizontal,
    this.slidableKey,
    this.opened = const <bool>[false, false],
    this.groupTag,
    this.closeWhenOpened = false,
    this.closeWhenTapped = false,
    this.dragStartBehavior = DragStartBehavior.start,
  }) : super(key: key);

  /// 单元格 [TCell]
  final Widget cell;

  /// 是否启用滑动（默认 true，false 表示禁用）
  final bool enabled;

  /// 右侧滑动操作项面板
  final TSwipeCellPanel? right;

  /// 左侧滑动操作项面板
  final TSwipeCellPanel? left;

  /// 滑动展开事件
  final TSwipeCellChanged? onChanged;

  /// 自定义控制滑动窗口
  final SlidableController? controller;

  /// 可拖动的方向
  final Axis? direction;

  /// 底层滑动组件的 Key
  final Key? slidableKey;

  /// 初始展开状态，依次表示左侧和右侧面板
  final List<bool> opened;

  /// 互斥滑动组标识
  final Object? groupTag;

  /// 展开时是否关闭同组其他单元格
  final bool closeWhenOpened;

  /// 点击单元格时是否关闭同组单元格
  final bool closeWhenTapped;

  /// 拖动开始行为
  final DragStartBehavior dragStartBehavior;

  /// 获取生效的 Theme Extension
  TSwipeCellThemeData _effectiveTheme(BuildContext context) {
    return (Theme.of(context).extension<TSwipeCellThemeData>() ??
        const TSwipeCellThemeData());
  }

  /// 获取滑动动画时长
  Duration getDuration(BuildContext context) =>
      _effectiveTheme(context).duration ?? const Duration(milliseconds: 200);

  static final Map<Object, List<SlidableController>> _controllers = {};

  static void _pushController(SlidableController controller, Object? tag,
      {bool del = false}) {
    if (tag == null) {
      return;
    }
    if (del) {
      if (_controllers.keys.contains(tag)) {
        _controllers[tag]!.remove(controller); // coverage:ignore-line
      }
    } else {
      if (_controllers.keys.contains(tag)) {
        // coverage:ignore-line
        if (!_controllers[tag]!.contains(controller)) {
          // coverage:ignore-line
          _controllers[tag]!.add(controller); // coverage:ignore-line
        }
      } else {
        _controllers[tag] = [controller]; // coverage:ignore-line
      }
    }
  }

  /// 根据groupTag关闭[TSwipeCell]
  ///
  static void close(
    /// 要关闭的互斥滑动组标识。
    Object? tag, {
    /// 保留不关闭的当前控制器。
    SlidableController? current,
  }) {
    if (tag == null || !_controllers.keys.contains(tag)) {
      return;
    }
    _controllers[tag]!.forEach((element) {
      // coverage:ignore-line
      if (element != current) {
        // coverage:ignore-line
        element.close(); // coverage:ignore-line
      }
    });
  }

  /// 获取上下文最近的[controller]
  static SlidableController? of(
    /// 用于查找最近 [SlidableController] 的上下文。
    BuildContext context,
  ) {
    // coverage:ignore-line
    return Slidable.of(context); // coverage:ignore-line
  }

  @override
  _TSwipeCellState createState() => _TSwipeCellState();
}

class _TSwipeCellState extends State<TSwipeCell> with TickerProviderStateMixin {
  late SlidableController controller;
  bool _ownsController = false;
  final confirmListenable = ValueNotifier<TSwipeCellAction?>(null);
  TSwipeDirection? openDirection;

  /// 缓存生效的 groupTag，避免在 dispose() 中访问 InheritedWidget 祖先
  Object? _groupTag;

  @override
  void initState() {
    super.initState();
    _bindController(widget.controller);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!mounted) {
        return;
      }
      final opened = widget.opened;
      if (opened.isNotEmpty && opened[0]) {
        controller.openStartActionPane(duration: widget.getDuration(context));
      }
      if (opened.length > 1 && opened[1]) {
        controller.openEndActionPane(duration: widget.getDuration(context));
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_groupTag != widget.groupTag) {
      TSwipeCell._pushController(controller, _groupTag, del: true);
      _groupTag = widget.groupTag;
      TSwipeCell._pushController(controller, _groupTag);
    }
  }

  @override // coverage:ignore-line
  void didUpdateWidget(covariant TSwipeCell oldWidget) {
    super.didUpdateWidget(oldWidget); // coverage:ignore-line
    if (oldWidget.controller != widget.controller) {
      // coverage:ignore-line
      TSwipeCell._pushController(controller, _groupTag,
          del: true); // coverage:ignore-line
      _unbindController(); // coverage:ignore-line
      _bindController(widget.controller); // coverage:ignore-line
      TSwipeCell._pushController(
          controller, widget.groupTag); // coverage:ignore-line
    }
    if (oldWidget.groupTag != widget.groupTag) {
      TSwipeCell._pushController(controller, _groupTag, del: true);
      _groupTag = widget.groupTag;
      TSwipeCell._pushController(controller, _groupTag);
    }
  }

  @override
  void dispose() {
    // 使用缓存的 groupTag，避免在 dispose 中访问 InheritedWidget 祖先
    TSwipeCell._pushController(controller, _groupTag, del: true);
    _unbindController();
    confirmListenable.dispose();
    super.dispose();
  }

  void _bindController(SlidableController? externalController) {
    _ownsController = externalController == null;
    controller = externalController ?? SlidableController(this);
    controller.actionPaneType.addListener(_handleActionPanelTypeChanged);
    controller.animation.addStatusListener(_handleAnimationStatusChanged);
  }

  void _unbindController() {
    controller.actionPaneType.removeListener(_handleActionPanelTypeChanged);
    controller.animation.removeStatusListener(_handleAnimationStatusChanged);
    if (_ownsController) {
      controller.dispose();
    }
  }

  void _handleAnimationStatusChanged(AnimationStatus status) {
    confirmListenable.value = null;
  }

  @override
  Widget build(BuildContext context) {
    final rightConfirmLength = widget.right?.confirms?.length ?? 0;
    final leftConfirmLength = widget.left?.confirms?.length ?? 0;

    final slidable = Slidable(
      key: widget.slidableKey ?? UniqueKey(),
      closeOnScroll: false,
      child: widget.cell,
      controller: controller,
      enabled: widget.enabled,
      groupTag: widget.groupTag,
      startActionPane: widget.left?.build(context),
      endActionPane: widget.right?.build(context),
      dragStartBehavior: widget.dragStartBehavior,
      direction: widget.direction ?? Axis.horizontal,
    );
    return TSwipeCellInherited(
      duration: widget.getDuration(context),
      controller: controller,
      cellClick: () {
        // coverage:ignore-line
        if (widget.closeWhenTapped) {
          // coverage:ignore-line
          TSwipeCell.close(widget.groupTag); // coverage:ignore-line
        }
      },
      actionClick: (action) {
        final isLeft = openDirection == TSwipeDirection.left;
        final panel = isLeft ? widget.left! : widget.right!;
        final index = panel.children.indexOf(action);
        final confirm = panel.confirms
            ?.find((element) => element.confirmIndex?.contains(index) == true);
        confirmListenable.value = confirm;
        return confirm != null;
      },
      child: rightConfirmLength > 0 || leftConfirmLength > 0
          ? ValueListenableBuilder(
              valueListenable: confirmListenable,
              builder: (BuildContext context, value, Widget? child) {
                return Stack(
                  children: [
                    slidable,
                    _confirmWidget(),
                  ],
                );
              },
            )
          : slidable,
    );
  }

  Widget _confirmWidget() {
    final isHorizontal = widget.direction == Axis.horizontal;
    final isLeft = openDirection == TSwipeDirection.left;
    final pane = isLeft ? widget.left : widget.right;
    final extentRatio = pane?.extentRatio ?? 0.3;
    return Positioned.fill(
      child: FractionallySizedBox(
        alignment: isHorizontal
            ? (isLeft ? Alignment.centerLeft : Alignment.centerRight)
            : (isLeft ? Alignment.topCenter : Alignment.bottomCenter),
        widthFactor: isHorizontal ? extentRatio : null,
        heightFactor: isHorizontal ? null : extentRatio,
        child: AnimatedSwitcher(
          duration: widget.getDuration(context),
          transitionBuilder: (child, animation) {
            return SlideTransition(
              child: child,
              position: Tween<Offset>(
                begin: isLeft ? const Offset(-1, 0) : const Offset(1, 0),
                end: isLeft ? const Offset(0, 0) : const Offset(0, 0),
              ).animate(animation),
            );
          },
          child: confirmListenable.value ?? const SizedBox.shrink(),
        ),
      ),
    );
  }

  void _handleActionPanelTypeChanged() {
    switch (controller.actionPaneType.value) {
      case ActionPaneType.none:
        final direction = openDirection;
        if (direction != null) {
          widget.onChanged?.call(direction, false);
        }
        openDirection = null;
        break;
      case ActionPaneType.start:
        if (widget.closeWhenOpened) {
          TSwipeCell.close(widget.groupTag, current: controller);
        }
        openDirection = TSwipeDirection.left;
        widget.onChanged?.call(openDirection!, true);
        break;
      case ActionPaneType.end:
        if (widget.closeWhenOpened) {
          TSwipeCell.close(widget.groupTag, current: controller);
        }
        openDirection = TSwipeDirection.right;
        widget.onChanged?.call(openDirection!, true);
        break;
    }
  }
}
