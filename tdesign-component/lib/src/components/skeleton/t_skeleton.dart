import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import 't_skeleton_rowcol.dart';
import 't_skeleton_theme_data.dart';

/// 骨架图动画
enum TSkeletonAnimation {
  /// 渐变
  gradient,

  /// 闪烁
  flashed,
}

/// 骨架图风格
enum TSkeletonVariant {
  /// 头像
  avatar,

  /// 图片
  image,

  /// 文本
  text,

  /// 段落
  paragraph,
}

class TSkeleton extends StatefulWidget {
  /// 使用预设形态创建骨架屏。
  ///
  /// [key] 用于区分或保留组件状态。
  /// [animation] 设置动画效果。
  /// [delay] 设置延迟显示的毫秒数。
  /// [variant] 设置预设骨架图形态。
  factory TSkeleton({
    Key? key,
    TSkeletonAnimation? animation,
    int delay = 0,
    TSkeletonVariant variant = TSkeletonVariant.text,
  }) {
    assert(delay >= 0);

    var objects = <List<TSkeletonRowColObj>>[];

    // 根据风格创建骨架图
    switch (variant) {
      case TSkeletonVariant.avatar:
        objects = const [
          [TSkeletonRowColObj.circle()]
        ];
        break;
      case TSkeletonVariant.image:
        objects = const [
          [
            TSkeletonRowColObj.rect(
              width: 72,
              height: 72,
              flex: null,
            )
          ]
        ];
        break;
      case TSkeletonVariant.text:
        objects = const [
          [
            TSkeletonRowColObj.text(flex: 24),
            TSkeletonRowColObj.spacer(width: 16),
            TSkeletonRowColObj.text(flex: 76),
          ],
          [TSkeletonRowColObj.text()],
        ];
        break;
      case TSkeletonVariant.paragraph:
        objects = [
          for (int i = 0; i < 3; i++) [const TSkeletonRowColObj.text()],
          const [
            TSkeletonRowColObj.text(flex: 55),
            TSkeletonRowColObj.spacer(flex: 45),
          ],
        ];
        break;
    }

    return TSkeleton._(
      key: key,
      animation: animation,
      delay: delay,
      rowCol: TSkeletonRowCol(objects: objects),
      variant: variant,
    );
  }

  const TSkeleton._({
    super.key,
    this.animation,
    required this.delay,
    required this.rowCol,
    required this.variant,
  });

  /// 从行列框架创建骨架屏
  const TSkeleton.fromRowCol({
    super.key,
    this.animation,
    this.delay = 0,
    required this.rowCol,
  })  : variant = null,
        assert(delay >= 0);

  /// 动画效果
  final TSkeletonAnimation? animation;

  /// 延迟显示加载时间
  final int delay;

  /// 自定义行列数量、宽度高度、间距等
  final TSkeletonRowCol rowCol;

  /// 预设骨架图形态；自定义行列模式下为空。
  final TSkeletonVariant? variant;

  @override
  _TSkeletonState createState() => _TSkeletonState();
}

