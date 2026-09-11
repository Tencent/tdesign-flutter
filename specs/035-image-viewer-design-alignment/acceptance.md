# 验收记录

## 验证环境

- 分支：`rss1102/feat/image-viewer-design-alignment`
- 基线：`origin/develop@044122f61`
- 设计：Figma `24386:5270`
- 小程序参考：`Tencent/tdesign-miniprogram@9ee571f8`
- 本地 Flutter/Dart：3.32.0 / 3.8.0
- 远端验证目标：Flutter 3.32.0 与 latest

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test test/components/image_viewer/t_image_viewer_test.dart --coverage` | 24/24 通过 | Flutter 3.32.0；图片失败占位实际渲染为 24×24 且位于操作栏下方，放大后横向平移不切换相邻页 |
| `flutter test test/image_viewer_demo_test.dart` | 4/4 通过 | Flutter 3.32.0，Example 包 |
| `flutter test test/image_viewer_demo_golden_test.dart` | 4/4 通过 | 固定 Linux Flutter 3.32.0；生成后无更新复验 |
| `flutter analyze --fatal-infos` | 通过，0 error / 0 warning | Flutter 3.32.0，全组件包；移除无效蒙层 API 后复验 |
| `dart run tool/generate_example_code.dart --check` | 通过 | 示例代码片段与源码一致 |
| `dart run tool/check_component_coverage.dart image_viewer` | 224/228，98.25% | 本地 LCOV 经 `componentProductionSource` 过滤后的 ImageViewer 生产源码口径，超过 95% 门禁 |

推送后由远端 CI 在 Flutter 3.32.0 与 latest 上执行严格 analyze、组件与示例功能测试；本表的本地命令不冒充 latest 本地执行证据。

## 人工验收

- [x] 浏览器真实操作：点击“带操作图片预览”打开面板，核对关闭/`1/2`/删除操作栏与图片布局，再点击关闭返回 Demo。
- [x] 双击 1x/2x、双指缩放 1～3x、放大后横向平移不切换相邻页、横向切图和下拉阈值关闭由真实指针 Widget 测试覆盖。

## 小程序能力核对

- [x] 图片列表、初始页、页码、切页、关闭、删除、关闭/删除自定义内容均有 Flutter 等价能力；关闭完成由 `TImageViewer.show` 返回的 `Future<void>` 单一承载。
- [x] 小程序受控 `visible` / 非受控 `defaultVisible` 的用户能力由 Flutter Route 生命周期表达：`show` 打开、调用方 `Navigator.pop` 主动关闭、返回 Future 通知关闭完成；不增加与 Navigator 冲突的布尔状态源。系统区域由 `SafeArea` 适配，无需 `usingCustomNavbar` 开关。
- [x] 图片来源、缓存和解码由 `ImageProvider` 配置，按需构建由 `TSwiper` 内部 `PageView.builder` 承担，长按业务由 `onLongPress` 承担；不复制 `imageProps` 字段集合。
- [x] 小程序 overlay 点击关闭对应 Flutter 全屏预览区点击关闭；组件不保留无实际命中区域的 Dialog `barrierDismissible` 或 `barrierColor`。

## 未覆盖项与后续工作

- 浏览器自动化的拖拽会先进入图片位移并回弹，未把它作为下拉关闭的人工通过证据；该行为以 Flutter Widget 手势测试验收。
- macOS 原生 Golden 与固定 Linux 基线存在字体栅格差异；Golden 仅在仓库约定的 Linux Flutter 3.32.0 环境生成和比对。
- latest 仅以远端 CI 为证据；本地未重复安装或运行 latest 工具链。
