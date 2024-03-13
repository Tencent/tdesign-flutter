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

### 1 组件类型

纵向单选框
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _verticleRadios(BuildContext context) {
    return TDRadioGroup(
      selectId: 'index:1',
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          var title = '单选';
          var subTitle = '';
          if (index == 2) {
            title = '单选标题多行单选标题多行单选标题多行单选标题多行单选标题多行单选标题多行';
          }
          if (index == 3) {
            subTitle = '描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息';
          }
          return TDRadio(
            id: 'index:$index',
            title: title,
            titleMaxLine: 2,
            subTitleMaxLine: 2,
            subTitle: subTitle,
          );
        },
        itemCount: 4,
      ),
    );
  }</pre>

</td-code-block>
                                  

横向单选框
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _horizontalRadios(BuildContext context) {
    return TDRadioGroup(
      selectId: 'index:1',
      direction: Axis.horizontal,
      directionalTdRadios: const [
        TDRadio(
          id: '0',
          title: '单选标题',
          radioStyle: TDRadioStyle.circle,
          showDivider: false,
        ),
        TDRadio(
          id: '1',
          title: '单选标题',
          radioStyle: TDRadioStyle.circle,
          showDivider: false,
        ),
        TDRadio(
          id: '2',
          title: '上限四字',
          radioStyle: TDRadioStyle.circle,
          showDivider: false,
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  
### 1 组件状态

单选框状态
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _radioStatus(BuildContext context) {
    return TDRadioGroup(
      contentDirection: TDContentDirection.right,
      selectId: '0',
      child: Column(
        children: const [
          TDRadio(
            id: '0',
            title: '选项禁用-已选',
            radioStyle: TDRadioStyle.circle,
            enable: false,
          ),
          TDRadio(
            id: '1',
            title: '选项禁用-默认',
            radioStyle: TDRadioStyle.circle,
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
        TDRadioGroup(
          radioCheckStyle: TDRadioStyle.check,
          selectId: 'index:0',
          child: const TDRadio(
            id: 'index:0',
            title: '单选',
          ),
        ),
        const SizedBox(
          height: 17,
        ),
        TDRadioGroup(
          radioCheckStyle: TDRadioStyle.hollowCircle,
          selectId: 'index:0',
          child: const TDRadio(
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
        TDRadioGroup(
          contentDirection: TDContentDirection.right,
          selectId: 'index:0',
          child: const TDRadio(
            id: 'index:0',
            title: '单选',
          ),
        ),
        TDRadioGroup(
          contentDirection: TDContentDirection.left,
          selectId: 'index:0',
          child: const TDRadio(
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
    return TDRadioGroup(
      selectId: 'index:0',
      passThrough: true,
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (contet, index) {
          var title = '单选';
          return TDRadio(
            id: 'index:$index',
            title: title,
            size: TDCheckBoxSize.large,
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
    return TDRadioGroup(
      selectId: 'index:1',
      cardMode: true,
      direction: Axis.vertical,
      directionalTdRadios: const [
        TDRadio(
          id: 'index:0',
          title: '单选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
        TDRadio(
          id: 'index:1',
          title: '单选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
        TDRadio(
          id: 'index:2',
          title: '单选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
        TDRadio(
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
    return TDRadioGroup(
      selectId: 'index:1',
      cardMode: true,
      direction: Axis.horizontal,
      directionalTdRadios: const [
        TDRadio(
          id: 'index:0',
          title: '单选',
          cardMode: true,
        ),
        TDRadio(
          id: 'index:1',
          title: '单选',
          cardMode: true,
        ),
        TDRadio(
          id: 'index:2',
          title: '单选',
          cardMode: true,
        ),
        TDRadio(
          id: 'index:3',
          title: '单选',
          cardMode: true,
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  


## API
### TDRadio
#### 简介
单选框按钮,继承自TDCheckbox，字段含义与父类一致
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| id |  | - |  |
| key |  | - |  |
| title |  | - |  |
| subTitle |  | - |  |
| enable |  | true |  |
| subTitleMaxLine |  | 1 |  |
| titleMaxLine |  | 1 |  |
| checkedColor |  | - |  |
| customContentBuilder |  | - |  |
| spacing |  | - |  |
| cardMode |  | - |  |
| showDivider | bool | - | 是否显示下划线 |
| size |  | TDCheckBoxSize.small |  |
| radioStyle | TDRadioStyle | TDRadioStyle.circle | 单选框按钮样式 |
| contentDirection |  | TDContentDirection.right |  |
| customIconBuilder |  | - |  |

```
```
 ### TDRadioGroup
#### 简介
RadioGroup分组对象，继承自TDCheckboxGroup，字段含义与父类一致
 RadioGroup应该嵌套在RadioGroup内，所有在RadioGroup的RadioButton只能有一个被选中

 cardMode: 使用卡片样式，需要配合direction 和 directionalTdRadios 使用，
 组合为横向、纵向卡片，同时需要在每个TDRadio上设置cardMode参数。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| child |  | - |  |
| direction |  | - |  |
| directionalTdRadios |  | - |  |
| selectId |  | - |  |
| passThrough |  | - |  |
| cardMode |  | false |  |
| strictMode | bool | true | 严格模式下，用户不能取消勾选，只能切换选择项， |
| radioCheckStyle | TDRadioStyle? | - | 勾选样式 |
| titleMaxLine |  | - |  |
| customIconBuilder |  | - |  |
| customContentBuilder |  | - |  |
| spacing |  | - |  |
| contentDirection |  | - |  |
| onRadioGroupChange |  | - |  |
| showDivider | bool | false | 是否显示下划线 |
| divider | Widget? | - | 自定义下划线 |


  