# configuration-contracts 实施方案

<a id="source-048"></a>
<a id="source-051"></a>
<a id="source-055"></a>
<a id="source-078"></a>
<a id="source-053"></a>
<a id="source-054"></a>
<a id="source-047"></a>
<a id="source-059"></a>
<a id="source-060"></a>
<a id="source-077"></a>
<a id="source-079"></a>

## 实现组织

按 spec.md 中的职责边界组织实现，避免复制另一条配置、状态或验证路径；设计理由与被否决的方案只在 Spec 中维护。

## 影响范围

| 范围 | 实际入口 | 维护要求 |
| --- | --- | --- |
| 实现或验收入口 | [tdesign-component/lib/src/theme](../../../tdesign-component/lib/src/theme) | 与最终方案和候选范围同步维护 |
| 实现或验收入口 | [tdesign-component/lib/src/components](../../../tdesign-component/lib/src/components) | 与最终方案和候选范围同步维护 |
| 验证入口 | [组件功能回归](../../../tdesign-component/tool/run_component_regression.dart)、[Golden 回归](../../../tdesign-component/tool/run_visual_regression.dart) | 按受影响契约运行；历史审计数据不代替当前候选验证 |

## 实施顺序与验证

1. 先明确最终方案、接口变化与调用方边界；新增设计决策回写 spec.md。
2. 同步实现、公开注释、消费示例和测试；生成物只从源码生成。
3. 围绕该职责的默认、显式配置、状态变化、异常与生命周期做真实验证；按适用范围执行双 SDK、Golden、设备或交付检查。
4. 结果绑定候选、环境和必要证据，更新 acceptance.md；真实剩余工作只在 tasks.md 维护。

历史文档收敛记录不替代实现验收；本轮文字槽范围、候选与结果见 acceptance.md。

## 文字槽实现与验证

复用既有 TTextStyleScope，仅传递已经存在的组件默认字体。对原生段落 reset/merge 边界分别补回归；Popover 在内容文字作用域内依据实际 Text 配置测量。测试登记沿用组件清单。双版本先功能/覆盖率与生成检查，再以相同 Linux 字体环境比较前后截图及旧基线。截图独立用于审阅，不放入 Spec。

本轮复用现有组件回归入口，将相同测试辅助函数提取到共享 helper；TabBar 自定义菜单专项 Golden 登记到现有视觉套件。先双版本功能与严格分析，再检查 Linux 新场景实际图，只生成新的8张基线并无更新复验；保留全部已有 PNG。验收只记录最终候选与未覆盖范围，不重复分支和推送流水。
