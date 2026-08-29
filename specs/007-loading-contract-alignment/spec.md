# Loading：默认值、尺寸、Demo 与文档调整

## 背景

在 Issue #70 的跨端对照 Review（见 `tdesign-component-align-review` skill）中，Flutter `TLoading` 与官方小程序（`tdesign-miniprogram@1.16.0`）/ Mobile Vue（`tdesign-mobile-vue@1.16.1`）的 Loading 存在以下核心差距：

1. **`duration` 默认值不一致**：官方默认 `800`ms，Flutter 默认 `2000`ms，转圈明显偏慢。
2. **`layout` 默认方向不一致**：官方默认 `horizontal`（图标在左、文字在右），Flutter 默认 `Axis.vertical`（图标在上、文字在下）。
3. **三种图标尺寸内部不一致**：同一 `TLoadingSize` 下 circle / activity / point 直径彼此不一致（如 large：circle 24 / activity 26 / point 20），且 circle 与尺寸 demo（20/22/26px）相比偏小。
4. **站点文档多处过时/不一致**：示例文件链接笔误、`axis/iconColor/textColor/duration` 误列为 `TLoading` 构造参数（实际在 `TLoadingThemeData`）、示例代码与源码不符、`loading_api.md` 与 README 分叉。

## 目标

- 对齐 `duration` 默认值 800ms、`axis` 默认方向 horizontal（对齐官方 `layout` 默认）。
- 统一 circle / activity 图标在各 `TLoadingSize` 下的容器直径，对齐官方尺寸 demo（20/22/26px）。
- 按小程序公开页收敛 Demo 分组与实例顺序：纯图标中合并 custom 指示器，尺寸合并为一个完整示例（复用已有能力，不加新 API）。
- 修正站点 README 与 `loading_api.md` 的过时/分叉内容。

## 非目标

- **不新增** `reverse` / `pause` / `delay` 属性（官方发布版未公开展示这三个属性对应 Demo，按"最小 API 扩充 + 不为未发布 Demo 加一次性参数"原则，本期不实现，列为后续）。
- **不实现** `attach`（仅 Vue 独有且发布版注释"视觉稿待定"）。
- 不改变 `TLoadingSize` / `TLoadingIcon` 枚举的定义与命名。
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

- `t_circle_indicator.dart` / `t_point_indicator.dart` / `t_activity_indicator.dart` 的公开 API（仅 `t_loading.dart` 内部传入的尺寸常量调整）
- 其他组件与站点整体结构

## 行为契约

### 1. `duration` 默认值 2000 → 800

- `TLoadingThemeData.duration` 的**生效默认值**从 `2000` 调整为 `800`（`t_loading.dart` `_effectiveTheme` 内 `theme.duration ?? 2000` → `?? 800`）。
- `t_loading_theme_data.dart` 的 `duration` 字段 dartdoc 说明默认对齐官方 `800ms`。
- 保持 `duration > 0` 才生效的既有语义（`innerDuration = effectiveDuration > 0 ? effectiveDuration : 1`）。

### 2. `axis` 默认方向 vertical → horizontal

- `_effectiveTheme` 中 `theme.axis ?? Axis.vertical` 调整为 `theme.axis ?? Axis.horizontal`。
- 显式传入 `axis` 或注入 `TLoadingThemeData(axis:)` 时行为不变。
- 间距语义保持不变（horizontal 用横向间距、vertical 用纵向间距）。

### 3. 尺寸统一

- circle 图标三档容器直径从 `18/21/24` 调整为 `20/22/26`，与 activity（已对齐官方 20/22/26）一致。
- `_getPaddingSize()` 与 point 指示器保持不变（point 的 `size` 语义与官方 dots 不同，官方 dots 无三档尺寸 Demo 依据，不做无依据调整）。

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

- **`duration` 默认 2000→800**：所有使用默认动画速度的调用转圈变快，属用户可感知的视觉行为变化。更新日志须加 `⚠️` 前置标记。
- **`axis` 默认 vertical→horizontal**：未显式指定方向的默认调用从"图标在上文字在下"变为"图标在左文字在右"，属**明确 breaking change**。更新日志须加 `⚠️` 前置标记并建议显式传 `axis: Axis.vertical` 保留原行为。

### 非 breaking

- circle 尺寸调整不改变 API 签名，仅内部视觉常量。
- 不新增公开 API；`TLoadingController.show` 保持原有签名。

## 验收标准

- [ ] `duration` 生效默认值从 2000 改为 800（未注入 Theme 时 circle indicator duration == 800）。
- [ ] `axis` 生效默认方向为 horizontal（未注入 Theme 时 Flex.direction == horizontal）。
- [ ] circle 三档容器直径统一为 20/22/26。
- [ ] 公开 Demo 的三个分组、实例顺序和文案与小程序一致，custom 指示器不单独扩展分组。
- [ ] 明暗主题整页 Golden 在 Flutter 3.32.0 Linux 可复现，且与小程序实际页面截图完成人工比对。
- [ ] 站点 README 链接、API 表、示例代码已修正，`loading_api.md` 与 README 一致。
- [ ] Loading 全部手写生产源码行覆盖率 ≥95% 且不低于修改前基线（86.15%）。
- [ ] `flutter analyze --fatal-infos` 0 error / 0 warning。
- [ ] 双版本（Flutter 3.32.0 / latest）focused tests 通过。
