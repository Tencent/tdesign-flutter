# PullDownRefresh 验证范围与结论

## 本次范围

2026-10-20 原记录整理；未重跑组件、Golden、设备或远端CI。以下结论仅限原候选与范围。

## 已有验证结论

| 原记录范围 | 原文可追溯标识与环境 | 有界结论 |
| --- | --- | --- |
| 既有记录 | 未绑定唯一完整候选 SHA；Flutter 3.32.0 | 组件与布局：有明确通过记录（限原范围）；Demo 与消费：有明确通过记录（限原范围）；静态检查：有明确通过记录（限原范围）；Golden：有明确通过记录（限原范围）；设备：仅按下文的实际操作与未覆盖范围解释 |

各标识可能对应不同阶段，不能合成一次完整验证；候选或日志缺失时仍需复核。

## 验证范围与未覆盖项

- `TPullDownRefresh` 默认渲染对齐官方（loadingBarHeight=50 / maxBarHeight=80 / 触发阈值=50）
- 下拉 → 松手 → 刷新 → 完成四态文案正确（中文默认与官方一致）
- 下拉过程中刷新头与页面内容同步下移，释放后回弹
- 外部 `controller.refresh()`、`onStateChanged` 生效；`await controller.refresh()` 在成功、失败或超时后完成，不代表业务一定成功
- `refreshTimeout` 默认 3000ms，超时通过 `onStateChanged(timeout)` 上报；传入 null 关闭超时
- `onLoadMore` 非空时按 `lowerThreshold` 自动启用触底加载，且不渲染额外 Footer UI
- `onRefresh == null` 时禁用下拉刷新并保留滚动
- 暗色刷新文案默认使用 `textDisabledColor`，显式
  `TLoadingThemeData.textColor` 可覆盖；独立 `TLoading` 默认值不变

## 必要证据与追溯

未绑定唯一候选的结果不作为当前通过证明；旧命令与流水由Git历史追溯。

当前待办见 [tasks.md](./tasks.md)；实际执行入口见[贡献规范](../../../CONTRIBUTING.md#组件测试与-ci-回归门禁)。清理不关闭未完成项。

## 1.0.1 controller-binding 独立候选（2026-10-23）

- 基线 develop `071efaba0111d868efe0b6a7ce55f6f784069a62`；分支 `rss1102/fix/controller-binding-1.0.1`，直接基于基线，不依赖其他修复分支。只包含本组源码、已登记回归、生成 API 与 Spec；不纳入后续 API 兼容别名/废弃迁移。
- macOS arm64；Flutter 3.32.0 / 3.47.7（官方 stable ref `abaf9c523780a608bd46686fd5e53740a07077f8` 与已安装高版本一致）。两 SDK 使用独立依赖解析、构建目录，分别离线解析组件包与 Example 的依赖。锁文件指纹保存在[验证数据](../001-Feedback-DropdownMenu/evidence/1.0.1-independent.json)。
- 变更的生产源码、测试及生成 API 按排序路径/NUL/文件字节 SHA-256：`cbbf663ebc674673faa77aafc8868e5066aecdadee381535284a5940a04454dd`；其相对基线的二进制 diff SHA-256：`ea96731c464a99f712e3c8935fc6af1fcdf7b04eae8b4f1277e1b31df1ac4b11`。双版本相关输入逐文件一致。验收文案和证据文件不纳入自引用指纹。
- 每 SDK：本组 manifest 中 8 个组件文件共 286 项通过；6 个 Example 文件共 37 项通过；三份调度器自测 30 项通过。严格 analyze 零诊断；API 生成并检查 57 份；示例片段 --check 通过。未沿用旧总补丁计数。
- 本组件生产覆盖率：3.32.0 215/224 = 95.98%；3.47.7 215/224 = 95.98%，均通过 95% 门禁。范围来自 manifest coverageTargets，数据按本组功能测试合并运行后分别过滤，不混入 Demo 或其他组件。
- 入口：在 tdesign-component 中分别用各 SDK 执行 `flutter test --no-pub --coverage --reporter expanded <manifest.componentTests>`、`dart run tool/check_component_coverage.dart refresh`、`flutter analyze --no-pub --fatal-infos`；调度器自测为 check_component_coverage_test / run_component_regression_test / run_visual_regression_test 三个 test/tool 文件。Example 使用 `flutter test --no-pub --exclude-tags golden --dart-define=TDESIGN_DEMO_TEST_MODULES=false <manifest.exampleTests>`。清单的实际文件集及日志摘要见验证数据。
- API 通过 AST 对比旧公开构造参数、属性、方法签名和默认值；仅 BackTop 允许新增可选 onCompleted。新测试均在原 manifest 登记的文件内，GitHub test-build.yml 调用公共组件和 Example runner，三份调度器自测确认清单一致。
- 最终 Review 通过，无阻塞问题。核对 Form/SwipeCell 先校验新绑定再释放旧绑定，替换失败及重复无效替换后保留实际绑定，卸载按实际对象清理。Swiper 保留 StateError 和单目标限制，Refresh/Dropdown 保留后绑定覆盖规则，旧 owner 不清理新 owner。未新增绑定限制或改变异常类型；既有 bind/unbind 签名保留。
- 原始日志、LCOV、锁文件与独立补丁保存在工作区外层 `artifacts/pr1148-independent/02-controller-binding/`，与本记录的指纹绑定；摘要随分支保留在验证数据中。未执行设备、正式 Linux Golden 或远端 CI；改动不涉及绘制/布局/Theme/字体，未更新图片基线。历史视觉/设备任务继续按原 tasks 保留，不据本次功能验收核销。未推送、创建 PR 或发布。
