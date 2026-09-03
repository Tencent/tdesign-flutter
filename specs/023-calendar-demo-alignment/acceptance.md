# Calendar 验收记录（2026-09-04）

## 当前基线与边界

- worktree：`/private/tmp/tdesign-calendar-picker-20260904`，分支 `rss1102/fix/calendar-picker-figma-alignment`。
- develop 基线 `a353a1ad`；按顺序合入 Calendar #1059、Picker #1062、DateTimePicker #1061，集成 HEAD `a73550ad`。本轮修复基于该集成提交继续完成。
- 本组件原 PR：#1059，固定 head `35b20b99a2101bf71d152745add872a8e8a06151`。本记录取代此前 PR 的验收结果，不表示远端 PR 已更新。
- Figma 分支 `4SdclZkcv5bPgX6pa8AsmI`，浏览器实看完整分组与弹出状态；截图见 `evidence/figma-*.png`。
- 小程序源码参考 `ae55fb050b7a9474c33752b45b71c741f37ed872`；逐项 API/default 审查见 `spec.md`。
- 三个组件本体均为平铺面板。Popup、标题、临时值、取消/确认均属于调用方组合，不新增容器开关。

## 验证结果

- Flutter 3.32.0 Linux 与本机 Flutter 3.47.0：`flutter analyze --no-pub --fatal-infos` 无问题。
- 两版本三个组件及调度器合计 223 项测试通过；三个 Demo 合计 16 项通过，本组件 Demo 为 6 项。最终局部修订按受影响套件复跑。
- 本组件生产源码覆盖率 `640/648 = 98.77%`，门禁为 95%；覆盖率由独立组件测试产生，没有混入 Demo 页面。
- Flutter 3.32.0 Linux：本组件 20 项 Golden；三组件合计 52 项，含 6 张完整页面、44 张通过真实点击打开的面板、2 张 Calendar 状态矩阵。全部更新后以无更新参数复跑通过。
- 使用默认精确 Golden 比较器，无自定义容差；最终差异 0%。Figma 是人工视觉对照，不是自动像素比较。已检查完整页面与所有打开态，并针对缺字、描述样式、国际化星期和窄屏年份修正后再次复核。
- `dart run tool/generate_example_code.dart --check` 通过；片段来自源码生成。
- `run_component_regression.dart`、`check_component_coverage.dart` 与 `run_visual_regression.dart` 已登记。Calendar 的组件状态与 Demo 有不同工作目录，允许同一组件拥有多个具名视觉套件；配置自测通过。
- GitHub 与 CNB 双版本功能入口包含三个 Demo；实际远端 CI 未运行，本记录仅代表本地执行。

## 复现入口

```sh
# tdesign-component 目录，安装依赖后
flutter analyze --no-pub --fatal-infos
flutter test --no-pub --exclude-tags golden --coverage test/components/calendar test/components/picker test/components/date_time_picker test/t_calendar_test.dart test/t_calendar_lunar_test.dart test/t_calendar_on_change_init_test.dart test/t_date_time_picker_test.dart test/tool
dart tool/check_component_coverage.dart calendar
# example 目录；纯 Golden 仅在 Flutter 3.32.0 Linux 执行
flutter test --no-pub test/calendar_demo_test.dart
flutter test --no-pub test/calendar_demo_golden_test.dart
```

## 限制与交付

- 使用本机已有 SDK、Docker 镜像、pub 缓存及测试字体；依赖解析为离线模式，没有为本轮验证安装新软件。
- 没有进行 Android/iOS 真机触控与系统字体的逐像素验收；Flutter 滚轮保留自身透视与惯性，不宣称与小程序渲染逐像素相同。
- Figma 设计截图中长地区占位串以真实地区名称替代；完整六列日期时间示例省略年份单位以完整呈现四位年份。
- 本记录为提交前的本地验收快照；远端 CI 与 CNB Review 结果以平台记录为准。新增 DateMode.monthDay 对使用穷尽 switch 的调用方存在枚举扩展兼容风险；其他组件不新增公开 API。
