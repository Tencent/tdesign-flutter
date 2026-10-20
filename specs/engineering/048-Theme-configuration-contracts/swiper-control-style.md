# Swiper 控制按钮样式收敛

## 最终契约

- 保留 TSwiperThemeData.controlStyle，仅 pagination=controls 时生效。外部 Material 组件主题不参与解析。
- 删除构造参数、字段、copyWith 和 lerp 中的 controlIconSize，不保留兼容别名。图标尺寸唯一入口为 controlStyle.iconSize，默认18dp；自定义图标自身的显式size仍优先。
- 显式TD样式当前状态非空值优先，null回到同状态Swiper默认值，再回到共享TD按钮默认值。透明色、零padding、无描边仍是有效覆盖。
- visualDensity始终无效，使用标准密度；通过padding/minimumSize/fixedSize/maximumSize调整尺寸。
- 支持ButtonStyle颜色、图标颜色/尺寸、几何、形状/描边、阴影、表面色、overlay、鼠标指针、反馈、splashFactory、tapTargetSize和按钮样式过渡。默认可见背景32dp、热区48dp；显式tapTargetSize允许改变热区。
- animationDuration只控制按钮样式过渡，Swiper.animationDuration仍控制切页。textStyle只为自定义文字图标提供默认排版；iconAlignment不创建不存在的图标文字组合布局。
- backgroundBuilder/foregroundBuilder及自定义图标恢复调用方Theme，并保留按钮已解析的文字/图标插槽默认值；内容显式样式优先。
- 业务下标、循环边界、disabled、切页、Tooltip、键盘/焦点/语义和原生反馈机制继续由Swiper及内部按钮管理。
- Theme插值中iconSize缺省或按状态返回null时以18dp插值；两端均没有图标尺寸配置时不生成额外尺寸值。

## Breaking迁移

删除controlIconSize属于编译期breaking change：

```dart
// 原配置
TSwiperThemeData(controlIconSize: 24)
// 新配置
TSwiperThemeData(
  controlStyle: ButtonStyle(iconSize: WidgetStatePropertyAll(24)),
)
```

已有controlStyle.iconSize配置无需迁移。原先因合并方向错误被忽略的背景、minimumSize、padding等显式样式现在生效；对曾依赖错误行为的调用方可见。密度不恢复。此次不引入新的公开样式类型。

## 验证矩阵

- M2/M3 × light/dark：外部IconButtonTheme/密度无效；TD显式背景、图标、尺寸、描边、反馈有效。
- normal/pressed/hovered/focused/disabled：同状态null回退，透明/零值保留；实际按下绘制与图标大小验证。
- 自定义图标/背景/前景图层读取原Theme，图标自身size优先；翻页、禁用、Controller/回调和键盘/焦点原生行为继续回归。
- 双向Theme插值验证18dp默认及状态值；既有Theme copyWith/lerp迁移。
- 双版本analyze、完整组件/工具/Demo回归；Linux3.32既有Golden无更新比较，新增light/dark普通及按下定制场景先审图再保存基线、无更新复跑。

## 当前状态

实施、双版本验证及逐图 review 完成；本节保留推送前本地验收记录，变更随 PR #1157 交付。

更新日志候选：`breaking(swiper): 删除 controlIconSize，统一使用 controlStyle.iconSize，并修复控制按钮显式样式与按状态回退`。不手工修改 CHANGELOG；PR 描述须包含该迁移说明。

## 主题过渡约束

真实切换minimumSize/fixedSize/maximumSize/padding时不生成最小尺寸大于最大尺寸的中间约束。iconSize18、minimumSize32、padding0、elevation0、透明阴影/表面色、无描边及圆形按有效默认值插值；最大尺寸的无限轴在中间帧保持无限，fixedSize一端缺省时离散恢复自然布局。Token依赖的颜色/文字一端缺省时保留null配置语义并切换端点，随后由当前TD主题与原生按钮样式动画处理，不能将null伪造为透明色/空文字。两端均显式配置的字段按状态插值；端点返回原配置。


## 本地验收记录（2026-10-13）

基于 PR #1157 本地 HEAD `5591c408baba9f0cb8fd9b4834356d25f5ad3a22`，以下为提交前的本地验证结果。

- Flutter 3.32.0 / latest 3.47.7：完整 57 组组件回归后，新增主题切换约束测试并对受影响的 Swiper、共享 Material helper、Theme extensions 最终重跑，各 88 测试通过，其中 Swiper 56 项、覆盖率 532/549（96.90%）。最终矩阵包含 2901 项组件测试；未重复与末次 Theme 插值修复无关的组件组。
- 两个版本工具测试各 155、Demo 测试各 365 通过；组件与 Demo analyze 均无问题。API 57 份检查及示例片段检查通过。
- Linux Flutter 3.32：全量 74 个唯一执行套件（75 个登记项）686 测试通过，无既有基线更新；末次主题插值修复后，再无更新重跑 Swiper / Theme 三个 Golden 套件，31 测试通过。
- 新增 4 张浅/深色普通及按下态控制按钮 Golden。与旧 HEAD 用相同场景渲染的图逐张比较：普通态均 0 差异；按下态各 2672 像素（1.90%）变化，仅下一页按钮背景及图标颜色。边框、位置和尺寸不变；修复前按下颜色被默认值盖住，修复后遵循显式 TD 状态配置。两列 M2/M3 表现一致。
- 额外独立尺寸断言验证 minimumSize 60dp、padding 12dp + iconSize 18dp 得到 42dp、shrinkWrap 默认 32dp；真实 Theme 过渡不再出现最小约束大于最大约束。密度无效且不恢复 Material 字体继承。
- 自定义图标、backgroundBuilder、foregroundBuilder 均读取原调用方 Theme，自定义 Icon.size 优先。真实点击、键盘 Enter、Controller/回调、终点禁用及原生 Tooltip/焦点路径保留。
- 最终 review：本轮未发现阻塞问题。删除 controlIconSize 是明确的编译期 breaking change；原先被错误合并屏蔽的显式样式现在生效。单端缺省颜色/固定尺寸采用文档明确的离散配置切换；最大尺寸无限轴保持无限。有效默认值由 TD 收口，不依赖 Material 默认视觉。

日志位于 `/private/tmp/td1157-swiper-*.log`，逐图对比：`http://127.0.0.1:8765/swiper-control-style/index.html`。
