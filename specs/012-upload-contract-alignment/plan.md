# 实施方案

## 技术方案

在现有 `TUpload` 的受控渲染基础上增加 `TUploadLayout` 分支。宫格继续复用现有 `Wrap`；列表使用内部 Row/Column 渲染缩略图、文件名、辅助信息和删除操作。状态遮罩根据 `TUploadFileStatus` 选择进度、刷新或错误图标。禁用遮罩只覆盖已有媒体预览，不影响上传状态遮罩。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `lib/src/components/upload` | 新增列表布局、retryableError 状态、禁用遮罩 |
| 测试 | `test/components/upload` | 增加视觉契约回归 |
| 示例 | `example/lib/page/t_upload_page.dart` | 对齐官方分组和禁用示例 |
| 文档 | `tool/components.json`、生成资产 | 暴露新增类型并同步代码片段 |

## API 变化

- 新增可选 `TUpload.layout`，默认 `TUploadLayout.grid`。
- 新增 `TUploadLayout.list`。
- 新增 `TUploadFileStatus.retryableError`。
- 新增主题可选字段 `disabledMaskColor`。

## 风险与取舍

- 列表布局只覆盖小程序 Demo 的基础文件信息表现，不复制平台拖拽与请求 API。
- 新增状态枚举不改变既有 `error` 语义；已有调用继续显示失败状态。

## 验证策略

- 单元测试：文件状态、copyWith、ThemeExtension。
- Widget 测试：宫格 / 列表、禁用遮罩和回调。
- 静态检查：`flutter analyze`、示例分析、生成资产检查。
- 人工验收：对照小程序 Upload 三组 Demo 检查布局和状态。
