# 实施方案

## 本轮补充修复

- 内部文字 defaults 低于调用方主题，字段来源解析与 Steps 共享；无 defaults 的既有消费者保持原路径。
- PopupRoute 捕获调用子树主题，面板统一绘制背景；内部路由、状态、画笔与徽标适配类不再公开导出。
- 同步无动画与动画切换状态，中断动画从当前进度开始；Demo 受控状态由页面 State 持有。
- 逐个验证七个真实代码面板、核心片段编译及滚动后的菜单锚点，增加菜单展开明暗 Golden。
- 删除把 Figma 整栏方向误建模为图文排列的 `layout`；普通图文项恢复固定纵向内容结构。
- 水波纹与非水波纹路径各只保留一个点击识别器，并收敛回调文档与次数测试。
- 不为单个组件扩展公共 `ExamplePage` 导航标题 API；页面壳差异不进入组件契约。

## 技术方案

- 用 `TTabBarType`、`TTabBarItemStyle`、`TTabBarStyle` 替代混合语义的
  `TTabBarVariant`。
- 组件内部从三个正交参数派生渲染；普通图文项固定使用 `Column`，双层级入口
  的菜单图标与文字固定使用 `Row`。
- 保留受控 `value/onChanged`，让禁用状态只由 `onChanged` 决定。
- 将 `TTabBarThemeData` 收敛到高度、颜色、间距、边线等视觉默认值；移除
  split、顶部边线开关、水波纹和动画策略。
- 按移动端画板重建三个分组、九个四项 TabBar 实例，并为可交互示例保留页面受控状态。

## API 变化

- breaking：删除 `TTabBarVariant` 与 `variant`。
- 新增：`TTabBarType type`、`TTabBarItemStyle itemStyle`、
  `TTabBarStyle style`。
- 删除本 PR 尚未发布且语义不成立的 `TTabBarLayout` 与 `layout` 草案 API；
  不产生额外迁移成本。未来若需要纵向 TabBar，应单独设计改变整栏轴向、尺寸、
  分隔线和选项分布的完整契约。
- breaking：`useVerticalDivider` 更名为 `split`。
- breaking：删除重复封装显隐和定位的 `TTabBarBadgeConfig`；
  `TTabBarItemConfig.badge` 直接接收可空 `TBadge`，`null` 表示不显示，偏移使用
  `TBadge.offset`。
- `TTabBarItemConfig` 支持 const；逐项 `onTap` 改为可选。
- breaking：Theme 移除行为/结构字段，由实例参数拥有。

## 风险与取舍

- 当前包仍处于 alpha；选择一次性收敛冲突状态源，不保留会继续误导的新旧双 API。
- 小程序作为公开效果和操作参考；Flutter 保留 Widget、回调和受控状态惯例。
- 固定几何仅用于 TabBar 专有结构；颜色、字体、圆角与阴影优先使用 TDesign Token。

## 验证策略

- 组件测试覆盖三条正交轴、固定图文结构、单次点击链路、受控切换、禁用、徽标、
  二级菜单与 Theme 优先级。
- Demo 测试覆盖页面分组、顺序、数量与关键参数。
- 真机先运行、热重启并操作；人工对照通过后再生成 Flutter 3.32 Linux 明暗 Golden，
  随后无更新参数复跑。
- Flutter 3.32.0 与 latest 执行 analyze、组件测试、Demo 测试和构建检查。
