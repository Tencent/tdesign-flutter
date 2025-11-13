---
title: Steps 步骤条
description: 用于任务步骤展示或任务进度展示。
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
  Widget _buildBasicHSteps1(BuildContext context) {
    return TDSteps(
      steps: [
        TDStepsItemData(title: 'Steps1', content: 'Content1'),
        TDStepsItemData(title: 'Steps2', content: 'Content2'),
      ],
    );
  }</pre>

</td-code-block>
                                  

水平默认步骤条2
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildBasicHSteps2(BuildContext context) {
    return TDSteps(
      steps: [
        TDStepsItemData(title: 'Steps1', content: 'Content1'),
        TDStepsItemData(title: 'Steps2', content: 'Content2'),
        TDStepsItemData(title: 'Steps3', content: 'Content3'),
      ],
      // 水平方向
      direction: TDStepsDirection.horizontal,
      activeIndex: 1,
    );
  }</pre>

</td-code-block>
                                  

水平默认步骤条3
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildBasicHSteps3(BuildContext context) {
    return TDSteps(
      steps: [
        TDStepsItemData(title: 'Steps1', content: 'Content1'),
        TDStepsItemData(title: 'Steps2', content: 'Content2'),
        TDStepsItemData(title: 'Steps3', content: 'Content3'),
        TDStepsItemData(title: 'Steps4', content: 'Content4'),
      ],
      // 水平方向
      direction: TDStepsDirection.horizontal,
      activeIndex: 1,
    );
  }</pre>

</td-code-block>
                                  
### 1 水平图标步骤条

水平图标步骤条1
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildHIconSteps1(BuildContext context) {
    return TDSteps(
      steps: [
        TDStepsItemData(
          title: 'Steps1',
          content: 'Content1',
          successIcon: TDIcons.cart,
        ),
        TDStepsItemData(
          title: 'Steps2',
          content: 'Content2',
          successIcon: TDIcons.cart,
        ),
      ],
      // 水平方向
      direction: TDStepsDirection.horizontal,
      activeIndex: 0,
    );
  }</pre>

</td-code-block>
                                  

水平图标步骤条2
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildHIconSteps2(BuildContext context) {
    return TDSteps(
      steps: [
        TDStepsItemData(
          title: 'Steps1',
          content: 'Content1',
          successIcon: TDIcons.cart,
        ),
        TDStepsItemData(
          title: 'Steps2',
          content: 'Content2',
          successIcon: TDIcons.cart,
        ),
        TDStepsItemData(
          title: 'Steps3',
          content: 'Content3',
          successIcon: TDIcons.cart,
        ),
      ],
      // 水平方向
      direction: TDStepsDirection.horizontal,
      activeIndex: 1,
    );
  }</pre>

</td-code-block>
                                  

水平图标步骤条3
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildHIconSteps3(BuildContext context) {
    return TDSteps(
      steps: [
        TDStepsItemData(
          title: 'Steps1',
          content: 'Content1',
          successIcon: TDIcons.cart,
        ),
        TDStepsItemData(
          title: 'Steps2',
          content: 'Content2',
          successIcon: TDIcons.cart,
        ),
        TDStepsItemData(
          title: 'Steps3',
          content: 'Content3',
          successIcon: TDIcons.cart,
        ),
        TDStepsItemData(
          title: 'Steps4',
          content: 'Content4',
          successIcon: TDIcons.cart,
        ),
      ],
      // 水平方向
      direction: TDStepsDirection.horizontal,
      activeIndex: 1,
    );
  }</pre>

</td-code-block>
                                  
### 1 水平简略步骤条

水平简略步骤条1
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSimpleHSteps1(BuildContext context) {
    return TDSteps(
      steps: [
        TDStepsItemData(title: 'Steps1', content: 'Content1'),
        TDStepsItemData(title: 'Steps2', content: 'Content2'),
      ],
      // 水平方向
      direction: TDStepsDirection.horizontal,
      activeIndex: 0,
      // 简略模式
      simple: true,
    );
  }</pre>

</td-code-block>
                                  

