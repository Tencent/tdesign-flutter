# 验收记录

## 验证环境

- 分支：`rss1102/breaking/drawer-design-alignment`
- 基线：`origin/develop`（创建工作树时为 `f3e14c43`）
- Flutter/Dart：3.32.0 / 3.8.0；latest 3.47.0 / 3.13.0
- Figma：Drawer 页面节点 `27361:21695`，组件集合 32 变体
- 小程序参考：develop 在线公开 Demo/API 与组件样式源码，Last Update 2026-08-24

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter analyze --no-pub`（组件 + Example） | 通过 | Flutter 3.32.0 和 3.47.0 均为 0 issues |
| `flutter test test/components/drawer/t_drawer_test.dart` | 通过 | 两个 SDK 均 43 项，覆盖视觉尺寸、Theme 优先级、蒙层、方向、Handle 和生命周期 |
| `flutter test test/drawer_demo_test.dart` | 通过 | 两个 SDK 均 6 项，覆盖六个公开场景和真实打开/关闭 |
| 覆盖率门禁 | 通过 | Drawer 生产源码 `LH/LF = 199/200 = 99.50%` |
| 回归登记自测 | 通过 | 覆盖率/组件/Demo/Golden 调度器 13 项 |
| Linux Golden | 通过 | Flutter 3.32.0；Drawer 整页与基础/图标打开态 6 张，导航矩阵 2 张，Popup 消费者 1 张；无更新参数复跑通过 |
| `dart run tool/generate_example_code.dart --check` | 通过 | 六个 Drawer 片段可独立阅读 |
| API 文档生成 | 通过 | Drawer、Handle、Placement、ThemeData、Widget 和 Item 已纳入 manifest |
| `flutter build web --release` | 通过 | Flutter 3.32.0 Example Web release 构建 |

## API 与实现收敛审查

| API / 实现 | 所有权 | 结论 |
| --- | --- | --- |
| `placement` | 实例结构方向 | 保留，非空默认 right；Theme 不保存 |
| `showOverlay` / `closeOnOverlayClick` | 实例蒙层行为 | 保留并改为非空默认 |
| `onOverlayClick` | 蒙层交互通知 | 新增；与是否关闭解耦 |
| `destroyOnClose` | Popup 生命周期策略 | 新增并直接透传 |
| `hover` / `bordered` / `isShowLastBordered` | Widget 实例状态 | 非空默认；从 Theme 移除同义开关 |
| `width` | 面板具体宽度 | 实例可覆盖 Theme，默认 280 |
| `title` / `footer` / `items` / `child` | Flutter Widget 组合内容 | 保留，不复制字符串 slot |
| `TDrawerHandle` | 命令式浮层生命周期 | 保留，代替小程序 visible 的机械映射 |

## 人工验收

- [x] Figma 五维 32 变体属性已读取并检查总览
- [x] 小程序公开 Demo、API 和样式源码已核对
- [x] 官方网页内小程序预览已实际点击：基础抽屉从左打开、含 8 项；项点击仅通知而不自动关闭
- [x] Flutter Demo light/dark 整页和打开态已逐张检查，无中文缺字
- [ ] Android 真机待核对；本 PR 未将桌面/Web 交互等价冒充为真机证据

## 设计 Review 结论

| 项目 | Figma / 小程序证据 | Flutter 结论 |
| --- | --- | --- |
| 宽度 | 560rpx | 默认 280dp，实例 > Theme > 默认值 |
| 标题 | 上 24、横向 16、下 8；Title Large | 完全对齐，可由 `titlePadding/titleStyle` token 化覆盖 |
| 菜单项 | 16/0/16/16 内边距；Body Large | 16sp 正文，按压色使用 secondary-container token |
| 图标 | 24，与正文间距 8 | 默认 IconTheme 统一尺寸/颜色，保留自定义 Widget |
| 分隔线 | 左缩进 16，level-1 | 移除外框；`bordered` 真正控制项分隔线 |
| 方向/标题/图标/底部/遮罩 | Figma 5 个二值维度，共 32 变体 | 公开 Demo 以 2 个小程序主场景 + 4 个 Flutter 必要变体收敛，不复制 32 个组合 |
| 生命周期 | 小程序 `visible` 受控，蒙层/项点击分开通知 | Flutter 保留命令式 `show/handle`，新增 `onOverlayClick` 和 `destroyOnClose`，不机械复制 `visible` |

## 未覆盖项与后续工作

- 未进行 Android/iOS 真机验证；手势点击、蒙层和关闭语义已由 Widget/Demo 测试覆盖。
- latest 首轮测试曾因与 3.32 共用的 `ink_sparkle.frag` 缓存不兼容失败；在 clean + `pub get` 后 43 + 6 项复跑通过，确认为 SDK 缓存边界而非源码回归。
