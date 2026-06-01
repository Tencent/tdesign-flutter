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
    return Row(
      // spacing: 36,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const TLoading(
          size: TLoadingSize.small,
          icon: TLoadingIcon.circle,
        ),
        const SizedBox(width: 36),
        const TLoading(
          size: TLoadingSize.small,
          icon: TLoadingIcon.activity,
        ),
        const SizedBox(width: 36),
        TLoading(
          size: TLoadingSize.small,
          icon: TLoadingIcon.point,
          iconColor: TTheme.of(context).brandNormalColor,
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  

图标加文字横向
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildTextIconHorizontalLoading(BuildContext context) {
    return const Row(
      // spacing: 36,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TLoading(
          size: TLoadingSize.small,
          icon: TLoadingIcon.circle,
          text: '加载中…',
          axis: Axis.horizontal,
        ),
        const SizedBox(width: 36),
        TLoading(
          size: TLoadingSize.small,
          icon: TLoadingIcon.activity,
          text: '加载中…',
          axis: Axis.horizontal,
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  

图标加文字竖向
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildTextIconVerticalLoading(BuildContext context) {
    return const Row(
      // spacing: 36,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TLoading(
          size: TLoadingSize.small,
          icon: TLoadingIcon.circle,
          text: '加载中…',
          axis: Axis.vertical,
        ),
        SizedBox(width: 36),
        TLoading(
          size: TLoadingSize.small,
          icon: TLoadingIcon.activity,
          text: '加载中…',
          axis: Axis.vertical,
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  

纯文字
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPureTextLoading(BuildContext context) {
    return Row(
      // spacing: 36,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const TLoading(
          size: TLoadingSize.small,
          text: '加载中…',
        ),
        const SizedBox(width: 36),
        TLoading(
          size: TLoadingSize.small,
          text: '加载失败',
          textColor: TTheme.of(context).textColorPlaceholder,
        ),
        const SizedBox(width: 36),
        TLoading(
          size: TLoadingSize.small,
          text: '加载失败',
          refreshWidget: GestureDetector(
            child: TText(
              '刷新',
              font: TTheme.of(context).fontBodySmall,
              textColor: TTheme.of(context).brandNormalColor,
            ),
            onTap: () {
              TToast.showText('刷新', context: context);
            },
          ),
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  
### 1 组件尺寸

大尺寸
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLargeLoading(BuildContext context) {
    return const TLoading(
      size: TLoadingSize.large,
      icon: TLoadingIcon.circle,
      text: '加载中…',
      axis: Axis.horizontal,
    );
  }</pre>

</td-code-block>
                                  

中尺寸
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildMediumLoading(BuildContext context) {
    return const TLoading(
      size: TLoadingSize.medium,
      icon: TLoadingIcon.circle,
      text: '加载中…',
      axis: Axis.horizontal,
    );
  }</pre>

</td-code-block>
                                  

小尺寸
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSmallLoading(BuildContext context) {
    return const TLoading(
      size: TLoadingSize.small,
      icon: TLoadingIcon.circle,
      text: '加载中…',
      axis: Axis.horizontal,
    );
  }</pre>

</td-code-block>
                                  
### 1 加载速度

调整加载速度
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCustomSpeedLoading(BuildContext context) {
    return Column(
      // spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TLoading(
          size: TLoadingSize.small,
          icon: TLoadingIcon.circle,
          axis: Axis.horizontal,
          text: '加载中…',
          duration: _currentSliderValue.round(),
        ),
        const SizedBox(height: 16),
        TSlider(
          value: _currentSliderValue,
          sliderThemeData: TSliderThemeData(
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
          },
        )
      ],
    );
  }</pre>

</td-code-block>
                                  


## API
### TLoading
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| axis | Axis | Axis.vertical | 文案和图标相对方向 |
| customIcon | Widget? | - | 自定义图标，优先级高于icon |
| duration | int | 2000 | 一次刷新的时间，控制动画速度 |
| icon | TLoadingIcon? | TLoadingIcon.circle | 图标，支持圆形、点状、菊花状 |
| iconColor | Color? | - | 图标颜色 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| refreshWidget | Widget? | - | 失败刷新组件 |
| size | TLoadingSize | - | 尺寸 |
| text | String? | - | 文案 |
| textColor | Color? | - | 文案颜色 |


### TLoadingSize
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| small | 小尺寸 |
| medium | 中尺寸 |
| large | 大尺寸 |


### TLoadingIcon
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| circle | 圆形 |
| point | 点状 |
| activity | 菊花状 |


  