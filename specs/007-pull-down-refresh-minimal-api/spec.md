# PullDownRefresh：以最小化、Flutter 模式 API 重新设计（对齐官方行为）

## 背景

Issue #81 的跨端对照 Review 结论：Flutter 当前 `TRefreshHeader` 是一个**直接透传 easy_refresh `Header` 约 40 个参数**的裸壳，API 面巨大且不收敛；同时缺失官方（小程序 / mobile-vue）明确提供的多项能力：

- `loadingTexts`（四态提示语自定义）
- `refreshTimeout` + `timeout`/`onTimeout`（刷新超时）
- `value` / `defaultValue` + `change`/`onChange`（受控刷新状态）
- `maxBarHeight`（最大下拉高度，默认 80）
- `scrolltolower` + `lowerThreshold`（触底加载）
- `disabled`（禁用）
- `loadingProps`（loading 指示器全量定制）
- 尺寸默认值偏差（`extent/triggerDistance=48` vs 官方 `loadingBarHeight=50`）

同时存在站点文档死链、示例代码与现网不一致、英文 l10n 缺空格等问题。

需求（用户原话）：**"按照最小的 API 实现，而且要符合 Flutter 的模式，但最后的表现一致的行为"**——即用**最小、Flutter 惯用**的 API 重新设计下拉刷新，同时保持与官方一致的**最终行为表现**。

## 目标

- 新增顶层组件 **`TPullDownRefresh`**，在内部封装 `EasyRefresh`，对外只暴露**最小、经设计的 Flutter 惯用 API**，替代直接透传 easy_refresh 参数的裸 `TRefreshHeader` 用法。
- 对齐官方能力：
  - `onRefresh`（对应 `refresh` 事件）
  - `onLoadMore` / `enableLoadMore`（对应 `scrolltolower`）
  - `disabled`（对应 `disabled`）
  - `texts`（对应 `loadingTexts`，四态文案）
  - `refreshTimeout` + `onTimeout`（对应 `refreshTimeout` + `timeout`）
  - `loadingBarHeight`（默认 50）+ `maxBarHeight`（默认 80），对齐官方尺寸
  - `loadingTheme`（复用 `TLoadingThemeData`，对应 `loadingProps`）
  - `onStateChanged`（对应 `change`/`onChange`）
  - `controller`（`TPullDownRefreshController`，对应官方受控 `value`，用 Flutter 控制器惯用法表达）
- 修复 Review 发现的文档 / l10n 问题：站点文档死链与示例不一致、英文文案缺空格。
- 保持 `flutter@3.32.0` 与 `flutter@latest` 双版本兼容，`flutter analyze` 0 error / 0 warning。

## 非目标

- 不保留 `TRefreshHeader` 直接暴露 easy_refresh 全部透传参数的能力（收敛为 `TPullDownRefresh` 的受控子集）。
- 不实现 easy_refresh 的高级二阶页（secondary）、多 footer 类型等非官方 TDesign 能力。
- 不实现 mp 特有的 `header` slot、`t-class-*` 外置类（mp 专属高级能力，非三端共性）。
- 不处理 Android / iOS 原生差异（交由 easy_refresh 与 Flutter 框架负责）。
- 不修改 `tdesign-component/CHANGELOG.md`（CLI 自动生成）。

## 范围

### 涉及

- tdesign-component/lib/src/components/refresh/t_pull_down_refresh.dart（新增，核心组件）
- tdesign-component/lib/src/components/refresh/t_pull_down_refresh_controller.dart（新增，受控控制器）
- tdesign-component/lib/src/components/refresh/t_pull_down_refresh_texts.dart（新增，四态文案）
- tdesign-component/lib/src/components/refresh/t_refresh_header.dart（保留：向后兼容的低层 Header，站点文档与示例迁移到 `TPullDownRefresh`）
- tdesign-component/lib/tdesign_flutter.dart（导出新增公开类）
- tdesign-component/test/components/refresh/t_refresh_test.dart（对齐新增组件测试）
- tdesign-component/example/lib/page/t_refresh_page.dart（改用 `TPullDownRefresh` 并补官方 demo 分组）
- tdesign-component/example/lib/l10n/app_en.arb（修正英文缺空格）
- tdesign-site/docs/components/pull-down-refresh/README.md（修正死链与示例代码不一致）

