---
title: Avatar 头像
description: 用于展示用户头像信息，除了纯展示也可点击进入个人详情等操作。
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

以下示例代码直接来自 Example App 的 `@ExampleCode(group: "avatar")` 生成资产，Web 文档不维护代码副本。

{{ flutter-example-group avatar }}

## API
### TAvatar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| avatarDisplayBorder | double | 2 | 带操作展示的头像描边宽度 |
| avatarDisplayList | List<String>? | - | 带操作展示的头像列表 |
| avatarDisplayListAsset | List<String>? | - | 带操作展示的头像列表（本地资源） |
| avatarDisplayWidget | Widget? | - | 带操作头像自定义操作Widget |
| avatarSize | double? | - | 自定义头像大小 |
| avatarUrl | String? | - | 头像地址 |
| backgroundColor | Color? | - | 自定义文案时背景色 |
| defaultUrl | String | '' | 默认图片（本地） |
| displayText | String? | - | 纯展示类型末尾文字 |
| fit | BoxFit? | - | 自定义图片对齐方式 |
| icon | IconData? | - | 自定义图标 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onTap | Function()? | - | 操作点击事件 |
| radius | double? | - | 自定义圆角 |
| shape | TAvatarShape | TAvatarShape.circle | 头像形状 |
| size | TAvatarSize | TAvatarSize.medium | 头像尺寸 |
| text | String? | - | 自定义文字 |
| type | TAvatarType | TAvatarType.normal | 头像类型 |


### TAvatarSize
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| large | - |
| medium | - |
| small | - |


### TAvatarType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| icon | - |
| normal | - |
| customText | - |
| display | - |
| operation | - |


### TAvatarShape
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| circle | - |
| square | - |


  