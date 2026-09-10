# 验收记录

## 验证环境

- 分支：`rss1102/feat/image-viewer-design-alignment`
- 基线：`origin/develop@12e5a2792`
- 设计：Figma `24386:5270`
- 小程序参考：`Tencent/tdesign-miniprogram@9ee571f8`
- Flutter/Dart：3.32.0 / 3.8.0；3.47.0 / 3.13.0

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test test/components/image_viewer/t_image_viewer_test.dart --coverage` | 22/22 通过 | Flutter 3.32.0；覆盖按钮、全屏预览区、下拉和系统返回完成单一 Future，以及缩放、动效和导航状态 |
| `flutter test test/image_viewer_demo_test.dart` | 4/4 通过 | Flutter 3.32.0，Example 包 |
| `flutter test test/image_viewer_demo_golden_test.dart` | 4/4 通过 | 固定 Linux Flutter 3.32.0；生成后无更新复验 |
| `flutter analyze --fatal-infos` | 通过，0 error / 0 warning | Flutter 3.32.0，全组件包；移除无效蒙层 API 后复验 |
| `dart run tool/generate_example_code.dart --check` | 通过 | 示例代码片段与源码一致 |
| `dart run tool/check_component_coverage.dart image_viewer` | 217/221，98.19% | ImageViewer 生产代码，超过 95% 门禁 |

## 人工验收

- [x] 浏览器真实操作：点击“带操作图片预览”打开面板，核对关闭/`1/2`/删除操作栏与图片布局，再点击关闭返回 Demo。
- [x] 双击 1x/2x、双指缩放 1～3x、横向切图、下拉阈值关闭由真实指针 Widget 测试覆盖。

## 小程序能力核对

- [x] 图片列表、初始页、页码、切页、关闭、删除、关闭/删除自定义内容均有 Flutter 等价能力；关闭完成由 `TImageViewer.show` 返回的 `Future<void>` 单一承载。
- [x] 小程序受控 `visible` / 非受控 `defaultVisible` 由 Flutter 的命令式 Route/Future 生命周期等价承载；系统区域由 `SafeArea` 适配，无需 `usingCustomNavbar` 开关。
- [x] 图片来源、缓存和解码由 `ImageProvider` 配置，按需构建由 `TSwiper` 内部 `PageView.builder` 承担，长按业务由 `onLongPress` 承担；不复制 `imageProps` 字段集合。
- [x] 小程序 overlay 点击关闭对应 Flutter 全屏预览区点击关闭；组件不保留无实际命中区域的 Dialog `barrierDismissible` 或 `barrierColor`。

## 未覆盖项与后续工作

- 浏览器自动化的拖拽会先进入图片位移并回弹，未把它作为下拉关闭的人工通过证据；该行为以 Flutter Widget 手势测试验收。
- macOS 原生 Golden 与固定 Linux 基线存在字体栅格差异；Golden 仅在仓库约定的 Linux Flutter 3.32.0 环境生成和比对。
- 本轮 Flutter 3.47.0 依赖解析受 `pub.dev` TLS 错误阻断；`--no-pub` 不能复用 3.32.0 生成的 SDK 路径，因此合并后代码仍需在 latest CI 复验。
