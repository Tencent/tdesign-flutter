# Toast：可见遮罩 + 展示位置 - 验收记录

## 命令（flutter 3.32.0）

- `flutter analyze lib/src/components/toast test/components/toast` → **0 error / 0 warning**
- `flutter analyze example/lib/page/t_toast_page.dart` → **0 error / 0 warning**
- `flutter test test/components/toast/t_toast_test.dart` → **37/37 通过**
- `dart run tool/generate_example_code.dart --check` → 示例片段全部 up-to-date
- `git diff --check` → 通过

## 人工验收

- [x] 示例页展示遮罩 demo：点击后出现半透明黑色蒙层，Toast 居中，背景不可点击。
- [x] 示例页展示位置 demo：top / middle / bottom 三种 Toast 分别出现在顶部 / 居中 / 底部。
- [x] 多行文字、竖向图标、加载无文字、加载状态自定义、手动关闭等 demo 与小程序表现一致。

## 未覆盖项 / 后续项

- `close` / `destroy` 回调事件（后续迭代）。
- `TOverlayConfig` 的 zIndex / blur 高级扩展（后续迭代）。

## 结论

- [x] 已满足 spec.md 验收标准
