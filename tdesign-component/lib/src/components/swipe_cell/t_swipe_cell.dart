import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../util/list_ext.dart';
import 't_swipe_cell_action.dart';
import 't_swipe_cell_inherited.dart';
import 't_swipe_cell_panel.dart';
import 't_swipe_cell_theme_data.dart';

export 'package:flutter_slidable/flutter_slidable.dart';

/// 操作面板所在侧。
enum TSwipeCellSide { start, end }

/// 滑动展开状态变化回调
typedef TSwipeCellChanged = void Function(
  TSwipeCellSide side,
  bool isOpen,
);

/// 滑动单元格组件
class TSwipeCell extends StatefulWidget {
  const TSwipeCell({
    Key? key,
    required this.child,
    this.enabled = true,
    this.start,
    this.end,
    this.onOpenChanged,
    this.controller,
    this.direction = Axis.horizontal,
    this.initialOpenSide,
    this.groupTag,
    this.closeWhenOpened = false,
    this.closeOnScroll = true,
    this.closeOnTapOutside,
    this.dragStartBehavior = DragStartBehavior.start,
  }) : super(key: key);

  /// 要增强为可滑动单元格的内容。
  final Widget child;

  /// 是否启用滑动（默认 true，false 表示禁用）
  final bool enabled;

  /// 起始侧滑动操作项面板。
  final TSwipeCellPanel? start;

  /// 结束侧滑动操作项面板。
  final TSwipeCellPanel? end;

  /// 滑动展开事件
  final TSwipeCellChanged? onOpenChanged;

  /// 自定义控制滑动窗口
  final SlidableController? controller;

  /// 可拖动的方向
  final Axis direction;

  /// 初始展开的面板；为空时保持关闭。
  final TSwipeCellSide? initialOpenSide;

  /// 互斥滑动组标识
  ///
  /// 相同 [groupTag] 的 [TSwipeCell] 会互相影响（配合 [closeWhenOpened] 实现互斥关闭）。
  /// **注意：需全局唯一**。不同类型 / 场景的互斥组请使用不同的标识，
  /// 避免传入 `==` 相同的值（如相同的字符串）导致意外串组。
  final Object? groupTag;

  /// 展开时是否关闭同组其他单元格
  final bool closeWhenOpened;

  /// 祖先滚动容器开始滚动时是否关闭已展开的操作区。
  ///
  /// 注意：当配合 [initialOpenSide] 初始展开面板时，若本值为 true，
  /// 面板会在首次滚动发生时即被关闭（语义偏"粘滞"），请按需调整。
  final bool closeOnScroll;

  /// 面板展开后，点击本格内容或单元格外部区域时是否自动关闭面板。
  ///
  /// 默认与官方行为对齐（`null` 视为 `true`）：面板展开后点击空白处自动收起。
  /// 点击操作项按钮不受此参数影响（由操作项自身的 `onPressed` / `autoClose` 处理）。
  final bool? closeOnTapOutside;

  /// 拖动开始行为
  final DragStartBehavior dragStartBehavior;

  /// 获取生效的 Theme Extension
  TSwipeCellThemeData _effectiveTheme(BuildContext context) {
    return (Theme.of(context).extension<TSwipeCellThemeData>() ??
        const TSwipeCellThemeData());
  }

  /// 获取滑动动画时长
  Duration getDuration(BuildContext context) =>
      _effectiveTheme(context).duration ?? const Duration(milliseconds: 600);

  static final Map<Object, List<SlidableController>> _controllers = {};

