# 实施方案

## 技术方案

- `TDivider` 根据 layout 解析默认 margin 和垂直高度。
- 文字样式由 `fontBodySmall`、`textColorPlaceholder` 构造完整 Token 样式，再合并组件 Theme。
- 线条优先采用显式组件 Theme / Material Theme，最终回退到 `bgColorComponent`。
- `TThemeBuilder` 不再预填 Divider Extension，避免遮蔽 Material `DividerThemeData`。
- Demo 只编排官方场景，不覆盖组件文字、线条或几何默认值。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | Divider / ThemeBuilder | 默认视觉对齐 |
| 测试 | Divider Widget / Golden | 覆盖几何、主题和 Token |
| 示例 | Divider page | 与小程序 Demo 矩阵一致 |
| 文档 | dartdoc / Spec | 记录默认行为变化 |

## API 变化

- 不新增、不删除公开 API。
- 默认尺寸、外边距和文字样式变化属于用户可感知的 breaking 行为。

## 风险与取舍

- 用户依赖旧默认间距时视觉会变化；仍可通过 `TDividerThemeData.margin`、`thickness`、
  `textStyle` 覆盖。
- Material `DividerThemeData.space` 显式配置继续优先于 TDesign 默认间距。

## 验证策略

- Widget 测试覆盖默认几何、主题覆盖和垂直布局。
- Golden 覆盖浅色、深色官方样例。
- 运行组件包与 Example `flutter analyze`，并检查示例代码生成资产。
