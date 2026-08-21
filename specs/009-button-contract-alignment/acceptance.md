# 验收记录

## 验证环境

- 分支：`rss1102/fix/button-contract-alignment`
- 基线：`origin/develop@67d334a7`
- 提交：由 PR HEAD 标识
- Flutter 3.32.0 / Dart 3.8.0
- Flutter 3.47.0 / Dart 3.13.0

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter analyze` | 通过 | Flutter 3.32.0 组件包，0 issues |
| `flutter test test/components/button --coverage` | 通过 | 118 个 Button 测试；Button 生产代码 417/434 = 96.08% |
| `flutter test test/components/fab` | 通过 | 63 个 Fab 测试，拖拽边界回归通过 |
| Dialog/Dropdown/Empty/Fab 直接消费者测试 | 通过 | 确认 Button 尺寸改动未泄漏到其他组合组件 |
| `flutter analyze` + Button/Fab tests | 通过 | Flutter 3.47.0；110 个 Button 非 Golden + 63 个 Fab 测试，Golden 以 3.32.0 为基线 |
| Example `flutter analyze` | 通过 | Flutter 3.32.0 与 3.47.0 均为 0 issues |
| Example `flutter build web` | 通过 | Flutter 3.32.0 release Web 产物编译成功 |
| `dart run tool/generate_example_code.dart --check` | 通过 | Demo 代码资产无漂移 |

## 人工验收

- [x] Golden 四档矩阵为 48/40/32/28dp，与 MiniProgram `button.wxss` 逐项核对
- [x] 四档字体、水平内边距与图标尺寸与 MiniProgram 源码规格一致
- [x] square 纯图标按钮为等宽高并保留 `radiusDefault`，普通与渐变分支一致
- [x] 图标、通栏与四种 shape Demo 的顺序、内容和文案与验收小程序一致
- [x] 普通与渐变按钮在 shrink-wrap/padded 下的视觉尺寸和点击区均已复查
- [x] 普通、ghost、渐变按钮均接入 Flutter WidgetState/Ink 点击反馈，禁用态及主题优先级测试通过
- [x] `TFab` 小程序组合源码明确为 large / circle(or round) / primary，Flutter 组合层已显式对齐

## 未覆盖项与后续工作

- Flutter 3.47.0 与 3.32.0 的字体栅格化存在少量像素差异，Golden 只在项目基线 3.32.0 上校验；latest 执行非 Golden 行为测试。
- 本次不扩展 Button 公开 API，不处理 loading/block/openType 等非 Flutter 基础契约。
