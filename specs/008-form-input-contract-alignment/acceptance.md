# 验收记录

## 验证环境

- 分支：rss1102/cnb-issue-54/refactor/form-input-contract-alignment
- 提交：由 PR HEAD 标识
- Flutter/Dart：Flutter 3.32.0（FVM）

## 自动化验证

> 本文件记录本次 API、视觉壳层和 Demo 对齐结果。Golden 基线只更新了受本次 Input 视觉变更直接影响的用例。

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test test/components/form test/components/input test/components/textarea` | 通过 | 76 tests，覆盖消息 token、状态颜色、局部样式合并、Textarea 容器与横向字段对齐 |
| `flutter test test/components/input/t_input_test.dart` | 通过 | 26 tests，覆盖 24dp 普通前后缀图标、40dp 密码显隐触控区域、局部样式 token 继承和状态颜色优先级 |
| `flutter test test/components/form/t_form_test.dart test/components/input/t_input_test.dart test/components/textarea/t_textarea_test.dart test/components/upload/t_upload_test.dart` | 通过 | 94 tests，新增 Upload 清空即时必填校验和竖排 FormItem 右侧操作区几何回归 |
| `flutter analyze`（`tdesign-component`） | 通过 | No issues found |
| `flutter analyze`（`tdesign-component/example`） | 通过 | No issues found |
| `Flutter 3.47.0 flutter analyze`（组件包与 Example） | 通过 | No issues found |
| `flutter test`（`tdesign-component`） | 未完全通过 | 2193 tests 中 2 个 `t_popup_route_test.dart` 用例失败；单独运行该文件通过，需后续排查测试顺序或共享状态 |
| `dart run tool/generate_example_code.dart --check` | 通过 | Example 代码资产与源码一致 |
| `flutter build web`（`tdesign-component/example`） | 通过 | Web Demo 可构建 |
| `flutter build web --no-web-resources-cdn`（`tdesign-component/example`） | 通过 | 使用仓库构建产物内的 CanvasKit 完成本地截图验收 |

## 人工验收

- [x] Form Demo 与小程序 Form/FormItem 语义矩阵核对
- [x] Input/Textarea Demo 核对 label、clear button、边框、状态、计数和 FormItem 组合
- [x] Input 图标插槽和密码显隐按钮核对组件默认尺寸、token 颜色及交互状态
- [x] 浅色 Input 全页截图核对 tips/error、超长标签和自定义样式的字体、颜色、行高与对齐
- [x] 深色 Form Web 截图核对分组、布局选择、禁用开关、九个字段和操作按钮的场景顺序
- [x] 深色 Textarea Web 截图核对固定高度、内置标题、自动增高、字符限制和容器间距
- [x] 通过 Widget 几何测试核对普通横向字段垂直居中、带消息字段顶部对齐，以及 Form Demo 个人简介标签顶部对齐
- [x] 使用无旧 Service Worker 缓存的新 Web 构建复查竖排生日/籍贯字段，label 与 controls 纵向排列且箭头保持在表单项最右侧
- [x] 使用同一新 Web 构建复查 Input 自定义样式，字段行只保留 FormItem 的单层背景与底部分隔线，不再叠加 Input 外壳边框
- [x] 通过 Golden 对 Material 主题隔离和新 Input 外层结构做回归

## 验收边界

- 小程序专属键盘高度、同层渲染、安全键盘和 `scrollToFirstError` 未复制到 Flutter API。
- 本地已按小程序源码完成 Form/Textarea 的结构和状态矩阵，并完成 Web 暗色运行截图；浅色主题的 token 映射已有 Widget 测试，最终跨设备字体栅格和逐像素结果仍需在 PR Demo 中复查。
