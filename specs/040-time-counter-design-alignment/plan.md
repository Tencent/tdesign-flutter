# 实施方案

1. 冻结最新 Flutter develop、小程序公开 CountDown Demo/源码和 Figma CountDown 组件节点。
2. 增加由 TDesign 颜色、字体和圆角 token 驱动的 `highlight` 标准形态，保留无匹配 token 的组件专属几何设计值。
3. 以格式化后的可见值统一展示与更新精度，修正回调频率、动态参数更新、格式校验和 Controller 命令边界。
4. 让 `autoStart` 仅负责首次启动，运行期由 Controller 命令持有唯一控制权；配置更新保持既有运行状态。
5. 保留 `TTimeCounter` 通用命名并统一内部注释、变量和 Demo 文案，重写 11 个公开 Demo 条目及其完整生成代码，关闭内部单元测试模块。
6. 补充组件根因测试、token 覆盖测试、Demo 结构/动态测试，并登记统一回归清单。
7. 功能确认后在 Flutter 3.32.0 Linux 更新并复验浅色/深色 Golden，再执行覆盖率、双版本 analyze 和运行验收。

## 风险控制

- 本次按用户确认不保留历史兼容：API 删除与默认语义变化以 breaking change 交付，并在 PR 中写清迁移方式。
- 公开 Demo 的正向计时与 Controller 场景移入组件测试，不等于删除 API。
- `autoStart` 的动态启停和 reset 后自动重启属于旧的重叠状态源；迁移为 Controller 的 `start` / `pause` 显式命令。
- 固定 Linux Flutter 3.32.0 生成 Golden，latest 不写回像素基线。
- Flutter latest 自动改写的分析配置和依赖噪声在验证后恢复。