水平简略步骤条2
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSimpleHSteps2(BuildContext context) {
    return TDSteps(
      steps: [
        TDStepsItemData(title: 'Steps1', content: 'Content1'),
        TDStepsItemData(title: 'Steps2', content: 'Content2'),
        TDStepsItemData(title: 'Steps3', content: 'Content3'),
      ],
      // 水平方向
      direction: TDStepsDirection.horizontal,
      activeIndex: 1,
      // 简略模式
      simple: true,
    );
  }</pre>

</td-code-block>
                                  

水平简略步骤条3
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSimpleHSteps3(BuildContext context) {
    return TDSteps(
      steps: [
        TDStepsItemData(title: 'Steps1', content: 'Content1'),
        TDStepsItemData(title: 'Steps2', content: 'Content2'),
        TDStepsItemData(title: 'Steps3', content: 'Content3'),
        TDStepsItemData(title: 'Steps4', content: 'Content4'),
      ],
      // 水平方向
      direction: TDStepsDirection.horizontal,
      activeIndex: 1,
      // 简略模式
      simple: true,
    );
  }</pre>

</td-code-block>
                                  
### 1 水平错误状态步骤条

水平错误状态基本步骤条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildHErrorSteps1(BuildContext context) {
    return TDSteps(
      steps: [
        TDStepsItemData(title: 'Steps1', content: 'Content1'),
        TDStepsItemData(title: 'Error', content: 'Content2'),
        TDStepsItemData(title: 'Steps3', content: 'Content3'),
        TDStepsItemData(title: 'Steps4', content: 'Content4'),
      ],
      // 水平方向
      direction: TDStepsDirection.horizontal,
      activeIndex: 1,
      // 错误状态
      status: TDStepsStatus.error,
    );
  }</pre>

</td-code-block>
                                  

水平错误状态图标步骤条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildHErrorSteps2(BuildContext context) {
    return TDSteps(
      steps: [
        TDStepsItemData(
          title: 'Steps1',
          content: 'Content1',
          successIcon: TDIcons.cart,
        ),
        TDStepsItemData(
          title: 'Error',
          content: 'Content2',
          successIcon: TDIcons.cart,
          errorIcon: TDIcons.close_circle,
        ),
        TDStepsItemData(
          title: 'Steps3',
          content: 'Content3',
          successIcon: TDIcons.cart,
        ),
        TDStepsItemData(
          title: 'Steps4',
          content: 'Content4',
          successIcon: TDIcons.cart,
        ),
      ],
      // 水平方向
      direction: TDStepsDirection.horizontal,
      activeIndex: 1,
      // 错误状态
      status: TDStepsStatus.error,
    );
  }</pre>

</td-code-block>
                                  

水平错误状态简略步骤条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildHErrorSteps3(BuildContext context) {
    return TDSteps(
      steps: [
        TDStepsItemData(
          title: 'Steps1',
          content: 'Content1',
          successIcon: TDIcons.cart,
        ),
        TDStepsItemData(
          title: 'Error',
          content: 'Content2',
          successIcon: TDIcons.cart,
          errorIcon: TDIcons.close_circle,
        ),
        TDStepsItemData(
          title: 'Steps3',
          content: 'Content3',
          successIcon: TDIcons.cart,
        ),
        TDStepsItemData(
          title: 'Steps4',
          content: 'Content4',
          successIcon: TDIcons.cart,
        ),
      ],
      // 水平方向
      direction: TDStepsDirection.horizontal,
      activeIndex: 1,
      // 错误状态
      status: TDStepsStatus.error,
      // 简略模式
      simple: true,
    );
  }</pre>

</td-code-block>
                                  
### 1 垂直步骤条

垂直默认步骤条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildVBasicSteps(BuildContext context) {
    return TDSteps(
      steps: [
        TDStepsItemData(title: 'Finish', content: 'Customize content'),
        TDStepsItemData(title: 'Process', content: 'Customize content'),
        TDStepsItemData(title: 'Default', content: 'Customize content'),
        TDStepsItemData(title: 'Default', content: 'Customize content'),
      ],
      // 垂直方向
      direction: TDStepsDirection.vertical,
      activeIndex: 1,
    );
  }</pre>

</td-code-block>
                                  

