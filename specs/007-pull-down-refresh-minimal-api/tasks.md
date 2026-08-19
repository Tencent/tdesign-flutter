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
- [x] 补齐官方「自定义提示语」「刷新超时」两组 demo（对应 mobile-vue loading-texts / timeout），同步 `example/assets/code/` 与站点 README
- [x] 补强 refresh 目录单元测试（controller 全方法、状态回调、同步回调、loadingTheme、控制器切换绑定）
- [x] 修正英文 l10n 缺空格
- [x] 修正站点 README 死链与示例不一致
- [x] 修订 Spec/plan/acceptance：`refreshTimeout` 默认 3000ms、传 null 关闭；controller 所有权；footer；Demo 矩阵标注；验收记录与真实结果一致
- [x] 补真实 `flutter test` 与 LCOV 覆盖率门禁（CI 最小改动，仅增加测试+覆盖率步骤）
- [x] 每个公开 Demo 补逐项 Widget 断言与 Golden/固定视口证据
- [x] controller 所有权修复：底层 EasyRefreshController 仅由 State 管理/dispose，外部 controller 不双重释放
- [x] loadMore 按 `scrolltolower` 语义补真实滚动到底/禁用/异常测试，不绘制额外 Footer UI
- [x] P2 最小修复：状态回调去重与避免 build 期同步回调、异常传播、timeout 语义、英文 `Release to refresh`、站点 churn 清理、child 滚动约束 dartdoc
- [x] P1：`onLoadMore` 异常传播（同步抛错 / Future 失败均不悬挂、经 `FlutterError.reportError` 上报）+ `onLoadMore` dartdoc 说明 + 测试
- [x] 跨端复核：移除小程序未定义的 footer no-more 文案，补 `lowerThreshold` / `successDuration` 默认值
- [x] 基础 Demo 按小程序公开 base 页面重做骨架结构，并为 Web 增加同位置点击刷新入口
- [x] P2-3：生成并提交 Golden baseline（`goldens/*.png`），接入 CI `.test` 阶段自动逐像素比对

## DONE

- [x] `flutter analyze` 组件 + 示例 0 error / 0 warning（flutter 3.32.0 与 latest 均通过）
- [x] `flutter test`（3.32.0 与 latest）通过
- [x] refresh 生产源码 LCOV LH/LF ≥95%
- [x] `flutter build apk`（3.32.0 与 latest）通过
- [x] `flutter build web`（3.32.0 与 latest）通过
- [x] 示例代码资产与 `generate_example_code` 输出一致
- [x] `git diff --check` 通过
- [ ] 真机 / 同尺寸像素对照（人工项，未完成）
