# 实施方案

## 技术方案

仅调整现有列表和宫格的 token/尺寸，不增加公开 API。Example 按小程序 `_example` 的 list、grid、status 和 align 四组源码拆成 9 个独立入口，使用现有 Flutter Widget 表达图标与状态。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `t_action_sheet_list.dart`, `t_action_sheet_grid.dart` | 可见尺寸与 token 对齐 |
| 测试 | `test/components/action_sheet/` | 保护样式契约 |
| 示例 | `example/lib/page/t_action_sheet_page.dart` | 官方 Demo 矩阵 |
| 文档 | `example/assets/code/action_sheet.*.txt` | 代码查看器片段 |

## API 变化

- 无。

## 风险与取舍

- 84 高度会增加带描述列表的垂直空间，这是为了匹配官方视觉规范。
- Flutter Demo 使用本地 TDesign 图标表达小程序的远程社交平台图片，避免把网络可用性变成组件验收前提。

## 验证策略

- 单元测试：ActionSheet 全部 Widget 测试。
- 集成或 Widget 测试：验证描述项高度、颜色 token 与分页点。
- 静态检查：Flutter 3.32.0 与 latest 严格 analyze。
- 人工验收：实机/浏览器打开 9 个入口，与小程序截图叠加对照。
