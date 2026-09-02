# DropdownMenu Figma、Demo 与组件契约对齐

## 背景

DropdownMenu 的锚点、滚动跟随和自动方向能力已由现有实现覆盖，但 Example 页面壳、多选展开态和组件默认视觉仍与 Figma `24386:5279` 存在差异。设计稿同时记录了“选中项 icon 位置不一致”和“展开后滚动导致菜单与面板分离”两个问题。

## 目标

- 补齐官方单选、1/2/3 列多选和禁用 Demo。
- 公开 Demo 只保留小程序页面实际展示的“组件类型”和“组件状态”。
- 使用紧凑页面壳，并按 Figma 展示 15 个三列选项及 348px 展开面板。
- 对齐触发项、单选项和多选项的字体、图标、间距、分隔线与状态色。
- 复核锚定滚动、状态所有权、Theme 与 Controller，不为设计对齐新增公开 API。
- 自定义面板、向上展开、scrollable 和 ThemeData 能力保留在组件 API 与聚焦测试中，不作为公开 Demo 矩阵。

## 非目标

- 不删除 Flutter 已有组件能力或公共 API。
- 不新增与现有 `TDropdownThemeData` 重复的逐实例样式参数。
- 不把 Figma 组件属性机械映射为 Flutter API。

## 范围

### 涉及

- DropdownMenu 组件默认样式、Example 页、组件与 Example 测试、生成代码片段和 Golden。
- DropdownMenu Spec、站点说明、回归登记与测试字体冲突。

### 不涉及

- 其他组件或底层 Overlay。

## 行为契约

- 单选 Demo 按官方顺序展示“全部产品”和“默认排序”，产品选项包含一个禁用项。
- 多选 Demo 在同一个菜单栏中分别传入 `columns: 1/2/3`；三列展开态展示 12 个普通项、3 个禁用项和 348px 面板，不人为设置 280px 上限。
- 状态组的两个禁用 trigger 点击后都不展开。
- 公开页在两个禁用 trigger 后结束，不展示内部“单元测试”或 Flutter 扩展分组。
- 默认触发栏高 48px，图文间距 4px，箭头使用 24px 图标容器；激活文字使用 `fontMarkMedium`，其他文字使用 `fontBodyMedium`。
- 单选项高 56px、水平内边距 16px、文字使用 `fontBodyLarge`、底部分隔线 0.5px，选中态使用 24px TDesign check 与品牌色。
- 多选项高 40px、圆角与颜色取现有语义 Token，水平内边距 16px、横纵间距 12px；内容区为左/上/右/下 `16/12/16/16`。
- 页面滚动时，菜单栏、面板与遮罩作为同一锚定单元移动；锚点离开视口时不残留分离面板。

## 验收标准

- [x] 官方入口可见，单选展开与两个禁用入口有 Example 测试。
- [ ] Figma 默认视觉、三列展开态和滚动锚定均有聚焦测试。
- [ ] DropdownMenu 生产源码 LCOV `LH/LF >= 95%`。
- [ ] Flutter 3.32.0 与 latest 的聚焦测试和严格 analyze 全部通过。
- [x] 未新增或删除公开 API；现有 API 的单一状态源和覆盖优先级已复核。
