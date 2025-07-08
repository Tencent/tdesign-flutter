---
title: Checkbox 多选框
description: 用于预设的一组选项中执行多项选择，并呈现选择结果。
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

[td_checkbox_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_checkbox_page.dart)

### 1 组件类型

纵向多选框
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _verticalCheckbox(BuildContext context) {
    return TDCheckboxGroupContainer(
      selectIds: const ['index:1'],
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          var title = '多选';
          var subTitle = '';
          if (index == 2) {
            title = '多选标题多行多选标题多行多选标题多行多选标题多行多选标题多行多选标题多行';
          }
          if (index == 3) {
            subTitle = '描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息';
          }
          return TDCheckbox(
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
                                  

横向多选框
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _horizontalCheckbox(BuildContext context) {
    return TDCheckboxGroupContainer(
      selectIds: const ['1'],
      direction: Axis.horizontal,
      directionalTdCheckboxes: const [
        TDCheckbox(
          id: '0',
          title: '多选标题',
          style: TDCheckboxStyle.circle,
          insetSpacing: 12,
          showDivider: false,
        ),
        TDCheckbox(
          id: '1',
          title: '多选标题',
          style: TDCheckboxStyle.circle,
          insetSpacing: 12,
          showDivider: false,
        ),
        TDCheckbox(
          id: '2',
          title: '上限四字',
          style: TDCheckboxStyle.circle,
          insetSpacing: 12,
          showDivider: false,
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  

带全选多选框
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _checkAllSelected(BuildContext context) {
    const itemCount = 4;
    return TDCheckboxGroupContainer(
      selectIds: checkIds,
      passThrough: false,
      controller: controller,
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var title = '多选';
          if(index == 0){
            title = '全选';
            return SizedBox(
              height: 56,
              child: TDCheckbox(
                id: 'index:$index',
                title: title,
                customIconBuilder: (context, checked) {
                  var length = controller!.allChecked().length - (controller!.checked('index:0') ? 1 : 0);
                  var allCheck = itemCount - 1 == length;
                  var halfSelected =
                      controller != null
                          && !allCheck
                          && length > 0;
                  return getAllIcon(allCheck, halfSelected);
                },
                onCheckBoxChanged: (checked){
                  if (checked) {
                    controller?.toggleAll(true);
                  } else {
                    controller?.toggleAll(false);
                  }
                },
              ),
            );
          }else{
            return SizedBox(
              height: index == itemCount - 1 ? null : 56,
              child: TDCheckbox(
                id: 'index:$index',
                title: title,
                subTitle: index == itemCount - 1 ? '描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息' : null,
                subTitleMaxLine: 2,
                onCheckBoxChanged: (checked){
                  var length = controller!.allChecked().length - (controller!.checked('index:0') ? 1 : 0);
                  var allCheck = itemCount - 1 == length;
                  var halfSelected =
                      controller != null
                          && !allCheck
                          && length > 0;
                  controller!.toggle('index:0', allCheck);
                  getAllIcon(allCheck, halfSelected);
                },
              ),
            );
          }
        },
        itemCount: itemCount,
      ),
    );
  }</pre>

</td-code-block>
                                  
### 1 组件状态

多选框状态
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _checkboxStatus(BuildContext context) {
    return TDCheckboxGroupContainer(
      contentDirection: TDContentDirection.right,
      selectIds: const ['0'],
      child: Column(
        children: const [
          TDCheckbox(
            id: '0',
            title: '选项禁用-已选',
            style: TDCheckboxStyle.circle,
            enable: false,
          ),
          TDCheckbox(
            id: '1',
            title: '选项禁用-默认',
            style: TDCheckboxStyle.circle,
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
        TDCheckboxGroupContainer(
          style: TDCheckboxStyle.check,
          selectIds: const ['index:0'],
          child: const TDCheckbox(
            id: 'index:0',
            title: '多选',
          ),
        ),
        const SizedBox(
          height: 17,
        ),
        TDCheckboxGroupContainer(
          style: TDCheckboxStyle.square,
          selectIds: const ['index:0'],
          child: const TDCheckbox(
            id: 'index:0',
            title: '多选',
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
        TDCheckboxGroupContainer(
          contentDirection: TDContentDirection.right,
          selectIds: const ['index:0'],
          child: const TDCheckbox(
            id: 'index:0',
            title: '多选',
          ),
        ),
        TDCheckboxGroupContainer(
          contentDirection: TDContentDirection.left,
          selectIds: const ['index:0'],
          child: const TDCheckbox(
            id: 'index:0',
            title: '多选',
          ),
        )
      ],
    );
  }</pre>

</td-code-block>
                                  

非通栏多选样式
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _passThroughStyle(BuildContext context) {
    return TDCheckboxGroupContainer(
      selectIds: const ['index:0'],
      passThrough: true,
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var title = '多选';
          return TDCheckbox(
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
    return TDCheckboxGroupContainer(
      selectIds: const ['index:1'],
      cardMode: true,
      direction: Axis.vertical,
      directionalTdCheckboxes: const [
        TDCheckbox(
          id: 'index:0',
          title: '多选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
        TDCheckbox(
          id: 'index:1',
          title: '多选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
        TDCheckbox(
          id: 'index:2',
          title: '多选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
        TDCheckbox(
          id: 'index:3',
          title: '多选',
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
    return TDCheckboxGroupContainer(
      selectIds: const ['index:1'],
      cardMode: true,
      direction: Axis.horizontal,
      directionalTdCheckboxes: const [
        TDCheckbox(
          id: 'index:0',
          title: '多选',
          cardMode: true,
        ),
        TDCheckbox(
          id: 'index:1',
          title: '多选',
          cardMode: true,
        ),
        TDCheckbox(
          id: 'index:2',
          title: '多选',
          cardMode: true,
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  


## API
### TDCheckbox
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| id | String? | - | id |
| key |  | - |  |
| title | String? | - | 文本 |
| subTitle | String? | - | 辅助文字 |
| titleFont | Font? | - | 标题字体大小 |
| subTitleFont | Font? | - | 副标题字体大小 |
| enable | bool | true | 不可用 |
| checked | bool | false | 选中状态。默认为`false` |
| titleMaxLine | int? | - | 标题的行数 |
| subTitleMaxLine | int? | 1 | 辅助文字的行数 |
| customIconBuilder | IconBuilder? | - | 自定义Checkbox显示样式 |
| customContentBuilder | ContentBuilder? | - | 完全自定义内容 |
| insetSpacing | double? | 16 | 文字和非图标侧的距离 |
| style | TDCheckboxStyle? | - | 复选框样式：圆形或方形 |
| spacing | double? | - | icon和文字的距离 |
| backgroundColor | Color? | - | 背景颜色 |
| selectColor | Color? | - | 选择颜色 |
| disableColor | Color? | - | 禁用选择颜色 |
| size | TDCheckBoxSize | TDCheckBoxSize.small | 复选框大小 |
| cardMode | bool | false | 展示为卡片模式 |
| showDivider | bool | true | 是否展示分割线 |
| contentDirection | TDContentDirection | TDContentDirection.right | 文字相对icon的方位 |
| onCheckBoxChanged | OnCheckValueChanged? | - | 切换监听 |
| titleColor | Color? | - | 标题文字颜色 |
| subTitleColor | Color? | - | 副标题文字颜色 |
| checkBoxLeftSpace | double? | - | 选项框左侧间距 |
| customSpace | EdgeInsetsGeometry? | - | 自定义组件间距 |

```
```
 ### TDCheckboxGroup
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child |  | - |  |
| key |  | - |  |
| onChangeGroup | OnGroupChange? | - | 状态变化监听器 |
| controller | TDCheckboxGroupController? | - | 可以通过控制器操作勾选状态 |
| checkedIds | List<String>? | - | 勾选的CheckBox id列表 |
| maxChecked | int? | - | 最多可以勾选多少 |
| titleMaxLine | int? | - | CheckBox标题的行数 |
| customContentBuilder | ContentBuilder? | - | CheckBox完全自定义内容 |
| contentDirection | TDContentDirection? | - | 文字相对icon的方位 |
| style | TDCheckboxStyle? | - | CheckBox复选框样式：圆形或方形 |
| spacing | double? | - | CheckBoxicon和文字的距离 |
| customIconBuilder | IconBuilder? | - | 自定义选择icon的样式 |
| onOverloadChecked | VoidCallback? | - | 超过最大可勾选的个数 |


  