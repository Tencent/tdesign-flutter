# 实施方案

1. 冻结 Flutter develop、小程序公开 CountDown Demo/源码和移动端相邻设计节点候选。
2. 修正计时更新频率、终点幂等、动态参数更新、格式校验和 Controller 边界。
3. 重写 11 个公开 Demo 条目及其完整生成代码。
4. 补充组件根因测试、Demo 结构/动态测试，并登记统一回归清单。
5. 功能确认后生成浅色/深色 Golden，再执行覆盖率、双版本 analyze 和 Web 操作验收。
6. 单提交、独立 PR，并只更新 GitHub Issue #1027 正文中的 TimeCounter 项。

## 风险控制

- 不删除已发布能力；新增校验只拒绝原本无法可靠解析的输入，不构成有效调用迁移。
- 公开 Demo 的正向计时与 Controller 场景移入组件测试，不等于删除 API。
- 固定 Linux Flutter 3.32.0 生成 Golden，latest 不写回像素基线。
- Flutter latest 自动改写的分析配置和依赖噪声在验证后恢复。
