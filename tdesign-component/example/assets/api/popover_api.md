## API
### TPopover

#### 静态方法

##### TPopover.showPopover

返回类型：`Future`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 上下文 |
| content | String? | - | 显示内容 |
| contentWidget | Widget? | - | 自定义内容 |
| offset | double | 4 | 偏移 |
| theme | TPopoverTheme? | - | 弹出气泡主题 |
| closeOnClickOutside | bool | true | - |
| placement | TPopoverPlacement? | - | 浮层出现位置 |
| showArrow | bool? | true | 是否显示浮层箭头 |
| arrowSize | double | 8 | 箭头大小 |
| padding | EdgeInsetsGeometry? | - | 内容内边距 |
| width | double? | - | 内容宽度（包含padding，实际高度：height - paddingLeft - paddingRight） |
| height | double? | - | 内容高度（包含padding，实际高度：height - paddingTop - paddingBottom） |
| overlayColor | Color? | Colors.transparent | - |
| onTap | OnTap? | - | 点击事件 |
| onLongTap | OnLongTap? | - | 长按事件 |
| radius | BorderRadius? | - | 圆角 |


### TPopoverWidget
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| arrowSize | double | 8 | 箭头大小 |
| content | String? | - | 显示内容 |
| contentWidget | Widget? | - | 自定义内容 |
| context | BuildContext | - | 上下文 |
| height | double? | - | 内容高度（包含padding，实际高度：height - paddingTop - paddingBottom） |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| offset | double | 4 | 偏移 |
| onLongTap | OnLongTap? | - | 长按事件 |
| onTap | OnTap? | - | 点击事件 |
| padding | EdgeInsetsGeometry? | - | 内容内边距 |
| placement | TPopoverPlacement? | - | 浮层出现位置 |
| radius | BorderRadius? | - | 圆角 |
| showArrow | bool? | true | 是否显示浮层箭头 |
| theme | TPopoverTheme? | - | 弹出气泡主题 |
| width | double? | - | 内容宽度（包含padding，实际高度：height - paddingLeft - paddingRight） |


### TPopoverTheme
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| dark | 暗色 |
| light | 亮色 |
| info | 品牌色 |
| success | 成功 |
| warning | 警告 |
| error | 错误 |


### TPopoverPlacement
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


### OnTap
#### 类型定义

```dart
typedef OnTap =  Function(String? content);
```


### OnLongTap
#### 类型定义

```dart
typedef OnLongTap =  Function(String? content);
```
