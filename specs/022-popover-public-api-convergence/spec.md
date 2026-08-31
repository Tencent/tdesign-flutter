# TPopover 公开 API 收敛

## 背景

`TPopover.showPopover` 同时提供 `String? content` 与 `Widget? contentWidget`，两者承接同一个内容槽，但允许同时为空或同时传入，并由实现隐式规定 `contentWidget` 优先。`placement` 也以 nullable 参数暴露，却在内部固定回退到 `top`。此外，底层定位渲染类 `TPopoverWidget` 从包入口公开导出，调用方可以绕过 Overlay 生命周期入口直接依赖实现细节。

本 Spec 是 Popover 公共契约的后续收敛，覆盖 `003-popover-contract-hardening` 中“保留双内容参数”和“兼容直接构造 `TPopoverWidget`”的旧范围约束，以及 `015-color-scheme-instance-ownership` 中把 `TPopoverWidget` 视为公开配色入口的旧描述；既有 Spec 的历史验收记录不回写。

## 目标

- Popover 只保留一个必填 Widget 内容入口。
- `placement` 是带 `top` 默认值的非空可选命名参数。
- 包入口不再导出底层 `TPopoverWidget`。
- 任意 Widget 内容在未指定固定宽高时也能按实际布局尺寸完成定位。
- 保持 Overlay 生命周期、十二种方位、自动翻转、边界约束、箭头补偿和主题覆盖能力。

## 非目标

- 不改变 `TPopoverColorScheme` 的枚举和值语义。
- 不新增 Controller、builder 或文本专用快捷 API。
- 不调整公开 Demo 的实例矩阵和视觉目标。
- 不删除 `width`、`height` 等逐实例尺寸覆盖能力。

## 范围

### 涉及

- `TPopover.showPopover` 的内容、placement 与事件回调契约。
- Popover 底层布局和包入口导出。
- Popover 示例、组件测试、Demo 测试、生成文档与 Spec。

### 不涉及

- Popup、DropdownMenu 等其他浮层组件。
- Popover ThemeData 的字段增删。
- 既有 Golden 的视觉重设计。

## 行为契约

- `showPopover` 只接受 `required Widget content`；调用方使用 `Text`、`TText` 或任意组合 Widget 表达内容。
- 未提供 content 的调用在编译期失败，不再生成空气泡。
- `placement` 声明为 `TPopoverPlacement placement = TPopoverPlacement.top`；省略时使用 top，不接受无独立语义的 null。
- `onTap` 与 `onLongTap` 使用 `VoidCallback`，只通知手势，不回传已由调用方持有的内容。
- 任意 Widget 内容优先按自身布局尺寸定位；`width`、`height` 显式传入时约束最终内容外框。
- 默认文本样式通过 Popover 内容子树提供，调用方传入未指定样式的 `Text` 时保持既有文本视觉。
- `TPopoverWidget` 仅作为 `src` 下的包内实现，且不再从 `package:tdesign_flutter/tdesign_flutter.dart` 导出。
- 公开测试不得依赖私有实现类型，改用稳定语义或测试 Key 观察气泡内容和位置。
- 以上参数删除、类型收紧和底层类隐藏均属于 breaking change。

## 验收标准

- [ ] 包入口无法导入或直接构造 `TPopoverWidget`。
- [ ] 全仓 `showPopover` 调用只传一个 Widget content。
- [ ] 省略 placement 时按 top 定位，显式十二种 placement 行为保持不变。
- [ ] 文本、自定义组合 Widget、显式尺寸和主题尺寸均有测试覆盖。
- [ ] onTap、onLongTap 各触发一次且不依赖内容回传。
- [ ] 组件测试、Demo 功能测试、Golden、覆盖率与 analyze 门禁通过。
