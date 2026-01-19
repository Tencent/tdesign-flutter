## API
### TDNoticeBar
#### 简介

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| content | dynamic | - | 文本内容（字符串或字符串数组等） |
| context | dynamic | - | 文本内容（请使用content属性） |
| direction | Axis? | Axis.horizontal | 滚动方向 |
| height | double | 22 | 文字高度 (当使用prefixIcon或suffixIcon时，icon大小值等于该属性） |
| interval | int? | 3000 | 步进滚动间隔时间（毫秒） |
| key |  | - |  |
| left | Widget? | - | 左侧内容（自定义左侧内容，优先级高于prefixIcon） |
| marquee | bool? | false | 跑马灯效果 |
| maxLines | int? | 1 | 文本行数（仅静态有效） |
| onTap | ValueChanged? | - | 点击事件 |
| prefixIcon | IconData? | - | 左侧图标 |
| right | Widget? | - | 右侧内容（自定义右侧内容，优先级高于suffixIcon） |
| speed | double? | 50 | 滚动速度 |
| style | TDNoticeBarStyle? | - | 公告栏样式 [TDNoticeBarStyle] |
| suffixIcon | IconData? | - | 右侧图标 |
| theme | TDNoticeBarTheme? | TDNoticeBarTheme.info | 主题 |

```
```
 ### TDNoticeBarStyle
#### 简介
公告栏样式
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 公告栏背景色 |
| context | BuildContext? | - | 上下文 |
| leftIconColor | Color? | - | 公告栏左侧图标颜色 |
| padding | EdgeInsetsGeometry? | - | 公告栏内边距 |
| rightIconColor | Color? | - | 公告栏右侧图标颜色 |
| textStyle | TextStyle? | - | 公告栏内容样式 |


#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TDNoticeBarStyle.generateTheme  | 根据主题生成样式 |
