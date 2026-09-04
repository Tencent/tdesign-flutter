# BackTop 视觉对齐记录

| 对齐项 | 设计 / 跨端依据 | Flutter 证据 | 结论 |
| --- | --- | --- | --- |
| 公开 Demo 状态矩阵 | [Figma BackTop 节点](https://www.figma.com/design/Kp5pFbm1YjcCBDrj0RUHjB/TDesign-for-mobile--Community-?node-id=24386-5237) | [浅色 Demo](../../tdesign-component/example/test/goldens/backtop_page_light.png)、[深色 Demo](../../tdesign-component/example/test/goldens/backtop_page_dark.png) | 圆形 / 半圆形、浅色 / 深色、带文案 / 无文案共 8 状态均由真实组件呈现 |
| 导航组件上下文 | Figma 组件集合 `24387:6706` | [浅色导航矩阵](../../tdesign-component/test/components/goldens/navigation_components_light.png)、[深色导航矩阵](../../tdesign-component/test/components/goldens/navigation_components_dark.png) | 48 圆形、40 高半圆、20 图标、0.5 边框和明暗 Token 已固化 |
| 操作模式 | [小程序 BackTop API](https://tdesign.tencent.com/miniprogram/components/back-top?tab=api) | `backtop_demo_test.dart` 的 200 阈值与点击回顶用例 | 沿用跨端的阈值和回顶语义，以 Flutter `ScrollController` 表达滚动状态 |

Golden 均在 Flutter 3.32.0 Linux 中生成，并在同一容器移除
`--update-goldens` 后再次通过精确比较。Figma 用于外观和状态依据；小程序用于公开
操作模式依据，不将其 `fixed`、`scroll-top`、字符串图标或 slot 机械复制为 Flutter API。
