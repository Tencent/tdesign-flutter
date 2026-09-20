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
      mainAxisSize: MainAxisSize.min,
      children: [
        const TLoading(icon: TLoadingIcon.circle),
        const SizedBox(width: 40),
        const TLoading(icon: TLoadingIcon.activity),
        const SizedBox(width: 40),
        Theme(
          data: Theme.of(context).mergeExtension(
            TLoadingThemeData(iconColor: context.tTheme.brandNormalColor),
          ),
          child: const TLoading(size: 40, icon: TLoadingIcon.point),
        ),
        const SizedBox(width: 40),
        Theme(
          data: Theme.of(context).mergeExtension(
            TLoadingThemeData(iconColor: context.tTheme.brandNormalColor),
          ),
          child: const TLoading(
            customIcon: Image(
              image: AssetImage('assets/img/loading-logo2.png'),
              fit: BoxFit.contain,
            ),
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Theme(
          data: Theme.of(
            context,
          ).mergeExtension(const TLoadingThemeData(axis: Axis.horizontal)),
          child: const TLoading(icon: TLoadingIcon.circle, text: '加载中...'),
        ),
        const SizedBox(width: 64),
        Theme(
          data: Theme.of(
            context,
          ).mergeExtension(const TLoadingThemeData(axis: Axis.horizontal)),
          child: const TLoading(icon: TLoadingIcon.activity, text: '加载中...'),
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Theme(
          data: Theme.of(
            context,
          ).mergeExtension(const TLoadingThemeData(axis: Axis.vertical)),
          child: const TLoading(icon: TLoadingIcon.circle, text: '加载中'),
        ),
        const SizedBox(width: 64),
        Theme(
          data: Theme.of(
            context,
          ).mergeExtension(const TLoadingThemeData(axis: Axis.vertical)),
          child: const TLoading(icon: TLoadingIcon.activity, text: '加载中'),
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  

纯文字
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPureTextLoading(BuildContext context) =>
      const TLoading(icon: null, text: '加载中...');</pre>

</td-code-block>
                                  
### 2 组件尺寸

大尺寸

<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLoadingSizes(BuildContext context) {
    Widget loading(double size) => Theme(
      data: Theme.of(
        context,
      ).mergeExtension(const TLoadingThemeData(axis: Axis.horizontal)),
      child: TLoading(size: size, icon: TLoadingIcon.circle, text: '加载中...'),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        loading(32),
        const SizedBox(height: 24),
        const Text('中尺寸'),
        const SizedBox(height: 16),
        loading(28),
        const SizedBox(height: 24),
        const Text('小尺寸'),
        const SizedBox(height: 16),
        loading(24),
      ],
    );
  }</pre>

</td-code-block>

### 3 加载速度

加载速度调整
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCustomSpeedLoading(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Theme(
          data: Theme.of(context).mergeExtension(
            TLoadingThemeData(
              axis: Axis.horizontal,
              duration: (2000 - _currentSliderValue).round(),
            ),
          ),
          child: const TLoading(
            size: 26,
            icon: TLoadingIcon.circle,
            text: '加载中...',
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            const min = 100.0;
            const max = 1500.0;
            const trackInset = 24.0;
            const labelWidth = 48.0;
            final progress = (_currentSliderValue - min) / (max - min);
            final trackWidth = constraints.maxWidth - trackInset * 2;
            final thumbCenter = trackInset + trackWidth * progress;
            final labelLeft = (thumbCenter - labelWidth / 2).clamp(
              0.0,
              constraints.maxWidth - labelWidth,
            );
            return SizedBox(
              height: 64,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: labelLeft,
                    width: labelWidth,
                    child: Text(
                      '${_currentSliderValue.round()}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: TSlider(
                      value: _currentSliderValue,
                      min: min,
                      max: max,
                      divisions: 100,
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  


## API
### TLoading
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| customIcon | Widget? | - | 自定义加载图标，优先于 icon，并按当前 Loading 动画时长持续旋转。 |
| icon | TLoadingIcon? | TLoadingIcon.circle | 预设图标，支持圆形、点状、菊花状；为 null 时不显示预设图标。customIcon 不为 null 时仍优先显示自定义图标。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| refreshWidget | Widget? | - | 文案后的自定义操作内容 |
| size | double | 20 | 加载指示器的外部尺寸，单位为逻辑像素，默认为 20。 |
| text | String? | - | 文案 |

### TLoadingThemeData

Loading 的视觉配置通过 `TLoadingThemeData` 注入到子树（`Theme.of(context).mergeExtension(...)`），字段均为可选，未指定时使用默认值。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| axis | Axis | Axis.horizontal | 文案和图标相对方向。默认 horizontal（图标在左、文字在右），对齐官方 `layout`；可显式指定 `Axis.vertical` 实现竖向布局。 |
| duration | int | 800 | 一次刷新的时间（毫秒），控制动画速度。默认 `800`ms，对齐官方 `duration`。 |
| iconColor | Color? | - | 图标颜色 |
| textColor | Color? | - | 文案颜色 |

### TLoadingIcon
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| circle | 圆形 |
| point | 点状 |
| activity | 菊花状 |
