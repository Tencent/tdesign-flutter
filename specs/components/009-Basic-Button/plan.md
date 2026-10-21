# Button 实施方案

<a id="record-009-contract-alignment"></a>
<a id="record-037-disabled-theme-alignment"></a>

## 实现组织

普通与渐变共用实时 ButtonStyle 状态解析；尺寸是设计下限，保留内容与字体缩放撑大的能力。

实例 style 负责完整样式，组件 Theme 保留图文间距、分档图标和渐变；Material 主题与 visualDensity 不反向控制内置外观。

## 影响范围

| 范围 | 实际入口 | 维护要求 |
| --- | --- | --- |
| 生产实现 | [tdesign-component/lib/src/components/button](../../../tdesign-component/lib/src/components/button) | 按 spec.md 的最终方案维护配置、状态和布局 |
| 测试与消费者 | [tdesign-component/test/components/button](../../../tdesign-component/test/components/button) | 对默认、覆盖、重建和直接组合消费者补充真实断言 |

## 实施顺序与验证

1. 先明确最终方案、接口变化与调用方边界；新增设计决策回写 spec.md。
2. 同步实现、公开注释、消费示例和测试；生成物只从源码生成。
3. 围绕该职责的默认、显式配置、状态变化、异常与生命周期做真实验证；按适用范围执行双 SDK、Golden、设备或交付检查。
4. 结果绑定候选、环境和必要证据，更新 acceptance.md；真实剩余工作只在 tasks.md 维护。

本次文档整理不执行上述实现或候选验收，不据旧命令流水推定当前检查通过。

<a id="source-082"></a>

## 082 · 文字默认值实现

在child内部Builder读取原生按钮主题恢复或渐变Material之后的实际文字样式，再进入既有scope，不复制状态解析。全局文字实现不变；同步公开注释、生成API、主题指南及迁移说明，双版本功能/覆盖率/分析后在Linux3.32精确比较原基线，不能以另一组件或混合分支结果替代。


### API 格式与消费 Demo 补充复核

TText 的使用规则保留在构造方法 dartdoc 和参数表，API 入口保持统一的表格布局，不修改生成器依赖或放宽展示格式门禁。补充 BackTop、Drawer、Indexes、Popup、Form 五类消费 Demo：在同一 Linux Flutter3.32.0 环境，仅回退 Button/NavBar 实现作为修改前对照，记录全部既有截图的前后与基线差异；先执行双版本非视觉门禁，再进行无更新参数的 Golden 比较。审查确认并获授权后仅更新对应 Golden，立即用相同环境和默认精确比较器复跑；Spec 不复制截图或逐图验证流水，图片由 Golden 维护，必要前后对比放在 PR。
