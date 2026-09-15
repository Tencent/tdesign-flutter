# 验收记录

## 验证环境

- 分支：`rss1102/feat/time-counter-design-alignment`
- Flutter 基线：已合并 `origin/develop@06f129cd`
- 移动端设计：Figma CountDown 页面；当前直接复验移动端展示画板 `28600:37472`（375×1500）
- 小程序参考：本地 `Tencent/tdesign-miniprogram@9ee571f8`

## 基线

| 命令 | 结果 |
| --- | --- |
| `flutter test test/components/time_counter/t_time_counter_test.dart` | Flutter 3.32.0，30/30 通过 |
| Demo 专项测试 | 未登记 |
| Golden | 未登记 |

## 最终自动化与人工验收

以下自动化结果均基于合并最新 develop 后的当前源码；首次提交的旧结果不作为最终结论。

| 门禁 | 结果 |
| --- | --- |
| Flutter 3.32.0 组件测试 | PASS，46/46 |
| Flutter 3.32.0 Demo 功能与代码资产测试 | PASS，4/4 |
| Flutter 3.32.0 component / example analyze | PASS，均 0 issue |
| Flutter 3.47.0 组件测试 | PASS，46/46 |
| Flutter 3.47.0 Demo 功能与代码资产测试 | PASS，4/4 |
| Flutter 3.47.0 component / example analyze | PASS，均 0 issue |
| TimeCounter 生产代码覆盖率 | PASS，279/283，98.59% |
| 代码面板生成校验 | PASS，11 个资产无漂移 |
| Flutter 3.32.0 Linux Golden | PASS，light / dark 2/2；更新后无参数精确复跑 |
| 小米 Android 16 当前源码 | PASS，完整 Example App 构建安装；首屏与尺寸区实测持续计时、16px 左对齐且无裁切 |

本轮未重复运行 Web 与 iPhone 模拟器；首次提交时的 Web / iOS 记录仅作为历史参考，不替代当前 Android 与 Linux Golden 证据。

Golden 初次生成时发现 Linux Skia 对包内 `TCloudNumber` 可变字体的测试栅格结果为实心方块，且通用 CJK 子集缺少 TimeCounter 文案。未接受错误基线；补充 TimeCounter 专用确定性字体子集，并按 package 字体命名空间覆盖测试字体后，明暗两张整页图的数字、中文均可读。比较器未配置容差，最终复跑为精确匹配。

## 歧义决策

- 小程序用于公开场景、尺寸、形态和计时结果参考，不机械复制字符串 `content`、结构化 change payload、external class 或 `selectComponent` 命令式 API。
- 保留 Flutter 通用组件名 `TTimeCounter`、已发布的 `direction`、Widget `content` builder 与 Controller；Figma CountDown 只定义倒计时视觉，不反向限定组件命名。
- `onChanged` 仅在 `format` 对应的可见值变化时更新；`format` 含 `S` 时按有效帧更新，未展示的时间单位变化不通知。
- 删除 `showMillisecond`，由 `format` 单一决定是否展示及刷新毫秒。
- `TTimeCounterThemeData` 仅保留 `defaultSize`、`defaultVariant` 两个视觉默认值；`splitWithUnit` 只由实例持有。
- `autoStart` 只决定首次挂载行为；Controller 删除公开可写状态和重复的 `resume`，运行期由 `start`、`pause`、`reset` 唯一控制，`reset` 后保持暂停。
- Figma 的无底色高亮单位是标准组件形态，由 `TTimeCounterVariant.highlight` 实现；`content` 只用于真正自定义内容。
- 当前 Web 页面按仓库既有逻辑只提供 API 入口、不提供代码遮罩切换；因此 Web 验收真实倒计时和完整滚动，代码面板操作改在 iOS 模拟器完成，不把静态资产读取冒充实际打开。
- 已直接读取 Figma CountDown 移动画板；颜色、字体、圆角优先来自 TDesign 语义 token，无对应通用 token 的 20/24/28dp 数字块和高亮 24dp 行盒保留为组件专属设计值。公开 Demo 实例按画板统一为距页面左侧 16px。
