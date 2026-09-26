# 实施方案

## 2026-09-25 胶囊几何修复

- 将图标项与图文项的 20px 图标默认尺寸收回 `TTabBar` 的 IconTheme；
  默认 Demo 删除重复的 `Icon(size: 20)`，显式尺寸继续优先。
- 胶囊外栏保留 16px 页面侧边距；内部改用 8px 四边内边距和 8px 项间距，
  项宽由可用宽度减去内边距与间距后等分，不再从全屏宽度扣 2px 估算。
- 胶囊选中背景使用完整项宽及 40px 内容高度；图文内容在项内垂直居中，
  徽标继续锚定图标。无动画与滑动指示器使用同一几何来源。
- 以 4 项图文带徽标、纯图标、纯文本及窄宽度场景作组件回归；对照截图
  只比较相同配置，旧 Demo Golden 不作为新阴影的设计目标。

## 本轮补充修复

- 移除 `TTabBar.centerDistance` 与 `TTabBarThemeData.centerDistance`，图文项
  间距由组件按布局内置解析（上下 0px、左右 4px），避免暴露缺乏公开场景的
  第二个间距覆盖入口。该删除属于 breaking API 变更；自定义间距无直接替代参数。
- 从 TabBar 源码重新生成 API 文档，核对新增 `iconTextLayout` 与图文 Badge
  锚点说明；不手写生成产物，也不改变公开 Demo 布局。
- 将二级菜单默认宽度从单纯的“标签项宽度减 20”调整为带 107px 设计下限的内部规则；保留既有 `popUpWidth` 显式覆盖，不增加 API。
- 为九个公开实例统一执行一次真实点击，并用明暗 postAction Golden 覆盖切换后的完整页面；二级菜单展开态仍使用独立 Golden。
- 为纯文本点击 Toast 和双层菜单选择 Toast 分别补充明暗 Overlay Golden；注册集合测试逐项映射 9 个初始态、9 个选中态和 3 类独立交互态。
- 内部文字 defaults 低于调用方主题，字段来源解析与 Steps 共享；无 defaults 的既有消费者保持原路径。
- PopupRoute 捕获调用子树主题，面板统一绘制背景；内部路由、状态、画笔与徽标适配类不再公开导出。
- 同步无动画与动画切换状态，中断动画从当前进度开始；Demo 受控状态由页面 State 持有。
- 逐个验证七个真实代码面板、核心片段编译及滚动后的菜单锚点，增加菜单展开明暗 Golden。
- 删除把 Figma 整栏方向误建模为图文排列的 `layout`；普通图文项恢复固定纵向内容结构。
- 水波纹与非水波纹路径各只保留一个点击识别器，并收敛回调文档与次数测试。
- 不为单个组件扩展公共 `ExamplePage` 导航标题 API；页面壳差异不进入组件契约。
- 将纯文本徽标的标准位置从 Demo 固定 offset 收回 TabBar 内部；实例 offset、
  局部 BadgeTheme 和全局 BadgeTheme 仍按原优先级覆盖，图标与图文不改变默认锚点。
- 将图文项的徽标 child 从整列 `图标 + 文字` 收敛为图标本身，保持 TBadge 默认
  右上角语义，避免文字宽度改变 Badge 的水平位置。

## 技术方案

- 用 `TTabBarType`、`TTabBarItemStyle`、`TTabBarStyle` 替代混合语义的
  `TTabBarVariant`。
- 组件内部从三个正交参数派生渲染；普通图文项默认上下排列，新增独立的
  `iconTextLayout` 选择 Figma 中图标在左、文字在右的图文项；它只改变单项内容，
  不改变整栏方向。双层级入口的菜单图标与文字仍固定使用 `Row`。
- 左右排列的图文项把 Badge 锚定到整组图文，文字在窄项宽或较大系统字体下
  限制为单行并省略，避免 RenderFlex 溢出；上下排列仍以图标锚定 Badge。
- 保留受控 `value/onChanged`，让禁用状态只由 `onChanged` 决定。
- 将 `TTabBarThemeData` 收敛到高度、颜色、间距、边线等视觉默认值；移除
  split、顶部边线开关、水波纹和动画策略。
- 按移动端画板重建三个分组、九个四项 TabBar 实例，并为可交互示例保留页面受控状态。

## API 变化

- breaking：删除 `TTabBarVariant` 与 `variant`。
- 新增：`TTabBarType type`、`TTabBarItemStyle itemStyle`、
  `TTabBarStyle style`、`TTabBarIconTextLayout iconTextLayout`。
- 删除本 PR 尚未发布且语义不成立的 `TTabBarLayout` 与 `layout` 草案 API；
  不产生额外迁移成本。未来若需要纵向 TabBar，应单独设计改变整栏轴向、尺寸、
  分隔线和选项分布的完整契约。
- breaking：`useVerticalDivider` 更名为 `split`。
- breaking：删除重复封装显隐和定位的 `TTabBarBadgeConfig`；
  `TTabBarItemConfig.badge` 直接接收可空 `TBadge`，`null` 表示不显示，偏移使用
  `TBadge.offset`。
- breaking：纯文本项在没有实例或 BadgeTheme offset 时改用 TabBar 标准徽标位置；
  已显式配置 offset 的调用不受影响。
- `TTabBarItemConfig` 支持 const；逐项 `onTap` 改为可选。
- breaking：Theme 移除行为/结构字段，由实例参数拥有。
- breaking：删除 `TTabBar` 构造参数及 `TTabBarThemeData` 字段
  `centerDistance`；保留原来的内置 0/4px 默认视觉，自定义间距不再支持。

## 风险与取舍

- 未显式设置 `Icon.size` 的图标项从 Flutter 隐式 24px 变为组件默认 20px，
  属于可见默认行为变化；需要保留旧尺寸时可传 `Icon(size: 24)`。
- 默认菜单宽度变化属于公开默认行为调整：窄标签项下菜单会变宽；显式设置
  `popUpWidth` 的调用不受影响。按仓库规范以 breaking change 记录。
- 当前包仍处于 alpha；选择一次性收敛冲突状态源，不保留会继续误导的新旧双 API。
- 小程序作为公开效果和操作参考；Flutter 保留 Widget、回调和受控状态惯例。
- 固定几何仅用于 TabBar 专有结构；颜色、字体、圆角与阴影优先使用 TDesign Token。
- 纯文本徽标位置属于 TabBar 专有组合几何，不修改 `TBadge` 的全局默认位置，避免
  影响 Tabs、SideBar、Avatar 等其他消费者。

## 验证策略

- 组件测试覆盖三条正交轴、固定图文结构、单次点击链路、受控切换、禁用、徽标、
  二级菜单与 Theme 优先级。
- Demo 测试覆盖页面分组、顺序、数量与关键参数。
- 真机先运行、热重启并操作；人工对照通过后再生成 Flutter 3.32 Linux 明暗 Golden，
  随后无更新参数复跑。
- Flutter 3.32.0 与 latest 执行 analyze、组件测试、Demo 测试和构建检查。
