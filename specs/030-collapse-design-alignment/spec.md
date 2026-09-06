# Collapse 设计对齐

## 证据与目标

- Flutter 基线：`origin/develop@2ed620b9`。
- Figma：Collapse `24386:5265`，375 宽移动端展示。
- 小程序：`origin/develop@cc2384cc5` 的 Collapse Demo、API 与样式。
- 公开 Demo 顺序收敛为基础、向上展开、带操作说明、手风琴、卡片；使用中文标题和内容，并覆盖初始展开与禁用项。
- 保留 Flutter 的声明式多选与手风琴状态入口，不复制小程序受控数组 API。

## 行为契约

- 基础、向上、操作说明各一个面板且默认展开。
- 手风琴和卡片各四项；第一项/末项的初始状态与设计稿一致，末项禁用。
- 通栏及展开内容分隔线左缩进 16，标题最小高度与设计稿一致。

## 验收

- [ ] Demo 结构和交互测试通过。
- [ ] 组件回归和覆盖率门禁通过。
- [ ] Flutter 3.32.0 与 latest analyze/test 通过。
- [ ] Flutter 3.32.0 Linux light/dark Golden 更新后复验通过。
