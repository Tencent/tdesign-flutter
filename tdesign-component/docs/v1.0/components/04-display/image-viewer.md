# TImageViewer

`TImageViewer.show` 打开全屏图片预览。图片来源使用 Flutter `ImageProvider<Object>`，不做运行时动态类型分派。

## Show API

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `context` | `BuildContext` | 必填 | 路由上下文 |
| `images` | `List<ImageProvider<Object>>` | 必填 | 图片列表 |
| `labels` | `List<String>?` | `null` | 与图片一一对应的标签 |
| `initialIndex` | `int` | `0` | 初始页 |
| `showClose` | `bool` | `true` | 显示关闭按钮 |
| `showDelete` | `bool` | `false` | 显示删除按钮 |
| `showIndex` | `bool` | `true` | 显示页码 |
| `loop` | `bool` | `false` | 循环轮播 |
| `autoplay` | `bool` | `false` | 自动轮播 |
| `autoplayInterval` | `Duration` | 3 秒 | 自动播放间隔 |
| `barrierDismissible` | `bool` | `true` | 点击遮罩关闭 |
| `onIndexChanged` | `ValueChanged<int>?` | `null` | 页切换通知 |
| `onClose` | `VoidCallback?` | `null` | 关闭通知 |
| `onDelete` | `ValueChanged<int>?` | `null` | 删除请求 |
| `onTap/onLongPress` | `ValueChanged<int>?` | `null` | 图片手势通知 |
| `leadingBuilder/trailingBuilder` | `TImageViewerItemBuilder?` | `null` | 导航栏槽位 |

## 状态边界

浮层持有当前临时页索引。图片列表属于调用方，删除按钮只通知 `onDelete`，不会复制或修改图片列表。

## Theme

`TImageViewerThemeData` 保存背景、导航栏、图标、标签、页码、遮罩和预览尺寸等视觉默认。图片、标签、索引和回调不进入 Theme。
