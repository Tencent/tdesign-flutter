# NavBar 三方视觉与交互对照

| 对照项 | 新版 Figma | 小程序 develop | Flutter 收敛结论 |
| --- | --- | --- | --- |
| 页面画板 | H5/Flutter 与小程序各 `375 × 1318`，间距 32 | 单一小程序 Demo 页面 | Flutter 严格对齐 H5/Flutter 画板，不混用小程序宿主区域 |
| 基础组合 | H5/Flutter 展示返回、左侧多操作、右侧多操作 | 无返回、显式返回、自定义左侧胶囊 | Demo 使用 Figma H5/Flutter 三组合；组件默认无返回对齐跨端共同契约 |
| 搜索 | 搜索框 + H5 右侧首页 / 更多 | 252px 搜索框，右侧是宿主系统胶囊 | Flutter 保留真实搜索与右侧 Widget 操作，不绘制微信系统胶囊 |
| 图片 | TDesign Logo + H5 右侧首页 / 更多 | Logo `87 × 24`，右侧是宿主系统胶囊 | Flutter Logo 固定 `87 × 24` 并保留 Figma H5 操作项 |
| 标题 | 居中、左对齐、普通返回文字、28/36 大标题 | 同顺序；Title Large、16px 返回、28/36 大标题 | 使用 Title Large Token；大标题仍由 `belowTitleWidget` 组合 |
| 自定义颜色 | 品牌蓝背景、白色内容 | CSS 变量覆盖为 `#0052D9` / white | Flutter 用语义品牌 Token 与实例前景色 |
| 系统区域 | 画板绘制 iOS 状态栏；小程序画板绘制微信胶囊 | `safeAreaInsetTop` 和宿主胶囊由微信拥有 | Flutter Golden 不包含宿主系统栏；`useSafeArea` 由页面布局显式决定 |
| 深色主题 | 当前 Figma 页面无深色画板 | 语义变量支持主题 | Flutter 以 TDesign 语义 Token 扩展，并独立严格 Golden |

## 已确认的设计差异

- 新版 Figma 明确把 H5/Flutter 和小程序拆成两个移动画板。小程序每行右侧的“更多 / 关闭”胶囊是微信宿主 UI，不是 `TNavBar` 可移植内容。
- 小程序 Demo 的基础状态先展示无返回再展示显式返回；Figma H5/Flutter 基础区用三种带返回的组合展示操作能力。Flutter 组件默认值按跨端公开契约收敛为无返回，但公开 Demo 的可见组合按 H5/Flutter 画板展示。
- 小程序搜索占位为“搜索内容”，新版 Figma H5/Flutter 画板为“搜索预设文案”；Flutter Demo 优先采用 Figma 文案，并记录该差异。
