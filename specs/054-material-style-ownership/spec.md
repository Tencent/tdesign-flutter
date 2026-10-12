# TD 内置样式所有权

## 目标与行为契约

外部 Material/M2/M3 默认或显式 Theme 配置均不得控制 TD 内置样式。保留已有组件实例样式、TD ThemeExtension、Token、Flutter 亮暗模式、字体缩放、平台输入、焦点、无障碍机制，以及调用方内容自身的主题行为。此项优先于此前允许标准 Material 主题作为视觉配置入口的泛化规则。

- 内置文字通过共享解析器形成完整、禁止继承的 TextStyle；已有实例/TD 字体、字距等配置继续生效。
- 内置图标不继承 Material IconTheme 的透明度、阴影、字体轴或缩放开关；显式 TD size/color 与组件内部图标作用域继续生效。
- 内置 TextField、IconButton、ListTile、Slider、进度指示器、InkWell、Divider 的样式由 TD 控制，不接受外部 Material 组件 Theme 的隐式或显式覆盖。
- child、prefix、suffix、builder 内容保留原始 Material Theme；既有 TD 内容默认排版不删除，子内容显式样式仍优先。
- 禁用、选择、值、回调与控制器语义不变。不以主题控制业务能力。
- 默认呈现变化与移除 Material 样式控制属于 breaking change，迁移到已有 TD Theme 或组件实例 style。

## 验收

先共享文字、图标，后逐组件验证；Flutter 3.32.0 与最新 stable 功能与严格分析通过；Linux 3.32.0 Golden 先比较，再仅更新有意差异并无更新重跑。
