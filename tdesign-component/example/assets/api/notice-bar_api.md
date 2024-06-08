## API
### TDNoticeBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| context | dynamic | - | 文本内容 |
| style | TDNoticeBarStyle? | - | 公告栏样式 |
| left | Widget? | - | 左侧内容（自定义左侧内容，优先级高于prefixIcon） |
| right | Widget? | - | 侧内容（自定义右侧内容，优先级高于suffixIcon） |
| marquee | bool? | false | 跑马灯效果 |
| speed | double? | 50 | 滚动速度 |
| interval | int? | 3000 | 步进滚动间隔时间（毫秒） |
| direction | Axis? | Axis.horizontal | 滚动方向 |
| theme | TDNoticeBarThemez? | TDNoticeBarThemez.info | 主题 |
| prefixIcon | IconData? | - | 左侧图标 |
| suffixIcon | IconData? | - | 右侧图标 |
| onTap | ValueChanged<dynamic>? | - | 点击事件 |

```
```
### TDNoticeBarStyle
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext? | - | 上下文 |
| backgroundColor | Color? | - | 公告栏的背景色 |
| leftIconColor | Color? | - | 公告栏左侧图标的颜色 |
| rightIconColor | Color? | - | 公告栏右侧图标的颜色 |
| padding | EdgeInsetsGeometry? | EdgeInsets.only(top: 13, bottom: 13, left: 16, right: 12) | 公告栏的内边距 |
| textStyle | TextStyle? | TextStyle(color: TDTheme.of(context).fontGyColor1, fontSize: 16, height: 1) | 公告栏内容的文本样式 |

