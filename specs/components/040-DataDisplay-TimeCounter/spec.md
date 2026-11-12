# TimeCounter 设计说明

## 背景与目标

以下保留设计形成时的问题与依据；已修复的问题不表示当前代码仍有同一缺陷。

格式、毫秒更新、生命周期和 Controller 状态存在重复来源。

当前 Flutter TimeCounter 已具备倒计时、正向计时、Controller 和三档尺寸，但公开 Demo 使用 `content` 手工模拟设计稿中的高亮形态，组件缺少对应标准能力；计时精度、回调频率、Controller 命令和 Theme 状态源也存在重叠。

## 范围与非目标

### 目标

- 公开 Demo 按“组件类型 / 组件尺寸”展示 6 个基础场景和 5 组三档尺寸场景。
- 使用 `96 * 60 * 1000` 的同源初始时长，由组件标准 `highlight` 形态实现无底色高亮数字与单位视觉。
- `format` 是展示内容和更新精度的唯一来源；秒级模式仅跨秒更新，含 `S` 毫秒段时按绘制帧更新。
- `onChanged` 与用户可见展示变化同步，避免未展示的时间单位变化时产生冗余通知。
- 保留通用计时器名称与正向/倒计时能力，并统一组件内部、注释和 Demo 文案的“计时器”语义。
- `autoStart` 仅决定首次挂载是否启动；挂载后的开始、暂停和重置由 Controller 命令唯一控制。
- 动态切换 `direction`、`time` 时保持当前运行/暂停状态，并按新配置重置计时值。
- 生成代码面板包含复现场景所需的完整组件组合和状态计算。

### 不涉及

- 不复制小程序的 `selectComponent` 命令式调用或 CSS external classes。
- 不删除正向计时、Controller、自定义 builder 等仍有独立语义的 Flutter 扩展能力。
- 不修改通用 ExampleModule API 只为补一个模块说明文案。

## 最终方案与行为契约

1. `time` 必须非负；`format` 必须由时间段和单字符非空白分隔符组成。
2. `format` 中每种时间段最多出现一次；相邻时间段之间必须有且仅有一个非空白分隔符，最后可有一个单位字符。
3. `format` 不含 `S` 时仅在格式化后的可见值变化时重建并触发 `onChanged`；包含 `S` 时按有效绘制帧重建并通知。
4. `onFinish` 在一次运行到达终点时只触发一次；单纯初始为零或 reset 不重复完成通知，显式从终点 start 可完成一次。
5. `time` 或 `direction` 更新时按新契约重置，并保持更新前的运行/暂停状态；声明式 `time` 更新优先于此前 `controller.reset(time)` 的临时目标；`autoStart` 只在首次挂载时读取，后续更新不作为运行命令。
6. Controller 由调用方持有和释放，只公开 `start`、`pause`、`reset` 三个命令；绑定多个 `TTimeCounter` 时命令广播给所有实例；`reset` 支持更新目标时长并拒绝负值，重置后保持暂停，需要继续计时时显式调用 `start`。
7. `size`、`variant`、`splitWithUnit` 动态变化时立即重算组件样式。

### API 收敛

- 保留组件名 `TTimeCounter` 以及 Flutter 的 `direction`、`content` 和 `TTimeCounterController`，它们共同表达通用正向/倒计时用例；Figma CountDown 仅作为倒计时视觉场景，不反向限定组件命名。
- 不新增小程序的字符串 `content`、结构化 change payload 或外部 class API；自定义内容继续使用 Widget builder，回调继续传递毫秒整数。
- `TTimeCounterVariant` 使用 `plain`、`highlight`、`round`、`square` 表达四种标准绘制形态；Demo 不用 builder 覆盖标准形态。
- 删除可由 `format` 推导的 `showMillisecond`；`splitWithUnit` 保留为本地化单位展示入口。
- Controller 使用私有命令状态，删除效果重复的 `resume` 和可由调用方写入的公开状态值；暂停后调用 `start` 即可继续。
- `TTimeCounterThemeData` 只保存稳定的视觉默认值 颜色和圆角等字段，不保存 size/variant 选择器，不保存计时精度或内容结构。
- 内部样式解析器保持私有，不进入公开 API 文档。

## 关键决策与取舍

| 决策 | 理由与取舍 |
| --- | --- |
| 采用的方案 | 格式决定可见更新精度，声明式 time 更新优先于 Controller 临时目标；Controller 只保留 start/pause/reset。 |
| 保留的边界与代价 | 保留通用正向/倒计时和 Widget 内容，Theme 只保存具体视觉，不保存 size/variant 行为选择器。 |

### 设计演变中的关键理由

- 本次按用户确认不保留历史兼容：API 删除与默认语义变化以 breaking change 交付，并在 PR 中写清迁移方式。
- 公开 Demo 的正向计时与 Controller 场景移入组件测试，不等于删除 API。
- `autoStart` 的动态启停和 reset 后自动重启属于旧的重叠状态源；迁移为 Controller 的 `start` / `pause` 显式命令。
- 固定 Linux Flutter 3.32.0 生成 Golden，latest 不写回像素基线。
- Flutter latest 自动改写的分析配置和依赖噪声在验证后恢复。

## 兼容性与迁移

本次只整理设计记录，不据此新增 API、改变默认值或判断全部兼容。后续接口删除、类型收紧或默认行为变化按最终源码和迁移指南核对。

## 验收标准

- Flutter 3.32.0 与 latest 下组件、Demo 功能测试及严格 analyze 通过。
- TimeCounter 生产代码行覆盖率不低于 95%。
- Flutter 3.32.0 Linux 浅色/深色 Golden 生成后无更新复验通过。
- Web Demo 实际观察倒计时变化；iOS 模拟器打开受影响代码面板核对内容完整性（Web 端按现有页面契约不提供代码遮罩入口）。

验收标准描述应满足的行为，不表示已执行或通过；执行范围与证据见 [acceptance.md](./acceptance.md)，剩余事项只在 [tasks.md](./tasks.md) 维护。

跨组件配置职责见 [Theme 契约](../../engineering/048-Theme-configuration-contracts/spec.md)，视觉方法见 [Golden 规范](../../engineering/044-Testing-golden-regression/spec.md)。
