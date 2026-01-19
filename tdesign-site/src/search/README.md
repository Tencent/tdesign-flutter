---
title: Search 搜索框
description: 用于一组预设数据中的选择。
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

[td_search_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_search_page.dart)

### 1 组件类型

基础搜索框
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildDefaultSearchBar(BuildContext context) {
    return TDSearchBar(
      placeHolder: '搜索预设文案',
      onTextChanged: (String text) {
        setState(() {
          inputText = text;
        });
      },
    );
  }</pre>

</td-code-block>
                                  

获取焦点后显示取消按钮
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildFocusSearchBar(BuildContext context) {
    return const TDSearchBar(
      placeHolder: '搜索预设文案',
      needCancel: true,
      autoFocus: true,
    );
  }</pre>

</td-code-block>
                                  
### 1 组件样式

搜索框形状
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSearchBarWithShape(BuildContext context) {
    return Column(
      // spacing: 16,
      children: [
        TDSearchBar(
          placeHolder: '搜索预设文案',
          // 方形
          style: TDSearchStyle.square,
          onTextChanged: (String text) {
            setState(() {
              inputText = text;
            });
          },
        ),
        const SizedBox(height: 16),
        TDSearchBar(
          placeHolder: '搜索预设文案',
          // 圆形
          style: TDSearchStyle.round,
          onTextChanged: (String text) {
            setState(() {
              inputText = text;
            });
          },
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  

默认状态其他对齐方式
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCenterSearchBar(BuildContext context) {
    return TDSearchBar(
      placeHolder: '搜索预设文案',
      alignment: TDSearchAlignment.center,
      onTextChanged: (String text) {
        setState(() {
          inputText = text;
        });
      },
    );
  }</pre>

</td-code-block>
                                  


## API
### TDSearchBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| action | String | '' | 自定义操作文字 |
| alignment | TDSearchAlignment? | TDSearchAlignment.left | 对齐方式，居中或这头部对齐 |
| autoFocus | bool | false | 是否自动获取焦点 |
| autoHeight | bool | false | 是否自动计算高度 |
| backgroundColor | Color? | - | 背景颜色 |
| controller | TextEditingController? | - | 控制器 |
| cursorHeight | double? | - | 光标的高 |
| enabled | bool? | - | 是否禁用 |
| focusNode | FocusNode? | - | 自定义焦点 |
| inputAction | TextInputAction? | - | 键盘动作类型 |
| key |  | - |  |
| mediumStyle | bool | false | 是否在导航栏中的样式 |
| needCancel | bool | false | 是否需要取消按钮 |
| onActionClick | TDSearchBarEvent? | - | 自定义操作回调 |
| onClearClick | TDSearchBarClearEvent? | - | 自定义操作回调 |
| onEditComplete | TDSearchBarCallBack? | - | 编辑完成回调 |
| onInputClick | GestureTapCallback? | - | 输入框点击事件 |
| onSubmitted | TDSearchBarEvent? | - | 提交回调 |
| onTapOutside | TapRegionCallback? | - | 点击输入框外部回调 |
| onTextChanged | TDSearchBarEvent? | - | 文字改变回调 |
| padding | EdgeInsets | const EdgeInsets.symmetric(horizontal: 16, vertical: 8) | 内部填充 |
| placeHolder | String? | - | 预设文案 |
| readOnly | bool? | - | 是否只读 |
| style | TDSearchStyle? | TDSearchStyle.square | 样式 |


  