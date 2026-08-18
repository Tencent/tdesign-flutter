# 验收记录

## 验证环境

- 分支：`rss1102/cnb-issue-81/refactor/pull-down-refresh-minimal-api`
- PR：#84
- Flutter：3.32.0（基线）与 latest 双版本由 CI 验证

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| flutter analyze（flutter 3.32.0） | ✅ success | CI pipeline-1 |
| flutter analyze（flutter latest） | ✅ success | CI pipeline-2 |
| flutter build apk（flutter 3.32.0） | ✅ success | CI pipeline-3 |
| flutter build apk（flutter latest） | ✅ success | CI pipeline-4 |
| flutter build web（flutter 3.32.0） | ✅ success | CI pipeline-5 |
| flutter build web（flutter latest） | ✅ success | CI pipeline-6 |
| flutter test（flutter 3.32.0） | ⏳ 待 CI | 本 PR 新增 `.test-332` 步骤，需 CI 执行确认 |
| flutter test（flutter latest） | ⏳ 待 CI | 本 PR 新增 `.test-latest` 步骤，需 CI 执行确认 |
| LCOV 覆盖率（refresh 生产源码 LH/LF ≥95%） | ⏳ 待 CI | `tool/check_refresh_coverage.py` 作为门禁，需 CI 执行确认达标 |
| 逐公开 Demo Golden（固定视口） | ✅ baseline 已提交并接入 CI | `goldens/*.png` 随仓库提交，`.test` 阶段自动运行 `t_refresh_golden_test.dart` 逐像素比对；后续 CI 确认 |
| generate_example_code --check | ✅ 手动核对一致 | 示例代码资产与生成器输出逐字一致 |

## 代码补强（已落地，验证依赖 CI / 人工）

- **每个公开 Demo** 均有逐项 Widget 断言（基础 / 自定义提示语 / 超时）+ 固定视口 Golden 测试文件。
- **loadMore**：补真实滚动到底触发、加载状态、禁用/结束语义测试；提供可见 footer（`_TPullDownRefreshFooter`）。
- **controller 所有权**：底层 `EasyRefreshController` 仅由 State 管理/dispose；外部 `TPullDownRefreshController.dispose()` 仅解绑、不释放底层（含 dispose 后行为测试）。
- **状态回调去重**：`onStateChanged` 在状态跳变处去重上报，异步调度避免 build 期同步回调。
- **异常传播**：`onRefresh` / `onLoadMore` 同步抛错 / Future 失败均正常结束（不悬挂）；错误经 `FlutterError.reportError` 上报（不吞掉），避免 easy_refresh 对任务失败无条件 rethrow 产生调用方无法接管的 unhandled async error。`onLoadMore` 已补同步抛错与 Future 失败两组测试。
- **footer no-more 文案**：新增 `TPullDownRefreshTexts.noMore`（默认 `/`），触底加载结束态 footer 展示；已补默认值 / 自定义文案测试。
- **timeout 语义**：超时瞬时上报 `timeout` 后立即结束刷新并复位（无专属渲染文案，已在 dartdoc 说明）。
- **英文文案**：`releaseRefresh` 改为 `Release to refresh`。
- **站点 churn 清理**：修复 README 全角逗号回归，移除过时 `easy_refresh` import，补充 child 滚动约束 dartdoc。

## 人工验收

- [x] `TPullDownRefresh` 默认渲染对齐官方（loadingBarHeight=50 / maxBarHeight=80 / 触发阈值=50）
- [x] 下拉 → 松手 → 刷新 → 完成四态文案正确（中文默认与官方一致）
- [x] 受控 `controller.refresh()` / `finishRefresh()`、`onStateChanged` 生效
- [x] `refreshTimeout` 默认 3000ms，超时触发 `onTimeout`；传入 null 关闭超时
- [x] `onLoadMore` / `enableLoadMore` 触底加载生效（含可见 footer）
- [x] `disabled` 禁用生效

## 未覆盖项与后续工作（如实保留，不臆测通过）

- **真机 / 同尺寸像素对照**：无法自动化，需真机人工核验（未完成）。
- **Golden 与小程序视口逐像素对照**：本 PR 提供固定视口 Golden，但与小程序实际渲染的逐像素对照需真机人工确认（未完成）。
- `TRefreshHeader` 保留为低层 Header（向后兼容），后续可进一步收敛其公开参数。