### 不涉及

- 其他列表 / 滚动组件
- 站点文档以外的其他文档仓库
- `tdesign-component/CHANGELOG.md`

## 行为契约

### TPullDownRefresh（顶层组件）

```dart
class TPullDownRefresh extends StatefulWidget {
  const TPullDownRefresh({
    Key? key,
    required this.child,
    this.onRefresh,
    this.onLoadMore,
    this.enableLoadMore = false,
    this.disabled = false,
    this.controller,
    this.texts,
    this.refreshTimeout,
    this.onTimeout,
    this.loadingBarHeight = 50,
    this.maxBarHeight = 80,
    this.loadingTheme,
    this.backgroundColor,
    this.onStateChanged,
  });
}
```

字段语义：

- `child`：必填，滚动内容（对应官方默认 slot）。
- `onRefresh`：`FutureOr<void> Function()?`，下拉触发刷新（对应 `refresh` 事件）。为空时禁用刷新。
- `onLoadMore`：`FutureOr<void> Function()?`，触底加载（对应 `scrolltolower`）。仅在 `enableLoadMore == true` 且非空时启用。
- `enableLoadMore`：默认 `false`，是否启用触底加载。
- `disabled`：默认 `false`，禁用下拉刷新（仍保留滚动）。
- `controller`：`TPullDownRefreshController?`，受控刷新 / 加载控制器。
- `texts`：`TPullDownRefreshTexts?`，四态提示语；为空时回退 l10n。
- `refreshTimeout`：`Duration?`，刷新超时；超过时长仍未完成 `onRefresh` 时触发 `onTimeout` 并结束刷新。为空时不启用超时（默认不启用，与现状一致）。
- `onTimeout`：`VoidCallback?`，刷新超时回调。
- `loadingBarHeight`：默认 `50`（对齐官方），Header 容器高度 = 触发阈值。
- `maxBarHeight`：默认 `80`（对齐官方），最大下拉高度（阻尼上限）。
- `loadingTheme`：`TLoadingThemeData?`，loading 指示器样式（对齐官方 `loadingProps`）。
- `backgroundColor`：`Color?`，Header 背景色（对齐官方 CSS 变量 `--td-pull-down-refresh-color`）。
- `onStateChanged`：`void Function(TPullDownRefreshState)?`，状态变化回调（对应 `change`/`onChange`），值域为 `TPullDownRefreshState`（inactive / dragging / ready / refreshing / done / timeout）。

### TPullDownRefreshState

```dart
enum TPullDownRefreshState {
  inactive,   // 未触发
  dragging,   // 下拉中（未达阈值）
  ready,      // 松手触发（达阈值）
  refreshing, // 刷新中
  done,       // 刷新完成 / 展示完成态
  timeout,    // 刷新超时
}
```

- 映射自 easy_refresh `IndicatorMode`：`inactive/done` → `inactive`、`drag` → `dragging`、`armed/ready` → `ready`、`processing` → `refreshing`、`processed` → `done`。
- 刷新完成（`onRefresh` 返回）后展示完成态，再回到 `inactive`。

### TPullDownRefreshController

```dart
class TPullDownRefreshController {
  Future<void> refresh();       // 外部触发刷新（受控 value=true）
  Future<void> loadMore();      // 外部触发触底加载
  void finishRefresh();         // 结束刷新（受控 value=false）
  void finishLoadMore();        // 结束加载
  void reset();                 // 复位 Header / Footer
  void dispose();
}
```

- `refresh()` 对应官方受控 `value=true`，`finishRefresh()` 对应 `value=false`；刷新过程状态由 `onStateChanged` 通知。

### TPullDownRefreshTexts

```dart
class TPullDownRefreshTexts {
  final String pullToRefresh;    // 下拉刷新
  final String releaseToRefresh; // 松手刷新
  final String refreshing;       // 正在刷新
  final String refreshComplete;  // 刷新完成
  const TPullDownRefreshTexts({...});
}
```

