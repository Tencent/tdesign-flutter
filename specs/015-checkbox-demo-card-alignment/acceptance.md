# 验收记录

## 验证环境

- 分支：`rss1102/pr-1048-demo-alignment`
- 提交：当前 PR 分支最新提交
- Flutter/Dart：Flutter 3.32.0 与 3.47.0

## 自动化验证

> 二次修复已基于官方站内小程序实际运行画面完成；Android 真机最终截图因设备进入 Dozing 且禁止 ADB 注入唤醒事件而待补。

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test test/components/checkbox/t_check_box_group_test.dart test/components/checkbox/t_checkbox_test.dart` | 通过 | Flutter 3.32.0 与 3.47.0 均 40 项，含默认圆形指示器、默认分割线、默认 3/5 行和卡片角标回归 |
| `flutter test test/checkbox_page_test.dart` | 通过 | Flutter 3.32.0，结构 + 明/暗全页 Golden |
| Checkbox 生产源码覆盖率 | 通过 | LH/LF = 288/297 = 96.97% |
| `flutter analyze` | 通过 | Flutter 3.32.0，组件与 Demo 均 0 问题 |
| Flutter 3.47.0 Checkbox 组件测试 | 通过 | 40 项 |
| Flutter 3.47.0 `flutter analyze` | 通过 | 组件与 Demo 均 0 问题 |
| Flutter 3.47.0 Demo Golden | 未严格通过 | 尺寸相同，明色 21px、暗色 18px 像素差异，属跨 Flutter 版本字形/渲染差异 |
| `dart run tool/generate_example_code.dart --check` | 通过 | 生成片段无漂移 |
| Checkbox 语义颜色回归 | 通过 | Theme 覆盖、默认主/次 token 与 Material 字体属性继承均已覆盖 |
| Checkbox 默认文案行数回归 | 通过 | 主标题 3 行、副标题 5 行，超出使用省略号 |

## 人工验收

- [ ] Android 16 真机横向文案无截断。
- [ ] 普通示例的指示器、分割线、文案和容器层级符合官方小程序运行画面。
- [x] 组件默认圆形指示器、普通 Checkbox 与 CheckboxGroup 默认分割线符合默认契约。
- [ ] 纵向/横向卡片角标与布局符合官方小程序运行画面。

## 未覆盖项与后续工作

- Flutter 3.47.0 与 3.32.0 的 Golden 存在极少像素差异，不在本次 Demo/组件对齐中放宽全局 Golden 阈值。
- Android 16 二次修复安装成功，但设备随后进入 Dozing，ADB 无 `INJECT_EVENTS` 权限无法唤醒；本次黑屏图不作为验收证据。
