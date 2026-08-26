# 实施方案

## 技术方案

在现有 `TUpload` 的受控渲染基础上增加 `TUploadLayout` 分支。宫格继续复用现有 `Wrap`；列表在组件内复用 `TButton` 并渲染文件行，与小程序的默认顺序、容器 token、间距、图标尺寸和失败颜色保持一致。两种布局均使用 Flutter 原生长按拖拽手势排序文件，结果通过既有 `onChanged` 回传。Demo 不复制组件样式，只传入官方分组、数据和交互状态。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `lib/src/components/upload` | 新增列表布局、retryableError 状态、禁用遮罩和拖拽排序 |
| 测试 | `test/components/upload` | 增加视觉契约回归 |
| 示例 | `example/lib/page/t_upload_page.dart` | 对齐官方分组和禁用示例 |
| 文档 | `tool/components.json`、生成资产 | 暴露新增类型并同步代码片段 |

## API 变化

- 新增可选 `TUpload.layout`，默认 `TUploadLayout.grid`。
- 新增可选 `TUpload.draggable`，默认 `false`；排序继续使用 `onChanged`，不新增状态专用回调。
- 新增 `TUploadLayout.list`。
- 新增 `TUploadFileStatus.retryableError`。
- 使用统一的 `TUpload.onFileTap` 替代状态特定的 `onPreview` / `onRetry`，由调用方根据文件状态决定后续行为。
- 新增主题可选字段 `disabledMaskColor`。

## 风险与取舍

- 拖拽使用 Flutter 原生手势并保持受控状态，不复制小程序振动和过渡配置。
- `onPreview` / `onRetry` 收敛为 `onFileTap`，调用方需迁移为基于 `file.status` 的业务分发。

## 验证策略

- 单元测试：文件状态、copyWith、ThemeExtension。
- Widget 测试：宫格 / 列表、禁用遮罩、拖拽排序和回调。
- 静态检查：`flutter analyze`、示例分析、生成资产检查。
- 人工验收：对照小程序 Upload 三组 Demo 检查布局和状态。
