# Acceptance Report — issue #924 TFab 暴露 onLongPress 回调

## 验收结论

状态：通过（自动化）；交互可在真机由人工复核 TC-03。

## 需求对照

| 验收项 | 结果 | 说明 |
|--------|------|------|
| Issue #924：暴露长按能力 | 通过 | 新增 `onLongPress`，并接入 `InkWell` |
| 兼容既有点击 | 通过 | `onClick` 仍映射 `onTap`，未传 `onLongPress` 时行为与此前一致 |
| 回归风险可控 | 通过 | 仅新增可选参数，无破坏性变更 |

## 执行检查

### 通过项

```bash
cd tdesign-component && flutter test test/t_fab_test.dart
```

（建议合并前在 CI 全量执行 `flutter test`。）

### 未通过项或阻塞项

- 无。

## 人工验收指引

1. 在页面中使用 `TFab(onLongPress: () { ... })`，长按按钮，确认业务回调执行。
2. 同时设置 `onClick` 与 `onLongPress`，分别短按与长按，确认两种手势各自触发预期逻辑。
3. 若项目使用 demo_tool 生成的 API 文档，在具备 `tdesign_flutter_tools` 的环境执行 `all_build.sh` 中对应 `TFab` 行，确认文档列表含 `onLongPress`。

## 环境说明

- 验证测试于 macOS，Flutter 测试通过。
- `tdesign_flutter_tools` 本地为 stub，API JSON 未在本机重新生成。
