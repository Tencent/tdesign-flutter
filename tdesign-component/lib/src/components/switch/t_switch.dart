import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';
import 't_cupertino_switch.dart';

/// 开关改变事件处理
typedef OnSwitchChanged = bool Function(bool value);

enum TSwitchSize { large, medium, small }

enum TSwitchType { fill, text, loading, icon }

class TSwitch extends StatefulWidget {
  const TSwitch({
    Key? key,
    this.enable = true,
    this.isOn = false,
    this.size = TSwitchSize.medium,
    this.type = TSwitchType.fill,
    this.trackOnColor,
    this.trackOffColor,
    this.thumbContentOnColor,
    this.thumbContentOffColor,
    this.thumbContentOnFont,
    this.thumbContentOffFont,
    this.onChanged,
    this.openText,
    this.closeText,
  }) : super(key: key);

  /// 是否可点击
  final bool enable;

  /// 是否打开
  final bool isOn;

  /// 开启时轨道颜色
  final Color? trackOnColor;

  /// 关闭时轨道颜色
  final Color? trackOffColor;

  /// 开启时ThumbView的颜色
  final Color? thumbContentOnColor;

  /// 关闭时ThumbView的颜色
  final Color? thumbContentOffColor;

  /// 开启时ThumbView的字体样式
  final TextStyle? thumbContentOnFont;

  /// 关闭时ThumbView的字体样式
  final TextStyle? thumbContentOffFont;

  /// 尺寸：大、中、小
  final TSwitchSize? size;

  /// 类型：填充、文本、加载
  final TSwitchType? type;

  /// 改变事件
  final OnSwitchChanged? onChanged;

  /// 打开文案
  final String? openText;

  /// 关闭文案
  final String? closeText;

  @override
  State<StatefulWidget> createState() {
    return TSwitchState();
  }
}

class TSwitchState extends State<TSwitch> {
  bool isOn = false;

  @override
  void initState() {
    super.initState();
    isOn = widget.isOn;
  }

  @override
  void didUpdateWidget(covariant TSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    isOn = widget.isOn;
  }

  @override
  Widget build(BuildContext context) {
    final theme = TTheme.of(context);
    final switchEnable = widget.enable && widget.type != TSwitchType.loading;
    final trackOnColor = widget.trackOnColor ?? theme.brandNormalColor;
    final trackOffColor = widget.trackOffColor ?? theme.textDisabledColor;
    final thumbContentOnColor =
        widget.thumbContentOnColor ?? theme.brandNormalColor;
    final thumbContentOffColor =
        widget.thumbContentOffColor ?? theme.textDisabledColor;
    final thumbContentOnFont =
        widget.thumbContentOnFont ?? const TextStyle(fontSize: 14);
    final thumbContentOffFont =
        widget.thumbContentOffFont ?? const TextStyle(fontSize: 14);
    Widget current = TCupertinoSwitch(
      value: isOn,
      activeColor: trackOnColor,
      trackColor: trackOffColor,
      onChanged: (value) {
        var process = widget.onChanged?.call(value) ?? false;
        // 如果外部未处理，才需要自定刷新开关，如果已处理则不需要刷新
        if (!process) {
          isOn = value;
          setState(() {});
        }
      },
      thumbView: _getThumbView(
        thumbContentOnColor,
        thumbContentOffColor,
        thumbContentOnFont,
        thumbContentOffFont,
      ),
    );
    if (!switchEnable) {
      current = Opacity(
        opacity: 0.4,
        child: IgnorePointer(
          ignoring: !switchEnable,
          child: current,
        ),
      );
    }
    return SizedBox(
      width: _getWidth(),
      height: _getHeight(),
      child: FittedBox(
        child: current,
      ),
    );
    // return ConstrainedBox( _getWidth(), height: _getHeight(), child: current);
  }

  double _getWidth() {
    switch (widget.size) {
      case TSwitchSize.large:
        return 52;
      case TSwitchSize.medium:
        return 45;
      case TSwitchSize.small:
        return 39;
      default:
        return 45;
    }
  }

  double _getHeight() {
    switch (widget.size) {
      case TSwitchSize.large:
        return 32;
      case TSwitchSize.medium:
        return 28;
      case TSwitchSize.small:
        return 24;
      default:
        return 28;
    }
  }

  Widget? _getThumbView(
    Color thumbContentOnColor,
    Color thumbContentOffColor,
    TextStyle thumbContentOnFont,
    TextStyle thumbContentOffFont,
  ) {
    switch (widget.type) {
      case TSwitchType.text:
        return Stack(
          children: [
            Container(
              alignment: Alignment.center,
              width: 16,
              child: TText(
                isOn
                    ? (widget.openText ?? context.resource.open)
                    : (widget.closeText ?? context.resource.close),
                textColor: isOn ? thumbContentOnColor : thumbContentOffColor,
                forceVerticalCenter: true,
                maxLines: 1,
                style: isOn ? thumbContentOnFont : thumbContentOffFont,
              ),
            )
          ],
        );
      case TSwitchType.loading:
        return Container(
          alignment: Alignment.centerLeft,
          child: TCircleIndicator(
            color: thumbContentOnColor,
            size: 16,
            lineWidth: 3,
          ),
        );
      case TSwitchType.icon:
        return Container(
          alignment: Alignment.centerLeft,
          child: Icon(
            isOn ? TIcons.check : TIcons.close,
            size: 16,
            color: isOn ? thumbContentOnColor : thumbContentOffColor,
          ),
        );
      case TSwitchType.fill:
      default:
        return null;
    }
  }
}
