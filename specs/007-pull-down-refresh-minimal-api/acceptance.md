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
| generate_example_code --check | ✅ 手动核对一致 | 示例代码资产与生成器输出逐字一致 |

## 人工验收

- [x] `TPullDownRefresh` 默认渲染对齐官方（loadingBarHeight=50 / maxBarHeight=80 / 触发阈值=50）
- [x] 下拉 → 松手 → 刷新 → 完成四态文案正确（中文默认与官方一致）
- [x] 受控 `controller.refresh()` / `finishRefresh()`、`onStateChanged` 生效
- [x] `refreshTimeout` + `onTimeout` 生效
- [x] `onLoadMore` / `enableLoadMore` 触底加载生效
- [x] `disabled` 禁用生效

## 未覆盖项与后续工作

- Widget 测试（t_refresh_test.dart）已补充，但 CNB CI 不执行 `flutter test`；GitHub 侧 test-build CI 会运行，若失败需在 PR 中迭代。
- `TRefreshHeader` 保留为低层 Header（向后兼容），后续可进一步收敛其公开参数。
