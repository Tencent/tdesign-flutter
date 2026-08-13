# 实施方案

## 技术方案

### 背景色对齐

- 将 `t_toast.dart` 中 5 处 `BoxDecoration.color` 的默认 token 由 `theme.fontGyColor1` 改为 `theme.fontGyColor2`（分别位于 `_TIconTextToast`、`_TToastLoading`、`_TToastLoadingWithoutText`、`_TTextToast` 的 build 中）。
- 保留 `toastTheme.backgroundColor ?? theme.fontGyColor2` 的优先级链：实例/主题自定义 > 默认 token。
- 同步更新 `t_toast_test.dart` 中默认背景色断言，由 `fontGyColor1` 改为 `fontGyColor2`。

### 默认时长对齐

- 将普通 toast 5 个 show 方法（showText / showIconText / showSuccess / showWarning / showFail）的默认 `duration` 参数由 `const Duration(milliseconds: 3000)` 改为 `const Duration(milliseconds: 2000)`。
- 加载类 toast（showLoading / showLoadingWithoutText）默认时长语义不变（无限）。

### 哨兵值封装

- 在 `TToast` 类中新增具名常量 `static const Duration infiniteDuration = Duration(seconds: 99999999)`。
- 将 showLoading / showLoadingWithoutText 的默认值由 `const Duration(seconds: 99999999)` 替换为 `TToast.infiniteDuration`。
- 将 `_showOverlay` 中 `if (duration != const Duration(seconds: 99999999))` 的判定替换为 `if (duration != TToast.infiniteDuration)`。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | tdesign-component/lib/src/components/toast/t_toast.dart | 默认背景 token、默认时长、新增具名常量 |
| 测试 | tdesign-component/test/components/toast/t_toast_test.dart | 更新背景断言、新增默认时长用例 |
| 示例 | 无 | 不涉及 |
| 文档 | 本 Spec、生成 API 文档 | 新增公共常量 `TToast.infiniteDuration`，生成文档自动体现 |

## API 变化

- 新增公共只读常量 `TToast.infiniteDuration`（非 breaking）。
- 不新增、不删除、不重命名任何 show 方法或参数。
- 默认背景色与默认 duration 的取值变化属于默认行为调整（非 breaking，但改变视觉与交互表现）。

## 风险与取舍

- 默认背景色变化会影响所有未显式自定义背景的 toast 视觉表现，属于预期内的对齐行为。
- 默认时长缩短可能让依赖 3 秒显示时间的既有页面感知不同，但属对齐 TDesign Mobile 的预期调整；加载类 toast 不受影响。
- `TToast.infiniteDuration` 为新增公共常量，暴露实现哨兵值，但语义化命名优于魔法数字；若未来改换哨兵策略，需同步维护该常量。
- 本次不处理淡入淡出动画、同 ID 替换闪烁等体验优化，避免扩大改动范围。

## 验证策略

- Widget 测试覆盖默认背景色 token 断言、默认 2000ms 时长行为、加载类 toast 不自动消失。
- 运行 `flutter analyze lib/src/components/toast`。
- 运行 toast 相关测试：`flutter test test/components/toast/t_toast_test.dart`。
- 运行 `git diff --check`。
