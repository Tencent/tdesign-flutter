# 实施方案

1. 在 Button 唯一 resolve 入口合并实例 style 后，将 visualDensity 规范化为 standard；普通和渐变共用最终样式。
2. Input 内置 TextField 使用窄范围 Theme，复制原主题、规范化视觉密度并使用空 Material 输入装饰主题；装饰已由 Input 专属 API 负责，避免 latest 新增的装饰密度入口泄漏。外层错误样式仍使用原上下文。内置 IconButton 显式标准密度。实现不使用 SDK 特判或动态调用。
3. 移除 Table 内部无效 CheckboxTheme，保留选择框约束与 TCheckbox 配置。
4. 在已有、已登记测试文件补充实际几何、交互、其他样式和调用方主题保留回归；修改 Table 依赖内部包装结构的断言为尺寸和选择行为断言。
5. 双版本使用隔离副本分别解析依赖，避免旧 package_config 指向错误 Flutter SDK；不覆盖用户已有工作区与覆盖率产物。

## 风险与验证

- Button 的密度优先级是明确的契约例外，更新 dartdoc 和旧 Spec。
- Input 隔离范围不能扩展到前后缀；最新 SDK 新增的装饰密度入口也必须阻断。
- 先聚焦测试，再 analyze、消费者与 Demo 功能回归、覆盖率和 CI 调度自测；稳定后执行必要 Linux Golden 比对，不自动更新基线。
