# TPopover 双层控制模式与主题插值

## 背景

`TPopover.showPopover` 通过 `OverlayEntry` 命令式展开，适合一次性简单展示，
但缺少与 Widget 树长期绑定的受控入口。操作菜单等内容无法通过
公开契约主动展开、关闭或查询状态。

`TPopoverThemeData.lerp` 还会把 nullable 数值、颜色和内边距中的 `null`
当作 `0`、透明色或零内边距参与插值。`null` 实际表示继续使用组件或 TDesign
默认值，伪造中间值会在动态主题切换时短暂污染气泡尺寸与视觉。

本 Spec 是 `022-popover-public-api-convergence` 的后续能力补充；既有内容、
定位和回调契约保持不变。

## 目标

- 保留 `showPopover` 的完整签名、默认行为与 `Future<void>` 返回契约。
- 新增 `TPopoverAnchor + TPopoverController` 受控层，职责对齐 Flutter M3
  `MenuAnchor + MenuController` 的分层模式。
- Anchor 单一持有锚点、内容、位置与样式；Controller 只提供
  `open`、`close` 和 `isOpen`。
- 所有关闭路径都同步 Controller 状态并触发 Anchor 关闭回调。
- 修复 nullable Theme 字段在动态主题插值期间的 fallback 污染。

## 非目标

- 不向 Controller 复制内容、位置或样式配置。
- 不新增 `visible` 受控布尔值，不把 Controller 设计为可变配置模型。
- 不改变多次独立 `showPopover` 可以叠加气泡的既有行为。
- 不改变 Popover 的定位、自动翻转、颜色方案或公开 Demo 矩阵。
- 本 PR 不迁移 TabBar；TabBar 可在本能力合并后单独复用。

## 范围

### 涉及

- 新增 `TPopoverAnchor`、`TPopoverAnchorBuilder` 和 `TPopoverController`。
- 受控层与 `showPopover` 复用的 Overlay 生命周期实现。
- `TPopoverThemeData.lerp` 的 nullable 字段语义。
- 操作型 Popover Demo、API 生成产物、组件与 Demo 测试。

### 不涉及

- TabBar、Popup、DropdownMenu 等其他组件。
- Popover ThemeData 字段增删与视觉重设计。
- 既有 Golden 基线的主动更新。

## 行为契约

- `showPopover` 不新增 Controller 参数，所有已有调用不需迁移。
- `TPopoverAnchor` 声明锚点 builder、content 及与 `showPopover` 同语义的
  位置、尺寸、主题覆盖和关闭策略。
- `controller.open()` 展开其绑定 Anchor；重复展开无副作用。
- `controller.close()` 关闭其绑定 Anchor；未绑定或重复关闭无副作用。
- `controller.isOpen` 反映当前 Anchor 的 Overlay 展开状态。
- 外部点击、滚动、返回键、Anchor 卸载及 Controller 主动关闭都使
  `isOpen` 恢复为 `false`。
- `TPopoverController.maybeOf(context)` 可从 Anchor 触发区域或气泡内容
  子树取得当前 Controller。
- 替换 Anchor 的 Controller 时保留当前展开状态，并把控制权交给新
  Controller。
- Controller 不保存内容、位置或样式，不作为展开配置的第二状态源。
- `TPopoverThemeData.lerp` 两侧均显式时正常连续插值；任一侧为 `null` 时
  在中点离散切换，保留 `null` 所代表的运行时 fallback，不伪造中间值。

## 验收标准

- [x] Controller 展开、关闭、重复操作、自然关闭和替换路径均有测试。
- [x] `showPopover` 原调用无需迁移，返回类型保持 `Future<void>`。
- [x] 交互内容 Demo 使用 Anchor 受控模式，在选择后更新状态并关闭气泡。
- [x] nullable 与双显式 Theme 插值有字段级测试。
- [x] API 文档、示例片段和 Spec 与最终实现一致。
- [x] Flutter 3.32.0 与 latest 的 analyze、功能测试和覆盖率门禁通过。
- [x] Flutter 3.32.0 Linux Golden 无非预期变化。
