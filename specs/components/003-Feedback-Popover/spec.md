# Popover 设计说明

<a id="record-003-contract-hardening"></a>
<a id="record-015-color-scheme-instance-ownership"></a>
<a id="record-022-public-api-convergence"></a>
<a id="record-027-controller-theme-lerp"></a>

## 背景与目标

以下保留设计形成时的问题与依据；已修复的问题不表示当前代码仍有同一缺陷。

内容入口、主题覆盖与关闭控制曾分散，复杂 Widget 和键盘场景暴露尺寸及生命周期问题。

TPopover 已公开点击、长按、主题背景色、最小/最大尺寸和十二种 placement，但原实现存在公开参数未执行、主题字段未消费、最大高度被当作固定高度以及边缘位置越出可用视口的问题。现有测试主要验证“能够渲染”，没有验证这些 API 的实际效果，因此测试全绿仍可能留下运行时契约缺口。

此外，Popover 使用 root Overlay 并持有触发节点的 BuildContext。触发节点在浮层展示期间销毁时，组件不能继续使用失效坐标，也不能永久保留 OverlayEntry、滚动监听或未完成的 Future。

`TTag`、`TSelectTag` 和 `TPopover` 已公开实例级 `colorPreset`，但 `TTagThemeData` 与 `TPopoverThemeData` 仍保存同类型的枚举选择器。Tag 的 `dark / light / outline / light-outline` 绘制形态还由 Theme 中 `isLight + isOutline` 两个布尔值隐式组合，普通实例无法直接表达；Popover 的 `dark / info / error` 配色名称也没有沿用 Button 已建立的 `defaultTheme / primary / danger` 词汇。仓库组件 Review skill 与外部安装副本还存在内容漂移，且没有充分说明 `variant / colorPreset / status` 的语义判定、Theme 默认值条件和历史 API 债务边界。

`TPopover.showPopover` 同时提供 `String? content` 与 `Widget? contentWidget`，两者承接同一个内容槽，但允许同时为空或同时传入，并由实现隐式规定 `contentWidget` 优先。`placement` 也以 nullable 参数暴露，却在内部固定回退到 `top`。此外，底层定位渲染类 `TPopoverWidget` 从包入口公开导出，调用方可以绕过 Overlay 生命周期入口直接依赖实现细节。

本 Spec 是 Popover 公共契约的后续收敛，覆盖 `003-Feedback-Popover/records/003-contract-hardening` 中“保留双内容参数”和“兼容直接构造 `TPopoverWidget`”的旧范围约束，以及 `003-Feedback-Popover/records/015-color-scheme-instance-ownership` 中把 `TPopoverWidget` 视为公开配色入口的旧描述；既有 Spec 的历史验收记录不回写。

`TPopover.showPopover` 通过 `OverlayEntry` 命令式展开，适合一次性简单展示，
但缺少与 Widget 树长期绑定的受控入口。操作菜单等内容无法通过
公开契约主动展开、关闭或查询状态。

`TPopoverThemeData.lerp` 还会把 nullable 数值、颜色和内边距中的 `null`
当作 `0`、透明色或零内边距参与插值。`null` 实际表示继续使用组件或 TDesign
默认值，伪造中间值会在动态主题切换时短暂污染气泡尺寸与视觉。

本 Spec 是 `003-Feedback-Popover/records/022-public-api-convergence` 的后续能力补充；既有内容、
定位和回调契约保持不变。

## 范围与非目标

本组件的内容、状态、布局与生命周期按最终方案维护；跨组件 Token/Material 规则引用 Theme 工程 Spec，公开 Demo 与 Golden 范围引用对应工程规范，不把已取代的阶段限制继续作为当前要求。

## 最终方案与行为契约

### 内容与配置

- 内容统一为 required Widget content；placement 默认 top。onTap/onLongTap 只通知内容手势，不隐式关闭。任意 Widget 按真实尺寸测量，width/height 是显式外框约束；min/max 约束与 padding 不得产生负布局。
- 配色入口使用 colorPreset / TPopoverColorPreset；颜色预设不进入 Theme。borderRadius、barrierColor 等具体视觉由 TPopoverThemeData 提供，保留 Token 回退；不再公开同义的 radius/overlayColor 实例入口。
- TPopoverWidget 是包内布局实现，不从公开包入口导出。Tag 共享的形态与配色职责是实例 variant 与 colorPreset，Theme 不保存枚举选择器。

### 定位与生命周期

- 十二种 placement 保持方向语义；主方向不足而反向充足时同轴翻转，两侧都不足时约束到可用视口。安全区、键盘、箭头尺寸及圆角安全区参与定位。
- topLeft/topRight/bottomLeft/bottomRight 的箭头基准距对应边缘 12px；气泡定位、箭头绘制和 clamp 使用同一坐标。锚点卸载后主动关闭，不在原点遗留气泡。
- 外部点击、滚动、返回、锚点销毁和显式关闭共用幂等清理，释放 Overlay、监听与历史条目，并完成展示 Future。关闭策略为 false 时保留对应交互。

### 两层入口

