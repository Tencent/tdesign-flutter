---
title: Popover 弹出气泡
description: 用于文字提示的气泡框。
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

以下示例代码直接来自 Example App 的 `@ExampleCode(group: "popover")` 生成资产，Web 文档不维护代码副本。

{{ flutter-example-group popover }}

## 从旧版 API 迁移

- 文本内容由 `content: '提示内容'` 改为 `content: const Text('提示内容')`。
- 自定义内容由 `contentWidget: widget` 改为 `content: widget`，不再需要为了首帧定位强制指定 `width` 和 `height`。
- `onTap`、`onLongTap` 改为无参数回调；内容已由调用方持有，无需从回调重复获取。
- `placement` 可省略，默认使用 `TPopoverPlacement.top`。
- `TPopoverWidget` 不再作为公开入口；统一通过 `TPopover.showPopover` 管理 Overlay 和生命周期。

## API
### TPopover
#### 简介
气泡弹层
通过 `showPopover` 静态方法弹出，支持 12 个方向定位和箭头。

#### 静态方法

##### TPopover.showPopover

显示气泡弹层

返回类型：`Future<void>`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 触发元素的上下文，用于计算气泡锚点位置。 |
| content | Widget | - | 气泡内容。直接传入未设置样式的 `Text` 时使用气泡默认文字样式；组合内容应自行定义子组件样式和布局。 |
| offset | double? | - | 弹层与触发元素的间距。 |
| colorScheme | TPopoverColorScheme | TPopoverColorScheme.defaultTheme | 气泡预设配色。 |
| closeOnClickOutside | bool | true | 点击气泡外部区域时是否关闭弹层。 |
| closeOnScroll | bool | true | 页面滚动时是否关闭弹层。 默认为 true，避免触发元素移动后气泡停留在旧坐标。 |
| placement | TPopoverPlacement | TPopoverPlacement.top | 浮层出现位置，默认为 `TPopoverPlacement.top`。 |
| showArrow | bool? | - | 是否显示气泡箭头。 |
| arrowSize | double? | - | 箭头尺寸。 |
| padding | EdgeInsetsGeometry? | - | 内容内边距。 |
| width | double? | - | 内容外框宽度（包含 padding）。未设置时按 `content` 的实际布局宽度确定，并受组件主题尺寸约束。 |
| height | double? | - | 内容外框高度（包含 padding）。未设置时按 `content` 的实际布局高度确定，并受组件主题尺寸约束。 |
| overlayColor | Color? | - | 蒙层颜色。 |
| onTap | VoidCallback? | - | 点击气泡内容时触发。 |
| onLongTap | VoidCallback? | - | 长按气泡内容时触发。 |
| radius | BorderRadius? | - | 气泡圆角。 |

### TPopoverColorScheme
#### 简介
弹出气泡预设配色。
#### 枚举值

| 名称 | 说明 |
| --- | --- |
| defaultTheme | 默认深色配色。 |
| light | 浅色。 |
| primary | 品牌主色。 |
| success | 成功。 |
| warning | 警告。 |
| danger | 危险色。 |

### TPopoverPlacement
#### 简介
气泡弹层定位方向
#### 枚举值

| 名称 | 说明 |
| --- | --- |
| topLeft | 上左。 |
| top | 上方。 |
| topRight | 上右。 |
| rightTop | 右上。 |
| right | 右侧。 |
| rightBottom | 右下。 |
| bottomRight | 下右。 |
| bottom | 下方。 |
| bottomLeft | 下左。 |
| leftBottom | 左下。 |
| left | 左侧。 |
| leftTop | 左上。 |
