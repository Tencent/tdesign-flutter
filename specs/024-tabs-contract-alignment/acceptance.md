# 验收记录

## 验证环境

- 分支：`rss1102/breaking/tabs-contract-alignment`
- 基线分支：`develop`（重放时为 `de63f77d`）
- Flutter/Dart：Flutter 3.32.0 与 Flutter 3.47.0（latest）

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| Flutter 3.32 Tabs 定向 `flutter analyze --no-pub` | 通过 | 0 issues |
| Flutter 3.32 Tabs 三个组件测试文件 | 通过 | 74 tests；含 Material 视觉隔离与 Theme 插值断言 |
| Flutter 3.32 `example/test/tabs_page_test.dart` | 通过 | 公开 Demo 契约 |
| Flutter 3.32 Tabs 覆盖率门禁 | 通过 | 754/778，96.92% |
| Flutter 3.47 Tabs 定向 `flutter analyze --no-pub` | 通过 | 独立临时 worktree 中 `clean + pub get` 后 0 issues |
| Flutter 3.47 Tabs 三个组件测试文件 | 通过 | 74 tests；含 Material 视觉隔离断言 |
| Flutter 3.47 `example/test/tabs_page_test.dart` | 通过 | 公开 Demo 契约 |
| `dart run tool/generate_example_code.dart --check` | 通过 | 示例产物一致 |
| `sh ./demo_tool/all_build.sh` | 通过 | 使用 Dart 3.32，生成 57 份 API 文档 |
| 回归/覆盖率调度器自测 | 通过 | 11 tests |
| Flutter 3.32 Linux Golden | 通过 | Tabs light/dark 与导航矩阵 light/dark，共 4 tests；默认精确比较器，无容差放宽 |
| Tabs 相对 `develop` 的依赖审查 | 通过 | 仅包含 Tabs、Demo、测试、Spec 与回归配置；未引用 Badge 新增 variant、size 或 offset API |

## API 与实现收敛审查

| API / 实现 | 所有权 | 结论 |
| --- | --- | --- |
| `TTabsBarVariant.line/tag/card` | 单一结构形态选择器 | 保留；不增加 `size` 维度 |
| `controller` / `DefaultTabController` | 同一状态机制的显式与继承入口 | 保留；二者不同时拥有状态 |
| `onTap` | 用户点击事件；不负责保存选中状态 | 保留；与 Controller 不重复 |
| `TTab.child` | 图标、文字、Badge 等任意内容组合 | 保留；不增加 `badgeBuilder` 等专用入口 |
| Badge 依赖边界 | `TTab.child` 可组合任意已有 Widget | Tabs 仅使用 `develop` 已存在的基础 `TBadge` 组合方式，不依赖 Badge 分支的新 API |
| `decoration` / `indicator` | 实例级完整样式逃逸入口 | 保留；优先于 `TTabsBarThemeData` |
| `TTabsBarThemeData` | 子树级具体视觉默认值 | 保留；不承载 variant、状态或 Controller |
| `TTabsBarView` | 内容区及默认不可滑动物理语义 | 保留；无状态实现，无私有 Controller |
| `TTabsBarSize` | 尚无稳定跨端尺寸契约 | 不实现 |
| `TTab` 内层 `IgnorePointer` | 与标签栏统一禁用拦截重复 | 已删除；标签栏负责交互，`TTab` 负责禁用样式 |
| Material 指示器自动调色 | 父级 Material 背景色不属于 TDesign 视觉解析链 | 已删除；默认指示器颜色只由实例参数或 TDesign token 决定 |
| `TTabsBarThemeData.lerp` | Theme 动画期间的视觉值插值 | 文字、间距、指示器均使用对应类型的 lerp，不在中点突变 |
| 旧 `t_tabbar_golden_test.dart` 与 5 张旧 variant 图片 | 未登记、无有效像素断言或已无引用 | 已清理；当前基线统一为 `t_tabs_variants_light/dark.png` |

## 人工验收

- [x] Android 16 真机核对 Line、Tag、Card、禁用态、图标、徽标和内容区组合；覆盖浅色、深色与点击切换
- [x] 本机实际渲染核对 Line、Tag、Card、禁用态、图标和徽标组合
- [x] 与 Figma node `28591:35767` 核对默认视觉和公开示例结构

## 未覆盖项与后续工作

- `TTabsBarSize` 未实现；待尺寸规格和跨端公共契约确认后单独评估。
- Android 16 真机使用 Flutter 3.32.0、Impeller Vulkan 运行；首次恢复调试进程出现黑屏，干净重启后完整渲染和交互正常。
- Golden 场景已扩充为 Line、Tag、Card 三行 light/dark 矩阵，并在 Flutter 3.32 Linux 更新后无更新参数复验通过。
