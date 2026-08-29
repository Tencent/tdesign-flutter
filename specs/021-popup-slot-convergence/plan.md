# 实施计划

1. 收敛 `TPopupOptions` 的头部、关闭区和重复生命周期 API。
2. 新增无业务行为的 `TPopupHeader` 标准布局组件。
3. 将 builder 的关闭参数收敛为 `VoidCallback`，把取消/确认业务逻辑留在按钮回调中。
4. 调整 Popup 外壳、上层组件和公开 Demo 的组合方式。
5. 同步 dartdoc、生成文档、示例片段和测试。
6. 执行 analyze、组件测试、Demo 测试及生成器校验。
