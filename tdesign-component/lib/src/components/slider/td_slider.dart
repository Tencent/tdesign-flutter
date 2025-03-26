///
///  Created by arvinwli@tencent.com on 4/24/23.
///
import 'package:flutter/material.dart';
import 'td_slider_theme.dart';

/// 单滑动选择器
class TDSlider extends StatefulWidget {
  /// 默认值
  final double value;

  /// 自定义盒子样式
  final Decoration? boxDecoration;

  /// 左侧标签
  final String? leftLabel;

  /// 右侧标签
  final String? rightLabel;

  /// 滑动变化监听
  final ValueChanged<double>? onChanged;

  /// 滑动开始监听
  final ValueChanged<double>? onChangeStart;

  /// 滑动结束监听
  final ValueChanged<double>? onChangeEnd;

  /// 样式
  final TDSliderThemeData? sliderThemeData;

  final Function(Offset offset, double value)? onTap;

  const TDSlider(
      {Key? key,
      required this.value,
      this.boxDecoration,
      this.onChanged,
      this.sliderThemeData,
      this.leftLabel,
      this.rightLabel,
      this.onChangeStart,
      this.onChangeEnd,
      this.onTap})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TDSliderState();
  }
}

class TDSliderState extends State<TDSlider> {
  final GlobalKey _sliderKey = GlobalKey();
  double value = 0;
  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  @override
  void didUpdateWidget(covariant TDSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    value = widget.value;
  }

  bool get enabled => widget.onChanged != null;

  TextStyle get labelTextStyle => TextStyle(
      fontSize: 16,
      color: enabled ? const Color(0xE6000000) : const Color(0x42000000));

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
        top: (tdSliderThemeData.showScaleValue ||
                    tdSliderThemeData.showThumbValue
                ? 16
                : 0) +
            8,
        bottom: 8,
      ),
      decoration: widget.boxDecoration ??
          const BoxDecoration(
            color: Colors.white,
          ),
      child: Row(
        children: [
          leftLabel,
          const SizedBox(width: 8),
          Expanded(
            child: Listener(
              onPointerDown: (event) {
                if (!enabled || widget.onTap == null) {
                  return;
                }

                final sliderBox =
                    _sliderKey.currentContext?.findRenderObject() as RenderBox?;
                if (sliderBox == null) {
                  return;
                }

                final tapOffset = sliderBox.globalToLocal(event.position);
                widget.onTap?.call(tapOffset, value);
              },
              child: SliderTheme(
                data: tdSliderThemeData.sliderThemeData,
                child: Slider(
                  key: _sliderKey,
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
                            widget.onChanged?.call(slideValue);
                          });
                        }
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          rightLabel
        ],
      ),
    );
  }
}

enum Position {
  start,
  end,
}

/// 范围滑动选择器
class TDRangeSlider extends StatefulWidget {
  /// 默认值
  final RangeValues value;

  /// 自定义盒子样式
  final Decoration? boxDecoration;

  /// 左侧标签
  final String? leftLabel;

  /// 右侧标签

  final String? rightLabel;

  /// 滑动变化监听
  final ValueChanged<RangeValues>? onChanged;

  /// 滑动开始监听

  final ValueChanged<RangeValues>? onChangeStart;

  /// 滑动结束监听
  final ValueChanged<RangeValues>? onChangeEnd;

  /// 样式
  final TDSliderThemeData? sliderThemeData;

  // Thumb 位置、坐标、当前值
  final Function(Position position, Offset offset, double value)? onTap;

  const TDRangeSlider(
      {Key? key,
      required this.value,
      this.boxDecoration,
      this.onChanged,
      this.sliderThemeData,
      this.leftLabel,
      this.rightLabel,
      this.onChangeStart,
      this.onChangeEnd,
      this.onTap})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TDRangeSliderState();
  }
}

class _TDRangeSliderState extends State<TDRangeSlider> {
  RangeValues rangeValues = const RangeValues(0, 100);
  final GlobalKey _sliderRangeKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    rangeValues = widget.value;
  }

  @override
  void didUpdateWidget(covariant TDRangeSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    rangeValues = widget.value;
  }

  bool get enabled => widget.onChanged != null;

  TextStyle get labelTextStyle => TextStyle(
      fontSize: 16,
      color: enabled ? const Color(0xE6000000) : const Color(0x42000000));

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
    final min = tdSliderThemeData.min;
    final max = tdSliderThemeData.max;

    return Container(
      padding: EdgeInsets.only(
        top: (tdSliderThemeData.showScaleValue ||
                    tdSliderThemeData.showThumbValue
                ? 16
                : 0) +
            8,
        bottom: 8,
      ),
      decoration: widget.boxDecoration ??
          const BoxDecoration(
            color: Colors.white,
          ),
      child: Row(
        children: [
          leftLabel,
          const SizedBox(width: 8),
          Expanded(
            child: Listener(
              onPointerDown: (PointerDownEvent event) {
                if (!enabled || widget.onTap == null) {
                  return;
                }

                final sliderBox = _sliderRangeKey.currentContext
                    ?.findRenderObject() as RenderBox?;
                if (sliderBox == null) {
                  return;
                }

                final sliderRangeBox = _sliderRangeKey.currentContext
                    ?.findRenderObject() as RenderBox?;
                if (sliderRangeBox == null) {
                  return;
                }

                // 坐标系转换
                final tapOffset = sliderBox.globalToLocal(event.position);
                final sliderWidth = sliderBox.size.width;

                // 动态获取 Thumb 尺寸（两个参数）
                final sliderTheme = Theme.of(context).sliderTheme;
                final thumbShape = sliderTheme.rangeThumbShape;
                final thumbSize = thumbShape?.getPreferredSize(
                      enabled, // 参数1: 是否启用
                      tdSliderThemeData.divisions != null, // 参数2: 是否离散
                    ) ??
                    const Size(24, 24);

                // 计算两个 Thumb 的位置
                final startRatio = (rangeValues.start - min) / (max - min);
                final endRatio = (rangeValues.end - min) / (max - min);
                final startCenter =
                    Offset(startRatio * sliderWidth, sliderBox.size.height / 2);
                final endCenter =
                    Offset(endRatio * sliderWidth, sliderBox.size.height / 2);

                // 检测点击区域
                final radius = thumbSize.width / 2;
                final isStartTap = (tapOffset - startCenter).distance <= radius;
                final isEndTap = (tapOffset - endCenter).distance <= radius;

                Position position = Position.start;
                double tappedValue = 0;

                if (isStartTap) {
                  position = Position.start;
                  tappedValue = rangeValues.start;
                } else if (isEndTap) {
                  position = Position.end;
                  tappedValue = rangeValues.end;
                } else {
                  // 计算轨道点击对应的值
                  tappedValue =
                      (tapOffset.dx / sliderWidth) * (max - min) + min;
                }

                widget.onTap?.call(position, tapOffset, tappedValue);
              },
              child: SliderTheme(
                data: tdSliderThemeData.sliderThemeData,
                child: RangeSlider(
                  key: _sliderRangeKey,
                  values: rangeValues,
                  min: tdSliderThemeData.min,
                  max: tdSliderThemeData.max,
                  divisions: tdSliderThemeData.divisions,
                  onChanged: widget.onChanged == null
                      ? null
                      : (slideValue) {
                          setState(() {
                            rangeValues = slideValue;
                            widget.onChanged?.call(slideValue);
                          });
                        },
                  onChangeStart: widget.onChangeStart,
                  onChangeEnd: widget.onChangeEnd,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          rightLabel,
        ],
      ),
    );
  }
}
