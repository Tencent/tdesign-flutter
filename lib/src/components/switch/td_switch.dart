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
    this.onColor,
    this.offColor = CupertinoColors.secondarySystemFill,
    this.onChanged,
  }) : super(key: key);

  /// 是否可点击
  final bool enable;

  /// 是否打开
  final bool isOn;

  /// 开启颜色
  final Color? onColor;

  /// 关闭颜色
  final Color? offColor;

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
    var onColor = widget.onColor ?? theme.brandColor7;
    var offColor = widget.offColor ?? theme.fontGyColor4;
    Widget current = TDCupertinoSwitch(
      value: isOn,
      activeColor: onColor,
      trackColor: offColor,
      onChanged: (value) {
        widget.onChanged?.call(value);
        isOn = value;
        setState(() {});
      },
      thumbView: _getThumbView(onColor, offColor),
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

  Widget? _getThumbView(Color onColor, Color offColor) {
    switch (widget.type) {
      case TDSwitchType.text:
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 1),
          child: TDText(
            isOn ? '开' : '关',
            style: TextStyle(color: isOn ? onColor : offColor, fontSize: 14),
          ),
        );
      case TDSwitchType.loading:
        return Container(
          alignment: Alignment.centerLeft,
          child: TDCircleIndicator(
            color: onColor,
            size: 16,
            lineWidth: 3,
          ),
        );
      case TDSwitchType.icon:
        return Container(
          alignment: Alignment.centerLeft,
          child: Icon(isOn ? TDIcons.check : TDIcons.close,
              size: 16, color: isOn ? onColor : offColor),
        );
      case TDSwitchType.fill:
      default:
        return null;
    }
  }
}
