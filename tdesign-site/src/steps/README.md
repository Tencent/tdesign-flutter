---
title: Steps 步骤条
description: Steps步骤条
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

[td_steps_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_steps_page.dart)

### 1 水平默认步骤条

水平默认步骤条1
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildBasicHSteps1(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: basicHStepsListData1,
            ),
          )
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  

水平默认步骤条2
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildBasicHSteps2(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: basicHStepsListData2,
              direction: TDStepsDirection.horizontal,
              activeIndex: 1,
            ),
          )
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  

水平默认步骤条3
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildBasicHSteps3(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: basicHStepsListData3,
              direction: TDStepsDirection.horizontal,
              activeIndex: 1,
            ),
          )
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  
### 1 水平图标步骤条

水平图标步骤条1
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildHIconSteps1(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: hIconStepsListData1,
              direction: TDStepsDirection.horizontal,
              activeIndex: 0,
            ),
          )
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  

水平图标步骤条2
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildHIconSteps2(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: hIconStepsListData2,
              direction: TDStepsDirection.horizontal,
              activeIndex: 1,
            ),
          )
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  

水平图标步骤条3
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildHIconSteps3(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: hIconStepsListData3,
              direction: TDStepsDirection.horizontal,
              activeIndex: 1,
            ),
          )
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  
### 1 水平简略步骤条

水平简略步骤条1
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSimpleHSteps1(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: simpleHStepsListData1,
              direction: TDStepsDirection.horizontal,
              activeIndex: 0,
              simple: true,
            ),
          )
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  

水平简略步骤条2
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSimpleHSteps2(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: simpleHStepsListData2,
              direction: TDStepsDirection.horizontal,
              activeIndex: 1,
              simple: true,
            ),
          )
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  

水平简略步骤条3
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSimpleHSteps3(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: simpleHStepsListData3,
              direction: TDStepsDirection.horizontal,
              activeIndex: 1,
              simple: true,
            ),
          )
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  
### 1 水平错误状态步骤条

水平错误状态基本步骤条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildHErrorSteps1(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: hErrorStepsListData1,
              direction: TDStepsDirection.horizontal,
              activeIndex: 1,
              status: TDStepsStatus.error,
            ),
          )
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  

水平错误状态图标步骤条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildHErrorSteps2(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: hErrorStepsListData2,
              direction: TDStepsDirection.horizontal,
              activeIndex: 1,
              status: TDStepsStatus.error,
            ),
          )
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  

水平错误状态简略步骤条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildHErrorSteps3(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: hErrorStepsListData3,
              direction: TDStepsDirection.horizontal,
              activeIndex: 1,
              status: TDStepsStatus.error,
              simple: true,
            ),
          )
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  
### 1 垂直步骤条

垂直默认步骤条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildVBasicSteps(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: vBasicStepsListData,
              direction: TDStepsDirection.vertical,
              activeIndex: 1,
            ),
          )
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  

垂直图标步骤条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildVIconSteps(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: vIconStepsListData,
              direction: TDStepsDirection.vertical,
              activeIndex: 1,
            ),
          )
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  

垂直简略步骤条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildVSimpleSteps(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: vSimpleStepsListData,
              direction: TDStepsDirection.vertical,
              activeIndex: 1,
              simple: true,
            ),
          )
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  

垂直错误状态基本步骤条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildVErrorBasicSteps(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: vErrorBasicStepsListData,
              direction: TDStepsDirection.vertical,
              activeIndex: 1,
              status: TDStepsStatus.error,
            ),
          )
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  

垂直错误状态图标步骤条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildVErrorIconSteps(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: vErrorIconStepsListData,
              direction: TDStepsDirection.vertical,
              activeIndex: 1,
              status: TDStepsStatus.error,
            ),
          )
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  

垂直错误状态简略步骤条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildVErrorSimpleSteps(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: vErrorSimpleStepsListData,
              direction: TDStepsDirection.vertical,
              activeIndex: 1,
              simple: true,
              status: TDStepsStatus.error,
            ),
          )
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  

垂直自定义内容基本步骤条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildVCustomContentBaseSteps(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: vCustomContentBasicStepsListData,
              direction: TDStepsDirection.vertical,
              activeIndex: 1,
            ),
          )
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  
### 1 Extension步骤条

Read-only Steps 纯展示水平步骤条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildHReadOnlySteps(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: hReadOnlyStepsListData,
              readOnly: true,
            ),
          )
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  

Read-only Steps 纯展示垂直步骤条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildVReadOnlySteps(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: vReadOnlyStepsListData,
              direction: TDStepsDirection.vertical,
              activeIndex: 0,
              readOnly: true,
            ),
          )
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  

Vertical Customize Steps 垂直自定义步骤条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildVCustomizeSteps(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: vCustomizeStepsListData,
              direction: TDStepsDirection.vertical,
              simple: true,
              activeIndex: 3,
              verticalSelect: true,
            ),
          )
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  


## API
### TDStepsItemData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| title | String | - | 标题 |
| content | String | - | 内容 |
| successIcon | IconData? | - | 成功图标 |
| errorIcon | IconData? | - | 失败图标 |
| customContent | Widget? | - | 自定义内容 |

```
```
 ### TDSteps
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| steps | List<TDStepsItemData> | - | 步骤条数据 |
| activeIndex | int | 0 | 步骤条当前激活的索引 |
| direction | TDStepsDirection | TDStepsDirection.horizontal | 步骤条方向 |
| status | TDStepsStatus | TDStepsStatus.success | 步骤条状态 |
| simple | bool | false | 步骤条simple模式 |
| readOnly | bool | false | 步骤条readOnly模式 |
| verticalSelect | bool | false | 步骤条垂直自定义步骤条选择模式 |


  