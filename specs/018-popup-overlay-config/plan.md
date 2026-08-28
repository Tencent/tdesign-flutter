# Popup 蒙层配置收敛 - 实施方案

## 技术方案

### 1. 新增 `TPopupOverlayConfig` 类

在 `t_popup_types.dart` 中新增公开类：

```dart
class TPopupOverlayConfig {
  final bool showOverlay;   // 是否显示可见半透明蒙层（默认 true）
  final Color? color;       // 蒙层颜色（null → black54）
  final double? opacity;    // 蒙层透明度系数（null → 不调整）
  final bool preventTap;    // 是否拦截背景交互（默认 true，替代原 modal）
  final bool? closeOnClick; // 点击可见蒙层是否关闭
  final VoidCallback? onClick; // 可见蒙层点击回调
  const TPopupOverlayConfig({...});
  bool get effectiveCloseOnClick =>
      showOverlay && preventTap && (closeOnClick ?? true);
}
```

### 2. `TPopupOptions` 收敛

- 移除构造器及各命名工厂上的 `showOverlay` / `closeOnOverlayClick` / `overlayColor` / `overlayOpacity` / `modal` / `onOverlayClick` 六个散参。
- 新增 `TPopupOverlayConfig? overlay` 参数。
- 内部保留 `TPopupOverlayConfig get overlayConfig => overlay ?? const TPopupOverlayConfig();` 访问器。
- 移除 `_closeOnOverlayClick` 私有字段和 `closeOnOverlayClick` getter。
- 移除 `_validatePlacementParams` 中的 `showOverlay && !modal` 校验（解耦）。

### 3. `_popup_route.dart` 改动

- `_barrierMode` / `_barrierColor` / `buildModalBarrier` / `_handleOverlayTap` 全部改用 `options.overlayConfig`。
- `showOverlay=false` 或 `preventTap=false` 时不响应蒙层点击配置；`preventTap=false` 的视觉蒙层只负责绘制并允许事件穿透。

### 4. `t_popup.dart` theme 合并

- `TPopup.show` 中把 theme 的 `barrierColor` / `barrierOpacity` 合并进 overlay config。

### 5. ActionSheet / Dialog / Drawer 适配

- 各组件改用 `TPopupOverlayConfig` 构造蒙层配置。

### 6. 导出与文档

- `tdesign_flutter.dart` 导出 `TPopupOverlayConfig`。
- 更新站点 README 的 API 表格。

## 影响范围

| 范围 | 文件 | 影响 |
| --- | --- | --- |
| 组件 | `t_popup_types.dart` | 新增 `TPopupOverlayConfig` |
| 组件 | `t_popup_options.dart` | 收敛散参，新增 `overlay` |
| 组件 | `_popup_route.dart` | 改用 overlayConfig |
| 组件 | `t_popup.dart` | theme 合并逻辑 |
| 组件 | `t_action_sheet.dart` | 适配新 API |
| 组件 | `t_dialog.dart` | 适配新 API |
| 组件 | `t_drawer.dart` | 适配新 API |
| 导出 | `tdesign_flutter.dart` | 导出 `TPopupOverlayConfig` |
| 测试 | `t_popup_options_contract_test.dart` | 新增 overlay 契约测试 |
| 测试 | `t_popup_test.dart` / `t_popup_coverage_test.dart` | 适配新 API |
| 文档 | `tdesign-site/docs/components/popup/README.md` | 更新 API 表格 |

## API 变化

- 新增公开类 `TPopupOverlayConfig`（非 breaking）。
- **移除六个散参**（**breaking change**）：`showOverlay`、`closeOnOverlayClick`、`overlayColor`、`overlayOpacity`、`modal`、`onOverlayClick` 统一收敛为 `overlay: TPopupOverlayConfig(...)`。
- **行为变化**：`showOverlay=true, preventTap=false` 成为合法配置（不再强制 `showOverlay` 必须 `preventTap=true`）。

## 风险与取舍

- `Colors.black54` 作为默认蒙层颜色保持不变（通过 `color == null` 时的 fallback）。
- `overlay` 为 null 时行为与现状一致。
- `opacity` 与 `color` 的组合逻辑与现状一致：`color` 决定基础色，`opacity` 作为 alpha 系数。

## 验证策略

- 更新现有测试适配新 API。
- 新增 `TPopupOverlayConfig` 默认值与解耦行为测试。
- 运行 `flutter analyze` 与相关测试。
