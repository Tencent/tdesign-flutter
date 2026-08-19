# Link 组件示例与图标行为对齐 h5 设计

## 背景

`TLink` 组件的示例演示页（`tdesign-component/example/lib/page/t_link_page.dart`）与 h5 端设计
（`tdesign-mobile-vue` 的 `src/link/demos`，在线示例
<https://tdesign.tencent.com/mobile-vue/mobile.html#/link>）存在差异：

- 示例结构：h5 将「带图标」拆分为「前置图标」与「后置图标」两个示例，Flutter 合并为一个「带图标链接」。
- 图标行为：当只传入 `suffixIcon` 时，Flutter 组件会自动补充一个默认的前置链接图标，h5 不会，导致
  「后置图标」「不同主题」「禁用状态」「链接尺寸」等示例无法按 h5 展示。
- 文案：链接尺寸示例的文案为「S/M/L 号链接」，h5 为「S/M/L 跳转链接」；「不同主题色」与 h5 的「不同主题」不一致。

## 目标

- 示例展示与 h5 对齐：将「带图标链接」拆为「前置图标文字链接」「后置图标文字链接」。
- 图标行为对齐 h5：仅传入 `suffixIcon` 时不再自动补默认前置链接图标。
- 文案对齐 h5：链接尺寸示例改为「S/M/L 跳转链接」，「不同主题色」改为「不同主题」。
- 同步更新示例代码快照、组件测试与站点文档。

## 非目标

- 不改变 `TLinkVariant.basic` / `TLinkVariant.underline` 的既有行为。
- 不改变「未传任何图标时默认展示 链接图标 + 跳转图标」的既有行为（该行为被现有测试覆盖）。
- 不改动 `TLinkVariant`、`TLinkColorScheme`、`TLinkSize` 等既有枚举/参数的签名。

## 新增 hover 参数（对齐 h5 点击反馈能力）

h5（tdesign-mobile-vue）`TdLinkProps` 提供 `hover`（是否开启点击反馈）。Flutter `TLink` 新增同名可选参数：

- `hover`：`bool`，默认 `true`。为 `false` 时关闭 InkWell 点击反馈（无水波纹 / 悬浮高亮），但链接仍可正常点击响应（用 `GestureDetector` 承接 `onTap`）。
- 该参数为**纯新增可选参数**，不改变既有行为（默认值 `true` 等价于现状），**非 breaking**。
- 覆盖 `TLinkVariant.basic` / `underline` / `icon` 三种形态。

## 范围

### 涉及

- 组件：`tdesign-component/lib/src/components/link/t_link.dart`
- 示例：`tdesign-component/example/lib/page/t_link_page.dart`
- 示例代码快照：`tdesign-component/example/assets/code/link.*.txt`
- 测试：`tdesign-component/test/components/link/t_link_test.dart`
- 站点文档：`tdesign-site/docs/components/link/README.md`
- 页脚示例（依赖 icon 后缀图标自动补前缀的旧行为）：`tdesign-component/example/lib/page/t_footer_page.dart`

### 不涉及

- 其他组件。
- `TLinkThemeData` / `TLinkResolve` 的颜色、字号、间距解析逻辑。

## 行为契约

- `TLink` 新增 `hover` 参数（默认 `true`）：为 `true` 时用 `InkWell` 提供点击反馈；为 `false` 时改用 `GestureDetector`（仅响应点击、无水波纹），对 `basic` / `underline` / `icon` 三种形态一致生效。
- `TLinkVariant.icon` 下，图标展示遵循以下规则：
  - 仅传 `prefixIcon`：只展示前置图标。
  - 仅传 `suffixIcon`：只展示后置图标（不再自动补默认前置链接图标）。
  - 同时传 `prefixIcon` 与 `suffixIcon`：前后图标都展示。
  - 两者都不传：保持默认展示 链接图标 + 跳转图标（既有行为不变）。
- 文案对齐 h5：链接尺寸示例展示「S/M/L 跳转链接」。
- 链接尺寸示例中，后缀跳转图标大小跟随 `TLinkSize` 变化（S=14 / M=16 / L=18），与组件默认图标尺寸对齐。
- 图标颜色跟随链接语义色；禁用态下图标使用禁用色。

## 验收标准

- [ ] 示例页「组件类型」含：基础、下划线、前置图标、后置图标四个示例。
- [ ] 「不同主题」「禁用状态」示例展示带后缀跳转图标的链接。
- [ ] 「链接尺寸」示例展示带后缀跳转图标的 S/M/L 跳转链接，且图标大小跟随尺寸（S=14 / M=16 / L=18）。
- [ ] 仅传 `suffixIcon` 时，`find.byIcon(TIcons.link)` 为 `findsNothing`。
- [ ] `hover: true`（默认）时存在 `InkWell`；`hover: false` 时不存在 `InkWell` 但仍可点击（`T07b`/`T07c`/`T07d` 用例覆盖）。
- [ ] `flutter analyze` 0 error / 0 warning。
- [ ] 相关测试通过，示例代码快照与 `generate_example_code.dart` 一致。
