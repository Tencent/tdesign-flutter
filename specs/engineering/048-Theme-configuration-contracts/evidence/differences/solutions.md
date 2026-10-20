# 32项差异处置结果

本记录保留Spec059的原始比较；按现有契约区分缺陷与已批准设计，未将所有差异强行改成旧小程序值。

| 处置 | 项数 |
|---|---:|
| 已有契约支持，运行通过，视觉待验收 | 8 |
| 平台几何方案待取证 | 1 |
| 具体实施方案待执行 | 21 |
| 已修复，运行通过，视觉待验收 | 2 |

双SDK严格分析0问题，相关完整功能回归各440项、仓库外迁移consumer各21项通过；每组件覆盖率均≥95%。47项聚焦检查包含在440项中。

## 逐项方案

### avatarBorderColor

**已有契约支持，运行通过，视觉待验收**

保留当前Flutter契约，不按旧CSS变量默认或覆盖能力修改生产实现；补当前契约的实际Widget断言。

验证：保留旧目标原始比较；新增contract/场景必须enforce=true且匹配，并覆盖浅/暗及自定义全局Token。

- [已有契约](../../../../../tdesign-component/lib/src/components/avatar/t_avatar_theme_data.dart#L84)：头像组成员描边颜色；未设置时使用 `bgColorContainer` Token。
- [已有契约](../../../../components/034-DataDisplay-Avatar/acceptance.md#L33)：明暗 Golden 中本次变更的头像组裁剪、边框与 `+5` 溢出文案符合设计稿

### avatarIconSmallFontSize

**已有契约支持，运行通过，视觉待验收**

保留当前Flutter契约，不按旧CSS变量默认或覆盖能力修改生产实现；补当前契约的实际Widget断言。

验证：保留旧目标原始比较；新增contract/场景必须enforce=true且匹配，并覆盖浅/暗及自定义全局Token。

- [已有契约](../../../../../tdesign-component/lib/src/components/avatar/t_avatar_theme_data.dart#L62)：默认图标大小；未设置时小、中、大尺寸分别为 20、24、32 逻辑像素。

### avatarTextLargeFontSize

**已有契约支持，运行通过，视觉待验收**

保留当前Flutter契约，不按旧CSS变量默认或覆盖能力修改生产实现；补当前契约的实际Widget断言。

验证：保留旧目标原始比较；新增contract/场景必须enforce=true且匹配，并覆盖浅/暗及自定义全局Token。

- [已有契约](../../spec.md#source-048)：字符头像仍按 `size` 使用内置字号与字重
- [已有契约](../../../../components/034-DataDisplay-Avatar/spec.md#L36)：字符头像按大、中、小尺寸默认使用 20、16、14 字号和 Semibold 字重。

### avatarTextMediumFontSize

**已有契约支持，运行通过，视觉待验收**

保留当前Flutter契约，不按旧CSS变量默认或覆盖能力修改生产实现；补当前契约的实际Widget断言。

验证：保留旧目标原始比较；新增contract/场景必须enforce=true且匹配，并覆盖浅/暗及自定义全局Token。

- [已有契约](../../spec.md#source-048)：字符头像仍按 `size` 使用内置字号与字重
- [已有契约](../../../../components/034-DataDisplay-Avatar/spec.md#L36)：字符头像按大、中、小尺寸默认使用 20、16、14 字号和 Semibold 字重。

### avatarTextSmallFontSize

**已有契约支持，运行通过，视觉待验收**

保留当前Flutter契约，不按旧CSS变量默认或覆盖能力修改生产实现；补当前契约的实际Widget断言。

验证：保留旧目标原始比较；新增contract/场景必须enforce=true且匹配，并覆盖浅/暗及自定义全局Token。

- [已有契约](../../spec.md#source-048)：字符头像仍按 `size` 使用内置字号与字重
- [已有契约](../../../../components/034-DataDisplay-Avatar/spec.md#L36)：字符头像按大、中、小尺寸默认使用 20、16、14 字号和 Semibold 字重。

### buttonBorderWidth

**平台几何方案待取证**

先在375宽目标小程序宿主记录button及::after的有效width/height、border-width、transform和transform-origin；连同基础库/OS/DPR存档，再裁定Flutter 1dp是否等效。

影响与边界：若存在200%伪元素和scale(0.5)，4rpx在375宽下为2dp再缩至1dp；这是条件推导，不是已取得的宿主事实。没有缩放时才应按2dp讨论。

验证：DPR2/3及浅/暗outline/ghost实际描边与边框盒；固定viewport和来源版本。不得由源码字面值直接改成2dp。

### buttonDangerDisabledBg

**具体实施方案待执行**

建议保留语义errorColorDisabled，并明确记录与直接errorColor3覆盖的区别；确认语义优先策略后登记为Flutter契约差异。

影响与边界：不改当前默认像素；单独设置调色板errorColor3与语义errorColorDisabled时的结果不同。

验证：同时测试只覆盖errorColor3、只覆盖errorColorDisabled、两者同时覆盖；已裁定语义优先后断言后者胜出。

### buttonDangerDisabledColor

**具体实施方案待执行**

建议填充危险按钮禁用前景使用fontWhite1，保留危险禁用背景errorColorDisabled；必须先核对危险填充按钮的浅/暗设计节点。

影响与边界：当前通用禁用字色会变为白色层级，属于可见默认变化；不能沿用primary深色fontWhite4裁定。

验证：核对危险背景上的对比及浅/暗最终颜色；显式实例disabled foreground仍优先，Linux定向Golden先无更新比对。

### buttonDangerOutlineDisabledColor

**具体实施方案待执行**

与危险填充禁用背景采用同一语义规则：建议前景和描边使用errorColorDisabled；不为旧CSS调色板引用新增独立入口。

影响与边界：默认主题不变；独立Token覆盖的优先级需要文档化。

验证：前景与描边必须同源；覆盖errorColor3/errorColorDisabled及实例ButtonStyle时分别断言。

### buttonDangerTextDisabledColor

**具体实施方案待执行**

建议文字危险按钮禁用前景使用errorColorDisabled；不机械复制冻结源码fontWhite1，以免浅色容器出现白底白字。取得设计裁定后再实施。

影响与边界：当前通用禁用字色会变成危险语义禁用色；需同时核对文字按钮背景和可读性。

验证：分别验证填充与文字分支；禁止复用同一disabled helper而把文字分支变成白字；实例状态样式优先。

### buttonDefaultActiveBgColor

**具体实施方案待执行**

拟将_resolveFillColors调用的_pressedBackgroundColor默认配色改为bgColorComponentActive；并让既有hasPressedBackground检测关闭重复pressed overlay。

影响与边界：普通与渐变/自定义背景必须按实际路径区分；默认填充按压视觉变化。

验证：真实指针按下保持、释放、取消、禁用切换；浅/暗下断言背景及overlay，P0 stateful背景不能被二次叠色。

### buttonGhostBorderColor

**已修复，运行通过，视觉待验收**

默认配色启用态前景/描边统一回退textColorAnti；禁用fontWhite4与实例ButtonStyle优先级不变。

验证：检查独立textColorAnti/fontWhite1，实际Text前景与Material边框一致；默认主题两Token相等，默认像素不变。

### buttonGhostColor

**已修复，运行通过，视觉待验收**

默认配色启用态前景/描边统一回退textColorAnti；禁用fontWhite4与实例ButtonStyle优先级不变。

验证：检查独立textColorAnti/fontWhite1，实际Text前景与Material边框一致；默认主题两Token相等，默认像素不变。

### buttonGhostDangerHoverColor

**具体实施方案待执行**

与ghost交互统一裁定；如按目标改变前景/描边，危险色按压取errorColorActive，避免只改文字遗漏边框。

影响与边界：须同时评估Ink层和透明容器上的实际视觉；不能把一次getter修正当作像素验收。

验证：独立覆盖errorColor/errorColorActive，按下/释放/禁用均检查前景、边框和实例优先级。

### buttonGhostHoverColor

**具体实施方案待执行**

建议先沿用Spec009的Flutter Ink状态层契约；取得目标按压设计后记录平台交互例外。若要求前景随按压变化，则默认ghost前景/边框用fontWhite2，并以已产生的前景/边框反馈抑制重复pressed overlay。

影响与边界：现有12%前景色状态层与冻结CSS前景变化不能只用字段相等判断视觉等价；必须检查实际合成结果。

验证：真实按下/释放/取消、hover/focus、透明背景及P0透明overlay；已产生反馈时不得重复叠加，禁用始终无反馈。

### buttonGhostPrimaryHoverColor

**具体实施方案待执行**

与默认ghost采用同一交互裁定；如按目标改变前景/描边，主色按压取brandColorActive，且与overlay反馈统一解析。

影响与边界：不新加activeColor入口；保持实例ButtonStyle拥有最终状态样式。

验证：独立覆盖brandColor与brandColorActive，检查真实按压的Text与Material边框及overlay组合。

### buttonLightActiveBgColor

**具体实施方案待执行**

拟将_pressedBackgroundColor浅色配色改为brandColorLightActive，避免使用brandColorFocus；沿同一resolve路径覆盖普通分支。

影响与边界：浅色填充按压色变化；焦点色不应被当作按压默认。

验证：独立设置brandColorFocus和brandColorLightActive，确认按压读取后者；复验焦点反馈和实例stateful ButtonStyle。

### emptyActionMarginTop

**已有契约支持，运行通过，视觉待验收**

保留当前Flutter契约，不按旧CSS变量默认或覆盖能力修改生产实现；补当前契约的实际Widget断言。

验证：保留旧目标原始比较；新增contract/场景必须enforce=true且匹配，并覆盖浅/暗及自定义全局Token。

- [已有契约](../../../../components/031-DataDisplay-Empty/spec.md#L11)：图片优先于图标，描述始终可选；操作 Widget 非空时以 32 间距展示。

### emptyDescriptionMarginTop

**已有契约支持，运行通过，视觉待验收**

保留当前Flutter契约，不按旧CSS变量默认或覆盖能力修改生产实现；补当前契约的实际Widget断言。

验证：保留旧目标原始比较；新增contract/场景必须enforce=true且匹配，并覆盖浅/暗及自定义全局Token。

- [已有契约](../../../../components/031-DataDisplay-Empty/spec.md#L12)：默认图标 96，图标/图片到描述间距分别为 22/16。

### inputBorderColor

**具体实施方案待执行**

拟仅将TInput._borderColor中normal分支由componentBorder改为componentStroke；保留focused/status和显式Theme边框策略，先核对Input分隔线设计。

影响与边界：浅色与暗色默认分隔线颜色均变化；FormItem外层分隔线与Input自身分隔线需避免双线。

验证：独立覆盖componentBorder/componentStroke；正常、聚焦、禁用、success/warning/error及borderless/FormItem组合均需Widget与定向Golden。

### inputVerticalPadding

**已有契约支持，运行通过，视觉待验收**

保留当前Flutter契约，不按旧CSS变量默认或覆盖能力修改生产实现；补当前契约的实际Widget断言。

验证：保留旧目标原始比较；新增contract/场景必须enforce=true且匹配，并覆盖浅/暗及自定义全局Token。

- [已有契约](../../../../../tdesign-component/lib/src/components/input/t_input_theme_data.dart#L38)：null 时在 TFormItem 作用域内为零，独立输入框为四周 16 逻辑像素

### switchDotLargeSize

**具体实施方案待执行**

在Switch内部建立按size解析的私有几何值，直接传到实际RenderBox/Painter以实现大号普通滑块直径26；去除整件FittedBox统一缩放。有图文/加载或开启态按26绘制。

影响与边界：这是同一几何修复批次，不逐项打补丁；不将私有几何表暴露为新的公开配置源。

验证：三尺寸×filled/text/icon×开/关×禁用/加载；测真实轨道、滑块、图标和字号。保留长文案、1/2/3倍字号、Theme插值、RTL手势；双SDK与Linux受影响Golden。

### switchDotPlainLargeSize

**具体实施方案待执行**

在Switch内部建立按size解析的私有几何值，直接传到实际RenderBox/Painter以实现大号无图文未选中滑块直径22；去除整件FittedBox统一缩放。plain条件同冻结WXML，开启态回到普通26。

影响与边界：这是同一几何修复批次，不逐项打补丁；不将私有几何表暴露为新的公开配置源。

验证：三尺寸×filled/text/icon×开/关×禁用/加载；测真实轨道、滑块、图标和字号。保留长文案、1/2/3倍字号、Theme插值、RTL手势；双SDK与Linux受影响Golden。

### switchDotPlainSize

**具体实施方案待执行**

在Switch内部建立按size解析的私有几何值，直接传到实际RenderBox/Painter以实现中号无图文未选中滑块直径18；去除整件FittedBox统一缩放。plain由无两项label、无两项icon且非loading决定，不能误用于图文/加载态。

影响与边界：这是同一几何修复批次，不逐项打补丁；不将私有几何表暴露为新的公开配置源。

验证：三尺寸×filled/text/icon×开/关×禁用/加载；测真实轨道、滑块、图标和字号。保留长文案、1/2/3倍字号、Theme插值、RTL手势；双SDK与Linux受影响Golden。

### switchDotPlainSmallSize

**具体实施方案待执行**

在Switch内部建立按size解析的私有几何值，直接传到实际RenderBox/Painter以实现小号无图文未选中滑块直径14；去除整件FittedBox统一缩放。plain条件同冻结WXML，开启态回到普通18。

影响与边界：这是同一几何修复批次，不逐项打补丁；不将私有几何表暴露为新的公开配置源。

验证：三尺寸×filled/text/icon×开/关×禁用/加载；测真实轨道、滑块、图标和字号。保留长文案、1/2/3倍字号、Theme插值、RTL手势；双SDK与Linux受影响Golden。

### switchDotSmallSize

**具体实施方案待执行**

在Switch内部建立按size解析的私有几何值，直接传到实际RenderBox/Painter以实现小号普通滑块直径18；去除整件FittedBox统一缩放。有图文/加载或开启态按18绘制。

影响与边界：这是同一几何修复批次，不逐项打补丁；不将私有几何表暴露为新的公开配置源。

验证：三尺寸×filled/text/icon×开/关×禁用/加载；测真实轨道、滑块、图标和字号。保留长文案、1/2/3倍字号、Theme插值、RTL手势；双SDK与Linux受影响Golden。

### switchIconLargeSize

**具体实施方案待执行**

在Switch内部建立按size解析的私有几何值，直接传到实际RenderBox/Painter以实现大号图标实际尺寸24；去除整件FittedBox统一缩放。图标和26dp滑块保留各自真实尺寸。

影响与边界：这是同一几何修复批次，不逐项打补丁；不将私有几何表暴露为新的公开配置源。

验证：三尺寸×filled/text/icon×开/关×禁用/加载；测真实轨道、滑块、图标和字号。保留长文案、1/2/3倍字号、Theme插值、RTL手势；双SDK与Linux受影响Golden。

### switchIconSize

**具体实施方案待执行**

在Switch内部建立按size解析的私有几何值，直接传到实际RenderBox/Painter以实现中号图标实际尺寸20；去除整件FittedBox统一缩放。独立图标尺寸不能随22dp滑块槽被缩成16。

影响与边界：这是同一几何修复批次，不逐项打补丁；不将私有几何表暴露为新的公开配置源。

验证：三尺寸×filled/text/icon×开/关×禁用/加载；测真实轨道、滑块、图标和字号。保留长文案、1/2/3倍字号、Theme插值、RTL手势；双SDK与Linux受影响Golden。

### switchIconSmallSize

**具体实施方案待执行**

在Switch内部建立按size解析的私有几何值，直接传到实际RenderBox/Painter以实现小号图标实际尺寸16；去除整件FittedBox统一缩放。图标和18dp滑块保留各自真实尺寸。

影响与边界：这是同一几何修复批次，不逐项打补丁；不将私有几何表暴露为新的公开配置源。

验证：三尺寸×filled/text/icon×开/关×禁用/加载；测真实轨道、滑块、图标和字号。保留长文案、1/2/3倍字号、Theme插值、RTL手势；双SDK与Linux受影响Golden。

### switchLabelColor

**具体实施方案待执行**

拟将TSwitchResolve.thumbContentOffColor默认回退改为bgColorSecondaryContainerActive，同步公开dartdoc；Theme显式值与禁用分支保留。

影响与边界：正常未选中文字/图标颜色变化；已记录的禁用/加载分层不变。

验证：分别验证text/icon、on/off、enabled/disabled/loading、浅/暗、全局Token与组件Theme独立覆盖；保留用户自定义前景。

### switchLargeWidth

**具体实施方案待执行**

在Switch内部建立按size解析的私有几何值，直接传到实际RenderBox/Painter以实现large轨道实际宽度52；去除整件FittedBox统一缩放。大号外框52×32，Painter轨道也应52×32。

影响与边界：这是同一几何修复批次，不逐项打补丁；不将私有几何表暴露为新的公开配置源。

验证：三尺寸×filled/text/icon×开/关×禁用/加载；测真实轨道、滑块、图标和字号。保留长文案、1/2/3倍字号、Theme插值、RTL手势；双SDK与Linux受影响Golden。

### switchSmallWidth

**具体实施方案待执行**

在Switch内部建立按size解析的私有几何值，直接传到实际RenderBox/Painter以实现small轨道实际宽度39；去除整件FittedBox统一缩放。小号外框39×24，Painter轨道也应39×24。

影响与边界：这是同一几何修复批次，不逐项打补丁；不将私有几何表暴露为新的公开配置源。

验证：三尺寸×filled/text/icon×开/关×禁用/加载；测真实轨道、滑块、图标和字号。保留长文案、1/2/3倍字号、Theme插值、RTL手势；双SDK与Linux受影响Golden。

## 可审查补丁

- [已实施的Ghost修复](../../acceptance.md#source-060)：一个语义回退源修正，覆盖文字/描边两个观察项。
- [四项视觉修复候选补丁](../../acceptance.md#source-060)：未应用到主工作区；在隔离工程Flutter3.47.7的47项聚焦检查通过，20条目标观察全部匹配。仍需完整回归、低SDK、设计及Linux视觉验收。

## 全量边界

其余524项运行队列未减去。所有条目的finalPaintVerified仍为false；已修复或已有契约支持只关闭本次运行/契约问题，不等于最终像素验收。CI/工作流/测试清单、正式版本及Golden均未修改，未发布。
