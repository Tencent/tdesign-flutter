## API
### TDPopover
#### 简介


#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| showPopover |  |   required BuildContext context,  String? content,  Widget? contentWidget,  double offset,  TDPopoverTheme? theme,  bool closeOnClickOutside,  TDPopoverPlacement? placement,  bool? showArrow,  double arrowSize,  EdgeInsetsGeometry? padding,  double? width,  double? height,  Color? overlayColor,  OnTap? onTap,  OnLongTap? onLongTap,  BorderRadius? radius, |  |

```
```
 ### TDPopoverWidget
#### 简介

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| arrowSize | double | 8 | 箭头大小 |
| content | String? | - | 显示内容 |
| contentWidget | Widget? | - | 自定义内容 |
| context | BuildContext | - | 上下文 |
| height | double? | - | 内容高度（包含padding，实际高度：height - paddingTop - paddingBottom） |
| key |  | - |  |
| offset | double | 4 | 偏移 |
| onLongTap | OnLongTap? | - | 长按事件 |
| onTap | OnTap? | - | 点击事件 |
| padding | EdgeInsetsGeometry? | - | 内容内边距 |
| placement | TDPopoverPlacement? | - | 浮层出现位置 |
| radius | BorderRadius? | - | 圆角 |
| showArrow | bool? | true | 是否显示浮层箭头 |
| theme | TDPopoverTheme? | - | 弹出气泡主题 |
| width | double? | - | 内容宽度（包含padding，实际高度：height - paddingLeft - paddingRight） |