- 缺省回退 l10n（`context.resource.pullToRefresh` / `releaseRefresh` / `refreshing` / `completeRefresh`）。
- 中文默认 `下拉刷新 / 松手刷新 / 正在刷新 / 刷新完成`，与官方 `loadingTexts` 默认一致。

### 默认值对齐（与官方一致）

| 参数 | 官方小程序 | mobile-vue | TPullDownRefresh（新） |
|---|---|---|---|
| 加载条高度 | `loadingBarHeight=50` | `50` | `loadingBarHeight=50` |
| 触发阈值 | =50 | =50 | =`loadingBarHeight`(50) |
| 最大下拉 | `maxBarHeight=80` | `80` | `maxBarHeight=80` |
| 完成停留 | `successDuration=500`ms | 300ms | 内部取 easy_refresh 完成动画（默认 500ms，对齐 mp） |
| loading 尺寸 | 50rpx≈25px | 24px | `TLoadingSize.medium`（默认，可用 `loadingTheme` 覆盖） |

> 说明：将默认 `extent/triggerDistance` 从 48 调整为官方 50，属**潜在视觉 breaking**（默认渲染高度变化），在 Spec 中明确标注。

### 兼容性

- 新增 `TPullDownRefresh`、`TPullDownRefreshController`、`TPullDownRefreshTexts`、`TPullDownRefreshState` 均为**新增公开类**（非 breaking）。
- 兼容性：`TRefreshHeader` 保留为低层 Header（向后兼容，不删除现有参数）；新增 `TPullDownRefresh` 为**推荐的最小化公开入口**，站点文档与示例统一迁移到 `TPullDownRefresh`。直接使用 `TRefreshHeader` 的低层用法仍可用，但不再推荐。
- 尺寸默认值 48 → 50：`TPullDownRefresh` 默认 `loadingBarHeight=50`，影响默认渲染表现，属潜在视觉 breaking，需在日志中注明。

### TRefreshHeader（保留，向后兼容）

- 保留 `TRefreshHeader extends Header`，不删除现有参数，低层直接配合 `EasyRefresh` 使用仍可用。
- 站点文档 / 示例推荐入口迁移到 `TPullDownRefresh`。

## 验收标准

- [x] `TPullDownRefresh` / `TPullDownRefreshController` / `TPullDownRefreshTexts` / `TPullDownRefreshState` 公开导出。
- [ ] 默认渲染：`loadingBarHeight=50`、`maxBarHeight=80`、触发阈值=50，Header 为 TDesign 样式。
- [ ] `onRefresh` 生效：下拉松手触发，完成后展示完成态并复位；`onRefresh == null` 时禁用刷新。
- [ ] `disabled == true` 时禁用下拉刷新（保留滚动）。
- [ ] `texts` 覆盖四态文案，缺省回退 l10n；中文默认与官方 `loadingTexts` 一致。
- [ ] `refreshTimeout` + `onTimeout` 生效：超时未完成时触发 `onTimeout` 并结束刷新。
- [ ] `onLoadMore` + `enableLoadMore` 生效（触底加载），`enableLoadMore == false` 时禁用。
- [ ] `controller.refresh()` / `finishRefresh()` / `loadMore()` / `finishLoadMore()` 生效。
- [ ] `onStateChanged` 按状态变化回调（inactive/dragging/ready/refreshing/done/timeout）。
- [ ] `loadingTheme` / `backgroundColor` 生效。
- [ ] 示例页 `t_refresh_page.dart` 改用 `TPullDownRefresh` 并补齐官方 demo 分组（基础刷新 / 自定义提示语 / 超时）。
- [ ] 英文 l10n 修正（`Release Refresh` / `Pull To Refresh` / `Refresh Completed` 加空格）。
- [ ] 站点 README 死链与示例代码不一致修正。
- [ ] `flutter analyze`（组件 + 示例）0 error / 0 warning；`git diff --check` 通过。
- [ ] refresh 相关 Widget / 单元测试通过。
