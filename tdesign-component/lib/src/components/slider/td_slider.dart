///
///  Created by arvinwli@tencent.com on 4/24/23.
///
import 'package:flutter/material.dart';
import 'td_slider_theme.dart';

enum Position {
  start,
  end,
}

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

  ///  Thumb 点击事件 坐标、当前值
  final Function(Offset offset, double value)? onTap;

  ///  Thumb 点击浮标文字 坐标、当前值
  final Function(Offset offset, double value)? onThumbTextTap;

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
      this.onTap,
      this.onThumbTextTap})
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
    return Listener(
        onPointerDown: (event) {
          final sliderBox =
              _sliderKey.currentContext?.findRenderObject() as RenderBox?;
          if (sliderBox == null ||
              widget.onThumbTextTap == null ||
              !tdSliderThemeData.showThumbValue) {
            return;
          }

          final localOffset = sliderBox.globalToLocal(event.position);
          final themeData = widget.sliderThemeData ?? TDSliderThemeData();
          final textRect = themeData.sliderMeasureData.thumbTextRect;

          if (textRect != null && textRect.contains(localOffset)) {
            widget.onThumbTextTap?.call(localOffset, value);
          }
        },
        child: Container(
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

                    final sliderBox = _sliderKey.currentContext
                        ?.findRenderObject() as RenderBox?;
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
        ));
  }
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

  //  Thumb 点击事件 位置、坐标、当前值
  final Function(Position position, Offset offset, double value)? onTap;

  ///  Thumb 点击浮标文字 位置、坐标、当前值
  final Function(Position position, Offset offset, double value)?
      onThumbTextTap;

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
      this.onTap,
      this.onThumbTextTap})
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

    return Listener(
      onPointerDown: (event) {
        final sliderBox =
            _sliderRangeKey.currentContext?.findRenderObject() as RenderBox?;
        final localOffset =
            sliderBox?.globalToLocal(event.position) ?? Offset.zero;

        if (sliderBox == null ||
            widget.onThumbTextTap == null ||
            !tdSliderThemeData.showThumbValue) {
          return;
        }

        final themeData = widget.sliderThemeData ?? TDSliderThemeData();
        final startTextRect =
            themeData.sliderMeasureData.startRangeThumbTextRect;
        final endTextRect = themeData.sliderMeasureData.endRangeThumbTextRect;

        if (startTextRect?.contains(localOffset) ?? false) {
          widget.onThumbTextTap?.call(Position.start, localOffset, rangeValues.start);
        }
        if (endTextRect?.contains(localOffset) ?? false) {
          widget.onThumbTextTap?.call(Position.end, localOffset, rangeValues.end);
        }
      },
      child: Container(
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

                  final tapOffset = sliderBox.globalToLocal(event.position);
                  final sliderWidth = sliderBox.size.width;

                  final sliderTheme = SliderTheme.of(context);
                  final thumbShape = sliderTheme.rangeThumbShape;
                  final thumbSize = thumbShape?.getPreferredSize(
                        enabled,
                        widget.sliderThemeData?.divisions != null,
                      ) ??
                      const Size(20, 20);

                  final thumbRadius = thumbSize.width / 2;

                  // 计算当前值对应的坐标比例
                  final min = widget.sliderThemeData?.min ?? 0;
                  final max = widget.sliderThemeData?.max ?? 100;
                  final startRatio = (rangeValues.start - min) / (max - min);
                  final endRatio = (rangeValues.end - min) / (max - min);

                  // 计算Thumb中心坐标
                  final startCenterX = startRatio * sliderWidth;
                  final endCenterX = endRatio * sliderWidth;
                  final verticalCenter = sliderBox.size.height / 2;

                  // 检测点击区域
                  final isStartTap =
                      (tapOffset.dx - startCenterX).abs() <= thumbRadius &&
                          (tapOffset.dy - verticalCenter).abs() <= thumbRadius;
                  final isEndTap =
                      (tapOffset.dx - endCenterX).abs() <= thumbRadius &&
                          (tapOffset.dy - verticalCenter).abs() <= thumbRadius;

                  Position position;
                  double tappedValue;

                  if (isStartTap) {
                    position = Position.start;
                    tappedValue = rangeValues.start;
                  } else if (isEndTap) {
                    position = Position.end;
                    tappedValue = rangeValues.end;
                  } else {
                    tappedValue =
                        (tapOffset.dx / sliderWidth) * (max - min) + min;
                    final startDistance =
                        (tappedValue - rangeValues.start).abs();
                    final endDistance = (tappedValue - rangeValues.end).abs();
                    position = startDistance < endDistance
                        ? Position.start
                        : Position.end;
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
      ),
    );
  }
}
