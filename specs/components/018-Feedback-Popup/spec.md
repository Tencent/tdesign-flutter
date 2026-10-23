# Popup 设计说明

<a id="record-018-overlay-config"></a>
<a id="record-019-radius-duration-alignment"></a>
<a id="record-020-demo-alignment"></a>
<a id="record-021-slot-convergence"></a>

## 背景与目标

以下保留设计形成时的问题与依据；已修复的问题不表示当前代码仍有同一缺陷。

蒙层散参、默认头部和关闭区让布局能力与业务行为耦合。

在 Popup 跨端 Review（Issue #72）与 Toast 收敛 `TOverlayConfig`（Spec 006）之后，Popup 的蒙层配置仍以**散参平铺**形式存在于 `TPopupOptions` 上：`showOverlay`、`closeOnOverlayClick`、`overlayColor`、`overlayOpacity`、`modal`、`onOverlayClick` 六个字段直接散落在构造器与各命名工厂签名中。

问题：
1. **冗余**：六个蒙层字段在每个命名工厂（bottom/center/top/left/right）里重复出现，签名膨胀。
2. **与 Toast 命名割裂**：Toast 已用 `TOverlayConfig` 具名类收敛蒙层行为，Popup 仍平铺，仓库内两套风格不一致。
3. **无法扩展**：未来要增加 `zIndex` / `blur` / 背景滚动拦截等蒙层能力，需要逐个命名工厂加参数，无法在配置类中扩展。
4. **`modal` 与 `showOverlay` 强耦合**：现有校验 `showOverlay=true requires modal=true`，不允许"显示蒙层但不拦截交互"，与 Toast 的 `showOverlay`/`preventTap` 解耦设计不一致。

在 Popup 跨端对照 Review（Issue #72）中发现两处与官方（小程序、Mobile Vue）不一致的 UI 表现：

1. **left/right 圆角差异**：官方 left/right 为无圆角全高矩形；Flutter 当前对 left 施加右缘圆角、right 施加左缘圆角。
2. **动画时长来源不一致**：小程序 `duration` 属性默认值为 240ms，而 Popup 样式和蒙层存在 300ms 回退值。组件运行时始终把公开属性传给 Popup 样式和蒙层，因此公开属性的 240ms 默认值是有效契约，300ms 只在参数缺失时兜底。

Popup Flutter Demo 虽覆盖了小程序公开页面的 7 个场景，但分组粒度、实例顺序、按钮文案和部分弹层结构不一致，并额外公开了嵌套 Popup。组件能力测试通过不能证明公开 Demo 已对齐。

Popup 是承载任意内容的基础浮层。小程序基础 Popup 默认只渲染内容，不自动生成标题、取消、确定或关闭按钮。当前未发布实现同时暴露整行头部 builder 与标题、取消、确认子插槽，并通过 sentinel 区分省略和显式 null，存在多个内容来源和覆盖关系。

## 范围与非目标

本组件的内容、状态、布局与生命周期按最终方案维护；跨组件 Token/Material 规则引用 Theme 工程 Spec，公开 Demo 与 Golden 范围引用对应工程规范，不把已取代的阶段限制继续作为当前要求。

## 最终方案与行为契约

### 面板与蒙层

- child、placement、width/height/inset、生命周期和单次 animationDuration 归 TPopupOptions。TPopupThemeData 承载面板背景、圆角、默认尺寸及 barrierColor；不保存同义动画时长或 barrierOpacity。
- TPopupOverlayConfig 只包括 showOverlay、color、preventTap、closeOnClick、onClick。color 自带 alpha，不再叠乘独立 opacity。默认显示遮罩并拦截背景；未指定色时回退组件 Theme，再到 black54。
- 可见性与拦截独立。只有可见且拦截的蒙层响应 onClick 和 closeOnClick；穿透时由背景接收事件，不把不可见层当作可点击遮罩。
- useSafeArea 默认 false，显式 true 按方向避让。top/bottom/center 默认大圆角；left/right 未设置圆角时为全高矩形，显式设置时只作用于内容侧边缘。
- 单次 animationDuration 优先，未设置为 240ms；不从已删除的 Theme transitionDuration 取值。减少动画等系统环境继续响应。

