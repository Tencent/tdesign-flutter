# DropdownMenu 官方 Demo 对齐

## 背景

DropdownMenu 的锚点、滚动跟随和自动方向能力已完整，但 Example 未公开展示官方的 1/2/3 列多选、纯禁用菜单、向上展开和自定义图标场景。CodeBuddy 建议新增图标 API，但现有 `TDropdownMenuItem.custom` 已能表达该 Demo。

## 目标

- 补齐官方单选、1/2/3 列多选和禁用 Demo。
- 复用现有 custom trigger 表达开合图标，不新增一次性 API。
- 保留自定义面板、向上展开、scrollable 和 ThemeData 作为明确标记的 Flutter 额外能力。

## 非目标

- 未经维护者确认，不改勾选位置、空选确认行为或面板默认最大高度。
- 不删除 Flutter 已有超集能力的公开 Demo。

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
- direction Demo 显式使用 `placement: above`，并通过 custom trigger 根据 `isOpen` 切换图标。

## 验收标准

- [x] 新 Demo 入口可见，单选展开、两个禁用入口和向上展开交互有 Example 测试。
- [x] DropdownMenu 生产源码 LCOV `LH/LF >= 95%`。
- [ ] Flutter 3.32.0 与 latest 的聚焦测试和严格 analyze 全部通过（latest 存在一个非本次改动的 0.93px 既有几何断言差异）。
- [ ] 待确认的公开契约已获得维护者决策或明确留作后续。
