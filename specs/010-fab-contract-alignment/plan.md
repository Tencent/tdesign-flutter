# 实施方案

## 技术方案

- 将 `TFabDefaults` 的数字索引改为内部强类型默认值，由 `TFabResolve` 直接消费，
  避免“声明了默认值但运行时不使用”的双事实来源。
- 默认动作层继续复用 `TButton`，实例层显式传入 large/fill/primary；通过局部
  `TButtonThemeData` 只固定 circle/round shape 与 `spacer4`，不新增 Fab 按钮透传 API。
- 默认图标改为 `TIcons.add`。在 TButton 外使用 `ShapeDecoration` 绘制
  `context.tTheme.shadowsMiddle`；仅默认动作层拥有该投影，`child` 模式不附加。
- 拖拽边界统一先按物理边解析，再转换到 right/bottom 坐标：最小 right/bottom 使用
  `end`，最大 right/bottom 扣除 `start`。
- 使用 `AnimationController` 驱动磁吸 right 值，取代 `Future.delayed`；生命周期中处理
  stop、duration 更新和 dispose。
- 以拖拽起点到当前位置的净位移判断点击/拖拽；拖拽层始终获得 onPressed，但固定模式
  仅在 child 模式包 GestureDetector，避免默认 TButton 重复点击。
- Demo 删除与小程序当前页面无关的配色、尺寸矩阵，改成四个官方场景；自动收缩只在
  Demo 内监听滚动并组合自定义 child。
- 更新站点文档，移除迁移前已经不存在的 Theme/Shape/Size API 示例。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `fab/t_fab*.dart` | 默认视觉、拖拽边界、磁吸和点击契约 |
| 主题 | `TFabThemeData` dartdoc | 明确只控制定位/拖拽，动作层完整定制走 child |
| 示例 | `example/lib/page/t_fab_page.dart` | 对齐小程序四个 Demo 场景 |
| 文档 | Fab API、站点 README、Spec | 同步当前 Flutter API 与迁移说明 |
| 测试 | `test/components/fab/` | Widget、拖拽、主题与 Golden 回归 |

## API 变化

- 不新增、删除或重命名公共构造参数、枚举或 Theme 字段。
- 默认动作层尺寸和颜色改变，按 breaking change 记录。
- 修正 `TFabBounds` 运行时方向，使其与既有 dartdoc 一致。
- `TFabDragDetails.position` 仅补充精确定义，不改变当前 right/bottom 数值结构。

## 风险与取舍

- 固定动作层基线意味着父级 Button Theme 不再隐式改变 TFab 动作层；需要完整定制时
  使用 `child`，避免恢复跨组件 `buttonProps` 或产生部分继承、部分覆盖的不稳定状态。
- 投影会扩大绘制边界但不扩大布局和命中区域，需要 Golden 与几何测试分别锁定。
- 边界方向修正可能影响依赖旧错误行为的调用方，因此 PR 必须给出迁移说明。
- 磁吸动画不能留下延迟 Future；必须在新拖拽、Widget 更新和 dispose 时安全终止。

## 验证策略

- 单元/Widget：默认动作层配置、图标、投影、child 边界、Theme 隔离。
- 手势：非对称边界、轴向限制、轻微拖拽点击、磁吸动画和生命周期。
- Golden：纯图标与图文默认样式，浅色主题固定尺寸。
- 示例：生成代码同步检查、Example analyze、Web release build。
- 双版本：Flutter 3.32.0 与 latest 分别执行 analyze 和 Fab 测试。
- 人工：Web/手机尺寸截图与小程序 Fab 源码规格逐项复查。
