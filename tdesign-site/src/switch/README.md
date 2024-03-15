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

### 1 组件类型

基础开关
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSwitchWithBase(BuildContext context) {
    return _buildItem(
      context,
      const TDSwitch(),
      title: '基础开关',
    );
  }</pre>

</td-code-block>
                                  

带描述开关
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSwitchWithText(BuildContext context) {
    return _buildItem(
      context,
      const TDSwitch(isOn: true, type: TDSwitchType.text),
      title: '带文字开关',
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSwitchWithIcon(BuildContext context) {
    return _buildItem(
      context,
      const TDSwitch(isOn: true, type: TDSwitchType.icon),
      title: '带图标开关',
    );
  }</pre>

</td-code-block>
                                  

自定义颜色开关
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSwitchWithColor(BuildContext context) {
    return _buildItem(
      context,
      const TDSwitch(isOn: true, trackOnColor: Colors.green),
      title: '自定义颜色开关',
    );
  }</pre>

</td-code-block>
                                  
### 1 组件状态

加载状态
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSwitchWithLoadingOff(BuildContext context) {
    return _buildItem(
      context,
      const TDSwitch(
        isOn: false,
        type: TDSwitchType.loading,
      ),
      title: '加载状态',
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSwitchWithLoadingOn(BuildContext context) {
    return _buildItem(
      context,
      const TDSwitch(
        isOn: true,
        type: TDSwitchType.loading,
      ),
      title: '加载状态',
    );
  }</pre>

</td-code-block>
                                  

禁用状态
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSwitchWithDisableOff(BuildContext context) {
    return _buildItem(
      context,
      const TDSwitch(
        enable: false,
        isOn: false,
      ),
      title: '禁用状态',
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSwitchWithDisableOn(BuildContext context) {
    return _buildItem(
      context,
      const TDSwitch(
        enable: false,
        isOn: true,
      ),
      title: '禁用状态',
    );
  }</pre>

</td-code-block>
                                  
### 1 组件样式

开关尺寸
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSwitchWithSizeLarge(BuildContext context) {
    return _buildItem(
      context,
      const TDSwitch(
        isOn: true,
        size: TDSwitchSize.large,
      ),
      title: '大尺寸32',
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSwitchWithSizeMed(BuildContext context) {
    return _buildItem(
      context,
      const TDSwitch(
        isOn: true,
        size: TDSwitchSize.medium,
      ),
      title: '中尺寸28',
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSwitchWithSizeSmall(BuildContext context) {
    return _buildItem(
      context,
      const TDSwitch(
        isOn: true,
        size: TDSwitchSize.small,
      ),
      title: '小尺寸24',
    );
  }</pre>

</td-code-block>
                                  


## API
### TDSwitch
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| enable | bool | true | 是否可点击 |
| isOn | bool | false | 是否打开 |
| size | TDSwitchSize? | TDSwitchSize.medium | 尺寸：大、中、小 |
| type | TDSwitchType? | TDSwitchType.fill | 类型：填充、文本、加载 |
| trackOnColor | Color? | - | 开启时轨道颜色 |
| trackOffColor | Color? | - | 关闭时轨道颜色 |
| thumbContentOnColor | Color? | - | 开启时ThumbView的颜色 |
| thumbContentOffColor | Color? | - | 关闭时ThumbView的颜色 |
| onChanged | OnSwitchChanged? | - | 改变事件 |


  