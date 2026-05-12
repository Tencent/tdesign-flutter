import 'package:flutter/material.dart';

/// [TTabBarView] 是 TDesign Flutter 对原生 [TabBarView] 的封装。
///
/// 在默认模式下（[autoHeight] = false）完全等价于原生 [TabBarView]，
/// 需要外部显式给它一个高度约束（例如包一层 [SizedBox(height: ...)]
/// 或放进 [Expanded] 内）才能正常显示。
///
/// 当 [autoHeight] 为 true 时，[TTabBarView] 会自动测量当前激活 tab
/// 子 widget 的真实高度并据此撑开自身，无需外部再手动设置固定高度。
/// 切 tab 时高度会以 [animationDuration] 指定的时长平滑过渡到目标
/// 子 widget 的高度；若 [isSlideSwitch] 为 true（可横向滑动切换），
/// 滑动过程中外层高度会在前后两个子 widget 的高度间平滑插值，
/// 避免高度跳变。
///
/// 参考 [issue #519](https://github.com/Tencent/tdesign-flutter/issues/519)。
class TTabBarView extends StatefulWidget {
  /// 子 widget 列表（每一项对应一个 tab 页的内容）
  final List<Widget> children;

  /// Tab 控制器，用于和外部 [TabBar] 联动
  final TabController? controller;

  /// 是否可以左右滑动切换 tab 页
  /// * false（默认）：禁用滑动，仅通过点击 tab 切换
  /// * true：允许滑动
  final bool isSlideSwitch;

  /// 是否开启高度自适应（默认 false，保持向后兼容）
  ///
  /// 开启后 [TTabBarView] 会根据当前激活的子 widget 高度自动撑开，
  /// 外部无需再包 [SizedBox] / [Container] 显式指定高度。
  final bool autoHeight;

  /// 高度自适应模式下的过渡动画时长（默认 300ms）
  ///
  /// 当 [autoHeight] = false 时该参数无效。
  final Duration animationDuration;

