# 仓库级测试

| 目录 | 职责 | 运行入口（仓库根目录） |
| --- | --- | --- |
| `scripts/` | 工具脚本的调度、失败处理及 Node 运行环境测试 | `bash scripts/run-tooling-checks.sh runner-tests` |
| `migration_consumer/` | 组件公开入口的独立消费验证及迁移指南示例测试 | `bash scripts/run-tooling-checks.sh migration` |

通用运行脚本保留在根目录 `scripts/`，迁移消费者的专用运行器放在 `migration_consumer/run.dart`；用户迁移示例唯一维护在 [Example](../tdesign-component/example/lib/migration_examples.dart)，验证时复制到临时消费者。GitHub/CNB 复用上述入口，在最低支持版和当前稳定版 Flutter 下执行。

组件自身测试保留在 `tdesign-component/test/`，Example 应用测试保留在 `tdesign-component/example/test/`，站点测试维持原有位置。本目录只收纳仓库级测试，不重复维护组件行为或 Golden。
