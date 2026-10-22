# Toast 设计说明

<a id="record-004-contract-alignment"></a>
<a id="record-006-overlay-config-and-placement"></a>
<a id="record-054-overlay-pointer"></a>

## 背景与目标

以下保留设计形成时的问题与依据；已修复的问题不表示当前代码仍有同一缺陷。

旧时长哨兵、位置算法和遮罩参数使加载提示与背景交互难以一致解释。

TDesign Flutter 的 TToast 组件在与 TDesign Mobile 对齐时存在两处默认行为偏差，且遗留一处魔法数字哨兵值的风险：

1. **默认背景色过深**：默认背景使用 `fontGyColor1`（`#E5000000`，rgba(0,0,0,0.9)，白色页面约 #1A1A1A），比 TDesign Mobile 的 `--td-toast-bg-color: @font-gray-2`（rgba(0,0,0,0.6)，白色页面约 #666666）更黑、更不透明。
2. **默认消失时长偏长**：普通 toast 默认 `duration = 3000ms`，而 TDesign Mobile 的默认时长为 2000ms。
3. **魔法数字哨兵值**：原实现用 `Duration(seconds: 99999999)` 作为"永不自动消失"的哨兵标记。若用户恰好传入相近的超长 duration，会被误判为无限、toast 永不消失。

- 各 show 方法（showText / showIconText / showSuccess / showWarning / showFail / showLoading / showLoadingWithoutText）构建气泡时，背景色取值 `toastTheme.backgroundColor ?? theme.fontGyColor2`。
- 未通过 `TToastThemeData(backgroundColor:)` 自定义时，默认背景为 `fontGyColor2`（rgba(0,0,0,0.6)）。
- `toastTheme.backgroundColor` 优先级高于默认 token，自定义覆盖行为保持不变。

在 Issue #50 的调研（见 `t_toast.dart` 现状与小程序 `tdesign.tencent.com/miniprogram/components/toast` 对比）中，当前 Flutter `TToast` 与小程序 Toast 存在以下核心差距：

1. **无可见遮罩（showOverlay）**：现有实现只有"透明 `preventTap` 拦点击层"（`Colors.transparent`），没有小程序 `showOverlay` 提供的**可见半透明蒙层**能力，导致 cover demo 无法实现。
2. **遮罩属性无收敛口**：现有 `preventTap` 是散落在 6 个 `showXxx` 上的 `bool?`，没有统一的"蒙层行为"配置；小程序侧 `overlayProps`（遮罩颜色、透明度、是否拦点击、zIndex 等）无从透传。
3. **无 placement（top/middle/bottom）**：小程序 Toast 支持 `placement: top / middle / bottom` 三种位置，Flutter 侧固定 `Center` 居中，无法顶部/底部展示。

## 范围与非目标

本组件的内容、状态、布局与生命周期按最终方案维护；跨组件 Token/Material 规则引用 Theme 工程 Spec，公开 Demo 与 Golden 范围引用对应工程规范，不把已取代的阶段限制继续作为当前要求。

## 最终方案与行为契约

### 展示与生命周期

- 所有 show 方法默认 duration 为 2000ms，包括加载提示。正时长自动关闭，零或负时长持续展示到主动 dismiss；不再公开 infiniteDuration。
- 匿名 Toast 共用内部标识，后一次替换前一次；同 ID 替换，不同 ID 可并存。关闭和替换清理计时器及 Overlay，避免叠加变暗和重复移除。
- TToastThemeData.backgroundColor 显式值优先，否则回退 fontGyColor2；默认外观随 TDesign 主题变化。

### 遮罩与位置

- TOverlayConfig.showOverlay 只控制可见遮罩；preventScrollThrough 只控制背景点击、触控拖动和鼠标滚轮，二者四种组合均有效。自定义 Toast 内容自身仍可交互，关闭后恢复背景行为。
- color 显式时使用其颜色；否则由 opacity 派生黑色遮罩。Toast 的 opacity 与 Popup 的蒙层配置不是同一个公开契约。
- Toast 中心按真实 Overlay 高度定位：top 25%、middle 45%、bottom 75%，水平居中；以实际渲染坐标验收，不以 Align 枚举或布局参数代替。

