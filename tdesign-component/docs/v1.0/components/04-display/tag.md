# TTag

> **状态**：已实现 | **控制类**：A | **Sprint**：S3

**源码路径**：`lib/src/components/tag`

## 架构

`TTag` 是标签组件族的展示与基础交互组件。关闭能力、启用状态和回调属于实例语义；`TTagThemeData` 只保存颜色、排版、间距和形状默认值。

## API

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `text` | `String` | 必填 | 标签文案 |
| `colorScheme` | `TTagColorScheme?` | `null` | 语义色 |
| `icon` | `IconData?` | `null` | 标签图标 |
| `size` | `TTagSize` | `medium` | 标签尺寸 |
| `needCloseIcon` | `bool` | `false` | 是否显示关闭图标 |
| `enabled` | `bool` | `true` | 是否使用启用视觉状态 |
| `onTap` | `GestureTapCallback?` | `null` | 标签点击回调 |
| `onCloseTap` | `GestureTapCallback?` | `null` | 关闭图标点击回调 |

## Theme

`TTagThemeData` 可配置默认语义色、文字和背景色、字体、padding、描边、形状、浅色模式、溢出和固定宽度。Theme 不包含 Widget、回调、关闭能力或 enabled 状态。

## Export

公开导出 `TTag`、`TTagSize`、`TTagShape`、`TTagColorScheme` 和 `TTagThemeData`。

## 验收

- 全部尺寸、形状、语义色、启用态、图标和关闭行为均有测试。
- Tag 组件族源码逐文件覆盖率均高于 96%。
