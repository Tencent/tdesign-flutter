# Drawer 实施方案

## 实现组织

通过组件公开路由与内容组合维护一致行为，状态仍由调用方管理。

不把页面业务结构或平台模板参数带入组件 Theme。

## 影响范围

| 范围 | 实际入口 | 维护要求 |
| --- | --- | --- |
| 生产实现 | [tdesign-component/lib/src/components/drawer](../../../tdesign-component/lib/src/components/drawer) | 按 spec.md 的最终方案维护配置、状态和布局 |
| 测试与消费者 | [tdesign-component/test/components/drawer](../../../tdesign-component/test/components/drawer) | 对默认、覆盖、重建和直接组合消费者补充真实断言 |

## 实施顺序与验证

1. 先明确最终方案、接口变化与调用方边界；新增设计决策回写 spec.md。
2. 同步实现、公开注释、消费示例和测试；生成物只从源码生成。
3. 围绕该职责的默认、显式配置、状态变化、异常与生命周期做真实验证；按适用范围执行双 SDK、Golden、设备或交付检查。
4. 结果绑定候选、环境和必要证据，更新 acceptance.md；真实剩余工作只在 tasks.md 维护。

此前文档整理不代表实现验收；本轮文字槽实现与本地验证见后文和 acceptance.md，不据旧命令流水推定当前检查通过。

## 文案槽一致性

菜单项 content 是正文替换槽，整个子树的 Text/TText 接入与内置 title 相同的默认字体和颜色；Row、Padding、Builder 不切断传递。实例显式字段及内容内部更近的 TTextThemeData 优先，TText 全局隔离保持。自定义内容仍自行布局，不强加内置 title 的单行/省略约束；完整 Drawer.child、footer、icon 不新增文字默认值。

补充直接/布局包装、明暗/缩放、显式与局部主题、段落与受限布局回归；双 SDK 组件/覆盖率及分析，Linux 3.32 同环境前后截图和既有 Golden 比较。基线变更按已确认的视觉范围独立审阅，交付状态不作为长期实施约束。
