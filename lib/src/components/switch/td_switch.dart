import 'package:flutter/cupertino.dart';

import '../../../td_export.dart';
import 'td_cupertino_switch.dart';

enum TDSwitchSize { large, medium, small }

enum TDSwitchType { fill, text, loading, icon }

class TDSwitch extends StatefulWidget {
  const TDSwitch({
    Key? key,
    this.enable = true,
    this.isOn = false,
    this.size = TDSwitchSize.medium,
    this.type = TDSwitchType.fill,
    this.trackOnColor,
    this.trackOffColor,
    this.thumbContentOnColor,
    this.thumbContentOffColor,
    this.onChanged,
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

  /// 尺寸：大、中、小
  final TDSwitchSize? size;

  /// 类型：填充、文本、加载
  final TDSwitchType? type;

  ///改变事件
  final ValueChanged<bool>? onChanged;

  @override
  State<StatefulWidget> createState() {
    return TDSwitchState();
  }
}

class TDSwitchState extends State<TDSwitch> {
  bool isOn = false;

  @override
  void initState() {
    super.initState();
    isOn = widget.isOn;
  }

  @override
  void didUpdateWidget(covariant TDSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    isOn = widget.isOn;
  }

  @override
  Widget build(BuildContext context) {
    final theme = TDTheme.of(context);
    final switchEnable = widget.enable && widget.type != TDSwitchType.loading;
    final trackOnColor = widget.trackOnColor ?? theme.brandColor7;
    final trackOffColor = widget.trackOffColor ?? theme.grayColor4;
    final thumbContentOnColor = widget.thumbContentOnColor ?? theme.brandColor7;
    final thumbContentOffColor = widget.thumbContentOffColor ?? theme.fontGyColor4;
    Widget current = TDCupertinoSwitch(
      value: isOn,
      activeColor: trackOnColor,
      trackColor: trackOffColor,
      onChanged: (value) {
        widget.onChanged?.call(value);
        isOn = value;
        setState(() {});
      },
      thumbView: _getThumbView(thumbContentOnColor, thumbContentOffColor),
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
      case TDSwitchSize.large:
        return 52;
      case TDSwitchSize.medium:
        return 45;
      case TDSwitchSize.small:
        return 39;
      default:
        return 45;
    }
  }

  double _getHeight() {
    switch (widget.size) {
      case TDSwitchSize.large:
        return 32;
      case TDSwitchSize.medium:
        return 28;
      case TDSwitchSize.small:
        return 24;
      default:
        return 28;
    }
  }

  Widget? _getThumbView(Color thumbContentOnColor, Color thumbContentOffColor) {
    switch (widget.type) {
      case TDSwitchType.text:
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 1),
          child: TDText(
            isOn ? '开' : '关',
            style: TextStyle(color: isOn ? thumbContentOnColor : thumbContentOffColor, fontSize: 14),
          ),
        );
      case TDSwitchType.loading:
        return Container(
          alignment: Alignment.centerLeft,
          child: TDCircleIndicator(
            color: thumbContentOnColor,
            size: 16,
            lineWidth: 3,
          ),
        );
      case TDSwitchType.icon:
        return Container(
          alignment: Alignment.centerLeft,
          child: Icon(isOn ? TDIcons.check : TDIcons.close,
              size: 16, color: isOn ? thumbContentOnColor : thumbContentOffColor),
        );
      case TDSwitchType.fill:
      default:
        return null;
    }
  }
}
