import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

///
/// 骨架图动画
///
enum TDSkeletonAnimation {
  gradient, // 渐变
  flashed, // 闪烁
}

///
/// 骨架图风格
///
enum TDSkeletonTheme {
  avatar, // 头像
  image, // 图片
  text, // 文本
  paragraph, // 段落
}

class TDSkeleton extends StatefulWidget {
  factory TDSkeleton({
    Key? key,
    TDSkeletonAnimation? animation,
    int delay = 0,
    TDSkeletonTheme theme = TDSkeletonTheme.text,
  }) {
    assert(delay >= 0);
    
    // 根据风格创建骨架图
    switch (theme) {
      case TDSkeletonTheme.avatar:
        return TDSkeleton.fromRowCol(
          key: key,
          animation: animation,
          delay: delay,
          rowCol: TDSkeletonRowCol(
            objects: const [
              [TDSkeletonRowColObj.circle()]
            ],
          ),
        );
      case TDSkeletonTheme.image:
        return TDSkeleton.fromRowCol(
          key: key,
          animation: animation,
          delay: delay,
          rowCol: TDSkeletonRowCol(
            objects: const [
              [
                TDSkeletonRowColObj.rect(
                  width: 72,
                  height: 72,
                  flex: null,
                )
              ]
            ],
          ),
        );
      case TDSkeletonTheme.text:
        return TDSkeleton.fromRowCol(
          key: key,
          animation: animation,
          delay: delay,
          rowCol: TDSkeletonRowCol(objects: const [
            [
              TDSkeletonRowColObj.text(flex: 24),
              TDSkeletonRowColObj.spacer(width: 16),
              TDSkeletonRowColObj.text(flex: 76),
            ],
            [TDSkeletonRowColObj.text()],
          ]),
        );
      case TDSkeletonTheme.paragraph:
        return TDSkeleton.fromRowCol(
          key: key,
          animation: animation,
          delay: delay,
          rowCol: TDSkeletonRowCol(objects: [
            for (int i = 0; i < 3; i++) [const TDSkeletonRowColObj.text()],
            const [
              TDSkeletonRowColObj.text(flex: 55),
              TDSkeletonRowColObj.spacer(flex: 45),
            ],
          ]),
        );
    }
  }

  /// 从行列框架创建骨架屏
  const TDSkeleton.fromRowCol({
    super.key,
    this.animation,
    this.delay = 0,
    required this.rowCol,
  }): assert(delay >= 0);

  /// 动画效果
  final TDSkeletonAnimation? animation;

  /// 延迟显示加载时间
  final int delay;

  /// 自定义行列数量、宽度高度、间距等
  final TDSkeletonRowCol rowCol;

  @override
  _TDSkeletonState createState() => _TDSkeletonState();
}

class _TDSkeletonState extends State<TDSkeleton>
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
  static LinearGradient _animationGradient(BuildContext context) =>
      LinearGradient(
        colors: [
          Colors.transparent,
          TDTheme.of(context).grayColor4,
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
      case TDSkeletonAnimation.gradient:
        _controller = AnimationController(
          duration: const Duration(milliseconds: 1500),
          vsync: this,
        )..repeat();
        _animation = Tween<double>(begin: -1, end: 1).animate(_controller!)
          ..addListener(() => setState(() {}));
        break;
      case TDSkeletonAnimation.flashed:
        _controller = AnimationController(
          duration: const Duration(seconds: 1),
          vsync: this,
        )..repeat(reverse: true);
        _animation = Tween<double>(begin: 1, end: _animationFlashed).animate(_controller!)
          ..addListener(() => setState(() {}));
        break;
      default:
        _controller = null;
        _animation = null;
    }

    // 延迟显示加载效果
    Future.delayed(Duration(milliseconds: widget.delay),
        () => setState(() => _isLoading = false));
  }

  Widget Function(TDSkeletonRowColObj) _buildObj(BuildContext context) =>
      (TDSkeletonRowColObj obj) {
        // 骨架图对象
        Widget skeletonObj = Container(
          width: obj.width,
          height: obj.height,
          margin: obj.margin,
          decoration: BoxDecoration(
            color: obj.style.background(context),
            borderRadius:
                BorderRadius.circular(obj.style.borderRadius(context)),
          ),
        );

        // 动画效果
        switch (widget.animation) {
          case TDSkeletonAnimation.gradient:
            skeletonObj = ShaderMask(
              blendMode: BlendMode.srcATop,
              shaderCallback: (bounds) => _animationGradient(context).createShader(
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
          case TDSkeletonAnimation.flashed:
            skeletonObj = Opacity(
              opacity: _animation!.value,
              child: skeletonObj,
            );
            break;
          default:
        }

        // 根据弹性因子创建弹性布局
        return obj.flex == null
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
          ? _buildObj(context)(widget.rowCol.objects.first.first)
          // 单行多个对象
          : Flexible(
              child: Row(
              children:
                  widget.rowCol.objects.first.map(_buildObj(context)).toList(),
            ));
    }

    // 多行多个对象
    List<Widget> skeletonRows = widget.rowCol.objects
        .map((row) => Row(children: row.map(_buildObj(context)).toList()))
        .toList();
    if (widget.rowCol.style.rowSpacing(context) > 0) {
      skeletonRows = skeletonRows
          .expand((row) =>
              [row, SizedBox(height: widget.rowCol.style.rowSpacing(context))])
          .toList()
        ..removeLast();
    } // 添加行间距
    var skeletonRowCol = Column(children: skeletonRows); // 行列布局

    return widget.rowCol.objects
            .any((row) => row.any((obj) => obj.flex != null))
        // 添加弹性布局
        ? Flexible(
            child: Container(
                constraints: BoxConstraints(
                    maxHeight: widget.rowCol.visualHeight(context)), // 限制最大高度
                child: skeletonRowCol))
        : skeletonRowCol;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
