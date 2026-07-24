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
| contentWidget | Widget? | - | 自定义内容 |
| offset | double | 4 | 弹层与触发元素的间距。 |
| colorScheme | TPopoverColorScheme? | - | 气泡语义色。 |
| closeOnClickOutside | bool | true | 点击气泡外部区域时是否关闭弹层。 |
| placement | TPopoverPlacement? | - | 浮层出现位置 |
| showArrow | bool? | true | 是否显示气泡箭头。 |
| arrowSize | double | 8 | 箭头尺寸。 |
| padding | EdgeInsetsGeometry? | - | 内容内边距。 |
| width | double? | - | 内容宽度。 |
| height | double? | - | 内容高度。 |
| overlayColor | Color? | Colors.transparent | 蒙层颜色。 |
| onTap | TPopoverTapCallback? | - | 点击事件 |
| onLongTap | TPopoverLongPressCallback? | - | 长按事件 |
| radius | BorderRadius? | - | 气泡圆角。 |


### TPopoverWidget
#### 简介
气泡弹层 Widget
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| arrowSize | double | 8 | 箭头大小 |
| colorScheme | TPopoverColorScheme? | - | 弹出气泡主题 |
| content | String? | - | 显示内容 |
| contentWidget | Widget? | - | 自定义内容 |
| context | BuildContext | - | 上下文 |
| height | double? | - | 内容高度（包含padding，实际高度：height - paddingTop - paddingBottom） |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| offset | double | 4 | 偏移 |
| onLongTap | TPopoverLongPressCallback? | - | 长按事件 |
| onTap | TPopoverTapCallback? | - | 点击事件 |
| padding | EdgeInsetsGeometry? | - | 内容内边距 |
| placement | TPopoverPlacement? | - | 浮层出现位置 |
| radius | BorderRadius? | - | 圆角 |
| showArrow | bool? | true | 是否显示浮层箭头 |
| width | double? | - | 内容宽度（包含padding，实际高度：height - paddingLeft - paddingRight） |


### TPopoverThemeData
#### 简介
TPopover 组件级 ThemeExtension
通过 Theme 子树注入，控制子树的默认气泡样式。

#### 静态方法

##### TPopoverThemeData.lerpDouble

返回类型：`double?`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| a | double? | - | 起始值。 |
| b | double? | - | 目标值。 |
| t | double | - | 插值进度。 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| arrowSize | double? | - | 箭头尺寸 |
| backgroundColor | Color? | - | 气泡背景色 |
| barrierColor | Color? | - | 蒙层色 |
| borderRadius | double? | - | 圆角 |
| colorScheme | TPopoverColorScheme? | - | 语义色 |
| maxHeight | double? | - | 最大高度 |
| minWidth | double? | - | 最小宽度 |
| offset | double? | - | 弹层与触发元素的间距 |
| padding | EdgeInsetsGeometry? | - | 内边距 |
| showArrow | bool? | - | 是否显示箭头 |


### TPopoverColorScheme
#### 简介
TPopover 语义色
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| dark | 深色 |
| light | 浅色 |
| info | 信息 |
| success | 成功 |
| warning | 警告 |
| error | 错误 |


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
