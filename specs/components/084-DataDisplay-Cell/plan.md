# Cell 实施方案

- 实现入口：`tdesign-component/lib/src/components/cell/t_cell_group.dart`。共用内容构建逻辑，非滚动路径直接返回；滚动路径按实际最大高度选择 Expanded 或 shrinkWrap。
- 回归入口：`tdesign-component/test/components/cell/t_cell_test.dart`。覆盖固有尺寸、约束异常及真实拖动，沿用现有 cell manifest 登记。
- 公开注释与生成 API 维护有界/无界行为说明，不承诺任意内容均支持固有尺寸。无公开参数或主题变更。
- 双 SDK 执行聚焦组件测试、严格分析和覆盖率；对照结果绑定具体代码候选。文档更新不刷新既有测试身份，设备与视觉证据单独说明。
