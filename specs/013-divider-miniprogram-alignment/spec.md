# Divider 小程序视觉契约对齐

## 背景

Flutter `TDivider` 没有承担小程序默认水平外边距、竖线高度与间距，文本样式也使用了
14px secondary，导致 Demo 必须额外包装 `SizedBox` / `Padding` 才能近似小程序。

## 目标

- Divider 组件自身承担水平、垂直布局的默认几何。
- 线条与文字默认样式使用 TDesign Token。
- Divider Demo 的分组、文案和实例矩阵对齐小程序。

## 非目标

- 不新增或删除公开 API。
- 不删除已有 Material `DividerThemeData` 兼容能力。
- 不改变垂直布局忽略 `dashed`、`align` 和 `child` 的既有规则。

## 范围

- `TDivider`、`TDividerThemeData`、`TThemeBuilder` 映射。
- Divider 测试、Golden、Demo 和生成示例资产。

## 行为契约

- 水平分割线默认上下外边距 10dp；线与内容间距为 `spacer12`。
- left / right 对齐的短边为 30dp，对应小程序 375dp 设计基准下的 60rpx。
- 垂直分割线默认高 14dp，左右外边距为 `spacer8`，调用方无需额外定高。
- 线条颜色默认使用 `bgColorComponent`，线宽默认 0.5dp。
- 内容默认使用 `fontBodySmall` 与 `textColorPlaceholder`。
- `TDividerThemeData.margin` 可整体覆盖不同 layout 的默认外边距。
- 显式 Material `DividerThemeData` 配置继续参与颜色、粗细和间距解析。

## 验收标准

- [x] 两个官方 Demo 分组不依赖额外几何补丁。
- [x] 水平、带文字、虚线和垂直示例与小程序视觉契约一致。
- [x] 浅色、深色主题均使用语义 Token。
- [x] 测试、Demo 和生成资产同步更新。
- [x] 组件包与 Example 静态检查通过。
