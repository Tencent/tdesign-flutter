# Calendar 验收记录（2026-09-04）

## 分支与范围

- 原 PR #1059，分支 `rss1102/style/calendar-demo-alignment`，在原 head `35b20b99` 上追加本组件改动，未合入其他组件 PR。
- 本组件保持平铺、受控面板；Popup、标题、临时值、取消/确认由调用方组合。
- Figma 分支 `4SdclZkcv5bPgX6pa8AsmI` 为视觉依据；已提交截图见 `evidence/figma-*.png`。小程序源码参考 `ae55fb050b7a9474c33752b45b71c741f37ed872`，API/default 对照见 `spec.md`。
- 本 PR 不新增公开 API。

## 验证证据

- 合并最新 `develop` 后，Flutter 3.32.0 严格 `flutter analyze --fatal-infos --fatal-warnings` 无问题，56 项组件测试通过；共享 widget_test.dart 的 6 项冒烟测试通过，日历弹层标题/关闭断言已同步。
- 各 PR 独立工作区使用已有 Flutter 3.32.0 Linux 镜像和离线 pub 缓存生成权威 Golden，随后无更新参数复跑通过；本组件 4 项 Demo 测试和 20 项 Demo Golden、2 项组件状态 Golden 通过。
- Golden 使用默认精确比较器；Figma 为人工视觉对照，不是 Figma 自动像素比较。拆分后的代表性打开态已复核。
- 拆分前相同组件实现还通过 Flutter 3.47.0 analyze/功能验证；生产源码覆盖率为 `640/648 = 98.77%`。此项是此前集成验证的记录，不冒充拆分后重新测量。
- 合并最新 `develop` 后，另以 Flutter 3.44.0 严格 analyze、40 项定向组件/调度测试和 10 项 example 测试复跑通过。
- 原 PR 已登记本组件的组件/Demo/覆盖率/视觉入口；Calendar Demo 与组件状态矩阵作为两个具名视觉套件进入 Flutter 3.32.0 Linux 调度。本次不引入其他两个组件的测试调度。远端 CI 与独立 CNB Review 以各自 PR/Issue 记录为准。

## 复现与限制

```sh
# tdesign-component
flutter analyze --no-pub --fatal-infos
flutter test --no-pub --exclude-tags golden test/components/calendar
# example；Golden 使用 Flutter 3.32.0 Linux
flutter test --no-pub test/calendar_demo_test.dart test/calendar_demo_golden_test.dart
```

未进行 Android/iOS 真机触控与系统字体验收。未安装新软件；Flutter 3.44.0 首次解析仅刷新共享 pub 缓存，随后各分支禁网验证。三个原 PR 分别推送、分别 Review。
