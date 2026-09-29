# 实施方案

## 技术方案

1. 只读盘点公开 Widget 参数、组件 Theme 字段和实际解析路径；同名仅作为候选，按语义判定，不按名称机械删除。
2. 收敛同一作用域内的同义入口，包括基础视觉字段。组件实例持有逐实例状态与形态，完整 `style` 可显式覆盖单实例；Theme 持有有证据的子树基础视觉默认值。不能把实例覆盖与子树默认值机械判为重复，也不能增加无独立语义的便利标量。每项先记录迁移影响再改公开 API。
3. 对受影响的小程序组件变量，记录 CSS `var()` 的回退表达式、明暗及状态分支，再检查 Flutter 是否读取正确的全局 Token、组件常量或必要 Theme 字段。优先审查所有 `@radius-circle` 消费路径：Avatar、BackTop、CountDown/TimeCounter、Skeleton，并验证正方形与非正方形边界；保留已确认的 Flutter 全局 `radiusCircle = 9999dp` API 语义，不把默认例外伪装成 CSS `50%` 同值。
4. 改动后先验证聚焦功能与覆盖优先级，再在固定 Linux 3.32.0 环境无更新复跑相关 Golden。Golden 按来源做消融：全局 Token 改值、组件 Token 缺失/错误、`radiusCircle` 错用、字体/阴影跨引擎、旧基线或 Demo 布局，逐张给出处置建议。正确 Token 值导致的旧基线差异与组件缺陷分别归因。
5. TimeCounter 对应小程序 CountDown：移除组件 Theme 的 `defaultSize/defaultVariant`，保留实例选择；为确有组件变量的默认/块文字色、块背景色及方/圆块圆角提供具体 Theme 值。圆块在默认正方形尺寸下使用全局 `radiusCircle`，自定义该 Token 时必须从固定的 `BoxShape.circle` 转成对应 dp 圆角，而不忽略覆盖。
6. 逐字段核对 `TTextThemeData` 的 Flutter 原生替代：`DefaultTextStyle` 可继承文字样式、`textWidthBasis`、`textHeightBehavior`，但不承载 `strutStyle`，且旧 Theme 已提供 TDesign `Font` 子树默认值。因此恢复 Text 组件 Theme，保留实例 `style` 作为单实例覆盖，测试 Theme/原生继承/实例优先级。Button/Input 同理保留有证据的组件 Theme 与实例完整 `style`，审查现有解析链和文档，不机械删除。分别比对默认与自定义视觉。

## 影响范围

| 范围 | 影响 |
| --- | --- |
| 组件 Theme/API | 仅修改经逐项审查确认重复或错用 Token 的组件；已发布字段变更列为 breaking |
| 测试 | 公开契约、自定义全局 Token、子树 Theme、实例配置、明暗视觉 |
| Demo 与文档 | 仅修正因公开 API 迁移而失效的使用，不能加入样式遮盖 |
| 报告 | 修改清单、风险、Golden 差异和未覆盖组件 |

## 风险与取舍

- 删除已发布 Theme 字段或 Widget 参数是 breaking change；不能把仅标记 deprecated 当成已实现单一控制源。上一轮临时增加的 `radiusCircleBorder` 辅助 API 未形成独立组件契约，删除它并由 BackTop 内部直接构造相同边框，避免误用于半圆或非正方形组件。
- 用户确认“子树默认值与单实例显式覆盖”是两个配置作用域；不能将二者误判为同一控制入口，也不能因此放任实例便利标量、组件 Theme、Flutter 标准主题之间的无意义重叠。删除 Theme 字段仍可能使已有子树批量定制失效，必须逐项证明原生继承是否等价。
- 804 个小程序组件变量目前有 2 个回退冲突、1 个未解析暗色表达式、3 个无回退；这些不是可直接认定的 Flutter 缺失项。

## 验证策略

- 静态：全局 216 键审计、Theme/API 重叠候选及实际引用核对。
- 功能：受影响组件在 Flutter 3.32.0 与 latest 的聚焦测试、定向 `flutter analyze --fatal-infos`。
- 视觉：固定 Linux 3.32.0、不更新 Golden；检查 master/test/diff 与具体 Token/布局来源。
- 人工：对设计稿无法裁定的项明确标记，不宣称像素一致。
