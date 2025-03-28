## API
### MessageLink
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| name | String | - | 名称 |
| uri | Uri? | - | 资源链接 |
| color | Color? | - | 颜色 |

```
```
 ### MessageMarquee
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| speed | int? | - | 速度 |
| loop | int? | - | 循环次数 |
| delay | int? | - | 延迟时间(毫秒) |

```
```
 ### TDMessage
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| closeBtn | dynamic | - | 关闭按钮 |
| content | String? | - | 通知内容 |
| duration | int? | 3000 | 消息内置计时器 |
| icon | dynamic | true | 自定义消息前面的图标 |
| link | dynamic | - | 链接名称 |
| marquee | MessageMarquee? | - | 跑马灯效果 |
| offset | List<double>? | - | 相对于 placement 的偏移量 |
| theme | MessageTheme? | MessageTheme.info | 消息组件风格 info/success/warning/error |
| visible | bool? | true | 是否显示 |
| onCloseBtnClick | VoidCallback? | - | 点击关闭按钮触发 |
| onDurationEnd | VoidCallback? | - | 计时结束后触发 |
| onLinkClick | VoidCallback? | - | 点击链接文本时触发 |


#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| showMessage |  |   required BuildContext context,  String? content,  bool? visible,  int? duration,  dynamic closeBtn,  dynamic icon,  dynamic link,  MessageMarquee? marquee,  List<double>? offset,  MessageTheme? theme,  VoidCallback? onCloseBtnClick,  VoidCallback? onDurationEnd,  VoidCallback? onLinkClick, |  |
