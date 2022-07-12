import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import '../../../td_export.dart';

enum TDButtonSize { small, medium, large }

enum TDButtonTheme {
  /// 常规
  normal,

  /// 强调
  primary,

  ///轻度
  light,
  danger,
}

enum TDButtonShape {
  square,
  round,
}

enum TDButtonType {
  ///常规
  normal,

  ///加载按钮
  loading,

  ///进度条按钮
  progress,
}

typedef TDButtonEvent = void Function();

class TDButton extends StatefulWidget {
  final Widget? child;
  final String? content;
  final bool disabled;
  final double? opacity;
  final double? width;
  final TDButtonSize? size;
  final TDButtonTheme? theme;
  final TDButtonShape? shape;
  final TDButtonType? type;
  final TDButtonEvent? click;
  final TDButtonEvent? longClick;
  final Key? reportKey;

  Timer? timer;

  ///设置下载进度, type 为Progress 生效
  double get progress => _btnState?.progress ?? 0;

  set progress(double p) => _btnState?.updateProgress(p);

  ///loading动画, true 开启动画，false停止, type 为Loading 生效
  bool get isLoading => _btnState?.isLoading ?? false;

  set isLoading(bool loading) => _btnState?.setIsLoading(loading);

  TDButton(
      {Key? key,
      this.reportKey,
      required this.content,
      this.size = TDButtonSize.medium,
      this.child,
      this.disabled = false,
      this.opacity = 1.0,
      this.width,
      this.theme = TDButtonTheme.normal,
      this.shape = TDButtonShape.square,
      this.type = TDButtonType.normal,
      this.click,
      this.longClick})
      : super(key: key);

  _TDButtonState? _btnState;

  @override
  State<StatefulWidget> createState() {
    _btnState = _TDButtonState(opacity!);
    return _btnState!;
  }
}

