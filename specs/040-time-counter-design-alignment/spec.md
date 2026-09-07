# TimeCounter 设计与交互对齐

## 背景

当前 Flutter TimeCounter 已具备倒计时、正向计时、Controller、三档尺寸和三种视觉形态，但公开 Demo 的场景、时长、布局和部分样式与移动端公开目标不一致；Ticker 每帧重建普通秒级画面，动态更新 `autoStart`、`direction` 和毫秒格式时也存在行为缺口。

## 目标

- 公开 Demo 按“组件类型 / 组件尺寸”展示 6 个基础场景和 5 组三档尺寸场景。
- 使用 `96 * 60 * 1000` 的同源初始时长，修正圆形单位场景和无底色自定义单位视觉。
- 秒级模式只在展示秒值变化时重建；毫秒模式仍按绘制帧重建。保留既有 `onChanged` 毫秒值通知语义，避免引入 breaking change。
- 动态切换 `autoStart`、`direction`、`time` 时保持可预测的重置、开始和暂停行为。
- 生成代码面板包含复现场景所需的完整组件组合和状态计算。

## 行为契约

1. `time` 必须非负；`format` 必须由时间段和单字符非空白分隔符组成。
2. `showMillisecond=true` 且 `format` 未包含毫秒段时追加 `:SSS`；已包含 `S` 段时保持调用者格式。
3. 秒级模式仅在秒值变化或到达终点时重建；毫秒模式按有效绘制帧重建。两种模式均保留运行期间按有效帧触发 `onChanged` 的既有契约。
4. `onFinish` 在一次运行自然到达终点时只触发一次；单纯初始为零或 reset 不重复完成通知，显式从终点 start 可完成一次。
5. `time` 或 `direction` 更新时按新契约重置；`autoStart` 从 false 变 true 开始，从 true 变 false 暂停。
6. Controller 由调用方持有和释放，重复 reset 支持更新目标时长并拒绝负值。

## API 收敛

- 保留 Flutter 已发布的 `direction`、`content` 和 `TTimeCounterController`，它们表达公开 Demo 之外仍成立的 Flutter 用例，不因跨端对齐删除。
- 不新增小程序的字符串 `content`、结构化 change payload 或外部 class API；自定义内容继续使用 Widget builder，回调继续传递毫秒整数。
- 无底色自定义单位场景使用现有 `content` builder 组合，不为单个 Demo 扩张样式参数。
- `start` 与 `resume` 当前运行效果相同，但语义分别表示首次启动和暂停后恢复；作为已发布 Controller 命令保留。
- 既有 `TTimeCounterThemeData` 保存 `variant`、`showMillisecond`、`splitWithUnit`，与当前 Theme 所有权规则存在历史技术债；本次不继续扩张，后续如迁移需单独 breaking 方案。

## 非目标

- 不复制小程序的 `selectComponent` 命令式调用或 CSS external classes。
- 不删除正向计时、Controller、自定义 builder 等 Flutter 扩展能力。
- 不修改通用 ExampleModule API 只为补一个模块说明文案。

## 验收标准

- Flutter 3.32.0 与 latest 下组件、Demo 功能测试及严格 analyze 通过。
- TimeCounter 生产代码行覆盖率不低于 95%。
- Flutter 3.32.0 Linux 浅色/深色 Golden 生成后无更新复验通过。
- Web Demo 实际观察倒计时变化；iOS 模拟器打开受影响代码面板核对内容完整性（Web 端按现有页面契约不提供代码遮罩入口）。
