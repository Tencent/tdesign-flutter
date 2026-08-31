# 验收记录

## 固定基线

- Flutter：`origin/develop` `ccace5c61383dc2c4fd5392f41222e65b54d8010`
- 小程序：`b60cdc8a1dce1f06dd45cb4e41eefd31c674e514`
- 公开运行页：`https://tdesign.tencent.com/miniprogram/live/m2w/program/miniprogram/#!pages/calendar/calendar.html`
- 截图视口：375×771 CSS px，DPR 2；已覆盖页面顶部与下半页 inline 日历入口。

## 验证命令

- Flutter 3.32.0：`flutter analyze --no-pub --fatal-infos`，0 error / 0 warning。
- Flutter 3.32.0：Calendar 7 个组件测试文件共 52 tests passed。
- Flutter 3.32.0：`example/test/calendar_demo_test.dart`，4 tests passed。
- Flutter 3.32.0 Linux：light/dark 两张 Golden 更新后立即无更新复跑，2 tests passed。
- Calendar 生产代码覆盖率：`640/648 = 98.77%`。
- Flutter 3.47.0：严格 analyze 与 Demo 测试通过；clean + pub get 后 Calendar 组件测试 52 tests passed。
- 回归矩阵自测 11 tests passed；示例代码生成 `--check` 无漂移。

## 视觉结论

- 两组标题、九个可见实例、分组说明、触发器顺序和日期文案与小程序公开 Demo 一致。
- Popup、标题、确认/取消、月份切换和逐实例本地化均由 Flutter 组合表达，没有复制小程序编排型 API。
- 小程序运行截图见 `evidence/miniprogram-top.jpg` 与 `evidence/miniprogram-lower.jpg`；Flutter 权威基线见 `tdesign-component/example/test/goldens/calendar_page_{light,dark}.png`。
- 截图复核发现并修复了六行月份最后一行被默认高度裁切的问题；修复后 2026 年 8 月的 30、31 日完整显示。

## 未验证项

- Android/iOS 系统字体的逐像素差异不由 Linux Golden 证明。
- 小程序公开运行页当前截图为深色模式；Flutter 同时固定了 light/dark 两套基线。
