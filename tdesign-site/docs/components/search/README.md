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

以下示例代码直接来自 Example App 的 `@ExampleCode(group: "search")` 生成资产，Web 文档不维护代码副本。

{{ flutter-example-group search }}

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