- showPopover 维持单次命令式展示；TPopoverAnchor + TPopoverController 提供 open/close/isOpen/maybeOf。Controller 不保存内容、位置、样式或额外 visible 状态。
- Anchor 在展开时捕获配置，已展开内容不热更新；下次展开读取新配置。替换 Controller 时保留展开状态并转移控制权。重复打开、关闭及未绑定调用安全幂等。
- Theme 插值双方显式时连续插值；任一侧为空时保留运行时回退语义，不以透明色或任意固定默认值伪造端点。

## 关键决策与取舍

| 决策 | 理由与取舍 |
| --- | --- |
| 采用的方案 | 内容统一为 Widget；命令式 showPopover 与 Anchor/Controller 共用浮层路径，Controller 只管理开关，不复制配置。 |
| 保留的边界与代价 | 保留自动翻转、裁剪约束和箭头安全区；展开期间配置不热替换，下一次展开读取新配置。 |

### 被取代的方案与原因

曾考虑只保留单次命令式入口、不增加 Controller；最终保留命令式与 Anchor 两层入口，但 Controller 不持有配置，避免第二状态源。旧 colorScheme 命名及同义实例圆角/蒙层色被后续收敛取代。

- 自动翻转只发生在同轴反方向能够完整容纳气泡时；两侧都不足时保留调用方请求方向并优先保证内容可见。
- backgroundColor 覆盖语义背景 token 后，调用方需要自行保证与语义文本色的对比度；本次没有新增 textColor API。
- maxHeight 对超长文本只限制外框高度，若未来需要滚动或省略策略，应单独定义 overflow 契约。
- 生命周期守卫只在已有 frame 上执行检查，不主动制造持续动画帧；锚点销毁发生在布局 frame 内，随后通过同一 dismiss 路径完成回收。
- 本 Spec 原始阶段未引入动态测量；Spec 022 后续以首帧隐藏和真实子布局尺寸完成收敛。

- 任意 Widget 不能在 build 前通过文本测量得到尺寸，因此定位需要以真实布局尺寸为准；需防止首帧错误位置和重复布局。
- 隐藏实现类会影响直接构造它的调用方，但该类依赖锚点 context，无法独立管理 Overlay 生命周期，继续公开会形成第二入口。
- Widget 内容由调用方持有，事件回调不再回传内容，避免冗余数据源。

- 受控层会新增一个 Widget 公开契约，但避免在 Controller 中形成第二份
  可变视觉配置。
- Controller 不继承 `ChangeNotifier`；Anchor builder 会在展开状态变化时重建，
  与 Flutter `MenuController` 的非可监听命令模型保持一致。
- nullable 字段采用离散切换会牺牲一侧为空时的连续动画，但能避免无法在
  ThemeExtension 内解析的上下文 token 被错误替换为零值或透明值。

## 兼容性与迁移

- 配色参数与枚举由旧 colorScheme/TPopoverColorScheme 迁移为 colorPreset/TPopoverColorPreset；内容改为必填 Widget，placement 非空，内容回调为 VoidCallback，底层布局类不再公开导出。
- radius/overlayColor 的同义实例覆盖迁移为局部 TPopoverThemeData.borderRadius/barrierColor；Anchor/Controller 增量能力不改变单次 showPopover 的叠加语义。

## 文字槽布局补充

直接的 Text/TText 内容按有效的 softWrap、maxLines、overflow 和段落高度规则测量；不换行且不省略时仅计算单行高度，容器仍遵守宽度限制。显式宽高和直接文字的测量边界保持；组合内容仍由自身布局决定尺寸。

## 内容子树统一文字默认值

Popover 为整个 content 子树提供气泡文字默认样式，Row、Column、Padding、Builder 等布局包装不改变继承。TText 保持全局隔离，通过 TTextStyleScope 获取组件默认值；实例显式字段及内容内部更近的 TTextThemeData 继续优先，不新增配置。

这是自定义内容默认行为的兼容性变化：未设置或仅部分设置样式的 Text/TText 将按缺失字段接入气泡样式，可能改变颜色、字体、换行和尺寸。完全自绘内容应使用显式样式或内部局部主题；不扫描子树，也不对组合内容套用直接文字的自然尺寸测量。

## 验收标准

- Demo Golden 使用统一视觉入口（或显式传入 `--dart-define=TDESIGN_DEMO_TEST_MODULES=false`），隐藏内部测试模块；本地 debug 额外模块造成的差异不作为组件缺陷或基线更新依据。

- 验证 Widget 内容、显式尺寸、padding 与宽高约束的真实布局，无负测量或空气泡。
- 验证十二种 placement、翻转、clamp、箭头边距、安全区、键盘及锚点卸载。
- 覆盖命令式与 Anchor/Controller 的幂等开关、控制权替换、Future 完成和资源释放。
- 覆盖 colorPreset、Theme 字段、默认回退及 nullable 插值，不依赖已隐藏的实现类作为公开消费者。

验收标准描述应满足的行为，不表示已执行或通过；执行范围与证据见 [acceptance.md](./acceptance.md)，剩余事项只在 [tasks.md](./tasks.md) 维护。

跨组件配置职责见 [Theme 契约](../../engineering/048-Theme-configuration-contracts/spec.md)，视觉方法见 [Golden 规范](../../engineering/044-Testing-golden-regression/spec.md)。
