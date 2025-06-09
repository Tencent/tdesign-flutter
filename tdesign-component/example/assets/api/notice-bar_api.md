## API
### TDNoticeBarStyle
#### 简介
公告栏样式
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext? | - | 上下文 |
| backgroundColor | Color? | - | 公告栏背景色 |
| textStyle | TextStyle? | - | 公告栏内容样式 |
| leftIconColor | Color? | - | 公告栏左侧图标颜色 |
| rightIconColor | Color? | - | 公告栏右侧图标颜色 |
| padding | EdgeInsetsGeometry? | - | 公告栏内边距 |


#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TDNoticeBarStyle.generateTheme  | 根据主题生成样式 |

```
```
 ### TDNoticeBar
#### 简介

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| context | dynamic | - | 文本内容 |
| style | TDNoticeBarStyle? | - | 公告栏样式 |
| left | Widget? | - | 左侧内容（自定义左侧内容，优先级高于prefixIcon） |
| right | Widget? | - | 右侧内容（自定义右侧内容，优先级高于suffixIcon） |
| speed | double? | 50 | 滚动速度 |
| interval | int? | 3000 | 步进滚动间隔时间（毫秒） |
| marquee | bool? | false | 跑马灯效果 |
| direction | Axis? | Axis.horizontal | 滚动方向 |
| theme | TDNoticeBarTheme? | TDNoticeBarTheme.info | 主题 |
| prefixIcon | IconData? | - | 左侧图标 |
| suffixIcon | IconData? | - | 右侧图标 |
| onTap | ValueChanged? | - | 点击事件 |
| height | double | 22 | 文字高度 (当使用prefixIcon或suffixIcon时，icon大小值等于该属性） |
| maxLines | int? | 1 | 文本行数（仅静态有效） |