### 插槽与生命周期

- bottom 默认无头部，仅 headerBuilder 扩展整块头部；center 默认无外置关闭按钮，仅 closeBuilder 扩展关闭区。top/left/right 通过 child 组合内容，不增加方向专属插槽。
- TPopupHeader 只负责 cancelButton/title/confirmButton 布局，三者均可为空；确认和取消业务回调由按钮持有，不编码进通用关闭类型。
- builder 得到的 close 是普通 VoidCallback；headerBuilder 关闭上报 custom，closeBuilder 上报 close。onVisibleChange 负责可见性通知，onOpened/onClosed 负责动画完成，不再保留 onOpen/onClose 同义通知。
- 保留嵌套路由、明确关闭原因及幂等清理；不能为修复公开示例而删除底层组合能力。
- 公开基础示例顶部/底部高 240px、左/右宽 280px、居中 240×240；标题和关闭按钮只在对应示例显式组合，不成为通用默认行为。

## 关键决策与取舍

| 决策 | 理由与取舍 |
| --- | --- |
| 采用的方案 | 蒙层行为用配置对象收敛；透明度由最终 Color 表达，不再与第二个 opacity 相乘。 |
| 保留的边界与代价 | bottom 只提供 headerBuilder，center 只提供 closeBuilder；按钮业务回调由调用方持有。 |

### 被取代的方案与原因

曾叠乘颜色 alpha 与独立 opacity，并提供默认标题/确认/关闭 sentinel；最终只使用最终颜色和显式 Widget 插槽，减少透明度与业务关闭原因的双重配置。

- `Colors.black54` 作为默认蒙层颜色保持不变（通过 `color == null` 时的 fallback）。
- `overlay` 为 null 时行为与现状一致。
- `opacity` 与 `color` 的组合逻辑与现状一致：`color` 决定基础色，`opacity` 作为 alpha 系数。

- **breaking change**：left/right 由有内缘圆角变为无圆角，可能影响既有页面的视觉表现，需在 PR 更新日志明确标记；动画时长恢复原有 240ms，不构成额外默认行为变化。
- 迁移策略：需要 left/right 圆角的用户可通过 `TPopupThemeData.panelRadius` 或 `TPopupOptions.radius` 显式设置，保持兼容。

- Golden 只允许由 Flutter 3.32.0 Linux 生成；其他平台仅运行非视觉断言。
- 页面结构对齐不等于所有平台像素完全一致，字体与系统渲染差异仍需真机抽查。
- 默认关闭安全区属于 breaking change；依赖旧默认值的调用方须显式传入 `useSafeArea: true`。

## 兼容性与迁移

- 蒙层散参统一迁移为 overlay 配置；独立 opacity/barrierOpacity、Theme 动画时长等同义入口移除。
- title/cancel/confirm 专用 sentinel、onOpen/onClose 迁移为内容组合、headerBuilder/closeBuilder 和 onVisibleChange；onOpened/onClosed 保留动画完成语义。

## 验收标准

- 验证 showOverlay/preventTap 四种组合、颜色自身 alpha、点击回调与关闭条件，不再读取 opacity/barrierOpacity。
- 验证五方向尺寸/圆角、安全区、默认 240ms 与显式时长，以及嵌套路由。
- 验证 headerBuilder、closeBuilder、TPopupHeader 及关闭原因，业务确认回调只由调用方触发。
- 验证 onVisibleChange、onOpened/onClosed 的时序和幂等清理，公开 Demo 不依赖旧 sentinel 或同义回调。

验收标准描述应满足的行为，不表示已执行或通过；执行范围与证据见 [acceptance.md](./acceptance.md)，剩余事项只在 [tasks.md](./tasks.md) 维护。

跨组件配置职责见 [Theme 契约](../../engineering/048-Theme-configuration-contracts/spec.md)，视觉方法见 [Golden 规范](../../engineering/044-Testing-golden-regression/spec.md)。

