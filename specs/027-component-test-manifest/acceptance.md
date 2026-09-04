# 验收记录

## 行为结论

- 32 个组件、76 个组件测试文件、17 个 Demo 功能测试文件和 33 个视觉 suite 由同一份 Dart manifest 维护。
- GitHub 与 CNB 不再保存 Demo 测试文件长列表，统一调用 `run_example_regression.dart`。
- 组件回归、覆盖率与视觉回归 runner 的外部命令和失败汇总语义保持不变。

## 验证结果

- Flutter 3.32.0：`flutter analyze --no-pub --fatal-infos`，0 error / 0 warning。
- manifest 与 runner 工具测试：13 tests passed。
- 公共 Demo 功能回归：96 tests passed。
- `git diff --check` 通过。

## 更新日志

该改动只重构内部测试基础设施，无用户可感知变化，不需要纳入 Changelog。
