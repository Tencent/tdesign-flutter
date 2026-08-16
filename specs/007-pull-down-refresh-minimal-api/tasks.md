# PullDownRefresh 最小化 API 重构 - 任务清单

## TODO

- [x] 创建 Spec `007-pull-down-refresh-minimal-api`

## DOING

- [ ] 新增 `TPullDownRefreshTexts`（四态文案）
- [ ] 新增 `TPullDownRefreshState` 枚举
- [ ] 新增 `TPullDownRefreshController`
- [ ] 新增顶层组件 `TPullDownRefresh`（封装 EasyRefresh，含超时 / 触底 / 禁用 / 受控）
- [ ] 收敛 `TRefreshHeader` 为内部私有 Header（移除裸透传参数）
- [ ] 导出新增公开类到 `tdesign_flutter.dart`
- [ ] 更新测试 `t_refresh_test.dart`（默认值 / onRefresh / disabled / texts / timeout / loadMore / controller / stateChanged）
- [ ] 示例页改用 `TPullDownRefresh` 并补官方 demo 分组
- [ ] 修正英文 l10n 缺空格
- [ ] 修正站点 README 死链与示例不一致

## DONE

- [ ] `flutter analyze` 组件 + 示例 0 error / 0 warning
- [ ] refresh 相关测试通过
- [ ] `git diff --check` 通过
