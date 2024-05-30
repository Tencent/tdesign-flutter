## API
### TDNoticeBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
|------------------|---------------------|---------------------------------------------------|--------------|
| key |  | - |  |
| text | String? | - | 显示内容 |
| textList | List<String>? | - | 步进滚动内容 |
| textStyle | TextStyle? | - | 文字样式 |
| left | Widget? | - | 左侧内容 |
| right | Widget? | - | 右侧内容 |
| backgroundColor | Color? | Colors.white | 背景色 |
| padding | EdgeInsetsGeometry? | EdgeInsets.symmetric(horizontal: 16, vertical: 8) | 内边距 |
| duration | int? | 3000 | 滚动周期（毫秒） |
| interval | int? | 2000 | 步进滚动间隔时间（毫秒） |
| type | TdNoticeBarType? | TdNoticeBarType.scroll | 滚动类型 |
