---
title: Switch 开关
description: 用于控制某个功能的开启和关闭。
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

[td_switch_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_switch_page.dart)

### 1 组件类型

基础开关
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSwitchWithBase(BuildContext context) {
    return const TCell(
      title: '基础开关',
      noteWidget: TSwitch(),
    );
  }</pre>

</td-code-block>
                                  

带描述开关
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSwitchWithText(BuildContext context) {
    return const TCell(
      title: '带文字开关',
      noteWidget: TSwitch(
        isOn: true,
        type: TSwitchType.text,
      ),
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSwitchWithIcon(BuildContext context) {
    return const TCell(
      title: '带图标开关',
      noteWidget: TSwitch(
        isOn: true,
        type: TSwitchType.icon,
      ),
    );
  }</pre>

</td-code-block>
                                  

自定义颜色开关
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSwitchWithColor(BuildContext context) {
    return const TCell(
      title: '自定义颜色开关',
      noteWidget: TSwitch(
        isOn: true,
        trackOnColor: Colors.green,
      ),
    );
  }</pre>

</td-code-block>
                                  
### 1 组件状态

加载状态
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSwitchWithLoadingOff(BuildContext context) {
    return const TCell(
      title: '加载状态',
      noteWidget: TSwitch(
        isOn: false,
        type: TSwitchType.loading,
      ),
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSwitchWithLoadingOn(BuildContext context) {
    return const TCell(
      title: '加载状态',
      noteWidget: TSwitch(
        isOn: true,
        type: TSwitchType.loading,
      ),
    );
  }</pre>

</td-code-block>
                                  

禁用状态
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSwitchWithDisableOff(BuildContext context) {
    return const TCell(
      title: '禁用状态',
      noteWidget: TSwitch(
        enable: false,
        isOn: false,
      ),
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSwitchWithDisableOn(BuildContext context) {
    return const TCell(
      title: '禁用状态',
      noteWidget: TSwitch(
        enable: false,
        isOn: true,
      ),
    );
  }</pre>

</td-code-block>
                                  
### 1 组件样式

开关尺寸
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSwitchWithSizeLarge(BuildContext context) {
    return const TCell(
      title: '大尺寸32',
      noteWidget: TSwitch(
        size: TSwitchSize.large,
        isOn: true,
      ),
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSwitchWithSizeMed(BuildContext context) {
    return const TCell(
      title: '中尺寸28',
      noteWidget: TSwitch(
        size: TSwitchSize.medium,
        isOn: true,
      ),
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSwitchWithSizeSmall(BuildContext context) {
    return const TCell(
      title: '小尺寸24',
      noteWidget: TSwitch(
        size: TSwitchSize.small,
        isOn: true,
      ),
    );
  }</pre>

</td-code-block>
                                  


## API
### TSwitch
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| closeText | String? | - | 关闭文案 |
| enable | bool | true | 是否可点击 |
| isOn | bool | false | 是否打开 |
| key |  | - |  |
| onChanged | OnSwitchChanged? | - | 改变事件 |
| openText | String? | - | 打开文案 |
| size | TSwitchSize? | TSwitchSize.medium | 尺寸：大、中、小 |
| thumbContentOffColor | Color? | - | 关闭时ThumbView的颜色 |
| thumbContentOffFont | TextStyle? | - | 关闭时ThumbView的字体样式 |
| thumbContentOnColor | Color? | - | 开启时ThumbView的颜色 |
| thumbContentOnFont | TextStyle? | - | 开启时ThumbView的字体样式 |
| trackOffColor | Color? | - | 关闭时轨道颜色 |
| trackOnColor | Color? | - | 开启时轨道颜色 |
| type | TSwitchType? | TSwitchType.fill | 类型：填充、文本、加载 |


  