# Loading：跨端对齐 - 任务清单

## TODO

- （无）

## DOING

- [x] 创建 Spec `007-loading-contract-alignment`
- [x] `t_loading.dart`：duration 默认 2000→800
- [x] `t_loading.dart`：axis 默认 vertical→horizontal
- [x] `t_loading.dart`：circle 三档尺寸对齐官方 24/28/32
- [x] `t_loading_theme_data.dart`：`duration` dartdoc 默认说明
- [x] 示例页收敛小程序公开矩阵（custom 合并到纯图标、三档尺寸合并，含生成代码）
- [x] 补充 Demo 结构测试、明暗整页 Golden 与小程序实际页截图证据
- [x] 补充 Widget 测试（duration/axis/尺寸/覆盖率补充）
- [x] 修正站点 README（链接/API 表/示例代码）
- [x] 执行验证：analyze / 双版本测试 / 覆盖率 / 示例生成

## DONE

- [x] `flutter analyze --fatal-infos` 0 error / 0 warning
- [x] `flutter test test/components/loading/t_loading_test.dart` 35 用例通过
- [x] 覆盖率 99.62%（基线 86.15%），≥95%
- [x] `dart run tool/generate_example_code.dart --check` 通过
