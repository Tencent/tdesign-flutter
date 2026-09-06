# Skeleton 设计对齐

## 背景

当前 Skeleton 已具备预设布局、自定义布局、延迟和两种动画，但默认行距、占位色、图片圆角以及公开 Demo 文案与移动端设计契约不一致；组件 Theme 的 nullable 数值插值还会把未配置值错误地当成 0。

## 目标

- 公开 Demo 展示头像、图片、文本、段落、单元格、宫格、图文组合与两种组件动效。
- 修正预设与组合骨架的尺寸、颜色、圆角和间距。
- 保持自定义布局、动画与延迟的单一公开入口，并修复 Theme 插值语义。
- 建立组件、Demo、动画、Golden 和双版本回归证据。

## 非目标

- 不机械复制小程序的 `loading`、slot、字符串 `theme` 或松散 `rowCol` 数据结构。
- 不为纯占位视觉增加业务内容状态、回调或 Controller。
- 不改变调用方显式提供的布局、颜色、圆角和间距。

## 行为契约

- `variant` 只选择四种内置结构；`TSkeleton.custom` / `layout` 是自定义结构的唯一入口。
- `animation` 为 null 时静态展示，`gradient` 与 `flashed` 分别使用扫光和闪烁动画；`delay` 只控制首次可见时间。
- 默认文本块高 16dp、头像 48dp、图片 72dp；图片与宫格图片使用 6dp 圆角。
- 默认多行间距为 8dp，文本首行内部间距为 16dp；默认占位色使用 secondary-container token。
- 块级显式样式优先于 `TSkeletonThemeData`，组件 Theme 优先于 TDesign token。
- 骨架图属于装饰性占位内容，不进入可访问语义树。

## API 收敛结论

| API | 所有权 | 结论 |
| --- | --- | --- |
| `variant` | 内置结构选择 | 保留 |
| `TSkeleton.custom` / `layout` | 强类型自定义布局 | 保留，避免与 variant 同时生效 |
| `animation` | 单一动效选择 | 保留 |
| `delay` | 防闪烁的生命周期参数 | 保留 |
| `loading` / child | 业务内容切换可由 Flutter 声明式条件组合表达 | 不新增 |
| callback / Controller | 无跨树命令或完成事件 | 不新增 |

## Breaking change

无。此次只修正默认视觉、Demo 和 Theme 插值错误，不改公开 API 签名。

## 验收标准

- [ ] Demo 分组、说明、顺序和实例符合移动端设计与公开示例。
- [ ] 组件测试覆盖预设、自定义布局、视觉优先级、Theme 插值、延迟和动画生命周期。
- [ ] Flutter 3.32.0 与 latest 的功能测试和严格 analyze 通过。
- [ ] Skeleton 生产源码覆盖率 LH/LF 不低于 95%。
- [ ] 固定 Linux Flutter 3.32.0 的 light/dark Golden 可复现。
- [ ] 最终运行 Web Demo，观察并比对渐变与闪烁动画状态。
