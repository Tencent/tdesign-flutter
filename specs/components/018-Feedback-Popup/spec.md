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
- TPopupOverlayConfig 只包括 showOverlay、color、preventTap、closeOnClick、onTap。color 自带 alpha，不再叠乘独立 opacity。默认显示遮罩并拦截背景；未指定色时回退组件 Theme，再到 black54。
- 可见性与拦截独立。只有可见且拦截的蒙层响应 onTap 和 closeOnClick；穿透时由背景接收事件，不把不可见层当作可点击遮罩。
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

## destroyOnClose 关闭销毁修复（独立交付）

Popup/Picker 保留现有 API、默认 false、Controller 绑定规则，不增加公开宿主、dispose 或状态保留参数。true 在关闭动画结束后卸载内容；false 关闭后保持内容 State，同一句柄 open 复用，重复 show 创建独立会话。路由正常 pop/remove，不把关闭路由保留在导航栈。打开期间被不透明路由遮挡时保留状态，不再把 destroyOnClose 取反用于遮挡策略；原 true 的遮挡释放行为也会改变。内部保留容器绑定实际 Navigator；卸载时清理隐藏内容，包括首次绘制前卸载。切换 Navigator 重新创建内容，不跨 Navigator 搬迁会话。

Drawer 单独保持 1.0.0 行为：`destroyOnClose: false`（默认）在不透明路由遮挡时保留 State，true 时允许释放；无论取值如何，关闭完成后均释放。句柄无重开入口，不创建保留容器，不缓存不可再使用的会话。内部入口采用包内桥接且不从主库导出，公开签名不变；不把 Drawer 的旧参数解释为关闭后缓存。下述关闭保留、隐藏路由及迁移风险适用于 Popup/Picker，以及沿用 Popup 默认配置的 ActionSheet 命令式入口。

隐藏内容维持原面板尺寸，避免停放扩大视口截断滚动位置；不绘制、不命中、不参与语义或焦点，禁用 Flutter ticker；业务定时器/订阅不保证暂停。result、onVisibleChange、onClosed 仍对应每次展示。关闭动画中 reopen、系统返回、非栈顶移除与重复关闭不得重复挂载或通知。隐藏期间由不进入返回栈的私有承载 ModalRoute 提供路由上下文；可见期间仍为本次实际路由，Navigator 祖先身份不变。承载路由不拦截底层点击，不向外传播隐藏 PopScope 的返回通知；不新增嵌套 Navigator。

风险：默认 false 以及显式 false 均从关闭释放变为保留，属于生命周期行为变化；丢弃句柄后仍可能占用至 Navigator 卸载，根 Navigator 可能长时间存活。本候选按确定的 1.0.1 修复范围单独交付，不宣称透明兼容旧资源释放时机，不与 API 命名迁移合并。

替换会话的兼容边界：默认 false 关闭后内容仍挂载，GlobalKey 及内容使用的业务 Controller 不能视为已释放/解绑。同句柄 open 复用原 State 和绑定；独立 show 推荐使用独立 GlobalKey 与 Controller，共享能力仍以各 Controller 原有规则为准。若需在替换会话时转交同一资源，应在创建旧会话时设置 true，并等旧内容卸载后再 show；不能事后通过关闭 false 会话获得销毁效果。false 的 onClosed 不等于内容 dispose，不应据此释放仍被内容使用的 Controller。Controller 所有权和重复绑定规则未改，解绑时机随 State 保留延后。这是 Popup/Picker 的生命周期 breaking，Drawer 不适用。

正式回归覆盖 Popup/Picker 两入口：同句柄重开保留 GlobalKey State/滚动位置且不重复绑定、false 替换复用 GlobalKey 的框架诊断、共享 ScrollController 的多位置与 position 断言、true 卸载后的安全转交、false 使用独立资源的安全替换及 Navigator 卸载清理。测试将不支持的复用作为兼容边界，不通过改实现或收紧公开 API 消除诊断。

局部历史消费返回（didPop 返回 false）不等于路由成功弹出；后续直接移除或非栈顶移除仍须保留 false 会话 State，同句柄重开复用。成功 pop 保持原动画与回调时序，内容在关闭动画结束后停放。此前局部历史消费时的 close-start 通知位置不在本次调整范围；零动画 onClosed 同步重开另行处理。

声明式 Navigator.pages 替换关联页面导致 Popup 移除时，同一 Navigator 的 false 会话也保留 State；内部停放刷新不得因构建阶段跳过而丢失 State。

## 1.0.0 → 1.0.1 蒙层配置调整（源码 breaking）

TPopupOverlayConfig 改为 final，库外不能 extends 或 implements；推荐使用 onTap，保留 onClick 构造参数及成员并标记废弃。非空 onTap 优先，null 时回退到 onClick；内部只保存并触发一个有效回调，旧成员返回同一个有效回调。保留直接构造、const、五项原有配置的默认值、蒙层通知时机与关闭条件，不涉及 TPopupOptions/copyWith、destroyOnClose 生命周期、Controller 或其他 Popup 类型的继承规则。

