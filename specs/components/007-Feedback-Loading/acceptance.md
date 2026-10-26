# Loading 验证范围与结论

## 证据边界

以下归纳原记录中保留的检查点，未重新执行验收。标识、SDK或日志未完整绑定的阶段仍无法独立复现，不能将不同阶段拼成当前候选通过；细节由Git历史追溯。

## 历史检查点

| 原记录范围 | 原文可追溯标识与环境 | 有界结论 |
| --- | --- | --- |
| 既有记录 | `ab04f68`、`8e8d68f6`、`33352953431`；Flutter 3.32.0 | 组件与布局：有明确通过记录（限原范围）；Demo 与消费：有明确通过记录（限原范围）；静态检查：有明确通过记录（限原范围）；Golden：有明确通过记录（限原范围）；设备：仅按下文的实际操作与未覆盖范围解释 |

## 最终保留结论

- activity默认色修复阶段：Flutter3.32组件50项、组件/工具合计63项，3.47组件50项；两版本Demo各2项、严格分析零诊断。3.32生产覆盖265/266（99.62%），生成片段检查通过。
- Linux Flutter3.32仅调整activity涉及的明暗两张Golden，检查后无更新参数复跑2/2；不将跨渲染器或模拟器截图视为真机像素证据。必要前后对照追溯[PR #1126](https://github.com/Tencent/tdesign-flutter/pull/1126)。
- 尺寸API收敛和后续颜色修复是不同事项；上表与本节不补造统一候选或重新验证结果。

## 未覆盖范围

- 真机DPR、字体及像素表现尚未实测。
- reverse/pause/delay及attach不属于已交付范围；旧Material颜色回退行号已失效，不再保存为当前覆盖率缺口。

当前待办见 [tasks.md](./tasks.md)；实际执行入口见[贡献规范](../../../CONTRIBUTING.md#组件测试与-ci-回归门禁)。

## 1.0.1 overlay-lifecycle 独立候选（2026-10-23）

- 基线 develop `071efaba0111d868efe0b6a7ce55f6f784069a62`；分支 `rss1102/fix/overlay-lifecycle-1.0.1`，直接基于基线，不依赖其他修复分支。只包含本组源码、已登记回归、生成 API 与 Spec；不纳入后续 API 兼容别名/废弃迁移。
- macOS arm64；Flutter 3.32.0 / 3.47.7（官方 stable ref `abaf9c523780a608bd46686fd5e53740a07077f8` 与已安装高版本一致）。两 SDK 使用独立依赖解析、构建目录，分别离线解析组件包与 Example 的依赖。锁文件指纹保存在[验证数据](evidence/1.0.1-independent.json)。
- 变更的生产源码、测试及生成 API 按排序路径/NUL/文件字节 SHA-256：`bc364580756e64147fee5ba3c17526eba31affd85f790bdea5cca226e6459bca`；其相对基线的二进制 diff SHA-256：`d9f3c2b9a5612dee54ec322249bb4d11040a6e9b146550bdb97586bb675c776b`。双版本相关输入逐文件一致。验收文案和证据文件不纳入自引用指纹。
- 每 SDK：本组 manifest 中 5 个组件文件共 215 项通过；4 个 Example 文件共 19 项通过；三份调度器自测 30 项通过。严格 analyze 零诊断；API 生成并检查 57 份；示例片段 --check 通过。未沿用旧总补丁计数。
- 本组件生产覆盖率：3.32.0 283/287 = 98.61%；3.47.7 283/287 = 98.61%，均通过 95% 门禁。范围来自 manifest coverageTargets，数据按本组功能测试合并运行后分别过滤，不混入 Demo 或其他组件。
- 入口：在 tdesign-component 中分别用各 SDK 执行 `flutter test --no-pub --coverage --reporter expanded <manifest.componentTests>`、`dart run tool/check_component_coverage.dart loading`、`flutter analyze --no-pub --fatal-infos`；调度器自测为 check_component_coverage_test / run_component_regression_test / run_visual_regression_test 三个 test/tool 文件。Example 使用 `flutter test --no-pub --exclude-tags golden --dart-define=TDESIGN_DEMO_TEST_MODULES=false <manifest.exampleTests>`。清单的实际文件集及日志摘要见验证数据。
- API 通过 AST 对比旧公开构造参数、属性、方法签名和默认值；仅 BackTop 允许新增可选 onCompleted。新测试均在原 manifest 登记的文件内，GitHub test-build.yml 调用公共组件和 Example runner，三份调度器自测确认清单一致。
- 最终 Review 通过，无阻塞问题。核对 Message 重复 dismiss 与回调次数、Loading 普通/遮挡后卸载且无后续 show/dismiss 的直接 dispose 断言、Toast 遮挡/State 重建及同 ID 新旧会话隔离。内容 Entry 的 maintainState 未改变，独立哨兵不接收交互；卸载后的微任务复核 owner，过期清理按实例身份隔离。公开签名、原默认值、匿名替换及全局唯一规则保留。
- 原始日志、LCOV、锁文件与独立补丁保存在工作区外层 `artifacts/pr1148-independent/01-overlay-lifecycle/`，与本记录的指纹绑定；摘要随分支保留在验证数据中。未执行设备、正式 Linux Golden 或远端 CI；改动不涉及绘制/布局/Theme/字体，未更新图片基线。历史视觉/设备任务继续按原 tasks 保留，不据本次功能验收核销。未推送、创建 PR 或发布。
