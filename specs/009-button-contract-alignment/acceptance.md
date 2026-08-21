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
| `flutter test test/components/button --coverage` | 通过 | 127 个 Button 测试；Button 生产代码 459/473 = 97.04% |
| `flutter test test/components/fab` | 通过 | 63 个 Fab 测试，拖拽边界回归通过 |
| Dialog/Dropdown/Empty/Drawer/NoticeBar/Fab 直接消费者测试 | 通过 | Flutter 3.32.0 共 353 个测试，确认 Button 改动未泄漏到组合组件 |
| `flutter analyze` + Button/Fab tests | 通过 | Flutter 3.47.0；185 个 Button 非 Golden + Fab 测试，Golden 以 3.32.0 为基线 |
| Example `flutter analyze` | 通过 | Flutter 3.32.0 与 3.47.0 均为 0 issues |
| Example `flutter build web` | 通过 | Flutter 3.32.0 release Web 产物编译成功 |
| `dart run tool/generate_example_code.dart --check` | 通过 | Demo 代码资产无漂移 |

## 人工验收

- [x] Golden 四档矩阵为 48/40/32/28dp，与 MiniProgram `button.wxss` 逐项核对
- [x] 四档字体、水平内边距与图标尺寸与 MiniProgram 源码规格一致
- [x] square 纯图标按钮为等宽高并保留 `radiusDefault`，普通与渐变分支一致
- [x] 图标、通栏与四种 shape Demo 的顺序、内容和文案与验收小程序一致
- [x] `TButtonShape` 收敛为 rectangle/square/round/circle；通栏和零圆角分别由父布局与 `ButtonStyle.shape` 表达
- [x] Button Theme 不再控制组件外部 margin，Demo 间距继续由 Flutter 父布局表达
- [x] 普通与渐变按钮在 shrink-wrap/padded 下的视觉尺寸和点击区均已复查
- [x] 渐变按钮在启用与禁用状态均仅生成一个 button 语义节点，启用态包含 tap 动作
- [x] 渐变 tap-target 的 intrinsic、dry layout、baseline、样式更新与空白区命中测试完整
- [x] fill、outline、text、ghost 与渐变按钮均接入 Flutter WidgetState/Ink 点击反馈，禁用态及主题优先级测试通过
- [x] fill、outline、text 的 pressed 背景 token 不叠加 pressed overlay，ghost 与渐变在无 pressed 背景变化时使用 overlay
- [x] 默认状态层基于 P0 最终样式生成，实例前景色和 stateful 背景的优先级测试通过
- [x] Icon 默认尺寸由 IconTheme 注入，调用方传入的 key、语义标签和原生视觉属性保持不变
- [x] `TFab` 小程序组合源码明确为 large / circle(or round) / primary，Flutter 组合层已显式对齐
- [x] 渐变分支使用内部状态控制器按实时 pressed/hovered/focused/disabled 重新解析 `ButtonStyle`
- [x] 渐变动态 cursor、P0 icon 样式、alignment 与 layer builder 已增加聚焦回归

## 未覆盖项与后续工作

- Flutter 3.47.0 与 3.32.0 的字体栅格化存在少量像素差异，Golden 只在项目基线 3.32.0 上校验；latest 执行非 Golden 行为测试。
- 本次不扩展 Button 公开 API，不处理 loading/block/openType 等非 Flutter 基础契约。
