# 验收记录

## 验证环境

- 分支：`rss1102/fix/fab-contract-alignment`
- Flutter 基线：`origin/develop@67d334a7`
- 小程序源码：`Tencent/tdesign-miniprogram develop@d973e4aa`
- Flutter 3.32.0：Dart 3.8.0
- Flutter latest：3.47.0 / Dart 3.13.0

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test test/components/fab/t_fab_test.dart test/components/base_components_golden_test.dart` | 通过 | Flutter 3.32.0，70 个用例 |
| `flutter analyze` | 通过 | Flutter 3.32.0，组件包零问题 |
| `flutter analyze example` | 通过 | Flutter 3.32.0，Example 零问题 |
| `flutter test test/fab_page_test.dart` | 通过 | 通栏按钮切换、单 Fab、自动收缩时序与无溢出 |
| `dart run tool/generate_example_code.dart --check` | 通过 | 示例代码资产无漂移 |
| `flutter build web` | 通过 | Flutter 3.32.0 release Web 构建 |
| `node scripts/check-flutter-component-contracts.mjs` | 通过 | 56 个组件路由契约完整 |
| `flutter test --no-pub test/components/fab/t_fab_test.dart` | 通过 | Flutter 3.47.0，68 个 Fab 用例 |
| `flutter analyze --no-pub` | 通过 | Flutter 3.47.0，组件包零问题 |
| `flutter analyze --no-pub example` | 通过 | Flutter 3.47.0，Example 零问题 |

## 人工验收

- [x] 默认 pure icon 为 48dp primary 圆形按钮
- [x] 图文 Fab 为 large primary 胶囊形，图文间距 4dp
- [x] 默认图标与小程序同为 TDesign add 图标
- [x] 投影使用 TDesign `shadowsMiddle`，对应小程序 `shadow-2`
- [x] 默认位置、拖拽、非对称边界和磁吸动画符合契约
- [x] Demo 分组、文案和四个场景与小程序源码一致
- [x] 四个通栏按钮切换单个 Fab，自动收缩在滚动结束 100ms 后展开且无布局溢出
- [x] 浅色 Golden 与手机尺寸 Web 截图未发现布局、裁剪或滚动遮挡问题

## 未覆盖项与后续工作

- Flutter 3.47.0 对 3.32.0 生成的 Golden 存在 50/84 像素（0.02%/0.04%）
  的引擎抗锯齿差异，因此 Golden 以仓库最低支持版本 3.32.0 生成和复验；3.47.0
  单独执行完整 Fab Widget 测试。
- Chrome 当前为深色主题；页面级 Web 复查覆盖 390×844 手机视口，浅色视觉由
  `base_components_light.png` Golden 覆盖。
