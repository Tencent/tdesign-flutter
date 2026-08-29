# Link 小程序契约对齐

## 背景

Flutter `TLink` 将下划线和图标建模为互斥 `variant`，并会在图标模式下自动补齐用户未传入的图标；这与小程序中 `underline`、`prefixIcon`、`suffixIcon` 彼此独立的契约不一致，也导致默认主题、图标组合和 Demo 表现偏离。

## 目标

- 下划线、前置图标和后置图标可独立组合，不隐式生成内容。
- 默认主题、尺寸、图标间距、禁用色和交互色对齐小程序 Token。
- Demo 的分组、文案和实例矩阵对齐小程序。

## 非目标

- 不复制小程序 `navigatorProps`；Flutter 导航由 `onPressed` 与 Router / Navigator 组合。
- 不暴露 hover 开关；Flutter 按原生桌面、Web 与触摸交互状态处理反馈。
- 不修改 Divider 或 Icon 组件契约与 Demo。

## 行为契约

- 删除 `TLinkVariant`、`variant` 和 `TLinkThemeData.defaultVariant`。
- 新增 `underline` 可空布尔值：实例 > `TLinkThemeData.underline` > `false`。
- `prefixIcon` / `suffixIcon` 只渲染用户显式传入的 Widget，可与 `underline` 同时生效。
- 默认 `colorScheme` 为 `defaultTheme`，默认 `size` 为 medium。
- small / medium / large 分别使用 `fontBodySmall` / `fontBodyMedium` / `fontBodyLarge`，图标尺寸分别为 14 / 16 / 18dp，图文间距统一为 `spacer4`。
- normal / active / disabled 使用对应语义 Token；禁用时不响应点击且保留 link 语义。
- 任意 Widget 内容通过 `DefaultTextStyle` 与 `IconTheme` 获得默认样式，显式子组件样式保留 Flutter 原生覆盖语义。

## 验收标准

- [x] 七类官方 Demo 场景与小程序分组、组合和视觉一致。
- [x] 下划线可与前/后图标组合，且不会自动增加图标。
- [x] 浅色、深色主题均使用语义 Token。
- [x] 公开 API 迁移、消费方、测试、Demo 和生成资产已同步。
- [x] Flutter 3.32.0 / latest 的 analyze 和聚焦测试通过。
