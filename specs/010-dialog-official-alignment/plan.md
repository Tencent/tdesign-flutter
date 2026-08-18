# 实施方案

## 技术方案

直接修正两个已有默认样式值。Example 层用现有 `Widget` 槽位和操作区组合能力表达官方场景，不增加与 Flutter 组合模型重复的便捷 API。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `t_dialog.dart` | 默认可见间距 |
| 测试 | `test/components/dialog/` | 样式和 ThemeData 契约 |
| 示例 | `example/lib/page/t_dialog_page.dart` | 21 场景公开矩阵 |
| 示例测试 | `example/test/dialog_page_test.dart` | 入口和关键组合交互 |
| 生成文档 | `example/assets/code/dialog.*.txt` | 代码查看器片段 |

## API 变化

- 无。

## 风险与取舍

- 默认可见间距发生 8px 变化，需在 PR 更新日志中向用户明确说明。
- Example 图片复用仓库已打包资源，避免网络不可用导致 Demo 空白。

## 验证策略

- 单元/Widget 测试：Dialog 组件全部聚焦测试。
- Example 测试：入口矩阵、图片组合和垂直按钮。
- 静态检查：Flutter 3.32.0 和 latest 严格 analyze。
- 人工验收：375px 视口像素截图与交互对照。