## 1.0.1 API 兼容迁移

`TPopupOverlayConfig.onTap` 替代 `onClick`，不改变遮罩点击和关闭规则。

1.0.0 的 `destroyOnClose` 实际已用于控制被不透明路由遮挡时的状态保留：路由返回 `maintainState = !options.destroyOnClose`，并非控制关闭后是否销毁。旧参数默认 false，遮挡时保留状态；true 时允许释放，不保证每次遮挡均释放。无论取值如何，关闭后均释放，再次打开创建新 State。依据见 [v1.0.0 路由实现](https://github.com/Tencent/tdesign-flutter/blob/v1.0.0/tdesign-component/lib/src/components/popup/_popup_route.dart#L68)及[当时的参数说明](https://github.com/Tencent/tdesign-flutter/blob/v1.0.0/tdesign-component/lib/src/components/popup/t_popup_options.dart#L228)。

本次提供 `maintainState` 以纠正命名，并保留旧参数的取反映射和原生命周期行为；不是新增“关闭后保留”能力。新参数声明为 `bool? maintainState`，省略默认值时隐式为 null，表示未指定新值。构造/展示入口此时回退到 `!destroyOnClose`，因此两者均未传时实际仍为 true；不能将新参数直接默认设为 true，否则会覆盖旧参数显式 true 的调用。copyWith 的 null 回退规则见下文。继承签名适配是独立的源码兼容风险，与生命周期是否改变分别说明。

新旧参数同时提供时，新参数优先，仅通知一次；没有新参数时保留旧公开 getter 的继承覆盖。旧入口及类型保留，标注推荐入口和 2.0.0 删除计划。普通旧 API 调用、默认行为及 Controller 绑定规则不变；copyWith 覆盖或实现的签名适配例外见下文。

验收覆盖旧调用、继承覆盖、新参数优先级、空回调及实际交互；取反参数覆盖默认、真假组合、工厂、copyWith 和 normalized。

### copyWith 新旧参数共存与继承适配

`TPopupOptions.copyWith` 同时接受 `bool? maintainState`（默认 null）和兼容参数 `bool? destroyOnClose`。maintainState 非空时优先，包含 false；否则取非空 destroyOnClose 的反值；两者均为 null 或未传时保留当前有效 maintainState（含旧 getter 覆盖）。不改变原对象，其他字段仍按原有复制规则处理。旧参数标明替代入口和 2.0.0 删除计划。

移除未发布的独立方法 `copyWithMaintainState`，统一使用原 copyWith。普通旧调用、旧 getter 覆盖及未覆盖该方法的子类保持原行为。1.0.0 使用方如覆盖或实现了 copyWith，升级到 1.0.1 时必须增加可选参数 bool? maintainState，并处理或转发；仅增加参数而忽略其值不算完成适配。该签名扩展属于继承源码的破坏性变更，FAQ 不能消除兼容风险，更新日志和版本化 FAQ 必须明确，不能宣称全部旧覆盖无需修改。

此前独立方法方案保留旧覆盖签名，但增加冗余入口及后续迁移成本，已按用户确定的统一命名方案取代。2.0.0 计划删除旧 destroyOnClose 参数，已使用 maintainState 的普通复制调用无需再次迁移。 自定义子类届时须移除向 super.copyWith 转发的旧参数；如继续提供自身的旧兼容入口，应自行取反映射到 maintainState。依赖旧 destroyOnClose getter 覆盖的类须改为显式配置或覆盖 maintainState。API 清理不应改变默认有效值、遮挡保留及关闭释放的生命周期契约。

验收覆盖：当前状态真假 × 新旧 nullable 参数的完整矩阵、显式 false 优先、null 回退、旧 getter 覆盖、其他配置保留与原对象不变、normalized、实际遮挡/恢复/关闭生命周期，以及增加参数后的子类虚分派、参数转发和原有复制定制。生成 API 保留两个参数的类型、可选性与迁移说明，不再生成独立方法。
