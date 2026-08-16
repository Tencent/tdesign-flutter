# 实施方案

## 技术方案

### 1. `duration` 默认值 2000 → 800

`t_loading.dart` `_effectiveTheme` 内：

```dart
final effectiveDuration = theme.duration ?? 2000;
```
改为：
```dart
final effectiveDuration = theme.duration ?? 800;
```

同步 `t_loading_theme_data.dart` `duration` 字段 dartdoc 默认说明为 `800`。

### 2. `axis` 默认方向 vertical → horizontal

`t_loading.dart` `_contentWidget` 内：

```dart
final effectiveAxis = theme.axis ?? Axis.vertical;
```
改为：
```dart
final effectiveAxis = theme.axis ?? Axis.horizontal;
```

### 3. `TLoadingController.show` 新增 `overlay`

在 `t_loading_controller.dart` 的 `show` 增加可选参数 `TOverlayConfig? overlay`，复用 toast 的 `TOverlayConfig`：

```dart
static void show(
  BuildContext context, {
  Widget? child,
  TLoadingSize size = TLoadingSize.medium,
  TLoadingIcon? icon = TLoadingIcon.circle,
  String? text,
  TLoadingThemeData? theme,
  TOverlayConfig? overlay,
}) {
  // ...
  final cfg = overlay ?? const TOverlayConfig();
  final showMask = cfg.showOverlay;
  final maskColor = showMask
      ? (cfg.color ?? Colors.black.withValues(alpha: cfg.opacity))
      : Colors.transparent;
  // 需要拦点击或显示可见蒙层 → Stack + 全屏蒙层
  if (cfg.preventTap || showMask) {
    // Positioned.fill(Container(color: maskColor)) + Center(loadingWidget)
  } else {
    // 原 Center(loadingWidget)
  }
}
```

需要 import `../toast/t_toast.dart`（或从 tdesign_flutter 顶层复用）。检查 `TOverlayConfig` 的可见性——它是 toast 组件内的公开类，需确认从 loading 侧可引用。若 `TOverlayConfig` 位于 `t_toast.dart` 且被 `tdesign_flutter.dart` 顶层导出，则直接 import toast 文件即可。

### 4. 尺寸统一（circle → 20/22/26）

`t_loading.dart` `_getCircleIndicator`：

```dart
case TLoadingSize.large: size: 26, lineWidth: ...
case TLoadingSize.medium: size: 22, lineWidth: ...
case TLoadingSize.small: size: 20, lineWidth: ...
```

保持 lineWidth 等比缩放逻辑。与 activity 直径（20/22/26）对齐。

### 5. Demo 补充 custom 指示器

`t_loading_page.dart` 纯图标分组新增：

```dart
@ExampleCode(group: 'loading')
Widget _buildCustomIconLoading(BuildContext context) {
  return Theme(
    data: Theme.of(context).mergeExtension(...),
    child: const TLoading(
      size: TLoadingSize.small,
      customIcon: SizedBox(...自定义图标...),
    ),
  );
}
```

### 6. 文档修正

修正 `tdesign-site/docs/components/loading/README.md` 与 `example/assets/api/loading_api.md`。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `t_loading.dart` | duration 默认、axis 默认、circle 尺寸 |
| 组件 | `t_loading_controller.dart` | `show` 新增 `overlay` 参数 |
| 组件 | `t_loading_theme_data.dart` | `duration` dartdoc 默认说明 |
| 测试 | `t_loading_test.dart` | 补充 duration/axis/overlay/尺寸分支，提升覆盖率 |
| 示例 | `t_loading_page.dart` | 补 custom 指示器 Demo |
| 生成示例 | `example/assets/code/` | 随示例源码自动生成 |
| 文档 | `example/assets/api/loading_api.md` | 收敛与 README 一致 |
| 文档 | `tdesign-site/docs/components/loading/README.md` | 修正链接/API 表/示例代码 |

## API 变化

- **新增可选参数** `TLoadingController.show(..., TOverlayConfig? overlay)`（非 breaking）。
- **breaking change**：`duration` 默认 2000→800、`axis` 默认 vertical→horizontal（更新日志加 `⚠️`）。
- circle 尺寸内部常量调整（非 API 变化）。

## 风险与取舍

- `TOverlayConfig` 复用 toast 组件：需确认其从 loading 侧可 import（位于 `t_toast.dart`，公开类，顶层 `tdesign_flutter.dart` 已导出 toast 文件）。若 import 出现循环依赖，则在 loading 侧内联一份轻量配置或从公共模块提取；**优先复用** `TOverlayConfig` 保持跨组件一致。
- `Colors.black.withValues(alpha:)` 需 Flutter 3.27+，基线 3.32.0 / latest 均满足。
- `duration`/`axis` 默认值变更属 breaking，需在 PR 更新日志加 `⚠️` 并给出迁移建议。
- 覆盖率基线 86.15%（LF=260, LH=224），需补充 `t_loading_theme_data.dart`（5.0%）、`t_activity_indicator.dart`（80.7%）等用例提升至 ≥95%。
- point 尺寸不做调整（避免破坏其独立视觉体系与无官方三档依据）。

## 验证策略

- Widget 测试覆盖：默认 duration==800、默认 axis==horizontal、circle 三档尺寸 20/22/26、`TLoadingController.show` overlay 蒙层渲染与 preventTap、不传 overlay 时无蒙层。
- 覆盖率：`flutter test --coverage` 统计 `lib/src/components/loading/` 行覆盖率 ≥95%。
- 静态检查：`flutter analyze --fatal-infos` 0 error / 0 warning。
- 示例生成：`dart run tool/generate_example_code.dart --check` 保持 up-to-date。
- 双版本：Flutter 3.32.0 与 latest focused tests 通过。
