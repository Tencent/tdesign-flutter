# PullDownRefresh 最小化 API 重构 - 任务清单

## TODO

- （无）

## DOING

- [x] 创建 Spec `007-pull-down-refresh-minimal-api`
- [x] 新增 `TPullDownRefreshTexts`（四态文案）
- [x] 新增 `TPullDownRefreshState` 枚举
- [x] 新增 `TPullDownRefreshController`
- [x] 新增顶层组件 `TPullDownRefresh`（封装 EasyRefresh，含超时 / 触底 / 禁用 / 受控）
- [x] 保留 `TRefreshHeader` 为低层 Header（向后兼容）
- [x] 导出新增公开类到 `tdesign_flutter.dart`
- [x] 更新测试 `t_refresh_test.dart`（默认值 / onRefresh / disabled / texts / timeout / loadMore / controller / stateChanged）
- [x] 示例页改用 `TPullDownRefresh` 并同步示例代码资产
- [x] 修正英文 l10n 缺空格
- [x] 修正站点 README 死链与示例不一致

## DONE

- [x] `flutter analyze` 组件 + 示例 0 error / 0 warning（flutter 3.32.0 与 latest 均通过）
- [x] `flutter build apk`（3.32.0 与 latest）通过
- [x] `flutter build web`（3.32.0 与 latest）通过
- [x] 示例代码资产与 `generate_example_code` 输出一致
- [x] `git diff --check` 通过
