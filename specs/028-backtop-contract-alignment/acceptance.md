# 验收记录

## 验证环境

- 分支：`rss1102/breaking/backtop-design-alignment`
- 基线：`origin/develop`（创建工作树时为 `f3e14c43`）
- Flutter/Dart：Flutter 3.32.0 / Dart 3.8.0；Flutter 3.47.0 / Dart 3.13.0
- 小程序参考：`develop` 分支 `_example/back-top.wxml` / `.ts` 与在线 API
- Figma 主基准：分支 `4SdclZkcv5bPgX6pa8AsmI` 的 BackTop 页面节点 `24386:5237`，移动画板 `375 × 812`

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test ...backtop... --no-pub --coverage` | PASS，38 tests | Flutter 3.32.0；生产源码 175/176，99.43% |
| `flutter test test/backtop_demo_test.dart test/backtop_demo_golden_test.dart --no-pub` | PASS，9 tests | Flutter 3.32.0 Linux；Demo 结构、两按钮选型、真实滚动回顶，以及首屏 / 两种滚动态的 light/dark 严格 Golden |
| `flutter test ...backtop... --no-pub --exclude-tags golden` | PASS，38 tests | Flutter 3.47.0 |
| `flutter analyze` | PASS，0 error / 0 warning | 两个 SDK 均在组件包、示例包全量执行 |
| `dart run tool/generate_example_code.dart --check` | PASS | 2 个公开代码片段与页面实现一致，清理 2 个旧片段 |
| `sh ./demo_tool/all_build.sh` | PASS | API 文档覆盖组件、Theme 与两个枚举 |
| `flutter build web --release` | PASS | Flutter 3.32.0，Web Demo 可构建 |
| Linux `--update-goldens` 后无更新参数复跑 | PASS | Flutter 3.32.0；Demo 6 张、组件 8 状态矩阵 2 张及共享导航矩阵 2 张，严格比较 |
| 回归工具测试 | PASS，17 tests | 覆盖率、组件清单、视觉清单与代码片段生成器 |
| Android 16 `flutter test integration_test/backtop_example_test.dart -d 40302eeb` | PASS，1 test | 最终 Demo 的两按钮选型、真实滚动显隐、两种悬浮形态、点击回顶及 light/dark 切换 |
| Android 16 普通 APK 安装 | PASS | 最终 `lib/main.dart` debug APK 经 `adb install --no-streaming -r -t` 返回 `Success`；包路径存在，Launcher 任务前台可见，测试结束后应用仍保留 |

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

- [x] Figma 新分支的两个 `375 × 812` 移动画板、尺寸、顺序、间距和组件实例已读取
- [x] 小程序公开 Demo 的两按钮选型、300ms / 1000 滚动、点击回顶及默认阈值已读取
- [x] Flutter Demo 首屏 / 两种滚动态 light/dark 6 张 Linux Golden 与组件 8 状态矩阵 2 张已逐张核对
- [x] Android 16 真机重新完成可见的两按钮选型、滚动显隐、两种悬浮形态、点击回顶与明暗主题核对
- [x] 普通持久安装 App 中人工点击半圆形、回顶、主题切换和圆形，并逐张核对浅色半圆形与深色圆形截图

## 未覆盖项与后续工作

- 浏览器连接器的安全策略拒绝访问本机 `127.0.0.1` Demo，因此没有把 Web
  实际浏览器点击冒充为已完成；Web release 构建、真实 Widget 滚动交互和 Linux
  Golden 已通过。
- iOS 真机未验证；移动端操作验收以 Xiaomi Android 16 设备 `40302eeb` 为准。
- Figma 只提供浅色移动端画板，Flutter 深色主题是基于语义 Token 的扩展；系统状态栏也不在 Flutter Golden 边界内。两项差异均已在 `visual-comparison.md` 明示，并须由真机截图补证。
- GitHub PR #1079 在完整验收前已创建；本记录明确纠正交付顺序。最终真机、双 SDK、覆盖率与生成检查现已完成，仍须更新该 PR，并在 CNB 独立创建 PR、完成 CodeBuddy Review 后才可签收。
