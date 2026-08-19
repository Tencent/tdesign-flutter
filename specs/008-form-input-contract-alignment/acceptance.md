# 验收记录

## 验证环境

- 分支：rss1102/cnb-issue-54/refactor/form-input-contract-alignment
- 提交：由 PR HEAD 标识
- Flutter/Dart：Flutter 3.32.0（FVM）

## 自动化验证

> 本文件记录本次 API、视觉壳层和 Demo 对齐结果。Golden 基线只更新了受本次 Input 视觉变更直接影响的用例。

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test test/components/form test/components/input test/components/textarea` | 通过 | 64 tests |
| `flutter analyze`（`tdesign-component`） | 通过 | No issues found |
| `flutter analyze`（`tdesign-component/example`） | 通过 | No issues found |
| `Flutter 3.47.0 flutter analyze`（组件包与 Example） | 通过 | No issues found |
| `flutter test`（`tdesign-component`） | 未完全通过 | 2193 tests 中 2 个 `t_popup_route_test.dart` 用例失败；单独运行该文件通过，需后续排查测试顺序或共享状态 |
| `dart run tool/generate_example_code.dart --check` | 通过 | Example 代码资产与源码一致 |
| `flutter build web`（`tdesign-component/example`） | 通过 | Web Demo 可构建 |

## 人工验收

- [x] Form Demo 与小程序 Form/FormItem 语义矩阵核对
- [x] Input/Textarea Demo 核对 label、clear button、边框、状态、计数和 FormItem 组合
- [x] 通过 Golden 对 Material 主题隔离和新 Input 外层结构做回归

## 验收边界

- 小程序专属键盘高度、同层渲染、安全键盘和 `scrollToFirstError` 未复制到 Flutter API。
- 本地已按小程序 API 文档完成结构和状态矩阵；真实设备字体、IME、键盘和逐像素截图仍需用户在 Demo 中复查。
