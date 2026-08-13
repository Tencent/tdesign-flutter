# 实施方案

## 技术方案

### 核心改动：单实例 + 精简 API

将 TToast 从"多实例 Map + toastId"模型重构为**单一实例**模型：

1. 用单个 `_ToastInstance? _currentInstance` 取代 `Map<String, _ToastInstance> _toastInstances`。
2. 删除 `_generateToastId()` 与 `_instanceCounter`。
3. 所有 show 方法移除 `toastId` 参数并改为返回 `void`。
4. 新增 `dismiss()` 关闭当前 Toast；`dismissAll()` 委托给 `dismiss()` 以兼容旧用法；删除 `dismissToast(toastId)`。
5. 简化 `_ToastInstance`：删除冗余的 `showing`、`disposeTimer`、`scheduleDispose`，自动关闭定时器到期后直接调用 `dismiss()`。

核心代码示意：

```dart
static _ToastInstance? _currentInstance;

// 展示新 Toast 前先移除旧的
static void _showOverlay(Widget widget, {required BuildContext context, Duration duration}) {
  final overlayState = Overlay.maybeOf(context);
  if (overlayState == null) { return; }
  dismiss(); // 单实例替换语义
  ...
  final instance = _ToastInstance(overlayEntry: overlayEntry);
  _currentInstance = instance;
  if (duration != const Duration(seconds: 99999999)) {
    instance.timer = Timer(duration, dismiss);
  }
}

static void dismiss() {
  _currentInstance?.cancel();
  _currentInstance = null;
}

static void dismissAll() => dismiss();
```

### 测试改动

更新 `t_toast_test.dart`：

- 删除使用 `toastId` 的用例（"同一 toastId 重复展示"、"不同 toastId 替换"）。
- 将 `dismissToast(id)` 改为 `dismiss()`。
- 保留并强化单实例替换用例（连续 show 多个只保留最新）。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | tdesign-component/lib/src/components/toast/t_toast.dart | 移除 toastId / Map / 生成器；新增 dismiss()；删除 dismissToast() |
| 测试 | tdesign-component/test/components/toast/t_toast_test.dart | 适配新 API |
| 示例 | tdesign-component/example/lib/page/t_toast_page.dart | showLoading 示例改用 dismiss() |

## API 变化（breaking change）

- 删除所有 show 方法的 `toastId` 参数。
- 删除 `dismissToast(String toastId)`。
- 所有 show 方法返回类型由 `String` 改为 `void`。
- 新增 `dismiss()`。

## 风险与取舍

- **Breaking change**：依赖 `toastId` / `dismissToast(id)` / show 方法返回值的调用方需要迁移到 `dismiss()` / 无返回值。考虑到 TDesign Mobile 的单实例设计以及本 issue 报告的叠加问题，这是更合理、更简洁的默认行为。
- **Dart 侧兼容**：`showText` 等方法返回值改为 `void` 后，若调用方曾把返回值赋给变量会编译报错，需相应调整；删除 `dismissToast` 同理。仓库内部调用均已同步更新。
- 不引入淡入淡出动画等体验类改动，避免扩大改动范围。

## 验证策略

- Widget 测试：覆盖"连续多次 show 只有最新可见"、"dismiss 关闭当前 Toast"、"dismissAll 兼容"。
- 运行 `flutter analyze lib/src/components/toast`。
- 运行 toast 相关测试：`flutter test test/components/toast/t_toast_test.dart`。
- 运行 `git diff --check`。
- 全局 grep 确认无 `toastId` / `dismissToast` 残留。
