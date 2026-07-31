## API
### TPopover
#### 简介
气泡弹层
通过 `showPopover` 静态方法弹出，支持 12 个方向定位和箭头。

#### 静态方法

##### TPopover.showPopover

显示气泡弹层

返回类型：`Future`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 上下文 |
| content | String? | - | 显示内容 |
| contentWidget | Widget? | - | 自定义内容。 自定义 Widget 无法在首帧定位前可靠测量，使用时必须通过 `width`/`height` 或组件主题提供确定尺寸。 |
| offset | double? | - | 弹层与触发元素的间距。 |
| colorScheme | TPopoverColorScheme? | - | 气泡语义色。 |
| closeOnClickOutside | bool | true | 点击气泡外部区域时是否关闭弹层。 |
| placement | TPopoverPlacement? | - | 浮层出现位置 |
| showArrow | bool? | - | 是否显示气泡箭头。 |
| arrowSize | double? | - | 箭头尺寸。 |
| padding | EdgeInsetsGeometry? | - | 内容内边距。 |
| width | double? | - | 内容外框宽度（包含 padding）。 使用 `contentWidget` 时必须同时提供 `width` 和 `height`，也可以由 `TPopoverThemeData` 提供对应尺寸。 |
| height | double? | - | 内容外框高度（包含 padding）。 |
| overlayColor | Color? | - | 蒙层颜色。 |
| onTap | TPopoverTapCallback? | - | 点击事件 |
| onLongTap | TPopoverLongPressCallback? | - | 长按事件 |
| radius | BorderRadius? | - | 气泡圆角。 |


### TPopoverWidget
#### 简介
气泡弹层 Widget
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| arrowSize | double? | - | 箭头大小 |
| colorScheme | TPopoverColorScheme? | - | 弹出气泡主题 |
| content | String? | - | 显示内容 |
| contentWidget | Widget? | - | 自定义内容。 自定义 Widget 无法在首帧定位前可靠测量，使用时必须通过 `width`/`height` 或组件主题提供确定尺寸。 |
| context | BuildContext | - | 上下文 |
| height | double? | - | 内容外框高度（包含 padding）。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| offset | double? | - | 偏移 |
| onLongTap | TPopoverLongPressCallback? | - | 长按事件 |
| onTap | TPopoverTapCallback? | - | 点击事件 |
| padding | EdgeInsetsGeometry? | - | 内容内边距 |
| placement | TPopoverPlacement? | - | 浮层出现位置 |
| radius | BorderRadius? | - | 圆角 |
| showArrow | bool? | - | 是否显示浮层箭头 |
| width | double? | - | 内容外框宽度（包含 padding）。 |


### TPopoverPlacement
#### 简介
气泡弹层定位方向
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| topLeft | 上左 |
| top | 上 |
| topRight | 上右 |
| rightTop | 右上 |
| right | 右 |
| rightBottom | 右下 |
| bottomRight | 下右 |
| bottom | 下 |
| bottomLeft | 下左 |
| leftBottom | 左下 |
| left | 左 |
| leftTop | 左上 |


### TPopoverTapCallback
#### 简介
点击事件回调
#### 类型定义

```dart
typedef TPopoverTapCallback = void Function(String? content);
```


### TPopoverLongPressCallback
#### 简介
长按事件回调
#### 类型定义

```dart
typedef TPopoverLongPressCallback = void Function(String? content);
```
