# 验收记录

## 验证环境

- PR 源分支：`rss1102/feat/progress-design-alignment`
- 本地修复分支：`rss1102/work/pr1092-progress`
- 基线：已合入 `origin/develop@031b1a06`
- 设计：Figma 页面 `24386:5271`，移动端 frame `28600:38672`
- 小程序参考：`Tencent/tdesign-miniprogram@cc2384cc`
- Flutter/Dart：Flutter 3.32.0、Flutter 3.47.0（latest）

## 历史自动化验证（`9ad88559`，修复后必须重跑）

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test test/components/progress/t_progress_test.dart` | 52/52 通过 | Flutter 3.32.0、3.47.0 |
| `flutter test test/progress_demo_test.dart` | 4/4 通过 | Flutter 3.32.0、3.47.0 |
| `flutter test --coverage test/components/progress/t_progress_test.dart` | 通过 | 生产代码 LH/LF 482/487，98.97% |
| `flutter test --update-goldens test/progress_demo_golden_test.dart` 后无更新复验 | 2/2 通过 | 固定 Linux amd64、Flutter 3.32.0，light/dark |
| `flutter analyze --fatal-infos lib test` | 0 issues | Flutter 3.32.0、3.47.0 |
| `dart run tool/generate_example_code.dart --check` | 通过 | 代码面板来自公开 Demo 源码 |
| 三项组件回归清单自测试 | 13/13 通过 | coverage、component、visual manifest |

## 历史人工验收（`9ad88559`，不作为修复后结论）

- [x] 在 Flutter 3.32.0 Web Demo 打开 Progress 页面，按钮进度操作前为 `80%`；点击一次后按钮和 Continue 同步为 `90%`，可访问性 value 同步更新。
- [x] 人工检查固定 Linux light/dark Golden：六类形态、四种状态、圆角、标题文案、状态图标和 CJK 字体均可辨识。

## 本轮 Review 发现并纳入修复

- 设计稿基础区为 6 个实例，原 Demo 实际渲染 9 个；状态区缺少 linear/plump 渐变行。
- `micro` 同时承担只读微型环形与可交互微型按钮，且交互区域只有 16px。
- Theme 的历史 `progressLabelPosition` 可以推翻 linear/plump 的形态语义。
- `primary` 是调色名称而不是任务状态；无障碍标签直接输出内部枚举名称。

## 本轮修复后验证

| 验证 | 结果 | 备注 |
| --- | --- | --- |
| Progress 组件测试 | 53/53 通过 | Flutter 3.32.0、3.47.0 |
| Progress Demo 功能测试 | 6/6 通过 | Flutter 3.32.0、3.47.0；验证单个按钮和微型按钮的真实状态切换，公开矩阵共 20 个实例 |
| 生产代码覆盖率 | 482/485，99.38% | 高于 LH/LF 95% 门禁 |
| 严格 analyze | 0 issues | 组件与 Example；Flutter 3.32.0、3.47.0 |
| Linux Golden | 2/2 通过 | Flutter 3.32.0 amd64；更新后无更新参数精确复跑 |
| 回归清单工具自测 | 13/13 通过 | coverage、component、visual manifest |
| 生成器与站点契约 | 通过 | 示例代码 check；57 份 API 生成仅 Progress 有差异；56 个站点路由契约通过 |
| Web 实际操作 | 通过 | 点击按钮：`开始/0%` → `10%`；点击微型按钮：`30%` → `60%` |

- API 已直接收敛，不提供旧名称兼容：`primary` → `normal`，`micro` 拆为
  `microCircular` / `microButton`，并删除可推翻形态语义的历史 Theme 字段。
- 微型按钮视觉圆环保持 16px，透明命中区扩大到 44×44；按钮和只读环形的语义角色分离。
- `gradient` 覆盖 linear、plump、button，优先级高于 Theme 和状态默认色；环形传入渐变会断言失败。

## 验证边界

- 本轮像素证据是 Flutter 3.32.0 Linux Golden 的仓库基线精确比较；Figma 用于人工核对矩阵、文案、形态和状态，不声称 Figma 渲染与 Flutter 截图逐像素同源。
- 小程序仅作为公开效果与 API 语义参考，Flutter 未机械复制其 props/events。

## Button 设计稿遗漏修复

- 公开 Demo 仅保留一个 `button` 实例：初始显示“开始”，每次点击按 10% 步长增加进度并显示百分比。右侧组件设计稿的 `Continue` 仅说明自定义 `label` 能力，不增加为公开 Demo 实例。
- 品牌色轨道、已完成区的对比渐变、高度与圆角均由 `TProgressVariant.button` 本体绘制；Demo 只传入 `value` / `label` / 交互回调。
- Flutter 3.32.0：组件测试 53/53、Demo 页测试 2/2、完整 Demo 回归 4/4 通过；组件与 Example 定向 analyze 零问题。
- Linux amd64 Flutter 3.32.0：light/dark Golden 按单个 Button 的“开始”初始态与组件本体渐变更新，无更新参数精确复跑 2/2 通过。
