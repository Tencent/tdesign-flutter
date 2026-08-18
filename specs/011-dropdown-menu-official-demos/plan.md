# 实施方案

## 技术方案

仅改动 Example 层：多选用现有 `columns`，禁用用现有 `enabled`，direction 用现有 `placement` 和 `TDropdownMenuItem.custom`。组件层保持不变。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 示例 | `example/lib/page/t_dropdown_menu_page.dart` | 官方 Demo 矩阵 |
| 测试 | `example/test/dropdown_menu_page_test.dart` | 入口与交互证据 |
| 生成文档 | `example/assets/code/dropdown_menu.*.txt` | 代码查看器片段 |

## API 变化

- 无。

## 风险与取舍

- 组件默认勾选位置、空选行为和面板最大高度仍待维护者确认，不在本次无 API 补丁中擅自改动。
- Flutter 额外 Demo 保留在独立分组，避免被误解为官方一对一场景。

## 验证策略

- 组件测试：全部 `test/components/dropdown_menu/`。
- Example 测试：入口矩阵、禁用、向上展开与自定义图标。
- 静态检查：Flutter 3.32.0 和 latest 严格 analyze。
- 人工验收：真实运行时截图和交互。
