# 验收记录

## 验证环境

- 分支：`rss1102/breaking/drawer-design-alignment`
- 基线：`origin/develop`（创建工作树时为 `f3e14c43`）
- Flutter/Dart：3.32.0 / 3.8.0；latest 3.47.0 / 3.13.0
- 新 Figma 分支：Drawer 移动端展示节点 `24386:5238`，375 × 1024，公开 Demo 为 7 个入口
- 小程序参考：develop 在线公开 Demo/API 与组件样式源码，Last Update 2026-08-24

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter analyze --no-pub`（组件 + Example） | 通过 | Flutter 3.32.0 和 3.47.0 均为 0 issues |
| `flutter test test/components/drawer/t_drawer_test.dart` | 通过 | 两个 SDK 均 43 项，覆盖视觉尺寸、Theme 优先级、蒙层、方向、Handle 和生命周期 |
| `flutter test test/drawer_demo_test.dart` | 通过 | 两个 SDK 均 5 项，覆盖 Figma 7 入口和真实打开/关闭 |
| 覆盖率门禁 | 通过 | Drawer 生产源码 `LH/LF = 199/200 = 99.50%` |
| 回归登记自测 | 通过 | 覆盖率/组件/Demo/Golden 调度器 13 项 |
| Linux Golden | 通过 | Flutter 3.32.0；375 × 1024 整页 2 张 + 7 打开态 light/dark 14 张；无更新参数 16/16 复跑通过 |
| `dart run tool/generate_example_code.dart --check` | 通过 | 5 个 Drawer 示例片段与源码同步 |
| API 文档生成 | 通过 | Drawer、Handle、Placement、ThemeData、Widget 和 Item 已纳入 manifest |
| `flutter build web --release` | 通过 | Flutter 3.32.0 Example Web release 构建 |

## API 与实现收敛审查

| API / 实现 | 所有权 | 结论 |
| --- | --- | --- |
| `placement` | 实例结构方向 | 保留，非空默认 right；Theme 不保存 |
| `showOverlay` / `closeOnOverlayClick` | 实例蒙层行为 | 保留并改为非空默认 |
| `onOverlayClick` | 蒙层交互通知 | 新增；与是否关闭解耦 |
| `destroyOnClose` | Popup 生命周期策略 | 新增并直接透传 |
| `enableFeedback` / `bordered` / `isShowLastBordered` | Widget 实例状态 | 非空默认；从 Theme 移除同义开关 |
| `width` | 面板具体宽度 | 实例可覆盖 Theme，默认 280 |
| `drawerTop` / `useSafeArea` | 实例布局与系统安全区 | 实例参数；Theme 不保存 |
| `onClose` / `onItemClick` | 生命周期与菜单交互通知 | 保留；分别表示展示周期结束和菜单项点击 |
| `title` / `footer` / `items` / `child` | Flutter Widget 组合内容 | 保留，不复制字符串 slot |
| `TDrawerHandle` | 命令式浮层生命周期 | 保留，代替小程序 visible 的机械映射 |

## 人工验收

- [x] 新 Figma 375 × 1024 Demo 的 7 个入口已逐项读取，大小标题、左右方向和底部插槽已放大人工检查
- [x] 小程序公开 Demo、API 和样式源码已核对
- [x] 官方网页内小程序预览已实际点击：基础抽屉从左打开、含 8 项；项点击仅通知而不自动关闭
- [x] Flutter Demo light/dark 整页和 7 个打开态已逐张检查；人工发现并修复了首轮字体子集中“二至八/插槽”缺字
- [x] Android 16 Xiaomi 真机（设备 `40302eeb`）已在代码更新后明确 Hot Restart，并可见逐项操作基础、图标、大小标题、左右方向与底部插槽

## 设计 Review 结论

| 项目 | Figma / 小程序证据 | Flutter 结论 |
| --- | --- | --- |
| 宽度 | 560rpx | 默认 280dp，实例 > Theme > 默认值 |
| 标题 | 上 24、横向 16、下 8；Title Large | 完全对齐，可由 `titlePadding/titleStyle` token 化覆盖 |
| 菜单项 | 16/0/16/16 内边距；Body Large | 16sp 正文，按压色使用 secondary-container token |
| 图标 | 24，与正文间距 8 | 默认 IconTheme 统一尺寸/颜色，保留自定义 Widget |
| 分隔线 | 左缩进 16，level-1 | 移除外框；`bordered` 真正控制项分隔线 |
| 方向/标题/图标/底部/遮罩 | 新 Figma Demo 为 7 入口；小程序 develop 仅 4 场景且全部左侧 | 公开 Demo 优先对齐 Figma 7 入口，打开后操作语义对齐小程序，差异已显式记录 |
| 生命周期 | 小程序 `visible` 受控，蒙层/项点击分开通知 | Flutter 保留命令式 `show/handle`，新增 `onOverlayClick` 和 `destroyOnClose`，不机械复制 `visible` |

## 未覆盖项与后续工作

- iOS 未实机验证；Android 真机、Widget/Demo 测试与固定 Linux Golden 已形成三层证据。
- latest 首轮测试曾因与 3.32 共用的 `ink_sparkle.frag` 缓存不兼容失败；在 3.47.0 clean + `pub get` 后组件 43 项 + Demo 5 项完整复跑通过，确认为 SDK 缓存边界而非源码回归。
