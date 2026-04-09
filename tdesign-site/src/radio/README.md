---
title: Radio 单选框
description: 
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

[td_radio_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_radio_page.dart)

### 1 组件类型

纵向单选框
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _verticalRadios(BuildContext context) {
    return TCell(
      title: '单选标题',
      hover: false,
      required: true,
      descriptionWidget: TRadioGroup(
        selectId: '0',
        direction: Axis.horizontal,
        directionalTdRadios: const [
          TRadio(
            id: '0',
            title: '单选标题0',
            showDivider: false,
          ),
          TRadio(
            id: '1',
            title: '单选标题1',
            showDivider: false,
          ),
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  

横向单选框
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _horizontalRadios(BuildContext context) {
    return TRadioGroup(
      selectId: 'index:1',
      direction: Axis.horizontal,
      directionalTdRadios: const [
        TRadio(
          id: '0',
          title: '单选标题',
          radioStyle: TRadioStyle.circle,
          showDivider: false,
        ),
        TRadio(
          id: '1',
          title: '单选标题',
          radioStyle: TRadioStyle.circle,
          showDivider: false,
        ),
        TRadio(
          id: '2',
          title: '上限四字',
          radioStyle: TRadioStyle.circle,
          showDivider: false,
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  

横向单选框-换行
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _horizontalRadiosWrap(BuildContext context) {
    return TRadioGroup(
      selectId: '0',
      direction: Axis.horizontal,
      rowCount: 4,
      directionalTdRadios: const [
        TRadio(id: '0', title: '单0'),
        TRadio(id: '1', title: '单1'),
        TRadio(id: '3', title: '单2'),
        TRadio(id: '4', title: '单3'),
        TRadio(id: '5', title: '单4'),
        TRadio(id: '6', title: '单5'),
      ],
    );
  }</pre>

</td-code-block>
                                  
### 1 组件状态

单选框状态
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _radioStatus(BuildContext context) {
    return TRadioGroup(
      contentDirection: TContentDirection.right,
      selectId: '0',
      child: const Column(
        children: [
          TRadio(
            id: '0',
            title: '选项禁用-已选',
            radioStyle: TRadioStyle.circle,
            enable: false,
          ),
          TRadio(
            id: '1',
            title: '选项禁用-默认',
            radioStyle: TRadioStyle.circle,
            enable: false,
          ),
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  
### 1 组件样式

勾选样式
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _checkStyle(BuildContext context) {
    return Column(
      children: [
        TRadioGroup(
          radioCheckStyle: TRadioStyle.check,
          selectId: 'index:0',
          child: const TRadio(
            id: 'index:0',
            title: '单选',
          ),
        ),
        const SizedBox(
          height: 17,
        ),
        TRadioGroup(
          radioCheckStyle: TRadioStyle.hollowCircle,
          selectId: 'index:0',
          child: const TRadio(
            id: 'index:0',
            title: '单选',
          ),
        )
      ],
    );
  }</pre>

</td-code-block>
                                  

勾选显示位置
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _checkPosition(BuildContext context) {
    return Column(
      children: [
        TRadioGroup(
          contentDirection: TContentDirection.right,
          selectId: 'index:0',
          child: const TRadio(
            id: 'index:0',
            title: '单选',
          ),
        ),
        TRadioGroup(
          contentDirection: TContentDirection.left,
          selectId: 'index:0',
          child: const TRadio(
            id: 'index:0',
            title: '单选',
            showDivider: false,
          ),
        )
      ],
    );
  }</pre>

</td-code-block>
                                  

非通栏单选样式
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _passThroughStyle(BuildContext context) {
    return TRadioGroup(
      selectId: 'index:0',
      passThrough: true,
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var title = '单选';
          return TRadio(
            id: 'index:$index',
            title: title,
            size: TCheckBoxSize.large,
          );
        },
        itemCount: 4,
      ),
    );
  }</pre>

</td-code-block>
                                  
### 1 特殊样式

纵向卡片单选框
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _verticalCardStyle(BuildContext context) {
    return TRadioGroup(
      selectId: 'index:1',
      cardMode: true,
      direction: Axis.vertical,
      directionalTdRadios: const [
        TRadio(
          id: 'index:0',
          title: '单选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
        TRadio(
          id: 'index:1',
          title: '单选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
        TRadio(
          id: 'index:2',
          title: '单选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
        TRadio(
          id: 'index:3',
          title: '单选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  

横向卡片单选框
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _horizontalCardStyle(BuildContext context) {
    return TRadioGroup(
      selectId: 'index:1',
      cardMode: true,
      direction: Axis.horizontal,
      rowCount: 2,
      directionalTdRadios: const [
        TRadio(
          id: 'index:0',
          title: '单选',
          cardMode: true,
        ),
        TRadio(
          id: 'index:1',
          title: '单选',
          cardMode: true,
        ),
        TRadio(
          id: 'index:2',
          title: '单选',
          cardMode: true,
        ),
        TRadio(
          id: 'index:3',
          title: '单选',
          cardMode: true,
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  


## API
### TRadio
#### 简介
单选框按钮,继承自TDCheckbox，字段含义与父类一致
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor |  | - |  |
| cardMode |  | - |  |
| checkBoxLeftSpace |  | - |  |
| contentDirection |  | TContentDirection.right |  |
| customContentBuilder |  | - |  |
| customIconBuilder |  | - |  |
| customSpace |  | - |  |
| disableColor |  | - |  |
| enable |  | true |  |
| id |  | - |  |
| insetSpacing |  | - |  |
| key |  | - |  |
| radioStyle | TRadioStyle | TRadioStyle.circle | 单选框按钮样式 |
| selectColor |  | - |  |
| showDivider | bool | - | 是否显示下划线 |
| size |  | TCheckBoxSize.small |  |
| spacing |  | - |  |
| subTitle |  | - |  |
| subTitleColor |  | - |  |
| subTitleFont |  | - |  |
| subTitleMaxLine |  | 1 |  |
| title |  | - |  |
| titleColor |  | - |  |
| titleFont |  | - |  |
| titleMaxLine |  | 1 |  |

```
```

### TRadioGroup
#### 简介
RadioGroup分组对象，继承自TDCheckboxGroup，字段含义与父类一致
 RadioGroup应该嵌套在RadioGroup内，所有在RadioGroup的RadioButton只能有一个被选中

 cardMode: 使用卡片样式，需要配合direction 和 directionalTdRadios 使用，
 组合为横向、纵向卡片，同时需要在每个TDRadio上设置cardMode参数。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| cardMode |  | false |  |
| child |  | - |  |
| contentDirection |  | - |  |
| controller |  | - |  |
| customContentBuilder |  | - |  |
| customIconBuilder |  | - |  |
| direction |  | - |  |
| directionalTdRadios |  | - |  |
| divider | Widget? | - | 自定义下划线 |
| key |  | - |  |
| onRadioGroupChange |  | - |  |
| passThrough |  | - |  |
| radioCheckStyle | TRadioStyle? | - | 勾选样式 |
| rowCount | int | 1 | 每行几列 |
| selectId |  | - |  |
| showDivider | bool | false | 是否显示下划线 |
| spacing |  | - |  |
| strictMode | bool | true | 严格模式下，用户不能取消勾选，只能切换选择项， |
| titleMaxLine |  | - |  |


  