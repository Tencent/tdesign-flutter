# TCell

`TCell` 是由 Widget 槽位组成的单元格。组件只保存按压视觉状态，不保存业务值。

## API

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `title` | `Widget?` | `null` | 标题区 |
| `subtitle` | `Widget?` | `null` | 副标题区 |
| `prefix` | `Widget?` | `null` | 标题左侧内容 |
| `image` | `Widget?` | `null` | 单元格左侧图片区 |
| `note` | `Widget?` | `null` | 右侧说明内容 |
| `trailing` | `Widget?` | `null` | 最右侧内容 |
| `arrow` | `bool` | `false` | 显示右箭头 |
| `required` | `bool` | `false` | 显示必填标记 |
| `align` | `TCellAlign?` | Theme / `center` | 垂直对齐方式 |
| `enableFeedback` | `bool` | `true` | 是否显示按压反馈 |
| `onTap` | `GestureTapCallback?` | `null` | 点击回调 |
| `onLongPress` | `GestureLongPressCallback?` | `null` | 长按回调 |

`title/subtitle/prefix/image/note/trailing` 均为单一 Widget 槽位，不接受多类型内容。

## Theme

`TCellThemeData` 为 Cell 提供文字样式、颜色、内边距、默认对齐、高度和底部分隔线等视觉默认。实例 `align` 优先于 Theme。

Theme 不保存内容 Widget、回调或按压状态。`enableFeedback` 属于实例交互配置。

## 验收要求

- 无 String/Widget 或 IconData/Widget 双轨参数。
- 内容参数统一使用 Widget，视觉默认值由 Theme 提供。
- `onTap` 与 `onLongPress` 均为空时不创建手势行为。
- Dartdoc 可由 tools 生成完整参数说明。
