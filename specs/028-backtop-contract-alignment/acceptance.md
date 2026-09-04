# 验收记录

## 验证环境

- 分支：`rss1102/breaking/backtop-design-alignment`
- 基线：`origin/develop`（创建工作树时为 `f3e14c43`）
- Flutter/Dart：Flutter 3.32.0 / Dart 3.8.0；Flutter 3.47.0 / Dart 3.13.0
- 小程序参考：1.16.0 在线公开 Demo，Last Update 2026-08-24
- Figma：BackTop 页面节点 `24386:5237`，组件集合节点 `24387:6706`

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test ...backtop... --no-pub --coverage` | PASS，45 tests | Flutter 3.32.0；生产源码 173/177，97.74% |
| `flutter test test/backtop_demo_test.dart --no-pub` | PASS，3 tests | Flutter 3.32.0 与 3.47.0；Demo 结构、8 状态矩阵及真实滚动回顶 |
| `flutter test ...backtop... --no-pub --exclude-tags golden` | PASS，45 tests | Flutter 3.47.0 |
| `flutter analyze` | PASS，0 error / 0 warning | 两个 SDK 均在组件包、示例包全量执行 |
| `dart run tool/generate_example_code.dart --check` | PASS | 2 个公开代码片段与页面实现一致，清理 1 个旧片段 |
| `sh ./demo_tool/all_build.sh` | PASS | API 文档覆盖组件、Theme 与两个枚举 |
| `flutter build web --release` | PASS | Flutter 3.32.0，Web Demo 可构建 |
| Linux `--update-goldens` 后无更新参数复跑 | PASS，4 tests | Flutter 3.32.0；导航矩阵与 Demo 各 light/dark，严格比较 |
| 回归工具测试 | PASS，17 tests | 覆盖率、组件清单、视觉清单与代码片段生成器 |

## API 与实现收敛审查

| API / 实现 | 所有权 | 结论 |
| --- | --- | --- |
| `shape` | 实例结构形态 | 保留，改为非空默认；Theme 同义字段删除 |
| `colorScheme` | 实例预设配色 | 新增 light/dark；Theme 不保存选择器 |
| `showText` | 标准设计文案状态 | 保留；不新增重复文案入口 |
| `visibilityOffset` | 实例滚动显隐行为 | 默认 200；Theme 同义字段删除 |
| `controller` | Flutter 滚动状态与命令源 | 保留；负责读取偏移与动画回顶 |
| `onPressed` | 回顶完成通知 | 保留可空；不再作为重复禁用状态 |
| `tooltip` | 无障碍提示 | 保留 |
| `TBackTopThemeData` | 子树具体视觉默认值 | 只保留颜色、尺寸、间距、边框和文字样式 |
| 小程序 `fixed` / `scroll-top` / icon 字符串 / slot | 平台布局或内容机制 | 不移植，以 Flutter 父布局、Controller 和 Widget 组合表达 |

## 人工验收

- [x] Figma 设计矩阵、尺寸、间距、边框与明暗 Token 已读取
- [x] 小程序公开 Demo 的滚动输入、点击事件及默认阈值已读取
- [x] Flutter Demo light/dark 4 张 Linux Golden 已逐张核对
- [ ] Android 真机待核对

## 未覆盖项与后续工作

- 浏览器连接器的安全策略拒绝访问本机 `127.0.0.1` Demo，因此没有把 Web
  实际浏览器点击冒充为已完成；Web release 构建、真实 Widget 滚动交互和 Linux
  Golden 已通过。
- Android / iOS 真机触控与系统字体栅格仍由 PR Demo 阶段补充，不影响本次固定
  Flutter 测试环境下的契约与像素回归结论。
