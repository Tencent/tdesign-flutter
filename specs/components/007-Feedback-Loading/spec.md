# Loading 设计说明

## 背景与目标

以下保留设计形成时的问题与依据；已修复的问题不表示当前代码仍有同一缺陷。

预设尺寸与指示器实际几何不一致，时长和方向默认值偏离移动端语义。

在 Issue #70 的跨端对照 Review（见 `tdesign-component-align-review` skill）中，Flutter `TLoading` 与官方小程序（`tdesign-miniprogram@1.16.0`）/ Mobile Vue（`tdesign-mobile-vue@1.16.1`）的 Loading 存在以下核心差距：

1. **`duration` 默认值不一致**：官方默认 `800`ms，Flutter 默认 `2000`ms，转圈明显偏慢。
2. **`layout` 默认方向不一致**：官方默认 `horizontal`（图标在左、文字在右），Flutter 默认 `Axis.vertical`（图标在上、文字在下）。
3. **尺寸 API 语义不一致**：官方两端的 `size` 都是可连续配置的指示器尺寸，默认 `20px`；Flutter 使用 `TLoadingSize` 枚举，而且同一枚举在 circle / activity / point 上对应不同几何含义，无法表达 Button 默认 20px 与公开尺寸 Demo 的 24/28/32px。
4. **站点文档多处过时/不一致**：示例文件链接笔误、`axis/iconColor/textColor/duration` 误列为 `TLoading` 构造参数（实际在 `TLoadingThemeData`）、示例代码与源码不符、`loading_api.md` 与 README 分叉。

- Figma 页面节点 `24386:5280` 的“颜色不一致”标注对应 24×24 的 activity 指示器；设计基准中 activity 使用主文字黑色，而 circle / point 保持品牌色。
- 当前组件把同一个品牌色默认值传给所有预设指示器，导致纯图标、横向图文、竖向图文中的 3 个 activity 实例全部错误呈现为蓝色。
- 本轮在组件默认解析链中区分图标类型：activity 默认读取 `textColorPrimary`，circle / point 继续读取 `brandNormalColor`。Demo 不注入黑色覆盖，因此这是**组件问题修复**，不是 Demo 遮盖。
- `TLoadingThemeData.iconColor`、Flutter `ProgressIndicatorThemeData.color` 和显式 `ColorScheme` 的覆盖能力保持不变；无公开 API 签名变化，不是 breaking change。

## 范围与非目标

### 目标

- 将 `TLoading.size` 收敛为单一 `double` 参数，默认 `20.0`；移除 `TLoadingSize`，不在 Theme 中增加重复尺寸入口。
- 对齐 `duration` 默认值 800ms、`axis` 默认方向 horizontal（对齐官方 `layout` 默认）。
- 统一 circle / activity / point 的 `size` 为指示器外部尺寸；公开尺寸 Demo 显式使用 `24/28/32px`。
- 按小程序公开页收敛 Demo 分组与实例顺序：纯图标中合并 custom 指示器，尺寸合并为一个完整示例（复用已有能力，不加新 API）。
- 修正站点 README 与 `loading_api.md` 的过时/分叉内容。

### 涉及

- `tdesign-component/lib/src/components/loading/t_loading.dart`
- `tdesign-component/lib/src/components/loading/t_loading_controller.dart`
- `tdesign-component/lib/src/components/loading/t_loading_theme_data.dart`
- `tdesign-component/test/components/loading/t_loading_test.dart`
- `tdesign-component/example/lib/page/t_loading_page.dart`（收敛小程序公开 Demo 矩阵）
- `tdesign-component/example/assets/api/loading_api.md`（收敛与 README 一致）
- `tdesign-site/docs/components/loading/README.md`（修正链接、API 表、示例代码；不写入 PR 更新日志）

### 不涉及

- **不新增** `reverse` / `pause` / `delay` 属性（官方发布版未公开展示这三个属性对应 Demo，按"最小 API 扩充 + 不为未发布 Demo 加一次性参数"原则，本期不实现，列为后续）。
- **不实现** `attach`（仅 Vue 独有且发布版注释"视觉稿待定"）。
- 不改变 `TLoadingIcon` 枚举的定义与命名。
- 不改变 `TLoadingController` 的命令式 `show/dismiss` 形态（属框架设计差异，可接受）。
- 不为公开 Demo 未使用的全屏蒙层新增参数；保持 Loading 与 Toast 的公共契约独立。
- 不改动其他 Overlay 组件（Toast / Dialog / ActionSheet）。
- `tdesign-component/CHANGELOG.md` 由 CLI 自动生成，不人工编辑。

