import 'package:flutter/cupertino.dart';

import '../../../td_export.dart';

class TDSwitch extends StatefulWidget {

  const TDSwitch({
    Key? key,
    this.enable = true,
    this.isOn = false,
    this.onColor,
    this.offColor,
    this.onChanged,
  }): super(key: key);

  /// 是否可点击
  final bool enable;

  /// 是否打开
  final bool isOn;

  /// 开启颜色
  final Color? onColor;

  /// 关闭颜色
  final Color? offColor;

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
    Widget current = CupertinoSwitch(
      value: isOn,
      activeColor: widget.onColor ?? theme.brandColor8,
      trackColor: widget.offColor ?? theme.grayColor4,
      onChanged: (value) {
        widget.onChanged?.call(value);
        isOn = value;
        setState(() {

        });
      },
    );
    if (!widget.enable) {
      current = Opacity(
        opacity: 0.4,
        child: IgnorePointer(
          ignoring: !widget.enable,
          child: current,
        ),
      );
    }
    return current;
  }
}
