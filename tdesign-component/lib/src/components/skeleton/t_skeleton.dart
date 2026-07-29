import 'dart:async';

import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import 't_skeleton_layout.dart';
import 't_skeleton_theme_data.dart';

/// 骨架屏动画。
enum TSkeletonAnimation {
  /// 高亮渐变扫过骨架块。
  gradient,

  /// 骨架块透明度闪烁。
  flashed,
}

/// 骨架屏预设形态。
enum TSkeletonVariant {
  /// 头像占位。
  avatar,

  /// 图片占位。
  image,

  /// 双行文本占位。
  text,

  /// 四行段落占位。
  paragraph,
}

/// 在内容加载前展示页面结构的占位组件。
class TSkeleton extends StatefulWidget {
  const TSkeleton({
    super.key,
    this.variant = TSkeletonVariant.text,
    this.animation,
    this.delay = Duration.zero,
  }) : layout = null;

  /// 使用自定义行列布局创建骨架屏。
  const TSkeleton.custom({
    super.key,
    required TSkeletonLayout layout,
    this.animation,
    this.delay = Duration.zero,
  })  : layout = layout,
        variant = null;

  /// 预设形态；自定义布局时为空。
  final TSkeletonVariant? variant;

  /// 自定义布局；预设形态时为空。
  final TSkeletonLayout? layout;

  /// 动画效果；为 null 时保持静态。
  final TSkeletonAnimation? animation;

  /// 骨架屏的延迟显示时间，用于避免短请求产生闪烁。
  final Duration delay;

  @override
  State<TSkeleton> createState() => _TSkeletonState();
}

class _TSkeletonState extends State<TSkeleton> with TickerProviderStateMixin {
  static const _flashedOpacity = .3;

  AnimationController? _controller;
  Animation<double>? _animation;
  Timer? _delayTimer;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _configureAnimation();
    _configureDelay();
  }

  @override
  void didUpdateWidget(covariant TSkeleton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animation != widget.animation) {
      _configureAnimation();
    }
    if (oldWidget.delay != widget.delay) {
      _configureDelay();
    }
  }

  void _configureAnimation() {
    _controller?.dispose();
    _controller = null;
    _animation = null;

    final duration = switch (widget.animation) {
      TSkeletonAnimation.gradient => const Duration(milliseconds: 1500),
      TSkeletonAnimation.flashed => const Duration(seconds: 1),
      null => null,
    };
    if (duration == null) {
      return;
    }

    _controller = AnimationController(duration: duration, vsync: this)
      ..addListener(_handleAnimationTick)
      ..repeat(reverse: widget.animation == TSkeletonAnimation.flashed);
    _animation = switch (widget.animation!) {
      TSkeletonAnimation.gradient =>
        Tween<double>(begin: -1, end: 1).animate(_controller!),
      TSkeletonAnimation.flashed =>
        Tween<double>(begin: 1, end: _flashedOpacity).animate(_controller!),
    };
  }

  void _configureDelay() {
    _delayTimer?.cancel();
    _isVisible = widget.delay == Duration.zero;
    if (_isVisible) {
      return;
    }
    _delayTimer = Timer(widget.delay, () {
      if (mounted) {
        setState(() => _isVisible = true);
      }
    });
  }

  void _handleAnimationTick() {
    if (mounted && _isVisible) {
      setState(() {});
    }
  }

  TSkeletonLayout get _effectiveLayout =>
      widget.layout ??
      switch (widget.variant!) {
        TSkeletonVariant.avatar => const TSkeletonLayout(
            rows: [
              [TSkeletonBlock.circle()]
            ],
          ),
        TSkeletonVariant.image => const TSkeletonLayout(
            rows: [
              [TSkeletonBlock.rectangle(width: 72, height: 72, flex: null)],
            ],
          ),
        TSkeletonVariant.text => const TSkeletonLayout(
            rows: [
              [
                TSkeletonBlock.line(flex: 24),
                TSkeletonBlock.spacer(width: 16),
                TSkeletonBlock.line(flex: 76),
              ],
              [TSkeletonBlock.line()],
            ],
          ),
        TSkeletonVariant.paragraph => const TSkeletonLayout(
            rows: [
              [TSkeletonBlock.line()],
              [TSkeletonBlock.line()],
              [TSkeletonBlock.line()],
              [TSkeletonBlock.line(flex: 55), TSkeletonBlock.spacer(flex: 45)],
            ],
          ),
      };

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      return const SizedBox.shrink();
    }

    final layout = _effectiveLayout;
    final theme = Theme.of(context).extension<TSkeletonThemeData>();
    final rowSpacing =
        layout.rowSpacing ?? theme?.rowSpacing ?? context.tTheme.spacer16;
    final rows = <Widget>[];
    for (final row in layout.rows) {
      rows.add(
        row.length == 1
            ? _buildBlock(context, row.single, theme, allowFlex: false)
            : Row(
                children: row
                    .map((block) => _buildBlock(context, block, theme))
                    .toList(),
              ),
      );
    }

    return ExcludeSemantics(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < rows.length; index++) ...[
            rows[index],
            if (index < rows.length - 1 && rowSpacing > 0)
              SizedBox(height: rowSpacing),
          ],
        ],
      ),
    );
  }

  Widget _buildBlock(
    BuildContext context,
    TSkeletonBlock block,
    TSkeletonThemeData? theme, {
    bool allowFlex = true,
  }) {
    final radius = block.style.borderRadius ??
        switch (block.style.shape) {
          TSkeletonBlockShape.rounded =>
            theme?.borderRadius ?? context.tTheme.radiusSmall,
          TSkeletonBlockShape.circle => (block.height ?? block.width ?? 0) / 2,
          TSkeletonBlockShape.rectangle => 0,
        };
    Widget child = Container(
      width: block.width,
      height: block.height,
      margin: block.margin,
      decoration: BoxDecoration(
        color: block.isSpacer
            ? Colors.transparent
            : block.style.color ??
                theme?.blockColor ??
                context.tTheme.bgColorComponent,
        borderRadius: BorderRadius.circular(radius),
      ),
    );

    if (!block.isSpacer && widget.animation == TSkeletonAnimation.gradient) {
      child = ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) => LinearGradient(
          colors: [
            Colors.transparent,
            theme?.highlightColor ??
                context.tTheme.bgColorSecondaryContainerActive,
            Colors.transparent,
          ],
          begin: const Alignment(-1, -0.268),
          end: const Alignment(1, 0.268),
        ).createShader(Rect.fromLTWH(
          bounds.width * _animation!.value,
          0,
          bounds.width,
          bounds.height,
        )),
        child: child,
      );
    } else if (!block.isSpacer &&
        widget.animation == TSkeletonAnimation.flashed) {
      child = Opacity(opacity: _animation!.value, child: child);
    }

    return !allowFlex || block.flex == null
        ? child
        : Flexible(flex: block.flex!, child: child);
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }
}
