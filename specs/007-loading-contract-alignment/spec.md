# Loading：默认值、尺寸、Demo 与文档调整

## 背景

在 Issue #70 的跨端对照 Review（见 `tdesign-component-align-review` skill）中，Flutter `TLoading` 与官方小程序（`tdesign-miniprogram@1.16.0`）/ Mobile Vue（`tdesign-mobile-vue@1.16.1`）的 Loading 存在以下核心差距：

1. **`duration` 默认值不一致**：官方默认 `800`ms，Flutter 默认 `2000`ms，转圈明显偏慢。
2. **`layout` 默认方向不一致**：官方默认 `horizontal`（图标在左、文字在右），Flutter 默认 `Axis.vertical`（图标在上、文字在下）。
3. **尺寸 API 语义不一致**：官方两端的 `size` 都是可连续配置的指示器尺寸，默认 `20px`；Flutter 使用 `TLoadingSize` 枚举，而且同一枚举在 circle / activity / point 上对应不同几何含义，无法表达 Button 默认 20px 与公开尺寸 Demo 的 24/28/32px。
4. **站点文档多处过时/不一致**：示例文件链接笔误、`axis/iconColor/textColor/duration` 误列为 `TLoading` 构造参数（实际在 `TLoadingThemeData`）、示例代码与源码不符、`loading_api.md` 与 README 分叉。

## 目标

- 将 `TLoading.size` 收敛为单一 `double` 参数，默认 `20.0`；移除 `TLoadingSize`，不在 Theme 中增加重复尺寸入口。
- 对齐 `duration` 默认值 800ms、`axis` 默认方向 horizontal（对齐官方 `layout` 默认）。
- 统一 circle / activity / point 的 `size` 为指示器外部尺寸；公开尺寸 Demo 显式使用 `24/28/32px`。
- 按小程序公开页收敛 Demo 分组与实例顺序：纯图标中合并 custom 指示器，尺寸合并为一个完整示例（复用已有能力，不加新 API）。
- 修正站点 README 与 `loading_api.md` 的过时/分叉内容。

## 非目标

- **不新增** `reverse` / `pause` / `delay` 属性（官方发布版未公开展示这三个属性对应 Demo，按"最小 API 扩充 + 不为未发布 Demo 加一次性参数"原则，本期不实现，列为后续）。
- **不实现** `attach`（仅 Vue 独有且发布版注释"视觉稿待定"）。
- 不改变 `TLoadingIcon` 枚举的定义与命名。
- 不改变 `TLoadingController` 的命令式 `show/dismiss` 形态（属框架设计差异，可接受）。
- 不为公开 Demo 未使用的全屏蒙层新增参数；保持 Loading 与 Toast 的公共契约独立。
- 不改动其他 Overlay 组件（Toast / Dialog / ActionSheet）。
- `tdesign-component/CHANGELOG.md` 由 CLI 自动生成，不人工编辑。

## 范围

### 涉及

- `tdesign-component/lib/src/components/loading/t_loading.dart`
- `tdesign-component/lib/src/components/loading/t_loading_controller.dart`
- `tdesign-component/lib/src/components/loading/t_loading_theme_data.dart`
- `tdesign-component/test/components/loading/t_loading_test.dart`
- `tdesign-component/example/lib/page/t_loading_page.dart`（收敛小程序公开 Demo 矩阵）
- `tdesign-component/example/assets/api/loading_api.md`（收敛与 README 一致）
- `tdesign-site/docs/components/loading/README.md`（修正链接、API 表、示例代码；不写入 PR 更新日志）

### 不涉及

- `t_circle_indicator.dart` / `t_activity_indicator.dart` 的公开 API
- 其他组件与站点整体结构

## 行为契约

### 0. `size` 单一尺寸契约

- `TLoading.size` 类型由 `TLoadingSize` 改为 `double`，默认 `20.0`，要求大于 0。
- `TLoadingController.show.size` 同步改为 `double`，默认 `20.0`。
- 移除 `TLoadingSize`，也不在 `TLoadingThemeData` 增加 `size`，保证尺寸只有一个公开状态源。
- `size` 统一表示指示器外部尺寸：circle 直径为 `size`、描边为 `size / 8`；activity 半径为 `size / 2`；point 使用 `size × size` 容器，单点直径为 `size × 0.2`；customIcon 受同尺寸方形约束。
- 文本字号和图文间距不再由指示器尺寸联动：文本使用默认 body-medium，横向间距 8、纵向间距 6。

