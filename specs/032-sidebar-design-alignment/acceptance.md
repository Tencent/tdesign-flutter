# 验收记录

## 2026-09-08 移除数据项 key（本地验证）

- 删除 `TSideBarItem` 构造器未保存、未使用的 `key` 参数，保留 `TSideBar` 与内部渲染 Widget 的 Key。仓库调用点无传入该参数的情况，默认渲染和滚动机制未修改。
- 此项属于 breaking API 变更：已有调用方删除 `TSideBarItem(key: ...)` 中的 `key:`；`value` 仍用于选中项匹配，不替代 Flutter Widget Key。
- API 文档由源码重新生成：只移除 `TSideBarItem` 表格的 `key`，`TSideBar.key` 保留。
- Flutter 3.32.0 / 3.47.0 重新验证：组件测试各 75/75、Demo 各 8/8，组件包与 Example 严格 analyze 均无诊断；生产覆盖率 237/237 = 100%。3.32 Demo 首次遇到旧字体缓存缺失，备份旧 build 后重建测试资源，复跑通过。
- 本次仅删除无效参数，未修改视觉或 Golden；真机与远端验证状态仍见下文，不沿用旧结果宣称完成。

## 2026-09-08 选中颜色回退修复（本地验证）

- 范围：修复仅配置 `selectedTextStyle.fontSize` 时指示线颜色为空；按字段合并实例与组件 Theme，选中文字、图标和指示线遵循同一颜色优先级。无 API 签名变更；默认视觉不变。
- 新增 32 个矩阵用例，覆盖 8 组颜色配置 × M2/M3 × light/dark；修复前复现 24 个失败，修复后组件 75/75 通过。测试验证最终颜色、字号、字重及 3×14dp 指示线尺寸。
- Flutter 3.32.0 / 3.47.0：组件 75/75、Demo 8/8，组件包与 Example 严格 analyze 无诊断；SideBar 生产覆盖率 237/237 = 100%。回归调度清单自测 8/8。
- Flutter 3.32.0 Linux：共享导航 2 张、SideBar Demo 6 张严格 Golden 全部通过，未更新基线。首次复跑遇到构建缓存内图标字体资源缺失，隔离副本重新解析依赖后通过。
- 公开 API 注释已同步，并通过生成器更新 `side-bar_api.md`，没有手工修改生成文档。
- 重新查看 Figma `28591:34071`：默认选中指示线与选中文字为品牌色；本次只核对该修复范围，不代表整页视觉差异全部消除。
- 真机验证未完成：新增默认样式与仅改字号的 light/dark 并排截图场景，但 Android 安装返回 `INSTALL_FAILED_USER_RESTRICTED`，当前修改未能在设备上运行。旧截图不能作为本次修复证据，需用户允许安装后重跑。

以下为此前版本的历史验收记录，不代表本次修改已通过远端 CI、CodeBuddy 或真机验收。

## 环境

- 分支：`rss1102/breaking/sidebar-design-alignment`
- 合并基线：`origin/develop` (`3d5ed773`)
- Figma：页面 `24787:18812`，移动端画板 `28591:34071`
- 小程序：`Tencent/tdesign-miniprogram` develop `ae55fb05`

## 自动化验证

| 项目 | 结果 | 证据 |
| --- | --- | --- |
| 组件行为 | 43/43 通过 | 受控回写、禁用、loading、line/tag、语义和 Theme 优先级 |
| 生产覆盖率 | 通过 | SideBar 生产源码 LH/LF = 230/230 = 100% |
| Demo 行为 | 8/8 通过 | 10 项数据、Badge、锚点双向同步、末项、文本缩放与公开入口 |
| 严格 Golden | 8/8 通过 | Flutter 3.32 Linux：入口、锚点、tag 与共享导航矩阵各 light/dark；更新后无 `--update-goldens` 复跑 |
| 双 SDK | 通过 | Flutter 3.32.0 / 3.47.0 组件包与 Example analyze 均 0 error / 0 warning；功能测试通过 |
| 构建 | 通过 | 两个 SDK 的 Web release 与 Android debug 均成功 |
| 生成产物 | 通过 | API 与示例片段已生成，`generate_example_code.dart --check` 通过 |
| Android 16 | 通过 | uppercase `R`、手工可见操作、真机 integration 1/1、普通 APK 安装 `Success` 与冷启动 |

## 人工 Figma / 小程序对照

- [x] 读取新版 Figma 移动画板 `28591:34071`（375×667），核对 103dp 左栏、10 项、默认第二项、Badge 位置和右侧纵向图文行。
- [x] 读取小程序 develop 的 SideBar 组件与公开 Demo，保留受控切换、锚点同步和禁用项操作模式。
- [x] 明确记录重大跨端差异：小程序为 5 项 + 64dp 圆图三列宫格；新版 Figma 为约 10 项 + 48dp 圆角方图纵向列表。Flutter 公开详情按用户指定优先对齐新版 Figma。
- [x] 逐张检查 8 个最终 Golden；独立 CJK 子集无缺字方框，长页无裁切，light/dark 状态和结构一致，共享导航矩阵只变更 SideBar 区域。

## API / Theme Review

- `value/onChanged` 是唯一受控状态源；不复制小程序 `defaultValue` 或动态事件对象。
- `variant` 为非空实例结构状态（`line` / `tag`）；`width`、`height` 也是实例布局契约，Theme 不持有结构选择器或尺寸状态。
- `TSideBarThemeData` 只保留颜色、文字样式和内边距；优先级为实例视觉参数 > ThemeExtension > TDesign 语义 Token。
- disabled 同时落到不可点击行为与 `Semantics.enabled=false`；选中态写入逐项语义。
- 默认标签使用 Body Large Token；103dp 宽度、3×14 指示线和 9dp 圆角均有组件测试与 Golden 证据。
- Breaking 范围已记录：实例 `style` 重命名为 `variant`、枚举 `normal/outline` 改为 `line/tag`，移除 Theme `style/height`，新增 103dp `width`，默认宽度行为变化。

## 真机证据

- 设备：Xiaomi Android 16，ADB `40302eeb`。
- 最终源码通过 `flutter run` 安装并执行 uppercase `R`，返回 `Restarted application in 1,337ms`。
- 手工可见操作：从首页进入 SideBar；锚点页点击第四项并滚动内容；切页页点击禁用第五项后选中态不变，再点击第三项成功；进入带图标与 tag 页面；切换 light/dark。
- tag 页首帧图片尚未解码时右侧短暂空白，等待稳定后 8 个纵向图文行完整出现；Golden 已预缓存同一资产以消除非确定性。
- `flutter test integration_test/sidebar_example_test.dart -d 40302eeb` 最终代码 1/1 通过。
- integration 后重新构建普通 APK；首次安装被系统拒绝，改为检测到“USB安装提示”后精确确认，ADB 返回 `Success`；强停冷启动后检测到“`TDesign Flutter 组件库`”。
- 截图：`/private/tmp/sidebar-phone-anchor-default.png`、`/private/tmp/sidebar-phone-anchor-click.png`、`/private/tmp/sidebar-phone-anchor-dark.png`、`/private/tmp/sidebar-phone-icon.png`、`/private/tmp/sidebar-phone-tag-late.png`、`/private/tmp/sidebar-phone-tag-dark.png`。

## 待完成

- 独立 GitHub / CNB PR、Issue #1027 SideBar 条目关联及 CodeBuddy Review。
