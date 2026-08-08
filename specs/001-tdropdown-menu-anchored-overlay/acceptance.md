# 验收记录

## 验证环境

- 分支：develop
- 提交：542d1b4c9da7e201ee9a2af35e71f67b4e79983a
- PR：[Tencent/tdesign-flutter#974](https://github.com/Tencent/tdesign-flutter/pull/974)
- Flutter：仓库当前最低支持版本 3.32.0

## 自动化验证

PR #974 已提交并合入以下自动化覆盖：

- 展开、滚动、自定义和禁用触发项；
- 打开/关闭回调、动画和 reduced-motion；
- 同菜单项切换、快速切换、切换中关闭和 Future 完成；
- Overlay、Navigator、滚动、视口、键盘和安全区；
- above、below、auto placement 及临界空间稳定性；
- 箭头方向、焦点、语义、Escape、系统返回、Controller 替换和 dispose；
- 动态移除、禁用当前项及面板高度重建。

建议在本地基线执行：

    cd tdesign-component
    flutter test test/components/dropdown_menu/t_dropdown_menu_test.dart

## 人工验收

- [ ] 窄屏下上下展开方向符合预期
- [ ] 键盘弹出时面板不遮挡输入区域且不越过安全区
- [ ] root Overlay 和嵌套 Overlay 下触发栏、面板、遮罩保持锚定
- [ ] 快速点击多个菜单项时无空白闪烁或旧面板残留
- [ ] 开启系统 reduced-motion 后无明显动画

## 未覆盖项与后续工作

- 目标设备上的视觉动画和复杂嵌套滚动仍需人工确认。