  static void _pushController(SlidableController controller, Object? tag,
      {bool del = false}) {
    if (tag == null) {
      return;
    }
    if (del) {
      final controllers = _controllers[tag];
      if (controllers != null) {
        controllers.remove(controller); // coverage:ignore-line
        if (controllers.isEmpty) {
          _controllers.remove(tag); // coverage:ignore-line
        }
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
  TSwipeCellSide? openSide;

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
      switch (widget.initialOpenSide) {
        case TSwipeCellSide.start:
          controller.openStartActionPane(duration: widget.getDuration(context));
        case TSwipeCellSide.end:
          controller.openEndActionPane(duration: widget.getDuration(context));
        case null:
          break;
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
    _unregisterTapOutsideListener();
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

  bool get _shouldCloseOnTapOutside => widget.closeOnTapOutside != false;

  void _registerTapOutsideListener() {
    if (_shouldCloseOnTapOutside) {
      WidgetsBinding.instance.pointerRouter.addRoute(_handlePointerDown);
    }
  }

  void _unregisterTapOutsideListener() {
    WidgetsBinding.instance.pointerRouter.removeRoute(_handlePointerDown);
  }

  /// 点击本格外部区域时关闭已展开面板
  void _handlePointerDown(PointerDownEvent event) {
    if (!_shouldCloseOnTapOutside) {
      return;
    }
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) {
      return;
    }
    final local = box.globalToLocal(event.position);
    final size = box.size;
    final inside = local.dx >= 0 &&
        local.dy >= 0 &&
        local.dx <= size.width &&
        local.dy <= size.height;
    if (!inside) {
      controller.close(duration: widget.getDuration(context));
    }
  }

  /// 点击本格内容（非操作项按钮）时关闭已展开面板
  void _handleChildTapDown(PointerDownEvent event) {
    if (!_shouldCloseOnTapOutside) {
      return;
    }
    controller.close(duration: widget.getDuration(context));
  }

  @override
  Widget build(BuildContext context) {
    final endConfirmLength = widget.end?.confirms?.length ?? 0;
    final startConfirmLength = widget.start?.confirms?.length ?? 0;

    final slidable = Slidable(
      closeOnScroll: widget.closeOnScroll,
      child: _shouldCloseOnTapOutside
          ? Listener(
              onPointerDown: _handleChildTapDown,
              behavior: HitTestBehavior.translucent,
              child: widget.child,
            )
          : widget.child,
      controller: controller,
      enabled: widget.enabled,
      groupTag: widget.groupTag,
      startActionPane: widget.start?.build(context),
      endActionPane: widget.end?.build(context),
      dragStartBehavior: widget.dragStartBehavior,
      direction: widget.direction,
    );
    return TSwipeCellInherited(
      duration: widget.getDuration(context),
      controller: controller,
      actionClick: (action) {
        final panel =
            openSide == TSwipeCellSide.start ? widget.start! : widget.end!;
        // 优先按稳定 id 匹配；未配置 id 时回退到实例引用匹配（indexOf）。
        final index = action.id != null
            ? panel.children.indexWhere((e) => e.id == action.id)
            : panel.children.indexOf(action);
        final confirm = panel.confirms
            ?.find((element) => element.confirmIndex?.contains(index) == true);
        confirmListenable.value = confirm;
        return confirm != null;
      },
      child: endConfirmLength > 0 || startConfirmLength > 0
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
    final isStart = openSide == TSwipeCellSide.start;
    final pane = isStart ? widget.start : widget.end;
    final extentRatio = pane?.extentRatio ?? 0.3;
    return Positioned.fill(
      child: FractionallySizedBox(
        alignment: isHorizontal
            ? (isStart ? Alignment.centerLeft : Alignment.centerRight)
            : (isStart ? Alignment.topCenter : Alignment.bottomCenter),
        widthFactor: isHorizontal ? extentRatio : null,
        heightFactor: isHorizontal ? null : extentRatio,
        child: AnimatedSwitcher(
          duration: widget.getDuration(context),
          transitionBuilder: (child, animation) {
            return SlideTransition(
              child: child,
              position: Tween<Offset>(
                begin: isStart ? const Offset(-1, 0) : const Offset(1, 0),
                end: const Offset(0, 0),
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
        final side = openSide;
        if (side != null) {
          widget.onOpenChanged?.call(side, false);
        }
        openSide = null;
        _unregisterTapOutsideListener();
        break;
      case ActionPaneType.start:
        if (widget.closeWhenOpened) {
          TSwipeCell.close(widget.groupTag, current: controller);
        }
        openSide = TSwipeCellSide.start;
        widget.onOpenChanged?.call(openSide!, true);
        _registerTapOutsideListener();
        break;
      case ActionPaneType.end:
        if (widget.closeWhenOpened) {
          TSwipeCell.close(widget.groupTag, current: controller);
        }
        openSide = TSwipeCellSide.end;
        widget.onOpenChanged?.call(openSide!, true);
        _registerTapOutsideListener();
        break;
    }
  }
}
