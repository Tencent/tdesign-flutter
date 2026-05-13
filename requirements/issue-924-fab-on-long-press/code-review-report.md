# Code Review Report — issue #924

## 审查结论

状态：通过

## 修改范围

- `tdesign-component/lib/src/components/fab/t_fab.dart`：为 `TFab` 新增 `onLongPress` 回调并透传到 `InkWell`。
- `tdesign-component/example/lib/page/t_fab_page.dart`：新增长按示例条目，方便验收。

## 规范检查

### 1. 构造方法与字段顺序

- 通过：构造方法在前，字段在后；新增字段 `onLongPress` 放在构造方法之后。

### 2. 注释风格

- 通过：新增公开 API 使用 `///` 注释。

### 3. all_build 配置

- 不涉及：未新增组件类与 demo_tool 生成入口，仅扩展现有 `TFab` 参数。

### 4. TTheme 使用

- 通过：本次仅新增事件回调，不修改主题/样式逻辑。

### 5. TResourceDelegate 使用

- 不涉及：本次仅新增事件回调；示例中使用 `debugPrint` 输出日志，不引入固定 UI 文案。

## 正确性评审

- 新增 `onLongPress` 为可选参数，默认行为与此前一致（未传入时不产生长按回调）。
- `onClick` 与 `onLongPress` 可同时配置，交互由 `InkWell` 负责分发，符合 Flutter 常规行为。

## 风险与未验证项

- 风险较低：属于向后兼容的 API 扩展。
- 未覆盖自动化 widget test：仓库当前未对 `TFab` 提供现成测试基础；本次通过 example 页面提供可复现验收路径。
