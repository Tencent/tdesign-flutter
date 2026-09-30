# 实施方案

## 技术方案

1. 只读盘点公开 Widget 参数、组件 Theme 字段和实际解析路径；同名仅作为候选，按语义判定，不按名称机械删除。
2. 收敛同义入口，包括跨实例 `style`、组件 Theme 与便利标量的基础视觉字段。已有完整 `style` 的字段由 `style` 独占 TDesign 公开配置；未被完整 `style` 覆盖的可复用视觉字段归组件 Theme；实例 API 持有状态、规格与结构选择。每项先记录迁移影响再改公开 API。
3. 对受影响的小程序组件变量，记录 CSS `var()` 的回退表达式、明暗及状态分支，再检查 Flutter 是否读取正确的全局 Token、组件常量或必要 Theme 字段。优先审查所有 `@radius-circle` 消费路径：Avatar、BackTop、CountDown/TimeCounter、Skeleton，并验证正方形与非正方形边界；保留已确认的 Flutter 全局 `radiusCircle = 9999dp` API 语义，不把默认例外伪装成 CSS `50%` 同值。
4. 改动后先验证聚焦功能与覆盖优先级，再在固定 Linux 3.32.0 环境无更新复跑相关 Golden。Golden 按来源做消融：全局 Token 改值、组件 Token 缺失/错误、`radiusCircle` 错用、字体/阴影跨引擎、旧基线或 Demo 布局，逐张给出处置建议。正确 Token 值导致的旧基线差异与组件缺陷分别归因。
5. TimeCounter 对应小程序 CountDown：移除组件 Theme 的 `defaultSize/defaultVariant`，保留实例选择；为确有组件变量的默认/块文字色、块背景色及方/圆块圆角提供具体 Theme 值。圆块在默认正方形尺寸下使用全局 `radiusCircle`，自定义该 Token 时必须从固定的 `BoxShape.circle` 转成对应 dp 圆角，而不忽略覆盖。
6. 按最新单入口规则修订前期的 Text/Button/Input 多层样式方案：`TText.style` 承担 TextStyle 能表达的绘制值，`TTextThemeData` 只留不被 TextStyle 表达的段落默认值；`TInput.style` 承担输入文字样式；Button 的实例 `ButtonStyle` 承担可表达的视觉字段，Theme 只留独有视觉配置。Text 尚待跨仓调用点迁移，不能提前视作实施完成。

## 影响范围

| 范围 | 影响 |
| --- | --- |
| 组件 Theme/API | 仅修改经逐项审查确认重复或错用 Token 的组件；已发布字段变更列为 breaking |
| 测试 | 公开契约、自定义全局 Token、子树 Theme、实例配置、明暗视觉 |
| Demo 与文档 | 仅修正因公开 API 迁移而失效的使用，不能加入样式遮盖 |
| 报告 | 修改清单、风险、Golden 差异和未覆盖组件 |

## 风险与取舍

- 删除已发布 Theme 字段或 Widget 参数是 breaking change；不能把仅标记 deprecated 当成已实现单一控制源。上一轮临时增加的 `radiusCircleBorder` 辅助 API 未形成独立组件契约，删除它并由 BackTop 内部直接构造相同边框，避免误用于半圆或非正方形组件。
- 本轮用户要求同一绘制字段即使跨子树默认与单实例覆盖也不再保留两套 TDesign 公开入口。这会移除部分已发布子树批量定制能力；须列出迁移方式、breaking 范围和外部调用风险。
- 804 个小程序组件变量目前有 2 个回退冲突、1 个未解析暗色表达式、3 个无回退；这些不是可直接认定的 Flutter 缺失项。

## 验证策略

- 静态：全局 216 键审计、Theme/API 重叠候选及实际引用核对。
- 功能：受影响组件在 Flutter 3.32.0 与 latest 的聚焦测试、定向 `flutter analyze --fatal-infos`。
- 视觉：固定 Linux 3.32.0、不更新 Golden；检查 master/test/diff 与具体 Token/布局来源。
- 人工：对设计稿无法裁定的项明确标记，不宣称像素一致。
