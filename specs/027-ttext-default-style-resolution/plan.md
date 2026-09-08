# 实施方案

## 技术方案

移除“只要存在显式 TextTheme 就把继承样式视为显式”的捷径。统一将继承
DefaultTextStyle 与当前 Material TextTheme 的各语义样式比较；相同则判定为
框架自动注入并过滤。Flutter 的诊断 fallback 样式也明确过滤。其他样式继续作为调用方
局部覆盖进入既有 TTextResolve 合并链。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 主题基础设施 | lib/src/theme/t_theme.dart | 修正显式 DefaultTextStyle 判定 |
| TText | test/components/text/t_text_resolve_test.dart | 固定 TextTheme 与局部样式优先级 |
| Popover 公开示例 | example/lib/page/t_popover_page.dart | 自定义内容随正确行高自适应高度 |
| 全组件 | 集中式组件与视觉回归 | 扫描共享解析变化的实际影响 |
| Golden | 256 张已登记基线 | 记录恢复 bodyLarge 后的预期排版 |
| 文档 | specs/027-ttext-default-style-resolution/ | 记录契约和验收证据 |

## API 变化

- 无。仅修复内部主题解析行为。

## 风险与取舍

- 共享解析会影响所有通过 TTextResolve 或 tExplicitDefaultTextStyle 获取文字样式的组件，
  不能只跑 TText 聚焦测试。
- 如果 Golden 变化，必须逐项确认来自文字层级恢复，不能批量更新掩盖非预期布局变化。

## 验证策略

- 单元及 Widget 测试：显式 TextTheme、局部 DefaultTextStyle、诊断 fallback。
- 组件回归：运行集中式全组件调度器并检查各组件生产覆盖率。
- 静态检查：Flutter 3.32.0 与 latest 分别对组件包和示例工程 analyze。
- 视觉回归：Flutter 3.32.0 Linux 运行全部 Golden；有意更新后立即严格复跑。
