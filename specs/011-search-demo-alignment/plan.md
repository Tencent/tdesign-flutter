# 实施方案

## 组件实现

- 保留 `TextField` 作为 IME、选择、格式化和无障碍核心，TSearchBar 重构其外层视觉壳。
- 将组件结构收敛为 40dp Row：输入区域 Expanded，右侧 action 按需插入。
- 以完整 Token TextStyle 为基线后 merge 组件 Theme，避免只改颜色时丢失字号和行高。
- controller 与 FocusNode 在生命周期内分别同步，清除与 action 保持单一职责。

## Theme

- 保留实例级 `variant/textAlignment` 与 Theme 级 `variant/cursorHeight`，不在 Theme 中重复暴露文字对齐。
- 使用 `height/inputBackgroundColor/contentPadding/textStyle/hintStyle/searchIconTheme/
  clearIconTheme/actionTextStyle/actionGap` 描述组件本体。
- 移除页面级背景、外边距和自动填满父容器的配置。

## Demo

- 使用私有 `_SearchDemoSurface` 复现官方示例的页面背景与 16dp/8dp 留白。
- 搜索结果使用 `TCell` 在组件外组合。
- 取消按钮由页面焦点状态控制，回调中由页面决定清空和失焦。
- `maxLength/maxCharacter` 由 Search 提供明确约束；结果列表仍由 Demo 外部组合。

## 验证

- Widget 测试覆盖 controller、focus、action、clear、原生输入参数及 Theme 优先级。
- 几何与样式测试锁定 40dp、图标尺寸、Token 文字和圆角。
- 执行全量 analyze、Search 测试、示例资产检查、Web build 和双 Flutter 版本验证。
- 运行 Demo 并截取手机尺寸页面，与小程序源码规格逐项比对。
