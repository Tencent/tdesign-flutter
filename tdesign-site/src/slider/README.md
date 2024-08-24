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
        min: 0,
        max: 100,
      ),
      value: 10,
      // divisions: 5,
      onChanged: (value) {},
    );
  }</pre>

</td-code-block>
                                  

双游标滑块
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildDoubleHandle(BuildContext context) {
    return TDRangeSlider(
      sliderThemeData: TDSliderThemeData(
        min: 0,
        max: 100,
      ),
      value: const RangeValues(10, 60),
      // divisions: 5,
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
        showThumbValue: true,
        scaleFormatter: (value) => value.toInt().toString(),
        min: 0,
        max: 100,
      ),
      value: 10,
      leftLabel: '0',
      rightLabel: '100',
      // divisions: 5,
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
        showThumbValue: true,
        min: 0,
        max: 100,
        scaleFormatter: (value) => value.round().toString(),
      ),
      leftLabel: '0',
      rightLabel: '100',
      value: const RangeValues(40, 60),
      // divisions: 5,
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
        showScaleValue: true,
        divisions: 5,
        min: 0,
        max: 100,
        scaleFormatter: (value) => value.toInt().toString(),
      ),
      value: 60,
      // divisions: 5,
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
        showScaleValue: true,
        divisions: 5,
        min: 0,
        max: 100,
        scaleFormatter: (value) => value.toInt().toString(),
      ),
      value: const RangeValues(40, 70),
      // divisions: 5,
      onChanged: (value) {},
    );
  }</pre>

</td-code-block>
                                  
### 1 组件状态

禁用状态
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildDisable(BuildContext context) {
    return Column(
      children: [
        TDSlider(
          sliderThemeData: TDSliderThemeData(
            min: 0,
            max: 100,
          ),
          value: 40,
          leftLabel: '0',
          rightLabel: '100',
        ),
        const SizedBox(
          height: 16,
        ),
        TDRangeSlider(
          sliderThemeData: TDSliderThemeData(
            min: 0,
            max: 100,
            showThumbValue: true,
            scaleFormatter: (value) => value.toInt().toString(),
          ),
          value: const RangeValues(20, 60),
          leftLabel: '0',
          rightLabel: '100',
        ),
        const SizedBox(
          height: 16,
        ),
        TDRangeSlider(
          sliderThemeData: TDSliderThemeData(
            showScaleValue: true,
            divisions: 5,
            min: 0,
            max: 100,
            scaleFormatter: (value) => value.toInt().toString(),
          ),
          value: const RangeValues(20, 60),
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  
### 1 特殊样式

胶囊型滑块
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCapsule(BuildContext context) {
    return Column(
      children: [
        TDSlider(
          sliderThemeData: TDSliderThemeData.capsule(
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
            showScaleValue: true,
            divisions: 5,
            min: 0,
            max: 100,
            scaleFormatter: (value) => value.toInt().toString(),
          )
            ..updateSliderThemeData((data) =>
                data.copyWith(
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
            min: 0,
            max: 100,
          ),
          value: 40,
          boxDecoration: BoxDecoration(
             color: Colors.amber
          ),
          // divisions: 5,
          onChanged: (value) {},
        ),
        const SizedBox(
          height: 16,
        ),
        TDRangeSlider(
          sliderThemeData: TDSliderThemeData.capsule(
            min: 0,
            max: 100,
            scaleFormatter: (value) => value.toInt().toString(),
          ),
          boxDecoration: BoxDecoration(
              color: Colors.deepOrangeAccent
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


  