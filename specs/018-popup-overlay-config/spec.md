# Popup：收敛蒙层散参到 `TPopupOverlayConfig`

## 背景

在 Popup 跨端 Review（Issue #72）与 Toast 收敛 `TOverlayConfig`（Spec 006）之后，Popup 的蒙层配置仍以**散参平铺**形式存在于 `TPopupOptions` 上：`showOverlay`、`closeOnOverlayClick`、`overlayColor`、`overlayOpacity`、`modal`、`onOverlayClick` 六个字段直接散落在构造器与各命名工厂签名中。

问题：
1. **冗余**：六个蒙层字段在每个命名工厂（bottom/center/top/left/right）里重复出现，签名膨胀。
2. **与 Toast 命名割裂**：Toast 已用 `TOverlayConfig` 具名类收敛蒙层行为，Popup 仍平铺，仓库内两套风格不一致。
3. **无法扩展**：未来要增加 `zIndex` / `blur` / 背景滚动拦截等蒙层能力，需要逐个命名工厂加参数，无法在配置类中扩展。
4. **`modal` 与 `showOverlay` 强耦合**：现有校验 `showOverlay=true requires modal=true`，不允许"显示蒙层但不拦截交互"，与 Toast 的 `showOverlay`/`preventTap` 解耦设计不一致。

## 目标

- 新增公开类 `TPopupOverlayConfig`，统一收敛 Popup 蒙层行为：是否显示可见蒙层（`showOverlay`）、蒙层颜色（`color`）、透明度（`opacity`）、是否拦截背景交互（`preventTap`，替代原 `modal`）、点击蒙层是否关闭（`closeOnClick`，替代原 `closeOnOverlayClick`）、蒙层点击回调（`onClick`，替代原 `onOverlayClick`）。
- **收敛散参**：从 `TPopupOptions` 及各命名工厂移除 `showOverlay`、`closeOnOverlayClick`、`overlayColor`、`overlayOpacity`、`modal`、`onOverlayClick`，统一收敛到 `TPopupOverlayConfig` 单一口子（单一真源，不兼容收敛版）。
- 每个 `TPopupOptions` 构造器只保留 **1 个可选参数** `TPopupOverlayConfig? overlay`（默认 null，未传时行为与现状一致）。
- 保持 `showOverlay` 与 `preventTap` **解耦**（与 Toast 一致）：允许 `showOverlay=true, preventTap=false`（显示蒙层但不拦截背景交互）。
- 在 `t_popup.dart` 的 `TPopup.show` 中统一解析 theme 的 `barrierColor`/`barrierOpacity` 作为 `TPopupOverlayConfig.color`/`opacity` 的默认值。

## 非目标

- 不新增 `overlayProps` 平铺散参数（用 `TPopupOverlayConfig` 具名类收敛，与 Toast 先例一致）。
- 不实现 `zIndex` / `blur` / `preventScrollThrough` 等高级蒙层能力（留作 `TPopupOverlayConfig` 未来扩展字段）。
- 不改动 ActionSheet / Dialog / Drawer 对 Popup 的调用（它们会在本次迁移中改用新的 `overlay` 参数，但这是适配而非新功能）。
- 不实现非 center 方向的 `closeBtn` 关闭按钮能力（列为后续项）。

## 范围

### 涉及

- `tdesign-component/lib/src/components/popup/t_popup_options.dart`
- `tdesign-component/lib/src/components/popup/t_popup_types.dart`（新增 `TPopupOverlayConfig`）
- `tdesign-component/lib/src/components/popup/_popup_route.dart`
- `tdesign-component/lib/src/components/popup/t_popup.dart`（`show` 方法中 theme 合并逻辑）
- `tdesign-component/lib/tdesign_flutter.dart`（导出 `TPopupOverlayConfig`）
- `tdesign-component/lib/src/components/action_sheet/t_action_sheet.dart`（适配新参数）
- `tdesign-component/lib/src/components/dialog/t_dialog.dart`（适配新参数）
- `tdesign-component/lib/src/components/drawer/t_drawer.dart`（适配新参数）
- `tdesign-component/test/components/popup/t_popup_options_contract_test.dart`
- `tdesign-component/test/t_popup_test.dart`
- `tdesign-component/test/t_popup_coverage_test.dart`
- `tdesign-site/docs/components/popup/README.md`（同步新 API 文档）

### 不涉及

- 其他 Overlay 组件（ActionSheet / Dialog / Drawer 的内部蒙层实现本身，仅适配 Popup 新 API）
- `tdesign-component/CHANGELOG.md`（由 CLI 自动生成）

## 行为契约

### TPopupOverlayConfig

新增公开类：

