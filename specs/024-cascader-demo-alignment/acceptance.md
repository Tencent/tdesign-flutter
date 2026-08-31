# 验收记录

## 固定基线

- Flutter：`origin/develop` `ccace5c61383dc2c4fd5392f41222e65b54d8010`
- 小程序：`b60cdc8a1dce1f06dd45cb4e41eefd31c674e514`
- 公开运行页：`https://tdesign.tencent.com/miniprogram/live/m2w/program/miniprogram/#!pages/cascader/cascader.html`
- 截图视口：375×771 CSS px，DPR 2。

## API Review 结论

- `TCascaderOption` 比小程序动态 `keys` 更符合 Dart typed model；转换应位于业务数据进入组件的边界。
- `value + onChanged`、`onChanged == null` 禁用、`variant` 形态所有权均已收敛，无重复公开入口。
- Popup、标题、搜索框、过滤结果、确认策略和次级说明可通过现有 Flutter 组件组合，不新增平台编排 API。
- 保留既有 tab 默认值；基础 Demo 显式使用 step，在不破坏兼容性的前提下对齐可见效果。

## 验证结果

- Flutter 3.32.0：`flutter analyze --no-pub --fatal-infos`，0 error / 0 warning。
- Flutter 3.32.0：TCascader 组件回归 14 tests passed；Demo 功能 4 tests passed。
- Flutter 3.32.0 Linux：light/dark 两张全页 Golden 更新后立即无更新复跑，2 tests passed。
- Cascader 生产代码覆盖率：`163/166 = 98.19%`。
- Flutter 3.47.0：严格 analyze 与组件回归通过；example clean + pub get 后 Demo 4 tests passed。
- 回归矩阵自测 11 tests passed；示例代码生成 `--check` 无漂移。

## 视觉结论

- 两组标题、七个触发实例、说明条与地址字段顺序均与小程序公开 Demo 一致。
- 小程序截图见 `evidence/miniprogram-top.jpg`；Flutter 权威基线见 `tdesign-component/example/test/goldens/cascader_page_{light,dark}.png`。
- 所有进阶能力都由 Flutter 组合完成，本次未修改 `lib/src/components/cascader/` 生产源码。

## 未验证项

- Android/iOS 系统字体的逐像素差异不由 Linux Golden 证明。
