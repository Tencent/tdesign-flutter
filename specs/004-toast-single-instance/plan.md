# 实施方案

## 技术方案

### 核心改动

在 `_showOverlay` 方法中，展示新 Toast 前先调用 `dismissAll()` 移除所有已有 Toast 实例，再插入新的 OverlayEntry。

具体改动 `t_toast.dart` 的 `_showOverlay` 方法：

```dart
static void _showOverlay(...) {
    // 新 Toast 展示前先移除所有已有实例（单实例替换语义）
    dismissAll();
    ...
}
```

同时更新 `_showOverlay` 中原本的注释，将"不同 ID 的 Toast 可以并存；同 ID 采用替换语义"改为"单实例替换语义：新 Toast 展示时移除所有旧 Toast"。

注意：需要在调用 `dismissAll()` 之后、插入新 OverlayEntry 之前，保证新的 Toast 不会被旧的取消影响。

### 测试改动

更新 `t_toast_test.dart` 中涉及多实例并存的测试用例：

- `dismissAll 关闭所有 Toast` 测试：改为验证"新 Toast 替换旧 Toast"。
- 新增测试：连续 show 多个 Toast，验证始终只有一个可见。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | tdesign-component/lib/src/components/toast/t_toast.dart | `_showOverlay` 加入 dismissAll，行为从多实例并存改为单实例替换 |
| 测试 | tdesign-component/test/components/toast/t_toast_test.dart | 更新多实例相关测试 |

## API 变化

- 不新增、不删除、不重命名任何公共 API。
- `showText` 等方法的行为从"多实例并存"变为"新实例替换旧实例"，属于**默认行为变更**，是 breaking change。

## 风险与取舍

- **Breaking change**：用户若依赖多 Toast 并存的行为（如 loading + 提示同时显示），修改后不再支持。但考虑到 TDesign Mobile 的设计以及用户报告的问题，单实例语义是更合理的默认行为。
- `showLoading` 和普通 Toast 同时显示的场景：修改后 loading 会被普通 Toast 替换，反之亦然。如果用户需要两者并存，需要自行设计（例如用自定义 Overlay 或其它方案）。
- 不引入淡入淡出动画等体验类改动，避免扩大改动范围。

## 验证策略

- Widget 测试：新增"连续多次 show 只有最新可见"用例。
- Widget 测试：更新 `dismissAll` 相关用例以适配新行为。
- 运行 `flutter analyze lib/src/components/toast`。
- 运行 toast 相关测试：`flutter test test/components/toast/t_toast_test.dart`。
- 运行 `git diff --check`。