```dart
class TPopupOverlayConfig {
  /// 是否显示可见半透明蒙层（默认 true）。
  final bool showOverlay;

  /// 蒙层颜色；为 null 时用默认 black54。
  final Color? color;

  /// 蒙层透明度系数（0–1）；为 null 时不额外调整透明度。
  final double? opacity;

  /// 是否拦截背景交互（默认 true，替代原 modal）。
  final bool preventTap;

  /// 点击可见蒙层是否关闭；仅在 [showOverlay] 与 [preventTap] 均为 true 时生效。
  final bool? closeOnClick;

  /// 可见蒙层点击回调；仅在 [showOverlay] 与 [preventTap] 均为 true 时触发。
  final VoidCallback? onClick;

  const TPopupOverlayConfig({
    this.showOverlay = true,
    this.color,
    this.opacity,
    this.preventTap = true,
    this.closeOnClick,
    this.onClick,
  });

  /// 解析后的点击可见蒙层是否关闭。
  bool get effectiveCloseOnClick =>
      showOverlay && preventTap && (closeOnClick ?? true);
}
```

### TPopupOptions 改动

- 移除构造器及各命名工厂（bottom/center/top/left/right）上的 `showOverlay`、`closeOnOverlayClick`、`overlayColor`、`overlayOpacity`、`modal`、`onOverlayClick` 六个散参。
- 新增可选参数 `TPopupOverlayConfig? overlay`（默认 null）。
- `overlay == null` 时使用 `const TPopupOverlayConfig()` 默认值，行为与现状一致（showOverlay=true, preventTap=true, closeOnClick跟随, 无回调）。
- 保留 `copyWith` 中 `overlay` 字段的三态处理（`_unset` sentinel）。

### _popup_route.dart 改动

- `_barrierMode` 改为由 `options.overlay` 解析：
  - `overlay.preventTap == false` → `_PopupBarrierMode.nonModal`
  - `overlay.preventTap == true && overlay.showOverlay == true` → `_PopupBarrierMode.modalOverlay`
  - `overlay.preventTap == true && overlay.showOverlay == false` → `_PopupBarrierMode.modalTransparent`
- `_barrierColor` 改为：
  - `overlay.showOverlay == false` → `Colors.transparent`
  - 基础色 `overlay.color ?? Colors.black54`
  - `overlay.opacity != null` 时与基础色 alpha 相乘
- `buildModalBarrier` 中 `options.closeOnOverlayClick` → `overlay.effectiveCloseOnClick`
- `_handleOverlayTap` 中 `options.onOverlayClick` → `overlay.onClick`，`options.closeOnOverlayClick` → `overlay.effectiveCloseOnClick`
- `showOverlay=false` 或 `preventTap=false` 时没有可点击的可见蒙层，`closeOnClick` 与 `onClick` 不生效；视觉蒙层允许穿透时，点击由背景接收。

### t_popup.dart 改动

- `TPopup.show` 中 theme 合并逻辑改为解析 `TPopupOverlayConfig`：
  - `options.overlay?.color ?? theme?.barrierColor` → 传入新的 overlay config
  - `options.overlay?.opacity ?? theme?.barrierOpacity` → 传入新的 overlay config
- 若无 `options.overlay`，则用 theme 值构造 `TPopupOverlayConfig`。

### ActionSheet / Dialog / Drawer 适配

- 将 `showOverlay`/`closeOnOverlayClick`/`overlayColor` 改为构造 `TPopupOverlayConfig` 传入 `overlay` 参数。

### 兼容性（不兼容收敛版）

- 不传 `overlay` 时行为与现状完全一致（标准模态弹层）。
- **breaking change**：移除 `showOverlay`、`closeOnOverlayClick`、`overlayColor`、`overlayOpacity`、`modal`、`onOverlayClick` 六个散参。既有调用需迁移为 `overlay: TPopupOverlayConfig(...)`。
- **行为变化**：移除 `showOverlay=true requires modal=true` 的校验约束。现在 `showOverlay=true, preventTap=false` 是合法配置（显示蒙层但不拦截背景交互），与 Toast 的解耦设计一致。
- 更新日志中该条须加 `⚠️` 前置标记提醒用户迁移。

## 验收标准

- [ ] `TPopupOverlayConfig` 公开类存在，字段与默认值符合契约。
- [ ] `TPopupOptions` 构造器及各命名工厂均可接收 `overlay`，不传时行为与现状一致。
- [ ] `showOverlay`、`closeOnOverlayClick`、`overlayColor`、`overlayOpacity`、`modal`、`onOverlayClick` 六个散参已从 `TPopupOptions` 移除。
- [ ] `overlay.showOverlay: true` 时渲染可见半透明蒙层，颜色/透明度可由 `color` / `opacity` 控制。
- [ ] `overlay.preventTap` 拦截背景交互与 `showOverlay` 显示蒙层解耦；`preventTap=false, showOverlay=false` 时不渲染蒙层/拦截层。
- [ ] `overlay.effectiveCloseOnClick` 仅在显示且拦截蒙层点击时可为 true。
- [ ] `overlay.onClick` 仅在可点击的可见蒙层上正确触发；穿透模式不触发。
- [ ] theme 的 `barrierColor` / `barrierOpacity` 作为 `TPopupOverlayConfig.color` / `opacity` 的默认值生效。
- [ ] ActionSheet / Dialog / Drawer 迁移到新 API 后行为不变。
- [ ] Popup 相关单元 / Widget 测试通过。
- [ ] flutter analyze 与 git diff --check 通过。
