# Acceptance Report — issue #924 [TDFab] 暴漏onLongPress方法

## 验收结论

状态：通过

## 需求对照

| 验收项 | 结果 | 说明 |
|---|---|---|
| `TFab` 暴露长按回调 `onLongPress` | 通过 | 新增可选参数并透传到 `InkWell.onLongPress` |
| 保持对现有点击回调 `onClick` 的兼容 | 通过 | `onLongPress` 为可选参数，不影响原有点击行为 |
| 提供可验收示例 | 通过 | `TFabPage` 新增 “LongPress 长按事件” 示例条目 |

## 执行检查

### 通过项

```bash
dart analyze tdesign-component/lib/src/components/fab/t_fab.dart
node scripts/issue-workflow/check-issue-fix.mjs --requirements-dir requirements/issue-924-fab-on-long-press
```

### 未通过项或阻塞项

- 无

## 人工验收指引

1. 运行 `tdesign-component/example`（按项目既有方式启动）。
2. 进入 FAB 示例页（`TFabPage`）。
3. 长按 “LongPress 长按事件” 示例中的 FAB，观察控制台输出 `TFab onLongPress`，并确认无异常报错。

## 环境说明

- OS：macOS（darwin）
- 说明：验收以静态检查 + example 人工交互为主，不涉及站点生成物改动。
