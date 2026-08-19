# TSwipeCell 官方对齐修复（跨端 Review 结论落地）

## 背景

在 Issue #82 中，对 Flutter `TSwipeCell` 与 TDesign 小程序（`@1.16.0`）、Mobile Vue（`@1.16.1`）进行了跨端实现对照 Review。结论（均引用源码证据）指出 Flutter 在默认交互参数、点击关闭行为、视觉 Token、面板宽度模型与文档示例上存在以下差异需要对齐：

1. **P0 打开/关闭阈值**：Flutter 默认 `extentRatio / 2`（面板宽度的 50%），官方小程序 `swipe-cell.wxs` 的 `THRESHOLD = 0.3`、Mobile Vue `swipe-cell.mjs` 的 `threshold = 0.3`（面板宽度的 30%）。滑动手感不一致。
2. **P0 动画时长**：Flutter 默认 `200ms`，官方为 `600ms`（`0.6s cubic-bezier(0.18,0.89,0.32,1)`）。展开/收起节奏观感不同。
3. **P0 点击外部/本格关闭**：官方打开后面板点击空白处自动收起（小程序 `onTap(){this.close()}`、Mobile Vue `useClickAway(swipeCellRef, close)`），Flutter 无此行为，需手动关闭。
4. **P1 图标大小**：Flutter 默认 `18px`，官方 `--td-font-size-xl`（20px）。
5. **P1 图标-文字间距**：Flutter 默认 `2px`，官方 `--td-spacer`（8px）。
6. **P2 面板内边距**：官方左右各 `--td-spacer-2`（16px），Flutter 无内置。
7. **P2 文档/示例修正**：站点 README 遗漏 `closeOnScroll`；示例 `_buildSwiperCell` 存在 `print` 调试输出残留；`TSwipeCellAction.flex` dartdoc 中“失踪”为错别字（应“始终”）。

## 目标

- 将 Flutter `TSwipeCell` 的默认交互参数（阈值、动画时长）与官方对齐。
- 补齐“点击外部 / 本格关闭”能力（做成可开关项，默认对齐官方）。
- 将操作项视觉默认值（图标大小、间距、面板内边距）与官方对齐。
- 像小程序一样以操作项内容尺寸决定面板宽度，标准 action 零配置。
- 修正站点文档、示例调试输出与 dartdoc 错别字。

## 非目标

- 不引入新的 TDesign 主题 Token（继续复用现有 Token）。
- 本次不引入受控 `openSide`；保留 `initialOpenSide`，受控状态另行设计。

## 范围

### 涉及

- `tdesign-component/lib/src/components/swipe_cell/t_swipe_cell.dart`（内建像素拖拽、官方动画、自有 controller、关闭语义）
- `tdesign-component/lib/src/components/swipe_cell/t_swipe_cell_panel.dart`（只保留 action 容器职责）
- `tdesign-component/lib/src/components/swipe_cell/t_swipe_cell_theme_data.dart`（只保留视觉/布局默认值）
- `tdesign-component/lib/src/components/swipe_cell/t_swipe_cell_action.dart`（真实内容宽度、标准 action 与 builder）
- `tdesign-component/lib/src/components/swipe_cell/t_swipe_cell_inherited.dart`（仅传递操作项关闭回调）
- `tdesign-component/example/lib/page/t_swipe_cell_page.dart`（清理 `print`）
- `tdesign-component/example/assets/code/SwipeCell._buildSwiperCell.txt`（同步清理 `print`）
- `tdesign-site/docs/components/swipe-cell/README.md`（补 `closeOnScroll`）
- `tdesign-component/test/components/swipe_cell/t_swipe_cell_test.dart`（补测试）

### 不涉及

- 其它组件与模块。

## 行为契约

