# Acceptance Report — issue #924 [TDFab] 暴露 onLongPress 方法

## 验收结论

状态：通过（自动化测试与文档自检已完成；UI 光感变更建议设计走查）

## 需求对照

| 验收项 | 结果 | 说明 |
|--------|------|------|
| issue 要求透出长按能力 | 通过 | 新增 `onLongPress` 并绑定 `InkWell.onLongPress` |
| 与单击互不干扰 | 通过 | 见 `t_fab_test.dart` TC-02 |
| 示例可人工验证 | 通过 | `TFabPage`「交互」模块长按出 `SnackBar` |
| API 文档 | 通过 | `fab_api.md` 已增加参数行 |

## 执行检查

### 通过项

```bash
cd tdesign-component && flutter test test/t_fab_test.dart
cd tdesign-component && flutter analyze lib/src/components/fab/t_fab.dart
node scripts/issue-workflow/check-issue-fix.mjs \
  --requirements-dir requirements/issue-924-fab-on-long-press \
  --component-file tdesign-component/lib/src/components/fab/t_fab.dart \
  --class-name TFab \
  --all-build tdesign-component/demo_tool/all_build.sh \
  --require-all-build-class
```

### 未通过项或阻塞项

- 无。

## 人工验收指引

1. 打开示例应用，进入 Fab 示例页，找到「交互」中的「Fab onLongPress 长按回调」。
2. 长按按钮，确认出现「已长按」提示。
3. 在业务工程中引用新版本 `TFab`，传入 `onLongPress` 验证自定义逻辑。

## 环境说明

- Flutter 测试在 macOS 本机执行；`tdesign_flutter_tools` 本地为 path stub，未运行全量 `all_build.sh` 生成 API，已手工维护 `fab_api.md` 与代码一致。
