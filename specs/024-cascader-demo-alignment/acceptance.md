# 验收记录

## 固定基线

- Flutter：`origin/develop` `e5d890e4108d79afdd15fbf5c234d64668a5a5d3`
- 小程序：`b60cdc8a1dce1f06dd45cb4e41eefd31c674e514`
- 公开运行页：`https://tdesign.tencent.com/miniprogram/live/m2w/program/miniprogram/#!pages/cascader/cascader.html`
- 截图视口：375×771 CSS px，DPR 2。

## API Review 结论

- `TCascaderOption` 比小程序动态 `keys` 更符合 Dart typed model；转换应位于业务数据进入组件的边界。
- `value + onChanged`、`onChanged == null` 禁用、`variant` 形态所有权均已收敛，无重复公开入口。
- `subtitles` 只提供按内部活动层级读取的文案，不公开 `activeLevel`，不会形成第二套状态源。
- Popup、标题、搜索框、过滤结果和提交策略通过现有 Flutter 组件组合，不新增平台弹层 API。
- 保留既有 tab 默认值；基础 Demo 显式使用 step，在不破坏兼容性的前提下对齐可见效果。

## 验证结果

- Flutter 3.32.0：`flutter analyze --no-pub --fatal-infos`，0 error / 0 warning。
- Flutter 3.32.0：TCascader 组件回归 16 tests passed；Demo 功能 5 tests passed。
- Flutter 3.32.0 Linux：2 张关闭状态与 10 张打开状态 light/dark Golden 更新后立即无更新复跑，12 tests passed。
- Cascader 生产代码覆盖率：`248/251 = 98.80%`。
- Flutter 3.47.0：严格 analyze、TCascader 16 tests 与 Demo 5 tests passed。
- 回归矩阵自测 11 tests passed；示例代码生成 `--check` 无漂移。

## 视觉结论

- 两组标题、七个触发实例、说明条与地址字段顺序均与小程序公开 Demo 一致。
- 小程序截图见 `evidence/miniprogram-top.jpg`；Flutter 权威基线见 `tdesign-component/example/test/goldens/cascader_page_{light,dark}.png`。
- TCascader 自身实现 step/tab 导航、活动层级次级标题、选项列表和 TDesign 默认样式；Popup、搜索和提交策略由 Flutter 组合完成。
- 打开状态覆盖基础、tab、次级标题、任意层和搜索五种场景，并分别固定 light/dark 基线。

## 未验证项

- Android/iOS 系统字体的逐像素差异不由 Linux Golden 证明。
