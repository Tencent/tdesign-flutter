## API
### TDPopover
#### 简介


#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| showPopover |  |   required BuildContext context,  String? content,  Widget? contentWidget,  double offset,  TDPopoverTheme? theme,  bool closeOnClickOutside,  TDPopoverPlacement? placement,  bool? showArrow,  double arrowSize,  EdgeInsetsGeometry? padding,  double? width,  double? height,  Color? overlayColor,  OnTap? onTap,  OnLongTap? onLongTap, |  |

```
```
 ### TDPopoverWidget
#### 简介

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| context | BuildContext | - | 上下文 |
| content | String? | - | 显示内容 |
| contentWidget | Widget? | - | 自定义内容 |
| offset | double | 4 | 偏移 |
| theme | TDPopoverTheme? | - | 弹出气泡主题 |
| placement | TDPopoverPlacement? | - | 浮层出现位置 |
| showArrow | bool? | true | 是否显示浮层箭头 |
| arrowSize | double | 8 | 箭头大小 |
| padding | EdgeInsetsGeometry? | - | 内容内边距 |
| width | double? | - | 内容宽度（包含padding，实际高度：height - paddingLeft - paddingRight） |
| height | double? | - | 内容高度（包含padding，实际高度：height - paddingTop - paddingBottom） |
| onTap | OnTap? | - | 点击事件 |
| onLongTap | OnLongTap? | - | 长按事件 |
