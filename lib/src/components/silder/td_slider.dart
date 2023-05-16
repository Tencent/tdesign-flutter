///
///  Created by arvinwli@tencent.com on 4/24/23.
///
import 'package:flutter/material.dart';
import 'td_slider_theme.dart';

class TDSlider extends StatefulWidget {
  final double value;
  final String? leftLabel;
  final String? rightLabel;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final TDSliderThemeData? sliderThemeData;

  const TDSlider(
      {Key? key,
      required this.value,
      this.onChanged,
      this.sliderThemeData,
      this.leftLabel,
      this.rightLabel,
      this.onChangeStart,
      this.onChangeEnd})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TDSliderState();
  }
}

class TDSliderState extends State<TDSlider> {
  double value = 0;

  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  bool get enabled => widget.onChanged != null;

  TextStyle get labelTextStyle =>
      TextStyle(fontSize: 16, color: enabled ? const Color(0xE6000000) : const Color(0x42000000));

  Widget get leftLabel => widget.leftLabel?.isNotEmpty == true
      ? Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(widget.leftLabel!, style: labelTextStyle),
        )
      : Container();

  Widget get rightLabel => widget.rightLabel?.isNotEmpty == true
      ? Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Text(widget.rightLabel!, style: labelTextStyle),
        )
      : Container();

  @override
  Widget build(BuildContext context) {
    var tdSliderThemeData = widget.sliderThemeData ?? TDSliderThemeData();
    return Container(
      padding: EdgeInsets.only(
        top: (tdSliderThemeData.showScaleValue ? 16 : 0) + 18,
        bottom: 18,
      ),
      color: Colors.white,
      child: Row(
        children: [
          leftLabel,
          const SizedBox(width: 8),
          Expanded(
              child: SliderTheme(
            data: tdSliderThemeData,
            child: Slider(
              value: value,
              min: tdSliderThemeData.min,
              max: tdSliderThemeData.max,
              divisions: tdSliderThemeData.divisions,
              onChangeStart: widget.onChangeStart,
              onChangeEnd: widget.onChangeEnd,
              onChanged: enabled
                  ? (slideValue) {
                      setState(() {
                        value = slideValue;
                        if (widget.onChanged != null) {
                          widget.onChanged!(slideValue);
                        }
                      });
                    }
                  : null,
            ),
          )),
          const SizedBox(width: 8),
          rightLabel
        ],
      ),
    );
  }
}

class TDRangeSlider extends StatefulWidget {
  final RangeValues value;
  final ValueChanged<RangeValues>? onChanged;
  final ValueChanged<RangeValues>? onChangeStart;
  final ValueChanged<RangeValues>? onChangeEnd;
  final TDSliderThemeData? sliderThemeData;
  final String? leftLabel;
  final String? rightLabel;

  const TDRangeSlider(
      {Key? key,
      required this.value,
      this.onChanged,
      this.sliderThemeData,
      this.leftLabel,
      this.rightLabel,
      this.onChangeStart,
      this.onChangeEnd})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TDRangeSliderState();
  }
}

class _TDRangeSliderState extends State<TDRangeSlider> {
  RangeValues rangeValues = const RangeValues(0, 100);

  @override
  void initState() {
    super.initState();
    rangeValues = widget.value;
  }

  bool get enabled => widget.onChanged != null;

  TextStyle get labelTextStyle =>
      TextStyle(fontSize: 16, color: enabled ? const Color(0xE6000000) : const Color(0x42000000));

  Widget get leftLabel => widget.leftLabel?.isNotEmpty == true
      ? Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(widget.leftLabel!, style: labelTextStyle),
        )
      : Container();

  Widget get rightLabel => widget.rightLabel?.isNotEmpty == true
      ? Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Text(widget.rightLabel!, style: labelTextStyle),
        )
      : Container();

  @override
  Widget build(BuildContext context) {
    var tdSliderThemeData = widget.sliderThemeData ?? TDSliderThemeData();
    return Container(
      padding: EdgeInsets.only(
        top: (tdSliderThemeData.showScaleValue || tdSliderThemeData.showThumbValue ? 16 : 0) + 18,
        bottom: 18,
      ),
      color: Colors.white,
      child: Row(
        children: [
          leftLabel,
          const SizedBox(width: 8),
          Expanded(
              child: SliderTheme(
            data: tdSliderThemeData,
            child: RangeSlider(
              values: rangeValues,
              min: tdSliderThemeData.min,
              max: tdSliderThemeData.max,
              divisions: tdSliderThemeData.divisions,
              onChanged: widget.onChanged == null
                  ? null
                  : (slideValue) {
                      setState(() {
                        rangeValues = slideValue;
                        if (widget.onChanged != null) {
                          widget.onChanged!(slideValue);
                        }
                      });
                    },
              onChangeStart: widget.onChangeStart,
              onChangeEnd: widget.onChangeEnd,
            ),
          )),
          const SizedBox(width: 8),
          rightLabel,
        ],
      ),
    );
  }
}