1. **打开阈值**：组件内部固定为实测操作面板宽度的 30%，不再公开阈值配置。
2. **动画**：所有拖拽释放、点击关闭、初始展开和 controller 操作都固定使用 `600ms + Cubic(0.18, 0.89, 0.32, 1)`，不再提供无法完整生效的 `ThemeData.duration`。
3. **点击关闭**：固定对齐官方：
   - 面板展开后，点击本格内容（cell child）或点击单元格外部区域自动关闭面板；
   - 点击操作项后先触发 `onPressed`，再自动关闭。
   - 面板关闭后移除全局监听。
4. **视觉默认值**（`TSwipeCellAction`）：
   - 图标大小默认值 `18` → `20`；
   - 图标与文字间距默认值 `2` → `8`；
   - 新增面板内边距默认值 `EdgeInsets.symmetric(horizontal: 16)`（左右各 16px）。
5. **文档/示例**：站点 README 与示例只展示收敛后的公开 API；移除空 Theme 包装、调试输出和非核心兼容场景，并同步生成物。
6. **面板真实尺寸**：操作面板使用 shrink-wrap `Row` 布局，在拖拽开始时直接读取 RenderBox 实际宽度。标准 action 使用 `icon + spacing + label + padding` 的真实内容宽度；自定义 builder 同样由布局结果决定，删除 `extent`。
7. **第三方隔离**：移除 `flutter_slidable` 依赖和全量 re-export，新增只暴露 `open(side)` / `close()` 的 `TSwipeCellController`。
8. **精简 API**：`TSwipeCellPanel` 只保留 `children`；删除 threshold、motion、drag dismiss、confirm 编排。`TSwipeCellAction` 删除 `autoClose`、`direction`、`confirmIndex`、`id`，点击 action 固定触发回调并关闭。
9. **兼容性**：本次为公开 API breaking change，优先保证与小程序的基础交互和内容尺寸模型一致，不保留第三方或历史能力兼容分支。
10. **动态一致性**：已展开面板的真实宽度或 `TextDirection` 变化时同步校正偏移；当前侧面板被移除时立即关闭。
11. **交互稳定性**：拖拽收到指针取消时恢复拖拽前状态；关闭动画结束前屏蔽 action 重复点击和 child 事件穿透。
12. **作用域与生命周期**：互斥关闭限定在当前 `ModalRoute`；滚动监听绑定到确切 `ScrollPosition` 并随其更换。
13. **主题继承**：Action 视觉解析遵循实例参数 > SwipeCell Theme > Flutter 子树/Material Theme > Token。

## 验收标准

- [x] 内部打开阈值固定为面板真实宽度的 30%，不公开覆盖入口。
- [x] 所有开合路径固定使用 600ms 官方 cubic 动画。
- [x] 展开后点击本格、外部或操作项均自动关闭，关闭后监听移除。
- [x] 图标大小默认 20、间距默认 8、面板左右内边距默认 16。
- [x] 普通 label、图标 + label、仅图标的操作项均自动展开到各自完整内容宽度，文字不被裁掉。
- [x] 自动宽度来自真实 RenderBox，在嵌套/窄宽容器中不依赖 `MediaQuery` 或文字预估。
- [x] `extentRatio` / `flex` / `extent` 已移除；自定义 `builder` 自行决定宽度。
- [x] `flutter_slidable` 依赖、re-export 和第三方公开类型已移除。
- [x] Panel / Action 非核心历史 API 已删除，不保留兼容分支。
- [x] 展开期间的宽度变化、面板移除和 LTR/RTL 切换不会留下错误偏移。
- [x] PointerCancel 与关闭动画期间的重复点击/事件穿透有回归测试。
- [x] ScrollPosition 更换后滚动关闭仍有效；不同路由不互相关闭。
- [x] DefaultTextStyle、TextTheme 与 IconTheme 可控制未显式覆盖的 Action。
- [x] 站点 README、API 文档与示例代码生成物同步。
- [x] 新增测试通过；`flutter analyze` 0 error / 0 warning。
- [ ] 同时兼容 `flutter@3.32.0` 与 `flutter@latest`。