  const TTabBarView({
    Key? key,
    required this.children,
    this.controller,
    this.isSlideSwitch = false,
    this.autoHeight = false,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  State<TTabBarView> createState() => _TTabBarViewState();
}

class _TTabBarViewState extends State<TTabBarView> {
  /// 每个子 widget 测量得到的真实高度；下标 = children index
  late List<double> _childHeights;

  /// 当前生效的外层容器高度（驱动 [AnimatedSize]）
  double? _currentHeight;

  TabController? _controller;

  @override
  void initState() {
    super.initState();
    _childHeights = List<double>.filled(widget.children.length, 0);
    _attachController();
  }

  @override
  void didUpdateWidget(covariant TTabBarView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // children 数量变化时需要重建高度表
    if (oldWidget.children.length != widget.children.length) {
      _childHeights = List<double>.filled(widget.children.length, 0);
      _currentHeight = null;
    }

    // controller 变更时需要重新挂载监听
    if (oldWidget.controller != widget.controller) {
      _detachController();
      _attachController();
    }
  }

  @override
  void dispose() {
    _detachController();
    super.dispose();
  }

  void _attachController() {
    _controller = widget.controller;
    _controller?.animation?.addListener(_onControllerTick);
  }

  void _detachController() {
    _controller?.animation?.removeListener(_onControllerTick);
    _controller = null;
  }

  /// 监听 [TabController.animation] —— 每帧根据 animation.value 在
  /// 相邻两个子 widget 高度之间插值，实现滑动中高度平滑过渡。
  void _onControllerTick() {
    if (!widget.autoHeight) {
      return;
    }
    final animation = _controller?.animation;
    if (animation == null) {
      return;
    }
    final interpolated = _interpolateHeight(animation.value);
    if (interpolated != null && interpolated != _currentHeight) {
      setState(() {
        _currentHeight = interpolated;
      });
    }
  }

  /// 根据浮点位置在相邻两个子 widget 高度间线性插值。
  /// 返回 null 表示尚未采集到有效高度。
  double? _interpolateHeight(double position) {
    if (widget.children.isEmpty) {
      return null;
    }
    final lastIndex = widget.children.length - 1;
    final clamped = position.clamp(0.0, lastIndex.toDouble());
    final lower = clamped.floor();
    final upper = clamped.ceil().clamp(0, lastIndex);
    final t = clamped - lower;

    final hLower = _childHeights[lower];
    final hUpper = _childHeights[upper];
    if (hLower <= 0 && hUpper <= 0) {
      return null;
    }
    if (hLower <= 0) {
      return hUpper;
    }
    if (hUpper <= 0) {
      return hLower;
    }
    return hLower + (hUpper - hLower) * t;
  }

  /// 子 widget 上报自己的高度
  void _onChildHeightChanged(int index, double height) {
    if (index < 0 || index >= _childHeights.length) {
      return;
    }
    if ((_childHeights[index] - height).abs() < 0.5) {
      // 阈值过滤，避免浮点误差触发无谓 setState
      return;
    }
    _childHeights[index] = height;

    if (!widget.autoHeight) {
      return;
    }
    // 子高度变化后，按当前 animation 位置重新插值
    final animation = _controller?.animation;
    final position =
        animation?.value ?? _controller?.index.toDouble() ?? 0.0;
    final newHeight = _interpolateHeight(position);
    if (newHeight != null && newHeight != _currentHeight) {
      // 本方法由 [_SizeReportingWidget._notifySize] 在 postFrameCallback
      // 中调用，此时已处于帧提交之外的安全时机，可以直接 setState。
      if (!mounted) {
        return;
      }
      setState(() {
        _currentHeight = newHeight;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final physics = widget.isSlideSwitch
        ? const ScrollPhysics()
        : const NeverScrollableScrollPhysics();

    if (!widget.autoHeight) {
      // 向后兼容路径：与原有行为完全一致——外部必须给高度约束。
      return TabBarView(
        controller: widget.controller,
        physics: physics,
        children: widget.children,
      );
    }

    // 自适应高度路径：
    //
    // 使用"影子测量（shadow measurement）"策略——先用 Offstage 把所有
    // children 在"不受父高度约束"的环境下渲染一次，通过 [_SizeReportingWidget]
    // 各自上报真实高度；随后用 AnimatedSize + SizedBox(_currentHeight)
    // 驱动可见的 TabBarView 平滑过渡到当前激活子 widget 的高度。
    //
    // 之所以需要影子测量：若直接把 _SizeReportingWidget 放进 TabBarView
    // 的 children，子会被外层 SizedBox 的有限高度压缩，上报的"真实高度"
    // 失真（例如一个 200 高的子在 100 的 SizedBox 里会被上报为 100），
    // 导致切换 tab 时高度无法正确扩展。
    final shadowMeasure = Offstage(
      offstage: true,
      child: TickerMode(
        enabled: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < widget.children.length; i++)
              _SizeReportingWidget(
                onSizeChange: (size) => _onChildHeightChanged(i, size.height),
                child: widget.children[i],
              ),
          ],
        ),
      ),
    );

    // 首帧尚未采集到高度前，仅渲染 shadowMeasure 让子完成一次测量。
    // 下一帧 _currentHeight 就绪后会重新 build 并渲染 AnimatedSize。
    if (_currentHeight == null) {
      return shadowMeasure;
    }

    return Stack(
      children: [
        shadowMeasure,
        AnimatedSize(
          duration: widget.animationDuration,
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: _currentHeight,
            child: TabBarView(
              controller: widget.controller,
              physics: physics,
              children: widget.children,
            ),
          ),
        ),
      ],
    );
  }
}

/// 一个轻量级的"尺寸上报"包装器：子 widget 每次 layout 后会通过
/// [onSizeChange] 回调上报自身的实际尺寸，仅在尺寸发生变化时触发。
class _SizeReportingWidget extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onSizeChange;

  const _SizeReportingWidget({
    Key? key,
    required this.child,
    required this.onSizeChange,
  }) : super(key: key);

  @override
  State<_SizeReportingWidget> createState() => _SizeReportingWidgetState();
}

class _SizeReportingWidgetState extends State<_SizeReportingWidget> {
  final GlobalKey _childKey = GlobalKey();
  Size? _oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(_notifySize);
    return Container(
      // 顶部对齐：让子内容从顶部开始占据空间，避免子内容较短时被居中后
      // 在 TabBarView 的内部 PageView 中出现视觉偏移。
      alignment: Alignment.topCenter,
      key: _childKey,
      child: widget.child,
    );
  }

  void _notifySize(Duration _) {
    if (!mounted) {
      return;
    }
    final context = _childKey.currentContext;
    if (context == null) {
      return;
    }
    final newSize = context.size;
    if (newSize == null || newSize == _oldSize) {
      return;
    }
    _oldSize = newSize;
    widget.onSizeChange(newSize);
  }
}
