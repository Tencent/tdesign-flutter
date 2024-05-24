---
title: Textarea 多行文本框
description: 用于多行文本信息输入。
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

基础多文本输入框
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _basicType(BuildContext context) {
    return TDTextarea(
      controller: controller[0],
      hintText: '请输入文字',
      maxLines: 4,
      minLines: 4,
      onChanged: (value) {
        setState(() {});
      },
    );
  }</pre>

</td-code-block>
                                  

带标题多文本输入框
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _basicTypeByTitle(BuildContext context) {
    return TDTextarea(
      controller: controller[1],
      label: '标签文字',
      hintText: '请输入文字',
      maxLines: 4,
      minLines: 4,
      onChanged: (value) {
        setState(() {});
      },
    );
  }</pre>

</td-code-block>
                                  

自动增高多文本输入框
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _autoHeightType(BuildContext context) {
    return TDTextarea(
      controller: controller[2],
      hintText: '请输入文字',
      minLines: 1,
      onChanged: (value) {
        setState(() {});
      },
    );
  }</pre>

</td-code-block>
                                  

设置字符数限制
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _maxLengthType(BuildContext context) {
    return TDTextarea(
      controller: controller[3],
      label: '标签文字',
      hintText: '请输入文字',
      maxLines: 4,
      minLines: 4,
      maxLength: 500,
      indicator: true,
      onChanged: (value) {
        setState(() {});
      },
    );
  }</pre>

</td-code-block>
                                  
### 1 组件状态

禁用状态
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _disabledState(BuildContext context) {
    return TDTextarea(
      controller: controller[4],
      label: '标签文字',
      hintText: '不可编辑文字',
      maxLines: 4,
      minLines: 4,
      readOnly: true,
      onChanged: (value) {
        setState(() {});
      },
    );
  }</pre>

</td-code-block>
                                  
### 1 组件样式

竖排样式
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _verticalStyle(BuildContext context) {
    return TDTextarea(
      controller: controller[5],
      label: '标签文字',
      hintText: '请输入文字',
      maxLines: 4,
      minLines: 4,
      maxLength: 500,
      indicator: true,
      layout: TDTextareaLayout.vertical,
      onChanged: (value) {
        setState(() {});
      },
    );
  }</pre>

</td-code-block>
                                  

卡片样式
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _cardStyle(BuildContext context) {
    return TDTextarea(
      controller: controller[6],
      label: '标签文字',
      hintText: '请输入文字',
      maxLines: 4,
      minLines: 4,
      maxLength: 500,
      indicator: true,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TDTheme.of(context).radiusExtraLarge),
      ),
      margin: EdgeInsets.only(right: TDTheme.of(context).spacer16, left: TDTheme.of(context).spacer16),
      onChanged: (value) {
        setState(() {});
      },
    );
  }</pre>

</td-code-block>
                                  
### 1 特殊样式

标签外置输入框
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _extensionStyle(BuildContext context) {
    return TDTextarea(
      controller: controller[7],
      label: '标签文字',
      hintText: '请输入文字',
      maxLines: 4,
      minLines: 4,
      maxLength: 500,
      indicator: true,
      layout: TDTextareaLayout.vertical,
      bordered: true,
      onChanged: (value) {
        setState(() {});
      },
    );
  }</pre>

</td-code-block>
                                  

自定义标题
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _setLabel(BuildContext context) {
    return TDTextarea(
      controller: controller[9],
      label: '地址信息',
      // labelWidth: 100,
      labelIcon: Icon(
        TDIcons.location,
        size: 20,
        color: TDTheme.of(context).fontGyColor1,
      ),
      hintText: '请输入文字',
      maxLines: 4,
      minLines: 4,
      maxLength: 500,
      indicator: true,
      onChanged: (value) {
        setState(() {});
      },
    );
  }</pre>

</td-code-block>
                                  

必填和辅助说明
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _setStatus(BuildContext context) {
    return TDTextarea(
      controller: controller[10],
      label: '标签文字',
      hintText: '请输入文字',
      maxLines: 4,
      minLines: 4,
      maxLength: 500,
      indicator: true,
      layout: TDTextareaLayout.vertical,
      required: true,
      additionInfo: '辅助说明',
      onChanged: (value) {
        setState(() {});
      },
    );
  }</pre>

</td-code-block>
                                  


## API
### TDTextarea
#### 简介
用于多行文本信息输入
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| width | double? | - | 输入框宽度 |
| textStyle | TextStyle? | - | 文本颜色 |
| backgroundColor | Color? | Colors.white | 输入框背景色 |
| decoration | Decoration? | - | 输入框样式(包括标签) |
| labelStyle | TextStyle? | - | 左侧标签文本样式 |
| required | bool? | - | 是否必填标志（红色*） |
| readOnly | bool? | false | 是否只读 |
| autofocus | bool? | false | 是否自动获取焦点 |
| onEditingComplete | VoidCallback? | - | 点击键盘完成按钮时触发的回调 |
| onSubmitted | ValueChanged<String>? | - | 点击键盘完成按钮时触发的回调, 参数值为输入的内容 |
| hintText | String? | - | 提示文案 |
| inputType | TextInputType? | - | 键盘类型，数字、字母 |
| onChanged | ValueChanged<String>? | - | 输入文本变化时回调 |
| inputFormatters | List<TextInputFormatter>? | - | 显示输入内容，如限制长度(LengthLimitingTextInputFormatter(6)) |
| inputDecoration | InputDecoration? | - | 自定义输入框TextField组件样式 |
| maxLines | int? | - | 最大输入行数 |
| minLines | int? | 4 | 最小输入行数 |
| focusNode | FocusNode? | - | 获取或者取消焦点使用 |
| controller | TextEditingController? | - | controller 用户获取或者赋值输入内容 |
| cursorColor | Color? | - | 游标颜色 |
| hintTextStyle | TextStyle? | - | 提示文本颜色，默认为文本颜色 |
| labelWidget | Widget? | - | label组件，支持自定义 |
| textInputBackgroundColor | Color? | - | 文本框背景色 |
| size | TDInputSize? | TDInputSize.large | 输入框规格 |
| maxLength | int? | - | 最大字数限制 |
| additionInfo | String? | '' | 错误提示信息 |
| additionInfoColor | Color? | - | 错误提示颜色 |
| textAlign | TextAlign? | - | 文字对齐方向 |
| label | String? | - | 输入框标题 |
| indicator | bool? | false | 否显示文本计数器，如 0/140（必须设置maxLength） |
| layout | TDTextareaLayout? | TDTextareaLayout.horizontal | 标题输入框布局方式。可选项：vertical/horizontal |
| autosize | bool? | - | 是否自动增高，值为 autosize 时，maxLines 不生效 |
| labelIcon | Widget? | - | 输入框标题图标 |
| labelWidth | double? | - | 输入框标题宽度 |
| margin | EdgeInsetsGeometry? | - | 外边距 |
| textareaDecoration | Decoration? | - | 输入框样式(不包括标签) |
| bordered | bool? | - | 是否显示外边框 |


  