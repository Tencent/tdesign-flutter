# Footer 设计说明

## 背景与目标

以下保留设计形成时的问题与依据；已修复的问题不表示当前代码仍有同一缺陷。

品牌、说明和操作区的内容存在性不需要再用 variant 重复编码。

- Figma Footer `24386:5265`；小程序 `origin/develop@cc2384cc5`。
- Demo 收敛为基础、链接、品牌三组；链接组含单链接与双链接，品牌组含两个设计实例。
- 删除与内容重复的必填 `variant`，改用 Flutter Widget 组合 Logo 与链接。

## 范围与非目标

使用可选内容及链接组合表达页脚，组件只管理布局、分隔与语义样式。

## 最终方案与行为契约

- `logo` 非空时隐藏 `links`，但可与 `text` 组合为“版权文案 + 品牌”样式；
  组合时文案与 Logo 使用 `spacer8`。
- 多链接间绘制分隔线；链接与分隔线的水平间距使用 `spacer12`，分隔线颜色使用
  `componentStrokeColor`；版权文字保持单行省略。
- Theme 高度作为可选的外层布局约束；未配置时由内容自然撑开，与小程序 Footer 的内容驱动布局一致。

### 1.0.x 链接布局补丁

- 保留现有构造参数、品牌与版权组合、文字样式及间距 token；不引入旧 API、平台判断或版本兼容分支。
- 链接直接参与 `Wrap` 的布局，不使用 `IntrinsicWidth`，避免实际 Web 默认字体下的逐字竖排。
- 复用 Flutter `RenderWrap` 的测量、换行、居中、RTL、固有尺寸和命中测试。分隔线按最终布局绘制，仅出现在同一行的相邻链接之间，不作为可独立换行的子项。
- 保留链接左右各 `spacer1` 的间距、分隔线宽 1 / 高 22 及 `componentStroke` 颜色；换行行间距为 4。链接可以是任意 Widget，不预估或重复测量文本。
- 多链接行的最小高度为分隔线高度；单链接保持内容自然高度。窄容器中链接按可用宽度布局，版权保持单行省略。

## 关键决策与取舍

| 决策 | 理由与取舍 |
| --- | --- |
| 采用的方案 | 使用可选内容及链接组合表达页脚，组件只管理布局、分隔与语义样式。 |
| 保留的边界与代价 | 明确品牌内容可以与说明共存，避免互斥开关抹掉有效组合。 |

## 兼容性与迁移

- 删除 `TFooterVariant` 和构造器位置参数。
- `logo` 从资源路径改为 `Widget?`，`links` 改为 `List<Widget>`，删除 `width`。

## 验收标准

- 组件、Demo、覆盖率、双版本 analyze/test 通过。
- Flutter 3.32.0 Linux light/dark Golden 更新并复验通过。

验收标准描述应满足的行为，不表示已执行或通过；执行范围与证据见 [acceptance.md](./acceptance.md)，剩余事项只在 [tasks.md](./tasks.md) 维护。

跨组件配置职责见 [Theme 契约](../../engineering/048-Theme-configuration-contracts/spec.md)，视觉方法见 [Golden 规范](../../engineering/044-Testing-golden-regression/spec.md)。
