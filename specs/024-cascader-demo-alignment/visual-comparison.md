# Cascader 视觉与交互对照

## 基线

- Figma：`TDesign-for-mobile--Community-` 节点 `24386:5246`。
- 小程序公开页：`https://tdesign.tencent.com/miniprogram/components/cascader`。
- Flutter 固定视口：375×812 CSS px，DPR 1；Golden 使用 Flutter 3.32.0 Linux。

## 设计属性矩阵

Figma 组件集显示 `theme: step/tab`、`step: 1/2/3/4`、`subtitle: true/false`、
`close-btn: true/false`。Flutter 将 Popup 标题与关闭按钮留在组合层，TCascader 只负责
step/tab 导航、活动层级次级标题和选项列表。

## 可见契约

- step 每层高度 44，节点直径 8；活动导航使用品牌色，箭头使用占位文字色。
- tab 导航高度 48，活动项使用 2px 品牌色指示线。
- 选项行高度 56、水平内边距 16；列表不继承系统安全区 padding；普通和已选文字保持主文字色，末级勾选图标使用品牌色。
- 分隔线使用 `componentStrokeColor`，背景使用 `bgColorContainer`，组件 Theme 与调用方显式 Flutter Theme 按字段覆盖。
- 次级标题位于导航与选项之间，使用 body-medium 和占位文字色，并随内部活动层级更新。

## 交互契约

- 基础和 tab 示例选择末级后立即提交、关闭并更新 Cell。
- 任意层示例允许停留在中间层，点击关闭按钮提交当前草稿；蒙层关闭不提交。
- 搜索命中末级后立即提交并关闭。

稳定的视觉回归基线由 `cascader_page_{light,dark}.png` 和
`cascader_{base,tab,subtitle,any,search}_opened_{light,dark}.png` 提供。
