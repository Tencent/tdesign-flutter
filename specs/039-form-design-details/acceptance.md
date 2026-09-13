# 验收记录

## 验证环境

- 分支：`rss1102/fix/form-design-details`
- 基线：`origin/develop@5d75a033d`（包含 #1119）
- Flutter/Dart：Flutter 3.32.0（FVM）、Flutter 3.47.0 / Dart 3.13.0

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test --no-pub test/components/form/t_form_test.dart` | 通过 | 49 tests |
| `flutter test --no-pub --exclude-tags golden test/form_demo_test.dart` | 通过 | 4 tests；覆盖 inline Radio、交互、对齐、间距和按钮样式 |
| `dart run tool/generate_example_code.dart --check` | 通过 | 示例代码与源码一致 |
| Linux 3.32.0：`flutter test --no-pub test/form_demo_test.dart` | 通过 | 6 tests；先确认旧基线仅因性别行上下各 16px 兼容间距而缩短 32px，再更新并无更新复跑 |
| `flutter analyze --fatal-infos` | 通过 | 组件包与 example 均为 0 issues |
| `flutter build apk --debug` | 通过 | Android Debug APK 构建成功 |
| Flutter 3.47.0：Form 组件 / Demo 非 Golden 测试 | 通过 | 49 + 4 tests |
| Flutter 3.47.0：`flutter analyze --fatal-infos` | 通过 | 组件包与 example 均为 0 issues |

## 人工验收

- [x] iPhone 16 模拟器复验合入 #1119 后的水平、竖向布局和无障碍节点
- [ ] Android 16 真机当前未连接；不可沿用旧 head 冒充最终真机证据

### 原 Form 修复的 Android 真机修改前后对比

- 设备：Android 16，物理分辨率 1220 × 2656
- 修改前：`origin/develop@c2f9ef5e8`
- 修改后：#1119 合入前的 Form 修复提交；用于核对本 PR 其余四类视觉变更
- 条件：同一设备、默认浅色主题、同一 Form Demo 页面

![Form 真机修改前后对比](assets/form-1105-before-after.png)

### 合入 #1119 后的移动端实装核对

- 环境：iPhone 16 模拟器，Flutter 3.47.0，默认浅色主题
- 水平与竖向均使用同一个 `TRadioGroup.options` 和 `TRadioVariant.inline`
- 截图外部标注说明了移除旧参数、Theme 间距补丁、手写手势和兼容分支的原因

![Form 合入 Radio 重构后的移动端实装](assets/form-radio-integration-ios.png)

## 未覆盖项与后续工作

- Android 16 真机当前未连接，因此最终集成态以 CI 对齐 Golden、Android APK 构建与 iPhone 移动端实装交叉验证；Android 连接后可补同页复验，但当前记录不将模拟器写成真机。