class _TDButtonState extends State<TDButton>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  double progress = 0;
  AnimationController? _animationController;
  Animation<double>? _animation;
  double _opacity = 1.0;
  double _originOp = 1.0;
  double _btnWidth = 0;

  final GlobalKey _globalKey = GlobalKey();

  _TDButtonState(double op) {
    _opacity = op;
    _originOp = op;
  }

  void updateProgress(double progress) {
    if (widget.type != TDButtonType.progress){
      return;
    }

    progress = min(1, max(progress, 0));
    setState(() {
      progress = progress;
    });
  }

  void setIsLoading(bool isLoading) {
    if (widget.type != TDButtonType.loading){
      return;
    }

    if (isLoading) {
      _animationController?.forward();
    } else {
      _animationController?.stop();
    }
    setState(() {
      isLoading = isLoading;
    });
  }

  @override
  void initState() {
    super.initState();
    _setAnimation();
  }

  void _setAnimation() {
    if (widget.type != TDButtonType.loading){
      return;
    }


    _animationController ??=
        AnimationController(duration: const Duration(seconds: 300), vsync: this);

    _animation ??=
    Tween<double>(begin: 1, end: 300).animate(_animationController!)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController?.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animationController?.forward();
        }
      });
  }

  double _getButtonHeight() {
    var height = 28.0;
    switch (widget.size) {
      case TDButtonSize.small:
        height = 36;
        break;
      case TDButtonSize.medium:
        height = 40;
        break;
      case TDButtonSize.large:
        height = 44;
        break;
      default:
    }
    return height;
  }

  Color? _getButtonColor() {
    switch (widget.theme) {
      case TDButtonTheme.primary:
        return widget.disabled == true
            ? TDTheme.of(context).brandColor3
            : TDTheme.of(context).brandColor8;
      case TDButtonTheme.danger:
        return widget.disabled == true
            ? TDTheme.of(context).errorColor3
            : TDTheme.of(context).errorColor6;
      default:
    }
    return null;
  }

  TextStyle _getButtonTextStyle() {
    var style = const TextStyle();
    var fontMap = <TDButtonSize, dynamic>{
      TDButtonSize.small: [TDTheme.of(context).fontS, FontWeight.w400],
      TDButtonSize.medium: [TDTheme.of(context).fontS, FontWeight.w400],
      TDButtonSize.large: [TDTheme.of(context).fontM, FontWeight.w400]
    };

    switch (widget.theme) {
      case TDButtonTheme.normal:
        style = TextStyle(
            fontSize: fontMap[widget.size][0].size,
            height: fontMap[widget.size][0].height,
            fontWeight: fontMap[widget.size][1],
            decoration: TextDecoration.none,
            color: widget.disabled == true
                ? TDTheme.of(context).brandColor3
                : TDTheme.of(context).brandColor8);
        break;
      case TDButtonTheme.primary:
        style = TextStyle(
            fontSize: fontMap[widget.size][0].size,
            height: fontMap[widget.size][0].height,
            fontWeight: fontMap[widget.size][1],
            decoration: TextDecoration.none,
            color: widget.disabled == true
                ? TDTheme.of(context).whiteColor1
                : TDTheme.of(context).whiteColor1);
        break;
      case TDButtonTheme.light:
        style = TextStyle(
            fontSize: fontMap[widget.size][0].size,
            height: fontMap[widget.size][0].height,
            fontWeight: fontMap[widget.size][1],
            decoration: TextDecoration.none,
            color: widget.disabled == true
                ? TDTheme.of(context).fontGyColor4
                : TDTheme.of(context).fontGyColor1);
        break;
      case TDButtonTheme.danger:
        style = TextStyle(
            fontSize: fontMap[widget.size][0].size,
            height: fontMap[widget.size][0].height,
            fontWeight: fontMap[widget.size][1],
            decoration: TextDecoration.none,
            color: widget.disabled == true
                ? TDTheme.of(context).whiteColor1
                : TDTheme.of(context).whiteColor1);
        break;
      default:
    }

    return style;
  }

  Widget? _getButtonTypeWidget() {
    Widget? typedWidget;
    switch (widget.type) {
      case TDButtonType.normal:
        typedWidget = TDText(
          widget.content ?? '',
          style: _getButtonTextStyle(),
          forceVerticalCenter: true,
        );
        break;
      case TDButtonType.loading:
        typedWidget = RotationTransition(
          alignment: Alignment.center,
          turns: _animation!,
          child: const SizedBox(
            width: 14,
            height: 14,
            child: Icon(
              TDIcons.loading,
              size: 14,
            ),
          ),
        );
        break;
      case TDButtonType.progress:
        typedWidget = SizedBox(
          width: _btnWidth,
          height: _getButtonHeight(),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: _btnWidth * progress,
                  height: _getButtonHeight(),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.white.withOpacity(0),
                    Colors.white.withOpacity(0.45)
                  ])),
                ),
              ),
              TDText(
                '${(progress * 100).toStringAsFixed(2)}%',
                style: _getButtonTextStyle(),
                forceVerticalCenter: true,
              ),
            ],
          ),
        );
        break;
      default:
    }
    return typedWidget;
  }

  BoxDecoration? _getButtonDecoration() {
    switch (widget.theme) {
      case TDButtonTheme.normal:
        return BoxDecoration(
            border: Border.all(
                color: widget.disabled == true
                    ? TDTheme.of(context).brandColor3
                    : TDTheme.of(context).brandColor8,
                width: 0.5),
            borderRadius: widget.shape == TDButtonShape.round
                ? BorderRadius.circular(4)
                : null);
      case TDButtonTheme.primary:
        return BoxDecoration(
            color: _getButtonColor(),
            borderRadius: widget.shape == TDButtonShape.round
                ? BorderRadius.circular(4)
                : null);
      case TDButtonTheme.light:
        return BoxDecoration(
            border:
                Border.all(color: TDTheme.of(context).grayColor4, width: 0.5),
            borderRadius: widget.shape == TDButtonShape.round
                ? BorderRadius.circular(4)
                : null);
      case TDButtonTheme.danger:
        return BoxDecoration(
            color: _getButtonColor(),
            borderRadius: widget.shape == TDButtonShape.round
                ? BorderRadius.circular(4)
                : null);
      default:
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var height = _getButtonHeight();
    if (widget.type == TDButtonType.progress) {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        var btnW = _globalKey.currentContext?.size?.width ?? 0;
        if (_btnWidth <= 0 && btnW > 0) {
          _btnWidth = btnW;
          updateProgress(progress);
        }
        _btnWidth = btnW;
      });
    }
    return GestureDetector(
      key: widget.reportKey,
      child: Container(
        key: _globalKey,
        decoration: _getButtonDecoration(),
        padding: (widget.type == TDButtonType.progress)
            ? EdgeInsets.zero
            : const EdgeInsets.only(left: 16, right: 16),
        width: widget.width,
        height: height,
        child: Center(
          child: widget.child ?? _getButtonTypeWidget(),
        ),
      ),
      onTap: () {
        if (widget.disabled == true){
          return;
        }
        if (widget.click != null) {
          widget.click!();
        }
      },
      onLongPressUp: () {
        if (widget.disabled == true){
          return;
        }
        if (widget.longClick != null) {
          widget.longClick!();
        }
      },
      onTapDown: (TapDownDetails details) {
        if (widget.disabled == true){
          return;
        }
        setState(() {
          widget.timer?.cancel();
          widget.timer = null;
          _opacity = 0.6 * _originOp;
        });
      },
      onTapUp: (TapUpDetails details) {
        if (widget.disabled == true){
          return;
        }
        widget.timer = Timer(const Duration(milliseconds: 100), () {
          widget.timer?.cancel();
          widget.timer = null;
          setState(() {
            _opacity = _originOp;
          });
        });
      },
      onLongPressEnd: (LongPressEndDetails details) {
        if (widget.disabled == true){
          return;
        }
        setState(() {
          _opacity = _originOp;
        });
      },
    );
  }
}
