# 验收记录

## 固定基线

- Flutter：`origin/develop` `f3e14c43626935dc87928753a902c68ce4494421`
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
- Flutter 3.32.0：TCascader 组件回归 17 tests passed；Demo 功能 5 tests passed。
- Flutter 3.32.0：TPopup 保持 develop 的 Container 背景、圆角与裁剪；TSearchBar
  仅在内部 TextField 边界提供透明 Material 上下文，Popup、ActionSheet、Search 与
  Cascader 聚焦回归通过。
- Flutter 3.32.0 Linux：2 张关闭状态与 10 张打开状态 light/dark Golden 更新后立即无更新复跑，12 tests passed。
- Cascader 生产代码覆盖率：`248/251 = 98.80%`。
- Search 生产代码覆盖率：`193/197 = 97.97%`。
- Flutter 3.47.0：严格 analyze、TCascader 17 tests、TPopup 46 tests、
  TSearchBar 无 Material 宿主回归与 Demo 5 tests passed。
- 回归矩阵自测 11 tests passed；示例代码生成 `--check` 无漂移。

## 视觉结论

- 两组标题、七个触发实例、说明条与地址字段顺序均与小程序公开 Demo 一致。
- 小程序截图见 `evidence/miniprogram-top.jpg`；Flutter 权威基线见 `tdesign-component/example/test/goldens/cascader_page_{light,dark}.png`。
- TCascader 自身实现 step/tab 导航、活动层级次级标题、选项列表和 TDesign 默认样式；Popup、搜索和提交策略由 Flutter 组合完成。
- 打开状态覆盖基础、tab、次级标题、任意层和搜索五种场景，并分别固定 light/dark 基线。
- 已在连接设备上完成基础三级选择：弹层逐级切换、末级提交、自动关闭和 Cell 回显均符合交互契约。
- 真机验证发现选项列表曾继承系统顶部安全区，造成导航分隔线下出现额外空白；组件现显式使用零列表内边距，并由非零安全区组件测试防止回归。

## 未验证项

- 不同系统字体的逐像素差异不由 Linux Golden 证明。
