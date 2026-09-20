---
title: Cascader 级联选择器
description: 用于多层级数据的逐级选择
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

{{ flutter-example-group cascader }}

## API
### TMultiCascader
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| action | TCascaderAction? | - | 自定义选择器右上角按钮 |
| backgroundColor | Color? | - | 背景颜色 |
| cascaderHeight | double | - | 选择器List的视窗高度，默认200 |
| closeText | String? | - | 关闭按钮文本 |
| data | List<Map> | - | 选择器的数据源 |
| initialData | String? | - | 初始化数据 |
| initialIndexes | List<int>? | - | 若为null表示全部从零开始 |
| isLetterSort | bool | false | 是否开启字母排序 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onChange | MultiCascaderCallback | - | 值发生变更时触发 |
| onClose | Function? | - | 选择器关闭按钮回调 |
| subTitles | List<String>? | - | 每级展示的次标题 |
| theme | String? | - | 展示风格 可选项：step/tab |
| title | String? | - | 选择器标题 |
| titleStyle | TextStyle? | - | 标题样式 |
| topRadius | double? | - | 顶部圆角 |


### MultiCascaderCallback
#### 类型定义

```dart
typedef MultiCascaderCallback = void Function(List<MultiCascaderListModel> selected);
```


  