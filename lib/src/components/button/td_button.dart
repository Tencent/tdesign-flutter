import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

enum TDButtonSize { Small, Medium, Large }

enum TDButtonTheme {
  /// 常规
  Default,

  /// 强调
  Primary,

  ///轻度
  Light,
  Danger,
}

enum TDButtonShape {
  Square,
  Round,
}

enum TDButtonType {
  ///常规
  Normal,

  ///加载按钮
  Loading,

  ///进度条按钮
  Progress,
}

typedef TDButtonEvent = void Function();

class TDButton extends StatefulWidget {
  final Widget? child;
  final String? content;
  final bool? disabled;
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
      this.size = TDButtonSize.Medium,
      this.child,
      this.disabled = false,
      this.opacity = 1.0,
      this.width,
      this.theme = TDButtonTheme.Default,
      this.shape = TDButtonShape.Square,
      this.type = TDButtonType.Normal,
      this.click,
      this.longClick})
      : super(key: key);

  _TDButtonState? _btnState;

  @override
  State<StatefulWidget> createState() {
    _btnState = _TDButtonState(this.opacity!);
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
    if (widget.type != TDButtonType.Progress) return;

    progress = min(1, max(progress, 0));
    setState(() {
      this.progress = progress;
    });
  }

  void setIsLoading(bool isLoading) {
    if (widget.type != TDButtonType.Loading) return;

    if (isLoading) {
      _animationController?.forward();
    } else {
      _animationController?.stop();
    }
    setState(() {
      this.isLoading = isLoading;
    });
  }

  void initState() {
    super.initState();
    _setAnimation();
  }

  void _setAnimation() {
    if (widget.type != TDButtonType.Loading) return;

    if (_animationController == null) {
      _animationController =
          AnimationController(duration: Duration(seconds: 300), vsync: this);
    }
    if (_animation == null) {
      _animation =
          Tween<double>(begin: 1, end: 300).animate(_animationController!)
            ..addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                _animationController?.reverse();
              } else if (status == AnimationStatus.dismissed) {
                _animationController?.forward();
              }
            });
    }
  }

  double _getButtonHeight() {
    double height = 28;
    switch (widget.size) {
      case TDButtonSize.Small:
        height = 36;
        break;
      case TDButtonSize.Medium:
        height = 40;
        break;
      case TDButtonSize.Large:
        height = 44;
        break;
    }
    return height;
  }

  Color? _getButtonColor() {
    switch (widget.theme) {
      case TDButtonTheme.Primary:
        return widget.disabled == true
            ? TDTheme.of(context).brandColor3
            : TDTheme.of(context).brandColor8;
      case TDButtonTheme.Danger:
        return widget.disabled == true
            ? TDTheme.of(context).errorColor3
            : TDTheme.of(context).errorColor6;
    }
    return null;
  }

  TextStyle _getButtonTextStyle() {
    TextStyle style = TextStyle();
    Map fontMap = {
      TDButtonSize.Small: [TDTheme.of(context).fontS, FontWeight.w400],
      TDButtonSize.Medium: [TDTheme.of(context).fontS, FontWeight.w400],
      TDButtonSize.Large: [TDTheme.of(context).fontM, FontWeight.w400]
    };

    switch (widget.theme) {
      case TDButtonTheme.Default:
        style = TextStyle(
            fontSize: fontMap[widget.size][0].size,
            height: fontMap[widget.size][0].height,
            fontWeight: fontMap[widget.size][1],
            decoration: TextDecoration.none,
            color: widget.disabled == true
                ? TDTheme.of(context).brandColor3
                : TDTheme.of(context).brandColor8);
        break;
      case TDButtonTheme.Primary:
        style = TextStyle(
            fontSize: fontMap[widget.size][0].size,
            height: fontMap[widget.size][0].height,
            fontWeight: fontMap[widget.size][1],
            decoration: TextDecoration.none,
            color: widget.disabled == true
                ? TDTheme.of(context).whiteColor1
                : TDTheme.of(context).whiteColor1);
        break;
      case TDButtonTheme.Light:
        style = TextStyle(
            fontSize: fontMap[widget.size][0].size,
            height: fontMap[widget.size][0].height,
            fontWeight: fontMap[widget.size][1],
            decoration: TextDecoration.none,
            color: widget.disabled == true
                ? TDTheme.of(context).fontGyColor4
                : TDTheme.of(context).fontGyColor1);
        break;
      case TDButtonTheme.Danger:
        style = TextStyle(
            fontSize: fontMap[widget.size][0].size,
            height: fontMap[widget.size][0].height,
            fontWeight: fontMap[widget.size][1],
            decoration: TextDecoration.none,
            color: widget.disabled == true
                ? TDTheme.of(context).whiteColor1
                : TDTheme.of(context).whiteColor1);
        break;
    }

    return style;
  }

  Widget? _getButtonTypeWidget() {
    Widget? typedWidget;
    switch (widget.type) {
      case TDButtonType.Normal:
        typedWidget = TDText(
          widget.content ?? '',
          style: _getButtonTextStyle(),
          forceVerticalCenter: true,
        );
        break;
      case TDButtonType.Loading:
        typedWidget = RotationTransition(
          alignment: Alignment.center,
          turns: _animation!,
          child: Container(
            width: 14,
            height: 14,
            child: const Icon(
              TDIcons.loading,
              size: 14,
            ),
          ),
        );
        break;
      case TDButtonType.Progress:
        typedWidget = Container(
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
                "${(progress * 100).toStringAsFixed(2)}%",
                style: _getButtonTextStyle(),
                forceVerticalCenter: true,
              ),
            ],
          ),
        );
        break;
    }
    return typedWidget;
  }

  BoxDecoration? _getButtonDecoration() {
    switch (widget.theme) {
      case TDButtonTheme.Default:
        return BoxDecoration(
            border: Border.all(
                color: widget.disabled == true
                    ? TDTheme.of(context).brandColor3
                    : TDTheme.of(context).brandColor8,
                width: 0.5),
            borderRadius: widget.shape == TDButtonShape.Round
                ? BorderRadius.circular(4)
                : null);
      case TDButtonTheme.Primary:
        return BoxDecoration(
            color: _getButtonColor(),
            borderRadius: widget.shape == TDButtonShape.Round
                ? BorderRadius.circular(4)
                : null);
      case TDButtonTheme.Light:
        return BoxDecoration(
            border:
                Border.all(color: TDTheme.of(context).grayColor4, width: 0.5),
            borderRadius: widget.shape == TDButtonShape.Round
                ? BorderRadius.circular(4)
                : null);
      case TDButtonTheme.Danger:
        return BoxDecoration(
            color: _getButtonColor(),
            borderRadius: widget.shape == TDButtonShape.Round
                ? BorderRadius.circular(4)
                : null);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double height = _getButtonHeight();
    if (widget.type == TDButtonType.Progress) {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        double btnW = _globalKey.currentContext?.size?.width ?? 0;
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
        padding: (widget.type == TDButtonType.Progress)
            ? EdgeInsets.zero
            : const EdgeInsets.only(left: 16, right: 16),
        width: widget.width,
        height: height,
        child: Center(
          child: widget.child != null ? widget.child! : _getButtonTypeWidget(),
        ),
      ),
      onTap: () {
        if (widget.disabled == true) return;
        if (widget.click != null) {
          widget.click!();
        }
      },
      onLongPressUp: () {
        if (widget.disabled == true) return;
        if (widget.longClick != null) {
          widget.longClick!();
        }
      },
      onTapDown: (TapDownDetails details) {
        if (widget.disabled == true) return;
        setState(() {
          widget.timer?.cancel();
          widget.timer = null;
          _opacity = 0.6 * _originOp;
        });
      },
      onTapUp: (TapUpDetails details) {
        if (widget.disabled == true) return;
        widget.timer = Timer(const Duration(milliseconds: 100), () {
          widget.timer?.cancel();
          widget.timer = null;
          setState(() {
            _opacity = _originOp;
          });
        });
      },
      onLongPressEnd: (LongPressEndDetails details) {
        if (widget.disabled == true) return;
        setState(() {
          _opacity = _originOp;
        });
      },
    );
  }
}
