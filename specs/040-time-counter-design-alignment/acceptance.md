# 验收记录

## 验证环境

- 分支：`rss1102/feat/time-counter-design-alignment`
- Flutter 基线：已合并 `origin/develop@bd357422`
- 移动端设计：Figma CountDown 页面；移动端展示画板 `28600:37472`（375×1500）、方形中尺寸实例 `27236:22626`、无底色高亮实例 `27236:22717`
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
| Flutter 3.32.0 组件测试 | PASS，38/38 |
| Flutter 3.32.0 Demo 功能与代码资产测试 | PASS，4/4 |
| Flutter 3.32.0 component / example analyze | PASS，均 0 issue |
| Flutter 3.47.0 组件测试 | PASS，38/38 |
| Flutter 3.47.0 Demo 功能与代码资产测试 | PASS，4/4 |
| Flutter 3.47.0 component / example analyze | PASS，均 0 issue |
| TimeCounter 生产代码覆盖率 | PASS，279/280，99.64% |
| 代码面板生成校验 | PASS，11 个资产无漂移 |
| Flutter 3.32.0 Linux Golden | PASS，light / dark 2/2；更新后无参数精确复跑 |
| iPhone 16 模拟器当前源码 | PASS，首屏实测从 `01:35:38` 继续运行到 `01:32:18`，毫秒场景同步更新；`highlight` 数字、单位、方形与圆形形态均正常 |

Android 实机已完成当前源码构建与安装，但设备停在带指纹的安全锁屏，未将安装成功冒充为视觉验收通过。Web 本轮未重复运行；首次提交时的 Web / Android 记录仅作为历史参考。

Golden 初次生成时发现 Linux Skia 对包内 `TCloudNumber` 可变字体的测试栅格结果为实心方块，且通用 CJK 子集缺少 TimeCounter 文案。未接受错误基线；补充 TimeCounter 专用确定性字体子集，并按 package 字体命名空间覆盖测试字体后，明暗两张整页图的数字、中文均可读。比较器未配置容差，最终复跑为精确匹配。

## 歧义决策

- 小程序用于公开场景、尺寸、形态和计时结果参考，不机械复制字符串 `content`、结构化 change payload、external class 或 `selectComponent` 命令式 API。
- 保留 Flutter 已发布的 `direction`、Widget `content` builder 与 Controller；仅从公开 Demo 移除正向计时和控制入口，聚焦测试继续覆盖这些能力。
- 普通秒级展示与 `onChanged` 均只在可见秒值变化时更新；`format` 含 `S` 时才按有效帧更新。
- 删除 `showMillisecond`，由 `format` 单一决定是否展示及刷新毫秒。
- `TTimeCounterThemeData` 仅保留 `defaultSize`、`defaultVariant` 两个视觉默认值；`splitWithUnit` 只由实例持有。
- Controller 删除公开可写状态和重复的 `resume`；暂停后使用 `start` 继续。
- Figma 的无底色高亮单位是标准组件形态，由 `TTimeCounterVariant.highlight` 实现；`content` 只用于真正自定义内容。
- 当前 Web 页面按仓库既有逻辑只提供 API 入口、不提供代码遮罩切换；因此 Web 验收真实倒计时和完整滚动，代码面板操作改在 iOS 模拟器完成，不把静态资产读取冒充实际打开。
- 已直接读取 Figma CountDown 组件节点；颜色、字体、圆角优先来自 TDesign 语义 token，无对应通用 token 的 20/24/28dp 数字块和高亮 24dp 行盒保留为组件专属设计值。
