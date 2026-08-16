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

[t_loading_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/t_loading_page.dart)

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
        Theme(
          data: Theme.of(context).mergeExtension(
            TLoadingThemeData(
              iconColor: context.tTheme.brandNormalColor,
            ),
          ),
          child: const TLoading(
            size: TLoadingSize.small,
            icon: TLoadingIcon.point,
          ),
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  

图标加文字横向
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildTextIconHorizontalLoading(BuildContext context) {
    return Row(
      // spacing: 36,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Theme(
          data: Theme.of(context)
              .mergeExtension(const TLoadingThemeData(axis: Axis.horizontal)),
          child: const TLoading(
            size: TLoadingSize.small,
            icon: TLoadingIcon.circle,
            text: '加载中…',
          ),
        ),
        const SizedBox(width: 36),
        Theme(
          data: Theme.of(context)
              .mergeExtension(const TLoadingThemeData(axis: Axis.horizontal)),
          child: const TLoading(
            size: TLoadingSize.small,
            icon: TLoadingIcon.activity,
            text: '加载中…',
          ),
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  

图标加文字竖向
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildTextIconVerticalLoading(BuildContext context) {
    return Row(
      // spacing: 36,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Theme(
          data: Theme.of(context)
              .mergeExtension(const TLoadingThemeData(axis: Axis.vertical)),
          child: const TLoading(
            size: TLoadingSize.small,
            icon: TLoadingIcon.circle,
            text: '加载中…',
          ),
        ),
        const SizedBox(width: 36),
        Theme(
          data: Theme.of(context)
              .mergeExtension(const TLoadingThemeData(axis: Axis.vertical)),
          child: const TLoading(
            size: TLoadingSize.small,
            icon: TLoadingIcon.activity,
            text: '加载中…',
          ),
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
        Theme(
          data: Theme.of(context).mergeExtension(
            TLoadingThemeData(
              textColor: context.tTheme.textColorPlaceholder,
            ),
          ),
          child: const TLoading(
            size: TLoadingSize.small,
            text: '加载失败',
          ),
        ),
        const SizedBox(width: 36),
        Theme(
          data: Theme.of(context).mergeExtension(
            const TLoadingThemeData(),
          ),
          child: const TLoading(
            size: TLoadingSize.small,
            text: '加载失败',
            refreshWidget: Text('刷新'),
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
    return Theme(
      data: Theme.of(context)
          .mergeExtension(const TLoadingThemeData(axis: Axis.horizontal)),
      child: const TLoading(
        size: TLoadingSize.large,
        icon: TLoadingIcon.circle,
        text: '加载中…',
      ),
    );
  }</pre>

</td-code-block>
                                  

中尺寸
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildMediumLoading(BuildContext context) {
    return Theme(
      data: Theme.of(context)
          .mergeExtension(const TLoadingThemeData(axis: Axis.horizontal)),
      child: const TLoading(
        size: TLoadingSize.medium,
        icon: TLoadingIcon.circle,
        text: '加载中…',
      ),
    );
  }</pre>

</td-code-block>
                                  

小尺寸
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSmallLoading(BuildContext context) {
    return Theme(
      data: Theme.of(context)
          .mergeExtension(const TLoadingThemeData(axis: Axis.horizontal)),
      child: const TLoading(
        size: TLoadingSize.small,
        icon: TLoadingIcon.circle,
        text: '加载中…',
      ),
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
        Theme(
          data: Theme.of(context).mergeExtension(
            TLoadingThemeData(
              axis: Axis.horizontal,
              duration: _currentSliderValue.round(),
            ),
          ),
          child: const TLoading(
            size: TLoadingSize.small,
            icon: TLoadingIcon.circle,
            text: '加载中…',
          ),
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
| customIcon | Widget? | - | 自定义图标，优先级高于icon |
| icon | TLoadingIcon? | TLoadingIcon.circle | 图标，支持圆形、点状、菊花状 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| refreshWidget | Widget? | - | 失败刷新组件 |
| size | TLoadingSize | - | 尺寸 |
| text | String? | - | 文案 |

### TLoadingThemeData

Loading 的视觉配置通过 `TLoadingThemeData` 注入到子树（`Theme.of(context).mergeExtension(...)`），字段均为可选，未指定时使用默认值。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| axis | Axis | Axis.horizontal | 文案和图标相对方向。默认 horizontal（图标在左、文字在右），对齐官方 `layout`；可显式指定 `Axis.vertical` 实现竖向布局。 |
| duration | int | 800 | 一次刷新的时间（毫秒），控制动画速度。默认 `800`ms，对齐官方 `duration`。 |
| iconColor | Color? | - | 图标颜色 |
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


  