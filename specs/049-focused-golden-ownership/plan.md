# 实施方案

## 技术方案

从 `component_test_manifest.dart` 删除指向两个共享拼盘测试的登记，保留各组件独立 Demo 和聚焦视觉 suite。删除无引用的测试文件及基线。BackTop Demo 只更新发生差异的三张基线。用调度器自测核对登记、文件与明暗覆盖，用无更新参数的 Linux 视觉 runner 验证。

## 影响范围

| 范围 | 影响 |
| --- | --- |
| 测试 | 两个共享矩阵测试及四张基线删除；BackTop Demo 三张基线更新 |
| 登记 | `tool/component_test_manifest.dart` 移除重复 suite |
| 组件 / Demo | 源码与公开行为不变 |

## API 变化

无；不构成 breaking change，也无用户可感知的更新日志条目。

## 风险与取舍

不再用同一张图同时观察多个组件，但各组件独立 Demo Golden 仍在 CI 中执行。跨主题集成测试保留，因为其对比目的不同。

## 验证策略

- 调度器自测与清单引用检查。
- Linux Flutter 3.32.0 严格视觉回归；更新 BackTop 后不带更新参数复跑。
- `git diff --check`、Dart 格式和 analyze。
