# ActionSheet 官方基线对齐

## 背景

ActionSheet 当前 Demo 以自定义业务场景取代了官方小程序的公开示例矩阵，且列表描述项高度、描述色与宫格分页点颜色存在可见差异。

## 目标

- 以 `tdesign-miniprogram` ActionSheet 当前 Demo 为唯一基线，提供一对一的公开 Demo 矩阵。
- 对齐列表描述项高度、描述文本 token 和宫格分页点 token。
- 保持现有强类型 `TActionSheetItem` 与命令式入口，不为追平 Web 形态扩大 API。

## 非目标

- 不删除现有 `showGroup` 公开能力。
- 不新增字符串联合 item、`suffixIcon` 或 `popupProps` 等非 Flutter-native API。
- 不以 Mobile Vue Demo 代替小程序基线。

## 范围

### 涉及

- ActionSheet 列表与宫格的可见样式。
- ActionSheet 组件 Widget 测试。
- Example 页与自动生成的代码片段。

### 不涉及

- Popup 底层路由与动画协议。
- `showGroup` 的公开签名或行为。

## 行为契约

- 无描述列表项高 56；带描述列表项高 84。
- 面板描述和 item 描述均使用 `textColorPlaceholder`。
- 分页当前点使用 `brandNormalColor`，非当前点使用 `textDisabledColor`。
- Example 公开展示 9 个官方场景：3 个列表类型、3 个宫格类型、1 个状态场景和 2 个对齐场景。
- 公开页在“组件样式”后结束，不展示仅供内部验证的“单元测试”模块。

## 验收标准

- [x] 样式 token 和 84 高度有 Widget 测试保护。
- [x] 9 个 Demo 各自有可见入口和独立代码片段。
- [x] Example 测试验证 9 个入口、常规宫格交互和运行时视觉快照。
- [x] Flutter 3.32.0 与 latest 均通过聚焦测试及严格 analyze。
- [x] ActionSheet 生产源码 LCOV `LH/LF >= 95%`。
- [ ] 在真实运行时与小程序基线完成像素和交互对照。