垂直图标步骤条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildVIconSteps(BuildContext context) {
    return TDSteps(
      steps: [
        TDStepsItemData(
          title: 'Finish',
          content: 'Customize content',
          successIcon: TDIcons.cart,
        ),
        TDStepsItemData(
          title: 'Process',
          content: 'Customize content',
          successIcon: TDIcons.cart,
        ),
        TDStepsItemData(
          title: 'Default',
          content: 'Customize content',
          successIcon: TDIcons.cart,
        ),
        TDStepsItemData(
          title: 'Default',
          content: 'Customize content',
          successIcon: TDIcons.cart,
        ),
      ],
      // 垂直方向
      direction: TDStepsDirection.vertical,
      activeIndex: 1,
    );
  }</pre>

</td-code-block>
                                  

垂直简略步骤条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildVSimpleSteps(BuildContext context) {
    return TDSteps(
      steps: [
        TDStepsItemData(
          title: 'Finish',
          content: 'Customize content',
          successIcon: TDIcons.cart,
        ),
        TDStepsItemData(
          title: 'Process',
          content: 'Customize content',
          successIcon: TDIcons.cart,
        ),
        TDStepsItemData(
            title: 'Default',
            content: 'Customize content',
            successIcon: TDIcons.cart),
        TDStepsItemData(
          title: 'Default',
          content: 'Customize content',
          successIcon: TDIcons.cart,
        ),
      ],
      // 垂直方向
      direction: TDStepsDirection.vertical,
      activeIndex: 1,
      // 简略模式
      simple: true,
    );
  }</pre>

</td-code-block>
                                  

垂直错误状态基本步骤条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildVErrorBasicSteps(BuildContext context) {
    return TDSteps(
      steps: [
        TDStepsItemData(title: 'Finish', content: 'Customize content'),
        TDStepsItemData(title: 'Process', content: 'Customize content'),
        TDStepsItemData(title: 'Default', content: 'Customize content'),
        TDStepsItemData(title: 'Default', content: 'Customize content'),
      ],
      // 垂直方向
      direction: TDStepsDirection.vertical,
      activeIndex: 1,
      // 错误状态
      status: TDStepsStatus.error,
    );
  }</pre>

</td-code-block>
                                  

垂直错误状态图标步骤条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildVErrorIconSteps(BuildContext context) {
    return TDSteps(
      steps: [
        TDStepsItemData(
          title: 'Finish',
          content: 'Customize content',
          successIcon: TDIcons.cart,
        ),
        TDStepsItemData(
          title: 'Process',
          content: 'Customize content',
          successIcon: TDIcons.cart,
          errorIcon: TDIcons.close_circle,
        ),
        TDStepsItemData(
          title: 'Default',
          content: 'Customize content',
          successIcon: TDIcons.cart,
        ),
        TDStepsItemData(
          title: 'Default',
          content: 'Customize content',
          successIcon: TDIcons.cart,
        ),
      ],
      // 垂直方向
      direction: TDStepsDirection.vertical,
      activeIndex: 1,
      // 错误状态
      status: TDStepsStatus.error,
    );
  }</pre>

</td-code-block>
                                  

垂直错误状态简略步骤条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildVErrorSimpleSteps(BuildContext context) {
    return TDSteps(
      steps: [
        TDStepsItemData(
          title: 'Finish',
          content: 'Customize content',
          successIcon: TDIcons.cart,
        ),
        TDStepsItemData(
          title: 'Process',
          content: 'Customize content',
          successIcon: TDIcons.cart,
        ),
        TDStepsItemData(
          title: 'Default',
          content: 'Customize content',
          successIcon: TDIcons.cart,
        ),
        TDStepsItemData(
          title: 'Default',
          content: 'Customize content',
          successIcon: TDIcons.cart,
        ),
      ],
      // 垂直方向
      direction: TDStepsDirection.vertical,
      activeIndex: 1,
      // 简略模式
      simple: true,
      // 错误状态
      status: TDStepsStatus.error,
    );
  }</pre>

</td-code-block>
                                  

