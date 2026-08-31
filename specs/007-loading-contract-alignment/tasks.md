# Loading：跨端对齐 - 任务清单

## TODO

- （无）

## DOING

- [x] 创建 Spec `007-loading-contract-alignment`
- [x] `t_loading.dart`：duration 默认 2000→800
- [x] `t_loading.dart`：axis 默认 vertical→horizontal
- [x] `t_loading.dart`：size 收敛为 `double`、默认 20，移除 `TLoadingSize`
- [x] `t_loading.dart` / `t_point_indicator.dart`：三种指示器统一外部尺寸语义
- [x] Demo 显式展示 circle 24/28/32、point 40、速度示例 26
- [x] `t_loading_theme_data.dart`：`duration` dartdoc 默认说明
- [x] 示例页收敛小程序公开矩阵（custom 合并到纯图标、三档尺寸合并，含生成代码）
- [x] 公开 Demo 恢复左对齐，使用小程序官方 custom 图片，并补可拖动的常驻速度数值
- [x] 补充 Demo 结构测试、明暗整页 Golden 与小程序实际页截图证据
- [x] 补充 Widget 测试（duration/axis/尺寸/覆盖率补充）
- [x] 修正站点 README（链接/API 表/示例代码）
- [x] CNB 复审后重新逐段同步 README 与最终公开 Demo，移除过期 Slider API
- [x] custom 指示器复用既有 duration 持续旋转，并补默认速度与运行期更新测试
- [x] 修正 `customIcon` 与 `icon == null` 的冲突组合，落实自定义内容最高优先级
- [x] 执行验证：analyze / 双版本测试 / 覆盖率 / 示例生成

## DONE

- [x] `flutter analyze --fatal-infos --no-pub`（3.32.0）0 error / 0 warning
- [x] `flutter test test/components/loading/t_loading_test.dart`（3.32.0）36/36 通过
- [x] Loading 目录覆盖率 99.59%，≥95%
- [x] `dart run tool/generate_example_code.dart --check` 通过
- [x] Flutter 3.47.0 analyze 0 error / 0 warning，Loading 与受影响主题测试 63/63 通过
