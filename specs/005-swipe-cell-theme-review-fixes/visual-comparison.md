# Issue #1027 视觉对比：SwipeCell

## 结论

- 问题归属：组件，需重点提示。
- Demo 没有为动作文字传入颜色；黑色来自 `TSwipeCellAction` 的样式合并顺序，外层 `DefaultTextStyle` 覆盖了组件默认 `textColorAnti`。
- 修复后仍继承外层字号、字重等排版属性，但默认颜色重新落回 `textColorAnti`；P1 `actionTextStyle` 与 P0 `labelStyle` 仍可显式覆盖。

## Golden 对比

完整修改前、修改后与独立像素差异图保存在 GitHub PR #1131 描述的附件中，不作为 Spec 二进制文件提交。差异只覆盖“收藏 / 编辑 / 删除”三处动作文字颜色。

- 代表性 light 展开态 Golden：`818 / 21952 = 3.73%` 像素发生变化。
- 新增 light / dark 两张展开态组件 Golden；原有关闭态 Demo 页面 Golden 无变化。
