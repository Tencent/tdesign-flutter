# TNoticeBar Review 修复 - 任务清单

状态标记：`[ ]` 待办，`[x]` 进行中/已完成（按 DONE 更新）。

## 代码修复

- [x] `_scroll()` 滚动距离改用可视区宽度 `_getEmptyWidth()`，移除屏宽依赖。
- [x] `_getFontSize()` 文本布局 `maxWidth` 改用可视区宽度。
- [x] 删除冗余 getter `_effectiveMarquee`、`_effectiveInterval`。
- [x] 统一 `widget.marquee`、`widget.interval` 引用。

## 测试补充

- [x] 新增水平滚动距离回归测试（容器宽 vs 屏幕宽）。
- [x] 加强 variant `resolve` 色值断言为具体 Token 色值。
- [x] 新增各 variant 背景色校验测试。

## 文档

- [x] 创建 Spec `specs/005-notice-bar-review/`。
- [x] 同步站点 README `tdesign-site/docs/components/notice-bar/README.md` 为当前 API。
- [x] 按官方 3 个分组、8 个 Demo 块重排公开页面。
- [x] 对齐各实例文案、图标、操作区和顺序，并关闭公开页面的内部测试分组。
- [x] 同步生成代码并加强 Example 矩阵测试。

## 验证

- [x] `flutter analyze` 改动文件无 error/warning。
- [x] Flutter 3.32.0 与 latest 的 NoticeBar 组件测试各 42 项通过。
- [x] Flutter 3.32.0 与 latest 的 Example 测试通过。
- [x] Flutter 3.32.0 与 latest 严格 analyze 均为 0 issues。
- [x] NoticeBar 生产源码覆盖率 96.23%（`LH=230` / `LF=239`）。
- [ ] 获取 interval、operation、默认图标、垂直交互和内边距等契约的维护者决策。
- [x] 更新并复验 Flutter 3.32.0 Linux light/dark Golden。
- [x] 完成固定视口 light/dark 页面截图验收。
- [ ] 完成真实设备触摸、循环与逐帧验收。