- `t_circle_indicator.dart` / `t_activity_indicator.dart` 的公开 API
- 其他组件与站点整体结构

## 最终方案与行为契约

### `size` 单一尺寸契约

- `TLoading.size` 类型由 `TLoadingSize` 改为 `double`，默认 `20.0`，要求大于 0。
- `TLoadingController.show.size` 同步改为 `double`，默认 `20.0`。
- 移除 `TLoadingSize`，也不在 `TLoadingThemeData` 增加 `size`，保证尺寸只有一个公开状态源。
- `size` 统一表示指示器外部尺寸：circle 直径为 `size`、描边为 `size / 8`；activity 半径为 `size / 2`；point 使用 `size × size` 容器，单点直径为 `size × 0.2`；customIcon 受同尺寸方形约束。
- 文本字号和图文间距不再由指示器尺寸联动：文本使用默认 body-medium，横向间距 8、纵向间距 6。

### `duration` 默认值 2000 → 800

- `TLoadingThemeData.duration` 的**生效默认值**从 `2000` 调整为 `800`（`t_loading.dart` `_effectiveTheme` 内 `theme.duration ?? 2000` → `?? 800`）。
- `t_loading_theme_data.dart` 的 `duration` 字段 dartdoc 说明默认对齐官方 `800ms`。
- 保持 `duration > 0` 才生效的既有语义（`innerDuration = effectiveDuration > 0 ? effectiveDuration : 1`）。

### `axis` 默认方向 vertical → horizontal

- `_effectiveTheme` 中 `theme.axis ?? Axis.vertical` 调整为 `theme.axis ?? Axis.horizontal`。
- 显式传入 `axis` 或注入 `TLoadingThemeData(axis:)` 时行为不变。
- 间距语义保持不变（horizontal 用横向间距、vertical 用纵向间距）。

### 尺寸示例

- 默认指示器尺寸为 20，对齐官方两端 API 默认值及 Button Loading。
- circle 尺寸 Demo 显式使用 24/28/32，对应小程序 `48/56/64rpx`。
- 纯图标 Demo 的 point 显式使用 40，对应小程序 `80rpx`。
- 加载速度 Demo 显式使用 26，对应小程序 `52rpx`。

### Demo 收敛

- `t_loading_page.dart` 的公开页仅保留小程序公开矩阵：`01 组件类型`、`02 组件尺寸`、`03 加载速度`。
- custom 指示器与 circle / spinner / dots 同属“纯图标”实例，使用小程序 Demo 同一张 `logo2.png` 的本地资产，不单独扩充一个 Flutter 专属 Demo。
- custom 指示器与其他 Loading 指示器一致，按 `TLoadingThemeData.duration` 持续线性旋转；复用既有动画时长，不新增公开参数。
- `customIcon` 是指示器内容的最高优先级入口；即使 `icon == null`，只要提供 customIcon 仍显示并旋转，避免两个现有参数形成冲突状态。
- 大、中、小三档尺寸收敛在“大尺寸”示例内，与小程序页面层级一致。
- 各示例内容按小程序带 padding 的 Demo 容器左对齐；横向图文实例间距 64，竖向图文实例间距 64。
- 加载速度默认值为 800，滑块上方常驻展示当前数值；拖动后数值与动画时长映射同步更新。
- 调试模块默认不出现在公开页。

### 文档修正

- 站点 README 示例链接 `td_loading_page.dart` → `t_loading_page.dart`。
- 站点 README API 表将 `axis/iconColor/textColor/duration` 从 `TLoading` 构造参数移入 `TLoadingThemeData` 说明。
- 站点 README 内嵌示例代码改为与 `t_loading_page.dart` 源码一致的 `Theme + mergeExtension` 写法。
- `example/assets/api/loading_api.md` 与站点 README 收敛一致。
- 同步修正 `duration` 默认值（800）与 `axis` 默认方向（horizontal）的文档描述。

### 指示器默认颜色

- 未显式配置颜色时，circle / point 使用 `brandNormalColor`，activity 使用 `textColorPrimary`（浅色主题为 Gy1 90% 黑色）。
- 统一覆盖优先级保持 `TLoadingThemeData.iconColor > ProgressIndicatorThemeData.color > 显式 ColorScheme.primary > 图标类型内置 Token`。
- 同一个 `TLoadingThemeData.iconColor` 仍可统一覆盖所有图标类型，不新增逐图标颜色 API。

