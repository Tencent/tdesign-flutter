# 验收记录

## 验证环境

- 分支：rss1102/cnb-issue-54/refactor/form-input-contract-alignment
- 提交：由 PR HEAD 标识
- Flutter/Dart：Flutter 3.32.0（FVM）

## 自动化验证

> 本文件记录本次 API、视觉壳层和 Demo 对齐结果。Golden 基线按实际完整渲染更新，避免保留被截断的历史快照。

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test test/components/input test/components/textarea test/components/form test/components/upload` | 通过 | 覆盖 Input/Textarea 专属主题、Form validator、字段布局、语义化纵向对齐和 Upload 表单校验链路 |
| `flutter analyze`（`tdesign-component`） | 通过 | No issues found |
| `flutter analyze`（`tdesign-component/example`） | 通过 | No issues found |
| `Flutter 3.47.0 flutter analyze`（组件包与 Example） | 通过 | No issues found |
| `flutter test`（`tdesign-component`） | 通过 | 2269 tests 全部通过，包含组件、主题隔离和 Golden 回归 |
| `dart run tool/generate_example_code.dart --check` | 通过 | Example 代码资产与源码一致 |
| `flutter build web`（`tdesign-component/example`） | 通过 | Web Demo 可构建 |
| `flutter build web --no-web-resources-cdn`（`tdesign-component/example`） | 通过 | 使用仓库构建产物内的 CanvasKit 完成本地截图验收 |

## 人工验收

### MiniProgram Demo 完整性矩阵

| 组件 | 小程序分组 / 实例 | Flutter Example | 结果 |
| --- | --- | --- | --- |
| Input | 3 组：组件类型 5、组件状态 2、组件样式 5 | 3 组、共 12 个同序实例 | 完整 |
| Textarea | 4 组：组件类型 5、组件状态 1、组件样式 1、特殊样式 1 | 4 组、共 8 个同序实例 | 完整 |
| Form | 1 组；横向/竖向切换、禁用态、9 个字段和提交/重置 | 同一组场景及字段矩阵 | 完整 |

- Demo 页面只编排分组、场景容器、业务插槽和明确的定制场景；输入壳层、字段行、提示/错误文字和 Textarea 内部视觉由组件实现。状态 Demo 的红色清除图标与小程序一致，由局部组件 Theme 显式定制，不改变 `TInput` 的默认清除图标颜色。
- 小程序 slot 使用 Flutter Widget 组合表达：字段行前置图标使用 `TFormItem.leading`，编辑区前缀使用 `TInput.prefix`，操作区使用 `extra` / `suffix`。

- [x] Form Demo 与小程序 Form/FormItem 语义矩阵核对
- [x] Input/Textarea Demo 核对 label、clear button、边框、状态、计数和 FormItem 组合
- [x] Input 图标插槽和密码显隐按钮核对24dp图标槽、标准56dp行高、token颜色及交互状态
- [x] 浅色 Input 全页截图核对 tips/error、超长标签和自定义样式的字体、颜色、行高与对齐
- [x] 深色 Form Web 截图核对分组、布局选择、禁用开关、九个字段和操作按钮的场景顺序
- [x] 深色 Textarea Web 截图核对固定高度、内置标题、自动增高、字符限制和容器间距
- [x] 通过 Widget 几何测试核对普通横向字段垂直居中、带消息字段顶部对齐，以及 Form Demo 个人简介标签顶部对齐
- [x] 核对 `extra` 保持无附加定位样式的原始插槽，并通过 FormItem 实例与主题的 `start/center` 语义配置控制整行纵向对齐
- [x] 使用无旧 Service Worker 缓存的新 Web 构建复查竖排生日/籍贯字段，label 与 controls 纵向排列且箭头保持在表单项最右侧
- [x] 使用同一新 Web 构建复查 Input 自定义样式，字段行只保留 FormItem 的单层背景与底部分隔线，不再叠加 Input 外壳边框
- [x] 通过 Golden 对 Material 主题隔离和新 Input 外层结构做回归

## 验收边界

- 小程序专属键盘高度、同层渲染、安全键盘和 `scrollToFirstError` 未复制到 Flutter API。
- 本地已按小程序源码完成 Form/Textarea 的结构和状态矩阵，并完成 Web 暗色运行截图；浅色主题的 token 映射已有 Widget 测试，最终跨设备字体栅格和逐像素结果仍需在 PR Demo 中复查。
