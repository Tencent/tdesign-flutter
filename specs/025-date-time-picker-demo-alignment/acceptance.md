# 验收记录

## 固定基线

- Flutter：`origin/develop` `ccace5c61383dc2c4fd5392f41222e65b54d8010`
- 小程序：`b60cdc8a1dce1f06dd45cb4e41eefd31c674e514`
- 公开运行页：`https://tdesign.tencent.com/miniprogram/live/m2w/program/miniprogram/#!pages/date-time-picker/date-time-picker.html`
- 截图视口：375×771 CSS px，DPR 2。

## API Review 结论

- 现有 typed mode/value/steps 比字符串格式和动态对象更符合 Flutter/Dart 设计，无重复公开入口。
- Popup、标题、按钮和提交草稿由组合层负责；组件保持纯滚轮，生产源码无需修改。
- 保留年月日默认 mode 与实时 `onChanged` 语义，不引入 breaking change。

## 验证结果

- Flutter 3.32.0 / 3.47.0：严格 analyze 均为 0 error / 0 warning。
- 两个版本：DateTimePicker 组件回归均为 131 tests passed；Demo 均为 4 tests passed。
- Flutter 3.32.0 Linux：light/dark 两张全页 Golden 更新后立即无更新复跑，2 tests passed。
- DateTimePicker 生产代码覆盖率：`658/678 = 97.05%`。
- 回归矩阵自测 11 tests passed；示例代码生成 `--check` 无漂移。

## 视觉结论

- 两组七个可见实例、说明条、字段标题和值与小程序公开 Demo 的信息结构一致。
- 小程序截图见 `evidence/miniprogram-top.jpg`；Flutter 权威基线见 `tdesign-component/example/test/goldens/date_time_picker_page_{light,dark}.png`。
- 本次未修改 `lib/src/components/date_time_picker/` 生产源码。

## 未验证项

- Android/iOS 系统字体的逐像素差异不由 Linux Golden 证明。
