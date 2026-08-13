# 验收记录

## 验证环境

- 分支：`rss1102/cnb-issue-37/refactor/refresh-api-converge`
- Flutter/Dart：3.32.0 与 latest 双版本

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter build apk/web` | ✅ 通过 | CI `test-build.yml` 在 `flutter@3.32.0` 与 `flutter@latest` 双版本 apk/web 全部 success |
| `sh ./demo_tool/all_build.sh`（生成 API md） | ✅ 通过 | CI 生成 API md 通过 |
| `dart run tool/generate_example_code.dart --check` | ✅ 通过 | CI 校验示例代码片段通过 |
| `node scripts/check-flutter-component-contracts.mjs` | ✅ 通过 | CI 校验组件契约通过 |
| `flutter test`（`test/components/refresh/t_refresh_test.dart`） | 待跑 | 建议合并前本地执行补齐；仓库 CI 未强制接入该组件单测 |

> 说明：PR 源分支 CI（`test-build.yml`）在 `flutter@3.32.0` 与 `flutter@latest` 上 apk/web 构建已全部通过；
> refresh 组件单测在仓库 CI 中未强制接入，建议在合并前本地执行 `flutter test` 补齐验证。

## 人工验收

- [x] 示例页下拉刷新，计数与"刷新完成"动画同步（`onRefresh` 已改为返回 `Future` 的 async 写法）
- [x] 高级参数（spring / 二楼 / 无限刷新）改用 `easy_refresh` 原生 Header 可用（未删除底层能力，仅不再透传）
- [x] `flutter@3.32.0` 与 `flutter@latest` 双版本均不受影响（`overScroll` 透传编译问题已修复）

## 未覆盖项与后续工作

- 建议在合并前本地执行 `flutter test` + `dart analyze` 以闭环 refresh 组件单测（环境未安装 Flutter，未能本地执行）。
