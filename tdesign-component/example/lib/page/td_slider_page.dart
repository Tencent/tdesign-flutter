///
///  Created by arvinwli@tencent.com on 4/24/23.
///
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TDSliderPage extends StatefulWidget {
  const TDSliderPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDSliderPageState();
}

class DisplayRangeData {
  final Position currentPosition;
  final double currentTapValue;
  final Offset? tapOffset;
  DisplayRangeData({
    required this.currentPosition,
    required this.currentTapValue,
    this.tapOffset,
  });
}

class _TDSliderPageState extends State<TDSliderPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: tdTitle(),
        desc: '用于选择横轴上的数值、区间、档位。',
        exampleCodeGroup: 'slider',
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        children: [
          ExampleModule(title: '组件类型', children: [
            ExampleItem(desc: '单游标滑块', builder: _buildSingleHandle),
            ExampleItem(desc: '双游标滑块', builder: _buildDoubleHandle),
            ExampleItem(
                desc: '带数值单游标滑块 ', builder: _buildSingleHandleWithNumber),
            ExampleItem(
                desc: '带数值双游标滑块', builder: _buildDoubleHandleWithNumber),
            ExampleItem(desc: '带刻度单游标滑块', builder: _buildSingleHandleWithScale),
            ExampleItem(desc: '带刻度双游标滑块', builder: _buildDoubleHandleWithScale),
          ]),
          ExampleModule(title: '组件状态', children: [
            ExampleItem(desc: '禁用状态', builder: _buildDisableSingleHandle),
            ExampleItem(builder: _buildDisableDoubleHandleWithNumber),
            ExampleItem(builder: _buildDisableDoubleHandleWithScale),
          ]),
          ExampleModule(title: '组件事件', children: [
            ExampleItem(desc: 'onTap', builder: _buildOnTapSingleHandle),
            ExampleItem(builder: _buildOnTapDoubleHandle),
            ExampleItem(
                desc: 'onThumbTextTap',
                builder: _buildOnThumbTextTapSingleHandle),
            ExampleItem(builder: _buildOnThumbTextTapDoubleHandle),
          ]),
          ExampleModule(title: '特殊样式', children: [
            ExampleItem(
                desc: '胶囊型滑块', builder: _buildCapsuleSingleHandleWithNumber),
            ExampleItem(builder: _buildCapsuleDoubleHandle),
            ExampleItem(builder: _buildCapsuleSingleHandle),
            ExampleItem(builder: _buildCapsuleDoubleHandleWithNumber),
            ExampleItem(builder: _buildCapsuleSingleHandleWithScale),
            ExampleItem(builder: _buildCapsuleDoubleHandleWithScale),
            ExampleItem(desc: '胶囊型滑块', builder: _buildCapsule),
            ExampleItem(desc: '自定义盒子样式', builder: _buildCustomDecoration),
            ExampleItem(desc: '自定义滑轨颜色', builder: _buildCustomActiveColor),
          ]),
        ]);
  }

  @Demo(group: 'slider')
  Widget _buildSingleHandle(BuildContext context) {
    return TDSlider(
        sliderThemeData: TDSliderThemeData(
          context: context,
          min: 0,
          max: 100,
        ),
        value: 10,
        onChanged: (value) {});
  }

  @Demo(group: 'slider')
  Widget _buildDoubleHandle(BuildContext context) {
    return TDRangeSlider(
      sliderThemeData: TDSliderThemeData(
        context: context,
        min: 0,
        max: 100,
      ),
      value: const RangeValues(10, 60),
      onChanged: (value) {},
    );
  }

  @Demo(group: 'slider')
  Widget _buildSingleHandleWithNumber(BuildContext context) {
    return TDSlider(
      sliderThemeData: TDSliderThemeData(
        context: context,
        showThumbValue: true,
        scaleFormatter: (value) => value.toInt().toString(),
        min: 0,
        max: 100,
      ),
      value: 10,
      leftLabel: '0',
      rightLabel: '100',
      onChanged: (value) {},
    );
  }

  @Demo(group: 'slider')
  Widget _buildDoubleHandleWithNumber(BuildContext context) {
    return TDRangeSlider(
      sliderThemeData: TDSliderThemeData(
        context: context,
        showThumbValue: true,
        min: 0,
        max: 100,
        scaleFormatter: (value) => value.round().toString(),
      ),
      leftLabel: '0',
      rightLabel: '100',
      value: const RangeValues(40, 60),
      onChanged: (value) {},
    );
  }

  @Demo(group: 'slider')
  Widget _buildSingleHandleWithScale(BuildContext context) {
    return TDSlider(
      sliderThemeData: TDSliderThemeData(
        context: context,
        showScaleValue: true,
        divisions: 5,
        min: 0,
        max: 100,
        scaleFormatter: (value) => value.toInt().toString(),
      ),
      value: 60,
      onChanged: (value) {},
    );
  }

  @Demo(group: 'slider')
  Widget _buildDoubleHandleWithScale(BuildContext context) {
    return TDRangeSlider(
      sliderThemeData: TDSliderThemeData(
        context: context,
        showScaleValue: true,
        divisions: 5,
        min: 0,
        max: 100,
        scaleFormatter: (value) => value.toInt().toString(),
      ),
      value: const RangeValues(40, 70),
      onChanged: (value) {},
    );
  }

  @Demo(group: 'slider')
  Widget _buildDisableSingleHandle(BuildContext context) {
    return TDSlider(
      sliderThemeData: TDSliderThemeData(
        context: context,
        min: 0,
        max: 100,
      ),
      leftLabel: '0',
      rightLabel: '100',
      value: 40,
    );
  }

  @Demo(group: 'slider')
  Widget _buildDisableDoubleHandleWithNumber(BuildContext context) {
    return TDRangeSlider(
      sliderThemeData: TDSliderThemeData(
        context: context,
        showThumbValue: true,
        min: 0,
        max: 100,
        scaleFormatter: (value) => value.toInt().toString(),
      ),
      leftLabel: '0',
      rightLabel: '100',
      value: const RangeValues(20, 60),
    );
  }

  @Demo(group: 'slider')
  Widget _buildDisableDoubleHandleWithScale(BuildContext context) {
    return TDRangeSlider(
      sliderThemeData: TDSliderThemeData(
        context: context,
        showScaleValue: true,
        divisions: 5,
        min: 0,
        max: 100,
        scaleFormatter: (value) => value.toInt().toString(),
      ),
      value: const RangeValues(20, 60),
    );
  }

  @Demo(group: 'slider')
  Widget _buildOnTapSingleHandle(BuildContext context) {
    var currentValue = 40.0;
    Offset? tapOffset;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Value: ${currentValue.toStringAsFixed(1)}'),
                const SizedBox(width: 10),
                if (tapOffset != null)
                  Text(
                      'Tap at (${tapOffset!.dx.toStringAsFixed(0)}, ${tapOffset!.dy.toStringAsFixed(0)})'),
              ],
            ),
            TDSlider(
              sliderThemeData: TDSliderThemeData(
                  context: context, min: 0, max: 100, showThumbValue: true),
              leftLabel: '0',
              rightLabel: '100',
              value: currentValue,
              onChanged: (value) {},
              onTap: (offset, value) {
                setState(() {
                  currentValue = value;
                  tapOffset = offset;
                });
                print('onTap  offset: $offset, value: $value');
              },
            ),
          ],
        );
      },
    );
  }

  @Demo(group: 'slider')
  Widget _buildOnTapDoubleHandle(BuildContext context) {
    final displayRangeDataNotifier = ValueNotifier<DisplayRangeData>(
      DisplayRangeData(
        currentPosition: Position.start,
        currentTapValue: 40.0,
        tapOffset: null,
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder<DisplayRangeData>(
          valueListenable: displayRangeDataNotifier,
          builder: (context, data, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Position: ${data.currentPosition}'),
                const SizedBox(width: 10),
                Text('Value: ${data.currentTapValue.toStringAsFixed(1)}'),
                const SizedBox(width: 10),
                if (data.tapOffset != null)
                  Text(
                      'Tap at (${data.tapOffset!.dx.toStringAsFixed(0)}, ${data.tapOffset!.dy.toStringAsFixed(0)})'),
              ],
            );
          },
        ),
        const SizedBox(height: 10),
        TDRangeSlider(
          sliderThemeData: TDSliderThemeData(
              context: context, min: 0, max: 100, showThumbValue: true),
          leftLabel: '0',
          rightLabel: '100',
          value: const RangeValues(10, 60),
          onChanged: (value) {},
          onTap: (position, offset, value) {
            displayRangeDataNotifier.value = DisplayRangeData(
              currentPosition: position,
              currentTapValue: value,
              tapOffset: offset,
            );
            print('onTap offset: $offset, value: $value');
          },
        ),
      ],
    );
  }

  @Demo(group: 'slider')
  Widget _buildOnThumbTextTapSingleHandle(BuildContext context) {
    var currentValue = 40.0;
    Offset? tapOffset;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Value: ${currentValue.toStringAsFixed(1)}'),
                const SizedBox(width: 10),
                if (tapOffset != null)
                  Text(
                      'Tap at (${tapOffset!.dx.toStringAsFixed(0)}, ${tapOffset!.dy.toStringAsFixed(0)})'),
              ],
            ),
            TDSlider(
              sliderThemeData: TDSliderThemeData(
                context: context,
                min: 0,
                max: 100,
                showThumbValue: true,
              ),
              leftLabel: '0',
              rightLabel: '100',
              value: currentValue,
              onChanged: (value) {},
              onThumbTextTap: (offset, value) {
                setState(() {
                  currentValue = value;
                  tapOffset = offset;
                });
                print('onTap  offset: $offset, value: $value');
              },
            ),
          ],
        );
      },
    );
  }

  @Demo(group: 'slider')
  Widget _buildOnThumbTextTapDoubleHandle(BuildContext context) {
    final displayRangeDataNotifier = ValueNotifier<DisplayRangeData>(
      DisplayRangeData(
        currentPosition: Position.start,
        currentTapValue: 40.0,
        tapOffset: null,
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder<DisplayRangeData>(
          valueListenable: displayRangeDataNotifier,
          builder: (context, data, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Position: ${data.currentPosition}'),
                const SizedBox(width: 10),
                Text('Value: ${data.currentTapValue.toStringAsFixed(1)}'),
                const SizedBox(width: 10),
                if (data.tapOffset != null)
                  Text(
                      'Tap at (${data.tapOffset!.dx.toStringAsFixed(0)}, ${data.tapOffset!.dy.toStringAsFixed(0)})'),
              ],
            );
          },
        ),
        const SizedBox(height: 10),
        TDRangeSlider(
          sliderThemeData: TDSliderThemeData(
              context: context, min: 0, max: 100, showThumbValue: true),
          leftLabel: '0',
          rightLabel: '100',
          value: const RangeValues(10, 60),
          onChanged: (value) {},
          onThumbTextTap: (position, offset, value) {
            displayRangeDataNotifier.value = DisplayRangeData(
              currentPosition: position,
              currentTapValue: value,
              tapOffset: offset,
            );
            print('onTap offset: $offset, value: $value');
          },
        ),
      ],
    );
  }

  @Demo(group: 'slider')
  Widget _buildCapsuleSingleHandleWithNumber(BuildContext context) {
    return TDSlider(
      sliderThemeData: TDSliderThemeData.capsule(
        context: context,
        showThumbValue: true,
        min: 0,
        max: 100,
        scaleFormatter: (value) => value.toInt().toString(),
      ),
      value: 40,
      onChanged: (value) {},
    );
  }

  @Demo(group: 'slider')
  Widget _buildCapsuleDoubleHandle(BuildContext context) {
    return TDRangeSlider(
      sliderThemeData: TDSliderThemeData.capsule(
        context: context,
        min: 0,
        max: 100,
        scaleFormatter: (value) => value.toInt().toString(),
      ),
      value: const RangeValues(20, 60),
      onChanged: (value) {},
    );
  }

  @Demo(group: 'slider')
  Widget _buildCapsuleSingleHandle(BuildContext context) {
    return TDSlider(
      sliderThemeData: TDSliderThemeData.capsule(
        context: context,
        min: 0,
        max: 100,
        scaleFormatter: (value) => value.toInt().toString(),
      ),
      leftLabel: '0',
      rightLabel: '100',
      value: 40,
      onChanged: (value) {},
    );
  }

  @Demo(group: 'slider')
  Widget _buildCapsuleDoubleHandleWithNumber(BuildContext context) {
    return TDRangeSlider(
      sliderThemeData: TDSliderThemeData.capsule(
        context: context,
        showThumbValue: true,
        min: 0,
        max: 100,
        scaleFormatter: (value) => value.toInt().toString(),
      ),
      leftLabel: '0',
      rightLabel: '100',
      value: const RangeValues(20, 60),
      onChanged: (value) {},
    );
  }

  @Demo(group: 'slider')
  Widget _buildCapsuleSingleHandleWithScale(BuildContext context) {
    return TDSlider(
      sliderThemeData: TDSliderThemeData.capsule(
        context: context,
        showScaleValue: true,
        divisions: 5,
        min: 0,
        max: 100,
        scaleFormatter: (value) => value.toInt().toString(),
      )..updateSliderThemeData((data) => data.copyWith(
            activeTickMarkColor: const Color(0xFFE7E7E7),
            inactiveTickMarkColor: const Color(0xFFE7E7E7),
          )),
      value: 60,
      onChanged: (value) {},
    );
  }

  @Demo(group: 'slider')
  Widget _buildCapsule(BuildContext context) {
    return Column(
      children: [
        TDSlider(
          sliderThemeData: TDSliderThemeData.capsule(
            context: context,
            showThumbValue: true,
            min: 0,
            max: 100,
            scaleFormatter: (value) => value.toInt().toString(),
          ),
          value: 40,
          // divisions: 5,
          onChanged: (value) {},
        ),
        const SizedBox(
          height: 16,
        ),
        TDRangeSlider(
          sliderThemeData: TDSliderThemeData.capsule(
            context: context,
            min: 0,
            max: 100,
            scaleFormatter: (value) => value.toInt().toString(),
          ),
          value: const RangeValues(20, 60),
          // divisions: 5,
          onChanged: (value) {},
        ),
        const SizedBox(
          height: 16,
        ),
        TDSlider(
          sliderThemeData: TDSliderThemeData.capsule(
            context: context,
            min: 0,
            max: 100,
            scaleFormatter: (value) => value.toInt().toString(),
          ),
          leftLabel: '0',
          rightLabel: '100',
          value: 40,
          // divisions: 5,
          onChanged: (value) {},
        ),
        const SizedBox(
          height: 16,
        ),
        TDRangeSlider(
          sliderThemeData: TDSliderThemeData.capsule(
            context: context,
            min: 0,
            max: 100,
            showThumbValue: true,
            scaleFormatter: (value) => value.toInt().toString(),
          ),
          value: const RangeValues(20, 60),
          leftLabel: '0',
          rightLabel: '100',
          // divisions: 5,
          onChanged: (value) {},
        ),
        const SizedBox(
          height: 16,
        ),
        TDSlider(
          sliderThemeData: TDSliderThemeData.capsule(
            context: context,
            showScaleValue: true,
            divisions: 5,
            min: 0,
            max: 100,
            scaleFormatter: (value) => value.toInt().toString(),
          )..updateSliderThemeData((data) => data.copyWith(
                activeTickMarkColor: const Color(0xFFE7E7E7),
                inactiveTickMarkColor: const Color(0xFFE7E7E7),
              )),
          value: 60,
          // divisions: 5,
          onChanged: (value) {},
        ),
        const SizedBox(
          height: 16,
        ),
        TDRangeSlider(
          sliderThemeData: TDSliderThemeData.capsule(
            context: context,
            showScaleValue: true,
            divisions: 5,
            min: 0,
            max: 100,
            scaleFormatter: (value) => value.toInt().toString(),
          )..updateSliderThemeData((data) => data.copyWith(
                activeTickMarkColor: const Color(0xFFE7E7E7),
                inactiveTickMarkColor: const Color(0xFFE7E7E7),
              )),
          value: const RangeValues(20, 60),
          // divisions: 5,
          onChanged: (value) {},
        )
      ],
    );
  }

  @Demo(group: 'slider')
  Widget _buildCustomDecoration(BuildContext context) {
    return Column(
      children: [
        TDSlider(
          sliderThemeData: TDSliderThemeData(
            context: context,
            min: 0,
            max: 100,
          ),
          value: 40,
          boxDecoration: const BoxDecoration(color: Colors.amber),
          // divisions: 5,
          onChanged: (value) {},
        ),
        const SizedBox(
          height: 16,
        ),
        TDRangeSlider(
          sliderThemeData: TDSliderThemeData.capsule(
            context: context,
            min: 0,
            max: 100,
            scaleFormatter: (value) => value.toInt().toString(),
          ),
          boxDecoration: const BoxDecoration(color: Colors.deepOrangeAccent),
          value: const RangeValues(20, 60),
          onChanged: (value) {},
        ),
      ],
    );
  }

  @Demo(group: 'slider')
  Widget _buildCapsuleDoubleHandleWithScale(BuildContext context) {
    return TDRangeSlider(
      sliderThemeData: TDSliderThemeData.capsule(
        context: context,
        showScaleValue: true,
        divisions: 5,
        min: 0,
        max: 100,
        scaleFormatter: (value) => value.toInt().toString(),
      )..updateSliderThemeData((data) => data.copyWith(
            activeTickMarkColor: const Color(0xFFE7E7E7),
            inactiveTickMarkColor: const Color(0xFFE7E7E7),
          )),
      value: const RangeValues(20, 60),
      onChanged: (value) {},
    );
  }

  @Demo(group: 'slider')
  Widget _buildCustomActiveColor(BuildContext context) {
    return Column(
      children: [
        TDSlider(
          sliderThemeData: TDSliderThemeData(
            activeTrackColor: Colors.red,
            inactiveTrackColor: Colors.green,
            context: context,
            min: 0,
            max: 100,
          ),
          value: 40,
          // divisions: 5,
          onChanged: (value) {},
        ),
        const SizedBox(
          height: 16,
        ),
        TDRangeSlider(
          sliderThemeData: TDSliderThemeData.capsule(
            activeTrackColor: Colors.green,
            inactiveTrackColor: Colors.red,
            context: context,
            min: 0,
            max: 100,
            scaleFormatter: (value) => value.toInt().toString(),
          ),
          value: const RangeValues(20, 60),
          onChanged: (value) {},
        ),
      ],
    );
  }
}