垂直自定义标题基本步骤条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildVCustomTitleBaseSteps(BuildContext context) {
    return TDSteps(
      steps: [
        TDStepsItemData(title: 'Finish', content: 'Customize content'),
        TDStepsItemData(
          title: 'Process',
          content: 'Customize content',
          customTitle: const TDText(
            '这是一个很长很长的自定义标题，可以自动换行的一个标题内容',
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.visible,
          ),
        ),
        TDStepsItemData(title: 'Default', content: 'Customize content'),
        TDStepsItemData(title: 'Default', content: 'Customize content'),
      ],
      // 垂直方向
      direction: TDStepsDirection.vertical,
      activeIndex: 1,
    );
  }</pre>

</td-code-block>
                                  

垂直自定义内容基本步骤条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildVCustomContentBaseSteps(BuildContext context) {
    return TDSteps(
      steps: [
        TDStepsItemData(title: 'Finish', content: 'Customize content'),
        TDStepsItemData(
          title: '这是一个很长很长很长很长的文字，他是用来展示这个步骤的标题',
          content: 'Customize content',
          customContent: Container(
            margin: const EdgeInsets.only(bottom: 16, top: 4),
            child: const TDImage(
              assetUrl: 'assets/img/image.png',
              type: TDImageType.roundedSquare,
            ),
          ),
        ),
        TDStepsItemData(title: 'Default', content: 'Customize content'),
        TDStepsItemData(title: 'Default', content: 'Customize content'),
      ],
      // 垂直方向
      direction: TDStepsDirection.vertical,
      activeIndex: 1,
    );
  }</pre>

</td-code-block>
                                  
### 1 Extension 步骤条

Read-only Steps 纯展示水平步骤条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildHReadOnlySteps(BuildContext context) {
    return TDSteps(
      steps: [
        TDStepsItemData(title: 'Finish', content: 'content'),
        TDStepsItemData(title: 'Process', content: 'content'),
        TDStepsItemData(title: 'Default', content: 'content'),
        TDStepsItemData(title: 'Default', content: 'content'),
      ],
      // 只读模式
      readOnly: true,
    );
  }</pre>

</td-code-block>
                                  

Read-only Steps 纯展示垂直步骤条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildVReadOnlySteps(BuildContext context) {
    return TDSteps(
      steps: [
        TDStepsItemData(title: 'Finish', content: 'Customize content'),
        TDStepsItemData(title: 'Process', content: 'Customize content'),
        TDStepsItemData(title: 'Default', content: 'Customize content'),
        TDStepsItemData(title: 'Default', content: 'Customize content'),
      ],
      // 垂直方向
      direction: TDStepsDirection.vertical,
      activeIndex: 0,
      // 只读模式
      readOnly: true,
    );
  }</pre>

</td-code-block>
                                  

Vertical Customize Steps 垂直自定义步骤条
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildVCustomizeSteps(BuildContext context) {
    return TDSteps(
      steps: [
        TDStepsItemData(title: 'Selected'),
        TDStepsItemData(title: 'Selected'),
        TDStepsItemData(title: 'Selected'),
        TDStepsItemData(title: 'Please Selected'),
      ],
      // 垂直方向
      direction: TDStepsDirection.vertical,
      // 简略模式
      simple: true,
      activeIndex: 3,
      // 步骤条垂直自定义步骤条选择模式
      verticalSelect: true,
    );
  }</pre>

</td-code-block>
                                  


## API
### TDStepsItemData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| content | String? | - | 内容 |
| customContent | Widget? | - | 自定义内容 |
| customTitle | Widget? | - | 自定义标题 |
| errorIcon | IconData? | - | 失败图标 |
| successIcon | IconData? | - | 成功图标 |
| title | String? | - | 标题 |

```
```
 ### TDSteps
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| activeIndex | int | 0 | 步骤条当前激活的索引 |
| direction | TDStepsDirection | TDStepsDirection.horizontal | 步骤条方向 |
| key |  | - |  |
| readOnly | bool | false | 步骤条readOnly模式 |
| simple | bool | false | 步骤条simple模式 |
| status | TDStepsStatus | TDStepsStatus.success | 步骤条状态 |
| steps | List<TDStepsItemData> | - | 步骤条数据 |
| verticalSelect | bool | false | 步骤条垂直自定义步骤条选择模式 |


  