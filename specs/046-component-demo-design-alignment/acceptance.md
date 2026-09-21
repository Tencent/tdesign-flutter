# 验收记录

## 基线

- Git：`origin/develop@47e070a70bafbb99ea5722cf59c03ab5bf61ae3f`
- 受影响源码与测试 binary diff 指纹：`b9a1a63f686ba0504d82fdb5aed54fa447587d245e2de0405dd66ccbcbc3439c`
- Golden：Linux amd64、Flutter 3.32.0、仓库固定字体与视口
- Latest：Flutter 3.47.0 clean snapshot
- 设计比较：统一从首个公开标题裁切，省略状态栏、Figma 头部与底部测试区域

## 自动化结果

| 门禁 | 结果 |
| --- | --- |
| Flutter 3.32.0 component 全量回归 | 通过 |
| Flutter 3.32.0 Example 全量回归 | 262/262 通过 |
| Flutter 3.47.0 component 全量回归 | 通过 |
| Flutter 3.47.0 Example 全量回归 | 262/262 通过 |
| Flutter 3.32.0 / latest 严格 analyze | 0 issues |
| 示例代码生成与 `--check` | 通过 |
| Demo 结构审计 | 60 个入口、372 个 ExampleItem、0 orphan |
| Linux Flutter 3.32.0 全量 Golden | 更新后移除更新参数，全部视觉套件通过 |
| Progress 生产源码覆盖率 | 524/527，99.43% |
| Checkbox 生产源码覆盖率 | 393/410，95.85% |
| Swiper 生产源码覆盖率 | 478/495，96.57% |
| Popover 生产源码覆盖率 | 630/642，98.13% |

## Golden 差异归因

- 最终提交包含 201 份逐文件三栏证据：179 个修改、12 个新增、10 个删除；
  `manifest.tsv` 无缺项、无像素完全相同却被提交为修改的基线，其中 103 个比较的
  最大 RGBA 通道差为 1。
- 首轮无更新参数比较共出现 119 张既有基线差异。
- 93 张仅为共享灰阶 Token 的单通道 1 级差异。
- 其余 26 张来自 Progress 最终设计重构，以及 `TCell.note` 自然宽度对 Calendar / SwipeCell 的预期布局影响。
- Cascader 的旧场景基线被按最终公开 Demo 契约删除，并新增最终场景基线；新增和删除项均保留在三栏证据与 manifest 中。
- 未发现无法归因的 Golden 漂移。

## 模拟器交互

- Progress 按钮实际点击后推进到 80%。
- Indexes 抽屉位于状态栏安全区下方，文字完整加载。
- DateTimePicker 默认值、选中行居中与弹层安全区正确。
- Swiper 控制按钮实际切页，缩放与淡化场景露出两侧卡片。
- Popover top-left / bottom-right 实际打开，气泡边缘对齐触发按钮，箭头保持约 12px 内边距。
- Popover 已打开时单击另一触发器，旧气泡关闭且新气泡在同一次点击中打开；单击当前触发器只关闭，拖动滚动不误判为外部点击。
- ImageViewer 可打开并返回关闭；拖拽和双指缩放由 25/25 指针级 Widget 测试覆盖，桌面自动化层未注入多点触控。

## 结论

当前源码不存在未归因的组件、Demo、Token 或 Golden 风险。公开 API 的 breaking 变化已在 Spec、dartdoc、生成 API 和测试中同步；本地证据满足创建 PR 条件，远端 CI 仍须以 PR 最终 head 为准。