## 关键决策与取舍

| 决策 | 理由与取舍 |
| --- | --- |
| 采用的方案 | size 使用单一 double 外部尺寸而不再提供预设枚举或 Theme 同义入口。 |
| 保留的边界与代价 | 文本字号与间距不随指示器尺寸联动，避免调整图标时意外改变文案布局。 |

### 设计演变中的关键理由

- Figma 当前 Loading 页为 `24386:5280`。“颜色不一致”文字标注位于 `x=-976, y=303, 60×20`，对应红色 20% 标记框 `x=-976, y=323, 24×24`；设计基准中的 activity 为主文字黑色，circle / point 为品牌蓝。
- 根因是**组件默认值**：`TLoading` 把同一 `brandNormalColor` 传给 circle、point、activity。修复后 activity 使用 `textColorPrimary`，circle / point 不变；公开 Demo 未添加颜色 Theme，避免掩盖组件问题。
- Flutter 3.32 Linux 首次精确比较：light 704px（0.17%）、dark 698px（0.16%）；差异只覆盖纯图标、横向图文、竖向图文共 3 个 activity 指示器。只更新 Loading light/dark 两张 Golden 后，无更新参数复跑 2/2。
- 完整修改前、修改后与独立像素差异图保存在 GitHub PR #1126 描述的附件中，不作为 Spec 二进制文件提交。
- Flutter 3.32：组件与工具回归 63/63（其中 Loading 组件 50/50），公开 Demo 2/2；生产源码 LCOV `265/266 = 99.62%`；组件与 Example 严格 analyze 均 0 issues。
- Flutter 3.47：Loading 组件 50/50、公开 Demo 2/2；组件与 Example 严格 analyze 均 0 issues。两个 SDK 间执行 clean 并分别恢复依赖，未混用编译缓存。
- 示例代码生成器 `--check` 通过，无生成片段变化。
- 没有新增或修改公开 API。默认 activity 视觉由品牌蓝改为主题主文字色，属于用户可感知的组件视觉修复，但不构成 breaking API 变更。

## 兼容性与迁移

- **`size` 从 `TLoadingSize` 改为 `double` 并移除枚举**：现有调用需改为所需逻辑像素值；由于旧枚举对不同 icon 的映射不同，不提供机械的一对一别名。
- 用户可感知的接口删除或默认行为变化按仓库 breaking 规范记录，并给出迁移方法。
- 用户可感知的接口删除或默认行为变化按仓库 breaking 规范记录，并给出迁移方法。

## 验收标准

- `TLoading()` 可省略 `size`，指示器外部尺寸默认为 20；非正数触发断言。
- 仓库源码、测试、Demo、生成片段和用户文档中不再引用 `TLoadingSize`。
- circle / activity / point 对同一个 `size` 使用统一外部尺寸语义。
- `duration` 生效默认值从 2000 改为 800（未注入 Theme 时 circle indicator duration == 800）。
- `axis` 生效默认方向为 horizontal（未注入 Theme 时 Flex.direction == horizontal）。
- circle 尺寸 Demo 显式展示 24/28/32，Button Loading 保持默认 20。
- 公开 Demo 的三个分组、实例顺序、对齐、文案与小程序一致，custom 指示器显示官方图片且不单独扩展分组，速度滑块常驻显示并更新数值。
- custom 指示器按默认 800ms 持续旋转，并响应 Theme duration 更新。
- `customIcon` 在 `icon == null` 时仍按最高优先级显示。
- 明暗主题整页 Golden 已在 Flutter 3.32.0 Linux CI 复现通过，且已与小程序实际页面截图完成人工比对。
- 站点 README 链接、API 表、示例代码已修正，`loading_api.md` 与 README 一致。
- Loading 全部手写生产源码行覆盖率 ≥95% 且不低于修改前基线（86.15%）。
- `flutter analyze --fatal-infos` 0 error / 0 warning。
- 双版本（Flutter 3.32.0 / latest）focused tests 通过。

验收标准描述应满足的行为，不表示已执行或通过；执行范围与证据见 [acceptance.md](./acceptance.md)，剩余事项只在 [tasks.md](./tasks.md) 维护。

跨组件配置职责见 [Theme 契约](../../engineering/048-Theme-configuration-contracts/spec.md)，视觉方法见 [Golden 规范](../../engineering/044-Testing-golden-regression/spec.md)。
