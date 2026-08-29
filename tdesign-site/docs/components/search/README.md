---
title: Search 搜索框
description: 用于用户输入搜索信息，并进行页面内容搜索。
spline: base
isComponent: true
---

## 引入

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

[t_search_bar_page.dart](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/example/lib/page/t_search_bar_page.dart)

### 基础搜索框

搜索结果是业务内容，通过 `TCell` 在搜索框下方组合，不属于 `TSearchBar` 公共 API。

```dart
TSearchBar(
  controller: controller,
  hintText: '输入tdesign，有预览结果',
  onChanged: filterResults,
  onFocusChanged: handleFocusChanged,
)
```

### 字数限制

```dart
TSearchBar(hintText: '最大输入10个字符', maxLength: 10)
TSearchBar(hintText: '最大输入10个字符，汉字算两个', maxCharacter: 10)
```

### 获取焦点后显示取消按钮

```dart
TSearchBar(
  controller: controller,
  hintText: '搜索预设文案',
  textAlignment: TSearchBarAlignment.center,
  actionText: focused ? '取消' : null,
  onFocusChanged: (value) => setState(() => focused = value),
  onActionPressed: () {
    controller.clear();
    FocusManager.instance.primaryFocus?.unfocus();
  },
)
```

### 搜索框形状与对齐

```dart
const TSearchBar(variant: TSearchBarVariant.round)
const TSearchBar(textAlignment: TSearchBarAlignment.center)
```

## API

### TSearchBar

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| controller | TextEditingController? | - | 文本控制器 |
| initialValue | String? | - | 初始文本，不能与 controller 同时设置 |
| hintText | String? | - | 占位提示 |
| actionText | String? | - | 右侧操作文案；为空时不占空间 |
| onActionPressed | VoidCallback? | - | 操作点击回调，不隐式清空或失焦 |
| onChanged / onSubmitted | ValueChanged&lt;String&gt;? | - | 文本变化与提交通知 |
| onFocusChanged | ValueChanged&lt;bool&gt;? | - | 焦点变化通知 |
| onClearPressed | VoidCallback? | - | 清除按钮点击回调 |
| enabled / readOnly | bool | true / false | 可交互与只读状态 |
| clearable / autofocus | bool | true / false | 清除按钮与自动聚焦 |
| inputType | TextInputType | TextInputType.text | 键盘类型 |
| inputAction | TextInputAction | TextInputAction.search | 键盘动作 |
| inputFormatters | List&lt;TextInputFormatter&gt;? | - | 输入格式化器 |
| maxLength | int? | - | 最大字符数 |
| maxCharacter | int? | - | 加权字符数，ASCII=1、非 ASCII=2；与 maxLength 互斥 |
| variant | TSearchBarVariant? | square | `square` 或 `round` |
| textAlignment | TSearchBarAlignment? | left | `left` 或 `center` |
| focusNode | FocusNode? | - | 自定义焦点节点 |

视觉默认值通过 `TSearchBarThemeData` 配置，包括高度、背景、内部留白、文字与图标样式、操作间距及光标高度。
