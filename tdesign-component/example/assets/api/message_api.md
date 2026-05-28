## API
### TMessage
#### 简介
TMessage 组件

#### 静态方法

##### TMessage.showMessage

返回类型：`void`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | - |
| content | String? | - | 通知内容 |
| visible | bool? | - | 是否显示 |
| duration | int? | - | 消息内置计时器 |
| closeBtn | dynamic | - | 关闭按钮 |
| icon | dynamic | - | 自定义消息前面的图标 |
| link | dynamic | - | 链接名称 |
| marquee | MessageMarquee? | - | 跑马灯效果 |
| offset | List<double>? | - | 相对于 placement 的偏移量 |
| theme | MessageTheme? | - | 消息组件风格 info/success/warning/error |
| onCloseBtnClick | VoidCallback? | - | 点击关闭按钮触发 |
| onDurationEnd | VoidCallback? | - | 计时结束后触发 |
| onLinkClick | VoidCallback? | - | 点击链接文本时触发 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| closeBtn | dynamic | - | 关闭按钮 |
| content | String? | - | 通知内容 |
| duration | int? | 3000 | 消息内置计时器 |
| icon | dynamic | true | 自定义消息前面的图标 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| link | dynamic | - | 链接名称 |
| marquee | MessageMarquee? | - | 跑马灯效果 |
| offset | List<double>? | - | 相对于 placement 的偏移量 |
| onCloseBtnClick | VoidCallback? | - | 点击关闭按钮触发 |
| onDurationEnd | VoidCallback? | - | 计时结束后触发 |
| onLinkClick | VoidCallback? | - | 点击链接文本时触发 |
| theme | MessageTheme? | MessageTheme.info | 消息组件风格 info/success/warning/error |
| visible | bool? | true | 是否显示 |


### MessageMarquee
#### 简介
跑马灯配置
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| delay | int? | - | 延迟时间(毫秒) |
| loop | int? | - | 循环次数 |
| speed | int? | - | 速度 |


### MessageLink
#### 简介
链接设置
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| color | Color? | - | 颜色 |
| name | String | - | 名称 |
| uri | Uri? | - | 资源链接 |


### MessageTheme
#### 简介
定义消息主题枚举
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| info | 普通通知 |
| success | 成功通知 |
| warning | 警示通知 |
| error | 错误通知 |
