# Footer 验证范围与结论

## 本次范围

2026-10-20 原记录整理；未重跑组件、Golden、设备或远端CI。以下结论仅限原候选与范围。

## 已有验证结论

| 原记录范围 | 原文可追溯标识与环境 | 有界结论 |
| --- | --- | --- |
| 既有记录 | `2ed620b9`、`cc2384cc5`；Flutter 3.32.0 / 3.47.0 | 组件与布局：有明确通过记录（限原范围）；Demo 与消费：有明确通过记录（限原范围）；静态检查：有明确通过记录（限原范围）；Golden：有明确通过记录（限原范围） |

各标识可能对应不同阶段，不能合成一次完整验证；候选或日志缺失时仍需复核。

## 验证范围与未覆盖项

原验收未进一步列出未覆盖项；本次未补做新候选验证，不能从历史通过记录外推全部状态、平台或设备。

## 必要证据与追溯

未绑定唯一候选的结果不作为当前通过证明；旧命令与流水由Git历史追溯。

当前待办见 [tasks.md](./tasks.md)；实际执行入口见[贡献规范](../../../CONTRIBUTING.md#组件测试与-ci-回归门禁)。清理不关闭未完成项。

## 2026-10-26：1.0.x 链接布局补丁本地验收

- 工作目录为 `pr1148-patch-local`，基线 `8bbbcd21` 叠加原有未提交改动；本次只修改 Footer 实现、既有组件测试、由源码生成的 Footer API 文档和本 Spec。
- Footer 生产基线与本次拉取的 `origin/develop@304bf7d6` 一致；未合并或重写整个 patch 分支。
- 保留公开签名、默认 token、品牌与版权组合，不新增兼容入口、平台或版本判断。
- 删除链接 IntrinsicWidth，复用标准 RenderWrap 的排列与换行，仅绘制同行相邻链接之间的分隔线。

| 环境与范围 | 本地结果 |
| --- | --- |
| Flutter 3.47.7 macOS 组件测试 | 22 项通过；Footer 生产覆盖率 81/81 = 100% |
| Flutter 3.32.0 Linux 组件测试 | 22 项通过；Footer 生产覆盖率 81/81 = 100% |
| 双版本组件库和 example 严格分析 | `flutter analyze --no-pub --fatal-infos` 无诊断 |
| 双版本公开 Demo | `test/footer/footer_demo_test.dart` 各 3 项通过 |
| Flutter 3.32.0 Linux 明暗 Golden | 既有两张基线通过，零基线更新 |
| Flutter 3.47.7 实际默认字体 Web | 375 宽度单/双链接横排；160/80 宽度换行后无行尾或独占一行的分隔线 |
| 旧 develop 负向对照 | 相同的约束感知链接测试因 LayoutBuilder 不支持固有尺寸测量而失败，补丁后通过 |

视觉命令为 `flutter test --no-pub --dart-define=TDESIGN_DEMO_TEST_MODULES=false test/footer/footer_demo_golden_test.dart`。第一次独立运行漏掉仓库统一的隐藏测试模块参数，图片从 812 增高到 917；修正参数后原基线直接通过，没有更新图片消除失败。

本地证据保存在本次任务的 `artifacts/pr1113-review-20261026/`，包括组件、Demo、分析、Golden、负向对照日志和 `patch-web-before-after.png`。Linux 使用独立快照与已缓存的 Flutter 3.32.0 镜像；开发工具依赖以与本机相同的 `6bcf065e` 工具源作临时 path override，规避容器 Git 缓存硬链接故障。该 override 不在交付目录中。

现有集中式清单已登记 Footer 组件、Demo 和 Golden；本次扩充同一组件测试文件，无需改调度清单。未覆盖远端最终 head CI、真机、Safari 或 Wasm；该本地验收阶段未推送或修改 PR，后续同步交付见下节。

最终文件指纹（SHA-256）：

```text
t_footer.dart: 2297be10146f972e0c10fb1b76dab2941c78f9aa782551c28f15274fd8728c64
t_footer_test.dart: 733d433124333f904cad34dd208b8872788beaa066f21605aae296081a62f50e
```

## PR #1113 同步交付与三方渲染

原 PR `52c32c2b` 与 `develop@304bf7d6` 同步后，仅交付 Footer 补丁；移除 develop 已淘汰的旧 Spec / Golden 路径，保留现行目录、品牌与版权组合及原有视觉基线。

对比图来自同一个 Flutter 3.47.7 Web 页面，以等宽三栏分别使用 develop、原 PR 和最终修复的 Footer 实现；共用当前 TLink / Theme、默认字体与容器约束，用于隔离比较 Footer 布局差异，不代表三个历史部署环境的全量运行。场景为 375 宽度单链接、375 宽度双链接、80 宽度双链接及品牌与版权组合。

三栏在一张画布中统一缩放，各场景外部容器宽高相同、顶部对齐；浅灰边框仅用于标出测试容器边界，不属于组件样式。避免 GitHub 表格分别缩放图片、垂直居中导致的比较偏差。

历史三方对照截图已按 Spec 图片规则清理，保留上述候选、环境、场景和观察范围。后续视觉回归引用 [Footer Golden 测试](../../../tdesign-component/example/test/footer/footer_demo_golden_test.dart)及[基线目录](../../../tdesign-component/example/test/footer/goldens/)；现有基线不代表本次重跑或覆盖全部 Web 场景。

推送前在独立交付目录复验双版本组件、Demo、严格分析和 Linux 明暗 Golden；本地结果不等同于推送后最终提交的远端 CI。
