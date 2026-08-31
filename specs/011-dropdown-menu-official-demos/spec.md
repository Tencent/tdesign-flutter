# DropdownMenu 官方 Demo 对齐

## 背景

DropdownMenu 的锚点、滚动跟随和自动方向能力已完整，但 Example 未公开展示官方的 1/2/3 列多选和纯禁用菜单，并混入了小程序公开页不存在的 Flutter 扩展示例。

## 目标

- 补齐官方单选、1/2/3 列多选和禁用 Demo。
- 公开 Demo 只保留小程序页面实际展示的“组件类型”和“组件状态”。
- 自定义面板、向上展开、scrollable 和 ThemeData 能力保留在组件 API 与聚焦测试中，不作为公开 Demo 矩阵。

## 非目标

- 未经维护者确认，不改勾选位置、空选确认行为或面板默认最大高度。
- 不删除 Flutter 已有组件能力或公共 API。

## 范围

### 涉及

- DropdownMenu Example 页、Example 测试和生成代码片段。
- DropdownMenu 生产源码覆盖率基线复核。

### 不涉及

- DropdownMenu 公开 API 和默认行为。
- 其他组件或底层 Overlay。

## 行为契约

- 单选 Demo 按官方顺序展示“全部产品”和“默认排序”，产品选项包含一个禁用项。
- 多选 Demo 在同一个菜单栏中分别传入 `columns: 1/2/3`，并在 Demo 层使用 280px 最大高度。
- 状态组的两个禁用 trigger 点击后都不展开。
- 公开页在两个禁用 trigger 后结束，不展示内部“单元测试”或 Flutter 扩展分组。

## 验收标准

- [x] 官方入口可见，单选展开与两个禁用入口有 Example 测试。
- [x] DropdownMenu 生产源码 LCOV `LH/LF >= 95%`。
- [ ] Flutter 3.32.0 与 latest 的聚焦测试和严格 analyze 全部通过（latest 存在一个非本次改动的 0.93px 既有几何断言差异）。
- [ ] 待确认的公开契约已获得维护者决策或明确留作后续。