### 1. `duration` 默认值 2000 → 800

- `TLoadingThemeData.duration` 的**生效默认值**从 `2000` 调整为 `800`（`t_loading.dart` `_effectiveTheme` 内 `theme.duration ?? 2000` → `?? 800`）。
- `t_loading_theme_data.dart` 的 `duration` 字段 dartdoc 说明默认对齐官方 `800ms`。
- 保持 `duration > 0` 才生效的既有语义（`innerDuration = effectiveDuration > 0 ? effectiveDuration : 1`）。

### 2. `axis` 默认方向 vertical → horizontal

- `_effectiveTheme` 中 `theme.axis ?? Axis.vertical` 调整为 `theme.axis ?? Axis.horizontal`。
- 显式传入 `axis` 或注入 `TLoadingThemeData(axis:)` 时行为不变。
- 间距语义保持不变（horizontal 用横向间距、vertical 用纵向间距）。

### 3. 尺寸示例

- 默认指示器尺寸为 20，对齐官方两端 API 默认值及 Button Loading。
- circle 尺寸 Demo 显式使用 24/28/32，对应小程序 `48/56/64rpx`。
- 纯图标 Demo 的 point 显式使用 40，对应小程序 `80rpx`。
- 加载速度 Demo 显式使用 26，对应小程序 `52rpx`。

### 4. Demo 收敛

- `t_loading_page.dart` 的公开页仅保留小程序公开矩阵：`01 组件类型`、`02 组件尺寸`、`03 加载速度`。
- custom 指示器与 circle / spinner / dots 同属“纯图标”实例，不单独扩充一个 Flutter 专属 Demo。
- 大、中、小三档尺寸收敛在“大尺寸”示例内，与小程序页面层级一致。
- 调试模块默认不出现在公开页。

### 5. 文档修正

- 站点 README 示例链接 `td_loading_page.dart` → `t_loading_page.dart`。
- 站点 README API 表将 `axis/iconColor/textColor/duration` 从 `TLoading` 构造参数移入 `TLoadingThemeData` 说明。
- 站点 README 内嵌示例代码改为与 `t_loading_page.dart` 源码一致的 `Theme + mergeExtension` 写法。
- `example/assets/api/loading_api.md` 与站点 README 收敛一致。
- 同步修正 `duration` 默认值（800）与 `axis` 默认方向（horizontal）的文档描述。

## 兼容性

### breaking change 汇总

- **`size` 从 `TLoadingSize` 改为 `double` 并移除枚举**：现有调用需改为所需逻辑像素值；由于旧枚举对不同 icon 的映射不同，不提供机械的一对一别名。
- **`duration` 默认 2000→800**：所有使用默认动画速度的调用转圈变快，属用户可感知的视觉行为变化。更新日志须加 `⚠️` 前置标记。
- **`axis` 默认 vertical→horizontal**：未显式指定方向的默认调用从"图标在上文字在下"变为"图标在左文字在右"，属**明确 breaking change**。更新日志须加 `⚠️` 前置标记并建议显式传 `axis: Axis.vertical` 保留原行为。

## 验收标准

- [ ] `TLoading()` 可省略 `size`，指示器外部尺寸默认为 20；非正数触发断言。
- [x] 仓库源码、测试、Demo、生成片段和用户文档中不再引用 `TLoadingSize`。
- [ ] circle / activity / point 对同一个 `size` 使用统一外部尺寸语义。
- [ ] `duration` 生效默认值从 2000 改为 800（未注入 Theme 时 circle indicator duration == 800）。
- [ ] `axis` 生效默认方向为 horizontal（未注入 Theme 时 Flex.direction == horizontal）。
- [ ] circle 尺寸 Demo 显式展示 24/28/32，Button Loading 保持默认 20。
- [ ] 公开 Demo 的三个分组、实例顺序和文案与小程序一致，custom 指示器不单独扩展分组。
- [x] 明暗主题整页 Golden 已在 Flutter 3.32.0 Linux CI 复现通过，且已与小程序实际页面截图完成人工比对。
- [ ] 站点 README 链接、API 表、示例代码已修正，`loading_api.md` 与 README 一致。
- [ ] Loading 全部手写生产源码行覆盖率 ≥95% 且不低于修改前基线（86.15%）。
- [ ] `flutter analyze --fatal-infos` 0 error / 0 warning。
- [ ] 双版本（Flutter 3.32.0 / latest）focused tests 通过。