## 关键决策与取舍

| 决策 | 理由与取舍 |
| --- | --- |
| 采用的方案 | 全部入口使用同一时长规则，零或负时长表示持续展示；取消特殊无限常量，减少两套生命周期语义。 |
| 保留的边界与代价 | 遮罩可见性与背景交互独立；同 ID 替换避免叠加变暗，不同 ID 仍可并存。 |

### 被取代的方案与原因

曾使用公开 infiniteDuration 哨兵并为加载默认无限展示；最终采用所有入口同一时长规则，以零或负时长显式表达持续显示，减少特殊常量与入口差异。

- `Colors.black.withValues(alpha:)` 需 Flutter 3.27+；项目基线 3.32.0 满足，latest 满足。
- placement 采用垂直百分比偏移（25% / 50% / 75%），与小程序 / mobile-vue 一致。旧实现为固定 `Center` 居中（并未叠加 SafeArea），新实现改为百分比定位，同样天然避让安全区（刘海屏 / 挖孔屏 / 底部手势条），无需叠加 SafeArea。
- **breaking change**：移除 `bool? preventTap` 参数，更新日志使用 `breaking` commit type（`- breaking(toast): 移除 preventTap 参数，改用 overlay`）提醒用户迁移。

独立验证目录，主工作区已有修改未触碰。Linux 一次性容器通过 --no-hardlinks 修复缓存 Git 克隆故障；切换 Flutter SDK 后清理构建缓存，避免 shader 版本污染。远端最终提交 CI 等待推送后核对，不沿用旧 head 的通过结论。

## 兼容性与迁移

- 旧 infiniteDuration 迁移为 duration: Duration.zero；加载默认从长期展示改为 2000ms，需要长期加载时显式传零时长。
- preventTap 迁移为 preventScrollThrough；默认 middle 从 50% 调整为 45%。这些属于可感知行为变化，不能以整理文档重新声明为兼容。

## 自定义文案默认值

showText / showLoading 的 customWidget 文案槽整个子树接入与各自内置文案相同的默认字体和反色文字，使用相同主题/实例配置解析。Row、Padding、Builder 不切断传递；显式字段及内容内部更近的 TTextThemeData 优先，全局隔离保持。自定义内容仍自行布局，不强加内置文案的一行/三行限制；不更改其他 Toast 类型或图标。

属于默认行为变更：未配置或仅部分配置的自定义文字可能改变字体、颜色、字距、换行和尺寸。自带背景仍需调用方保证对比度；不新增配置。

## 验收标准

- 全部 show 方法验证 2000ms 默认值、正/零/负时长及显式关闭；加载提示同样遵循该规则。
- 分别验证 showOverlay 与 preventScrollThrough 四种组合、真实背景点击/拖动/滚轮和内容自身交互。
- 按真实 Overlay 坐标验证 top=25%、middle=45%、bottom=75%。
- 验证匿名与显式 ID 的替换、并存和清理，确认无重复移除或半透明叠加。

验收标准描述应满足的行为，不表示已执行或通过；执行范围与证据见 [acceptance.md](./acceptance.md)，剩余事项只在 [tasks.md](./tasks.md) 维护。

跨组件配置职责见 [Theme 契约](../../engineering/048-Theme-configuration-contracts/spec.md)，视觉方法见 [Golden 规范](../../engineering/044-Testing-golden-regression/spec.md)。

发布归类：本轮与 Button/NavBar 的默认文字槽调整采用同一 patch 策略。未配置、空样式或部分显式样式仍可能改变字体、颜色、换行、尺寸和省略位置；原生 Text 的字体也可能受新默认值影响，段落参数沿用既有语义。保留旧外观需在实例或内容内部主题中明确所需字段；不以参数签名不变或测试通过承诺零兼容风险。
