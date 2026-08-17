# 实施方案

## 技术方案

1. **组件图标行为**：修改 `TLink._buildIconRow`，将「仅传 `suffixIcon` 时自动补默认前置链接图标」的行为移除，
   改为仅展示传入的后缀图标。同时理顺图标解析分支，使 `hasPrefix` / `hasSuffix` / 均未传三种情况互不干扰。
2. **示例页**：将「带图标链接」拆为「前置图标文字链接」与「后置图标文字链接」；「不同主题」「禁用状态」
   「链接尺寸」改为带后缀跳转图标的链接；尺寸文案改为「S/M/L 跳转链接」。
3. **页脚示例**：`t_footer_page.dart` 的单个链接页脚此前依赖「仅传 suffix 自动补前缀链接图标」的旧行为，
   显式补充 `prefixIcon: Icon(TIcons.link)` 以保持展示不变。
4. **测试**：为「仅传 suffix 不自动补默认前缀」补充断言 `find.byIcon(TIcons.link) == findsNothing`。
5. **示例代码快照与站点文档**：按新的示例方法更新 `link.*.txt` 与 `README.md`。
6. **hover 点击反馈开关**：为 `TLink` 新增可选参数 `hover`（默认 `true`），为 `false` 时改用 `GestureDetector` 承接 `onTap`，关闭 InkWell 水波纹反馈，对齐 h5 `hover` 能力。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `lib/src/components/link/t_link.dart` | 仅传 suffix 不再自动补默认前缀图标 |
| 测试 | `test/components/link/t_link_test.dart` | T05 补充断言 |
| 示例 | `example/lib/page/t_link_page.dart`、`t_footer_page.dart` | 示例结构 / 文案 / 图标对齐 |
| 示例快照 | `example/assets/code/link.*.txt` | 新增 prefix/suffix 快照，移除 icon 快照 |
| 文档 | `tdesign-site/docs/components/link/README.md` | 示例与 API 对齐当前组件 |

## API 变化

- 新增 `TLink.hover`（`bool`，默认 `true`）：为 `false` 时关闭 InkWell 点击反馈（用 `GestureDetector` 承接点击）。
  纯新增可选参数，不改变既有行为，**非 breaking**。
- `TLinkVariant.icon` 在「只传 suffixIcon」时的图标渲染行为变化（不再自动补默认前置链接图标），属于行为对齐 h5，非 breaking。

## 风险与取舍

- 页脚单个链接页脚依赖旧的自动补前缀行为，已通过显式传 `prefixIcon` 规避，展示不变。
- 「两者都不传 → 默认链接 + 跳转图标」行为保持不变，避免影响既有测试（T03 / T03b / T17c）。

## 验证策略

- 单元 / Widget 测试：T05 断言「仅传 suffix 时 `TIcons.link` 不出现」；T07b/T07c/T07d 断言 hover 开关对 InkWell 的控制。
- 静态检查：`flutter analyze` 0 error / 0 warning。
- 示例快照一致性：`dart run tool/generate_example_code.dart --verbose`（CI 兜底）。
- 人工验收：对照 h5 <https://tdesign.tencent.com/mobile-vue/mobile.html#/link> 逐项比对示例与文案。
