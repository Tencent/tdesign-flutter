# 实施任务

- [x] DONE 明确需求、历史实现缺口和验收边界
- [x] DONE 建立 Spec 与 Token 映射方案
- [x] DONE 实现站点 Theme Bridge 和 iframe 生命周期同步
- [x] DONE 实现 Flutter Web 消息解析与动态应用
- [x] DONE 补充并登记 Node / Flutter 测试
- [x] DONE 执行构建、测试、analyze 与代表性浏览器验收
- [x] DONE 重整当前 Token 映射、消息握手并重新验证最终源码；上游整页恢复限制见 acceptance

- [x] 独立 css2token 库、声明及说明，站点改为适配器
- [x] 稀疏输入、引用边界和双模式独立测试及浏览器验证

- [x] 将独立转换库迁移为纯 Dart，删除 JS 转换实现
- [x] 官网传 CSS，Example path 依赖转换，保留旧 JSON 消息兼容
- [x] 双版本独立测试、消息集成、analyze、构建与 Light/Dark 浏览器验收

- [x] 收敛官网上游 CSS 来源，移除手写默认表
- [x] 删除转换器字体默认值，由 Example 补齐
- [x] 完整映射和默认值漂移回归、双版本与 Light/Dark 浏览器验收

## Web 监听器优化（2026-10-07）

- [x] 迁移 Web API，移除全局监听状态，解耦 Provider 并释放订阅
- [x] 修复主题偏好初始化与外部更新竞争
- [x] 双版本测试、分析、Web 构建及 Light/Dark 浏览器验收
