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

## 验证

- [x] `flutter analyze` 改动文件无 error/warning。
- [ ] CI（flutter 3.32.0 与 latest）构建通过。
- [ ] 单元测试全绿（沙箱 pub-cache 不完整，需 CI 执行）。
