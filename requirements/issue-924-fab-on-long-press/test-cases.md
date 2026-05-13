# 测试用例 — issue #924 [TDFab] 暴漏onLongPress方法

## TC-01

- **前置条件**：运行 `tdesign-component/example`，进入 FAB 示例页（`TFabPage`）。
- **操作**：对 “LongPress 长按事件” 示例中的 FAB 进行长按。
- **期望**：控制台输出 `TFab onLongPress`；无异常报错；松手后按钮仍可继续交互。

## TC-02

- **前置条件**：同 TC-01。
- **操作**：对任意示例 FAB 进行点击（Tap）。
- **期望**：点击行为不受 `onLongPress` 新增影响；未配置 `onClick` 时点击无副作用且无异常。

## TC-03

- **前置条件**：在业务工程或示例中，构建 `TFab(onLongPress: ...)`。
- **操作**：执行 `flutter analyze`（或仓库现有静态检查流程）。
- **期望**：静态检查通过；对仅使用旧参数（不传 `onLongPress`）的代码保持兼容，无需改动即可编译通过。
