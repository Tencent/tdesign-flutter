# 验收记录

## 验证环境

- 分支：`rss1102/cnb-issue-81/refactor/pull-down-refresh-minimal-api`
- PR：#84
- Flutter：3.32.0（基线）与 3.47.0（本机 latest 代表）；远端 latest 仍以 CI 为准

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| flutter analyze（flutter 3.32.0） | ✅ success | 组件 + Example 本地严格 analyze 零告警 |
| flutter analyze（flutter 3.47.0） | ✅ success | 组件 + Example 本地严格 analyze 零告警 |
| flutter build apk（flutter 3.32.0 / latest） | ⏳ 待新 CI | 本轮未改原生层，仍以新提交 CI 为准 |
| flutter build web（flutter 3.32.0） | ✅ success | 本地 Example Web 构建成功 |
| flutter build web（flutter latest） | ⏳ 待新 CI | 由新提交 CI 复核 |
| flutter test（flutter 3.32.0） | ✅ success | refresh 行为 40 项 + Golden 3 项 + Example 页面 2 项 |
| flutter test（flutter 3.47.0） | ✅ success | refresh 行为 + Golden + Example 页面测试通过 |
| LCOV 覆盖率（refresh 生产源码 LH/LF ≥95%） | ✅ 98.7% | `153/155`，高于 95% 门槛 |
| 逐公开 Demo Golden（固定视口） | ✅ success | 三张 baseline 已更新；复用仓库统一的 1.5% 差异面积容差，规避 macOS/Linux 字体栅格差异 |
| generate_example_code --check | ✅ 手动核对一致 | 示例代码资产与生成器输出逐字一致 |

## 代码补强（已落地，验证依赖 CI / 人工）

- **每个公开 Demo** 均有逐项 Widget 断言（基础 / 自定义提示语 / 超时）+ 固定视口 Golden 测试文件。
- **loadMore**：补真实滚动到底触发、禁用与异常传播测试；按小程序 `scrolltolower` 语义不绘制额外 loading/no-more Footer。
- **controller 所有权**：底层 `EasyRefreshController` 仅由 State 管理/dispose；外部 `TPullDownRefreshController.dispose()` 仅解绑、不释放底层（含 dispose 后行为测试）。
- **状态回调去重**：`onStateChanged` 在状态跳变处去重上报，异步调度避免 build 期同步回调。
- **异常传播**：`onRefresh` / `onLoadMore` 同步抛错 / Future 失败均正常结束（不悬挂）；错误经 `FlutterError.reportError` 上报（不吞掉），避免 easy_refresh 对任务失败无条件 rethrow 产生调用方无法接管的 unhandled async error。`onLoadMore` 已补同步抛错与 Future 失败两组测试。
- **默认值补齐**：`lowerThreshold=50`、`successDuration=500ms` 与小程序一致，并有公开默认值断言。
- **基础 Demo 同构**：大骨架、三组双列骨架、中央刷新提示与小程序公开 base Demo 对应；Web 可点击同一区域触发刷新。
- **timeout 语义**：超时瞬时上报 `timeout` 后立即结束刷新并复位（无专属渲染文案，已在 dartdoc 说明）。
- **英文文案**：`releaseRefresh` 改为 `Release to refresh`。
- **站点 churn 清理**：修复 README 全角逗号回归，移除过时 `easy_refresh` import，补充 child 滚动约束 dartdoc。

## 人工验收

- [x] `TPullDownRefresh` 默认渲染对齐官方（loadingBarHeight=50 / maxBarHeight=80 / 触发阈值=50）
- [x] 下拉 → 松手 → 刷新 → 完成四态文案正确（中文默认与官方一致）
- [x] 受控 `controller.refresh()` / `finishRefresh()`、`onStateChanged` 生效
- [x] `refreshTimeout` 默认 3000ms，超时触发 `onTimeout`；传入 null 关闭超时
- [x] `onLoadMore` / `enableLoadMore` / `lowerThreshold` 触底加载生效，且不渲染额外 Footer UI
- [x] `disabled` 禁用生效

## 未覆盖项与后续工作（如实保留，不臆测通过）

- **真机 / 同尺寸像素对照**：无法自动化，需真机人工核验（未完成）。
- **Golden 与小程序视口逐像素对照**：本 PR 提供固定视口 Golden，但与小程序实际渲染的逐像素对照需真机人工确认（未完成）。
- `TRefreshHeader` 保留为低层 Header（向后兼容），后续可进一步收敛其公开参数。
