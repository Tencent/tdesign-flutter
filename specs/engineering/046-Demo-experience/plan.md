# experience 实施方案

<a id="source-046"></a>
<a id="source-065"></a>
<a id="source-073"></a>

## 实现组织

按 spec.md 中的职责边界组织实现，避免复制另一条配置、状态或验证路径；设计理由与被否决的方案只在 Spec 中维护。

## 影响范围

| 范围 | 实际入口 | 维护要求 |
| --- | --- | --- |
| 实现或验收入口 | [tdesign-component/example/lib](../../../tdesign-component/example/lib) | 与最终方案和候选范围同步维护 |
| 实现或验收入口 | [tdesign-component/tool/generate_example_code.dart](../../../tdesign-component/tool/generate_example_code.dart) | 与最终方案和候选范围同步维护 |

## 实施顺序与验证

1. 先明确最终方案、接口变化与调用方边界；新增设计决策回写 spec.md。
2. 同步实现、公开注释、消费示例和测试；生成物只从源码生成。
3. 围绕该职责的默认、显式配置、状态变化、异常与生命周期做真实验证；按适用范围执行双 SDK、Golden、设备或交付检查。
4. 结果绑定候选、环境和必要证据，更新 acceptance.md；真实剩余工作只在 tasks.md 维护。

本次文档整理不执行上述实现或候选验收，不据旧命令流水推定当前检查通过。

## 入门与导航剩余改动

以 develop `182f8cd956edeee4dfd7ef977176309f051e3c3c` 为独立基线，只提取 #1156 尚未覆盖的 Example、指南同步、预览布局和导航实现。保留现有迁移源与包内副本，历史截图/旧 CI 不搬入现行验收。

新增文档示例测试登记 sharedExampleTests，导航测试纳入站点 test:theme；先跑双版本功能与分析，再在 Linux 3.32.0 比对受影响 Golden。此分支与 #1155 站点转换清理互不依赖。
