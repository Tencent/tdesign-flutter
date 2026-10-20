# Divider 设计说明

<a id="record-013-miniprogram-alignment"></a>
<a id="record-038-vertical-spacing"></a>

## 背景与目标

以下保留设计形成时的问题与依据；已修复的问题不表示当前代码仍有同一缺陷。

水平与垂直分隔的布局和默认间距混用，单靠 Demo 外间距无法修复。

Flutter `TDivider` 没有承担小程序默认水平外边距、竖线高度与间距，文本样式也使用了
14px secondary，导致 Demo 必须额外包装 `SizedBox` / `Padding` 才能近似小程序。

垂直分割线默认左右外边距各 8dp，实际运行时与相邻文案过紧。本次对齐为左右各 16dp。

## 范围与非目标

### 目标

- Divider 组件自身承担水平、垂直布局的默认几何。
- 线条与文字默认样式使用 TDesign Token。
- Divider Demo 的分组、文案和实例矩阵对齐小程序。

### 涉及

- `TDivider`、`TDividerThemeData`、`TThemeBuilder` 映射。
- Divider 测试、Golden、Demo 和生成示例资产。

### 不涉及

- 不新增或删除公开 API。
- 不删除已有 Material `DividerThemeData` 兼容能力。
- 不改变垂直布局忽略 `dashed`、`align` 和 `child` 的既有规则。

## 最终方案与行为契约

- 水平分割线默认上下外边距 10dp；线与内容间距为 `spacer12`。
- left / right 对齐的短边为 30dp，对应小程序 375dp 设计基准下的 60rpx。
- 垂直分割线默认高 14dp，左右外边距为 `spacer8`，调用方无需额外定高。
- 线条颜色默认使用 `bgColorComponent`，线宽默认 0.5dp。
- 内容默认使用 `fontBodySmall` 与 `textColorPlaceholder`。
- `TDividerThemeData.margin` 可整体覆盖不同 layout 的默认外边距。
- 显式 Material `DividerThemeData` 配置继续参与颜色、粗细和间距解析。

- 垂直分割线未配置 Theme margin 时，使用 `spacer16` 作为左右外边距。
- 显式 `TDividerThemeData.margin` 仍拥有更高优先级。
- 水平分割线行为保持不变。

## 关键决策与取舍

| 决策 | 理由与取舍 |
| --- | --- |
| 采用的方案 | 方向决定组件自身的有效几何，垂直分隔保留自然内容高度与明确的外部约束。 |
| 保留的边界与代价 | 调用方布局负责外部排列，组件只负责线条、内容和本身间距。 |

### 设计演变中的关键理由

- 用户依赖旧默认间距时视觉会变化；仍可通过 `TDividerThemeData.margin`、`thickness`、
  `textStyle` 覆盖。
- 分隔间距使用实例参数、TDividerThemeData 和 TD Token 的明确回退链，Material DividerThemeData.space 不反向覆盖。

## 兼容性与迁移

默认间距发生变化，属于可见默认行为调整。

## 验收标准

- 两个官方 Demo 分组不依赖额外几何补丁。
- 水平、带文字、虚线和垂直示例与小程序视觉契约一致。
- 浅色、深色主题均使用语义 Token。
- 测试、Demo 和生成资产同步更新。
- 组件包与 Example 静态检查通过。

验收标准描述应满足的行为，不表示已执行或通过；执行范围与证据见 [acceptance.md](./acceptance.md)，剩余事项只在 [tasks.md](./tasks.md) 维护。

跨组件配置职责见 [Theme 契约](../../engineering/048-Theme-configuration-contracts/spec.md)，视觉方法见 [Golden 规范](../../engineering/044-Testing-golden-regression/spec.md)。