class _TSkeletonState extends State<TSkeleton>
    with SingleTickerProviderStateMixin {
  /// 动画控制器
  late final AnimationController? _controller;

  /// 动画效果
  late final Animation<double>? _animation;

  /// 加载状态
  bool _isLoading = true;

  /// 加载控件
  static final _loadingWidget = Container();

  /// 闪烁透明度
  static const _animationFlashed = .3;

  /// 静态渐变
  static LinearGradient _animationGradient(
          BuildContext context, TSkeletonThemeData? theme) =>
      LinearGradient(
        colors: [
          Colors.transparent,
          theme?.highlightColor ??
              context.tTheme.bgColorSecondaryContainerActive,
          Colors.transparent,
        ],
        // 15 deg
        begin: const Alignment(-1, -0.268),
        end: const Alignment(1, 0.268),
        tileMode: TileMode.clamp,
      );

  @override
  void initState() {
    super.initState();

    // 根据动画效果创建动画控制器
    switch (widget.animation) {
      case TSkeletonAnimation.gradient:
        _controller = AnimationController(
          duration: const Duration(milliseconds: 1500),
          vsync: this,
        )..repeat();
        _animation = Tween<double>(begin: -1, end: 1).animate(_controller!)
          ..addListener(_safeSetState);
        break;
      case TSkeletonAnimation.flashed:
        _controller = AnimationController(
          duration: const Duration(seconds: 1),
          vsync: this,
        )..repeat(reverse: true);
        _animation = Tween<double>(begin: 1, end: _animationFlashed)
            .animate(_controller!)
          ..addListener(_safeSetState);
        break;
      default:
        _controller = null;
        _animation = null;
    }

    // 延迟显示加载效果
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (!mounted) {
        return;
      }
      setState(() => _isLoading = false);
    });
  }

  void _safeSetState() {
    if (mounted) {
      setState(() {});
    }
  }

  Widget Function(TSkeletonRowColObj) _buildObj(BuildContext context,
          {bool allowFlex = true}) =>
      (TSkeletonRowColObj obj) {
        final theme = Theme.of(context).extension<TSkeletonThemeData>();
        final radius = obj.style.borderRadius ??
            switch (obj.style.shape) {
              TSkeletonBlockShape.circle => (obj.height ?? obj.width ?? 0) / 2,
              TSkeletonBlockShape.square => 0,
              TSkeletonBlockShape.rounded =>
                theme?.borderRadius ?? context.tTheme.radiusSmall,
            };
        // 骨架图对象
        Widget skeletonObj = Container(
          width: obj.width,
          height: obj.height,
          margin: obj.margin,
          decoration: BoxDecoration(
            color: obj.isSpacer
                ? Colors.transparent
                : obj.style.backgroundColor ??
                    theme?.blockColor ??
                    context.tTheme.bgColorComponent,
            borderRadius: BorderRadius.circular(radius),
          ),
        );

        // 动画效果
        switch (widget.animation) {
          case TSkeletonAnimation.gradient:
            skeletonObj = ShaderMask(
              blendMode: BlendMode.srcATop,
              shaderCallback: (bounds) =>
                  _animationGradient(context, theme).createShader(
                Rect.fromLTWH(
                  bounds.width * _animation!.value,
                  0,
                  bounds.width,
                  bounds.height,
                ),
              ),
              child: skeletonObj,
            );
            break;
          case TSkeletonAnimation.flashed:
            skeletonObj = Opacity(
              opacity: _animation!.value,
              child: skeletonObj,
            );
            break;
          default:
        }

        // 根据弹性因子创建弹性布局
        return !allowFlex || obj.flex == null
            ? skeletonObj
            : Flexible(flex: obj.flex!, child: skeletonObj);
      };

  @override
  Widget build(BuildContext context) {
    // 加载状态返回空容器
    if (_isLoading) {
      return _loadingWidget;
    }

    if (widget.rowCol.objects.length == 1) {
      return widget.rowCol.objects.first.length == 1
          // 单个对象
          ? _buildObj(context, allowFlex: false)(
              widget.rowCol.objects.first.first,
            )
          // 单行多个对象
          : Row(
              children:
                  widget.rowCol.objects.first.map(_buildObj(context)).toList(),
            );
    }

    // 多行多个对象
    List<Widget> skeletonRows = widget.rowCol.objects
        .map((row) => Row(children: row.map(_buildObj(context)).toList()))
        .toList();
    final skeletonTheme = Theme.of(context).extension<TSkeletonThemeData>();
    final rowSpacing = widget.rowCol.style.rowSpacing ??
        skeletonTheme?.rowSpacing ??
        context.tTheme.spacer16;
    if (rowSpacing > 0) {
      skeletonRows = skeletonRows
          .expand((row) => [row, SizedBox(height: rowSpacing)])
          .toList();
      if (skeletonRows.isNotEmpty) {
        skeletonRows.removeLast();
      }
    } // 添加行间距
    var skeletonRowCol = Column(
      mainAxisSize: MainAxisSize.min,
      children: skeletonRows,
    ); // 行列布局

    return widget.rowCol.objects
            .any((row) => row.any((obj) => obj.flex != null))
        // 添加弹性布局
        ? Container(
            constraints: BoxConstraints(
              maxHeight: widget.rowCol.visualHeight(rowSpacing),
            ), // 限制最大高度
            child: skeletonRowCol,
          )
        : skeletonRowCol;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
