# Rate 契约收敛与边界修复

## 背景

Rate 初版对齐公开 Demo 后，仍存在文案状态由组件与 Theme 双重控制、半星文案索引错误、自定义图标未贯穿浮层、读屏不可调整、RTL 绘制与命中方向错误，以及浮层样式常量未使用 token 等问题。

## 目标

- `texts` 是可见辅助文案的唯一状态入口：`null` 不显示，非 `null` 显示。
- 0 分或未命中文案档位时使用 `context.resource.notRated`；非整数评分按小程序的 `floor(value - 1)` 选择五档文案。
- 自定义图标同时用于主评分与半星选择浮层。
- 读屏将 Rate 识别为可增减的 slider，并复用受控回调链。
- LTR/RTL 下的命中与半星裁剪方向正确。
- 浮层尺寸、间距、圆角与字体从现有 TDesign token 派生。
- 浮层在窄屏和屏幕上下边界内保持可访问，必要时允许水平滚动。
- 整星点击、长按和拖动默认显示当前评分提示，可通过 `showValueIndicator` 关闭；提示与半星点击的精确选择浮层都固定锚定当前评分项，不跟随指针在项内移动。
- 整星模式将受控小数值向下归一化，确保绘制、文案与语义值一致。
- Demo 带文案行对齐小程序 `96rpx` 高度、`32rpx` 水平内边距和 `200rpx` 标题宽度；评分文案保持内容自适应，不设固定宽度。
- “组件类型”补齐第三方图标评分；“带描述评分”保持一个 Demo 分组，依次展示 `3 + 数字文案`、`3 + 默认情绪文案`和 `0 + 默认情绪文案` 三个独立白色栏，栏间距使用 `spacer16` token。
- 辅助文本遵循组件 Theme、显式 Material `ColorScheme.onSurface`、TDesign token 的解析顺序；评分星色保持 warning 语义，不机械映射 Material `primary`。
- 同一次指针交互只产生一组开始/结束生命周期；慢速拖拽不会因 tap 与 drag 识别器竞争而重复触发开始回调，指针取消以当前受控值结束。
- 拖动越过评分区域起始端可将整星或半星评分清零。
- 半星模式的读屏值始终包含可区分的数值；配置辅助文案时同时播报数值与档位描述。
- 未设置 `textWidth` 时，辅助文案在有界父布局中使用剩余宽度并省略溢出，在无界父布局中保持内容宽度。

## 非目标

- 不复制小程序的 `disabled`、`placement`、`iconPrefix` 等 API；评分提示位置由 Flutter 根据屏幕空间自适应。
- 不新增 Controller、非受控值或第二套状态源。
- 不保证第三方平台字体自动可用于 Flutter，第三方图标仍由 Widget builder 提供。

## 行为契约

1. `value` 仍是唯一评分状态源，`onChanged == null` 仍是唯一禁用表达。
2. `texts == null` 时不渲染辅助文案；`texts != null` 时渲染，未命中文案档位时使用本地化未评分兜底。
3. `allowHalf == false` 时小数受控值向下归一化，绘制、文案与语义使用同一值。
4. 语义增减步长在整星模式为 1，在半星模式为 0.5，并限制在 0 到 `count`。
5. 主体与浮层都调用同一个 `TRateIconBuilder`。
6. RTL 下从右侧开始计算评分，半星填充从右侧裁剪。
7. 同一次指针或语义交互最多触发一次 `onChangeStart` 和一次 `onChangeEnd`；指针取消不提交新的评分值。
8. 半星 Semantics 的当前值、增大值和减小值必须可区分，辅助文案不能覆盖数值信息。
9. 整星和半星模式拖动越过评分区域起始端时均可回到 0 分，并沿用受控回调链。
10. `showValueIndicator` 默认为 `true`，控制整星点击、长按和拖动过程中的当前值提示；`false` 不改变评分回调和半星点击选择能力。长按识别后的移动继续更新评分，松手关闭提示并完成同一次交互生命周期。评分提示与半星选择浮层的水平锚点均由当前评分值对应的星标中心决定。

## Breaking change 与迁移

`TRateThemeData.showText` 已存在于 `1.0.0-alpha.1`，本次删除属于公开 API breaking change。继续删除该字段以避免 Theme 承载内容可见性状态，但交付时必须标记为 breaking，并提供迁移说明：

- 原 `TRateThemeData(showText: true)`：改为向对应 `TRate` 传入非 null 的 `texts`；
- 原 `TRateThemeData(showText: false)` 或未配置：将 `TRate.texts` 保持为 null；
- 文案样式仍通过 `TRateThemeData.textStyle`、`textGap` 与 `textWidth` 配置。

此外，整星点击、长按和拖动由默认不显示评分提示改为默认显示，属于用户可感知的默认行为变化。需要维持旧视觉反馈时，为 `TRate` 设置 `showValueIndicator: false`；半星点击仍显示精确选择浮层。

## 验收标准

- 组件测试覆盖文案、默认评分提示及关闭路径、半星浮层、自定义图标、读屏增减、RTL、慢速拖拽生命周期、指针取消与受限宽度长文案。
- Demo 结构测试和 Flutter 3.32.0 Linux light/dark Golden 通过。
- Demo 非视觉契约测试在 Flutter 3.32.0 与 latest 均执行，Golden 独立固定在 Flutter 3.32.0 Linux。
- 生产 Rate 源码行覆盖率不低于 95%。
- Flutter analyze 零告警，示例生成片段同步。
