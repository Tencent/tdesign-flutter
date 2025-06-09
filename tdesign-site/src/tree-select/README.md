---
title: TreeSelect 树形选择器
description: 适用于选择树形的数据结构
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

[td_tree_select_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_tree_select_page.dart)

### 1 组件类型

基础树形选择
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildDefaultTreeSelect(BuildContext context) {
    var options = <TDSelectOption>[];

    for (var i = 1; i <= 10; i++) {
      options.add(TDSelectOption(label: '选项$i', value: i, children: []));

      for (var j = 1; j <= 10; j++) {
        options[i - 1].children.add(TDSelectOption(
              label: '选项$i.$j',
              value: i * 10 + j,
              children: [],
            ));
      }
    }

    return TDTreeSelect(
      options: options,
      defaultValue: values1,
      onChange: (val, level) {
        print('$val, $level');
      },
    );
  }</pre>

</td-code-block>
                                  

多选树形选择
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildMultipleTreeSelect(BuildContext context) {
    var options = <TDSelectOption>[];

    for (var i = 1; i <= 10; i++) {
      options.add(TDSelectOption(label: '选项$i', value: i, children: []));

      for (var j = 1; j <= 10; j++) {
        options[i - 1].children.add(
            TDSelectOption(label: '选项$i.$j', value: i * 10 + j, children: []));
      }
    }

    return TDTreeSelect(
      options: options,
      defaultValue: values2,
      multiple: true,
      onChange: (val, level) {
        print('$val, $level');
      },
    );
  }</pre>

</td-code-block>
                                  
### 1 组件状态

三级树形选择
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildThirdTreeSelect(BuildContext context) {
    var options = <TDSelectOption>[];

    for (var i = 1; i <= 10; i++) {
      options.add(TDSelectOption(label: '选项$i', value: i, children: []));

      for (var j = 1; j <= 10; j++) {
        options[i - 1].children.add(
            TDSelectOption(label: '选项$i.$j', value: i * 10 + j, children: []));

        for (var k = 1; k <= 10; k++) {
          options[i - 1].children[j - 1].children.add(
              TDSelectOption(label: '选项$i.$j.$k', value: i * 100 + j * 10 + k));
        }
      }
    }

    return TDTreeSelect(
      options: options,
      defaultValue: values3,
      onChange: (val, level) {
        print('$val, $level');
      },
    );
  }</pre>

</td-code-block>
                                  


## API
### TDSelectOption
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| label | String | - | 标签 |
| value | int | - | 值 |
| children | List<TDSelectOption> | const [] | 子选项 |
| multiple | bool | false | 当前子项支持多选 |

```
```
 ### TDTreeSelect
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| options | List<TDSelectOption> | const [] | 展示的选项列表 |
| defaultValue | List<dynamic> | const [] | 初始值，对应options中的value值 |
| onChange | TDTreeSelectChangeEvent? | - | 选中值发生变化 |
| multiple | bool | false | 支持多选 |
| style | TDTreeSelectStyle | TDTreeSelectStyle.normal | 一级菜单样式 |
| height | double | 336 | 高度 |


  