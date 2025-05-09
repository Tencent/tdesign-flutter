---
title: Slider 滑动选择器
description: 用于选择横轴上的数值、区间、档位。
spline: base
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

在tdesign_flutter/tdesign_flutter.dart中有所有组件的路径。

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

[td_slider_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_slider_page.dart)

### 1 组件类型

单游标滑块
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSingleHandle(BuildContext context) {
    return TDSlider(
        sliderThemeData: TDSliderThemeData(
          context: context,
          min: 0,
          max: 100,
        ),
        value: 10,
        onChanged: (value) {});
  }</pre>

</td-code-block>
                                  

双游标滑块
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
  }</pre>

</td-code-block>
                                  

带数值单游标滑块 
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
  }</pre>

</td-code-block>
                                  

带数值双游标滑块
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
  }</pre>

</td-code-block>
                                  

带刻度单游标滑块
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
  }</pre>

</td-code-block>
                                  

带刻度双游标滑块
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
  }</pre>

</td-code-block>
                                  
### 1 组件状态

禁用状态
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
  }</pre>

</td-code-block>
                                  
### 1 组件事件

onTap
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
  }</pre>

</td-code-block>
                                  

onThumbTextTap
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
  }</pre>

</td-code-block>
                                  
### 1 特殊样式

胶囊型滑块
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
  }</pre>

</td-code-block>
                                  

胶囊型滑块
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
  }</pre>

</td-code-block>
                                  

自定义盒子样式
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
  }</pre>

</td-code-block>
                                  

自定义滑轨颜色
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
  }</pre>

</td-code-block>
                                  


## API
### TDSlider
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| value | RangeValues | - | 默认值 |
| boxDecoration | Decoration? | - | 自定义盒子样式 |
| onChanged | ValueChanged<RangeValues>? | - | 滑动变化监听 |
| sliderThemeData | TDSliderThemeData? | - | 样式 |
| leftLabel | String? | - | 左侧标签 |
| rightLabel | String? | - | 右侧标签 |
| onChangeStart | ValueChanged<RangeValues>? | - | 滑动开始监听 |
| onChangeEnd | ValueChanged<RangeValues>? | - | 滑动结束监听 |
| onTap |  Function(Position position, Offset offset, double value)? | - |  |
| onThumbTextTap |  Function(Position position, Offset offset, double value)? | - | Thumb 点击浮标文字 位置、坐标、当前值 |

```
```
 ### TDRangeSlider
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| value | RangeValues | - | 默认值 |
| boxDecoration | Decoration? | - | 自定义盒子样式 |
| onChanged | ValueChanged<RangeValues>? | - | 滑动变化监听 |
| sliderThemeData | TDSliderThemeData? | - | 样式 |
| leftLabel | String? | - | 左侧标签 |
| rightLabel | String? | - | 右侧标签 |
| onChangeStart | ValueChanged<RangeValues>? | - | 滑动开始监听 |
| onChangeEnd | ValueChanged<RangeValues>? | - | 滑动结束监听 |
| onTap |  Function(Position position, Offset offset, double value)? | - |  |
| onThumbTextTap |  Function(Position position, Offset offset, double value)? | - | Thumb 点击浮标文字 位置、坐标、当前值 |


  