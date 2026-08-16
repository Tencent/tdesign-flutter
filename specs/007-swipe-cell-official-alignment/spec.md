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
- 修正站点文档、示例调试输出与 dartdoc 错别字。

## 非目标

- 不改变 `TSwipeCell`、`TSwipeCellPanel`、`TSwipeCellAction` 的公开 API 签名（不删参数、不改参数类型）。
- 不改动 `flutter_slidable` 的 API 使用方式与互斥分组机制。
- 不引入新的 TDesign 主题 Token（继续复用现有 Token）。
- “面板宽度模型”内容自适应不在本次范围（官方内容撑开 vs Flutter `extentRatio` 固定比例属框架形态差异，工程量大且会引入 breaking，单独评估）。

## 范围

### 涉及

- `tdesign-component/lib/src/components/swipe_cell/t_swipe_cell_panel.dart`（阈值默认值）
- `tdesign-component/lib/src/components/swipe_cell/t_swipe_cell.dart`（动画时长默认值、点击关闭能力）
- `tdesign-component/lib/src/components/swipe_cell/t_swipe_cell_theme_data.dart`（`duration` 默认说明、新增 `actionPadding`）
- `tdesign-component/lib/src/components/swipe_cell/t_swipe_cell_action.dart`（图标大小/间距/内边距默认值、`flex` 注释）
- `tdesign-component/example/lib/page/t_swipe_cell_page.dart`（清理 `print`）
- `tdesign-component/example/assets/code/SwipeCell._buildSwiperCell.txt`（同步清理 `print`）
- `tdesign-site/docs/components/swipe-cell/README.md`（补 `closeOnScroll`）
- `tdesign-component/test/components/swipe_cell/t_swipe_cell_test.dart`（补测试）

### 不涉及

- `flutter_slidable` 内部实现。
- 其它组件与模块。

## 行为契约

1. **打开阈值**：`TSwipeCellPanel.build` 中 `openThreshold` 默认值由 `extentRatio / 2` 改为 `extentRatio * 0.3`（面板宽度的 30%）；`closeThreshold` 同步改为 `extentRatio * 0.3`。显式传入时以传入值为准。
2. **动画时长**：`TSwipeCell.getDuration` 的兜底默认值由 `200ms` 改为 `600ms`。`TSwipeCellThemeData.duration` 仍为可空，`null` 时使用新的内置默认值（600ms）。
3. **点击关闭**：`TSwipeCell` 新增可空参数 `closeOnTapOutside`（默认 `true`，对齐官方）。为 `true` 时：
   - 面板展开后，点击本格内容（cell child）或点击单元格外部区域自动关闭面板；
   - 点击操作项按钮时不触发全局关闭（由操作项自身的 `onPressed` / `autoClose` 处理）。
   - 面板关闭后移除全局监听。
4. **视觉默认值**（`TSwipeCellAction`）：
   - 图标大小默认值 `18` → `20`；
   - 图标与文字间距默认值 `2` → `8`；
   - 新增面板内边距默认值 `EdgeInsets.symmetric(horizontal: 16)`（左右各 16px）。
5. **文档/示例**：
   - 站点 README 的 `TSwipeCell` 参数表补充 `closeOnScroll`（默认 `true`）与 `closeOnTapOutside`；
   - 示例 `_buildSwiperCell` 移除 `print('打开方向：$side')` / `print('打开转态$open')` 及 `print('点击action')` / `print(TSwipeCell.of(context))` 调试输出，同步更新生成代码 txt；
   - 修正 `TSwipeCellAction.flex` dartdoc 错别字“失踪”→“始终”。
6. **兼容性**：新增参数均为可空/带默认值，不改变既有调用方。阈值、动画时长、视觉默认值改变会影响既有页面手感与视觉（默认行为变更，属潜在 breaking），须在 Changelog 加 `⚠️` 标记。

## 验收标准

- [ ] `openThreshold` / `closeThreshold` 默认值均为面板宽度的 30%（`extentRatio * 0.3`），显式传入优先。
- [ ] `getDuration` 兜底默认 600ms；通过 Theme 的 `duration` 可覆盖。
- [ ] `closeOnTapOutside` 默认 `true`：展开后面板点击本格或外部自动关闭；操作项按钮点击不触发全局关闭；关闭后监听移除。
- [ ] 图标大小默认 20、间距默认 8、面板左右内边距默认 16。
- [ ] 站点 README 补充 `closeOnScroll` / `closeOnTapOutside`；示例移除 `print` 且生成代码 txt 同步；`flex` 注释修正。
- [ ] 新增测试通过；`flutter analyze` 0 error / 0 warning。
- [ ] 同时兼容 `flutter@3.32.0` 与 `flutter@latest`。
