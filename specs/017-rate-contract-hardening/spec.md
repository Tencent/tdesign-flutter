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
- 整星模式将受控小数值向下归一化，确保绘制、文案与语义值一致。
- Demo 带文案行对齐小程序 `96rpx` 高度、`32rpx` 水平内边距和 `200rpx` 标题宽度；评分文案保持内容自适应，不设固定宽度。

## 非目标

- 不复制小程序的 `disabled`、`placement`、`iconPrefix` 等 API。
- 不新增 Controller、非受控值或第二套状态源。
- 不保证第三方平台字体自动可用于 Flutter，第三方图标仍由 Widget builder 提供。

## 行为契约

1. `value` 仍是唯一评分状态源，`onChanged == null` 仍是唯一禁用表达。
2. `texts == null` 时不渲染辅助文案；`texts != null` 时渲染，未命中文案档位时使用本地化未评分兜底。
3. `allowHalf == false` 时小数受控值向下归一化，绘制、文案与语义使用同一值。
4. 语义增减步长在整星模式为 1，在半星模式为 0.5，并限制在 0 到 `count`。
5. 主体与浮层都调用同一个 `TRateIconBuilder`。
6. RTL 下从右侧开始计算评分，半星填充从右侧裁剪。

## 验收标准

- 组件测试覆盖文案、浮层自定义图标、读屏增减和 RTL。
- Demo 结构测试和 Flutter 3.32.0 Linux light/dark Golden 通过。
- 生产 Rate 源码行覆盖率不低于 95%。
- Flutter analyze 零告警，示例生成片段同步。
