# 实施方案

## 技术方案

- 用 `TTabBarType`、`TTabBarItemStyle`、`TTabBarStyle`、`TTabBarLayout`
  替代混合语义的 `TTabBarVariant`。
- 组件内部从四个正交参数派生渲染；图文项按 `layout` 使用 `Row` 或 `Column`。
- 保留受控 `value/onChanged`，让禁用状态只由 `onChanged` 决定。
- 将 `TTabBarThemeData` 收敛到高度、颜色、间距、边线等视觉默认值；移除
  split、顶部边线开关、水波纹和动画策略。
- 按 Figma 重建三列 3/4/5 项 Demo，并为可交互示例保留本地受控状态。

## API 变化

- breaking：删除 `TTabBarVariant` 与 `variant`。
- 新增：`TTabBarType type`、`TTabBarItemStyle itemStyle`、
  `TTabBarStyle style`、`TTabBarLayout layout`。
- breaking：`useVerticalDivider` 更名为 `split`。
- `TTabBarBadgeConfig`、`TTabBarItemConfig` 支持 const；逐项 `onTap` 改为可选。
- breaking：Theme 移除行为/结构字段，由实例参数拥有。

## 风险与取舍

- 当前包仍处于 alpha；选择一次性收敛冲突状态源，不保留会继续误导的新旧双 API。
- 小程序作为公开效果和操作参考；Flutter 保留 Widget、回调和受控状态惯例。
- 固定几何仅用于 TabBar 专有结构；颜色、字体、圆角与阴影优先使用 TDesign Token。

## 验证策略

- 组件测试覆盖四条正交轴、受控切换、禁用、徽标、二级菜单与 Theme 优先级。
- Demo 测试覆盖页面分组、顺序、数量与关键参数。
- 真机先运行、热重启并操作；人工对照通过后再生成 Flutter 3.32 Linux 明暗 Golden，
  随后无更新参数复跑。
- Flutter 3.32.0 与 latest 执行 analyze、组件测试、Demo 测试和构建检查。
