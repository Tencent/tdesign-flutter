# Button 禁用态与浅色描边对齐

## 背景与目标

Button 的默认禁用前景色统一落到通用禁用文本色，且浅色描边按钮背景透明，与设计稿不一致。本次按按钮语义使用现有主题 Token 修正默认视觉。

## 行为契约

- 主色填充按钮禁用时使用 `textColorAnti`。
- 浅色填充按钮、主色描边按钮和主色文字按钮禁用时使用 `brandDisabledColor`。
- 主色描边按钮禁用边框使用 `brandDisabledColor`。
- 浅色描边按钮默认背景使用 `brandLightColor`。
- 显式 Material `ColorScheme` 仍优先于 TDesign 默认 Token。

## 非目标

- 不新增颜色参数，不在组件或 Demo 中硬编码颜色值。
