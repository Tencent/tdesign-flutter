import 'package:flutter/material.dart';
import 'package:tdesign_icons/tdesign_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../text/t_text.dart';
import 't_backtop_theme_data.dart';

/// 返回顶部组件 v1.0
///
/// T2 自绘组件：`GestureDetector` + `Container` 双形态（`circle` / `halfCircle`）。
/// - 监听 [controller] 偏移控制显隐，点击默认 `controller.animateTo(0)` 后触发 [onPressed]。
/// - A 类禁用：[onPressed] 为 `null` 时不可点击。
/// - L4 样式（[shape]、颜色、默认阈值等）→ [TBackTopThemeData]。
class TBackTop extends StatefulWidget {
  const TBackTop({
    Key? key,
    this.controller,
    this.onPressed,
    this.showText = false,
    this.visibilityOffset,
    this.tooltip,
    this.shape,
  }) : super(key: key);

  /// 页面滚动的控制器
  final ScrollController? controller;

  /// 点击回调；`null` 表示禁用（A 类）
  final VoidCallback? onPressed;

  /// 是否展示文案（i18n 走 `context.resource`）
  final bool showText;

  /// 绑定 [controller] 时，偏移 ≥ 阈值才显示；未传时取 Theme `defaultVisibilityOffset`，Theme 也未配时始终可见
  final double? visibilityOffset;

  /// 读屏 / `Tooltip` 提示；未传时可回退资源文案
  final String? tooltip;

  /// 形状（circle / halfCircle）；未传时取 Theme `shape`
  final TBackTopShape? shape;

  @override
  State<TBackTop> createState() => _TBackTopState();
}

class _TBackTopState extends State<TBackTop> {
  bool _isAnimating = false;
  bool _isVisible = true;
  bool _listenerAttached = false;
  double? _lastVisibilityOffset;

  Color _bgColor = Colors.transparent;
  Color _borderColor = Colors.transparent;
  Color _fontColor = Colors.transparent;

  TBackTopThemeData get _themeData =>
      Theme.of(context).extension<TBackTopThemeData>() ??
      const TBackTopThemeData();

  TBackTopShape get _effectiveShape =>
      widget.shape ?? _themeData.shape ?? TBackTopShape.circle;

  double? get _effectiveVisibilityOffset =>
      widget.visibilityOffset ?? _themeData.defaultVisibilityOffset;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initColors();
    _attachScrollListener();
    _refreshVisibility();
  }

  void _attachScrollListener() {
    if (_listenerAttached) {
      return;
    }
    final offset = _effectiveVisibilityOffset;
    if (offset != null && widget.controller != null) {
      widget.controller!.addListener(_handleScroll);
      _listenerAttached = true;
      _lastVisibilityOffset = offset;
      _updateVisibility(offset);
    }
  }

  void _handleScroll() {
    final offset = _effectiveVisibilityOffset;
    if (offset != null && widget.controller != null) {
      _updateVisibility(offset);
    }
  }

  void _updateVisibility(double threshold) {
    final controller = widget.controller;
    if (controller == null || !controller.hasClients) {
      return;
    }
    final shouldShow = controller.offset >= threshold;
    if (shouldShow != _isVisible) {
      setState(() {
        _isVisible = shouldShow;
      });
    }
  }

  @override
  void didUpdateWidget(covariant TBackTop oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller ||
        oldWidget.visibilityOffset != widget.visibilityOffset) {
      // 解除旧监听，重新绑定
      oldWidget.controller?.removeListener(_handleScroll);
      _listenerAttached = false;
      _attachScrollListener();
    }
    _refreshVisibility();
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleScroll);
    super.dispose();
  }

  void _initColors() {
    final colorScheme = Theme.of(context).colorScheme;
    _bgColor = _themeData.backgroundColor ?? colorScheme.primaryContainer;
    _borderColor = _themeData.borderColor ?? colorScheme.primary;
    _fontColor = _themeData.contentColor ?? colorScheme.onPrimaryContainer;
  }

  void _refreshVisibility() {
    final offset = _effectiveVisibilityOffset;
    if (offset != _lastVisibilityOffset) {
      _lastVisibilityOffset = offset;
    }
    if (offset != null) {
      _updateVisibility(offset);
    }
  }

  String _resolveTooltip(BuildContext context) {
    if (widget.tooltip != null) {
      return widget.tooltip!;
    }
    // 使用 resource 中的 back + top 组合文案
    return '${context.resource.back}${context.resource.top}';
  }

  @override
  Widget build(BuildContext context) {
    // 内置可见性控制
    if (_effectiveVisibilityOffset != null && !_isVisible) {
      return const SizedBox.shrink();
    }

    final isDisabled = widget.onPressed == null;

    final child = _effectiveShape == TBackTopShape.circle
        ? _buildCircleWidget(context)
        : _buildHalfCircleWidget(context);

    // 始终包裹 Tooltip（含默认 resource 文案）以支持无障碍
    return Semantics(
      enabled: !isDisabled,
      child: Tooltip(
        message: _resolveTooltip(context),
        child: GestureDetector(
          onTap: isDisabled ? null : _handleTap,
          child: AnimatedOpacity(
            opacity: isDisabled ? 0.4 : 1,
            duration: const Duration(milliseconds: 150),
            child: child,
          ),
        ),
      ),
    );
  }

  Future<void> _handleTap() async {
    // 防抖处理，防止短时间内重复触发
    if (_isAnimating) {
      return;
    }

    final controller = widget.controller;
    if (controller != null && controller.hasClients) {
      _isAnimating = true;
      try {
        await controller.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      } finally {
        if (mounted) {
          _isAnimating = false;
        }
      }
    }

    if (!mounted) {
      return;
    }
    widget.onPressed?.call();
  }

  Widget _buildCircleWidget(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      padding: EdgeInsets.symmetric(vertical: widget.showText ? 6 : 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.tTheme.radiusCircle),
        border: Border.all(color: _borderColor, width: 0.5),
        color: _bgColor,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              TIcons.backtop,
              size: 20,
              color: _fontColor,
            ),
            Visibility(
              visible: widget.showText,
              child: TText(
                context.resource.top,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: context.tTheme.fontMarkExtraSmall?.size ?? 10,
                  color: _fontColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHalfCircleWidget(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 38),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(context.tTheme.radiusCircle),
            bottomLeft: Radius.circular(context.tTheme.radiusCircle),
          ),
          border: Border.all(color: _borderColor, width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              TIcons.backtop,
              size: 22,
              color: _fontColor,
            ),
            const SizedBox(width: 2),
            Visibility(
              visible: widget.showText,
              child: SizedBox(
                height: 32,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TText(
                      context.resource.back,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        height: 1.2,
                        fontSize: context.tTheme.fontMarkExtraSmall?.size ?? 10,
                        color: _fontColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TText(
                      context.resource.top,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        height: 1.2,
                        fontSize: context.tTheme.fontMarkExtraSmall?.size ?? 10,
                        color: _fontColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
