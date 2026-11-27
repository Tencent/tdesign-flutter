# Cell 设计说明

## 背景与范围

本节记录 PR #1162 的 `TCellGroup.scrollable` 高度约束修复。原实现同时使用 `Expanded` 和普通 `ListView`，在父级高度无界时触发布局异常。修复需要允许外层滚动容器承载列表，同时保留默认非滚动模式的布局路径。

范围仅限 CellGroup 的高度适配和滚动归属；不扩展 Cell 内容的固有尺寸支持，不调整公开参数、默认值、主题及内容生命周期。跨组件主题职责见 [Theme 契约](../../engineering/048-Theme-configuration-contracts/spec.md)。

## 行为契约

`scrollable` 默认仍为 `false`。有界表示父级约束的最大高度有限，不要求父级提供紧约束；`Column` 或 `SingleChildScrollView` 是否有界以实际传入的约束为准。

| 配置与约束 | 布局 | 滚动归属 |
| --- | --- | --- |
| `scrollable: false` | 保留按内容布局的 Column，不引入 LayoutBuilder 或 ListView | 由调用方决定 |
| `scrollable: true`，高度有界 | 组撑满可用高度，标题后剩余空间分配给列表 | 内部 ListView |
| `scrollable: true`，高度无界 | 列表 shrinkWrap，组按内容高度布局，不使用 Expanded | 内部禁止用户滚动；有外层滚动容器时由外层处理 |

无界 Column 本身不提供滚动能力；内容超过屏幕时，调用方仍需提供滚动容器或为组设置有限高度。标题、builder、分隔线、卡片圆角和主题解析保持原职责。

## 决策与限制

- 仅滚动模式需要读取父级高度，故仅该路径使用 LayoutBuilder；共用内容构建逻辑，避免复制两套标题与主题布局。
- 未采用无条件包裹 LayoutBuilder 的初始方案：它会使原本可计算固有尺寸的空组和自定义 builder 组合抛异常，影响与修复目标无关的默认路径。
- 非滚动路径不额外阻断固有尺寸计算，不等于承诺任意内容均支持 IntrinsicHeight/IntrinsicWidth。普通 TCell 内部也可能依赖布局约束，能否计算仍取决于实际子树。
- 无界模式的 shrinkWrap 需要测量内容，长列表可能增加布局成本；大量数据应优先提供有限高度并使用内部滚动。本次不新增虚拟列表 API 或公共布局封装。

## 兼容性

不改变 API 签名或默认值；保留原有可用的有界滚动与非滚动模式，修复原先报错的无界滚动组合。需要内部滚动时，调用方应提供有限高度（如 SizedBox，或在有界 Flex 中使用 Expanded）。

## 验收标准

- 有界滚动组可通过实际拖动改变内部滚动位置，标题保持在列表外。
- 无界滚动组在 SingleChildScrollView 和普通 Column 中无约束异常；拖动外层滚动容器内的 cells 时，外层偏移增加、内层偏移不变。
- 默认非滚动组的空组及可计算固有尺寸的自定义 builder 在 IntrinsicHeight 中正常布局。
- 原有 Cell 测试保持通过，双版本严格分析与组件生产覆盖率满足仓库门禁。

实际结果见 [acceptance.md](./acceptance.md)，未覆盖事项见 [tasks.md](./tasks.md)。

## 卡片形态背景色

本节记录 issue #1240 的修复：`TCellGroup(variant: TCellGroupVariant.card)` 的圆角一直画在组容器上，但容器本身没有 `color`；视觉上的白色来自内部 `TCell` 的 `bgColorContainer`。`cardPadding` 默认左右各 16 逻辑像素，使单元格内缩，圆角弧线所在的这一圈没有任何可填充的内容，表现即为"改了 `cardBorderRadius` 但看不到圆角"；把 `cardPadding` 设为 `EdgeInsets.zero` 时单元格贴到边缘，圆角才有可见的裁切结果。圆角与裁切本身从未失效，缺的是容器自身背景。

|
配置 | 组容器装饰 | 圆角可见性 |
| --- | --- | --- |
| 卡片形态，未配置 `cardBackgroundColor` | `color` 回退 `bgColorContainer` Token，`borderRadius` 取 `resolveCardBorderRadius`，`clipBehavior: Clip.antiAlias` | 默认 `cardPadding` 下可见 |
| 卡片形态，配置 `cardBackgroundColor` | `color` 取配置值，其余同上 | 可见 |
| 通栏形态 | 不绘制 `color` | 与修复前一致 |

`cardPadding` 的语义收敛为卡片内边距，不再隐含"决定圆角是否可见"。圆角解析、裁切与分隔线职责不变。

## 兼容性（卡片背景色）

仅新增可选字段 `TCellThemeData.cardBackgroundColor`，未配置时行为在通栏形态下与修复前完全一致；卡片形态在默认 `cardPadding` 下由"边缘露出页面底色"变为"完整白色卡片"，属于缺陷修复，同步更新 `cell_card_default_radius_light.png` / `cell_card_default_radius_dark.png` 两张 golden，差异区域限于卡片矩形内部。

## 验收标准（卡片背景色）

- 卡片形态容器自身绘制背景色，默认 `cardPadding` 与 `EdgeInsets.zero` 下 `borderRadius` 均来自主题；
- 通栏形态容器不绘制 `color`，行为不变；
- 未配置 `cardBackgroundColor` 时回退 `bgColorContainer` Token；
- iOS 真机（模拟器）截图对比：默认 `cardPadding` 下圆角可见。
