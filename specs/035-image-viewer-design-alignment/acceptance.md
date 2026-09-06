# 验收记录

## 验证环境

- 分支：`rss1102/feat/image-viewer-design-alignment`
- 基线：`origin/develop@2ed620b9`
- 设计：Figma `24386:5270`
- 小程序参考：`Tencent/tdesign-miniprogram@cc2384cc`
- Flutter/Dart：3.32.0 / 3.8.0；3.47.0 / 3.13.0

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test test/components/image_viewer/t_image_viewer_test.dart` | 20/20 通过 | Flutter 3.32.0、3.47.0 |
| `flutter test test/image_viewer_demo_test.dart` | 4/4 通过 | Flutter 3.32.0，Example 包 |
| `flutter test test/image_viewer_demo_golden_test.dart` | 4/4 通过 | 固定 Linux Flutter 3.32.0；生成后无更新复验 |
| `flutter analyze --fatal-infos` | 通过，0 error / 0 warning | Flutter 3.32.0、3.47.0 |
| `dart run tool/generate_example_code.dart --check` | 通过 | 示例代码片段与源码一致 |
| 组件生产代码覆盖率 | LH/LF = 186/187，99.47% | `t_image_viewer.dart` 与 Theme |

## 人工验收

- [x] 浏览器真实操作：点击“带操作图片预览”打开面板，核对关闭/`1/2`/删除操作栏与图片布局，再点击关闭返回 Demo。
- [x] 双击 1x/2x、双指缩放 1～3x、横向切图、下拉阈值关闭由真实指针 Widget 测试覆盖。

## 未覆盖项与后续工作

- 浏览器自动化的拖拽会先进入图片位移并回弹，未把它作为下拉关闭的人工通过证据；该行为以 Flutter Widget 手势测试验收。
- macOS 原生 Golden 与固定 Linux 基线存在字体栅格差异；Golden 仅在仓库约定的 Linux Flutter 3.32.0 环境生成和比对。
