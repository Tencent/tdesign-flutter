# TNoticeBar Review 修复 - 任务清单

状态标记：`[ ]` 待办，`[x]` 进行中/已完成（按 DONE 更新）。

## 代码修复

- [x] `_scroll()` 滚动距离改用可视区宽度 `_getEmptyWidth()`，移除屏宽依赖。
- [x] `_getFontSize()` 文本布局 `maxWidth` 改用可视区宽度。
- [x] 删除冗余 getter `_effectiveMarquee`、`_effectiveInterval`。
- [x] 统一 `widget.marquee`、`widget.interval` 引用。
- [x] 新增实例 `status`，移除 ThemeData 中重复的 `variant` 状态入口。
- [x] 将 `left` / `prefixIcon` 收敛为 `prefix` Widget 插槽。
- [x] 将 `right` 收敛为 `operation` Widget 插槽，并允许和 `suffixIcon` 共存。
- [x] `interval` 默认值改为 2 秒；`speed` 仅控制横向跑马灯。
- [x] 纵向轮播由 `direction + items` 启用，不再依赖 `marquee`。

## 测试补充

- [x] 新增水平滚动距离回归测试（容器宽 vs 屏幕宽）。
- [x] 加强 status `resolve` 色值断言为具体 Token 色值。
- [x] 新增各 status 默认图标、背景色和 operation 点击测试。
- [x] 固定 `items` 优先于 `content`，以及自定义 `Icon` 继承状态颜色和标准尺寸的契约测试。

## 文档

- [x] 创建 Spec `specs/005-notice-bar-review/`。
- [x] 同步站点 README `tdesign-site/docs/components/notice-bar/README.md` 为当前 API。
- [x] 按官方 3 个分组、8 个 Demo 块重排公开页面。
- [x] 对齐各实例文案、图标、操作区和顺序，并关闭公开页面的内部测试分组。
- [x] 同步生成代码并加强 Example 矩阵测试。

## 验证

- [x] `flutter analyze` 改动文件无 error/warning。
- [x] Flutter 3.32.0 与 latest 的 NoticeBar 组件测试各 45 项通过。
- [x] Flutter 3.32.0 与 latest 的 Example 测试通过。
- [x] Flutter 3.32.0 与 latest 严格 analyze 均为 0 issues。
- [x] NoticeBar 生产源码覆盖率 96.08%（`LH=245` / `LF=255`）。
- [x] 获取 interval、speed、operation、默认图标、prefix 和垂直轮播契约的维护者决策。
- [x] 更新并复验 Flutter 3.32.0 Linux light/dark Golden。
- [x] 完成收敛后固定视口 light/dark 页面截图验收。
- [ ] 完成真实设备触摸、循环与逐帧验收。
