---
title: Loading 加载
description: 用于表示页面或操作的加载状态，给予用户反馈的同时减缓等待的焦虑感，由一个或一组反馈动效组成。
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

[td_loading_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_loading_page.dart)

### 1 组件类型

纯图标
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPureIconLoading(BuildContext context) {
    return _buildRow([
      const TDLoading(
        size: TDLoadingSize.small,
        icon: TDLoadingIcon.circle,
      ),
      const TDLoading(
        size: TDLoadingSize.small,
        icon: TDLoadingIcon.activity,
      ),
      TDLoading(
        size: TDLoadingSize.small,
        icon: TDLoadingIcon.point,
        iconColor: TDTheme.of(context).brandNormalColor,
      ),
    ]);
  }</pre>

</td-code-block>
                                  

图标加文字横向
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildTextIconHorizontalLoading(BuildContext context) {
    return _buildRow(const [
      TDLoading(
        size: TDLoadingSize.small,
        icon: TDLoadingIcon.circle,
        text: '加载中…',
        axis: Axis.horizontal,
      ),
      TDLoading(
        size: TDLoadingSize.small,
        icon: TDLoadingIcon.activity,
        text: '加载中…',
        axis: Axis.horizontal,
      ),
    ]);
  }</pre>

</td-code-block>
                                  

图标加文字竖向
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildTextIconVerticalLoading(BuildContext context) {
    return _buildRow(const [
      TDLoading(
        size: TDLoadingSize.small,
        icon: TDLoadingIcon.circle,
        text: '加载中…',
        axis: Axis.vertical,
      ),
      TDLoading(
        size: TDLoadingSize.small,
        icon: TDLoadingIcon.activity,
        text: '加载中…',
        axis: Axis.vertical,
      ),
    ]);
  }</pre>

</td-code-block>
                                  

纯文字
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPureTextLoading(BuildContext context) {
    return _buildRow([
      const TDLoading(
        size: TDLoadingSize.small,
        text: '加载中…',
      ),
      TDLoading(
        size: TDLoadingSize.small,
        text: '加载失败',
        textColor: TDTheme.of(context).fontGyColor3,
      ),
      TDLoading(
        size: TDLoadingSize.small,
        text: '加载失败',
        refreshWidget: GestureDetector(
          child: TDText(
            '刷新',
            font: TDTheme.of(context).fontBodySmall,
            textColor: TDTheme.of(context).brandNormalColor,
          ),
          onTap: () {
            TDToast.showText('刷新', context: context);
          },
        ),
      ),
    ]);
  }</pre>

</td-code-block>
                                  
### 1 组件尺寸

大尺寸
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLargeLoading(BuildContext context) {
    return _buildRow([
      const TDLoading(
        size: TDLoadingSize.large,
        icon: TDLoadingIcon.circle,
        text: '加载中…',
        axis: Axis.horizontal,
      ),
    ]);
  }</pre>

</td-code-block>
                                  

中尺寸
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildMediumLoading(BuildContext context) {
    return _buildRow([
      const TDLoading(
        size: TDLoadingSize.medium,
        icon: TDLoadingIcon.circle,
        text: '加载中…',
        axis: Axis.horizontal,
      ),
    ]);
  }</pre>

</td-code-block>
                                  

小尺寸
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSmallLoading(BuildContext context) {
    return _buildRow([
      const TDLoading(
        size: TDLoadingSize.small,
        icon: TDLoadingIcon.circle,
        text: '加载中…',
        axis: Axis.horizontal,
      ),
    ]);
  }</pre>

</td-code-block>
                                  
### 1 加载速度

调整加载速度
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCustomSpeedLoading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TDLoading(
            size: TDLoadingSize.small,
            icon: TDLoadingIcon.circle,
            axis: Axis.horizontal,
            text: '加载中…',
            duration: _currentSliderValue.round(),
          ),
          TDSlider(value: _currentSliderValue,
            sliderThemeData: TDSliderThemeData(
              context: context,
              max: 2000,
              min: -20,
              divisions: 100,
              showThumbValue: true,
              scaleFormatter: (value) => value.toInt().toString(),
            ),
            onChanged: (double value) {
              setState(() {
                _currentSliderValue = value;
              });
            },)
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  


## API
### TDLoading
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| size | TDLoadingSize | - | 尺寸 |
| icon | TDLoadingIcon? | TDLoadingIcon.circle | 图标，支持圆形、点状、菊花状 |
| iconColor | Color? | - | 图标颜色 |
| axis | Axis | Axis.vertical | 文案和图标相对方向 |
| text | String? | - | 文案 |
| refreshWidget | Widget? | - | 失败刷新组件 |
| customIcon | Widget? | - | 自定义图标，优先级高于icon |
| textColor | Color | Colors.black | 文案颜色 |
| duration | int | 2000 | 一次刷新的时间，控制动画速度 |


  