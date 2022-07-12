import 'package:flutter/material.dart';
import '../../../td_export.dart';

typedef OnCheckValueChanged = void Function(bool selected);

enum TDRadioType {
  circle,
  square,
  check,
}

// ignore: must_be_immutable
class TDRadio extends StatefulWidget {
  final TDRadioType type;
  bool? selected;
  final bool? disabled;
  final OnCheckValueChanged? onCheckValueChanged;

  TDRadio(
      {Key? key,
      this.type = TDRadioType.circle,
      this.selected = false,
      this.disabled = false,
      this.onCheckValueChanged})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDRadioState();
}

class _TDRadioState extends State<TDRadio> {
  bool selected = false;

  @override
  void initState() {
    selected = widget.selected ?? false;
    super.initState();
  }

  Color _getIconColor(BuildContext context) {
    if (widget.disabled == true) {
      return TDTheme.of(context).grayColor4;
    }

    return selected
        ? TDTheme.of(context).brandColor8
        : TDTheme.of(context).grayColor4;
  }

  Widget? _getRadioIcon(BuildContext context) {
    Widget? icon;
    switch (widget.type) {
      case TDRadioType.circle:
        icon = Icon(selected ? TDIcons.check_circle_filled : TDIcons.circle,
            size: 24, color: _getIconColor(context));
        break;
      case TDRadioType.square:
        icon = Icon(
            selected ? TDIcons.check_rectangle_filled : TDIcons.rectangle,
            size: 24,
            color: _getIconColor(context));
        break;
      case TDRadioType.check:
        icon = selected
            ? Icon(TDIcons.check, size: 24, color: _getIconColor(context))
            : const SizedBox(
                width: 0,
                height: 0,
              );
        break;
    }

    return icon;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 24,
        height: 24,
        color: Colors.transparent,
        child: _getRadioIcon(context),
      ),
      onTap: () {
        if (widget.disabled == true){
          return;
        }

        setState(() {
          selected = !selected;
          widget.selected = selected;
          if (widget.onCheckValueChanged != null) {
            widget.onCheckValueChanged!(selected);
          }
        });
      },
    );
  }
}
