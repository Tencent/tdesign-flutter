# 实施方案

## 技术方案

### 1. 新增 `TOverlayConfig` 类

在 `t_toast.dart` 中新增公开类：

```dart
class TOverlayConfig {
  final bool showOverlay;
  final Color? color;
  final double opacity;
  final bool preventTap;
  const TOverlayConfig({
    this.showOverlay = false,
    this.color,
    this.opacity = 0.2,
    this.preventTap = false,
  });
}
```

### 2. 新增 `TToastPlacement` 枚举

```dart
enum TToastPlacement {
  top,
  middle,
  bottom,
}
```

映射对齐常量：

```dart
FractionalOffset _placementOffset(TToastPlacement p) {
  switch (p) {
    case TToastPlacement.top:
      return const FractionalOffset(0.5, 0.25); // 距顶 25%
    case TToastPlacement.bottom:
      return const FractionalOffset(0.5, 0.75); // 距底 25%
    case TToastPlacement.middle:
      return const FractionalOffset(0.5, 0.5); // 正中
  }
}
```

与小程序 / mobile-vue 一致的**垂直百分比偏移 + 水平恒居中**定位：top 距顶 25%、middle 正中 50%、bottom 距底 25%。百分比定位天然避让安全区，**无需叠加 SafeArea**。

### 3. showXxx 签名扩展（不兼容收敛版）

- `showText` / `showIconText` / `showLoading` / `showLoadingWithoutText`：
  - 接收 `TOverlayConfig? overlay`
  - 保留 `TToastPlacement placement = TToastPlacement.middle`
- `showSuccess` / `showWarning` / `showFail`：委托 `showIconText` 时透传 `overlay` / `placement`。
- **移除旧 `bool? preventTap` 参数**：拦截点击只能通过 `overlay: TOverlayConfig(preventTap: true)` 开启，形成单一真源（breaking change）。

### 4. `_showOverlay` 统一解析

```dart
static void _showOverlay(
  Widget? widget, {
  required BuildContext context,
  Duration duration = const Duration(milliseconds: 2000),
  TOverlayConfig? overlay,
  TToastPlacement placement = TToastPlacement.middle,
  required String toastId,
}) {
  // ...
  final cfg = overlay ?? const TOverlayConfig();
  final finalPreventTap = cfg.preventTap; // 单一真源，拦截统一由 TOverlayConfig 决定
  final showMask = cfg.showOverlay;
  final maskColor = showMask
      ? (cfg.color ?? Colors.black.withValues(alpha: cfg.opacity))
      : Colors.transparent;

  // 需要拦点击或显示可见蒙层 → Stack + 全屏蒙层
  if (finalPreventTap || showMask) {
    overlayEntry = OverlayEntry(
      builder: (context) => captured.wrap(
        Stack(
          children: [
            Positioned.fill(child: Container(color: maskColor)),
            Align(alignment: placementOffset, child: widget),
          ],
        ),
      ),
    );
  } else {
    overlayEntry = OverlayEntry(
      builder: (context) => captured.wrap(
        Align(alignment: placementOffset, child: widget),
      ),
    );
  }
}
```

> 注意：已移除旧的 `bool? preventTap`，拦截点击唯一入口为 `TOverlayConfig.preventTap`（不兼容收敛版）。

### 5. 示例页对齐小程序 demo

在 `t_toast_page.dart` 中补齐小程序 toast demo 分组：

- **基础提示**：纯文字、多行文字、竖向图标、加载状态（无文字）、加载状态自定义
- **组件状态**：成功、警告、失败
- **显示遮罩**：`showOverlay` 半透明蒙层 + 拦点击
- **手动关闭**：`duration` 短时长 + `dismissToast`
- **展示位置**：top / middle / bottom

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | tdesign-component/lib/src/components/toast/t_toast.dart | 新增 TOverlayConfig / TToastPlacement，扩展 showXxx 签名，重写 _showOverlay |
| 测试 | tdesign-component/test/components/toast/t_toast_test.dart | 新增 overlay / placement 用例 |
| 示例 | tdesign-component/example/lib/page/t_toast_page.dart | 对齐小程序 demo |
| 站点文档 | tdesign-site/docs/components/toast/README.md | **本次不含**：站点 README 文档变更已从 PR 中移出，留待独立 PR 处理（避免与功能变更混入） |

## API 变化

- 新增公开类 `TOverlayConfig`（非 breaking）。
- 新增公开枚举 `TToastPlacement`（非 breaking）。
- 保留可选参数 `overlay` / `placement`（默认值保证向后兼容，非 breaking）。
- **移除 `preventTap: bool?` 参数**（**breaking change**）：迁移为 `overlay: TOverlayConfig(preventTap: true)`。

## 风险与取舍

- `Colors.black.withValues(alpha:)` 需 Flutter 3.27+；项目基线 3.32.0 满足，latest 满足。
- placement 采用垂直百分比偏移（25% / 50% / 75%），与小程序 / mobile-vue 一致。旧实现为固定 `Center` 居中（并未叠加 SafeArea），新实现改为百分比定位，同样天然避让安全区（刘海屏 / 挖孔屏 / 底部手势条），无需叠加 SafeArea。
- **breaking change**：移除 `bool? preventTap` 参数，更新日志使用 `breaking` commit type（`- breaking(toast): 移除 preventTap 参数，改用 overlay`）提醒用户迁移。

## 验证策略

- Widget 测试覆盖：
  - showOverlay 可见蒙层、placement 对齐、TOverlayConfig.preventTap 拦截与 showOverlay 解耦；
  - 各 `showXxx`（showIconText / showSuccess / showWarning / showFail / showLoading / showLoadingWithoutText）透传 `overlay` / `placement`；
  - `TOverlayConfig` 默认值契约（默认 opacity 0.2、两者均关闭时不渲染蒙层）；
  - `placement` 与 `overlay` 组合时位置仍生效。
- 运行 `flutter analyze lib/src/components/toast`。
- 运行 toast 相关测试：`flutter test test/components/toast/t_toast_test.dart`（47 个用例）。
- 运行 `git diff --check`。
