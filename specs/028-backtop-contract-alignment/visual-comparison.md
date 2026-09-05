# BackTop 视觉对齐记录

| 对齐项 | 设计 / 跨端依据 | Flutter 证据 | 结论 |
| --- | --- | --- | --- |
| 公开 Demo 首屏 | [Figma 分支 BackTop 节点](https://www.figma.com/design/jivYXTMTP3jEkeZXWbMh4J/branch/4SdclZkcv5bPgX6pa8AsmI/TDesign-for-mobile?node-id=24386-5237) 的 `375 × 812` 移动画板 | [浅色首屏](../../tdesign-component/example/test/goldens/backtop_page_light.png)、[深色首屏](../../tdesign-component/example/test/goldens/backtop_page_dark.png) | 标题、说明、组件类型、两个全宽描边按钮和双列骨架的顺序与间距已锁定 |
| 公开 Demo 滚动态 | 同一 Figma 节点的圆形 / 半圆形移动端展示 | `backtop_page_circle_scrolled_{light,dark}.png`、`backtop_page_half-round_scrolled_{light,dark}.png` | 固定视口内真实滚动后由单个组件呈现对应悬浮形态；圆形保留标准浮动间距，半圆形直边贴齐屏幕右边缘；形态切换不产生缩放中间态 |
| 组件状态矩阵 | 同一 Figma 页面的 BackTop 组件实例 | [浅色组件矩阵](../../tdesign-component/test/components/backtop/goldens/backtop_state_matrix_light.png)、[深色组件矩阵](../../tdesign-component/test/components/backtop/goldens/backtop_state_matrix_dark.png) | 48 圆形、40 高半圆、20 图标、0.5 边框，以及形态 / 配色 / 文案 8 状态已固化 |
| 操作模式 | [小程序 BackTop API](https://tdesign.tencent.com/miniprogram/components/back-top?tab=api) 与 `develop` 分支 `_example/back-top.ts` | `backtop_demo_test.dart` 的按钮选型、300ms 滚动至最多 1000、200 显隐阈值与点击回顶用例 | 沿用小程序公开 Demo 的操作流程，以 Flutter `ScrollController` 表达滚动状态 |

Golden 均在 Flutter 3.32.0 Linux 中生成，并在同一容器移除
`--update-goldens` 后再次通过精确比较。Figma 用于外观、布局和状态依据；小程序用于公开
操作模式依据，不将其 `fixed`、`scroll-top`、字符串图标或 slot 机械复制为 Flutter API。

## 跨端差异提醒

- Figma 当前仅提供浅色移动端设计画板；Flutter 深色页面是依照 TDesign 语义 Token 的平台主题扩展，已用独立严格 Golden 固化，不能宣称为 Figma 中已有的深色稿。
- Figma 画板包含 iOS 状态栏和底部 Home Indicator；Flutter Golden 的边界从应用内容开始，不绘制宿主系统栏。Android 真机验收必须补充完整屏幕截图确认系统栏、页面与悬浮控件没有冲突。
- 小程序使用 `wx.pageScrollTo` 与组件 `fixed` 定位；Flutter 使用页面 `ScrollController` 和父级 `Stack` 定位。这是平台机制差异，操作结果保持一致，不映射成同名 API。
