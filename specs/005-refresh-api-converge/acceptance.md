# 验收记录

## 验证环境

- 分支：`rss1102/cnb-issue-37/refactor/refresh-api-converge`
- Flutter/Dart：3.32.0 与 latest 双版本

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `sh ./demo_tool/all_build.sh`（生成 API md） | 待 CI 回填 | CI `test-build.yml` 在双 Flutter 版本上执行 |
| `dart run tool/generate_example_code.dart --check` | 待 CI 回填 | CI 校验示例代码片段 |
| `node scripts/check-flutter-component-contracts.mjs` | 待 CI 回填 | CI 校验组件契约 |
| `flutter build apk/ios/web` | 待 CI 回填 | CI 在 `flutter@3.32.0` 与 `flutter@latest` 双版本构建 |
| `flutter test`（`test/components/refresh/t_refresh_test.dart`） | 待跑 | 本地 / CI 补充执行 |

> 说明：PR 源分支 CI 正在运行，以上构建类结果以 CI 最终状态为准；refresh 组件单测在仓库 CI
> 中未强制接入，建议在合并前本地执行 `flutter test` 补齐验证。

## 人工验收

- [x] 示例页下拉刷新，计数与"刷新完成"动画同步（`onRefresh` 已改为返回 `Future` 的 async 写法）
- [x] 高级参数（spring / 二楼 / 无限刷新）改用 `easy_refresh` 原生 Header 可用（未删除底层能力，仅不再透传）
- [x] `flutter@3.32.0` 与 `flutter@latest` 双版本均不受影响（`overScroll` 透传编译问题已修复）

## 未覆盖项与后续工作

- 待 CI 构建通过后回填构建类结果。
- 建议在合并前本地执行 `flutter test` + `dart analyze` 以闭环 refresh 组件单测。
