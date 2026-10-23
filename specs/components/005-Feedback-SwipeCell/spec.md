# SwipeCell 设计说明

<a id="record-005-theme-review-fixes"></a>
<a id="record-007-official-alignment"></a>

## 背景与目标

以下保留设计形成时的问题与依据；已修复的问题不表示当前代码仍有同一缺陷。

第三方能力透出、手工面板宽度与重复配置造成拖拽和点击关闭行为不一致。

对 `TSwipeCell` 组件实现进行 review 后发现以下问题，本次修复落地：

1. **P1 组件级 Theme 覆盖能力不足（重点）**：`TSwipeCellThemeData` 仅有 `duration` 一个字段，操作项的背景色、图标色、文字样式、图标尺寸与间距均只能靠 P0 实例参数或 P4 Token 兜底，无法通过组件级 Theme 在子树批量覆盖，未完整闭环多层级主题控制方案。
2. **DOM 布局不对称**：`TSwipeCellAction.build` 中图标为裸 `Widget`，文字被 `Flexible` 包裹，二者在主轴上地位不对称。
3. **API 健壮性**：
   - `groupTag` 类型为 `Object?`，`==` 相同的值（如同字符串）易意外串组，缺唯一性说明；
   - `actionClick` 依赖 `children.indexOf(action)` 的实例引用相等，`copyWith` 重建的等价实例会使二次确认静默失效；
   - `closeOnScroll` 与 `initialOpenSide` 组合行为缺文档说明。

在 Issue #82 中，对 Flutter `TSwipeCell` 与 TDesign 小程序（`@1.16.0`）、Mobile Vue（`@1.16.1`）进行了跨端实现对照 Review。结论（均引用源码证据）指出 Flutter 在默认交互参数、点击关闭行为、视觉 Token、面板宽度模型与文档示例上存在以下差异需要对齐：

1. **P0 打开/关闭阈值**：Flutter 默认 `extentRatio / 2`（面板宽度的 50%），官方小程序 `swipe-cell.wxs` 的 `THRESHOLD = 0.3`、Mobile Vue `swipe-cell.mjs` 的 `threshold = 0.3`（面板宽度的 30%）。滑动手感不一致。
2. **P0 动画时长**：Flutter 默认 `200ms`，官方为 `600ms`（`0.6s cubic-bezier(0.18,0.89,0.32,1)`）。展开/收起节奏观感不同。
3. **P0 点击外部/本格关闭**：官方打开后面板点击空白处自动收起（小程序 `onTap(){this.close()}`、Mobile Vue `useClickAway(swipeCellRef, close)`），Flutter 无此行为，需手动关闭。
4. **P1 图标大小**：Flutter 默认 `18px`，官方 `--td-font-size-xl`（20px）。
5. **P1 图标-文字间距**：Flutter 默认 `2px`，官方 `--td-spacer`（8px）。
6. **P2 面板内边距**：官方左右各 `--td-spacer-2`（16px），Flutter 无内置。
7. **P2 文档/示例修正**：站点 README 遗漏 `closeOnScroll`；示例 `_buildSwiperCell` 存在 `print` 调试输出残留；`TSwipeCellAction.flex` dartdoc 中“失踪”为错别字（应“始终”）。

## 范围与非目标

本组件的内容、状态、布局与生命周期按最终方案维护；跨组件 Token/Material 规则引用 Theme 工程 Spec，公开 Demo 与 Golden 范围引用对应工程规范，不把已取代的阶段限制继续作为当前要求。

## 最终方案与行为契约

### 内容和配置职责

- 面板只承载 children，操作项逐项持有内容与外观；TSwipeCellThemeData 只保留 actionPadding，不重复保存 action 的背景、文字、图标、尺寸或间距。builder 与内置视觉参数互斥。
- 默认 action 图标为 20dp、图文间距为 8dp，面板内边距默认左右各 16dp；实际宽度由图标、文案、间距、padding 和自定义内容布局共同决定，不再接收 extent。
- 保留最小 TSwipeCellController.open(side)/close，不暴露 flutter_slidable 的全部能力。

### 手势与生命周期

- 打开阈值固定为实测面板宽度的 30%；释放、初始展开与命令操作使用统一 600ms 曲线 Cubic(0.18, 0.89, 0.32, 1)。
- 展开后点击内容或外部关闭；action 先回调再关闭，关闭动画结束前阻止重复点击和事件穿透。关闭后释放全局监听。
- 面板宽度、方向或面板内容动态变化时校正偏移；移除当前侧面板立即关闭。指针取消恢复拖拽前状态，互斥关闭限定当前 ModalRoute，滚动监听随实际 ScrollPosition 迁移。

## 关键决策与取舍

| 决策 | 理由与取舍 |
| --- | --- |
| 采用的方案 | 面板以实际布局宽度驱动阈值和偏移；保留最小 open/close Controller，移除第三方透传。 |
| 保留的边界与代价 | 逐 action 的外观由实例负责；Theme 只保留 actionPadding，固定基础交互以减少互相无效的组合。 |

### 被取代的方案与原因

曾直接透出第三方动效与 action Theme 字段；最终保留最小控制器、实测面板几何与逐项实例外观，舍弃没有完整基础契约的确认编排和同义样式入口。

- **Breaking change**：无。全部为新增可空字段 / 保持默认行为。既有调用方无需改动。
- **验证**：新增单元测试与主题验收测试；依赖 CI 跑 `flutter analyze` 与双版本构建（`flutter@3.32.0` / `flutter@latest`）。

- `SlidableController` 改为 `TSwipeCellController`；
- 删除纵向滑动、分组、阈值、motion、dismiss、confirm 和手动关闭开关；
- 自定义 action 删除 `extent`，改由 builder 自身布局决定宽度；
- 动画、30% 阈值、互斥与点击关闭成为固定官方行为。

实现需同时通过 Flutter 3.32.0 与 latest，并保持 `flutter analyze` 零告警。

## 兼容性与迁移

- 第三方导出、extent、阈值/动效透传、确认编排与 action 的 id/autoClose 等旧入口已移除；采用真实内容尺寸、最小 Controller 和单次点击关闭语义。
- 默认图标、间距及面板内边距变化具有视觉影响；action 同义 Theme 字段迁移到逐项实例参数，自定义 builder 与内置参数互斥。

## 验收标准

- 验证真实内容面板宽度、30% 阈值、统一曲线和方向/内容变化后的偏移。
- 验证点击关闭、指针取消、重复点击抑制、作用域互斥及监听释放。
- 实例 action 视觉和 actionPadding 生效，自定义 builder 不与内置字段混用，外部 Material 主题不反向配置。
- 公开入口不依赖第三方全量导出，控制器仅管理打开/关闭。

验收标准描述应满足的行为，不表示已执行或通过；执行范围与证据见 [acceptance.md](./acceptance.md)，剩余事项只在 [tasks.md](./tasks.md) 维护。

跨组件配置职责见 [Theme 契约](../../engineering/048-Theme-configuration-contracts/spec.md)，视觉方法见 [Golden 规范](../../engineering/044-Testing-golden-regression/spec.md)。


## 1.0.1 controller-binding

保留重复绑定时现有 FlutterError；先绑定新 Controller 再解绑旧对象。替换失败保留旧绑定，重复无效提交仍拒绝，卸载按实际绑定清理。

Controller 不提供同时控制多个组件的能力，建议独立组件分别使用 Controller。为保持历史兼容，本版本保留本组件既有的重复绑定处理规则。
