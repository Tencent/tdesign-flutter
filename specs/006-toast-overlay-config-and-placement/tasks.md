# Toast：可见遮罩 + 展示位置 - 任务清单

## TODO

- （无）

## DOING

- [x] 创建 Spec `006-toast-overlay-config-and-placement`
- [x] 新增公开类 `TOverlayConfig`
- [x] 新增公开枚举 `TToastPlacement` 与位置对齐逻辑
- [x] 扩展 `showXxx` 签名（overlay / placement）
- [x] **移除 `bool? preventTap` 散参，收敛到 `TOverlayConfig`（不兼容收敛版，breaking）**
- [x] 重写 `_showOverlay` 统一解析蒙层 + 位置
- [x] 补充 Widget 测试（showOverlay / placement / preventTap 解耦）
- [x] 示例页对齐小程序 demo（含加载状态自定义）
- [x] 修正站点 README 过时引用并同步新能力

## DONE

- [x] `flutter analyze lib/src/components/toast test/components/toast` 0 error / 0 warning
- [x] `flutter analyze example/lib/page/t_toast_page.dart` 0 error / 0 warning
- [x] `flutter test test/components/toast/t_toast_test.dart` 37 个用例全部通过
- [x] `dart run tool/generate_example_code.dart --check` 示例片段全部 up-to-date
- [x] `git diff --check` 通过