原因：配置对象负责不可变配置值，业务使用构造与组合；避免未来新增配置成员都要求外部 implements 补齐。final 不保证任意新增必填参数、改默认值或改变行为都兼容，也不等于限制 Popup 的 child/builder/回调扩展。旧动态 getter 每次读取的行为与配置快照不一定等价，handle.open() 沿用创建句柄时的 options，不会应用新配置；更换配置须重新构造 TPopupOptions，通过 TPopup.show() 创建新会话，不承诺活动 Popup 自动响应外部配置变化。

旧 onClick 普通调用和成员访问保持可用并提示废弃；旧继承、implements 以及相关 mock 仍需迁移；Popup 组件文档的 FAQ 说明接口现状、源码迁移影响、组合替代和新配置的实际应用方式，明确 1.0.0 到 1.0.1 的适配范围，不表述其他版本方向；不用新增一个 getter 的转发作为 final 的适配方案。消费者测试验证旧 implements/extends 被诊断、普通 const 构造与业务工厂可用，并覆盖真实遮罩点击和关闭先后。该配置契约已随 #1199 合入 develop；final 限制仍属于源码 breaking。本 PR 沿用该契约，只叠加上节 destroyOnClose 生命周期修复，不再次调整配置 API。


show() 创建独立会话并立即显示，不需要随后调用 open()；open() 沿用原句柄创建时的配置，已显示时不重复打开。更换配置通过 show() 创建新会话，不会自动关闭旧会话。该重开行为在 1.0.0 已存在，API 注释与 FAQ 必须区分既有行为和本次源码迁移。本次不新增 update()、dispose()、宿主 API 或 maintainState，也不修改默认值、回调时机或 Controller 绑定规则。

组件 FAQ 在生成 API 入口后维护；文档校验允许该问答区，但仍拒绝复制 API 表、重复生成入口和额外演示章节。全局 FAQ 不重复 Popup 详情。


## FAQ 展示与 ActionSheet 间接影响

Popup FAQ 保留变化、推荐用法与关键资源风险；重复 close 不销毁、onClosed 与 dispose 的区别、Controller 所有权/多绑定规则、根 Navigator 长期保留以及旧 true 的遮挡变化仍由本 Spec 详细说明，不因 FAQ 精简而撤销。Picker 与 DateTimePicker 只给出 TPickerPopup 的简短提示，链接到 Popup 的“替换会话”具体标题，使用文档局部稳定锚点 popup-session-reuse，必须带 tab=api；空锚点仅以 relative/top:-128px 提前定位，不占额外布局高度，避免固定栏遮挡目标标题，不修改全站滚动行为；独立面板不受弹层保留规则影响。Drawer 不复制该升级 FAQ，维持既有 API 注释及关闭/遮挡规则。

ActionSheet 的 showList/showGrid 通过 _show、showGridSections 直接调用 TPopup.show；两处 TPopupOptions.bottom 均不传 destroyOnClose，因而沿用 false 保留策略。返回值为 TPopupHandle，可同句柄 open 重开，所属 Navigator 卸载时清理。此间接生命周期影响此前范围说明遗漏，本轮补齐记录，不改变实现。三个入口都没有 destroyOnClose 参数，不能让用户直接设置 true；ActionSheet FAQ 须独立注明参数限制，再链接通用资源风险。不可把“仅 Popup/Picker 受影响”作为完整结论，也不新增参数或更改默认值来规避该限制。


## 蒙层配置与原会话重开的 FAQ 详细边界

FAQ 前两问仅保留 1.0.0 到 1.0.1 的适配风险、回调优先级及实际用法；不改变配置 final、onTap/onClick 或 open/show 的既有契约。库外 extends/implements 及相关 mock 应改为构造与组合；不能仅增加 onTap getter 或通过 noSuchMethod 绕过 final。旧 onClick 构造参数与成员保留并提示废弃；非空 onTap 优先，null 回退 onClick，每次点击仅通知一次，旧 onClick 成员返回实际生效的回调。将废弃提示提升为错误的检查仍需适配。

工厂组合示例从 FAQ 移至此处，避免在用户页面重复展开设计说明：

```dart
TPopupOverlayConfig createOverlay({
  required bool showMask,
  VoidCallback? onMaskTap,
}) {
  return TPopupOverlayConfig(
    showOverlay: showMask,
    onTap: onMaskTap,
  );
}
```

将 TPopupOverlayConfig(onClick: callback) 改为 TPopupOverlayConfig(onTap: callback) 即可迁移普通调用；旧动态 getter 与不可变配置快照并不等价，需按业务状态重新创建配置，工厂不保证旧动态读取行为透明兼容。其他蒙层默认值、通知时机及关闭条件不因本轮文案精简改变。

handle.open() 沿用创建句柄时的 options，不重新应用新配置，是 1.0.0 已有行为；更换配置需构造 TPopupOptions 并通过 TPopup.show() 创建独立会话。新会话不自动关闭旧会话，替换前关闭旧会话后仍须按 destroyOnClose 的资源复用边界处理；配置复用与内容 State 保留是不同维度。详细生命周期、GlobalKey 和 Controller 限制继续沿用上文，不因为 FAQ 删句而撤销。
