# 验收记录

## 验证环境

- 分支：`rss1102/breaking/navbar-design-alignment`
- 基线：`origin/develop`（创建工作树时为 `f3e14c43`）
- Flutter/Dart：Flutter 3.32.0 / Dart 3.8.0；Flutter latest 3.47.0
- Figma：分支 `4SdclZkcv5bPgX6pa8AsmI`，NavBar 页面节点 `24386:5240`
- 小程序：`Tencent/tdesign-miniprogram` develop 分支 `packages/components/navbar/`

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| 组件行为与覆盖率 | 54/54 通过 | `TNavBar` / `TNavBarThemeData` 生产 LH/LF = 174/177 = 98.31% |
| Demo 行为 | 3/3 通过 | 安全区、Figma H5 组合、图片尺寸、搜索与操作反馈 |
| 严格 Golden | 6/6 通过 | Flutter 3.32 Linux：组件 2、Demo 2、共享导航 2；更新后无 `--update-goldens` 复跑 |
| 双 SDK `flutter analyze` | 通过 | 3.32.0 与 3.47.0 的组件包和 Example 均 0 error / 0 warning |
| 生成与构建 | 通过 | API 与示例片段生成检查、Web release、Android debug |
| Android 16 最终真机 | 通过 | 设备集成 1/1；最终代码 Hot Restart、可见操作、普通 APK 持久安装 |
| 公共 Demo 壳层隔离回归 | 2/2 通过 | ExamplePage 显式持有既有 Body Large / 500 标题视觉，Navbar 默认值变化不再污染其他组件 Golden |

## 人工验收

- [x] 新版 Figma H5/Flutter 与小程序两张 `375 × 1318` 画板已分别读取
- [x] 小程序 develop Demo、组件默认尺寸和 API 已读取
- [x] 最终 light/dark Golden 逐张核对；同时发现并修正深色安全区测试误用浅色 token
- [x] 最终 Android 16 真机交互与截图核对

## API / Theme Review

- `useDefaultBack`、`height`、`useBorderStyle` 的默认值或可空性变化均属于公开 breaking contract，已在 Spec 给出迁移说明；仓库内未发现 `height: null`、`useBorderStyle: null` 或 `TNavBarThemeData(useBorderStyle: ...)` 调用残留。
- `height` 是 `PreferredSizeWidget` 的实例结构契约，`useBorderStyle` 是实例结构选择器；两者不由 Theme 持有，避免双状态源。
- Theme 只保留可继承视觉值；有效值优先级保持“构造器 > TNavBarThemeData > Material AppBarTheme > TDesign 语义 Token”。
- 默认标题使用 Title Large 语义 Token（18/26/600），返回图标为 24；组件不复制小程序宿主胶囊、路由 delta、fixed 或 placeholder API。
- 本轮未新增 `variant`、`status` 或 `colorScheme`，也未用字符串模拟枚举；禁用交互仍由 `onTap: null` 表达。

## 真机证据

- 设备：Xiaomi Android 16 设备，ADB `40302eeb`。
- 最终 app/lib 代码通过 `flutter attach` 执行 uppercase `R`，返回 `Restarted application in 1,492ms`。
- CNB 首轮 Flutter 3.32 全量视觉回归暴露公共 ExamplePage 壳层隐式继承 Navbar 新默认标题样式，造成多个无关组件 Golden 漂移；修复后再次在最终源码上执行 uppercase `R`，返回 `Restarted application in 1,246ms`。
- 实际可见操作：从首页搜索进入 NavBar；点击“更多”；搜索框输入 `Navbar`；滚动检查居中/左对齐、普通/大标题与自定义品牌色；切换 light/dark。
- 壳层隔离修复后的可见复验：重新搜索进入 Navbar、滚动到“组件样式”、切换 dark/light，并点击“更多”操作；最终停留在亮色 Navbar 页面。
- 设备集成：`flutter test integration_test/navbar_example_test.dart -d 40302eeb`，1/1 通过，覆盖真实路由、操作反馈、搜索与主题切换。
- 集成测试结束后重新执行 `flutter build apk --debug`，通过手机“USB 安装提示”点击“继续安装”，ADB 返回 `Success`；`pm path` 可读，冷启动 `.MainActivity` 后首页正常可交互并保留在手机上。
- 截图：`/private/tmp/navbar-demo-final-dark-top.png`、`/private/tmp/navbar-demo-final-search.png`、`/private/tmp/navbar-demo-final-dark-styles.png`、`/private/tmp/navbar-demo-final-light-styles.png`、`/private/tmp/navbar-final-normal-apk-ready.png`。

## 未覆盖项与后续工作

- Figma 小程序画板包含微信宿主胶囊，H5/Flutter 画板不包含；Flutter 不伪造宿主控件。
- Figma 当前只给出浅色设计画板；深色是基于 TDesign 语义 Token 的平台主题扩展，必须独立 Golden 与真机验证。
- iOS 真机不在本轮设备范围内；系统栏不属于 Flutter Golden 边界。
