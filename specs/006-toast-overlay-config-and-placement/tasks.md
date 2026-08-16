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
- [x] 补充各 `showXxx` 方法透传 `overlay` / `placement` 的契约测试（showIconText / showSuccess / showWarning / showFail / showLoading / showLoadingWithoutText）
- [x] 补充 `TOverlayConfig` 默认值契约测试（默认 opacity 0.2、showOverlay 与 preventTap 均关闭时不渲染蒙层）
- [x] 示例页对齐小程序 demo（含加载状态自定义）
- [x] 站点 README 文档变更随本 PR 提交（同步新 API 与 demo 结构、修正过时引用），但**不写入 PR 更新日志**（文档调整属用户无需感知的变更）
- [x] 样式对齐：纯文字 / 带图标 / 加载类 Toast 默认 `maxWidth` 由 191 调整为 185（对齐小程序 `max-width: 370rpx` 与 mobile-vue `185px`），并统一 `_TTextToast` / `_TIconTextToast` / `_TToastLoading` 取值口径（移除 `191.scale`）

## DONE

- [x] `flutter analyze lib/src/components/toast test/components/toast` 0 error / 0 warning
- [x] `flutter analyze example/lib/page/t_toast_page.dart` 0 error / 0 warning
- [x] `flutter test test/components/toast/t_toast_test.dart` 47 个用例全部通过
- [x] `dart run tool/generate_example_code.dart --check` 示例片段全部 up-to-date
- [x] `git diff --check` 通过
