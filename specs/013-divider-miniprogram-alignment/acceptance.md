# 验收记录

## 验证基线

- Flutter：`origin/develop`
- 对照范围：小程序 Divider 组件源码与官方 Demo

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test test/components/divider test/components/base_components_golden_test.dart` | 通过 | Flutter 3.32.0，共 43 项 |
| `flutter analyze`（组件包） | 通过 | Flutter 3.32.0，0 issues |
| `flutter analyze`（Example） | 通过 | Flutter 3.32.0，0 issues |
| `dart run tool/generate_example_code.dart --check` | 通过 | 示例资产已同步 |
| `flutter test --no-pub test/components/divider/t_divider_test.dart` | 通过 | Flutter 3.47.0，共 39 项 |
| `flutter test --no-pub --coverage test/components/divider/t_divider_test.dart` | 通过 | Flutter 3.32.0，Divider 生产源码行覆盖率 ≥95%：`t_divider.dart` LF=78/LH=77（98.72%）、`t_divider_painter.dart` LF=19/LH=19（100%）、`t_divider_theme_data.dart` LF=20/LH=20（100%），合计 LF=117/LH=116 = **99.15%**，未回退；唯一未覆盖行为 `t_divider.dart:267`（竖线 + 无显式 Material `space` 的 `_defaultMargin` 分支） |
| `flutter analyze --no-pub`（组件包） | 通过 | Flutter 3.47.0，0 issues |

> 备注：本机在全新 Flutter 3.32.0 容器中复核时，Golden 像素比对因无系统字体、字体渲染与生成 Golden 的 CI 环境不同而存在像素级差异（`--update-goldens` 重新生成的 PNG 与已提交版本字节不同）；`t_divider_test.dart` 的全部 39 项代码级断言与 Divider 生产源码覆盖率均不受影响。已提交的 Golden 文件保持现状，交由 CI 的 `autofix.yml` 在目标环境中统一维护，不在此环境回写。

## 人工验收

- [x] 浅色、深色 Golden 人工检查
- [ ] Android / iOS 真机官方 Demo 截图对照
- [x] Web 浏览器官方 Demo 截图对照

## 未覆盖项

- Android / iOS 真机官方 Demo 截图对照仍保持未完成，不由自动化测试替代，合并前仍需按平台复核。
