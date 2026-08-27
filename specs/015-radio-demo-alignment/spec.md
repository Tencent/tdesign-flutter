# Radio Demo 小程序视觉对齐

## 背景

Radio Demo 已按小程序公开示例整理结构和文案，但真机截图显示默认选中标记、长文案换行和横向布局仍存在差异。现有 `TRadio` 已具备主题色、尺寸和文本行数能力，但缺少内置勾选样式，`TRadioGroup` 也无法把行数配置传给子项。

## 目标

- 以小程序公开 Demo 为可见效果基线，完成 Radio Demo 的最小视觉对齐。
- 由组件提供可复用的内置选中标记样式，Demo 不自绘基础 Radio 图标。
- 所有颜色、尺寸、圆角和间距来自现有 Theme、Material 或 TDesign token。
- 移除与小程序冲突的默认圆点视觉，以实心勾选作为统一默认样式。

## 非目标

- 不复制小程序运行时、平台提示或兼容分支。
- 不机械映射小程序 props/events。
- 不改变 Radio 的受控状态模型。

## 范围

### 涉及

- `TRadio` 内置选中标记样式。
- `TRadioGroup` 对图标样式和文本最大行数的透传。
- Radio Demo、Widget 测试、Golden 和真机截图。
- Demo 调试模块的 release 隔离及已发现的异步回调生命周期问题。

### 不涉及

- Checkbox 或其他选择组件的公开 API。
- 小程序专属的 Skyline/WebView 提示。
- 与 Radio Demo 无关的页面结构和样式。

## 行为契约

- `TRadioIconType.dot` 提供圆环加圆点样式。
- `TRadioIconType.check` 在选中时显示品牌色勾选标记，未选中时不显示标记。
- `TRadioIconType.fill` 未选中时显示边框圆环，选中时显示品牌色实心圆及反色勾选标记。
- 禁用、选中和未选颜色继续遵循 `TRadioThemeData`、Material `RadioTheme` / `ColorScheme`、TDesign token 的既有优先级；反色勾选标记使用 `ColorScheme.onPrimary` 或 `textColorAnti` token。
- 图标几何尺寸由 `TRadioSize` 的既有指示器尺寸按比例计算，不新增固定像素样式常量。
- 块级 Radio 使用 `spacer16` 上下内边距；分割线不带外边距，并从正文起点开始，均对齐小程序默认块级布局。
- 带副标题时，内置指示器与主标题行盒垂直居中，不相对整个多行文本块居中。
- 副标题默认使用 `textColorSecondary`，与小程序 `text-color-secondary` token 保持一致。
- Material `TextTheme` 只提供字体排版继承，不覆盖 Radio 标题和副标题的语义颜色；颜色由 `TRadioThemeData` 和对应 TDesign token 解析。
- `customIconBuilder` 优先于 `iconType`，保持完整自定义能力。
- `TRadio` 和 `TRadioGroup` 的 `iconType` 默认值为 `fill`，直接对齐小程序默认实心勾选视觉，不保留旧默认视觉的兼容分支。
- `TRadioGroup` 将 `iconType`、`titleMaxLines` 和 `subTitleMaxLines` 透传给默认子项；文本行数默认值仍为 `1`、`1`。
- release 构建不创建或展示 Demo 内部测试模块；debug 行为保持可控。

## 验收标准

- [ ] 未传新增参数时，Radio 使用小程序默认实心勾选视觉，受控交互行为保持不变。
- [ ] 三种图标样式覆盖选中、未选和禁用状态测试。
- [ ] Group 参数正确透传，长标题和副标题按 Demo 要求换行。
- [ ] Demo 不包含基础 Radio 图标的自定义绘制或平台兼容分支。
- [ ] Demo 样式值使用 Theme / Material / TDesign token 或组件公开能力。
- [ ] light/dark Golden 更新并通过。
- [ ] Android 真机截图与小程序公开 Demo 分段对照完成。
- [ ] Flutter 3.32.0 与 latest 的 analyze 和相关测试通过。
