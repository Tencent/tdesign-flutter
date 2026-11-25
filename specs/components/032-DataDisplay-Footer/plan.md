# Footer 实施方案

## 实现组织

使用可选内容及链接组合表达页脚，组件只管理布局、分隔与语义样式。

明确品牌内容可以与说明共存，避免互斥开关抹掉有效组合。

## 影响范围

| 范围 | 实际入口 | 维护要求 |
| --- | --- | --- |
| 生产实现 | [tdesign-component/lib/src/components/footer](../../../tdesign-component/lib/src/components/footer) | 按 spec.md 的最终方案维护配置、状态和布局 |
| 测试与消费者 | [tdesign-component/test/components/footer](../../../tdesign-component/test/components/footer) | 对默认、覆盖、重建和直接组合消费者补充真实断言 |

## 实施顺序与验证

1. 先明确最终方案、接口变化与调用方边界；新增设计决策回写 spec.md。
2. 同步实现、公开注释、消费示例和测试；生成物只从源码生成。
3. 围绕该职责的默认、显式配置、状态变化、异常与生命周期做真实验证；按适用范围执行双 SDK、Golden、设备或交付检查。
4. 结果绑定候选、环境和必要证据，更新 acceptance.md；真实剩余工作只在 tasks.md 维护。

本次文档整理不执行上述实现或候选验收，不据旧命令流水推定当前检查通过。

## 1.0.x 链接布局补丁

在现有 Footer 内增加私有 Wrap 绘制实现，标准 Wrap 负责链接换行；绘制阶段只给同行相邻链接补分隔线。删除链接 IntrinsicWidth，保留当前品牌与版权组合。组件测试覆盖宽窄容器、分隔线绘制、RTL、动态更新、点击及 spacing/color token；实际默认字体 Web 页面另行核对，避免固定测试字体产生假阴性。
