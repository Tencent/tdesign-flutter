# 实施方案

## 技术方案

复用现有 `TDropdownMenu`、单选/多选面板与 `TDropdownThemeData`。默认值按 `组件 Theme > Flutter Theme > TDesign 语义 Token > 单一设计常量` 解析：字体、颜色、间距和圆角使用现有 Token；24px 图标容器、56px 单选行和 40px 多选项保留在现有 Theme 字段或单一内置默认中，不增加同义 API。Demo 启用 `compactDemo`，三列展开态按 Figma 构造 15 个选项并移除人为 280px 上限。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 示例 | `example/lib/page/t_dropdown_menu_page.dart` | 官方 Demo 矩阵 |
| 组件 | `lib/src/components/dropdown_menu/` | Figma 默认视觉与 Token 回退 |
| 测试 | `example/test/dropdown_menu_page_test.dart` | 入口与交互证据 |
| 生成文档 | `example/assets/code/dropdown_menu.*.txt` | 代码查看器片段 |

## API 变化

- 无新增、删除或签名变更。
- `TDropdownMenuController` 继续只负责跨树打开/关闭命令；选中值由声明式 `value(s) + callback` 持有，PanelController 只关闭当前局部面板，三者没有第二完成源。
- `placement`、`scrollable`、overlay 行为和 Theme 字段保留独立职责，不把 Figma 的 `active/disabled/checked` 组件属性新增为 Flutter 公共枚举。

## 风险与取舍

- 默认视觉变化会更新 DropdownMenu Golden，但不改变公开 API 签名、选中状态所有权或事件时序，因此不属于 breaking change。
- Flutter 扩展能力不进入公开 Demo，避免被误解为官方一对一场景。

## 验证策略

- 组件测试：全部 `test/components/dropdown_menu/`。
- Example 测试：官方入口矩阵、单选展开、三列 348px 展开态与禁用。
- 静态检查：Flutter 3.32.0 和 latest 严格 analyze。
- Golden：固定 Flutter 3.32.0 Linux 更新明暗整页、单选与三列展开态，并不带更新参数复跑。
- 人工验收：与 Figma `24386:5279` 和公开 Demo 的真实运行截图逐项对照。
