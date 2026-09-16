# 运行截图比对

主基线：Figma `TDesign for mobile` 分支稿的 Dialog 页面（节点 `24386:5278`，由用户提供的分支设计链接进入），统一使用 375dp 宽移动端画板；`tdesign-miniprogram@1.16.0`（`ae55fb050b7a9474c33752b45b71c741f37ed872`）仅作为公开 Demo 结构的辅助证据。Flutter 截图覆盖公开页面和带关闭按钮弹层的 light/dark；系统导航栏与宿主字体属于平台合理差异。

| 场景 | 小程序 | Flutter light | Flutter dark |
| --- | --- | --- | --- |
| 公开 Demo 页面 | ![小程序页面](evidence/miniprogram-page.png) | ![Flutter 浅色页面](evidence/flutter-page-light.png) | ![Flutter 深色页面](evidence/flutter-page-dark.png) |
| 对话框打开态 | ![小程序打开态](evidence/miniprogram-open.png) | ![Flutter 浅色打开态](evidence/flutter-open-light.png) | ![Flutter 深色打开态](evidence/flutter-open-dark.png) |

人工核对结论：三组场景、22 个入口、默认顶边距和关闭按钮位置符合公开 Demo 视觉基线；图片、输入和开放能力按钮继续通过 Flutter Widget / `TDialogAction` 组合表达，没有新增跨端专用公共 API。截图证明页面与关键打开态布局，不替代 22 个入口的逐项输入、返回值和连续交互验收。

## Issue #1027 像素复核

本轮再次读取 Figma `24386:5278` 下的具体实例：长内容 `27360:22420`、确认类无标题 `27360:22456`、确认类纯标题 `27360:22476`、输入类 `27360:22499` / `27360:22500`，以及六种图片实例 `27360:22572`、`27360:22583`、`27360:22603`、`27360:22632`、`27360:22633`、`27360:22634`。设计稿明确显示 4dp 滚动条、品牌填充确认按钮、文字输入 Footer、全宽图片和 24dp 间距。关闭图标按用户走查值复核可见边界 top/end 8dp。

责任边界：滚动条和关闭图标由 `TDialog` 默认实现负责，属于组件修复；确认/输入/组件用法的按钮组合与六种图片内容编排属于公开 Demo 修复。Demo 不通过额外外壳覆盖组件的默认滚动和关闭按钮样式。
