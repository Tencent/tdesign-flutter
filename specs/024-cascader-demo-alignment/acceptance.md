# 验收记录

## 固定基线

- Flutter：`origin/develop` `f3e14c43626935dc87928753a902c68ce4494421`
- 小程序：`b60cdc8a1dce1f06dd45cb4e41eefd31c674e514`
- 公开运行页：`https://tdesign.tencent.com/miniprogram/live/m2w/program/miniprogram/#!pages/cascader/cascader.html`
- 截图视口：375×771 CSS px，DPR 2。

## API Review 结论

- 默认值来源复核：step 44、圆点 8、箭头 22、次级标题顶部 20、左右 16
  直接对应小程序样式与设计矩阵；选项文案使用小程序 Radio 的 body-large，
  step 与次级标题使用 body-medium，颜色和分隔线继续使用 TDesign Token。
  Flutter 平铺面板高度 360 与小程序 Popup 内容高度 78vh 职责不同，保留 360，
  但 Theme 插值按 360 的运行时有效默认值计算。

- `TCascaderOption` 比小程序动态 `keys` 更符合 Dart typed model；转换应位于业务数据进入组件的边界。
- `value + onChanged`、`onChanged == null` 禁用、`variant` 形态所有权均已收敛，无重复公开入口。
- `subtitles` 只提供按内部活动层级读取的文案，不公开 `activeLevel`，不会形成第二套状态源。
- Popup、标题、搜索框、过滤结果和提交策略通过现有 Flutter 组件组合，不新增平台弹层 API。
- 保留既有 tab 默认值；基础 Demo 显式使用 step，在不破坏兼容性的前提下对齐可见效果。

## 验证结果

- Flutter 3.32.0：组件包及 Demo 工程 `flutter analyze --no-pub`，均为 0 error / 0 warning。
- Flutter 3.32.0：TCascader 组件回归 24 tests passed；与 Search、TText、共享主题
  组合回归 54 tests passed；Demo 功能 6 tests passed。
- Flutter 3.32.0：TPopup 保持 develop 的 Container 背景、圆角与裁剪；TSearchBar
  仅在内部 TextField 边界提供透明 Material 上下文，Popup、ActionSheet、Search 与
  Cascader 聚焦回归通过。
- Flutter 3.32.0 Linux：按小程序 Radio body-large 修正 TCascader 局部主题污染后，
  2 张关闭状态基线保持不变，10 张打开状态 light/dark Golden 更新；组件级 2 张
  light/dark 基线同步活动导航品牌色，并登记到统一视觉回归入口。最终 14 tests passed；
  同一容器中 PR 原始 head 的旧 Demo 基线 12 tests passed，排除了容器字体差异。
- Cascader 生产代码覆盖率：`308/315 = 97.78%`。
- Search 生产代码覆盖率：`193/197 = 97.97%`。
- TCascader 分隔线只接受显式 Material 覆盖，TThemeBuilder 投影的默认值不会覆盖
  TDesign `componentStrokeColor`；公开代码片段列明七个示例的受控状态和差异配置。
- Flutter 3.47.0：组件包及 Demo 工程严格 analyze 通过；TCascader、Search、TText、
  共享主题组合回归 54 tests passed，Demo 6 tests passed。
- 回归、覆盖率及 Golden 清单自测 13 tests passed；API 文档重新生成，示例代码生成
  `--check` 无漂移。

## 视觉结论

- 两组标题、七个触发实例、说明条与地址字段顺序均与小程序公开 Demo 一致。
- 小程序截图见 `evidence/miniprogram-top.jpg`；Flutter 权威基线见 `tdesign-component/example/test/goldens/cascader_page_{light,dark}.png`。
- TCascader 自身实现 step/tab 导航、活动层级次级标题、选项列表和 TDesign 默认样式；Popup、搜索和提交策略由 Flutter 组合完成。
- 打开状态覆盖基础、tab、次级标题、任意层和搜索五种场景，并分别固定 light/dark 基线。
- 已在连接设备上完成基础三级选择：弹层逐级切换、末级提交、自动关闭和 Cell 回显均符合交互契约。
- 真机验证发现选项列表曾继承系统顶部安全区，造成导航分隔线下出现额外空白；组件现显式使用零列表内边距，并由非零安全区组件测试防止回归。

## 未验证项

- 不同系统字体的逐像素差异不由 Linux Golden 证明。
